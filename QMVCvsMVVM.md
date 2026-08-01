# Complete Qt Master Course (Qt 5.15 LTS → Qt 6.11)

# PART VII — Software Architecture

# Chapter 62 — MVC vs MVVM (Complete Deep Dive)

## Master MVC, MVVM, Qt Model/View, Qt Widgets Architecture & QML Architecture

> **Level:** Advanced → Architect

---

# Chapter Objectives

After completing this chapter, you will understand:

* What is Software Architecture?
* MVC Architecture
* MVVM Architecture
* MVP Architecture
* Qt Model/View vs MVC
* MVC in Qt Widgets
* MVVM in Qt Widgets
* MVVM in QML
* Data Binding
* Enterprise Architecture
* Choosing the Right Architecture
* Medical TPS Architecture
* Qt Internals
* Qt 5.15 vs Qt 6.11
* Best Practices
* Interview Questions

---

# Table of Contents

1. Introduction
2. Why Architecture Matters
3. MVC Architecture
4. MVP Architecture
5. MVVM Architecture
6. Qt Model/View vs MVC
7. MVC in Qt Widgets
8. MVVM in Qt Widgets
9. MVVM in QML
10. Data Binding
11. Enterprise Application Architecture
12. Medical TPS Example
13. Qt Internals
14. Qt 5 vs Qt 6
15. Best Practices
16. Common Mistakes
17. Interview Questions
18. Revision Notes

---

# 1. Introduction

As applications grow, writing all code inside a single `QMainWindow` quickly becomes difficult to maintain.

Consider a Medical Treatment Planning System (TPS):

* Patient management
* DICOM import
* Beam configuration
* Dose calculation
* DVH visualization
* Report generation

If all of this logic is placed inside UI classes, the application becomes tightly coupled and hard to test.

Software architecture helps divide responsibilities into well-defined layers.

---

# 2. Why Architecture Matters

Poor architecture often looks like this:

```text
QMainWindow

├── Database
├── File I/O
├── Network
├── Dose Engine
├── UI
├── Reports
├── Business Rules
└── Rendering
```

Problems:

* Difficult to maintain
* Hard to test
* Low code reuse
* High coupling

A layered architecture separates these concerns.

---

# 3. MVC Architecture

MVC stands for:

* **Model**
* **View**
* **Controller**

Architecture:

```text
        User
          │
          ▼
      Controller
       │      │
       ▼      ▼
     Model → View
```

---

## Responsibilities

### Model

Contains:

* Business data
* Business rules
* Database access
* Domain logic

Examples:

* Patient
* Beam
* Dose
* Structure

---

### View

Displays information.

Examples:

* Buttons
* Tables
* Charts
* Graphics

The View should not contain business rules.

---

### Controller

Receives user actions.

Example:

```text
User

↓

Clicks Save

↓

Controller

↓

Model Updated

↓

View Refreshed
```

The Controller coordinates between the View and the Model.

---

# MVC Workflow

```text
User

↓

View

↓

Controller

↓

Model

↓

View Updated
```

---

# 4. MVP Architecture

MVP stands for:

* Model
* View
* Presenter

Architecture:

```text
User

↓

View

↓

Presenter

↓

Model
```

The Presenter contains presentation logic.

Unlike MVC, the View communicates directly with the Presenter.

---

## Responsibilities

| Component | Responsibility            |
| --------- | ------------------------- |
| Model     | Data and business logic   |
| View      | UI only                   |
| Presenter | UI logic and coordination |

---

# 5. MVVM Architecture

MVVM stands for:

* Model
* View
* ViewModel

Architecture:

```text
Model

↓

ViewModel

↓

View
```

The ViewModel exposes data in a format that is easy for the View to consume.

---

## Responsibilities

### Model

Business data.

---

### ViewModel

Provides:

* Display-friendly properties
* Commands
* Validation
* State management

---

### View

Displays ViewModel properties.

---

## Workflow

```text
User

↓

View

↓

ViewModel

↓

Model

↓

ViewModel

↓

View
```

---

# 6. Qt Model/View vs MVC

Many developers assume Qt implements classic MVC.

It does not.

Qt provides a **Model/View/Delegate** architecture.

```text
Model

↓

Delegate

↓

View
```

The Delegate takes on much of the presentation and editing responsibility that a Controller might handle in a traditional MVC implementation.

---

## Comparison

| Classic MVC | Qt                          |
| ----------- | --------------------------- |
| Model       | Model                       |
| View        | View                        |
| Controller  | Delegate + View interaction |

This is why Qt documentation refers to the framework as **Model/View**, not MVC.

---

# 7. MVC in Qt Widgets

Example:

```text
Patient Database

↓

PatientModel

↓

Controller

↓

QTableView
```

Possible implementation:

```text
PatientController

↓

PatientModel

↓

PatientRepository

↓

Database
```

The controller reacts to UI events such as button clicks and updates the model.

---

# 8. MVVM in Qt Widgets

Although MVVM is commonly associated with QML, it can also be implemented with Qt Widgets.

Example:

```text
Patient

↓

PatientViewModel

↓

QTableView

↓

User
```

The ViewModel:

* Retrieves data
* Formats values
* Performs validation
* Exposes commands

The View binds to the ViewModel through Qt's signal-slot mechanism rather than declarative bindings.

---

# 9. MVVM in QML

MVVM fits naturally with QML because of **property bindings**.

Architecture:

```text
C++ Model

↓

ViewModel

↓

QML

↓

Automatic Binding
```

Example:

```text
Patient Name

↓

ViewModel Property

↓

Text Label

↓

Automatic Update
```

When the ViewModel property changes, the QML UI updates automatically.

---

# 10. Data Binding

One of MVVM's strengths is automatic synchronization between the ViewModel and the View.

Conceptually:

```text
ViewModel

↓

Property Changed

↓

View Updated
```

In Qt Widgets, this usually requires explicit signal-slot connections.

In QML, property bindings handle much of this automatically.

---

# Example

```text
Dose Value

95 Gy

↓

ViewModel

↓

Dose Label Updated
```

No manual refresh call is needed when bindings are in place.

---

# 11. Enterprise Application Architecture

Large Qt applications often have multiple layers.

```text
UI

↓

ViewModel / Controller

↓

Business Services

↓

Repositories

↓

Database
```

Responsibilities:

| Layer                  | Responsibility |
| ---------------------- | -------------- |
| UI                     | Display        |
| ViewModel / Controller | UI logic       |
| Service                | Business logic |
| Repository             | Data access    |
| Database               | Persistence    |

This separation makes the application easier to test and maintain.

---

# 12. Medical TPS Example

A production-grade Treatment Planning System might look like this:

```text
MainWindow

├── Patient Module
├── DICOM Module
├── Beam Module
├── Dose Engine
├── DVH Module
├── Optimization Module
└── Report Module
```

Each module can internally use MVC or MVVM.

Example:

```text
BeamView

↓

BeamViewModel

↓

BeamService

↓

BeamRepository

↓

SQLite
```

Or, for a Widgets-based application:

```text
BeamView

↓

BeamController

↓

BeamService

↓

BeamRepository
```

This modular approach keeps the UI independent from the dose engine and data storage.

---

# 13. Qt Internals

Qt Widgets event flow:

```text
User

↓

Button Click

↓

Signal

↓

Controller / ViewModel

↓

Model

↓

Signal

↓

View Refresh
```

Qt Model/View flow:

```text
Business Objects

↓

Model

↓

Delegate

↓

View

↓

Screen
```

Signal-slot communication allows these layers to remain loosely coupled.

---

# 14. Qt 5 vs Qt 6

| Feature               | Qt 5.15 | Qt 6.11                                        |
| --------------------- | ------- | ---------------------------------------------- |
| MVC Pattern           | ✔       | ✔                                              |
| MVVM Pattern          | ✔       | ✔                                              |
| Model/View Framework  | ✔       | ✔                                              |
| Signal-Slot Mechanism | ✔       | ✔                                              |
| QML Property Binding  | ✔       | ✔ (enhanced tooling and language improvements) |

The architectural patterns themselves are independent of the Qt version.

---

# 15. Best Practices

✅ Keep business logic out of UI classes.

✅ Use services or repositories for database access.

✅ Keep Views focused on presentation.

✅ Use Models as the single source of truth.

✅ Use MVVM when working extensively with QML.

✅ Use Controllers or ViewModels to coordinate UI actions instead of embedding logic in widgets.

---

# 16. Common Mistakes

### ❌ Putting SQL queries inside `QMainWindow`

Move database access into repositories or services.

---

### ❌ Performing business calculations inside the View

The View should display results, not calculate them.

---

### ❌ Treating Qt's Model/View as classic MVC

Qt's architecture is Model/View/Delegate and differs from textbook MVC.

---

### ❌ Creating "God Objects"

Avoid one class that manages UI, networking, business logic, and persistence simultaneously.

---

# 17. Interview Questions

## Easy

1. What is MVC?
2. What is MVVM?
3. What is the difference between a Model and a View?

---

## Medium

1. Why doesn't Qt describe its Model/View framework as MVC?
2. Compare MVC and MVVM.
3. Where does the Delegate fit into Qt's architecture?

---

## Hard

1. Design the architecture of a Hospital Management System using MVC.
2. Explain how MVVM works with QML property bindings.
3. Compare MVC, MVP, and MVVM for desktop applications.

---

## Expert

1. Design the architecture for a Medical Treatment Planning System containing DICOM import, beam configuration, dose calculation, optimization, DVH visualization, and report generation.
2. Explain how you would structure a large Qt Widgets application to keep UI, business logic, and persistence independent.
3. Compare MVC, MVVM, and Qt's Model/View/Delegate architecture, discussing where each approach is most appropriate.

---

# 18. Revision Notes

* MVC separates Models, Views, and Controllers.
* MVP introduces a Presenter to coordinate between the View and the Model.
* MVVM introduces a ViewModel that exposes presentation-ready data.
* Qt's item-view framework is best described as Model/View/Delegate.
* QML naturally supports MVVM through property bindings.
* Qt Widgets can also implement MVVM using signals and slots.
* Enterprise applications benefit from additional layers such as Services and Repositories.
* Good architecture reduces coupling, improves testability, and simplifies maintenance.

---

# 💡 Senior Engineer Tips

## Which architecture should you choose?

| Application Type             | Recommended Architecture                         |
| ---------------------------- | ------------------------------------------------ |
| Small Qt Widgets Tool        | Simple MVC                                       |
| Large Qt Widgets Application | Layered MVC (Controller + Service + Repository)  |
| QML Desktop/Mobile App       | MVVM                                             |
| Medical TPS                  | Layered Architecture + Model/View + Services     |
| CAD Software                 | Layered MVC + Model/View                         |
| ERP                          | Layered MVC or MVVM (depending on UI technology) |

### Typical Enterprise Qt Widgets Architecture

```text
UI (QMainWindow / Dialogs)
           │
           ▼
Controller
           │
           ▼
Service Layer
           │
           ▼
Repository
           │
           ▼
Database / File System
```

For applications like a **Medical TPS**, this architecture is often combined with Qt's **Model/View Framework**. For example, a `BeamModel` may expose data to a `QTableView`, while a `BeamController` coordinates user actions and a `BeamService` performs dose-related business logic.

---



## **Chapter 63 — QFile (Complete Deep Dive)**

