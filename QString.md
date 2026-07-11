Excellent. We now begin one of the **largest and most important chapters** in the entire Qt course.

> If `QObject` is the **heart** of Qt and `QVariant` is the **universal container**, then **`QString` is the backbone of almost every Qt application**.

Every Qt developer writes `QString` thousands of times.

However, very few understand:

* Why Qt created `QString`
* Why it stores UTF-16 internally
* How implicit sharing works
* Why `QStringLiteral` is faster
* What `QStringView` does
* How conversions affect performance
* How Qt 6 improved string handling

A senior Qt developer should understand **both the API and the internal implementation**.

---

# Complete Qt Master Course (Qt 5.15 LTS → Qt 6.11)

# PART III — Qt Core

# Chapter 14 — QString (Complete Deep Dive)

**Part 1 – Fundamentals, Unicode, UTF Encodings, and Basic APIs**

> **Level:** Beginner → Intermediate → Advanced → Expert

---

# Chapter Objectives

After completing this chapter, you will understand:

* Why `QString` exists
* Unicode fundamentals
* UTF-8 vs UTF-16 vs UTF-32
* Internal architecture
* Memory layout
* Implicit sharing
* Basic APIs
* Construction
* Comparison
* Search
* Conversion
* Performance basics
* Qt 5.15 vs Qt 6.11

---

# Table of Contents

1. What is QString?
2. Why Qt Created QString
3. Unicode Fundamentals
4. UTF-8, UTF-16, UTF-32
5. Internal Architecture
6. Memory Layout
7. Creating QString
8. Basic Operations
9. Comparison APIs
10. Searching APIs
11. Conversion APIs
12. Implicit Sharing (Introduction)
13. Performance
14. Qt 5 vs Qt 6
15. Best Practices
16. Interview Questions
17. Revision Notes

---

# 1. What is QString?

## Definition

`QString` is Qt's Unicode string class.

Header:

```cpp
#include <QString>
```

Module:

```text
QtCore
```

---

Unlike C strings:

```cpp
char name[20];
```

or

```cpp
std::string
```

`QString` is designed for:

* Unicode
* Internationalization
* Cross-platform applications
* Efficient string handling
* Implicit sharing

---

# Why Not Use std::string?

A common interview question.

Qt was designed long before modern C++ string handling matured.

`QString` provided:

* Unicode support
* Rich APIs
* Efficient memory sharing
* Integration with Qt

Today, Qt supports both `QString` and `std::string`, but most Qt APIs use `QString`.

---

# 2. Why Qt Created QString

Imagine a global application.

English:

```text
Hello
```

Hindi:

```text
नमस्ते
```

Japanese:

```text
こんにちは
```

Arabic:

```text
مرحبا
```

Chinese:

```text
你好
```

A simple `char` array cannot reliably represent all these languages without agreeing on an encoding.

Qt needed a string class capable of representing Unicode consistently across platforms.

---

# 3. Unicode Fundamentals

## Character vs Encoding

Many beginners confuse these concepts.

Character:

```text
A
```

Unicode Code Point:

```text
U+0041
```

Encoding:

```text
UTF-8

UTF-16

UTF-32
```

---

Conceptual Diagram

```text
Character

↓

Unicode Code Point

↓

Encoding

↓

Bytes
```

Unicode defines **what** a character is.

UTF encodings define **how** it is stored.

---

# 4. UTF-8 vs UTF-16 vs UTF-32

## UTF-8

Variable length:

```text
A

↓

41
```

ASCII characters use one byte.

Other characters require multiple bytes.

Advantages:

* Compact for English.
* Dominant encoding on the web.
* Compatible with ASCII.

Disadvantages:

* Random indexing by character is more complex.

---

## UTF-16

Qt's internal representation for `QString`.

Conceptually:

```text
A

↓

0041
```

Most commonly used characters fit in one 16-bit code unit.

Some characters (such as many emoji and certain historic scripts) require **surrogate pairs** (two UTF-16 code units).

Advantages:

* Efficient for many languages.
* Good balance between size and indexing.

---

## UTF-32

Every code point uses 32 bits.

Advantages:

* Simple indexing by code point.

Disadvantages:

* Larger memory usage.

---

# Comparison

| Feature                    | UTF-8    | UTF-16          | UTF-32  |
| -------------------------- | -------- | --------------- | ------- |
| ASCII Size                 | 1 byte   | 2 bytes         | 4 bytes |
| Memory for English         | Best     | Larger          | Largest |
| Memory for East Asian text | Variable | Often efficient | Largest |
| Random Access by Code Unit | Moderate | Good            | Good    |

> **Important:** `QString::size()` counts UTF-16 code units, not necessarily user-perceived characters (graphemes). Emoji and combining characters may require more than one code unit.

---

# 5. Internal Architecture

Conceptually:

```text
QString

↓

Shared String Data

↓

UTF-16 Buffer
```

Unlike `std::string`, `QString` is optimized for Qt's Unicode model.

---

# Internal Memory Layout (Conceptual)

```text
QString

+---------------------------+

Pointer

↓

String Data

Length

Capacity

Reference Count

UTF-16 Buffer

+---------------------------+
```

The exact layout is implementation-specific and can change between Qt versions.

---

# Example

```cpp
QString text = "Qt";
```

Conceptually:

```text
QString

↓

Length = 2

↓

UTF-16

↓

Q

t
```

---

# 6. Creating QString

Default:

```cpp
QString text;
```

Empty string.

---

From C string:

```cpp
QString text("Qt");
```

---

From `std::string`

```cpp
std::string name = "Qt";

QString text =
    QString::fromStdString(name);
```

---

From UTF-8

```cpp
QString text =
    QString::fromUtf8("Hello");
```

---

From Latin-1

```cpp
QString text =
    QString::fromLatin1("Qt");
```

Use the constructor or dedicated conversion functions according to the source encoding.

---

# 7. Basic Operations

Concatenation:

```cpp
QString first = "Qt";

QString second = "6";

QString result =
    first + second;
```

Output:

```text
Qt6
```

---

Append

```cpp
QString text = "Qt";

text.append(" Creator");
```

---

Prepend

```cpp
text.prepend("Modern ");
```

---

Insert

```cpp
text.insert(2, "--");
```

---

Remove

```cpp
text.remove(0, 2);
```

---

Replace

```cpp
text.replace("Qt",
             "Qt6");
```

---

# 8. Comparison

Equality:

```cpp
if (a == b)
{
}
```

---

Case-insensitive:

```cpp
a.compare(b,
          Qt::CaseInsensitive);
```

---

Lexicographical comparison:

```cpp
int result =
    a.compare(b);
```

Result:

* Negative
* Zero
* Positive

Similar to `strcmp()`.

---

# 9. Searching APIs

Contains

```cpp
text.contains("Qt");
```

---

Starts With

```cpp
text.startsWith("Qt");
```

---

Ends With

```cpp
text.endsWith(".cpp");
```

---

Index Of

```cpp
text.indexOf("Qt");
```

Returns the first matching index or `-1`.

---

Last Index Of

```cpp
text.lastIndexOf("Qt");
```

---

# 10. Conversion APIs

To Integer

```cpp
int value =
    text.toInt();
```

Safer version:

```cpp
bool ok = false;

int value =
    text.toInt(&ok);
```

---

To Double

```cpp
double d =
    text.toDouble();
```

---

To UTF-8

```cpp
QByteArray bytes =
    text.toUtf8();
```

---

To Std String

```cpp
std::string s =
    text.toStdString();
```

---

From Std String

```cpp
QString text =
    QString::fromStdString(s);
```

---

# 11. Implicit Sharing (Introduction)

One of `QString`'s biggest advantages.

Example:

```cpp
QString a = "Qt";

QString b = a;
```

Initially:

```text
QString A

↓

Shared Data

↑

QString B
```

No character data is copied.

---

Modify:

```cpp
b.append("6");
```

Now:

```text
QString A

↓

Qt

QString B

↓

Qt6
```

A copy is made only when modification occurs.

This is known as **Copy-on-Write (CoW)**.

We'll explore this in detail in **Chapter 108 – Implicit Sharing**.

---

# 12. Performance

## Fast

* Copying `QString`
* Passing by `const QString &`
* Read-only operations

---

## Slower

* Repeated concatenation in loops without reserving capacity.
* Frequent encoding conversions.
* Unnecessary temporary strings.

---

## Reserve Capacity

```cpp
QString text;

text.reserve(1000);
```

Useful when building large strings incrementally.

---

# 13. Qt 5.15 vs Qt 6.11

| Feature                | Qt 5.15   | Qt 6.11                 |
| ---------------------- | --------- | ----------------------- |
| UTF-16 Storage         | ✔         | ✔                       |
| Implicit Sharing       | ✔         | ✔                       |
| `QStringView` Support  | Available | Expanded and encouraged |
| `QStringLiteral`       | ✔         | ✔                       |
| Modern C++ Integration | Good      | Better                  |

Qt 6 encourages non-owning string views (`QStringView`, `QLatin1StringView`, etc.) to reduce unnecessary allocations.

---

# 14. Best Practices

* Pass `QString` by `const QString&` for read-only parameters.
* Use `QStringLiteral()` for compile-time string literals.
* Prefer `QStringView` when you only need to inspect existing string data.
* Reserve capacity when building very large strings.
* Be aware of the source encoding when converting from `char*`.

---

# 15. Common Mistakes

* Assuming `QString::size()` equals the number of user-visible characters.
* Repeatedly converting between `QString` and `std::string`.
* Ignoring conversion failures with `toInt()` and similar APIs.
* Using the wrong source encoding.
* Excessive string concatenation in performance-critical loops.

---

# 16. Interview Questions

## Easy

1. What is `QString`?
2. Why does Qt use UTF-16 internally?
3. How do you convert a `QString` to `std::string`?

## Medium

1. Explain implicit sharing in `QString`.
2. Compare UTF-8 and UTF-16.
3. What does `QString::compare()` return?

## Hard

1. Describe the conceptual memory layout of `QString`.
2. Explain why `QStringLiteral()` can improve performance.
3. Discuss how Unicode affects string indexing.

## Expert

1. Compare `QString`, `std::string`, and `std::u16string` in a cross-platform Qt application.
2. Design a high-performance text-processing pipeline using Qt string classes.
3. Analyze the trade-offs of UTF-16 as the internal storage format.

---

# 17. Revision Notes

* `QString` is Qt's Unicode string class.
* It stores text internally using UTF-16 code units.
* It supports efficient implicit sharing.
* It integrates deeply with the Qt framework.
* Use the appropriate conversion API for the source encoding.
* Prefer passing by `const QString&` and use `QStringLiteral()` where appropriate.

---

# End of Chapter 14 — Part 1

You now understand the foundations of `QString`, Unicode, and the most commonly used APIs.

## Next Section

In **Chapter 14 — Part 2**, we will cover advanced topics including:

