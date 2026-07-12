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

# Chapter 18 — QMap (Complete Deep Dive)

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
[⬅️ QVector](/QQVector.md)      |          [QHash ➡️](/QQHash.md)
---
## **License**
This project is licensed under the MIT License.

---

Happy Coding!


