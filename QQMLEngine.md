# Complete Qt Master Course (Qt 5.15 LTS → Qt 6.11)

# PART XII — QML & Qt Quick

# Chapter 87 — QML Engine (Complete Deep Dive)

## Master QQmlEngine, QQmlApplicationEngine, Contexts, Type Registration & QML Runtime Internals

> **Level:** Advanced → Architect

---

# 1. Introduction

The **QML Engine** is the runtime responsible for loading, parsing, instantiating, and managing QML objects.

When you write:

```cpp
QQmlApplicationEngine engine;

engine.load(
QUrl("qrc:/main.qml"));
```

the engine performs all the work required to display your QML application.

Without the engine,

QML files are simply text files.

---

## Architecture

```text
Application

↓

QQmlApplicationEngine

↓

QQmlEngine

↓

QQmlContext

↓

QML Objects

↓

Scene Graph

↓

GPU
```

---

# 2. QML Engine Architecture

The engine consists of several major components.

```text
QQmlApplicationEngine

        │

        ▼

QQmlEngine

        │

 ┌──────┼──────────┐

 ▼      ▼          ▼

Parser Context Type System

        │

        ▼

Object Tree
```

Responsibilities

* Parse QML
* Resolve imports
* Evaluate bindings
* Create objects
* Manage contexts
* Communicate with C++

---

# 3. QQmlEngine

Header

```cpp
#include <QQmlEngine>
```

Create

```cpp
QQmlEngine engine;
```

`QQmlEngine` is the core runtime.

It does **not** automatically create a window.

Typical uses

* Embedding QML into existing applications
* Custom object creation
* Unit testing
* Advanced runtime control

---

## Responsibilities

```text
QQmlEngine

↓

Parser

↓

Compiler

↓

Binding Engine

↓

Memory Manager
```

---

# 4. QQmlApplicationEngine

Header

```cpp
#include <QQmlApplicationEngine>
```

Create

```cpp
QQmlApplicationEngine engine;
```

Load

```cpp
engine.load(
QUrl("qrc:/main.qml"));
```

Unlike `QQmlEngine`,

`QQmlApplicationEngine`

* loads the root QML file,
* manages translation reloads,
* is intended for complete QML applications.

---

## Startup Flow

```text
main()

↓

QQmlApplicationEngine

↓

Load QML

↓

Create Window

↓

Show UI
```

---

# 5. QML Loading Process

When `load()` is called:

```text
Load File

↓

Parse

↓

Resolve Imports

↓

Compile Bindings

↓

Create Objects

↓

Connect Signals

↓

Display
```

Every object in the QML file becomes a runtime QObject-based instance.

---

## Example

```qml
Rectangle
{
    Text
    {
    }

    Button
    {
    }
}
```

Runtime

```text
Rectangle

├── Text

└── Button
```

---

# 6. QQmlContext

A **context** stores data visible to QML.

Architecture

```text
QQmlEngine

↓

Root Context

↓

Child Context

↓

Objects
```

Header

```cpp
#include <QQmlContext>
```

Retrieve

```cpp
QQmlContext *ctx =
engine.rootContext();
```

Every QML component executes within a context.

---

# 7. Context Properties

Expose C++ objects

```cpp
ctx->setContextProperty(
"backend",
&backend);
```

QML

```qml
backend.login()
```

Workflow

```text
QObject

↓

Context

↓

QML

↓

Method Call
```

---

## When to Use Context Properties

Suitable for:

* Small applications
* Application-wide services
* Quick prototypes

For reusable QML modules, registered QML types are usually a better choice.

---

# 8. Type Registration

Register a C++ class

```cpp
qmlRegisterType<MyClass>(
"MyApp",
1,
0,
"MyClass");
```

QML

```qml
import MyApp 1.0

MyClass
{
}
```

---

## Advantages

* Strong typing
* Reusable modules
* Better tooling support
* Cleaner architecture

---

## Registration Workflow

```text
C++ Class

↓

qmlRegisterType()

↓

QML Module

↓

Object Instance
```

---

# 9. Singleton Registration

Sometimes only one instance should exist.

Example

```text
Settings

↓

Singleton
```

Registration

```cpp
qmlRegisterSingletonType<
Settings>(
...
);
```

Usage

```qml
Settings.language
```

Applications

* Settings
* Theme manager
* Logger
* Configuration
* License manager

---

# 10. Import Paths & Modules

Example

```qml
import QtQuick

import QtQuick.Controls

import MyCompany.MyModule
```

The engine searches:

```text
Import

↓

Import Paths

↓

Module

↓

Types
```

---

## Resource System

Modules may be stored inside

```text
qrc
```

or

filesystem directories.

---

# 11. Object Ownership

Objects may be owned by

* C++
* QML

Qt tracks ownership to prevent leaks.

Example

```text
QObject

↓

QML

↓

Destroy
```

Qt determines whether it should delete the object based on ownership rules.

---

## Ownership Types

```text
C++ Ownership

↓

Application Deletes

-------------------

JavaScript Ownership

↓

QML Deletes
```

Qt provides APIs such as `QQmlEngine::setObjectOwnership()` to explicitly control ownership when necessary.

---

# 12. Memory Management

QML automatically manages many objects.

Workflow

```text
Object

↓

Reference

↓

Unused

↓

Destroyed
```

The engine:

* Tracks object lifetimes.
* Releases objects when appropriate.
* Works with QObject parent-child ownership.

---

Avoid

```cpp
delete object;
```

if QML owns the object.

---

# 13. Enterprise Applications

## Automotive

```text
Vehicle Data

↓

Backend

↓

QML Engine
```

---

## Medical TPS

```text
Dose Engine

↓

Backend

↓

QML Dashboard
```

---

## ERP

```text
REST API

↓

Backend

↓

QML UI
```

---

## Industrial Automation

```text
PLC

↓

Backend

↓

QML
```

---

# 14. Qt Internals

```text
QQmlApplicationEngine

↓

QQmlEngine

↓

Parser

↓

Compiler

↓

Binding Engine

↓

QObject Tree

↓

Scene Graph
```

Bindings

```text
Property Changes

↓

Dependency Tracking

↓

Binding Recalculation

↓

UI Update
```

The engine tracks dependencies so that property bindings update automatically when source values change.

---

# 15. Qt 5 vs Qt 6

| Feature                | Qt 5.15 | Qt 6.11                                 |
| ---------------------- | ------- | --------------------------------------- |
| QQmlEngine             | ✔       | ✔                                       |
| QQmlApplicationEngine  | ✔       | ✔                                       |
| Context Properties     | ✔       | ✔                                       |
| Type Registration      | ✔       | ✔                                       |
| Singleton Registration | ✔       | ✔                                       |
| QML Modules            | ✔       | ✔ (Improved tooling and module support) |

Qt 6 places greater emphasis on modern QML modules and compile-time tooling while remaining largely compatible.

---

# 16. Best Practices

✅ Use `QQmlApplicationEngine` for complete QML applications.

✅ Register reusable C++ classes instead of relying heavily on context properties.

✅ Keep business logic in C++.

✅ Organize QML into modules.

✅ Manage object ownership carefully.

---

# 17. Common Mistakes

### ❌ Exposing too many context properties

Prefer registered types and singletons for scalable projects.

---

### ❌ Mixing UI logic with backend logic

Maintain a clear separation of concerns.

---

### ❌ Manual deletion of QML-owned objects

Understand ownership before deleting objects.

---

### ❌ Global context abuse

Avoid putting unrelated services into the root context.

---

### ❌ Ignoring module organization

Organize large projects into reusable modules.

---

# 18. Interview Questions

## Easy

1. What is `QQmlEngine`?
2. What is `QQmlApplicationEngine`?
3. What is a QML context?

---

## Medium

1. Explain context properties.
2. What is QML type registration?
3. When should you use a singleton?

---

## Hard

1. Explain the QML loading process.
2. Describe QML object ownership.
3. Compare context properties with registered QML types.

---

## Expert

1. Design the QML engine architecture for a Treatment Planning System with reusable modules for patient management, dose visualization, treatment planning, and machine monitoring.
2. Explain how the QML engine evaluates property bindings efficiently.
3. Compare `QQmlEngine`, `QQmlApplicationEngine`, and `QQuickView` and describe when each should be used.

---

# 19. Revision Notes

* `QQmlEngine` is the core QML runtime.
* `QQmlApplicationEngine` is used for complete QML applications.
* The engine parses QML, creates objects, and evaluates bindings.
* `QQmlContext` provides data visibility for QML.
* Context properties expose C++ objects.
* Registered QML types are preferable for reusable components.
* Singletons provide shared application-wide services.
* Object ownership determines who deletes an object.
* The engine manages bindings and object lifetimes.
* Qt 6 continues to improve the QML module system.

---

# 💡 Senior Engineer Tips

## Context Property vs Registered Type vs Singleton

| Requirement                | Best Choice      |
| -------------------------- | ---------------- |
| One global settings object | Singleton        |
| Reusable business object   | Registered Type  |
| Small prototype            | Context Property |
| Shared logging service     | Singleton        |
| Multiple object instances  | Registered Type  |

---

## Enterprise QML Engine Architecture

```text
                 main.cpp
                     │
                     ▼
        QQmlApplicationEngine
                     │
          ┌──────────┼──────────┐
          ▼          ▼          ▼
     QML Modules  Singletons  Context
          │          │          │
          └──────────┼──────────┘
                     ▼
              Business Services
                     │
        ┌────────────┼────────────┐
        ▼            ▼            ▼
   REST API     Database     Device Layer
```

This architecture keeps the application modular, testable, and easy to maintain.

---

## Medical TPS Example

```text
             QQmlApplicationEngine
                     │
      ┌──────────────┼──────────────┐
      ▼              ▼              ▼
 Patient Module  Planning Module  Machine Module
      │              │              │
      └──────────────┼──────────────┘
                     ▼
             C++ Core Services
                     │
      ┌──────────────┼──────────────┐
      ▼              ▼              ▼
 Dose Engine      DICOM       Device Communication
                     │
                     ▼
                Medical Hardware
```

This layered architecture provides:

* Independent QML modules
* Reusable backend services
* Clean separation between UI and computation
* Easy testing and future expansion

---


## **Chapter 88 — JavaScript in QML (Complete Deep Dive)**

