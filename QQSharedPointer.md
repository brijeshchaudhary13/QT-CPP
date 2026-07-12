> **Senior Qt Architect Insight**
>
> Before using `QSharedPointer`, always ask:
>
> **"Do I really need shared ownership?"**
>
> Many Qt objects already have ownership managed by the **QObject parent-child hierarchy**, making `QSharedPointer` unnecessary or even inappropriate in those cases.

---

# Chapter 22 — QSharedPointer (Complete Deep Dive)

---

# 1. Why Smart Pointers?

Traditional C++:

```cpp
Patient* patient = new Patient();
```

Later:

```cpp
delete patient;
```

Problems:

* Forgot `delete`
* Deleted twice
* Used after deletion
* Exception before `delete`
* Complex ownership

Example:

```cpp
Patient* p = new Patient();

throw std::runtime_error("Error");

// delete never executed
```

Memory leak.

---

# 2. What is QSharedPointer?

## Definition

`QSharedPointer<T>` is a **reference-counted smart pointer** that provides **shared ownership** of an object.

Header:

```cpp
#include <QSharedPointer>
```

Module:

```text
QtCore
```

Example:

```cpp
QSharedPointer<Patient> patient(
    new Patient);
```

Multiple smart pointers can own the same object.

The object is destroyed automatically when the **last owner** goes away.

---

# Concept

```text
Object

↑

Shared Pointer A

↑

Shared Pointer B

↑

Shared Pointer C
```

All three own the same object.

---

# 3. Ownership Models

## Raw Pointer

```text
Pointer

↓

Object
```

No automatic ownership.

---

## Unique Ownership

```text
One Owner

↓

Object
```

Example:

```cpp
std::unique_ptr
```

---

## Shared Ownership

```text
Owner A

↓

Object

↑

Owner B

↑

Owner C
```

Used by:

```cpp
QSharedPointer
```

---

# 4. Reference Counting

Suppose:

```cpp
QSharedPointer<Patient> p1(
    new Patient);
```

Reference count:

```text
1
```

Copy:

```cpp
QSharedPointer<Patient> p2 = p1;
```

Reference count:

```text
2
```

Another copy:

```cpp
QSharedPointer<Patient> p3 = p1;
```

Reference count:

```text
3
```

Destroy:

```cpp
p2.clear();
```

Reference count:

```text
2
```

Destroy:

```cpp
p1.clear();
```

Reference count:

```text
1
```

Destroy:

```cpp
p3.clear();
```

Reference count:

```text
0

↓

Delete Object
```

---

# Lifecycle Diagram

```text
Create Object
      │
      ▼
Reference Count = 1
      │
      ▼
Copy Pointer
      │
      ▼
Reference Count++
      │
      ▼
Destroy Pointer
      │
      ▼
Reference Count--
      │
      ▼
Reference Count == 0 ?
      │
     Yes
      │
      ▼
Delete Object
```

---

# 5. Internal Architecture

Conceptually:

```text
QSharedPointer
        │
        ▼
Control Block
        │
 ┌──────┴──────┐
 │             │
Ref Count   Managed Object
```

The control block stores bookkeeping information such as the reference count.

---

# Memory Layout

Conceptually:

```text
QSharedPointer
      │
      ▼
+------------------------+
| Object Pointer         |
| Control Block Pointer  |
+------------------------+

Control Block
+------------------------+
| Reference Count        |
| Deleter                |
+------------------------+

Managed Object
+------------------------+
| Patient                |
+------------------------+
```

The exact implementation is internal to Qt and may vary.

---

# 6. Creating QSharedPointer

Basic

```cpp
QSharedPointer<Patient> patient(
    new Patient);
```

---

Preferred Factory

```cpp
auto patient =
    QSharedPointer<Patient>::create();
```

Advantages:

* Simpler syntax
* Exception-safe construction
* Recommended for new code

---

# Copy

```cpp
QSharedPointer<Patient> p2 = patient;
```

Reference count increases.

---

# Assignment

```cpp
QSharedPointer<Patient> p3;

p3 = patient;
```

Now both share ownership.

---

# 7. Common APIs

## data()

Returns the raw pointer.

```cpp
Patient* raw =
    patient.data();
```

Use carefully. The raw pointer does **not** own the object.

---

## clear()

```cpp
patient.clear();
```

Releases this ownership reference.

---

## isNull()

```cpp
if (patient.isNull())
{
}
```

Checks whether the smart pointer is empty.

---

## reset()

```cpp
patient.reset();
```

Releases ownership of the current object.

---

## operator->

```cpp
patient->setName("Alice");
```

Works like a normal pointer.

---

## operator*

```cpp
(*patient).setAge(25);
```

Dereferences the managed object.

---

# 8. Object Lifetime

Example:

```cpp
auto patient =
    QSharedPointer<Patient>::create();
```

Pass to another object:

```cpp
database.save(patient);
viewer.show(patient);
report.generate(patient);
```

Ownership:

```text
Database

↓

Patient

↑

Viewer

↑

Report
```

The patient remains alive until **all** owners release it.

---

# 9. Performance

Advantages:

* Automatic deletion
* Exception safety
* Clear ownership semantics

Costs:

* Reference counting overhead
* Atomic operations for thread-safe reference count updates
* Additional memory for the control block

For most GUI and business applications, the overhead is small compared to the benefits.

---

# 10. Qt 5.15 vs Qt 6.11

| Feature                        | Qt 5.15 | Qt 6.11 |
| ------------------------------ | ------- | ------- |
| `QSharedPointer`               | ✔       | ✔       |
| Thread-safe reference counting | ✔       | ✔       |
| `create()`                     | ✔       | ✔       |
| API                            | Stable  | Stable  |

There is **no major conceptual difference** between Qt 5.15 and Qt 6.11 for `QSharedPointer`.

---

# 11. QObject Considerations

A critical rule.

Avoid combining `QObject` parent ownership with `QSharedPointer` ownership for the **same object**.

Incorrect:

```cpp
QWidget* parent = new QWidget;

auto button =
    QSharedPointer<QPushButton>::create(parent);
```

Now there are two ownership systems:

* `QObject` parent-child
* `QSharedPointer`

This can lead to double deletion or undefined behavior.

### General Guideline

* Use **parent-child ownership** for `QObject` trees (widgets, dialogs, layouts, etc.).
* Use `QSharedPointer` primarily for non-`QObject` data objects or carefully designed shared ownership scenarios.

---

# 12. Best Practices

* Prefer `QSharedPointer::create()`.
* Use `QSharedPointer` only when ownership is genuinely shared.
* Pass by `const QSharedPointer<T>&` when you don't need to take ownership.
* Avoid unnecessary copying of smart pointers.
* Do not mix ownership models without careful design.

---

# 13. Common Mistakes

* Using `QSharedPointer` for every object.
* Mixing it with `QObject` parent ownership.
* Calling `delete` on the raw pointer returned by `data()`.
* Creating multiple unrelated `QSharedPointer`s from the same raw pointer.
* Using shared ownership where unique ownership is sufficient.

---

# 14. Interview Questions

## Easy

1. What is `QSharedPointer`?
2. What is reference counting?
3. When is the object destroyed?

---

## Medium

1. Explain shared ownership.
2. What is the purpose of the control block?
3. Why should `QSharedPointer::create()` be preferred?

---

## Hard

1. Describe the conceptual memory layout.
2. Explain the lifecycle of a `QSharedPointer`.
3. Compare `QSharedPointer` and `std::shared_ptr`.

---

## Expert

1. Design a shared image cache for a Treatment Planning System using `QSharedPointer`.
2. Explain why mixing `QObject` parent ownership and `QSharedPointer` is dangerous.
3. Discuss the performance implications of atomic reference counting in multithreaded applications.

---

# 15. Revision Notes

* `QSharedPointer` implements shared ownership.
* Ownership is managed through reference counting.
* The object is destroyed automatically when the last owner releases it.
* `QSharedPointer::create()` is the preferred construction method.
* A control block stores the reference count and deletion information.
* Avoid using `QSharedPointer` with `QObject` parent-child ownership for the same object.

---

# 🏥 Production Examples

| Use Case                            | Recommended                     |
| ----------------------------------- | ------------------------------- |
| Shared DICOM Image                  | `QSharedPointer<Image>`         |
| Dose Matrix                         | `QSharedPointer<DoseMatrix>`    |
| Beam Model                          | `QSharedPointer<BeamModel>`     |
| Patient Data Object (non-`QObject`) | `QSharedPointer<Patient>`       |
| Shared Configuration Object         | `QSharedPointer<Configuration>` |

---

Excellent. This is one of the **most important chapters in the entire Qt Core course**.

If you truly understand this chapter, you will understand **how large enterprise Qt applications manage memory safely**.

Many real-world bugs in Qt applications come from misunderstanding:

* Reference counting
* Cyclic references
* Weak pointers
* QObject ownership
* Thread-safe smart pointers
* Lifetime management

This chapter covers what experienced Qt developers discuss during architecture reviews.

---

# 1. Internal Reference Counting

Every `QSharedPointer` manages two conceptual pieces:

```text
Managed Object

↓

Patient
```

and

```text
Control Block

↓

Reference Count

↓

Weak Count

↓

Deleter
```

Conceptually:

```text
QSharedPointer
        │
        ▼
+----------------------+
| Object Pointer       |
| Control Block Ptr    |
+----------------------+
             │
             ▼
+----------------------+
| Strong Count         |
| Weak Count           |
| Deleter              |
+----------------------+
             │
             ▼
+----------------------+
| Patient Object       |
+----------------------+
```

---

# Strong Reference Count

Example:

```cpp
auto p1 =
    QSharedPointer<Patient>::create();
```

Count:

```text
1
```

Copy:

```cpp
auto p2 = p1;
```

Count:

```text
2
```

Another copy:

```cpp
auto p3 = p1;
```

Count:

```text
3
```

Destroy:

```cpp
p3.clear();
```

Count:

```text
2
```

Eventually:

```text
1

↓

0

↓

Delete Object
```

---

# Weak Count

Weak references do **not** own the object.

They only observe it.

```text
QSharedPointer

↓

Strong Count

----------------

QWeakPointer

↓

Weak Count
```

When the strong count becomes zero:

```text
Delete Managed Object
```

The control block remains alive until all weak pointers are also gone.

---

# 2. Thread Safety

A common interview question:

> **Is `QSharedPointer` thread-safe?**

The answer requires precision.

### Thread-safe reference counting

The internal reference counting operations are thread-safe.

Example:

```cpp
QSharedPointer<Image> img = ...;

Thread A:
auto copy1 = img;

Thread B:
auto copy2 = img;
```

Incrementing and decrementing the reference count is synchronized internally.

---

### The managed object is **not** automatically thread-safe

```cpp
img->setPixel(...);
```

If two threads modify the same object concurrently:

```text
Thread A

↓

Modify

------------

Thread B

↓

Modify
```

This is a data race unless you synchronize access yourself.

Use:

* `QMutex`
* `QReadWriteLock`
* Other synchronization mechanisms

to protect shared mutable state.

---

# 3. Custom Deleters

Sometimes an object cannot be destroyed with a simple:

```cpp
delete object;
```

Example:

```cpp
FILE* file = fopen(...);
```

Needs:

```cpp
fclose(file);
```

You can provide a custom deleter.

Example:

```cpp
QSharedPointer<FILE> file(
    fopen("data.txt", "r"),
    [](FILE* f)
    {
        if (f)
            fclose(f);
    });
```

Other examples:

* Socket handles
* GPU resources
* OpenGL objects
* Operating system handles

---

# 4. Cyclic References

This is one of the most important topics.

Suppose:

```cpp
class Patient
{
public:
    QSharedPointer<Report> report;
};
```

and

```cpp
class Report
{
public:
    QSharedPointer<Patient> patient;
};
```

Ownership graph:

```text
Patient

↓

Report

↑

Patient
```

Reference counts:

```text
Patient

Count = 1

↓

Report

Count = 1

↑
```

Neither count reaches zero.

Memory leak.

---

# Why?

Destroy:

```cpp
patient.clear();
```

Patient still owned by Report.

Destroy:

```cpp
report.clear();
```

Report still owned by Patient.

Nothing gets deleted.

---

# Solution

One side should be:

```cpp
QWeakPointer
```

Instead:

```cpp
Patient

↓

QSharedPointer

↓

Report

↑

QWeakPointer

↑

Patient
```

Now destruction works correctly.

---

# 5. QWeakPointer

Purpose:

Observe an object.

Do **not** own it.

Example:

```cpp
QSharedPointer<Patient> patient =
    QSharedPointer<Patient>::create();

QWeakPointer<Patient> weak = patient;
```

Weak pointer:

```text
Patient

↓

Weak Pointer

(No Ownership)
```

Destroy:

```cpp
patient.clear();
```

Patient is deleted.

Weak pointer automatically becomes expired.

---

# lock()

To access the object safely:

```cpp
if (auto strong = weak.toStrongRef())
{
    strong->print();
}
```

If the object has already been destroyed:

```cpp
toStrongRef()
```

returns an empty `QSharedPointer`.

Always check the result before use.

---

# 6. QEnableSharedFromThis

Sometimes an object needs to create a `QSharedPointer` referring to itself.

Incorrect:

```cpp
QSharedPointer<MyClass>(this);
```

This creates a **new ownership control block**, which can lead to double deletion if another `QSharedPointer` already owns the object.

Use:

```cpp
QEnableSharedFromThis<MyClass>
```

Example:

```cpp
class Beam :
    public QEnableSharedFromThis<Beam>
{
};
```

Inside the class:

```cpp
auto self = sharedFromThis();
```

This returns a `QSharedPointer` that shares the existing ownership.

---

# 7. Pointer Casting

Qt provides casting helpers.

## staticCast()

```cpp
QSharedPointer<Base> base;

auto derived =
    base.staticCast<Derived>();
```

Use when the conversion is known to be safe at compile time.

---

## dynamicCast()

```cpp
auto derived =
    base.dynamicCast<Derived>();
```

Uses RTTI.

Returns an empty `QSharedPointer` if the cast fails.

---

## constCast()

```cpp
auto modifiable =
    constPointer.constCast<Type>();
```

Removes constness.

Use sparingly.

---

# 8. QSharedPointer vs std::shared_ptr

| Feature               | QSharedPointer | std::shared_ptr |
| --------------------- | -------------- | --------------- |
| Qt Integration        | Excellent      | Good            |
| STL Integration       | Limited        | Excellent       |
| Custom Deleters       | ✔              | ✔               |
| Weak Pointer          | `QWeakPointer` | `std::weak_ptr` |
| Thread-safe Ref Count | ✔              | ✔               |
| Standard C++          | No             | Yes             |

---

# Which Should You Use?

## Qt-heavy application

```cpp
QSharedPointer
```

Especially when interacting with Qt APIs that already use Qt smart pointers.

---

## Generic Modern C++ Library

```cpp
std::shared_ptr
```

Preferred.

---

## Mixed Projects

Follow the surrounding codebase.

Avoid unnecessary conversions between smart pointer types.

---

# 9. Production Architecture

Medical TPS example:

```text
TreatmentPlan
      │
      ▼
QSharedPointer<Patient>
      │
      ▼
Patient
      │
      ├─────────────┐
      ▼             ▼
BeamSet         StructureSet
      │             │
      ▼             ▼
DoseEngine     ImageSeries
```

Shared objects:

* Images
* Dose matrices
* Beam models
* Patient data

Weak references:

* GUI caches
* Temporary viewers
* Observer-style relationships

---

# 10. Medical TPS Example

```cpp
class Patient
{
public:
    QString name;
};

using PatientPtr =
    QSharedPointer<Patient>;
```

Image cache:

```cpp
QHash<QString, PatientPtr>
```

Different subsystems can safely share ownership:

* Viewer
* Registration
* Dose engine
* Reporting

---

# 11. Qt 5.15 vs Qt 6.11

| Feature                 | Qt 5.15 | Qt 6.11 |
| ----------------------- | ------- | ------- |
| Reference Counting      | ✔       | ✔       |
| `QWeakPointer`          | ✔       | ✔       |
| Casting APIs            | ✔       | ✔       |
| `QEnableSharedFromThis` | ✔       | ✔       |
| API                     | Stable  | Stable  |

There is **no major conceptual difference** between Qt 5.15 and Qt 6.11.

---

# 12. Best Practices

* Use `QSharedPointer` only when ownership is genuinely shared.
* Prefer `QWeakPointer` to break ownership cycles.
* Use `QSharedPointer::create()` for object creation.
* Never create multiple unrelated `QSharedPointer`s from the same raw pointer.
* Do not mix `QObject` parent-child ownership with `QSharedPointer` for the same object.
* Pass `const QSharedPointer<T>&` when you only need to observe or temporarily use a shared object.

---

# 13. Common Mistakes

* Cyclic references causing memory leaks.
* Calling `QSharedPointer<T>(this)` inside a managed object.
* Assuming `QSharedPointer` makes the object itself thread-safe.
* Using shared ownership where unique ownership is sufficient.
* Mixing ownership models.

---

# 14. Interview Questions

## Easy

1. What is `QWeakPointer`?
2. Why do we need weak pointers?
3. What happens when the last `QSharedPointer` is destroyed?

---

## Medium

1. Explain reference counting.
2. What is a cyclic reference?
3. How does `toStrongRef()` work?

---

## Hard

1. Describe the conceptual control block.
2. Compare `QSharedPointer` and `std::shared_ptr`.
3. Explain `QEnableSharedFromThis`.

---

## Expert

1. Design a shared image cache for a Treatment Planning System.
2. Explain why cyclic references leak memory and how to prevent them.
3. Discuss smart pointer ownership strategies in a large Qt application using both `QObject` and non-`QObject` classes.

---

# 15. Revision Notes

* `QSharedPointer` provides shared ownership through reference counting.
* The control block stores strong count, weak count, and deleter information.
* `QWeakPointer` observes objects without owning them.
* Use `QWeakPointer` to break ownership cycles.
* Reference counting is thread-safe; the managed object is **not** automatically thread-safe.
* Use casting helpers instead of raw pointer casts when working with `QSharedPointer`.

---

# 🏥 Production Recommendations

| Scenario             | Recommended Smart Pointer         |
| -------------------- | --------------------------------- |
| Shared DICOM Image   | `QSharedPointer<Image>`           |
| Shared Dose Matrix   | `QSharedPointer<DoseMatrix>`      |
| GUI Observer         | `QWeakPointer<Model>`             |
| Beam Model Cache     | `QSharedPointer<BeamModel>`       |
| Cyclic Relationships | `QSharedPointer` + `QWeakPointer` |

---

## **Chapter 23 — QScopedPointer (Complete Deep Dive)**
[⬅️ QPair](/QQPair.md)      |          [QScopedPointer ➡️](/QQPair.md)
---
## **License**
This project is licensed under the MIT License.

---

Happy Coding!

