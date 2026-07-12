> **Senior Qt Developer Insight**
>
> A beginner uses `QVariant` because an API requires it.
>
> An experienced Qt developer understands **why** `QVariant` exists, how it stores values, and how to extend it with custom types.

---

# Chapter 13 — QVariant (Complete Deep Dive)

---

# 1. What is QVariant?

## Definition

`QVariant` is a **generic container** capable of storing values of many different types.

Header:

```cpp
#include <QVariant>
```

Module:

```text
QtCore
```

---

Without `QVariant`:

```cpp
int age = 25;

QString name = "Alice";

double salary = 50000.0;
```

Each variable has a fixed type.

---

With `QVariant`:

```cpp
QVariant value;

value = 25;

value = "Alice";

value = 50000.0;
```

The same variable can store different value types over its lifetime.

---

# Why is this Useful?

Many Qt APIs need to work with values whose types are not known until runtime.

Examples:

* Database records
* Model/View data
* JSON values
* Settings
* Dynamic properties

---

# 2. Why Qt Needs QVariant

Imagine implementing a table model.

One column contains:

```text
Name
```

Another:

```text
Age
```

Another:

```text
Salary
```

The data types differ:

```text
QString

int

double
```

Instead of creating separate APIs for each type, Qt uses:

```cpp
QVariant
```

Every value is returned through a common interface.

---

# Example

```cpp
QVariant value;

value = QString("Alice");

value = 25;

value = true;
```

---

# Conceptual Architecture

```text
             QVariant

                 │

--------------------------------------

int

double

QString

QDate

QTime

QObject*

Custom Type
```

---

# 3. Internal Architecture

Conceptually:

```text
+----------------------------+

Type ID

Storage

Flags

+----------------------------+
```

`QVariant` stores:

* The type of the value.
* The value itself (or a reference to it, depending on size and implementation).
* Metadata needed for construction, destruction, and copying.

It relies heavily on the **Qt Meta-Type System (`QMetaType`)**.

---

# Example

```cpp
QVariant value = 25;
```

Conceptually:

```text
QVariant

↓

Type = int

↓

Value = 25
```

Later:

```cpp
value = QString("Qt");
```

Conceptually:

```text
QVariant

↓

Type = QString

↓

Value = "Qt"
```

---

# 4. Creating QVariant Objects

Default:

```cpp
QVariant value;
```

The variant is invalid.

Check:

```cpp
if (!value.isValid())
{
    // No value stored
}
```

---

Construct from an integer:

```cpp
QVariant value(100);
```

---

Construct from a string:

```cpp
QVariant value(QString("Qt"));
```

---

Construct from a boolean:

```cpp
QVariant value(true);
```

---

# 5. Supported Built-in Types

`QVariant` supports many built-in Qt and C++ types.

Examples:

| Type        | Supported         |
| ----------- | ----------------- |
| int         | ✔                 |
| double      | ✔                 |
| bool        | ✔                 |
| QString     | ✔                 |
| QByteArray  | ✔                 |
| QDate       | ✔                 |
| QTime       | ✔                 |
| QDateTime   | ✔                 |
| QColor      | ✔ (Qt GUI module) |
| QPoint      | ✔                 |
| QSize       | ✔                 |
| QRect       | ✔                 |
| QStringList | ✔                 |

Support depends on the relevant Qt modules being available.

---

# Query the Stored Type

```cpp
QVariant value = 42;

qDebug() << value.typeName();
```

Possible output:

```text
int
```

In Qt 6, `QMetaType` APIs are preferred for detailed type information.

---

# 6. Type Conversion

Retrieve as an integer:

```cpp
QVariant value = 100;

int number = value.toInt();
```

---

Retrieve as a string:

```cpp
QVariant value = QString("Qt");

QString text = value.toString();
```

---

Convert integer to string:

```cpp
QVariant value = 100;

QString text = value.toString();
```

Output:

```text
100
```

Qt performs many common conversions automatically.

---

# Failed Conversion

Example:

```cpp
QVariant value("Hello");

int x = value.toInt();
```

The conversion cannot interpret `"Hello"` as an integer, so the result is `0`.

A safer approach is:

```cpp
bool ok = false;
int x = value.toInt(&ok);
```

Then:

```cpp
if (ok)
{
    // Conversion succeeded
}
```

---

# 7. QMetaType

`QVariant` depends on **`QMetaType`**.

Relationship:

```text
QVariant

↓

QMetaType

↓

Type Information
```

`QMetaType` knows:

* Type name
* Size
* Construction
* Destruction
* Copying
* Moving (where supported)

We'll study `QMetaType` in more depth in later chapters.

---

# 8. Custom Types

Suppose:

```cpp
struct Patient
{
    QString name;
    int age;
};
```

To store it in `QVariant`:

Declare the type:

```cpp
Q_DECLARE_METATYPE(Patient)
```

Create:

```cpp
Patient patient;

QVariant value =
    QVariant::fromValue(patient);
```

Retrieve:

```cpp
Patient p =
    value.value<Patient>();
```

For queued signal-slot connections or runtime type lookup, you may also need:

```cpp
qRegisterMetaType<Patient>();
```

---

# 9. Internal Memory Layout

Conceptually:

```text
QVariant

+-----------------------------+

Type ID

Storage

MetaType Pointer

Flags

+-----------------------------+
```

For small types, the value may be stored directly inside the variant.

For larger types, an internal allocation or shared data may be used depending on the type and Qt implementation.

---

# Example

```cpp
QVariant value(123);
```

Conceptually:

```text
Type

↓

int

Value

↓

123
```

---

# 10. Implicit Sharing

Many Qt value classes stored inside a `QVariant` use **implicit sharing**.

Example:

```cpp
QVariant a =
    QString("Qt");

QVariant b = a;
```

Initially:

```text
QVariant A

↓

QString Data

↑

QVariant B
```

Both variants share the same string data.

---

Modify:

```cpp
b = QString("Qt6");
```

Now:

```text
A

↓

"Qt"

B

↓

"Qt6"
```

A detach (copy-on-write) occurs only when modification is necessary.

This minimizes unnecessary copying.

---

# 11. Performance

## Fast Operations

* Store integers.
* Store booleans.
* Store pointers (where appropriate).
* Copy implicitly shared Qt value types.

---

## Slower Operations

* Repeated type conversions.
* Large custom types by value.
* Frequent boxing and unboxing in tight loops.

---

## Recommendation

If the type is known at compile time, use the concrete type directly.

Use `QVariant` only when type flexibility is required.

---

# 12. Qt 5.15 vs Qt 6.11

| Feature                | Qt 5.15 | Qt 6.11       |
| ---------------------- | ------- | ------------- |
| QVariant               | ✔       | ✔             |
| QMetaType Integration  | ✔       | Improved APIs |
| Implicit Sharing       | ✔       | ✔             |
| Custom Types           | ✔       | ✔             |
| Modern C++ Integration | Good    | Better        |

Qt 6 modernized many `QMetaType` APIs while preserving the overall programming model of `QVariant`.

---

# 13. Production Usage

`QVariant` appears throughout Qt.

## Model/View

```cpp
QVariant data(const QModelIndex &index,
              int role) const;
```

Every item returns a `QVariant`.

---

## SQL

```cpp
QSqlQuery

↓

QVariant
```

Database values are retrieved as variants.

---

## JSON

`QJsonValue::toVariant()` and `QJsonValue::fromVariant()` provide interoperability.

---

## QSettings

Settings values are stored and retrieved using `QVariant`.

---

## Dynamic Properties

```cpp
object->setProperty("Version",
                    QVariant("6.11"));
```

---

# 14. Best Practices

* Use `QVariant` when runtime type flexibility is required.
* Prefer direct C++ types when the type is known.
* Check conversion success when reading external data.
* Register custom types correctly.
* Avoid repeatedly converting between types inside performance-critical loops.

---

# 15. Common Mistakes

* Assuming every conversion succeeds.
* Storing large objects unnecessarily by value.
* Forgetting `Q_DECLARE_METATYPE` for custom types.
* Overusing `QVariant` where a concrete type is sufficient.
* Ignoring conversion failures.

---

# 16. Interview Questions

## Easy

1. What is `QVariant`?
2. Why was `QVariant` introduced?
3. How do you retrieve an integer from a `QVariant`?

## Medium

1. Explain the relationship between `QVariant` and `QMetaType`.
2. How do you store a custom type in a `QVariant`?
3. What does `isValid()` indicate?

## Hard

1. Describe the conceptual internal architecture of `QVariant`.
2. Explain how implicit sharing affects `QVariant` performance.
3. Compare `QVariant` with `std::variant`.

## Expert

1. Design a plugin API that exchanges data using `QVariant`.
2. Discuss the trade-offs between `QVariant`, `std::variant`, and templates.
3. Explain how `QVariant` supports Qt's Model/View architecture.

---

# 17. Revision Notes

* `QVariant` is Qt's generic value container.
* It stores values together with runtime type information.
* It relies on `QMetaType` for type management.
* Many Qt APIs use `QVariant` to support heterogeneous data.
* Custom types require `Q_DECLARE_METATYPE` and sometimes `qRegisterMetaType()`.
* Many Qt value types benefit from implicit sharing when stored in a `QVariant`.
* Prefer concrete types when compile-time type information is available.

---

[⬅️ MOC Internals](/QMOCInternals.md)      |          [QString  ➡️](/QString.md)
---
## **License**
This project is licensed under the MIT License.

---

Happy Coding!


