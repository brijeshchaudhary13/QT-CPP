Excellent. This chapter moves from **using `QSet`** to **understanding how it works internally**.

Most developers know only:

```cpp
QSet<QString> names;
```

Senior developers understand:

* How `QSet` is implemented internally
* Why insertion is **O(1)** on average
* What causes performance degradation
* How rehashing works
* How to use custom classes as keys
* How to optimize `QSet` for millions of objects

These topics frequently appear in **Qt source code interviews**, **medical software**, **CAD**, **GIS**, and **embedded systems**.

---

# Complete Qt Master Course (Qt 5.15 LTS → Qt 6.11)

# PART III — Qt Core

# Chapter 20 — QSet (Complete Deep Dive)

## Part 2 — Internals, Custom Types, Rehashing & Performance

> **Level:** Advanced → Expert

---

# Table of Contents

1. Internal Implementation
2. Rehashing
3. Custom Types
4. Custom qHash()
5. Iterator Rules
6. Implicit Sharing
7. Move Semantics
8. Thread Safety
9. QSet vs std::unordered_set
10. Performance Optimization
11. Medical TPS Usage
12. Qt 5 vs Qt 6
13. Best Practices
14. Interview Questions
15. Revision Notes

---

# 1. Internal Implementation

Unlike:

```cpp
QVector<int>
```

which stores:

```text
10
20
30
40
```

contiguously,

`QSet` stores data inside a hash table.

Conceptually:

```text
QSet

↓

Hash Table

↓

Bucket Array

↓

Bucket

↓

Node

↓

Node
```

Internally, `QSet` is implemented on top of `QHash`.

---

# Memory Layout

Conceptually:

```text
Bucket 0

↓

Node

------------

Bucket 1

↓

Empty

------------

Bucket 2

↓

Node

↓

Node
```

Each node stores:

```text
Stored Value

↓

Next Pointer
```

This is why iteration order is unspecified.

---

# 2. Rehashing

Suppose:

```cpp
QSet<int> set;
```

Initially:

```text
8 Buckets
```

Insert:

```cpp
for(int i=0;i<1000;i++)
{
    set.insert(i);
}
```

Eventually:

```text
8 Buckets

↓

16 Buckets

↓

32 Buckets

↓

64 Buckets
```

Qt reallocates the bucket table and redistributes elements.

---

## Why Rehash?

Without rehashing:

```text
Bucket 5

↓

1

↓

9

↓

17

↓

25

↓

33
```

Long collision chains reduce lookup performance.

Rehashing spreads entries across more buckets.

---

## Reserve

For large datasets:

```cpp
QSet<QString> uids;

uids.reserve(50000);
```

Benefits:

* Fewer rehashes
* Better insertion speed
* More predictable performance

---

# 3. Using Custom Types

Suppose you have:

```cpp
struct BeamID
{
    QString machine;

    int beamNumber;
};
```

You cannot immediately do:

```cpp
QSet<BeamID> beams;
```

Qt needs to know:

* When two `BeamID` objects are equal.
* How to compute their hash.

---

# 4. Implementing operator==

```cpp
struct BeamID
{
    QString machine;
    int beamNumber;

    bool operator==(const BeamID& other) const
    {
        return machine == other.machine &&
               beamNumber == other.beamNumber;
    }
};
```

This defines logical equality.

---

# Implementing qHash()

Modern Qt 6 style:

```cpp
size_t qHash(const BeamID& id,
             size_t seed = 0)
{
    return qHashMulti(seed,
                      id.machine,
                      id.beamNumber);
}
```

Qt can now store:

```cpp
QSet<BeamID> beams;
```

---

# Poor Hash Function

```cpp
size_t qHash(const BeamID&, size_t)
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

Use all important fields.

```text
Machine

↓

Beam Number

↓

Combined Hash

↓

Bucket
```

---

# 5. Iterator Rules

Example:

```cpp
for(auto it = set.begin();
    it != set.end();
    ++it)
{
}
```

The order is unspecified.

Never write code such as:

```cpp
if(*set.begin() == expected)
```

because the "first" element is not defined.

---

# Iterator Invalidation

Operations that trigger a rehash may invalidate iterators.

Example:

```cpp
auto it = set.begin();

set.insert(newValue);
```

If insertion causes rehashing:

```text
Old Buckets

↓

New Buckets
```

The iterator may become invalid.

Reacquire iterators after structural modifications.

---

# 6. Implicit Sharing

Like many Qt containers:

```cpp
QSet<int> a;

QSet<int> b = a;
```

Initially:

```text
Reference Count = 2
```

No buckets copied.

---

Modify:

```cpp
b.insert(100);
```

Qt detaches.

```text
Shared Data

↓

Copy Table

↓

Modify Copy
```

---

# 7. Move Semantics

Returning:

```cpp
QSet<QString> createSet()
{
    QSet<QString> names;

    return names;
}
```

Modern compilers typically apply:

* RVO
* Move construction

---

Move:

```cpp
QSet<QString> b =
    std::move(a);
```

Ownership transfers efficiently.

---

# 8. Thread Safety

Read-only access:

```text
Thread A

↓

contains()

----------------

Thread B

↓

contains()
```

Safe if no thread modifies the set.

---

Modification:

```text
Thread A

↓

insert()

----------------

Thread B

↓

remove()
```

Not safe without synchronization.

Use:

* `QMutex`
* `QReadWriteLock`

depending on the access pattern.

---

# 9. QSet vs std::unordered_set

| Feature          | QSet      | std::unordered_set |
| ---------------- | --------- | ------------------ |
| Qt Integration   | Excellent | Limited            |
| Uses qHash()     | ✔         | ✘                  |
| Uses std::hash   | ✘         | ✔                  |
| Implicit Sharing | ✔         | ✘                  |
| Average Lookup   | O(1)      | O(1)               |

---

# Which One Should You Use?

## Qt Project

```cpp
QSet
```

---

## Pure STL Library

```cpp
std::unordered_set
```

---

## Mixed Qt + STL

Choose based on the surrounding API to minimize conversions.

---

# 10. Performance Optimization

## Reserve

```cpp
set.reserve(100000);
```

---

## Good Keys

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

Avoid:

Large custom classes with expensive hash calculations unless necessary.

---

## Membership Test

Good:

```cpp
if(set.contains(uid))
{
}
```

Avoid manually searching through a list:

```cpp
for(...)
{
}
```

---

# 11. Medical TPS Use Cases

## Unique SOP Instance UIDs

```cpp
QSet<QString>
```

---

## Loaded Images

```cpp
QSet<ImageID>
```

---

## Imported Structures

```cpp
QSet<QString>
```

---

## Beam Identifiers

```cpp
QSet<BeamID>
```

---

## Visited Voxels (Algorithm Dependent)

```cpp
QSet<VoxelID>
```

Useful in graph-based or traversal algorithms where uniqueness matters.

---

# 12. Qt 5.15 vs Qt 6.11

| Feature             | Qt 5.15 | Qt 6.11 |
| ------------------- | ------- | ------- |
| Built on Hash Table | ✔       | ✔       |
| Uses qHash()        | ✔       | ✔       |
| Implicit Sharing    | ✔       | ✔       |
| API                 | Stable  | Stable  |

There is **no major behavioral difference** between Qt 5.15 and Qt 6.11 for `QSet`.

---

# 13. Best Practices

* Reserve capacity when handling large datasets.
* Implement both `operator==` and `qHash()` for custom types.
* Never depend on iteration order.
* Use `contains()` for membership checks.
* Synchronize concurrent modifications externally.
* Keep hash functions fast and well-distributed.

---

# 14. Common Mistakes

* Forgetting to implement `operator==` for custom keys.
* Writing poor `qHash()` implementations.
* Expecting insertion order.
* Ignoring iterator invalidation after rehashing.
* Using `QList` instead of `QSet` for uniqueness.

---

# 15. Interview Questions

## Easy

1. What is `QSet`?
2. Does `QSet` allow duplicates?
3. Why is lookup fast?

---

## Medium

1. Explain rehashing.
2. How do you store custom classes?
3. Why is iteration order undefined?

---

## Hard

1. Explain the internal implementation of `QSet`.
2. Compare `QSet` and `std::unordered_set`.
3. Discuss collision handling and its impact on performance.

---

## Expert

1. Design a unique DICOM UID registry for a TPS.
2. Explain how `QSet` scales to millions of entries.
3. Compare `QSet`, `QHash`, and `QMap` for a permission system.

---

# 16. Revision Notes

* `QSet` is implemented using a hash-based structure.
* Lookup is O(1) on average.
* Rehashing redistributes elements into more buckets.
* Custom types require `operator==` and `qHash()`.
* Iteration order is unspecified.
* Reserve capacity for better performance.
* Implicit sharing minimizes copy cost until modification.

---

# 🏥 Production Recommendations

| Scenario                      | Recommended Container |
| ----------------------------- | --------------------- |
| Unique DICOM SOP UIDs         | `QSet<QString>`       |
| Imported RT Structure Names   | `QSet<QString>`       |
| Beam Identifier Registry      | `QSet<BeamID>`        |
| Loaded Plugin IDs             | `QSet<QString>`       |
| Visited Nodes in Graph Search | `QSet<NodeId>`        |

---

# Next Chapter

## **Chapter 21 — QPair (Complete Deep Dive)**

