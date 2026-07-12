# Chapter 20 — QSet (Complete Deep Dive)

---

# 1. What is QSet?

## Definition

`QSet<T>` is an **unordered container of unique values**.

Header:

```cpp
#include <QSet>
```

Module:

```text
QtCore
```

Example:

```cpp
QSet<QString> patients;
```

Unlike:

```cpp
QList<QString>
```

which allows:

```text
Patient1

Patient1

Patient2
```

`QSet` automatically prevents duplicates.

---

# Concept

```text
QSet

↓

Unique Elements Only
```

Example:

```cpp
patients.insert("Alice");
patients.insert("Bob");
patients.insert("Alice");
```

Result:

```text
Alice

Bob
```

Only one `"Alice"` exists.

---

# 2. Why Qt Created QSet

Many applications require uniqueness.

Examples:

Medical TPS

```text
Unique Beam IDs
```

---

DICOM

```text
Unique SOP Instance UIDs
```

---

GIS

```text
Visited Nodes
```

---

Compiler

```text
Imported Modules
```

---

Permission System

```text
Unique Roles
```

Instead of manually checking:

```cpp
if (!list.contains(value))
{
    list.append(value);
}
```

use:

```cpp
set.insert(value);
```

---

# 3. Internal Architecture

`QSet` is built on top of `QHash`.

Conceptually:

```text
QSet

↓

QHash

↓

Hash Table

↓

Buckets

↓

Nodes
```

Each element is stored as a hash key.

No separate value is stored because the key itself is the stored object.

---

# Internal Relationship

Conceptually:

```text
QSet<QString>

↓

QHash<QString, Dummy>
```

The implementation detail is hidden from the user, but conceptually `QSet` uses a hash-based structure.

---

# 4. Mathematical Set Concepts

A mathematical set contains:

* Unique elements
* No ordering
* Fast membership testing

Example:

```text
A

↓

1

2

3
```

Another:

```text
B

↓

3

4

5
```

---

Union

```text
1

2

3

4

5
```

---

Intersection

```text
3
```

---

Difference

```text
1

2
```

---

These operations are directly supported by `QSet`.

---

# 5. Memory Layout

Conceptually:

```text
QSet

↓

Hash Table

↓

Bucket Array

↓

Node

↓

Node

↓

Node
```

Like `QHash`, elements are **not stored contiguously**.

---

Node

Conceptually:

```text
+----------------------+

Stored Value

Next Pointer

+----------------------+
```

---

# 6. Creating QSet

Default

```cpp
QSet<int> numbers;
```

---

Insert

```cpp
numbers.insert(10);
numbers.insert(20);
numbers.insert(30);
```

---

Duplicate

```cpp
numbers.insert(20);
```

Ignored.

---

Initializer List

```cpp
QSet<int> values =
{
    1,
    2,
    3
};
```

---

# 7. Common APIs

## insert()

```cpp
set.insert("TPS");
```

---

## remove()

```cpp
set.remove("TPS");
```

---

## contains()

```cpp
set.contains("TPS");
```

Returns:

```text
true

or

false
```

---

## size()

```cpp
set.size();
```

---

## isEmpty()

```cpp
set.isEmpty();
```

---

## clear()

```cpp
set.clear();
```

---

## values()

```cpp
QList<QString> list =
    set.values();
```

Returns a `QList`.

The order is unspecified.

---

# 8. Set Operations

## Union

```cpp
QSet<int> c = a.united(b);
```

Example:

```text
A

1

2

3

B

3

4

5

↓

Result

1

2

3

4

5
```

---

## Intersection

```cpp
QSet<int> c =
    a.intersect(b);
```

> **Note:** `intersect()` modifies the existing set and returns a reference to it. If you want a new set without modifying the originals, use `intersects()` only to test for overlap, or make a copy before calling `intersect()`.

Conceptually:

```text
3
```

---

## Difference (Subtract)

```cpp
QSet<int> c =
    a.subtract(b);
```

> **Note:** Like `intersect()`, `subtract()` modifies the set. To preserve the original, operate on a copy.

Result:

```text
1

2
```

---

## intersects()

```cpp
if (a.intersects(b))
{
}
```

Returns:

```text
true

or

false
```

---

# 9. Iteration

```cpp
for (const auto &value : set)
{
    qDebug() << value;
}
```

Output order:

```text
Apple

Orange

Banana
```

or

```text
Banana

Apple

Orange
```

Order is **unspecified**.

Never rely on iteration order.

---

# 10. Performance

Average Complexity

| Operation | Complexity |
| --------- | ---------- |
| Insert    | O(1)       |
| Remove    | O(1)       |
| Contains  | O(1)       |
| Traverse  | O(n)       |

Worst-case complexity may degrade with excessive hash collisions.

---

# Why Faster Than QList?

Searching a list:

```text
Item

↓

Item

↓

Item

↓

Found
```

Linear search.

Searching a set:

```text
Hash

↓

Bucket

↓

Found
```

Average constant-time lookup.

---

# 11. Qt 5.15 vs Qt 6.11

| Feature             | Qt 5.15 | Qt 6.11 |
| ------------------- | ------- | ------- |
| Hash Based          | ✔       | ✔       |
| Unique Elements     | ✔       | ✔       |
| API                 | Stable  | Stable  |
| Average O(1) Lookup | ✔       | ✔       |

There is **no significant conceptual difference** between Qt 5.15 and Qt 6.11 for `QSet`.

---

# 12. Best Practices

* Use `QSet` whenever uniqueness is required.
* Do not use `QList` just to simulate a set.
* Reserve capacity if you expect many insertions.
* Do not rely on iteration order.
* Use `contains()` for membership tests rather than manually searching a list.

---

# 13. Common Mistakes

* Expecting sorted elements.
* Expecting insertion order.
* Using `QList` for uniqueness checks.
* Ignoring hash collisions when designing custom key types.
* Assuming duplicate insertions increase the container size.

---

# 14. Interview Questions

## Easy

1. What is `QSet`?
2. Does `QSet` allow duplicates?
3. Is `QSet` ordered?

---

## Medium

1. Why is `QSet` built on `QHash`?
2. Compare `QSet` and `QList`.
3. Explain `contains()` complexity.

---

## Hard

1. Explain how `QSet` stores elements internally.
2. Compare `QSet` and `std::unordered_set`.
3. Describe union and intersection operations.

---

## Expert

1. Design a DICOM UID registry using `QSet`.
2. Explain why `QSet` is appropriate for graph traversal.
3. Compare `QSet`, `QHash`, and `QMap` for permission management.

---

# 15. Revision Notes

* `QSet` stores unique elements.
* It is implemented using a hash-based structure.
* Average lookup is O(1).
* Iteration order is unspecified.
* Duplicate insertions are ignored.
* Set operations such as union and intersection are supported.

---

# 🏥 Production Examples

| Use Case                | Recommended     |
| ----------------------- | --------------- |
| Unique Patient IDs      | `QSet<QString>` |
| DICOM SOP Instance UIDs | `QSet<QString>` |
| Visited Graph Nodes     | `QSet<NodeId>`  |
| Active User Roles       | `QSet<QString>` |
| Loaded Plugin Names     | `QSet<QString>` |

---
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
[⬅️ QHash](/QQHash.md)      |          [QPair ➡️](/QQPair.md)
---
## **License**
This project is licensed under the MIT License.

---

Happy Coding!
