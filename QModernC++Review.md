# Chapter 6 — Modern C++ Review

---

# 1. Introduction

Qt is written in C++, and modern versions of Qt make extensive use of modern C++ language features.

Understanding these features will help you:

* Write safer code.
* Avoid memory leaks.
* Improve performance.
* Read Qt source code.
* Understand modern Qt APIs.

---

# 2. Why Modern C++ Matters in Qt

Consider this signal-slot connection:

```cpp
connect(button, &QPushButton::clicked,
        this, [this]()
{
    saveFile();
});
```

To understand this code, you need to know:

* Function pointers
* Lambdas
* Object lifetime
* Capture lists

Without a good C++ foundation, this syntax can seem confusing.

---

# 3. RAII (Resource Acquisition Is Initialization)

## What is RAII?

RAII is a C++ programming idiom where the lifetime of a resource is tied to the lifetime of an object.

When the object is created:

* It acquires a resource.

When the object is destroyed:

* It releases the resource automatically.

---

## Why RAII?

Without RAII:

```cpp
FILE* fp = fopen("data.txt", "r");

if (!fp)
    return;

// ...

fclose(fp);
```

If the function returns early or throws an exception before `fclose()`, the file remains open.

---

With RAII:

```cpp
std::ifstream file("data.txt");

// File automatically closes when `file` goes out of scope.
```

No manual cleanup is required.

---

## RAII in Qt

Qt uses RAII in many places.

Example:

```cpp
QFile file("data.txt");

if (file.open(QIODevice::ReadOnly))
{
    // Read file
}

// QFile destructor closes the file automatically if it is open.
```

---

## Scope Example

```cpp
{
    QFile file("data.txt");
    file.open(QIODevice::ReadOnly);

} // Destructor runs here
```

The resource is released automatically.

---

## Advantages

* Automatic cleanup.
* Exception safety.
* Reduced memory leaks.
* Cleaner code.

---

## Disadvantages

* Requires understanding object lifetime.
* Improper ownership design can still cause issues.

---

## Best Practices

* Prefer automatic (stack) objects when possible.
* Encapsulate resources inside objects.
* Avoid manual cleanup when RAII is available.

---

## Interview Question

**Q:** What problem does RAII solve?

**A:** It ensures that resources are automatically released when objects go out of scope, preventing resource leaks and making code exception-safe.

---

# 4. Smart Pointers

Traditional C++ often uses raw pointers:

```cpp
MyClass* ptr = new MyClass;

// ...

delete ptr;
```

Problems:

* Memory leaks.
* Double deletion.
* Ownership confusion.

---

Modern C++ provides smart pointers.

## `std::unique_ptr`

```cpp
auto ptr = std::make_unique<MyClass>();
```

Characteristics:

* Single owner.
* Automatically deletes the object.
* Cannot be copied.
* Can be moved.

---

## `std::shared_ptr`

```cpp
auto ptr = std::make_shared<MyClass>();
```

Characteristics:

* Multiple owners.
* Reference counting.
* Object destroyed when last owner is destroyed.

---

## `std::weak_ptr`

A non-owning reference to a `std::shared_ptr`.

Useful to break ownership cycles.

---

## Qt Smart Pointers

Qt also provides its own smart pointers (covered in later chapters):

* `QSharedPointer`
* `QScopedPointer`
* `QPointer`
* `QWeakPointer`

These integrate well with Qt APIs and the `QObject` model.

---

## Choosing the Right Pointer

| Situation               | Recommendation                                         |
| ----------------------- | ------------------------------------------------------ |
| Automatic object        | Stack allocation                                       |
| Single ownership        | `std::unique_ptr`                                      |
| Shared ownership        | `std::shared_ptr`                                      |
| Observing shared object | `std::weak_ptr`                                        |
| QObject with parent     | Parent-child ownership (often no smart pointer needed) |

> We'll discuss the interaction between smart pointers and `QObject` in Chapters 22–25.

---

# 5. Move Semantics

## The Problem

Copying large objects can be expensive.

```cpp
std::vector<int> data = createLargeVector();
```

If copied unnecessarily, performance suffers.

---

## Move Semantics

Move semantics transfer ownership of resources instead of copying them.

Conceptually:

```text
Object A
    │
    ▼
[Large Buffer]

↓

Move

↓

Object B
    │
    ▼
[Large Buffer]

Object A no longer owns it.
```

---

## Example

```cpp
std::string a = "Hello";

std::string b = std::move(a);
```

The internal buffer is moved to `b`.

After the move:

* `b` contains the data.
* `a` remains valid but its value is unspecified.

---

## Why It Matters in Qt

Many Qt classes support efficient move operations in modern Qt versions.

Move semantics reduce unnecessary allocations and copies.

---

## Best Practice

Only use `std::move()` when you are finished using the object.

---

## Common Mistake

Using an object as if it still contains its original value after it has been moved from.

---

# 6. Lambda Expressions

Lambdas allow you to define anonymous functions inline.

Example:

```cpp
auto add = [](int a, int b)
{
    return a + b;
};

qDebug() << add(3, 4);
```

Output:

```text
7
```

---

## Lambda Capture

```cpp
int value = 10;

auto print = [value]()
{
    qDebug() << value;
};
```

The lambda captures a copy of `value`.

---

## Capture by Reference

```cpp
int value = 10;

auto increment = [&value]()
{
    ++value;
};
```

Changes affect the original variable.

---

## Lambdas in Qt

Very common for signal-slot connections.

```cpp
connect(button, &QPushButton::clicked,
        this,
        [this]()
{
    saveFile();
});
```

Lambdas often replace the need for small slot functions.

---

## Best Practices

* Capture only what you need.
* Avoid capturing large objects by value unless necessary.
* Be careful when capturing `this`; ensure the object's lifetime is valid.

---

# 7. `constexpr`

`constexpr` allows certain values and functions to be evaluated at compile time.

Example:

```cpp
constexpr int bufferSize = 1024;
```

---

Function example:

```cpp
constexpr int square(int x)
{
    return x * x;
}
```

If called with compile-time constants, the result can be computed during compilation.

---

## Benefits

* Improved performance.
* Compile-time validation.
* Better optimization opportunities.

---

# 8. `enum class`

Traditional enums:

```cpp
enum Color
{
    Red,
    Green,
    Blue
};
```

Problems:

* Enumerators pollute the surrounding namespace.
* Implicit conversion to integers.

---

Modern C++:

```cpp
enum class Color
{
    Red,
    Green,
    Blue
};
```

Usage:

```cpp
Color color = Color::Red;
```

Advantages:

* Scoped names.
* Strong type safety.
* Fewer naming conflicts.

---

# 9. Templates

Templates enable generic programming.

Example:

```cpp
template<typename T>
T maximum(T a, T b)
{
    return (a > b) ? a : b;
}
```

Usage:

```cpp
maximum(3, 7);
maximum(2.5, 4.1);
```

The compiler generates the appropriate function for each type.

Templates are widely used throughout both the C++ Standard Library and Qt.

---

# 10. `auto`

The compiler deduces the variable's type.

Example:

```cpp
auto number = 42;
```

Equivalent to:

```cpp
int number = 42;
```

---

Useful with iterators:

```cpp
auto it = myMap.begin();
```

This avoids long type names.

---

## Best Practices

Use `auto` when:

* The type is obvious from the initializer.
* Iterator or template types are verbose.

Avoid `auto` if it makes the code less readable.

---

# 11. `nullptr`

Modern C++ replaces `NULL` and `0` with `nullptr`.

Example:

```cpp
QObject* object = nullptr;
```

Advantages:

* Type-safe.
* Avoids overload ambiguities.
* Preferred in modern C++.

---

# 12. `override`

Ensures a virtual function actually overrides a base-class function.

Example:

```cpp
class Base
{
public:
    virtual void draw();
};

class Derived : public Base
{
public:
    void draw() override;
};
```

If the signature doesn't match, the compiler reports an error.

Always use `override` when overriding virtual functions.

---

# 13. `final`

Prevents further overriding or inheritance.

Example:

```cpp
class Widget final
{
};
```

No class may derive from `Widget`.

Or:

```cpp
class Base
{
public:
    virtual void paint() final;
};
```

Derived classes cannot override `paint()`.

---

# 14. Qt 5.15 vs Qt 6.11

| Feature        | Qt 5.15 | Qt 6.11                        |
| -------------- | ------- | ------------------------------ |
| RAII           | ✔       | ✔                              |
| Smart Pointers | ✔       | ✔                              |
| Move Semantics | ✔       | More widely adopted internally |
| Lambdas        | ✔       | ✔                              |
| `constexpr`    | ✔       | Used more extensively          |
| `enum class`   | ✔       | ✔                              |
| Templates      | ✔       | ✔                              |
| `auto`         | ✔       | ✔                              |
| `nullptr`      | ✔       | ✔                              |
| `override`     | ✔       | ✔                              |
| `final`        | ✔       | ✔                              |

Qt 6 generally embraces modern C++ more fully, but these language features are available in both Qt 5.15 and Qt 6.11.

---

# 15. Best Practices

* Prefer RAII over manual resource management.
* Use stack objects where practical.
* Prefer `nullptr` over `NULL`.
* Mark overrides with `override`.
* Use `enum class` instead of traditional enums.
* Use lambdas for concise callbacks.
* Avoid unnecessary copies; take advantage of move semantics.
* Use `auto` judiciously to improve readability.

---

# 16. Common Mistakes

* Mixing raw pointers with unclear ownership.
* Overusing `std::move()`.
* Capturing dangling references in lambdas.
* Forgetting `override` on overridden virtual functions.
* Using `NULL` instead of `nullptr`.
* Overusing `auto` where the type becomes unclear.

---

# 17. Interview Questions

## Easy

1. What is RAII?
2. Why is `nullptr` preferred over `NULL`?
3. What is a lambda expression?

## Medium

1. Compare `std::unique_ptr` and `std::shared_ptr`.
2. Explain move semantics.
3. What are the benefits of `enum class`?

## Hard

1. Explain how RAII improves exception safety.
2. Discuss the relationship between move semantics and performance.
3. Describe when to use `auto` and when to avoid it.

## Expert

1. Design an ownership strategy for a large Qt application using `QObject` and smart pointers.
2. Explain why Qt's parent-child ownership model and RAII complement each other.
3. Compare C++ smart pointers with Qt's ownership mechanisms and discuss appropriate use cases.

---

# 18. Revision Notes

* RAII ties resource lifetime to object lifetime.
* Smart pointers automate memory management.
* Move semantics transfer resources efficiently.
* Lambdas provide concise anonymous functions.
* `constexpr` enables compile-time computation.
* `enum class` offers scoped, type-safe enumerations.
* Templates support generic programming.
* `auto` reduces verbosity.
* `nullptr` is the modern null pointer literal.
* `override` and `final` improve correctness and maintainability.

---
[⬅️ QFirst Qt Application](/QFirstQtApplication.md)      |          [STL for Qt Developers ➡️](/QSTLforQtDevelopers.md)
---

## **License**
This project is licensed under the MIT License.

---

Happy Coding!

