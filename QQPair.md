> **Senior Qt Architect Insight**
>
> For new Qt 6 projects, I generally recommend **`std::pair`** unless a Qt API specifically requires `QPair`. Understanding both is essential because you'll encounter `QPair` often in legacy code.

---

# Chapter 21 — QPair (Complete Deep Dive)

---

# 1. What is QPair?

## Definition

`QPair<T1, T2>` stores **exactly two related values**.

Header:

```cpp
#include <QPair>
```

Module:

```text
QtCore
```

Example:

```cpp
QPair<QString, int> employee;
```

Stores:

```text
Name

↓

Salary
```

Unlike:

```cpp
QList<int>
```

which stores many values,

`QPair` always stores **exactly two objects**.

---

# Concept

```text
QPair

↓

First

↓

Second
```

Example:

```cpp
QPair<QString, int> student;
```

Conceptually:

```text
"Brijesh"

↓

101
```

---

# 2. Why Qt Created QPair

Many APIs naturally return two values.

Examples:

Medical TPS

```text
Dose

↓

Monitor Units
```

---

Networking

```text
IP Address

↓

Port
```

---

Geometry

```text
X

↓

Y
```

---

Database

```text
Key

↓

Value
```

Instead of creating a new class for every two-value combination, `QPair` provides a lightweight generic solution.

---

# 3. Internal Structure

Conceptually, `QPair` is simply:

```cpp
template<typename T1, typename T2>
struct QPair
{
    T1 first;
    T2 second;
};
```

This is a conceptual illustration. The actual Qt implementation may include additional constructors and helper functions.

---

# Memory Layout

Example:

```cpp
QPair<int, double> pair;
```

Conceptually:

```text
+----------------------+

first

↓

10

----------------------

second

↓

25.5

+----------------------+
```

The exact memory layout depends on alignment and padding rules of the platform and compiler.

---

# 4. Creating QPair

Default

```cpp
QPair<QString, int> employee;
```

---

Constructor

```cpp
QPair<QString, int> employee("Alice", 5000);
```

---

Helper Function

```cpp
auto pair =
    qMakePair(QString("Bob"), 6000);
```

`qMakePair()` lets the compiler deduce template types automatically.

---

# 5. Accessing Members

Unlike `QMap`:

```cpp
map[key]
```

`QPair` exposes two public members:

```cpp
pair.first
```

and

```cpp
pair.second
```

Example:

```cpp
qDebug() << pair.first;
qDebug() << pair.second;
```

---

# Example

```cpp
QPair<QString,int> patient("John",101);

qDebug() << patient.first;

qDebug() << patient.second;
```

Output:

```text
John

101
```

---

# 6. Common APIs

`QPair` has a deliberately small API because it is essentially a simple aggregate type.

Typical operations:

* Construction
* Copy
* Move
* Assignment
* Comparison
* Access through `first` and `second`

---

# Assignment

```cpp
QPair<QString,int> a;

QPair<QString,int> b;

b = a;
```

---

# Copy

```cpp
QPair<QString,int> copy(original);
```

---

# Move

```cpp
QPair<QString,int> moved =
    std::move(original);
```

---

# 7. Comparison Operators

Two pairs can be compared.

Example:

```cpp
QPair<int,int> a(1,2);

QPair<int,int> b(1,3);
```

Comparison:

```cpp
if (a == b)
{
}
```

Returns:

```text
false
```

Comparison is performed lexicographically:

1. Compare `first`
2. If equal, compare `second`

This matches the behavior of `std::pair`.

---

# 8. Structured Bindings (Modern C++17)

One of the nicest features of modern C++.

```cpp
QPair<QString,int> employee("Alice",5000);

auto [name, salary] = employee;
```

Now:

```cpp
name

salary
```

can be used directly.

> This requires C++17 and works because modern Qt provides the necessary tuple-like interface for `QPair`.

---

# 9. Performance

Excellent.

Reasons:

* Only two objects.
* No dynamic allocation (unless the contained types allocate internally).
* Very small object.
* Efficient copy and move operations.

Example:

```cpp
QPair<int,int>
```

Typically occupies memory for two integers, subject to alignment.

---

# 10. Qt 5.15 vs Qt 6.11

| Feature                | Qt 5.15                                  | Qt 6.11 |
| ---------------------- | ---------------------------------------- | ------- |
| `QPair` Available      | ✔                                        | ✔       |
| `first` / `second`     | ✔                                        | ✔       |
| `qMakePair()`          | ✔                                        | ✔       |
| Structured bindings    | Partial (depends on compiler/Qt version) | ✔       |
| Modern C++ integration | Good                                     | Better  |

---

# Relationship with std::pair

Qt 6 embraces the C++ Standard Library more strongly than Qt 5.

For new code:

```cpp
std::pair
```

is often preferred unless Qt APIs specifically use `QPair`.

---

# 11. Best Practices

* Use `QPair` for temporary or simple two-value groupings.
* If the values have clear semantic meaning, consider defining a named `struct` instead of using `first` and `second`.
* Prefer structured bindings in C++17 or later.
* Use `std::pair` in modern non-Qt libraries for consistency with the STL.

---

# Example

Instead of:

```cpp
QPair<double,double>
```

Prefer:

```cpp
struct Point
{
    double x;
    double y;
};
```

The second version is more readable.

---

# 12. Common Mistakes

* Using `QPair` to represent complex domain objects.
* Nesting many `QPair` objects:

```cpp
QPair<int,
      QPair<QString,
            double>>
```

This quickly becomes difficult to understand.

* Using `first` and `second` when descriptive names would improve readability.
* Assuming `QPair` replaces proper data structures.

---

# 13. Interview Questions

## Easy

1. What is `QPair`?
2. How many values can it store?
3. How do you access its members?

---

## Medium

1. Compare `QPair` and `std::pair`.
2. Explain `qMakePair()`.
3. What are structured bindings?

---

## Hard

1. Describe the conceptual memory layout of `QPair`.
2. Explain comparison behavior.
3. When should you use a custom structure instead?

---

## Expert

1. Design a function returning two values using `QPair`.
2. Compare `QPair`, `std::pair`, and a custom `struct` from an API design perspective.
3. Discuss when `QPair` hurts readability in large codebases.

---

# 14. Revision Notes

* `QPair` stores exactly two values.
* Members are `first` and `second`.
* `qMakePair()` performs template argument deduction.
* Comparison is lexicographical.
* C++17 structured bindings improve readability.
* Prefer a named `struct` when the pair represents a real domain concept.
* `std::pair` is often preferred in modern C++ unless interacting with Qt APIs.

---

# 🏥 Production Examples

| Use Case             | Example                        |
| -------------------- | ------------------------------ |
| Dose + Monitor Units | `QPair<double, double>`        |
| IP Address + Port    | `QPair<QHostAddress, quint16>` |
| X/Y Coordinates      | `QPair<double, double>`        |
| Database Key + Value | `QPair<QString, QVariant>`     |
| Patient Name + ID    | `QPair<QString, int>`          |

---
Excellent. This is the **advanced** part of `QPair`.

This chapter focuses on **modern C++ practices**, API design, and real-world engineering decisions.

A common misconception among developers is:

> "If I need to return two values, I should always use `QPair`."

That is **not** always the best choice.

Senior developers consider:

* Readability
* Maintainability
* ABI stability
* Performance
* Domain modeling
* Future extensibility

before choosing between:

* `QPair`
* `std::pair`
* `std::tuple`
* Custom `struct`

---

# 1. Copy & Move Semantics

`QPair` supports copy and move operations, depending on the capabilities of the contained types.

Example:

```cpp
QPair<QString, QString> a("TPS", "Beam");

QPair<QString, QString> b = a;      // Copy

QPair<QString, QString> c = std::move(a); // Move
```

When the contained types have efficient move constructors (such as `QString`), moving is generally cheaper than copying.

---

# Return Value Optimization (RVO)

```cpp
QPair<QString, int> createPatient()
{
    return {"John", 101};
}
```

Modern compilers typically apply:

* Named Return Value Optimization (NRVO), or
* Move construction

This avoids unnecessary copies.

---

# 2. Template Type Deduction

Instead of writing:

```cpp
QPair<QString, int> pair("Alice", 25);
```

you can use:

```cpp
auto pair = qMakePair(QString("Alice"), 25);
```

The compiler deduces the template arguments automatically.

---

# C++17 Alternative

With modern C++:

```cpp
auto pair = std::make_pair(QString("Alice"), 25);
```

Both approaches avoid explicitly writing template parameters.

---

# 3. Returning Multiple Values

A common use case:

```cpp
QPair<double, double> calculateDose()
{
    return {74.5, 250.0};
}
```

Usage:

```cpp
auto result = calculateDose();

double dose = result.first;
double mu   = result.second;
```

---

# Better with Structured Bindings

```cpp
auto [dose, mu] = calculateDose();
```

This improves readability.

---

# When More Than Two Values Are Needed

Instead of:

```cpp
QPair<QString,
      QPair<int,
            double>>
```

Prefer:

```cpp
struct PatientDose
{
    QString name;
    int id;
    double dose;
};
```

This is easier to understand and maintain.

---

# 4. QPair vs std::pair

| Feature                              | QPair                     | std::pair |
| ------------------------------------ | ------------------------- | --------- |
| Qt Integration                       | Excellent                 | Good      |
| STL Integration                      | Limited                   | Excellent |
| Structured Bindings                  | Supported (modern Qt/C++) | Native    |
| Standard C++                         | No                        | Yes       |
| Recommended for new generic C++ code | Usually No                | Yes       |

---

# Which Should You Use?

## Inside Qt APIs

```cpp
QPair<QString, int>
```

Perfectly acceptable.

---

## Generic C++ Library

```cpp
std::pair
```

Preferred.

---

## Mixed Project

Follow the surrounding API.

Consistency is more important than personal preference.

---

# 5. QPair vs Custom Structure

Suppose:

```cpp
QPair<double, double> result;
```

Question:

```text
first  = ?

second = ?
```

Not obvious.

---

Instead:

```cpp
struct DoseResult
{
    double dose;
    double monitorUnits;
};
```

Now:

```cpp
DoseResult result;
```

Reading:

```cpp
result.dose;
```

is much clearer than:

```cpp
result.first;
```

---

# Readability Comparison

Poor:

```cpp
QPair<QString,int> patient;
```

```cpp
patient.first
```

What is `first`?

---

Better:

```cpp
struct Patient
{
    QString name;
    int id;
};
```

```cpp
patient.name
```

Much more descriptive.

---

# 6. Performance Considerations

Memory:

```cpp
QPair<int, int>
```

Conceptually:

```text
+----------------+

first

second

+----------------+
```

No heap allocation occurs unless one of the contained types allocates memory internally (for example, `QString`).

---

# Copy Cost

```cpp
QPair<QString, QString>
```

Copies both `QString` objects.

Fortunately:

`QString` is implicitly shared.

So:

```cpp
QPair<QString, QString> b = a;
```

usually performs only reference-count updates until modification.

---

# Move Cost

```cpp
QPair<QString, QString>
```

moves efficiently because `QString` supports move semantics.

---

# 7. ABI & Memory Layout

Conceptually:

```text
QPair<T1,T2>

↓

T1

↓

Padding (if required)

↓

T2
```

Padding depends on:

* Compiler
* Platform
* Alignment requirements

Example:

```cpp
QPair<char, int>
```

may include padding between `char` and `int`.

Never assume an exact binary layout across compilers or architectures.

---

# 8. Qt Source Code Usage

Historically, `QPair` appears in many Qt APIs and older codebases.

Examples include:

* Internal helper structures
* Temporary return values
* Algorithms
* Mapping functions

Modern Qt code also embraces standard library facilities where appropriate.

---

# 9. Medical TPS Examples

## Beam Name + Energy

```cpp
QPair<QString, double> beamInfo;
```

---

## Point Coordinates

```cpp
QPair<double, double> point;
```

---

## Better Design

Instead of:

```cpp
QPair<double, double>
```

Prefer:

```cpp
struct BeamInfo
{
    QString name;
    double energy;
};
```

or

```cpp
struct Point2D
{
    double x;
    double y;
};
```

The intent is immediately clear.

---

# 10. Qt 5.15 vs Qt 6.11

| Feature                | Qt 5.15               | Qt 6.11                                |
| ---------------------- | --------------------- | -------------------------------------- |
| `QPair` Available      | ✔                     | ✔                                      |
| `qMakePair()`          | ✔                     | ✔                                      |
| Move Semantics         | ✔                     | ✔                                      |
| Structured Bindings    | Compiler/Qt dependent | Fully supported in modern environments |
| Modern STL Integration | Good                  | Better                                 |

---

# 11. Best Practices

* Use `QPair` only for simple two-value relationships.
* Prefer structured bindings in C++17 and later.
* Prefer `std::pair` in generic C++ libraries.
* Use descriptive `struct`s for domain objects.
* Avoid nested `QPair` objects.
* Keep APIs expressive rather than relying on `first` and `second`.

---

# 12. Common Mistakes

* Returning complex business data in nested `QPair`s.
* Using `first` and `second` where meaningful names are needed.
* Assuming `QPair` is always better than a custom structure.
* Ignoring readability for future maintainers.

---

# 13. Interview Questions

## Easy

1. What is `QPair`?
2. How do you access its members?
3. What does `qMakePair()` do?

---

## Medium

1. Compare `QPair` and `std::pair`.
2. Explain structured bindings.
3. When should you prefer a custom `struct`?

---

## Hard

1. Describe the memory layout of `QPair`.
2. Discuss move semantics and copy costs.
3. Explain why nested `QPair`s are discouraged.

---

## Expert

1. Design an API returning two values. Would you use `QPair`, `std::pair`, or a custom `struct`? Justify your choice.
2. Discuss the trade-offs between generic pairs and domain-specific types in a large enterprise codebase.
3. Explain how API readability affects long-term maintainability.

---

# 14. Revision Notes

* `QPair` stores exactly two values.
* Copy and move behavior depend on the contained types.
* `qMakePair()` simplifies template deduction.
* Structured bindings improve readability.
* Prefer named `struct`s for business/domain objects.
* `std::pair` is generally preferred for modern generic C++ code.
* Follow existing project conventions when working in established codebases.

---

# 🏥 Production Recommendations

| Scenario                   | Recommended Choice     |
| -------------------------- | ---------------------- |
| Temporary two-value return | `QPair` or `std::pair` |
| Qt API compatibility       | `QPair`                |
| Generic C++ library        | `std::pair`            |
| Business object            | Custom `struct`        |
| TPS Beam Information       | `struct BeamInfo`      |
| Patient Record             | `struct Patient`       |

---

[⬅️ QSet](/QQSet.md)      |          [QSharedPointer ➡️](/QQSharedPointer.md)
---
## **License**
This project is licensed under the MIT License.

---

Happy Coding!


