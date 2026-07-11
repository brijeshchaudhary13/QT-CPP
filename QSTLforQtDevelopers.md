# Chapter 7 — STL for Qt Developers

---

# 1. What is the STL?

The **Standard Template Library (STL)** is a part of the C++ Standard Library.

It provides reusable, generic components for:

* Containers
* Algorithms
* Iterators
* Function objects
* Utility classes

The STL is **not related to Qt**, but modern Qt applications frequently use both STL and Qt APIs together.

---

# STL Architecture

```text
                 STL

                  │

-----------------------------------------

Containers

Algorithms

Iterators

Function Objects

Utilities

Memory
```

Each component works together through templates.

---

# Why Qt Developers Should Learn STL

Even if you write Qt applications every day, you'll encounter STL in:

* Qt source code
* Third-party libraries
* Modern C++ examples
* Standard C++ APIs
* Enterprise codebases

Qt 6 itself makes greater use of standard C++ features than earlier versions.

---

# 2. std::vector

## Definition

`std::vector` is a dynamically resizable array.

Header

```cpp
#include <vector>
```

---

## Internal Layout

Conceptually:

```text
vector

│

Pointer

↓

+--------------------------------------+

1

2

3

4

5

+--------------------------------------+

Size = 5

Capacity = 8
```

---

## Example

```cpp
#include <vector>
#include <iostream>

int main()
{
    std::vector<int> numbers;

    numbers.push_back(10);
    numbers.push_back(20);
    numbers.push_back(30);

    for (int value : numbers)
    {
        std::cout << value << '\n';
    }
}
```

---

## Memory Growth

Suppose:

```cpp
numbers.push_back(10);
```

Capacity:

```text
1
```

Add more elements.

```text
1

↓

2

↓

4

↓

8

↓

16
```

The vector grows by allocating a larger block and moving/copying existing elements.

---

## Complexity

| Operation     | Complexity     |
| ------------- | -------------- |
| Random Access | O(1)           |
| Push Back     | Amortized O(1) |
| Insert Middle | O(n)           |
| Remove Middle | O(n)           |

---

## Advantages

* Contiguous memory.
* Excellent cache locality.
* Fast iteration.
* Compatible with C APIs (`data()`).

---

## Disadvantages

* Inserting/removing in the middle is expensive.
* Reallocation invalidates iterators, references, and pointers to elements.

---

## Best Practices

Reserve capacity when you know the approximate size.

```cpp
std::vector<int> values;
values.reserve(1000);
```

---

# 3. std::map

A sorted associative container.

Header:

```cpp
#include <map>
```

---

Example:

```cpp
std::map<int, std::string> students;

students[1] = "Alice";
students[2] = "Bob";
```

---

Internally

Usually implemented as a balanced binary search tree (commonly a Red-Black Tree).

```text
          50

         /  \

      30     80

     / \    / \
```

---

Characteristics

* Automatically sorted by key.
* Logarithmic lookup.

---

Complexity

| Operation | Complexity |
| --------- | ---------- |
| Insert    | O(log n)   |
| Find      | O(log n)   |
| Remove    | O(log n)   |

---

Use When

* Sorted traversal is required.
* Range queries are needed.

---

# 4. std::unordered_map

Hash table implementation.

Header:

```cpp
#include <unordered_map>
```

---

Example

```cpp
std::unordered_map<int, std::string> students;

students[10] = "Alice";
```

---

Internal Structure

```text
Hash Function

↓

Bucket

↓

Linked Nodes / Equivalent Internal Structure
```

---

Advantages

* Average O(1) lookup.
* Very fast for large datasets.

---

Disadvantages

* No ordering.
* Worst-case O(n) (rare with good hash functions).

---

Complexity

| Operation | Complexity   |
| --------- | ------------ |
| Insert    | Average O(1) |
| Find      | Average O(1) |
| Remove    | Average O(1) |

---

# std::map vs std::unordered_map

| Feature         | map                                      | unordered_map       |
| --------------- | ---------------------------------------- | ------------------- |
| Sorted          | ✔                                        | ✘                   |
| Lookup          | O(log n)                                 | Average O(1)        |
| Memory          | Lower overhead per bucket but tree nodes | Hash table overhead |
| Iteration Order | Sorted                                   | Unspecified         |

---

# 5. std::list

A doubly linked list.

Header

```cpp
#include <list>
```

---

Structure

```text
Node

↓

Node

↓

Node

↓

Node
```

Each node stores pointers to neighboring nodes.

---

Advantages

* Constant-time insertion/removal at known positions.
* Stable iterators during insert/erase (except erased elements).

---

Disadvantages

* Poor cache locality.
* No random access.
* Higher memory overhead per element.

---

Complexity

| Operation     | Complexity            |
| ------------- | --------------------- |
| Push Front    | O(1)                  |
| Push Back     | O(1)                  |
| Random Access | O(n)                  |
| Insert        | O(1) (given iterator) |

---

Use When

Frequent insertion and deletion in the middle of the sequence outweigh the costs of non-contiguous storage.

---

# 6. Standard Algorithms

Header

```cpp
#include <algorithm>
```

---

## sort()

```cpp
std::sort(values.begin(), values.end());
```

Complexity:

```text
O(n log n)
```

---

## find()

```cpp
auto it = std::find(values.begin(),
                    values.end(),
                    20);
```

---

## reverse()

```cpp
std::reverse(values.begin(),
             values.end());
```

---

## count()

```cpp
int total =
std::count(values.begin(),
           values.end(),
           5);
```

---

## for_each()

```cpp
std::for_each(values.begin(),
              values.end(),
              [](int value)
{
    std::cout << value;
});
```

---

## Why Use Algorithms?

Instead of writing loops manually:

```cpp
for (...)
{
}
```

Prefer expressive standard algorithms when they clearly communicate intent.

---

# 7. Function Objects

Also called **functors**.

Example

```cpp
struct Greater
{
    bool operator()(int a,
                    int b) const
    {
        return a > b;
    }
};
```

Use

```cpp
std::sort(values.begin(),
          values.end(),
          Greater());
```

Today, lambdas are often preferred for simple cases.

---

# 8. std::optional

Represents an optional value.

Header

```cpp
#include <optional>
```

---

Example

```cpp
std::optional<int> age;
```

Initially:

```text
No Value
```

Assign

```cpp
age = 25;
```

Check

```cpp
if (age)
{
    std::cout << *age;
}
```

---

Why Use It?

Instead of:

```cpp
return -1;
```

to indicate failure, return:

```cpp
std::optional<int>
```

This clearly expresses that a value may or may not be present.

---

# 9. std::variant

A type-safe union.

Example

```cpp
std::variant<int,
             double,
             std::string> value;
```

Assign

```cpp
value = 10;
```

Later

```cpp
value = std::string("Qt");
```

Retrieve

```cpp
std::get<std::string>(value);
```

---

Use Cases

* Configuration values.
* Generic APIs.
* State machines.
* Parsers.

---

# 10. std::any

Stores a value of almost any copyable type.

Example

```cpp
std::any value;

value = 100;

value = std::string("Qt");
```

Retrieve

```cpp
std::any_cast<std::string>(value);
```

---

Comparison

| Class    | Type Safe       | Multiple Types                  |
| -------- | --------------- | ------------------------------- |
| optional | ✔               | One optional type               |
| variant  | ✔               | One of several predefined types |
| any      | Runtime checked | Almost any copyable type        |

---

# 11. STL vs Qt Containers

| STL                  | Qt                                                                              |
| -------------------- | ------------------------------------------------------------------------------- |
| `std::vector`        | `QVector` (Qt 5), `QList`/`QVector` convergence in Qt 6                         |
| `std::map`           | `QMap`                                                                          |
| `std::unordered_map` | `QHash`                                                                         |
| `std::list`          | `QList` (not equivalent internally), `std::list`                                |
| `std::pair`          | `QPair`                                                                         |
| `std::optional`      | No direct equivalent before Qt 6; use STL                                       |
| `std::variant`       | `QVariant` serves a different purpose; `std::variant` is a C++ language utility |

---

# When Should You Use STL?

Prefer STL when:

* Working with generic C++ libraries.
* Writing reusable C++ code.
* Using modern standard algorithms.
* No Qt dependency is required.

---

# When Should You Use Qt Containers?

Prefer Qt containers when:

* Working heavily with Qt APIs.
* Using implicit sharing where applicable.
* Interacting with Qt-specific types and APIs.

---

# Enterprise Recommendation

Modern Qt 6 applications often use **both**:

```text
Business Logic

↓

STL

↓

Qt UI

↓

Qt Containers
```

Choose the container that best matches the surrounding code and API expectations.

---

# 12. Performance Comparison

| Container     | Lookup       | Insert End     | Insert Middle         | Memory              |
| ------------- | ------------ | -------------- | --------------------- | ------------------- |
| vector        | O(1)         | Amortized O(1) | O(n)                  | Excellent locality  |
| map           | O(log n)     | O(log n)       | O(log n)              | Tree overhead       |
| unordered_map | Average O(1) | Average O(1)   | Average O(1)          | Hash table overhead |
| list          | O(n)         | O(1)           | O(1) (given iterator) | Pointer overhead    |

---

# 13. Qt 5.15 vs Qt 6.11

| Feature         | Qt 5.15          | Qt 6.11                |
| --------------- | ---------------- | ---------------------- |
| STL Support     | ✔                | ✔                      |
| Modern C++      | Good             | Strong emphasis        |
| C++17 APIs      | Partial adoption | Widely adopted         |
| STL Integration | Good             | Improved throughout Qt |

Qt 6 is designed to work naturally with modern C++.

---

# 14. Best Practices

* Prefer `std::vector` over linked lists unless you have a specific reason.
* Use `std::unordered_map` for fast lookups.
* Use `std::map` when ordering matters.
* Prefer STL algorithms over handwritten loops when appropriate.
* Use `std::optional` instead of sentinel values.
* Use `std::variant` instead of unsafe unions.
* Reserve capacity for vectors when possible.

---

# 15. Common Mistakes

* Choosing `std::list` without a measurable need.
* Forgetting `reserve()` on large vectors.
* Assuming `unordered_map` preserves insertion order.
* Using `std::any` where `std::variant` would be more appropriate.
* Mixing STL and Qt containers unnecessarily within the same API.

---

# 16. Interview Questions

## Easy

1. What is the STL?
2. What is the difference between `std::vector` and `std::list`?
3. What is `std::optional`?

## Medium

1. Compare `std::map` and `std::unordered_map`.
2. Explain why `std::vector` is often preferred over linked lists.
3. What are the benefits of standard algorithms?

## Hard

1. Describe the memory layout of `std::vector`.
2. Explain iterator invalidation in STL containers.
3. Compare `std::variant`, `std::optional`, and `std::any`.

## Expert

1. Design a container strategy for a large Qt application using both STL and Qt containers.
2. Explain how cache locality influences container performance.
3. Discuss the trade-offs between Qt containers and STL containers in a modern Qt 6 codebase.

---

# 17. Revision Notes

* STL is the standard generic library for C++.
* `std::vector` is the default sequence container for most use cases.
* `std::map` provides sorted key-value storage.
* `std::unordered_map` provides fast average-case lookups.
* `std::list` is useful for specific insertion-heavy scenarios but is often overused.
* Standard algorithms improve readability and expressiveness.
* `std::optional`, `std::variant`, and `std::any` solve different generic programming problems.
* Modern Qt development benefits from understanding both STL and Qt containers.

---
[⬅️ Modern C++ Review](/QModernC++Review.md)      |          [QObject ➡️](/QQObject.md)
---

## **License**
This project is licensed under the MIT License.

---

Happy Coding!


