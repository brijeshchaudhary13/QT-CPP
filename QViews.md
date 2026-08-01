# Complete Qt Master Course (Qt 5.15 LTS → Qt 6.11)

# PART VII — Model/View Framework

# Chapter 59 — Views (Complete Deep Dive)

## Master QTableView, QListView, QTreeView & QAbstractItemView

> **Level:** Advanced → Expert

---

# Chapter Objectives

After completing this chapter, you will understand:

* What is a View?
* View Architecture
* `QAbstractItemView`
* `QTableView`
* `QListView`
* `QTreeView`
* `QHeaderView`
* Selection Behavior
* Selection Modes
* Editing Modes
* Scrolling
* Drag & Drop
* Context Menus
* Performance Optimization
* Enterprise Applications
* Qt Internals
* Qt 5.15 vs Qt 6.11
* Best Practices
* Interview Questions

---

# Table of Contents

1. Introduction
2. What is a View?
3. View Architecture
4. QAbstractItemView
5. QListView
6. QTableView
7. QTreeView
8. QHeaderView
9. Selection Behavior
10. Editing
11. Scrolling
12. Drag & Drop
13. Context Menus
14. Performance Optimization
15. Enterprise Applications
16. Qt Internals
17. Qt 5 vs Qt 6
18. Best Practices
19. Common Mistakes
20. Interview Questions
21. Revision Notes

---

# 1. Introduction

A **View** is responsible for displaying data from a Model.

A View **does not store data**.

Instead, it repeatedly asks the Model questions such as:

* How many rows?
* How many columns?
* What should be displayed here?
* Can this item be edited?

The View only knows **how to present data**, not how to store it.

---

## Example

Hospital database

```text
Database

↓

PatientModel

↓

QTableView

↓

Doctor
```

The View displays information provided by the model.

---

# 2. What is a View?

Think of a View as a **window into your data**.

One model can have many views.

```text
             PatientModel

        /         |          \

 TableView    TreeView    ListView
```

Each View presents the same data differently.

---

## Real World Example

A file system can be shown as:

```text
List View

Document1

Document2

Image.png
```

or

```text
Tree View

Documents

   Resume.pdf

   Notes.txt

Pictures

   Photo.jpg
```

Same data.

Different presentation.

---

# 3. View Architecture

Qt's architecture:

```text
Business Objects

↓

Model

↓

Delegate

↓

View

↓

User
```

---

Responsibilities:

| Component | Responsibility        |
| --------- | --------------------- |
| Model     | Data                  |
| Delegate  | Paint & Edit          |
| View      | Display & Interaction |

---

# 4. QAbstractItemView

Header

```cpp
#include <QAbstractItemView>
```

Every Qt View inherits from it.

Hierarchy:

```text
QAbstractScrollArea

↓

QAbstractItemView

├── QListView

├── QTableView

└── QTreeView
```

---

Responsibilities:

* Display data
* Mouse handling
* Keyboard navigation
* Editing
* Selection
* Drag & Drop
* Scrolling

---

# Important Functions

Set model

```cpp
view->setModel(model);
```

Retrieve current index

```cpp
view->currentIndex();
```

Current selection

```cpp
view->selectionModel();
```

---

# 5. QListView

Optimized for one-dimensional data.

Example:

```text
Patients

John

Alice

David

James
```

Works well with:

* Contact lists
* File lists
* Playlist
* Chat applications

---

Example

```cpp
QListView *view =
    new QListView;

view->setModel(model);
```

---

View Modes

```cpp
QListView::ListMode

QListView::IconMode
```

Icon Mode

```text
📁 Folder

📄 File

🖼 Image
```

---

# 6. QTableView

The most commonly used enterprise View.

Example

```text
ID    Name    Age

1     John    30

2     Alice   25
```

---

Example

```cpp
QTableView *table =
    new QTableView;

table->setModel(model);
```

---

Applications

* ERP
* Medical TPS
* SQL Viewer
* Excel-like software
* Accounting

---

Useful Features

* Sorting
* Resize columns
* Hidden columns
* Frozen columns (custom implementation)
* Grid lines
* Cell selection

---

# 7. QTreeView

Displays hierarchical data.

Example

```text
Hospital

├── Patients

├── Doctors

└── Reports
```

Applications

* File Explorer
* CAD hierarchy
* Medical structures
* Scene graph
* Object browser

---

Example

```cpp
QTreeView *tree =
    new QTreeView;

tree->setModel(model);
```

---

Expand

```cpp
tree->expand(index);
```

Collapse

```cpp
tree->collapse(index);
```

Expand all

```cpp
tree->expandAll();
```

---

# 8. QHeaderView

Every table and tree has headers.

```text
ID

Name

Age
```

Horizontal Header

```cpp
table->horizontalHeader();
```

Vertical Header

```cpp
table->verticalHeader();
```

---

Resize Modes

```cpp
QHeaderView::Interactive

QHeaderView::Stretch

QHeaderView::ResizeToContents

QHeaderView::Fixed
```

Example

```cpp
table->horizontalHeader()
     ->setSectionResizeMode(
        QHeaderView::Stretch);
```

---

# 9. Selection Behavior

Qt allows flexible selection.

---

Selection Behavior

Entire item

```cpp
SelectItems
```

Entire row

```cpp
SelectRows
```

Entire column

```cpp
SelectColumns
```

Example

```cpp
table->setSelectionBehavior(
    QAbstractItemView::SelectRows);
```

---

Selection Modes

Single

```cpp
SingleSelection
```

Multiple

```cpp
MultiSelection
```

Extended

```cpp
ExtendedSelection
```

No selection

```cpp
NoSelection
```

Example

```cpp
table->setSelectionMode(
    QAbstractItemView::ExtendedSelection);
```

---

# Example

```text
Ctrl + Click

↓

Multiple Rows Selected
```

---

# 10. Editing

Views support editing.

Edit Triggers

```cpp
DoubleClicked

SelectedClicked

EditKeyPressed

AnyKeyPressed

NoEditTriggers
```

Example

```cpp
table->setEditTriggers(
    QAbstractItemView::DoubleClicked);
```

---

Workflow

```text
Double Click

↓

Delegate

↓

Editor Widget

↓

setData()

↓

View Updated
```

---

# 11. Scrolling

Every View supports scrolling.

Policies

```cpp
Qt::ScrollBarAlwaysOn

Qt::ScrollBarAlwaysOff

Qt::ScrollBarAsNeeded
```

Example

```cpp
table->setVerticalScrollBarPolicy(
    Qt::ScrollBarAsNeeded);
```

---

Scroll to item

```cpp
table->scrollTo(index);
```

Useful in search functionality.

---

# 12. Drag & Drop

Enable dragging

```cpp
view->setDragEnabled(true);
```

Accept drops

```cpp
view->setAcceptDrops(true);
```

Enable both

```cpp
view->setDragDropMode(
    QAbstractItemView::InternalMove);
```

---

Applications

* Playlist
* Tree reorder
* Layer ordering
* CAD objects
* Medical contour ordering

---

Workflow

```text
Drag

↓

Drop

↓

Model Updated

↓

View Refresh
```

---

# 13. Context Menus

Views commonly provide right-click menus.

Example

```text
Right Click

↓

Open

Rename

Delete

Properties
```

Example

```cpp
view->setContextMenuPolicy(
    Qt::CustomContextMenu);
```

Applications

* File Explorer
* Database tools
* TPS
* CAD

---

# 14. Performance Optimization

Large datasets require optimization.

---

Use Model/View

Instead of

```text
100,000 QTableWidgetItems
```

Use

```text
QAbstractTableModel

↓

QTableView
```

---

Avoid unnecessary resizing

Bad

```cpp
ResizeToContents
```

for every update on huge tables.

Better

```cpp
Interactive
```

or

```cpp
Fixed
```

---

Uniform Row Heights

Tree View

```cpp
tree->setUniformRowHeights(true);
```

This allows Qt to calculate scrolling more efficiently when all rows have the same height.

---

Lazy Loading

Combine Views with

```text
fetchMore()
```

from the Model.

---

# 15. Enterprise Applications

---

Medical TPS

```text
PatientModel

↓

QTreeView

Patients

↓

QTableView

Dose Data

↓

Property Panel
```

---

CAD

```text
Drawing Tree

↓

Object Table

↓

Property View
```

---

ERP

```text
Customers

↓

Orders

↓

Invoices
```

---

IDE

```text
Project Tree

↓

Class Browser

↓

Search Results
```

---

# 16. Qt Internals

Rendering Pipeline

```text
View

↓

Visible Indexes

↓

Model::data()

↓

Delegate

↓

Paint

↓

Screen
```

---

Selection Pipeline

```text
Mouse Click

↓

View

↓

Selection Model

↓

Current Index

↓

Highlight
```

---

Editing Pipeline

```text
Double Click

↓

Delegate

↓

Editor

↓

Model

↓

dataChanged()

↓

View Refresh
```

The View coordinates user interaction, while the Model remains the source of truth.

---

# 17. Qt 5 vs Qt 6

| Feature     | Qt 5.15 | Qt 6.11 |
| ----------- | ------- | ------- |
| QListView   | ✔       | ✔       |
| QTableView  | ✔       | ✔       |
| QTreeView   | ✔       | ✔       |
| QHeaderView | ✔       | ✔       |
| Selection   | ✔       | ✔       |
| Editing     | ✔       | ✔       |

The core View APIs remain highly stable across Qt 5 and Qt 6.

---

# 18. Best Practices

✅ Always use `QTableView` with a custom model for enterprise applications.

✅ Keep business logic out of the View.

✅ Use `QHeaderView` to control column sizing instead of hardcoding widths.

✅ Use appropriate selection modes based on the workflow.

✅ Use lazy loading for very large datasets.

---

# 19. Common Mistakes

### ❌ Using `QTableWidget` for large datasets

`QTableView` with a custom model scales much better.

---

### ❌ Putting business logic inside the View

Views should only display and interact with data.

---

### ❌ Calling `resizeColumnsToContents()` repeatedly

This can become expensive on large tables.

---

### ❌ Ignoring selection models

Selection state should be managed through Qt's selection framework rather than manually.

---

# 20. Interview Questions

## Easy

1. What is a View?
2. What is the difference between `QTableView` and `QTableWidget`?
3. What is `QTreeView` used for?

---

## Medium

1. Explain `QAbstractItemView`.
2. What is the purpose of `QHeaderView`?
3. How does editing work in a View?

---

## Hard

1. Explain the complete rendering pipeline of `QTableView`.
2. How does a View interact with a Model and a Delegate?
3. How would you optimize a View displaying one million rows?

---

## Expert

1. Design the View architecture for a Medical Treatment Planning System containing patient lists, beam parameters, optimization results, and DVH tables.
2. Explain how multiple Views remain synchronized with one Model.
3. Design an IDE interface using `QTreeView`, `QTableView`, and custom Views.

---

# 21. Revision Notes

* A View displays data but does not own it.
* `QAbstractItemView` is the base class for Qt's item views.
* `QListView` is optimized for lists.
* `QTableView` is optimized for tabular data.
* `QTreeView` is optimized for hierarchical data.
* `QHeaderView` controls row and column headers.
* Selection behavior and selection mode are configurable.
* Editing is performed through delegates.
* Views support scrolling, drag-and-drop, and context menus.
* Efficient Views rely on custom Models and lazy loading.

---

# 💡 Senior Engineer Tips

### Choosing the Right View

| Requirement                    | Recommended View |
| ------------------------------ | ---------------- |
| Contact list                   | `QListView`      |
| SQL results                    | `QTableView`     |
| File explorer                  | `QTreeView`      |
| Medical RT Structure hierarchy | `QTreeView`      |
| Beam parameter table           | `QTableView`     |
| Dose statistics                | `QTableView`     |
| Playlist                       | `QListView`      |

### Enterprise Example (Medical TPS)

A production-grade Treatment Planning System often uses multiple views simultaneously:

```text
PatientModel
        │
        ├───────────────┬────────────────┐
        ▼               ▼                ▼
 QTreeView       QTableView      Property Panel
Patient List     Beam Table      Selected Object
```

Each view presents the same underlying data differently, ensuring consistency while serving different user workflows.

---
## **Chapter 60 — Delegates (Complete Deep Dive)**

