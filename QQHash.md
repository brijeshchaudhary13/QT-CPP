If `QMap` is optimized for **ordered storage**, then **`QHash` is optimized for speed**.

In large enterprise systems (TPS, CAD, ERP, Automotive, GIS), developers often choose **`QHash`** because lookups are typically much faster on average than tree-based maps.

> **Senior Qt Architect Insight**
>
> If you don't need keys in sorted order, `QHash` is usually the better choice.

---

# Chapter 19 — QHash (Complete Deep Dive)

---

# 1. What is QHash?

## Definition

`QHash<Key, T>` is an **unordered associative container**.

Header:

```cpp
#include <QHash>
```

Module:

```text
QtCore
```

Example:

```cpp
QHash<QString, int> scores;
```

Unlike:

```cpp
QMap<QString, int>
```

`QHash` **does not keep keys sorted**.

---

# Concept

```text
QHash

↓

Hash Function

↓

Bucket

↓

Value
```

Instead of storing elements in tree order, `QHash` places them into buckets based on a hash value.

---

# Example

```cpp
scores.insert("Alice", 95);
scores.insert("Bob", 87);
scores.insert("Charlie", 91);
```

Internally (conceptually):

```text
Hash("Alice")   → Bucket 5

Hash("Bob")     → Bucket 2

Hash("Charlie") → Bucket 8
```

The iteration order is **not guaranteed** and may differ between runs or Qt versions.

---

# 2. Why Qt Created QHash

Searching a tree:

```text
Root

↓

Left

↓

Right

↓

Found
```

Requires approximately:

```text
O(log n)
```

Searching a hash table:

```text
Hash(Key)

↓

Bucket

↓

Found
```

Average complexity:

```text
O(1)
```

This makes `QHash` ideal for frequent lookups.

---

# Real Project Usage

Medical TPS

```text
Beam ID

↓

Beam Object
```

---

ERP

```text
Employee ID

↓

Employee
```

---

GIS

```text
Layer Name

↓

Layer Object
```

---

Automotive

```text
CAN Signal Name

↓

Signal
```

---

# 3. Hash Table Concepts

Conceptually:

```text
Key

↓

Hash Function

↓

Integer Hash Value

↓

Bucket

↓

Stored Object
```

The hash value determines where the element is stored.

---

# Example

Suppose:

```text
Buckets

0

1

2

3

4

5

6

7
```

Insert:

```text
Alice
```

Hash:

```text
Hash("Alice") = 21
```

Bucket:

```text
21 % 8 = 5
```

Stored in:

```text
Bucket 5
```

---

# 4. Buckets

A hash table consists of multiple buckets.

Conceptually:

```text
Bucket 0

Bucket 1

Bucket 2

Bucket 3

Bucket 4

Bucket 5

Bucket 6

Bucket 7
```

Each bucket may contain:

* Zero elements
* One element
* Multiple elements (collision)

---

# 5. Hash Functions

The hash function converts a key into an integer.

Conceptually:

```text
Patient001

↓

Hash

↓

98456231
```

Qt provides `qHash()` overloads for many built-in Qt and C++ types.

For user-defined key types, you typically provide your own `qHash()` overload.

---

# Example

```cpp
QString key = "Heart";
```

Conceptually:

```text
"Heart"

↓

Hash

↓

123456789
```

↓

Bucket selection

---

# Good Hash Function

A good hash function should:

* Be deterministic.
* Distribute keys uniformly.
* Be fast to compute.
* Minimize collisions.

---

# 6. Memory Layout

Conceptually:

```text
QHash

↓

Bucket Array

↓

Bucket 0

↓

Node

↓

Bucket 1

↓

Node

↓

Bucket 2

↓

Empty

↓

Bucket 3

↓

Node
```

Unlike `QVector`, elements are not stored contiguously.

Unlike `QMap`, there is no tree structure.

---

# Node Layout (Conceptual)

```text
+----------------------------+

Key

Value

Next Pointer

+----------------------------+
```

Each bucket can contain a chain of nodes if collisions occur.

---

# 7. Creating QHash

Default

```cpp
QHash<QString, int> scores;
```

---

Insert

```cpp
scores.insert("Alice", 90);
scores.insert("Bob", 80);
```

---

Using `operator[]`

```cpp
scores["Charlie"] = 95;
```

---

Result

```text
Alice

Bob

Charlie
```

Stored in bucket order, **not sorted order**.

---

# 8. Common APIs

## insert()

```cpp
scores.insert("TPS", 100);
```

---

## value()

```cpp
scores.value("TPS");
```

Returns the associated value or a default value if the key is absent.

---

## contains()

```cpp
scores.contains("TPS");
```

---

## remove()

```cpp
scores.remove("TPS");
```

---

## clear()

```cpp
scores.clear();
```

---

## size()

```cpp
scores.size();
```

---

## isEmpty()

```cpp
scores.isEmpty();
```

---

## keys()

```cpp
scores.keys();
```

Returns a `QList` containing the keys.

The order is unspecified.

---

## values()

```cpp
scores.values();
```

Returns a `QList` containing the values.

Again, the order is unspecified.

---

# 9. Accessing Elements

Using `operator[]`

```cpp
scores["Alice"];
```

⚠️ If the key is missing, a new element is inserted with a default-constructed value.

---

Read-only

```cpp
scores.value("Alice");
```

No insertion occurs.

---

# 10. Iteration

```cpp
for (auto it = scores.cbegin();
     it != scores.cend();
     ++it)
{
    qDebug()
        << it.key()
        << it.value();
}
```

Output order:

```text
Bob

Alice

Charlie
```

or

```text
Charlie

Bob

Alice
```

The order is unspecified.

Never rely on iteration order.

---

# 11. Performance

Average Complexity

| Operation | Complexity |
| --------- | ---------- |
| Insert    | O(1)       |
| Find      | O(1)       |
| Remove    | O(1)       |
| Traverse  | O(n)       |

Worst-case complexity can degrade if many keys collide into the same buckets, but a good hash function minimizes this risk.

---

# Why Faster Than QMap?

`QMap`

```text
Tree

↓

O(log n)
```

`QHash`

```text
Hash

↓

Bucket

↓

O(1) average
```

---

# 12. Qt 5.15 vs Qt 6.11

| Feature             | Qt 5.15 | Qt 6.11 |
| ------------------- | ------- | ------- |
| Hash Table          | ✔       | ✔       |
| Buckets             | ✔       | ✔       |
| API                 | Stable  | Stable  |
| Average O(1) Lookup | ✔       | ✔       |

There is **no major conceptual difference** between Qt 5.15 and Qt 6.11 for `QHash`.

---

# 13. Best Practices

* Use `QHash` when key ordering is not required.
* Prefer `value()` for read-only access.
* Avoid relying on iteration order.
* Ensure custom key types have a high-quality `qHash()` implementation.
* Reserve bucket capacity for large datasets when the approximate size is known.

---

# 14. Common Mistakes

* Expecting sorted keys.
* Assuming iteration order is stable.
* Using `operator[]` for existence checks.
* Writing poor hash functions for custom types.
* Choosing `QHash` when ordered traversal is required.

---

# 15. Interview Questions

## Easy

1. What is `QHash`?
2. How is it different from `QMap`?
3. What is a hash table?

---

## Medium

1. Explain buckets.
2. What is a collision?
3. Why is lookup O(1) on average?

---

## Hard

1. Describe the conceptual memory layout of `QHash`.
2. Compare `QHash` and `std::unordered_map`.
3. Explain how a hash function affects performance.

---

## Expert

1. Design a cache for DICOM images using `QHash`.
2. Explain why collisions degrade performance.
3. Compare `QHash`, `QMap`, and `std::unordered_map` for a Treatment Planning System.

---

# 16. Revision Notes

* `QHash` is an unordered associative container.
* It stores key-value pairs using a hash table.
* Lookups are O(1) on average.
* Keys are **not** sorted.
* Iteration order is unspecified.
* `operator[]` inserts missing keys.
* Use `QHash` when lookup speed matters more than ordering.

---

# 🏥 Production Examples

| Use Case              | Recommended                |
| --------------------- | -------------------------- |
| Beam ID → Beam Object | `QHash<QString, Beam>`     |
| DICOM Image Cache     | `QHash<QString, Image>`    |
| Patient Session Cache | `QHash<QString, Session>`  |
| Loaded Plugins        | `QHash<QString, Plugin*>`  |
| GUI Widget Lookup     | `QHash<QString, QWidget*>` |


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
[⬅️ QVector](/QQVector.md)      |          [QSet ➡️](/QQSet.md)
---
## **License**
This project is licensed under the MIT License.

---

Happy Coding!
