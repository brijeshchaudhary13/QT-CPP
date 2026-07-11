Excellent. This is one of the most valuable chapters for becoming a **Senior Qt Developer**.

Most developers know how to write:

```cpp
QHash<QString, Patient> patients;
```

Very few understand:

* How `QHash` handles collisions
* What happens during **rehashing**
* How to write a **custom `qHash()`**
* Why a poor hash function can make your application much slower
* How Qt internally performs hash lookups

These topics are frequently asked in **Qt source code interviews**, **senior C++ interviews**, and are critical in **high-performance software** such as TPS, CAD, and GIS systems.

---

# Complete Qt Master Course (Qt 5.15 LTS → Qt 6.11)

# PART III — Qt Core

# Chapter 19 — QHash (Complete Deep Dive)

## Part 2 — Collision Resolution, Rehashing, Custom qHash(), Internals & Performance

> **Level:** Advanced → Expert

---

# Table of Contents

1. Hash Lookup Algorithm
2. Collision Handling
3. Rehashing
4. Custom `qHash()`
5. Iterator Rules
6. Implicit Sharing
7. Move Semantics
8. Thread Safety
9. `QHash` vs `QMap` vs `std::unordered_map`
10. Performance Optimization
11. Medical TPS Use Cases
12. Qt 5 vs Qt 6
13. Best Practices
14. Interview Questions
15. Revision Notes

---

# 1. Hash Lookup Algorithm

Suppose we have:

```cpp
QHash<QString, int> scores;
```

Insert:

```cpp
scores.insert("Alice", 95);
```

Internally (conceptually):

```text
"Alice"

↓

qHash("Alice")

↓

Hash Value

↓

Bucket Index

↓

Bucket

↓

Node
```

Lookup:

```cpp
scores.value("Alice");
```

Conceptually:

```text
Key

↓

Hash

↓

Bucket

↓

Compare Key

↓

Return Value
```

Only one bucket is searched instead of scanning every element.

---

# 2. Collision Handling

Collisions are unavoidable.

Example:

```text
Hash("ABC") = 10

Hash("XYZ") = 10
```

Both map to the same bucket.

---

Conceptually:

```text
Bucket 5

↓

ABC

↓

XYZ

↓

HELLO
```

Multiple elements share the bucket.

During lookup:

```text
Hash(Key)

↓

Bucket

↓

Compare Key

↓

Next

↓

Compare Key

↓

Found
```

---

# Why Good Hash Functions Matter

Good:

```text
Buckets

0 1 2 3 4 5 6 7

A B C D E F G H
```

Even distribution.

---

Poor:

```text
Bucket 0

↓

A

↓

B

↓

C

↓

D

↓

E

↓

F
```

Now lookup becomes slower because many keys must be compared.

---

# Average vs Worst Case

| Situation              | Complexity      |
| ---------------------- | --------------- |
| Good hash distribution | O(1) average    |
| Many collisions        | O(n) worst case |

The goal is to keep collisions rare.

---

# 3. Rehashing

Suppose the table starts with:

```text
8 Buckets
```

Insert many elements:

```text
8 Buckets

↓

90% Full
```

Qt expands the hash table.

Conceptually:

```text
Old Table

↓

Allocate Larger Table

↓

Recompute Bucket Positions

↓

Move Entries
```

This process is called **rehashing**.

---

# Example

Initially:

```text
8 Buckets
```

Later:

```text
16 Buckets
```

Then:

```text
32 Buckets
```

The exact growth policy is an implementation detail and may change between Qt versions.

---

# Why Rehash?

Without rehashing:

```text
Bucket

↓

Entry

↓

Entry

↓

Entry

↓

Entry
```

Collision chains become longer.

Rehashing shortens them.

---

# Reserve

If you know the approximate number of elements:

```cpp
QHash<QString, Beam> beams;

beams.reserve(10000);
```

Benefits:

* Fewer rehash operations
* Better insertion performance
* More predictable execution

---

# 4. Custom qHash()

One of the most common senior interview questions.

Suppose:

```cpp
class PatientID
{
public:
    QString hospital;

    int number;
};
```

Qt does **not** automatically know how to hash this type.

You provide:

```cpp
struct PatientID
{
    QString hospital;
    int number;

    bool operator==(const PatientID& other) const
    {
        return hospital == other.hospital &&
               number == other.number;
    }
};

size_t qHash(const PatientID& id, size_t seed = 0)
{
    return qHashMulti(seed,
                      id.hospital,
                      id.number);
}
```

In Qt 6, `qHashMulti()` is the recommended helper for combining multiple fields.

---

# Requirements

Custom key types should provide:

* Equality comparison (`operator==`)
* A compatible `qHash()` implementation

Equal objects **must** produce equal hash values.

---

# Bad Hash Function

```cpp
size_t qHash(const PatientID&, size_t)
{
    return 1;
}
```

Everything goes into one bucket.

Performance:

```text
O(n)
```

---

# Good Hash Function

Use all significant fields.

```text
Hospital

↓

Number

↓

Combined Hash

↓

Bucket
```

---

# 5. Iterator Rules

Example:

```cpp
for (auto it = hash.begin();
     it != hash.end();
     ++it)
{
}
```

Order is **unspecified**.

Never write code that depends on iteration order.

---

# Iterator Invalidation

Operations such as insertion that trigger a rehash can invalidate iterators because the internal bucket array changes.

Removal invalidates iterators to removed elements.

As a general rule:

* Do not continue using iterators after operations that may rehash.
* Reacquire iterators if the container has been structurally modified.

---

# 6. Implicit Sharing

Example:

```cpp
QHash<QString,int> a;

QHash<QString,int> b = a;
```

Initially:

```text
Reference Count = 2
```

No buckets copied.

---

Modify:

```cpp
b.insert("TPS",100);
```

Qt detaches.

```text
Shared

↓

Copy Table

↓

Modify Copy
```

---

# 7. Move Semantics

Returning:

```cpp
QHash<QString,int> createHash()
{
    QHash<QString,int> h;

    return h;
}
```

Modern compilers generally apply:

* Return Value Optimization (RVO)
* Move construction

---

Move:

```cpp
QHash<QString,int> b =
    std::move(a);
```

Ownership of the internal data transfers efficiently.

---

# 8. Thread Safety

A very common misconception.

## Read-Only Access

Multiple threads may safely read **the same immutable container**, provided no thread modifies it.

---

## Modification

Not safe:

```text
Thread A

↓

Insert

----------------

Thread B

↓

Remove
```

Without external synchronization, concurrent modification leads to data races.

Use:

* `QMutex`
* `QReadWriteLock`
* Higher-level synchronization strategies

depending on the access pattern.

---

# 9. QHash vs QMap vs std::unordered_map

| Feature            | QHash      | QMap           | std::unordered_map |
| ------------------ | ---------- | -------------- | ------------------ |
| Ordered            | ✘          | ✔              | ✘                  |
| Average Lookup     | O(1)       | O(log n)       | O(1)               |
| Internal Structure | Hash Table | Red-Black Tree | Hash Table         |
| Qt Integration     | Excellent  | Excellent      | Limited            |
| Custom Hash        | `qHash()`  | N/A            | `std::hash`        |

---

# Which One Should You Use?

### Fast lookup

```cpp
QHash
```

---

### Sorted reports

```cpp
QMap
```

---

### Pure Standard C++

```cpp
std::unordered_map
```

---

# 10. Performance Optimization

## Reserve

```cpp
hash.reserve(100000);
```

Reduces rehashing.

---

## Avoid Repeated Lookups

Instead of:

```cpp
if (hash.contains(key))
{
    value = hash.value(key);
}
```

Prefer:

```cpp
auto it = hash.find(key);

if (it != hash.end())
{
    value = it.value();
}
```

This performs only one lookup.

---

## Good Key Types

Excellent:

```cpp
QString
```

```cpp
int
```

```cpp
QUuid
```

---

Potentially expensive:

Large custom objects that require expensive hashing.

---

# 11. Medical TPS Use Cases

## Beam Cache

```cpp
QHash<QString, Beam>
```

Fast beam lookup.

---

## Image Cache

```cpp
QHash<QString, Image>
```

---

## Dose Engine Cache

```cpp
QHash<BeamID, DoseMatrix>
```

Custom key with `qHash()`.

---

## Plugin Registry

```cpp
QHash<QString, Plugin*>
```

---

## DICOM UID Cache

```cpp
QHash<QString, Study>
```

Average O(1) lookup.

---

# 12. Qt 5.15 vs Qt 6.11

| Feature             | Qt 5.15 | Qt 6.11                                      |
| ------------------- | ------- | -------------------------------------------- |
| Hash Table          | ✔       | ✔                                            |
| Implicit Sharing    | ✔       | ✔                                            |
| `qHash()`           | ✔       | ✔ (with modern helpers such as `qHashMulti`) |
| Average O(1) Lookup | ✔       | ✔                                            |
| API                 | Stable  | Stable                                       |

No major architectural change.

---

# 13. Best Practices

* Reserve capacity for large hashes.
* Use `find()` instead of `contains()` + `value()` when you need the value.
* Implement high-quality `qHash()` functions for custom keys.
* Never rely on iteration order.
* Use immutable keys whenever possible.
* Synchronize concurrent modifications externally.

---

# 14. Common Mistakes

* Poor custom hash functions.
* Forgetting `operator==` for custom keys.
* Depending on iteration order.
* Using `operator[]` for existence checks.
* Ignoring rehash costs.
* Modifying a shared `QHash` unexpectedly causing a detach.

---

# 15. Interview Questions

## Easy

1. What is a hash table?
2. What is a collision?
3. What does `reserve()` do?

---

## Medium

1. Explain rehashing.
2. Why is `QHash` faster than `QMap` on average?
3. What is `qHash()`?

---

## Hard

1. Design a custom key type for `QHash`.
2. Explain collision handling.
3. Compare `QHash` and `std::unordered_map`.

---

## Expert

1. Design a high-performance beam cache for a Treatment Planning System.
2. Explain how poor hash functions affect scalability.
3. Discuss thread-safety considerations for shared hash tables.

---

# 16. Revision Notes

* `QHash` uses a hash table with buckets.
* Good hash functions reduce collisions.
* Rehashing expands the table and redistributes entries.
* Custom key types require both `operator==` and `qHash()`.
* Iteration order is unspecified.
* `reserve()` reduces costly rehash operations.
* `find()` is often more efficient than `contains()` followed by `value()`.

---

# 🏥 Production Recommendations

| Scenario           | Recommended Container     |
| ------------------ | ------------------------- |
| DICOM UID cache    | `QHash<QString, Study>`   |
| TPS Beam cache     | `QHash<BeamID, Beam>`     |
| Plugin registry    | `QHash<QString, Plugin*>` |
| Loaded image cache | `QHash<QString, Image>`   |
| Session management | `QHash<QUuid, Session>`   |

---


# Next Chapter

## **Chapter 20 — QSet (Complete Deep Dive)**

