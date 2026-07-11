Excellent. We are now moving to another important Qt container.

`QSet` is one of the simplest containers conceptually, but it is **extremely useful in production applications**.

Many developers try to use:

```cpp
QList<QString>
```

or

```cpp
QVector<QString>
```

to store unique values.

This leads to:

* Duplicate checking
* Manual searching
* Poor performance

`QSet` solves this problem.

---

# Complete Qt Master Course (Qt 5.15 LTS → Qt 6.11)

# PART III — Qt Core

# Chapter 20 — QSet (Complete Deep Dive)

## Part 1 — Fundamentals, Internal Architecture, Set Theory & APIs

> **Level:** Beginner → Advanced

---

# Chapter Objectives

After completing this chapter, you will understand:

* What `QSet` is
* Internal implementation
* Relationship with `QHash`
* Set theory
* Membership testing
* Common APIs
* Performance
* Qt 5.15 vs Qt 6.11

---

# Table of Contents

1. What is QSet?
2. Why Qt Created QSet
3. Internal Architecture
4. Mathematical Set Concepts
5. Memory Layout
6. Creating QSet
7. Common APIs
8. Iteration
9. Performance
10. Qt 5 vs Qt 6
11. Best Practices
12. Interview Questions
13. Revision Notes

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

# Next Section

## **Chapter 20 — Part 2**

