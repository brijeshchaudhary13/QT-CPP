Excellent. This is one of the **most misunderstood topics** in Qt.

Many developers still ask:

* **Should I use `QVector` or `QList`?**
* **Is `QVector` faster?**
* **Why does Qt 6 still have `QVector` if `QList` changed?**

The answer depends on **which Qt version you're using**.

> **Senior Qt Architect Insight**
>
> If you're working on a **Qt 5.15 LTS** project, understanding the difference between `QVector` and `QList` is essential.
>
> If you're starting a **new Qt 6.11** project, you should understand why this distinction mostly disappeared.

---

# Complete Qt Master Course (Qt 5.15 LTS → Qt 6.11)

# PART III — Qt Core

# Chapter 17 — QVector (Complete Deep Dive)

## Part 1 — Fundamentals, Architecture, Memory Layout & Qt 5 vs Qt 6

> **Level:** Beginner → Advanced

---

# Chapter Objectives

After completing this chapter, you will understand:

* What `QVector` is
* Why Qt introduced it
* Internal architecture
* Memory layout
* Dynamic array implementation
* Capacity growth
* Iterators
* Performance
* Qt 5 vs Qt 6 redesign
* Migration recommendations

---

# Table of Contents

1. What is QVector?
2. Why Qt Created QVector
3. Internal Architecture
4. Memory Layout
5. Capacity vs Size
6. Creating QVector
7. Common APIs
8. Iteration
9. Performance
10. Qt 5 vs Qt 6
11. Best Practices
12. Common Mistakes
13. Interview Questions
14. Revision Notes

---

# 1. What is QVector?

## Definition

`QVector<T>` is Qt's **dynamic contiguous array container**.

Header:

```cpp
#include <QVector>
```

Module:

```text
QtCore
```

Example:

```cpp
QVector<int> numbers;
```

Conceptually:

```text
QVector<int>

↓

10

20

30

40
```

Like `std::vector`, it stores elements in contiguous memory.

---

# Dynamic Array

Unlike a fixed array:

```cpp
int values[10];
```

whose size cannot change,

a `QVector` grows dynamically.

```cpp
QVector<int> values;

values.append(10);
values.append(20);
values.append(30);
```

---

# 2. Why Qt Created QVector

Historically, Qt offered several sequential containers with different optimization goals.

`QVector` was designed for:

* Contiguous memory
* Fast random access
* Efficient iteration
* Cache-friendly algorithms

Typical use cases:

* Geometry
* Images
* Mathematical data
* Scientific computing
* CAD
* Medical imaging

---

# Real Project Examples

Medical TPS

```cpp
QVector<double> doseValues;
```

Stores dose values.

---

VTK Integration

```cpp
QVector<QVector3D>
```

Stores 3D points.

---

CAD

```cpp
QVector<QPointF>
```

Stores vertices.

---

Signal Processing

```cpp
QVector<float>
```

Stores sampled data.

---

# 3. Internal Architecture

Conceptually:

```text
QVector

↓

Shared Data

↓

Reference Count

↓

Size

↓

Capacity

↓

Contiguous Elements
```

Like many Qt containers, `QVector` uses implicit sharing.

---

# Memory Layout

Conceptually:

```text
QVector

+--------------------------+

Pointer

↓

Shared Data

↓

Size

↓

Capacity

↓

Element Array

+--------------------------+
```

Example:

```cpp
QVector<int> values =
{
    10,
    20,
    30
};
```

Memory:

```text
1000

↓

10

20

30
```

Each element is stored directly after the previous one.

---

# 4. Size vs Capacity

One of the most important interview topics.

Suppose:

```cpp
QVector<int> values;
```

Initially:

```text
Size = 0

Capacity = 0
```

Append:

```cpp
values.append(10);
```

Conceptually:

```text
Size = 1

Capacity = 4
```

After:

```cpp
values.append(20);
values.append(30);
```

```text
Size = 3

Capacity = 4
```

One slot remains unused.

---

Append another:

```cpp
values.append(40);
```

```text
Size = 4

Capacity = 4
```

Append again:

```cpp
values.append(50);
```

Capacity grows.

Conceptually:

```text
4

↓

8

↓

16

↓

32
```

Growth policies are implementation details and may vary between Qt versions.

---

# Why Capacity Exists

Without extra capacity:

```text
Append

↓

Allocate

↓

Copy

↓

Free

↓

Append
```

Every insertion would require reallocation.

Capacity minimizes allocations.

---

# 5. Creating QVector

Default

```cpp
QVector<int> values;
```

---

Initializer List

```cpp
QVector<int> values =
{
    1,
    2,
    3
};
```

---

Fill Constructor

```cpp
QVector<int> values(10);
```

Ten default-constructed integers.

---

Fill with Value

```cpp
QVector<int> values(5, 100);
```

Result:

```text
100

100

100

100

100
```

---

# 6. Common APIs

Append

```cpp
values.append(10);
```

---

Push Back

```cpp
values.push_back(20);
```

---

Pop Back

```cpp
values.pop_back();
```

---

Insert

```cpp
values.insert(2, 50);
```

---

Remove

```cpp
values.removeAt(1);
```

---

Clear

```cpp
values.clear();
```

---

Reserve

```cpp
values.reserve(1000);
```

---

Resize

```cpp
values.resize(500);
```

---

Squeeze

```cpp
values.squeeze();
```

Requests that unused capacity be released.

---

# 7. Accessing Elements

```cpp
values[0];
```

---

```cpp
values.at(0);
```

---

```cpp
values.first();
```

---

```cpp
values.last();
```

---

```cpp
values.data();
```

Returns a pointer to the contiguous storage.

Useful for interoperability with C APIs and numerical libraries.

---

# 8. Iteration

Range-based loop

```cpp
for (const auto &value : values)
{
    qDebug() << value;
}
```

Recommended.

---

Iterator

```cpp
for (auto it = values.begin();
     it != values.end();
     ++it)
{
}
```

---

Reverse

```cpp
for (auto it = values.rbegin();
     it != values.rend();
     ++it)
{
}
```

---

# 9. Performance

Excellent

* Random access
* Sequential iteration
* Cache locality
* Append (amortized constant time)

Potentially Expensive

* Insert at beginning
* Remove at beginning
* Frequent reallocations
* Detach after sharing

---

Reserve Example

Instead of:

```cpp
for (int i = 0; i < 100000; ++i)
{
    values.append(i);
}
```

Better:

```cpp
values.reserve(100000);

for (int i = 0; i < 100000; ++i)
{
    values.append(i);
}
```

Fewer reallocations.

---

# 10. Qt 5.15 vs Qt 6.11

This is the key part.

## Qt 5

Historically:

```text
QVector

↓

Contiguous Array

QList

↓

Different Implementation
```

Developers often chose `QVector` specifically for contiguous storage.

---

## Qt 6

Qt redesigned `QList`.

`QVector` is now effectively an alias of `QList`.

Conceptually:

```text
QVector

↓

QList Implementation

↓

Contiguous Storage
```

This means:

* Same implementation
* Same performance characteristics
* Same APIs

---

# Comparison

| Feature                 | Qt 5.15   | Qt 6.11   |
| ----------------------- | --------- | --------- |
| Contiguous storage      | ✔         | ✔         |
| Separate implementation | ✔         | ✘         |
| Alias of QList          | ✘         | ✔         |
| Cache locality          | Excellent | Excellent |
| Random access           | Excellent | Excellent |

---

# Migration Advice

Legacy Qt 5:

```cpp
QVector<Point>
```

No change is generally required.

Qt 6 preserves source compatibility.

New projects can continue using `QVector` where it best expresses intent, but understand that it shares its implementation with `QList`.

---

# 11. Best Practices

* Reserve capacity when the approximate size is known.
* Pass by `const QVector<T>&` for read-only parameters.
* Prefer range-based `for`.
* Avoid repeated insertion at the beginning.
* Use `data()` when interoperating with C libraries or numerical APIs.

---

# 12. Common Mistakes

* Confusing size with capacity.
* Forgetting to reserve memory for large datasets.
* Assuming Qt 6 `QVector` differs internally from `QList`.
* Holding iterators after operations that reallocate storage.
* Performing repeated front insertions on large vectors.

---

# 13. Interview Questions

## Easy

1. What is `QVector`?
2. What is the difference between size and capacity?
3. What does `reserve()` do?

---

## Medium

1. Why is contiguous memory beneficial?
2. Explain `resize()` versus `reserve()`.
3. When are iterators invalidated?

---

## Hard

1. Compare `QVector` and `std::vector`.
2. Explain the Qt 6 redesign of `QVector`.
3. Describe the conceptual memory layout of `QVector`.

---

## Expert

1. Design a data structure for storing millions of 3D dose points in a TPS.
2. Compare `QVector`, `QList`, and `std::vector` for numerical algorithms.
3. Explain cache locality and its impact on rendering and image processing performance.

---

# 14. Revision Notes

* `QVector` is a dynamic contiguous array.
* It provides fast random access.
* Capacity and size are different concepts.
* `reserve()` reduces reallocations.
* Qt 6 unifies `QVector` and `QList`.
* Contiguous storage improves CPU cache efficiency.
* Avoid frequent insertions at the beginning.

---

# 🎯 Senior Developer Recommendations

| Scenario                   | Recommended Container                                 |
| -------------------------- | ----------------------------------------------------- |
| Medical image pixel values | `QVector<float>` or `std::vector<float>`              |
| VTK point coordinates      | `QVector<QVector3D>`                                  |
| Qt GUI data                | `QVector` / `QList`                                   |
| Generic C++ algorithms     | `std::vector`                                         |
| Legacy Qt 5 code           | Keep `QVector` unless refactoring has a clear benefit |

---

# Next Section

In **Chapter 17 — Part 2**, we'll cover:
