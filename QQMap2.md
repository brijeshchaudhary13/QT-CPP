Excellent. This is the **advanced** part of `QMap`.

This chapter covers the topics expected from a **Senior Qt Developer**, including:

* Red-Black Tree balancing
* Iterator behavior
* Memory management
* Performance analysis
* Choosing between `QMap`, `QHash`, and `std::map`
* Production architecture decisions

These topics are especially useful for **enterprise software**, **medical TPS systems**, **DICOM processing**, **CAD applications**, and **configuration management**.

---

# Complete Qt Master Course (Qt 5.15 LTS → Qt 6.11)

# PART III — Qt Core

# Chapter 18 — QMap (Complete Deep Dive)

## Part 2 — Red-Black Tree Internals, Iterators, Performance & Production Usage

> **Level:** Advanced → Expert

---

# Table of Contents

1. Red-Black Tree Insertion
2. Tree Balancing
3. Iterator Rules
4. Implicit Sharing
5. Move Semantics
6. Search APIs
7. Lower Bound & Upper Bound
8. STL Interoperability
9. QMap vs QHash vs std::map
10. Performance Analysis
11. Medical TPS Use Cases
12. Qt 5.15 vs Qt 6.11
13. Best Practices
14. Interview Questions
15. Revision Notes

---

# 1. Red-Black Tree Insertion

Suppose we insert:

```cpp
QMap<int, QString> map;

map.insert(30, "Thirty");
map.insert(20, "Twenty");
map.insert(40, "Forty");
map.insert(10, "Ten");
```

Conceptually:

```text
        30
       /  \
     20    40
    /
  10
```

The tree remains balanced.

---

Insert:

```cpp
map.insert(5, "Five");
```

Without balancing:

```text
30
|
20
|
10
|
5
```

Searching becomes slow.

Qt automatically rebalances the tree.

---

# 2. Tree Balancing

Red-Black Trees maintain several invariants (such as coloring rules and balanced black-height) to keep the tree height logarithmic.

Conceptually:

```text
Before

30
|
20
|
10

↓

Rotate / Recolor

↓

      20
     /  \
   10    30
```

The exact balancing algorithm is handled internally by Qt.

Developers never manually rebalance the tree.

---

# Why Balance Matters

Balanced:

```text
Height ≈ log₂(n)
```

Unbalanced:

```text
Height ≈ n
```

Search:

| Structure             | Complexity |
| --------------------- | ---------- |
| Balanced Tree         | O(log n)   |
| Linked List-like Tree | O(n)       |

---

# 3. Iterator Rules

Iterators allow traversal in **sorted key order**.

Example:

```cpp
for (auto it = map.begin();
     it != map.end();
     ++it)
{
    qDebug()
        << it.key()
        << it.value();
}
```

Output:

```text
10
20
30
40
```

Not insertion order.

---

# Const Iterator

Preferred for read-only traversal.

```cpp
for (auto it = map.cbegin();
     it != map.cend();
     ++it)
{
}
```

---

# Reverse Iterator

```cpp
for (auto it = map.crbegin();
     it != map.crend();
     ++it)
{
}
```

Produces:

```text
40

30

20

10
```

---

# Iterator Invalidation

Unlike contiguous containers, inserting into a balanced tree does **not** generally require relocating all nodes.

However:

* Removing an element invalidates iterators referring to that removed element.
* Clearing the container invalidates all iterators.
* Modifying the container while iterating requires care.

Always consult the Qt documentation for exact guarantees when writing production code.

---

# Safe Pattern

```cpp
auto it = map.find("Beam1");

if (it != map.end())
{
    qDebug()
        << it.value();
}
```

---

# 4. Implicit Sharing

Like many Qt value types:

```cpp
QMap<QString,int> a;

QMap<QString,int> b = a;
```

Initially:

```text
Reference Count = 2
```

No nodes copied.

---

Modify:

```cpp
b.insert("New", 10);
```

Detach:

```text
Shared Data

↓

Copy Tree

↓

Modify Copy
```

---

# Detach Flow

```text
Modify

↓

Shared?

↓

Yes

↓

Clone Tree

↓

Modify
```

---

# 5. Move Semantics

Returning:

```cpp
QMap<QString,int> createMap()
{
    QMap<QString,int> map;

    map.insert("A",1);

    return map;
}
```

Modern compilers generally use:

* RVO
* Move construction

No unnecessary deep copy.

---

Move:

```cpp
QMap<QString,int> a;

QMap<QString,int> b =
    std::move(a);
```

Ownership transfers efficiently.

---

# 6. Search APIs

## find()

```cpp
auto it =
    map.find("Beam1");
```

Returns an iterator.

---

## constFind()

```cpp
auto it =
    map.constFind("Beam1");
```

Read-only.

---

## contains()

```cpp
map.contains("Beam1");
```

Returns `true` or `false`.

---

## value()

```cpp
map.value("Beam1");
```

Returns the associated value or a default if absent.

---

# 7. lowerBound() and upperBound()

These APIs leverage the ordered nature of `QMap`.

## lowerBound()

Returns the first element whose key is **not less than** the given key.

Example:

Keys:

```text
10

20

30

40
```

```cpp
auto it =
    map.lowerBound(25);
```

Points to:

```text
30
```

---

## upperBound()

Returns the first element whose key is **greater than** the given key.

Example:

```cpp
auto it =
    map.upperBound(30);
```

Points to:

```text
40
```

---

# Why Are These Useful?

Range queries.

Example:

Patients:

```text
Patient100

Patient101

Patient102

...
```

Retrieve a range efficiently using ordered keys.

---

# 8. STL Interoperability

Although `QMap` is a Qt container, it supports iterator-based algorithms.

Example:

```cpp
auto it =
    std::find_if(
        map.begin(),
        map.end(),
        [](const auto &value)
        {
            return value > 100;
        });
```

Note that `std::find_if` operates on the values exposed by the iterator (key-value pairs), so predicates should be written accordingly.

---

# 9. QMap vs QHash vs std::map

This is a classic interview question.

| Feature            | QMap           | QHash        | std::map       |
| ------------------ | -------------- | ------------ | -------------- |
| Ordered            | ✔              | ✘            | ✔              |
| Lookup             | O(log n)       | Average O(1) | O(log n)       |
| Internal Structure | Red-Black Tree | Hash Table   | Red-Black Tree |
| Sorted Iteration   | ✔              | ✘            | ✔              |
| Qt Integration     | Excellent      | Excellent    | Limited        |

---

# Which One Should You Use?

## Ordered Reports

```cpp
QMap
```

---

## Fast Lookup

```cpp
QHash
```

---

## Pure Modern C++

```cpp
std::map
```

---

# 10. Performance Analysis

Excellent

* Ordered iteration
* Range queries
* `lowerBound()`
* `upperBound()`

Slower than `QHash` for average-case lookups because tree traversal is logarithmic rather than constant-time on average.

---

Memory

Each node stores:

```text
Key

Value

Parent

Left

Right

Color
```

Tree nodes require more overhead than contiguous arrays.

---

# Cache Locality

Unlike `QVector`:

```text
1000

1004

1008
```

Tree nodes may reside in unrelated memory locations.

```text
5000

900

8000

1200
```

This results in lower cache locality.

---

# 11. Medical TPS Use Cases

## DICOM Tags

```cpp
QMap<Tag, QVariant>
```

Ordered tag storage.

---

## Patient Registry

```cpp
QMap<QString, Patient>
```

Lookup by patient ID.

---

## Beam Table

```cpp
QMap<QString, Beam>
```

Lookup by beam name.

---

## Configuration

```cpp
QMap<QString, QString>
```

Ordered settings.

---

## Dose Statistics

```cpp
QMap<QString,double>
```

Organ name:

```text
Heart

↓

Dose
```

---

# 12. Qt 5.15 vs Qt 6.11

| Feature          | Qt 5.15 | Qt 6.11 |
| ---------------- | ------- | ------- |
| Ordered          | ✔       | ✔       |
| Red-Black Tree   | ✔       | ✔       |
| Implicit Sharing | ✔       | ✔       |
| `lowerBound()`   | ✔       | ✔       |
| `upperBound()`   | ✔       | ✔       |
| API              | Stable  | Stable  |

There is **no major behavioral difference** between Qt 5.15 and Qt 6.11 for `QMap`.

---

# 13. Best Practices

* Use `value()` for read-only access.
* Use `find()` when you need an iterator.
* Use `lowerBound()` for range-based searches.
* Prefer `QHash` if key ordering is unnecessary and lookup speed is the primary goal.
* Avoid `operator[]` unless insertion of missing keys is intended.
* Use `cbegin()` and `cend()` for read-only iteration.

---

# 14. Common Mistakes

* Expecting insertion order.
* Using `operator[]` for existence checks.
* Choosing `QMap` when `QHash` would be more appropriate.
* Assuming contiguous memory.
* Ignoring iterator validity after modifications.

---

# 15. Interview Questions

## Easy

1. What is `QMap`?
2. Why are keys ordered?
3. What does `contains()` do?

---

## Medium

1. Explain `lowerBound()`.
2. Compare `value()` and `operator[]`.
3. Why is lookup O(log n)?

---

## Hard

1. Explain Red-Black Tree balancing.
2. Compare `QMap` and `std::map`.
3. Discuss cache locality.

---

## Expert

1. Design a DICOM tag dictionary using `QMap`.
2. Compare `QMap` and `QHash` for a Treatment Planning System.
3. Explain how tree balancing maintains logarithmic performance.

---

# 16. Revision Notes

* `QMap` is implemented using a Red-Black Tree.
* Keys are always sorted.
* Lookup, insertion, and removal are O(log n).
* `lowerBound()` and `upperBound()` enable efficient range queries.
* Tree nodes are individually allocated, so cache locality is lower than contiguous containers.
* Implicit sharing reduces copy cost until modification.

---

# 🏥 Production Recommendations

| Scenario                                    | Recommended Container    |
| ------------------------------------------- | ------------------------ |
| DICOM Tag Dictionary                        | `QMap<Tag, QVariant>`    |
| Patient Database (ordered IDs)              | `QMap<QString, Patient>` |
| Configuration Files                         | `QMap<QString, QString>` |
| Dose Statistics                             | `QMap<QString, double>`  |
| Frequently accessed lookup without ordering | `QHash`                  |

---

# Next Chapter

## **Chapter 19 — QHash (Complete Deep Dive)**

