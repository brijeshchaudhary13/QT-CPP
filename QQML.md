# Complete Qt Master Course (Qt 5.15 LTS → Qt 6.11)

# PART XII — QML & Qt Quick

# Chapter 86 — QML (Complete Deep Dive)

## Master QML, Declarative Programming, Qt Quick Architecture & Enterprise UI Development

> **Level:** Beginner → Architect

---




# 1. Introduction

**QML (Qt Modeling Language)** is a **declarative language** used to build modern, animated, and responsive user interfaces in Qt.

QML is part of the **Qt Quick** framework and combines:

* Declarative UI description
* JavaScript for logic
* C++ for performance-critical code

Instead of writing *how* to create a UI step by step, you describe *what* the UI should look like.

---

## Architecture

```text
Application
      │
      ▼
   C++ Backend
      │
      ▼
  QML Engine
      │
      ▼
    QML UI
```

---

# 2. Why QML?

Traditional Qt Widgets

```cpp
QPushButton *button = new QPushButton(this);
button->setText("Login");
button->move(100,100);
button->resize(120,40);
```

---

Equivalent QML

```qml
Button {
    text: "Login"
}
```

Much shorter.

Much easier to read.

---

## Advantages

* Rapid UI development
* Rich animations
* Responsive layouts
* Touch-friendly
* Easy customization
* Hardware accelerated

---

## Typical Applications

* Automotive dashboards
* Medical touch interfaces
* Industrial HMIs
* Embedded Linux
* Smart TVs
* Mobile apps
* Modern desktop applications

---

# 3. Declarative Programming

## Imperative Programming

Traditional C++

```text
Create Button

↓

Set Size

↓

Set Position

↓

Show
```

You describe every step.

---

## Declarative Programming

QML

```text
Button

↓

text: "Login"

↓

width:120
```

You describe the final state.

Qt determines how to create it.

---

## Comparison

| Imperative     | Declarative        |
| -------------- | ------------------ |
| How            | What               |
| More code      | Less code          |
| Manual updates | Automatic bindings |
| Procedural     | State-oriented     |

---

# 4. QML Architecture

```text
Application
      │
      ▼
C++ Business Logic
      │
      ▼
QQmlApplicationEngine
      │
      ▼
QML Scene
      │
      ▼
Qt Quick Scene Graph
      │
      ▼
GPU
```

The QML engine interprets QML files and creates runtime objects.

---

# 5. QML Runtime

When the application starts

```text
main.cpp

↓

QQmlApplicationEngine

↓

Load main.qml

↓

Create Objects

↓

Display UI
```

Example

```cpp
QQmlApplicationEngine engine;

engine.load(
QUrl("qrc:/main.qml"));
```

---

# 6. QML Syntax

Simple example

```qml
import QtQuick

Rectangle
{
    width: 300
    height: 200

    color: "white"
}
```

Everything is an object.

---

Another example

```qml
Text
{
    text: "Hello Qt"
}
```

---

## General Structure

```qml
Type
{
    property:value

    child
    {
    }
}
```

---

# 7. Object Tree

QML creates a hierarchy of objects.

```text
Window

├── Rectangle

│     ├── Image

│     └── Text

└── Button
```

Children inherit transformations from parents.

---

Example

```qml
Rectangle
{
    Text
    {
    }

    Image
    {
    }
}
```

---

# 8. Properties

Everything in QML is based on properties.

Example

```qml
Rectangle
{
    width:300

    height:200

    color:"red"
}
```

---

Custom property

```qml
property int age:25
```

String

```qml
property string name:"John"
```

Boolean

```qml
property bool visible:true
```

Real

```qml
property real opacity:0.8
```

---

## Property Binding

One of QML's most powerful features.

```qml
Rectangle
{
    width: parent.width
}
```

When `parent.width` changes,

the rectangle updates automatically.

No manual code is required.

---

# 9. Signals

Signals notify when something happens.

Built-in

```qml
Button
{
    onClicked:
    {
    }
}
```

---

Custom signal

```qml
signal loginSuccess()
```

Emit

```qml
loginSuccess()
```

---

Workflow

```text
Click

↓

Signal

↓

Handler
```

---

# 10. Functions

Functions organize reusable logic.

Example

```qml
function add(a,b)
{
    return a+b;
}
```

Call

```qml
var x=add(2,3);
```

---

Functions are written in JavaScript.

---

# 11. Anchors & Layout

Instead of manually positioning items,

use anchors.

Center

```qml
anchors.centerIn: parent
```

Fill

```qml
anchors.fill: parent
```

Margins

```qml
anchors.margins:10
```

---

Example

```text
Parent

↓

Centered Button
```

---

Advantages

* Responsive
* Easy resizing
* Cross-platform

---

# 12. Components

A component is a reusable UI object.

Example

```qml
MyButton
{
}
```

Internally

```text
MyButton.qml
```

Reusable

```text
Login Screen

↓

MyButton

Settings

↓

MyButton
```

---

Benefits

* Reuse
* Cleaner code
* Easier maintenance

---

# 13. Importing Modules

Import

```qml
import QtQuick
```

Controls

```qml
import QtQuick.Controls
```

Layouts

```qml
import QtQuick.Layouts
```

Each module provides additional QML types.

---

# 14. C++ Integration

Architecture

```text
C++

↓

QObject

↓

QML
```

Expose object

```cpp
engine.rootContext()
->setContextProperty(
"backend",
&backend);
```

Then

```qml
backend.login()
```

---

Register type

```cpp
qmlRegisterType<MyClass>(
"MyApp",
1,
0,
"MyClass");
```

Usage

```qml
MyClass
{
}
```

---

# 15. Enterprise Applications

## Automotive

```text
Vehicle Data

↓

C++

↓

QML Dashboard
```

---

## Medical TPS

```text
Dose Engine

↓

C++

↓

QML Viewer
```

---

## Industrial HMI

```text
PLC

↓

Backend

↓

Touch UI
```

---

## Finance

```text
REST API

↓

Backend

↓

Charts
```

---

# 16. Qt Internals

```text
QML File

↓

Parser

↓

Object Tree

↓

Bindings

↓

Scene Graph

↓

GPU
```

The engine:

* Parses QML
* Creates QObject-based instances
* Evaluates bindings
* Renders via the Qt Quick Scene Graph

---

# 17. Qt 5 vs Qt 6

| Feature          | Qt 5.15                             | Qt 6.11                                                            |
| ---------------- | ----------------------------------- | ------------------------------------------------------------------ |
| QML              | ✔                                   | ✔                                                                  |
| Qt Quick         | ✔                                   | ✔                                                                  |
| Property Binding | ✔                                   | ✔                                                                  |
| Scene Graph      | ✔                                   | ✔ (Improved)                                                       |
| Rendering        | OpenGL by default on many platforms | Rendering Hardware Interface (RHI) supports multiple graphics APIs |

Qt 6 introduces the **Rendering Hardware Interface (RHI)**, allowing Qt Quick to run on Direct3D, Vulkan, Metal, or OpenGL depending on the platform.

---

# 18. Best Practices

✅ Keep business logic in C++.

✅ Keep QML focused on UI.

✅ Create reusable components.

✅ Prefer property bindings over manual updates.

✅ Use layouts and anchors instead of fixed positions.

---

# 19. Common Mistakes

### ❌ Putting heavy business logic in JavaScript

Move computational work to C++.

---

### ❌ Deep object nesting

Very deep hierarchies reduce readability and may affect performance.

---

### ❌ Breaking property bindings unintentionally

Assigning a value directly replaces the existing binding.

---

### ❌ Repeating UI code

Create reusable components.

---

### ❌ Using absolute positioning everywhere

Prefer anchors and layouts for responsive interfaces.

---

# 20. Interview Questions

## Easy

1. What is QML?
2. What is declarative programming?
3. What is a property?

---

## Medium

1. Explain property binding.
2. How do you expose C++ objects to QML?
3. What are QML components?

---

## Hard

1. Explain the QML object tree.
2. Compare Qt Widgets and QML.
3. Explain how the QML engine creates objects.

---

## Expert

1. Design a modern QML-based user interface for a Treatment Planning System with dose visualization, patient management, and real-time machine monitoring.
2. Explain how property bindings work internally and why they are efficient.
3. Compare QML, Qt Widgets, Flutter, WPF, and Electron for enterprise desktop applications.

---

# 21. Revision Notes

* QML is a declarative language for building Qt Quick UIs.
* QML focuses on *what* the UI should be.
* Property bindings automatically keep values synchronized.
* QML objects form a hierarchical object tree.
* JavaScript provides lightweight UI logic.
* C++ provides business logic and performance-critical code.
* Reusable components simplify maintenance.
* Anchors and layouts enable responsive designs.
* The QML engine creates objects and manages bindings.
* Qt 6 uses the Rendering Hardware Interface (RHI) for cross-platform graphics.

---

# 💡 Senior Engineer Tips

## Qt Widgets vs QML

| Feature                | Qt Widgets | QML       |
| ---------------------- | ---------- | --------- |
| Traditional Desktop UI | ⭐⭐⭐⭐⭐      | ⭐⭐⭐       |
| Touch Interfaces       | ⭐⭐         | ⭐⭐⭐⭐⭐     |
| Animations             | ⭐⭐         | ⭐⭐⭐⭐⭐     |
| GPU Acceleration       | Limited    | Excellent |
| Rapid UI Design        | Moderate   | Excellent |
| Mature Enterprise Apps | ⭐⭐⭐⭐⭐      | ⭐⭐⭐⭐      |

---

## Enterprise QML Architecture

```text
             QML UI
                │
                ▼
        ViewModel / Controller
                │
                ▼
         C++ Business Logic
                │
      ┌─────────┴─────────┐
      ▼                   ▼
 Database            REST API
      │                   │
      └─────────┬─────────┘
                ▼
            Core Services
```

Keep the UI declarative and lightweight while placing business logic, networking, and data access in C++.

---

## Medical TPS Example

```text
 Treatment Planning System
          │
          ▼
     QML Dashboard
          │
 ┌────────┼─────────┬─────────┐
 ▼        ▼         ▼         ▼
Patient Dose View DVH View Machine Status
          │
          ▼
     C++ Backend
          │
 ┌────────┼──────────┐
 ▼        ▼          ▼
Dose Engine  DICOM  REST Client
          │
          ▼
     Medical Devices
```

A modern TPS often uses:

* **QML** for responsive, touch-friendly interfaces.
* **C++** for dose calculation, DICOM processing, networking, and hardware integration.
* **Property bindings** to automatically update the UI when backend data changes.

---


## **Chapter 87 — QML Engine (Complete Deep Dive)**

