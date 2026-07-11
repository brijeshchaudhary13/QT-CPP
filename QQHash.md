Excellent. This is one of the **most important containers** in Qt and is heavily used in **production applications**.

If `QMap` is optimized for **ordered storage**, then **`QHash` is optimized for speed**.

In large enterprise systems (TPS, CAD, ERP, Automotive, GIS), developers often choose **`QHash`** because lookups are typically much faster on average than tree-based maps.

> **Senior Qt Architect Insight**
>
> If you don't need keys in sorted order, `QHash` is usually the better choice.

---

# Complete Qt Master Course (Qt 5.15 LTS → Qt 6.11)

# PART III — Qt Core

# Chapter 19 — QHash (Complete Deep Dive)

## Part 1 — Fundamentals, Hash Table Architecture, Memory Layout & APIs

> **Level:** Beginner → Advanced

---

# Chapter Objectives

After completing this chapter, you will understand:

* What `QHash` is
* Why Qt created it
* Hash table architecture
* Buckets
* Hash functions
* Collision handling
* Memory layout
* Common APIs
* Performance
* Qt 5.15 vs Qt 6.11

---

# Table of Contents

1. What is QHash?
2. Why Qt Created QHash
3. Hash Table Concepts
4. Buckets
5. Hash Functions
6. Memory Layout
7. Creating QHash
8. Common APIs
9. Iteration
10. Performance
11. Qt 5 vs Qt 6
12. Best Practices
13. Interview Questions
14. Revision Notes

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

# Next Section

## **Chapter 19 — Part 2**

