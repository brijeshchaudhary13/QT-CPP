# Complete Qt Master Course (Qt 5.15 LTS → Qt 6.11)

# PART VII — Model/View Framework

# Chapter 58 — Models (Complete Deep Dive)

## Master QAbstractItemModel, QAbstractListModel, QAbstractTableModel & Custom Models

> **Level:** Advanced → Expert

---

# Chapter Objectives

After completing this chapter, you will understand:

* What is a Model?
* Model Hierarchy
* `QAbstractItemModel`
* `QAbstractListModel`
* `QAbstractTableModel`
* `QAbstractItemModel` vs `QStandardItemModel`
* Creating Custom Models
* Required Virtual Functions
* Editable Models
* Inserting & Removing Rows
* Lazy Loading (`fetchMore()`)
* Persistent Model Indexes
* Model Notifications
* Performance Optimization
* Enterprise Applications
* Qt Internals
* Qt 5.15 vs Qt 6.11
* Best Practices
* Interview Questions

---

# Table of Contents

1. Introduction
2. What is a Model?
3. Model Hierarchy
4. Types of Models
5. QAbstractItemModel
6. QAbstractListModel
7. QAbstractTableModel
8. QStandardItemModel
9. Creating a Custom Model
10. Required Virtual Functions
11. Editable Models
12. Inserting & Removing Rows
13. Lazy Loading
14. Persistent Model Indexes
15. Model Notifications
16. Performance Optimization
17. Enterprise Applications
18. Qt Internals
19. Qt 5 vs Qt 6
20. Best Practices
21. Common Mistakes
22. Interview Questions
23. Revision Notes

---

# 1. Introduction

A **Model** is the heart of Qt's Model/View architecture.

It **does not draw anything**.

It simply answers questions like:

* How many rows exist?
* How many columns exist?
* What data belongs to this cell?
* Can this item be edited?
* Can rows be inserted or removed?

The View is only responsible for displaying what the Model provides.

---

## Real Example

Imagine a hospital database.

```text
Patient Table

ID   Name      Age

1    John      45

2    Alice     32

3    David     60
```

The **database** stores the data.

The **Model** exposes that data.

The **View** displays it.

---

# 2. What is a Model?

A Model is an adapter between **business data** and the **Qt View classes**.

```text
Database

↓

Business Objects

↓

Qt Model

↓

View
```

The Model does **not** know:

* How data is painted
* Which View displays it
* Whether it is shown in a table or tree

It simply provides data.

---

# 3. Model Hierarchy

Qt provides several model base classes.

```text
                 QAbstractItemModel
                        │
          ┌─────────────┴─────────────┐
          ▼                           ▼
QAbstractListModel          QAbstractTableModel
          │                           │
          ▼                           ▼
   Custom List Model          Custom Table Model
```

---

## Which One Should You Use?

| Data Type       | Model               |
| --------------- | ------------------- |
| List            | QAbstractListModel  |
| Table           | QAbstractTableModel |
| Tree            | QAbstractItemModel  |
| Quick Prototype | QStandardItemModel  |

---

# 4. Types of Models

Qt offers two major categories.

---

## Convenience Models

Examples:

* `QStandardItemModel`
* `QStringListModel`

Advantages:

* Easy to use
* Little code
* Good for prototypes

Disadvantages:

* More memory
* Less control
* Not ideal for large datasets

---

## Custom Models

Derived from:

* `QAbstractListModel`
* `QAbstractTableModel`
* `QAbstractItemModel`

Advantages:

* Faster
* Lower memory usage
* Direct connection to business objects
* Production-ready

---

# 5. QAbstractItemModel

This is the **base class** for every model.

Header:

```cpp
#include <QAbstractItemModel>
```

Responsibilities:

* Store or expose data
* Manage indexes
* Notify views
* Support editing
* Handle hierarchy

---

## Architecture

```text
Business Objects

↓

QAbstractItemModel

↓

QModelIndex

↓

View
```

---

# Important Virtual Functions

| Function      | Purpose           |
| ------------- | ----------------- |
| rowCount()    | Number of rows    |
| columnCount() | Number of columns |
| data()        | Retrieve data     |
| setData()     | Modify data       |
| flags()       | Item behavior     |
| headerData()  | Header text       |

---

# 6. QAbstractListModel

Optimized for one-dimensional data.

Example:

```text
Patients

John

Alice

David
```

Inheritance:

```text
QAbstractItemModel

↓

QAbstractListModel

↓

PatientListModel
```

Usually only one column exists.

---

Example:

```cpp
class PatientListModel :
    public QAbstractListModel
{
};
```

Applications:

* Contact lists
* File lists
* Recent projects
* Playlist

---

# 7. QAbstractTableModel

Optimized for tables.

Example:

```text
ID    Name    Age

1     John    25

2     Alice   30
```

Inheritance:

```text
QAbstractItemModel

↓

QAbstractTableModel

↓

PatientTableModel
```

Typical enterprise applications use this class extensively.

---

Example:

```cpp
class PatientTableModel :
    public QAbstractTableModel
{
};
```

---

# 8. QStandardItemModel

Qt provides a ready-made implementation.

Example:

```cpp
QStandardItemModel *model =
    new QStandardItemModel;
```

Advantages:

* Quick development
* No custom implementation required

Disadvantages:

* Higher memory usage
* Stores every cell as a `QStandardItem`
* Less efficient for large datasets

---

## Comparison

| Feature        | QStandardItemModel | Custom Model |
| -------------- | ------------------ | ------------ |
| Easy           | ✔                  | ✘            |
| Performance    | Medium             | Excellent    |
| Memory         | Higher             | Lower        |
| Enterprise Use | Limited            | Preferred    |

---

# 9. Creating a Custom Model

Suppose we have:

```cpp
struct Patient
{
    int id;
    QString name;
    int age;
};
```

Our model stores:

```text
Patient Vector

↓

PatientModel

↓

View
```

Skeleton:

```cpp
class PatientModel :
    public QAbstractTableModel
{
public:

    int rowCount(
        const QModelIndex &) const override;

    int columnCount(
        const QModelIndex &) const override;

    QVariant data(
        const QModelIndex &,
        int role) const override;
};
```

---

# 10. Required Virtual Functions

## rowCount()

```cpp
int rowCount(
    const QModelIndex &) const override;
```

Returns:

```text
Total Rows
```

---

## columnCount()

```cpp
int columnCount(
    const QModelIndex &) const override;
```

Returns:

```text
Total Columns
```

---

## data()

```cpp
QVariant data(
    const QModelIndex &index,
    int role) const override;
```

This is the **most important function**.

Qt repeatedly calls it whenever a View needs information.

Workflow:

```text
View

↓

Requests Cell

↓

Model::data()

↓

QVariant Returned
```

---

## headerData()

Used for:

```text
ID

Name

Age
```

instead of generic column numbers.

---

# 11. Editable Models

To allow editing:

Override:

```cpp
setData()
```

and

```cpp
flags()
```

Example:

```text
Double Click

↓

Editor Opens

↓

User Changes Data

↓

setData()

↓

Model Updated
```

Remember to emit:

```text
dataChanged()
```

after successful updates.

---

# 12. Inserting & Removing Rows

Never modify the model silently.

Before insertion:

```cpp
beginInsertRows();
```

Insert data.

After insertion:

```cpp
endInsertRows();
```

---

Workflow:

```text
beginInsertRows()

↓

Insert Data

↓

endInsertRows()

↓

View Updates
```

Similarly, use:

```cpp
beginRemoveRows()

↓

Remove Data

↓

endRemoveRows()
```

These functions keep all attached views synchronized.

---

# 13. Lazy Loading

Large datasets should not be loaded all at once.

Example:

```text
Database

1 Million Rows

↓

Initially Load

100 Rows

↓

User Scrolls

↓

Load More
```

Qt supports this through:

* `canFetchMore()`
* `fetchMore()`

Benefits:

* Faster startup
* Lower memory usage
* Better responsiveness

---

# 14. Persistent Model Indexes

A normal `QModelIndex` may become invalid after structural changes.

Qt provides:

```cpp
QPersistentModelIndex
```

Advantages:

* Survives many model updates
* Useful for long-lived references

Example:

```text
Row Inserted

↓

Persistent Index

↓

Still Valid (when appropriate)
```

Use it carefully, especially when caching references.

---

# 15. Model Notifications

Views depend on model signals.

Important notifications:

| Signal          | Purpose              |
| --------------- | -------------------- |
| dataChanged()   | Cell updated         |
| layoutChanged() | Layout changed       |
| modelReset()    | Entire model rebuilt |
| rowsInserted()  | Rows added           |
| rowsRemoved()   | Rows removed         |

Workflow:

```text
Business Data

↓

Model

↓

Signal

↓

View Refresh
```

Without these notifications, views cannot stay synchronized.

---

# 16. Performance Optimization

## Return Data Quickly

`data()` is called **very frequently**.

Avoid:

```text
data()

↓

Database Query

↓

Return
```

Instead:

```text
Database

↓

Cache

↓

Model

↓

View
```

---

## Avoid Unnecessary QVariant Construction

Create only the values required for the requested role.

---

## Load Data Lazily

Use `fetchMore()` for large datasets.

---

## Avoid Frequent Model Resets

Prefer:

```text
dataChanged()
```

instead of:

```text
modelReset()
```

when only a few items change.

---

# 17. Enterprise Applications

## Medical TPS

```text
TreatmentPlanModel

├── Beam List

├── Structures

├── Dose Constraints

└── Optimization Results
```

Displayed in:

* Table View
* Tree View
* Summary Panel

---

## CAD

```text
DrawingModel

├── Layers

├── Objects

├── Materials

└── Blocks
```

---

## ERP

```text
CustomerModel

↓

Orders

↓

Invoices

↓

Reports
```

---

## File Explorer

```text
Filesystem

↓

FileModel

↓

Tree View

↓

Details View
```

---

# 18. Qt Internals

Data request pipeline:

```text
View

↓

QModelIndex

↓

Model::data()

↓

QVariant

↓

Delegate

↓

Paint
```

Insert pipeline:

```text
beginInsertRows()

↓

Container Updated

↓

endInsertRows()

↓

Views Refresh
```

Qt relies on these begin/end notifications to maintain internal consistency.

---

# 19. Qt 5 vs Qt 6

| Feature             | Qt 5.15 | Qt 6.11 |
| ------------------- | ------- | ------- |
| QAbstractItemModel  | ✔       | ✔       |
| QAbstractTableModel | ✔       | ✔       |
| QAbstractListModel  | ✔       | ✔       |
| Persistent Indexes  | ✔       | ✔       |
| Lazy Loading        | ✔       | ✔       |

The core model architecture remains stable between Qt 5 and Qt 6.

---

# 20. Best Practices

✅ Use `QAbstractTableModel` for tabular business data.

✅ Keep business data separate from UI code.

✅ Return quickly from `data()`.

✅ Emit the correct model signals after every change.

✅ Use `fetchMore()` for large datasets.

✅ Prefer custom models over `QStandardItemModel` in enterprise applications.

---

# 21. Common Mistakes

### ❌ Performing database queries inside `data()`

`data()` may be called thousands of times during painting and scrolling.

---

### ❌ Forgetting `beginInsertRows()` / `endInsertRows()`

Views may become inconsistent or crash.

---

### ❌ Returning incorrect row or column counts

Views rely on these values to create indexes.

---

### ❌ Using `modelReset()` for every small change

It causes unnecessary repaints and may invalidate selections.

---

# 22. Interview Questions

## Easy

1. What is a Qt Model?
2. What is `QAbstractTableModel`?
3. What is the purpose of `data()`?

---

## Medium

1. Compare `QStandardItemModel` and `QAbstractTableModel`.
2. Explain `fetchMore()`.
3. Why is `QPersistentModelIndex` needed?

---

## Hard

1. Explain the complete lifecycle of inserting a row into a model.
2. Why are begin/end notification functions mandatory?
3. How does `QModelIndex` interact with the model?

---

## Expert

1. Design a `PatientModel` for a Medical TPS that displays over one million treatment records efficiently.
2. Explain how you would synchronize multiple views while minimizing repaint operations.
3. Design a high-performance model backed by a database that supports sorting, filtering, and lazy loading.

---

# 23. Revision Notes

* A Model provides data to Views.
* `QAbstractItemModel` is the base class for all models.
* `QAbstractListModel` is for lists.
* `QAbstractTableModel` is for tables.
* `QStandardItemModel` is convenient but less efficient for large datasets.
* `data()` is the core function of every model.
* Use `beginInsertRows()` / `endInsertRows()` and corresponding remove functions for structural changes.
* `fetchMore()` supports lazy loading.
* `QPersistentModelIndex` survives many model updates.
* Correct model notifications keep all views synchronized.

---

# 💡 Senior Engineer Tips

### When should I use each model?

| Scenario                                          | Recommended Model                           |
| ------------------------------------------------- | ------------------------------------------- |
| Simple prototype                                  | `QStandardItemModel`                        |
| File list                                         | `QAbstractListModel`                        |
| Database table                                    | `QAbstractTableModel`                       |
| Tree hierarchy (folders, DICOM RT Structure tree) | `QAbstractItemModel`                        |
| Large enterprise application                      | Custom model derived from an abstract model |

> **Industry Practice:** In enterprise applications such as Medical TPS, CAD, ERP, and IDEs, developers almost always implement **custom models** rather than relying on `QStandardItemModel`. This gives better performance, lower memory usage, and direct integration with business objects.

---


## **Chapter 59 — Views (Complete Deep Dive)**

