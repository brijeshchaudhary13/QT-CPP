Excellent. This is the **advanced** part of `QVector`.

This chapter focuses on how `QVector` behaves in **production software**, how it interacts with the CPU cache, when memory reallocations occur, and how to write high-performance code for applications such as:

* Medical TPS
* CAD software
* Image processing
* Scientific computing
* Automotive systems
* Real-time visualization

> **Senior Qt Architect Insight**
>
> In performance-critical code, the choice of data structure often matters more than small algorithmic optimizations. Understanding memory layout, cache locality, iterator validity, and allocation behavior is essential.

---

# Complete Qt Master Course (Qt 5.15 LTS → Qt 6.11)

# PART III — Qt Core

# Chapter 17 — QVector (Complete Deep Dive)

## Part 2 — Internals, Iterator Rules, Memory Management & Performance

> **Level:** Advanced → Expert

---

# Table of Contents

1. Internal Implementation
2. Iterator Invalidation
3. Copy-on-Write (Implicit Sharing)
4. Move Semantics
5. Memory Allocation Strategy
6. Raw Pointer Access
7. STL Interoperability
8. QVector vs std::span
9. Performance Optimization
10. Medical TPS Use Cases
11. Qt 5.15 vs Qt 6.11
12. Best Practices
13. Interview Questions
14. Revision Notes

---

# 1. Internal Implementation

Conceptually, `QVector` manages:

```text
QVector
   │
   ▼
Shared Data
   │
   ├── Reference Count
   ├── Size
   ├── Capacity
   └── Contiguous Element Buffer
```

Memory example:

```cpp
QVector<int> values = {10, 20, 30};
```

Conceptually:

```text
Address

1000 → 10
1004 → 20
1008 → 30
```

Each element is stored directly after the previous one.

This is why iteration is very efficient.

---

# CPU Cache Locality

Suppose we iterate:

```cpp
for (int value : values)
{
    sum += value;
}
```

Memory:

```text
10 20 30 40 50 60 70
```

The CPU loads cache lines that already contain several consecutive elements.

```text
CPU Cache

↓

10 20 30 40

↓

50 60 70
```

This reduces memory latency.

---

# 2. Iterator Invalidation

One of the most important interview topics.

Example:

```cpp
QVector<int> values = {1, 2, 3};

auto it = values.begin();
```

Now:

```cpp
values.append(4);
```

If reallocation occurs:

```text
Old Buffer

↓

Allocate New Buffer

↓

Copy Elements

↓

Destroy Old Buffer
```

The iterator now points to invalid memory.

---

## Safe Rule

After operations that may change capacity, assume:

* Iterators become invalid.
* References become invalid.
* Pointers returned by `data()` become invalid.

---

Operations that may invalidate iterators:

* `append()`
* `insert()`
* `erase()`
* `removeAt()`
* `resize()`
* `reserve()`
* `clear()`

---

# 3. Copy-on-Write (Implicit Sharing)

Qt containers use implicit sharing.

Example:

```cpp
QVector<int> a = {1, 2, 3};

QVector<int> b = a;
```

Initially:

```text
Shared Data

Reference Count = 2

↑          ↑
a          b
```

No copy of the elements occurs.

---

Modify:

```cpp
b.append(4);
```

Qt performs a detach.

```text
Before

a ─┐
   │
Shared Data

After

a → Data A

b → Data B
```

Only the modified vector receives new storage.

---

# Detach Algorithm (Conceptual)

```text
Modify Vector

↓

Reference Count > 1 ?

↓

Yes

↓

Allocate New Buffer

↓

Copy Existing Elements

↓

Apply Modification
```

---

# 4. Move Semantics

Returning a vector:

```cpp
QVector<double> createDose()
{
    QVector<double> dose;

    // Fill dose

    return dose;
}
```

Modern compilers generally apply:

* Return Value Optimization (RVO)
* Move construction

No unnecessary copy is performed.

---

Move example:

```cpp
QVector<int> a = {1,2,3};

QVector<int> b = std::move(a);
```

Conceptually:

```text
Before

a

↓

Buffer

After

b

↓

Buffer

a

↓

Valid but unspecified state
```

---

# 5. Memory Allocation Strategy

Capacity grows automatically.

Conceptually:

```text
Capacity

4

↓

8

↓

16

↓

32

↓

64

↓

128
```

Qt chooses growth heuristics to reduce the number of reallocations.

---

## Reserve

```cpp
QVector<float> values;

values.reserve(1000000);
```

Advantages:

* Fewer allocations.
* Better performance.
* Reduced memory fragmentation.

---

## Resize

```cpp
values.resize(100);
```

Creates 100 elements.

Unlike `reserve()`, `resize()` changes the logical size.

---

# 6. Raw Pointer Access

`QVector` provides contiguous storage.

```cpp
float* ptr = values.data();
```

Read-only:

```cpp
const float* ptr = values.constData();
```

Memory:

```text
QVector

↓

Pointer

↓

1.0

2.0

3.0

4.0
```

Useful for:

* OpenGL
* VTK
* CUDA
* Numerical libraries
* Legacy C APIs

---

## Important

Pointers become invalid after reallocation.

Never store:

```cpp
float* ptr = values.data();
```

and later:

```cpp
values.append(100);
```

unless you reacquire the pointer afterward.

---

# 7. STL Interoperability

Modern Qt works well with STL algorithms.

Sorting:

```cpp
std::sort(values.begin(),
          values.end());
```

Finding:

```cpp
auto it =
    std::find(values.begin(),
              values.end(),
              42);
```

Accumulation:

```cpp
int sum =
    std::accumulate(values.begin(),
                    values.end(),
                    0);
```

This allows combining Qt containers with the standard algorithm library.

---

# 8. QVector vs std::span

Modern C++20 introduced:

```cpp
std::span<int>
```

Purpose:

* Non-owning view.
* No allocation.
* No ownership.

Similar Qt concept:

```text
QVector

↓

QSpan? (Not provided)

↓

Use data() + size()
```

Qt currently does not provide a direct `QVectorView` equivalent. For generic contiguous memory views, standard `std::span` is an excellent option in C++20 projects.

---

# 9. Performance Optimization

## Good

```cpp
values.reserve(100000);

for (...)
{
    values.append(...);
}
```

---

Avoid:

```cpp
for (...)
{
    values.prepend(...);
}
```

Each prepend shifts all existing elements.

---

Pass by Reference

```cpp
void process(const QVector<double>& data);
```

Avoid:

```cpp
void process(QVector<double> data);
```

unless ownership transfer or a local copy is intended.

---

# 10. Medical TPS Use Cases

## Dose Matrix

```cpp
QVector<float> doseValues;
```

Stores dose values.

---

## Beam Angles

```cpp
QVector<double> gantryAngles;
```

---

## Control Points

```cpp
QVector<ControlPoint>
```

---

## Contours

```cpp
QVector<QPointF>
```

---

## DVH (Dose Volume Histogram)

```cpp
QVector<double> histogram;
```

The contiguous layout makes sequential processing efficient.

---

# 11. Qt 5.15 vs Qt 6.11

| Feature                 | Qt 5.15   | Qt 6.11   |
| ----------------------- | --------- | --------- |
| Contiguous storage      | ✔         | ✔         |
| Separate implementation | ✔         | ✘         |
| Alias of QList          | ✘         | ✔         |
| Cache locality          | Excellent | Excellent |
| Implicit sharing        | ✔         | ✔         |
| STL compatibility       | Good      | Better    |

Qt 6 simplifies the container model by sharing the implementation between `QVector` and `QList`.

---

# 12. Best Practices

* Reserve capacity when the final size is known.
* Prefer `append()` over `prepend()`.
* Pass vectors by `const QVector<T>&`.
* Reacquire pointers and iterators after operations that may reallocate.
* Use STL algorithms where appropriate.
* Consider `std::span` for read-only views in modern C++20 code.

---

# 13. Common Mistakes

* Confusing `reserve()` with `resize()`.
* Keeping stale pointers from `data()`.
* Assuming iterators survive all modifications.
* Repeated front insertions into large vectors.
* Ignoring detach costs when modifying shared vectors.

---

# 14. Interview Questions

## Easy

1. What is `QVector`?
2. What does `reserve()` do?
3. What is the difference between `size()` and `capacity()`?

---

## Medium

1. Explain implicit sharing in `QVector`.
2. When are iterators invalidated?
3. Why is contiguous memory important?

---

## Hard

1. Explain Copy-on-Write in `QVector`.
2. Compare `QVector` and `std::vector`.
3. Describe the memory allocation strategy.

---

## Expert

1. Design a data structure for storing a 512×512×300 CT volume.
2. Explain cache locality and its impact on dose calculation performance.
3. Compare `QVector`, `std::vector`, and `std::pmr::vector` for high-performance medical software.

---

# 15. Revision Notes

* `QVector` stores elements contiguously.
* Iterators and pointers may be invalidated after reallocation.
* Implicit sharing delays copying until modification.
* `reserve()` reduces reallocations; `resize()` changes the logical size.
* `data()` provides direct access to contiguous memory.
* Qt 6 unifies `QVector` and `QList`.

---

# 🚀 Senior Developer Recommendations

| Scenario                          | Recommended Choice         |
| --------------------------------- | -------------------------- |
| Qt Model/View data                | `QVector` / `QList`        |
| Numerical algorithms              | `std::vector` or `QVector` |
| VTK/OpenGL interoperability       | `QVector` (using `data()`) |
| Large TPS dose matrices           | `QVector<float>`           |
| Generic C++ libraries             | `std::vector`              |
| Read-only contiguous view (C++20) | `std::span`                |

---

# Next Chapter

## **Chapter 18 — QMap (Complete Deep Dive)**

