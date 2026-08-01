# Complete Qt Master Course (Qt 5.15 LTS → Qt 6.11)

# PART VII — Model/View Framework

# Chapter 57 — Model/View Programming (Complete Deep Dive)

## Master Qt's Model/View Architecture, Data Models, Views, Delegates & Enterprise UI Design

> **Level:** Advanced → Expert

---

# Chapter Objectives

After completing this chapter, you will understand:

* Why the Model/View Framework exists
* Problems with traditional widget-based data handling
* Qt's Model/View architecture
* Model, View, Delegate, and Selection Model
* `QAbstractItemModel`
* `QModelIndex`
* Data Roles
* Signals and notifications
* Editing workflow
* Multiple views sharing one model
* Enterprise architecture
* Qt Internals
* Qt 5.15 vs Qt 6.11
* Best Practices
* Interview Questions

---

# Table of Contents

1. Introduction
2. Why Model/View?
3. Traditional Approach vs Model/View
4. Model/View Architecture
5. Core Classes
6. `QAbstractItemModel`
7. `QModelIndex`
8. Data Roles
9. Views
10. Delegates
11. Selection Models
12. Editing Workflow
13. Multiple Views, One Model
14. Signals and Notifications
15. Enterprise Applications
16. Qt Internals
17. Qt 5 vs Qt 6
18. Best Practices
19. Common Mistakes
20. Interview Questions
21. Revision Notes

---

# 1. Introduction

Imagine you're building a Hospital Management System.

You need to display:

* 20,000 patients
* Live treatment status
* Sorting
* Filtering
* Editing
* Searching

A common beginner approach is:

```cpp
QTableWidget *table = new QTableWidget;

table->setRowCount(20000);
```

This works for small datasets.

As data grows, problems appear:

* Slow updates
* Data duplication
* Difficult maintenance
* Poor scalability

Qt solves this using the **Model/View Framework**.

---

# 2. Why Model/View?

The key idea is simple:

> **Separate the data from its visual representation.**

Instead of storing data directly inside UI widgets, keep the data in a **model**.

Views simply display that data.

---

## Real-World Example

Consider Microsoft Excel.

The spreadsheet contains data.

That same data can be:

* Displayed
* Sorted
* Filtered
* Printed
* Exported

The display changes, but the underlying data remains the same.

---

# 3. Traditional Approach vs Model/View

## Traditional Widget-Based Design

```text
Application

↓

QTableWidget

↓

Data Stored Inside Widget

↓

Display
```

Problems:

* UI owns the data
* Difficult to reuse
* Hard to synchronize
* Multiple views require duplicated data

---

## Qt Model/View

```text
          Model

         /   |   \

        /    |    \

TableView TreeView ListView
```

One model can serve many views.

---

# Example

Medical TPS

```text
Treatment Plan

↓

Dose Model

↓

Table View

↓

Tree View

↓

Statistics View
```

Every view reads the same data.

---

# 4. Model/View Architecture

Qt's complete architecture:

```text
              User
                │
                ▼
             View
                │
        Selection Model
                │
                ▼
            Delegate
                │
                ▼
             Model
                │
                ▼
          Business Data
```

Each layer has a distinct responsibility.

---

## Responsibilities

| Component       | Responsibility                    |
| --------------- | --------------------------------- |
| Model           | Stores and manages data           |
| View            | Displays data                     |
| Delegate        | Paints and edits individual items |
| Selection Model | Tracks user selection             |

---

# 5. Core Classes

Qt provides abstract base classes.

| Class                 | Purpose          |
| --------------------- | ---------------- |
| `QAbstractItemModel`  | Base model       |
| `QAbstractListModel`  | List model       |
| `QAbstractTableModel` | Table model      |
| `QAbstractProxyModel` | Base proxy model |
| `QListView`           | List display     |
| `QTableView`          | Table display    |
| `QTreeView`           | Tree display     |

Most applications derive from one of these base model classes.

---

# 6. `QAbstractItemModel`

This is the foundation of Qt's Model/View system.

Your application data is exposed through virtual functions.

Typical responsibilities include:

* Row count
* Column count
* Data retrieval
* Data modification
* Parent-child relationships (for trees)

Example:

```cpp
class PatientModel :
    public QAbstractTableModel
{
};
```

---

## Conceptual Architecture

```text
Database

↓

Patient Objects

↓

PatientModel

↓

Views
```

The model adapts business objects for presentation.

---

# 7. `QModelIndex`

Qt does not expose raw pointers to items.

Instead, it uses `QModelIndex`.

A `QModelIndex` identifies:

* Row
* Column
* Parent
* Model

---

Visualization:

```text
Table

      0    1    2

0    [ ]  [ ]  [ ]

1    [ ]  [X]  [ ]

2    [ ]  [ ]  [ ]
```

Selected cell:

```text
Row = 1

Column = 1

↓

QModelIndex
```

---

## Why Not Use Integers?

A model can represent:

* Tables
* Lists
* Trees
* Hierarchical structures

`QModelIndex` works consistently across all of them.

---

# 8. Data Roles

One item can provide different kinds of data.

Example:

| Role       | Purpose          |
| ---------- | ---------------- |
| Display    | Visible text     |
| Decoration | Icon             |
| Edit       | Editable value   |
| ToolTip    | Tooltip text     |
| Background | Background color |
| Foreground | Text color       |
| Font       | Font information |

---

Example:

Patient Status

```text
Display Role

Critical
```

Background Role

```text
Red
```

Decoration Role

```text
⚠ Icon
```

The same item supplies different data depending on the requested role.

---

# 9. Views

Views display model data.

Common views:

```text
Model

├── QListView

├── QTableView

└── QTreeView
```

Views **do not own the data**.

They simply request it from the model whenever needed.

---

# Example

```text
Patient Model

↓

Table View

↓

Doctor
```

Another view:

```text
Patient Model

↓

Tree View

↓

Administrator
```

Both remain synchronized automatically.

---

# 10. Delegates

Delegates control:

* Painting
* Editing

Visualization:

```text
Model

↓

Delegate

↓

Paint Cell

↓

Editor

↓

View
```

Examples:

Instead of displaying:

```text
Status

Completed
```

A delegate can paint:

```text
🟢 Completed
```

Or show:

* Progress bars
* Combo boxes
* Check boxes
* Spin boxes
* Custom graphics

---

# 11. Selection Models

Selections are separated from views.

Architecture:

```text
View

↓

Selection Model

↓

Current Selection
```

Benefits:

* Multiple synchronized views
* Shared selection
* Independent rendering

Example:

Selecting a patient in a table automatically highlights the same patient in another connected view.

---

# 12. Editing Workflow

Editing follows a well-defined sequence.

```text
User Double Clicks

↓

View

↓

Delegate Creates Editor

↓

User Changes Value

↓

Delegate Sends Value

↓

Model Updates Data

↓

dataChanged()

↓

View Refreshes
```

The model remains the single source of truth.

---

# 13. Multiple Views, One Model

One of the biggest advantages of Qt's architecture.

```text
                PatientModel

        /          |           \

 TableView    TreeView    StatisticsView
```

Updating the model:

```text
Database Updated

↓

Model Updated

↓

All Views Refresh Automatically
```

No duplicated data is required.

---

# 14. Signals and Notifications

The model informs connected views when data changes.

Important notifications include:

| Signal            | Purpose              |
| ----------------- | -------------------- |
| `dataChanged()`   | Cell values changed  |
| `layoutChanged()` | Layout modified      |
| `modelReset()`    | Entire model rebuilt |
| `rowsInserted()`  | New rows added       |
| `rowsRemoved()`   | Rows deleted         |

---

Workflow:

```text
Data Changes

↓

Model Emits Signal

↓

View Receives Signal

↓

Repaint Changed Area
```

Views stay synchronized automatically.

---

# 15. Enterprise Applications

## Medical TPS

```text
Treatment Plan Model

├── Beam Parameters

├── Structures

├── Dose Constraints

├── Optimization Results

└── Patient Information
```

Displayed simultaneously in:

* Table
* Tree
* Property editor

---

## CAD

```text
Drawing Model

├── Layers

├── Blocks

├── Dimensions

└── Materials
```

---

## Database Administration Tool

```text
Database Model

↓

Table View

↓

Filter View

↓

Export View
```

---

## Financial Dashboard

```text
Stock Model

↓

Table

↓

Chart

↓

Summary Panel
```

All views use the same underlying model.

---

# 16. Qt Internals

Complete architecture:

```text
Business Objects

↓

QAbstractItemModel

↓

QModelIndex

↓

Delegate

↓

View

↓

Screen
```

---

Update pipeline:

```text
Business Data

↓

Model Updated

↓

dataChanged()

↓

View Refresh

↓

Display
```

Qt minimizes unnecessary updates by refreshing only affected indexes.

---

# 17. Qt 5 vs Qt 6

| Feature              | Qt 5.15 | Qt 6.11 |
| -------------------- | ------- | ------- |
| Model/View Framework | ✔       | ✔       |
| `QAbstractItemModel` | ✔       | ✔       |
| `QModelIndex`        | ✔       | ✔       |
| Delegates            | ✔       | ✔       |
| Selection Models     | ✔       | ✔       |

The Model/View architecture is one of Qt's most stable APIs and remains essentially unchanged in Qt 6.

---

# 18. Best Practices

✅ Keep business logic out of views.

✅ Treat the model as the single source of truth.

✅ Reuse one model across multiple views whenever possible.

✅ Emit the correct model signals after data changes.

✅ Use delegates for custom rendering and editing instead of modifying views directly.

---

# 19. Common Mistakes

### ❌ Storing business data inside widgets

Keep data in the model, not the view.

---

### ❌ Updating the UI without updating the model

This causes inconsistent application state.

---

### ❌ Forgetting to emit model notifications

Views will not refresh correctly if the appropriate signals are omitted.

---

### ❌ Putting database access directly in the delegate

Delegates should focus on painting and editing, not business logic.

---

# 20. Interview Questions

## Easy

1. What is the Model/View Framework?
2. What is the difference between a model and a view?
3. What is `QModelIndex`?

---

## Medium

1. Why does Qt use `QModelIndex` instead of row and column numbers alone?
2. Explain the role of delegates.
3. How can multiple views display the same model?

---

## Hard

1. Explain the complete data flow from the model to the screen.
2. Compare `QTableWidget` with `QTableView`.
3. Why are model notifications critical?

---

## Expert

1. Design the data architecture for a Medical Treatment Planning System where treatment plans are displayed simultaneously in a table, tree, and property panel.
2. Explain how you would build a scalable CAD application using the Model/View Framework.
3. Compare Qt's Model/View architecture with a traditional MVC implementation, highlighting similarities and differences.

---


## **Chapter 58 — Models (Complete Deep Dive)**
