Excellent. We are now moving from **sequential containers** (`QList`, `QVector`) to **associative containers**.

This is one of the most important transitions in the Qt Core module.

A `QList` stores elements by **position (index)**.

A `QMap` stores elements by **key**.

Instead of asking:

```cpp
patients[3]
```

you ask:

```cpp
patients["P12345"]
```

where `"P12345"` is the patient's unique ID.

---

# Complete Qt Master Course (Qt 5.15 LTS → Qt 6.11)

# PART III — Qt Core

# Chapter 18 — QMap (Complete Deep Dive)

## Part 1 — Fundamentals, Red-Black Tree Architecture, Memory Layout & APIs

> **Level:** Beginner → Advanced

---

# Chapter Objectives

After completing this chapter, you will understand:

* What `QMap` is
* Ordered associative containers
* Key-value storage
* Internal Red-Black Tree architecture
* Memory layout
* Time complexity
* Common APIs
* Iteration
* Qt 5 vs Qt 6
* Production usage

---

# Table of Contents

1. What is QMap?
2. Why Qt Created QMap
3. Ordered Associative Containers
4. Internal Architecture
5. Red-Black Tree
6. Memory Layout
7. Creating QMap
8. Common APIs
9. Iteration
10. Performance
11. Qt 5 vs Qt 6
12. Best Practices
13. Interview Questions
14. Revision Notes

---

# 1. What is QMap?

## Definition

`QMap<Key, T>` is an **ordered associative container**.

Header:

```cpp
#include <QMap>
```

Module:

```text
QtCore
```

Example:

```cpp
QMap<QString, int> ages;
```

Here:

* Key → `QString`
* Value → `int`

---

Unlike a list:

```text
0 → Alice

1 → Bob
```

A map stores:

```text
Alice → 25

Bob → 30

Charlie → 28
```

You retrieve values using keys instead of numeric indices.

---

# Concept

```text
QMap

↓

Key

↓

Value
```

Example:

```text
Patient001 → Brijesh

Patient002 → Sakshi

Patient003 → Rahul
```

---

# 2. Why Qt Created QMap

Many real-world problems require lookup by identifier rather than position.

Examples:

## Medical TPS

```text
Structure Name

↓

RT Structure Object
```

---

## DICOM

```text
Tag

↓

Value
```

---

## ERP

```text
Employee ID

↓

Employee Object
```

---

## Automotive

```text
CAN Signal Name

↓

Signal Object
```

---

# 3. Ordered Associative Container

A key feature of `QMap`:

**Keys are always kept in sorted order.**

Example:

```cpp
QMap<int, QString> map;

map[30] = "Thirty";
map[10] = "Ten";
map[20] = "Twenty";
```

Stored internally:

```text
10

20

30
```

Not:

```text
30

10

20
```

Insertion order is **not** preserved.

---

# 4. Internal Architecture

Conceptually:

```text
QMap

↓

Root Node

↓

Binary Search Tree

↓

Left Child

Right Child
```

Qt implements `QMap` using a **balanced binary search tree** (specifically, a Red-Black Tree).

---

# 5. Red-Black Tree

A Red-Black Tree is a **self-balancing binary search tree**.

Every node contains:

```text
Key

Value

Left

Right

Parent

Color
```

Color is either:

```text
RED

or

BLACK
```

---

# Why Use a Red-Black Tree?

Without balancing:

```text
1

↓

2

↓

3

↓

4

↓

5
```

Searching becomes linear.

Balanced tree:

```text
      3

    /   \

   2     5

  /     /

 1     4
```

Searching remains efficient.

---

# Time Complexity

| Operation | Complexity |
| --------- | ---------- |
| Insert    | O(log n)   |
| Find      | O(log n)   |
| Remove    | O(log n)   |
| Traversal | O(n)       |

---

# 6. Memory Layout

Each node stores:

Conceptually:

```text
+----------------------------+

Key

Value

Left Pointer

Right Pointer

Parent Pointer

Color

+----------------------------+
```

Unlike `QVector`, the nodes are **not stored contiguously**.

Memory:

```text
Node

↓

Pointer

↓

Node

↓

Pointer

↓

Node
```

Each insertion allocates a new tree node.

---

# 7. Creating QMap

Default

```cpp
QMap<QString, int> ages;
```

---

Insert using `insert()`

```cpp
ages.insert("Alice", 25);
ages.insert("Bob", 30);
```

---

Using `operator[]`

```cpp
ages["Charlie"] = 28;
```

---

Result

```text
Alice → 25

Bob → 30

Charlie → 28
```

(sorted by key)

---

# 8. Common APIs

## insert()

```cpp
map.insert("Beam1", 120);
```

---

## value()

```cpp
int monitorUnits =
    map.value("Beam1");
```

Returns the associated value.

If the key is absent, it returns a default-constructed value unless an explicit default is provided.

---

## contains()

```cpp
map.contains("Beam1");
```

Returns:

```text
true

or

false
```

---

## remove()

```cpp
map.remove("Beam1");
```

---

## clear()

```cpp
map.clear();
```

---

## size()

```cpp
map.size();
```

---

## isEmpty()

```cpp
map.isEmpty();
```

---

## keys()

```cpp
map.keys();
```

Returns a `QList` of keys.

---

## values()

```cpp
map.values();
```

Returns a `QList` of values.

---

# 9. Accessing Elements

Using `operator[]`

```cpp
map["Patient001"];
```

⚠️ **Important:** If the key does not exist, `operator[]` inserts a new entry with a default-constructed value.

Example:

```cpp
QMap<QString, int> scores;

int score = scores["Alice"];
```

After this code:

```text
Alice → 0
```

A new element has been inserted.

---

Read-only access

```cpp
map.value("Patient001");
```

This does **not** insert a new key.

---

# 10. Iteration

Range-based

```cpp
for (auto it = map.cbegin();
     it != map.cend();
     ++it)
{
    qDebug()
        << it.key()
        << it.value();
}
```

---

Modern structured bindings (Qt iterators still return iterator objects, but you can combine Qt with STL-style approaches where appropriate).

---

Output

```text
Patient001

Brijesh

Patient002

Sakshi
```

Always in **sorted key order**.

---

# 11. Performance

Excellent

* Ordered traversal
* Lookup
* Insert
* Remove

Not Ideal

* Cache locality (tree nodes are separately allocated)
* Sequential numeric access
* Large contiguous datasets

---

# Example

Searching:

```cpp
map.value("Beam42");
```

Conceptually:

```text
Root

↓

Left

↓

Right

↓

Found
```

Approximately `O(log n)` operations.

---

# 12. Qt 5.15 vs Qt 6.11

| Feature          | Qt 5.15 | Qt 6.11 |
| ---------------- | ------- | ------- |
| Ordered          | ✔       | ✔       |
| Red-Black Tree   | ✔       | ✔       |
| Implicit Sharing | ✔       | ✔       |
| API              | Stable  | Stable  |
| Performance      | Similar | Similar |

There is **no fundamental conceptual difference** between Qt 5.15 and Qt 6.11 for `QMap`.

---

# 13. Best Practices

* Use `contains()` or `find()` when you need to check for existence before accessing.
* Use `value()` for read-only access.
* Avoid `operator[]` when you don't intend to insert.
* Choose `QMap` when sorted keys are important.
* Choose `QHash` when lookup speed is more important than ordering (we'll cover this in the next chapter).

---

# 14. Common Mistakes

* Assuming insertion order is preserved.
* Using `operator[]` for lookups and accidentally inserting entries.
* Expecting constant-time lookup.
* Using `QMap` where `QHash` would be a better fit.
* Assuming contiguous storage like `QVector`.

---

# 15. Interview Questions

## Easy

1. What is `QMap`?
2. What is the difference between a list and a map?
3. How do you insert an element?

---

## Medium

1. Why are keys always sorted?
2. Explain the difference between `value()` and `operator[]`.
3. What is the time complexity of lookup?

---

## Hard

1. Explain why `QMap` uses a Red-Black Tree.
2. Describe the conceptual memory layout.
3. Compare `QMap` with `std::map`.

---

## Expert

1. Design a patient registry using `QMap`.
2. Explain why `QMap` is not cache-friendly.
3. Compare `QMap`, `QHash`, and `std::unordered_map` for a TPS application.

---

# 16. Revision Notes

* `QMap` is an ordered associative container.
* It stores key-value pairs.
* Keys are automatically sorted.
* It is implemented using a balanced Red-Black Tree.
* Lookup, insertion, and removal are `O(log n)`.
* `operator[]` inserts missing keys.
* `value()` performs read-only access without insertion.

---

# 🏥 Production Examples

| Use Case                      | Recommended                |
| ----------------------------- | -------------------------- |
| DICOM Tag → Value             | `QMap<Tag, QVariant>`      |
| Patient ID → Patient Object   | `QMap<QString, Patient>`   |
| Beam Name → Beam Data         | `QMap<QString, Beam>`      |
| Configuration Parameters      | `QMap<QString, QString>`   |
| RT Structure Name → Structure | `QMap<QString, Structure>` |

---

# Next Section

In **Chapter 18 — Part 2**, we'll explore advanced topics:

