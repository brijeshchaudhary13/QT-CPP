# Complete Qt Master Course (Qt 5.15 LTS → Qt 6.11)

# PART XII — QML & Qt Quick

# Chapter 92 — Custom QML Types (Complete Deep Dive)

---

# 1. Introduction

QML is excellent for creating user interfaces, but it is **not** intended for heavy computation or complex business logic.

Real-world applications often require:

* Database access
* Network communication
* File handling
* Hardware communication
* Image processing
* Medical calculations

These tasks are typically implemented in **C++** and exposed to QML as **Custom QML Types**.

---

## Architecture

```text id="cqt01"
QML UI
   │
   ▼
Custom QML Type
   │
   ▼
C++ Backend
   │
   ▼
Database / Network / Devices
```

---

# 2. Why Custom QML Types?

Suppose you are building a Treatment Planning System (TPS).

QML should display:

* Patient information
* Dose values
* DVH graphs
* Machine status

The C++ backend should perform:

* DICOM parsing
* Dose calculation
* Database access
* Device communication

---

## Separation of Responsibilities

| Layer      | Responsibility    |
| ---------- | ----------------- |
| QML        | UI & Presentation |
| JavaScript | UI Logic          |
| C++        | Business Logic    |
| Database   | Persistent Data   |

---

# 3. Architecture

```text id="cqt02"
          QML UI
             │
             ▼
      Custom QML Type
             │
             ▼
        QObject
             │
             ▼
      Business Logic
             │
      ┌──────┼────────┐
      ▼      ▼        ▼
 Database REST API Devices
```

The `QObject` acts as the bridge between QML and C++.

---

# 4. Creating a Custom QML Type

## Step 1: Create a QObject

```cpp id="cqt03"
class Patient :
    public QObject
{
    Q_OBJECT
};
```

---

## Step 2: Register the Type

### Qt 5

```cpp id="cqt04"
qmlRegisterType<Patient>(
    "Medical",
    1,
    0,
    "Patient");
```

---

### Qt 6 (Modern)

```cpp id="cqt05"
class Patient :
    public QObject
{
    Q_OBJECT
    QML_ELEMENT
};
```

With `QML_ELEMENT`, the type is registered through Qt's QML module system (typically with CMake).

---

## Step 3: Use in QML

```qml id="cqt06"
import Medical

Patient
{
}
```

---

# 5. Q_PROPERTY

`Q_PROPERTY` exposes C++ properties to QML.

Example

```cpp id="cqt07"
Q_PROPERTY(
QString name

READ name

WRITE setName

NOTIFY nameChanged)
```

---

QML

```qml id="cqt08"
Text
{
    text:
    patient.name
}
```

Whenever `nameChanged()` is emitted,

the UI updates automatically.

---

## Property Flow

```text id="cqt09"
C++

↓

Q_PROPERTY

↓

QML

↓

Property Binding
```

---

# 6. Q_INVOKABLE

Expose functions to QML.

Example

```cpp id="cqt10"
Q_INVOKABLE

void login();
```

Call

```qml id="cqt11"
backend.login()
```

---

Function with return value

```cpp id="cqt12"
Q_INVOKABLE

int age();
```

QML

```qml id="cqt13"
Text
{
    text:
    backend.age()
}
```

---

## When to Use

* Utility functions
* Commands
* Data queries

---

# 7. Signals & Slots

Signals notify QML.

Example

```cpp id="cqt14"
signals:

void doseUpdated();
```

QML

```qml id="cqt15"
Connections
{
    target: backend

    function onDoseUpdated()
    {
    }
}
```

---

Workflow

```text id="cqt16"
C++

↓

Signal

↓

QML

↓

Update UI
```

---

Slots

```cpp id="cqt17"
public slots:

void startDose();
```

Slots can also be called from C++ signal-slot connections and, if invokable, from QML.

---

# 8. Enums in QML

Enums improve readability.

Example

```cpp id="cqt18"
enum Status
{
    Ready,

    Busy,

    Error
};

Q_ENUM(Status)
```

QML

```qml id="cqt19"
if(status===Patient.Ready)
{
}
```

---

Advantages

* Type safety
* Cleaner code
* Better readability

---

# 9. Singleton Types

Some objects should exist only once.

Examples

* Settings
* Theme
* Logger
* License Manager

Qt 5

```cpp id="cqt20"
qmlRegisterSingletonType<
Settings>();
```

Qt 6 also supports declarative registration with macros such as `QML_SINGLETON` when using the QML module system.

---

QML

```qml id="cqt21"
Settings.language
```

---

# 10. Context Properties vs Registered Types

## Context Property

```cpp id="cqt22"
setContextProperty(
"backend",
&backend);
```

Good for:

* Small applications
* Prototypes

---

## Registered Type

```cpp id="cqt23"
qmlRegisterType()
```

Good for:

* Large projects
* Reusable modules
* Libraries

---

## Comparison

| Feature             | Context Property | Registered Type |
| ------------------- | ---------------- | --------------- |
| Reusable            | ✘                | ✔               |
| Multiple Instances  | ✘                | ✔               |
| Tooling Support     | Limited          | Better          |
| Enterprise Projects | Limited          | ✔               |

---

# 11. Value Types

Not every type needs to inherit `QObject`.

Value types are lightweight objects passed by value.

Examples include:

* `QColor`
* `QPointF`
* `QRectF`
* `QSize`

Custom value types can also be exposed to QML using modern Qt facilities.

---

Example

```qml id="cqt24"
Rectangle
{
    color: "red"
}
```

Here, `color` uses the `QColor` value type.

---

# 12. Object Lifetime

Objects may be owned by:

* C++
* QML

Architecture

```text id="cqt25"
QObject

↓

Ownership

↓

Deletion
```

Qt provides:

```cpp id="cqt26"
QQmlEngine::

setObjectOwnership()
```

to explicitly control ownership when required.

---

Avoid deleting QML-owned objects manually.

---

# 13. Enterprise Applications

## Medical TPS

```text id="cqt27"
DoseEngine

↓

QML Type

↓

Dose Viewer
```

---

## Automotive

```text id="cqt28"
VehicleData

↓

Dashboard
```

---

## ERP

```text id="cqt29"
Customer

↓

UI
```

---

## Industrial HMI

```text id="cqt30"
PLC

↓

QML
```

---

# 14. Qt Internals

```text id="cqt31"
QObject

↓

Meta-Object System

↓

QML Engine

↓

Bindings

↓

UI
```

Method call

```text id="cqt32"
QML

↓

Meta-Object

↓

C++
```

Qt uses the meta-object system to expose:

* Properties
* Signals
* Slots
* Invokable methods
* Enums

---

# 15. Qt 5 vs Qt 6

| Feature                  | Qt 5.15 | Qt 6.11 |
| ------------------------ | ------- | ------- |
| `qmlRegisterType()`      | ✔       | ✔       |
| `Q_PROPERTY`             | ✔       | ✔       |
| `Q_INVOKABLE`            | ✔       | ✔       |
| `QML_ELEMENT`            | ✘       | ✔       |
| `QML_SINGLETON`          | Limited | ✔       |
| Declarative Registration | ✘       | ✔       |

Qt 6 encourages compile-time registration using CMake and macros such as `QML_ELEMENT`.

---

# 16. Best Practices

✅ Keep business logic in C++.

✅ Expose only necessary APIs to QML.

✅ Use `Q_PROPERTY` for observable state.

✅ Use signals for asynchronous updates.

✅ Prefer registered types for enterprise applications.

---

# 17. Common Mistakes

### ❌ Exposing Too Much

Only expose the API the UI actually needs.

---

### ❌ Missing `NOTIFY`

Without a `NOTIFY` signal, property bindings will not update automatically.

---

### ❌ Business Logic in QML

Keep calculations and business rules in C++.

---

### ❌ Forgetting Object Ownership

Understand whether C++ or QML owns an object.

---

### ❌ Using Context Properties Everywhere

Prefer registered types and modules for scalable architectures.

---

# 18. Interview Questions

## Easy

1. What is a Custom QML Type?
2. What does `Q_PROPERTY` do?
3. What is `Q_INVOKABLE`?

---

## Medium

1. Explain `qmlRegisterType()`.
2. What is `QML_ELEMENT`?
3. Compare context properties and registered types.

---

## Hard

1. Explain the role of the Qt Meta-Object System in QML integration.
2. How are C++ properties synchronized with QML?
3. Explain object ownership between QML and C++.

---

## Expert

1. Design the backend architecture for a Treatment Planning System where dose calculation, DICOM processing, machine communication, and patient management are exposed as reusable QML modules.
2. Compare `Q_PROPERTY`, `Q_INVOKABLE`, signals, slots, and context properties.
3. Explain the advantages of declarative type registration introduced in Qt 6.

---

# 19. Revision Notes

* Custom QML Types expose C++ functionality to QML.
* `QObject` is the foundation of integration.
* `Q_PROPERTY` exposes observable properties.
* `Q_INVOKABLE` exposes callable methods.
* Signals notify QML of changes.
* `Q_ENUM` exposes enums.
* Singleton types provide shared services.
* Registered types scale better than context properties.
* Qt's meta-object system enables communication between QML and C++.
* Qt 6 introduces `QML_ELEMENT` and improved declarative registration.

---

# 💡 Senior Engineer Tips

## Which Exposure Mechanism Should You Use?

| Requirement                | Recommended      |
| -------------------------- | ---------------- |
| Observable data            | `Q_PROPERTY`     |
| UI command                 | `Q_INVOKABLE`    |
| Asynchronous notification  | Signal           |
| Shared application service | Singleton        |
| Reusable backend object    | Registered Type  |
| Quick prototype            | Context Property |

---

## Enterprise Backend Architecture

```text id="cqt33"
              QML UI
                 │
                 ▼
      Registered QML Types
                 │
        ┌────────┼────────┐
        ▼        ▼        ▼
 PatientVM  DoseVM  MachineVM
        │        │        │
        └────────┼────────┘
                 ▼
          Business Services
                 │
      ┌──────────┼──────────┐
      ▼          ▼          ▼
 Database    REST API    Hardware
```

Each ViewModel exposes only the data and operations required by its corresponding QML view.

---

## Medical TPS Example

```text id="cqt34"
           Treatment Planning System
                     │
                     ▼
               QML Dashboard
                     │
      ┌──────────────┼──────────────┐
      ▼              ▼              ▼
 PatientVM      DoseVM      MachineVM
      │              │              │
      ▼              ▼              ▼
 Patient DB   Dose Engine   LINAC Interface
                     │
          ┌──────────┼──────────┐
          ▼          ▼          ▼
       DICOM      RT Plan    RT Dose
```

Benefits of this architecture:

* Strong separation between UI and business logic.
* Reusable backend modules.
* Easy unit testing.
* Scalable for large enterprise and medical applications.

---


## **Chapter 93 — Qt Multimedia (Complete Deep Dive)**

