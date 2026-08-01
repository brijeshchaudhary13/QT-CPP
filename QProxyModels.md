# Complete Qt Master Course (Qt 5.15 LTS → Qt 6.11)

# PART VII — Model/View Framework

# Chapter 61 — Proxy Models (Complete Deep Dive)

## Master QSortFilterProxyModel, Sorting, Filtering, Index Mapping & Advanced Data Transformation

> **Level:** Advanced → Expert

---

# Chapter Objectives

After completing this chapter, you will understand:

* What is a Proxy Model?
* Why Proxy Models exist
* `QAbstractProxyModel`
* `QSortFilterProxyModel`
* Sorting
* Filtering
* Regular Expression Filtering
* Mapping Indexes
* Chaining Proxy Models
* Custom Proxy Models
* Performance Optimization
* Enterprise Applications
* Qt Internals
* Qt 5.15 vs Qt 6.11
* Best Practices
* Interview Questions

---

# Table of Contents

1. Introduction
2. Why Proxy Models?
3. Proxy Model Architecture
4. QAbstractProxyModel
5. QSortFilterProxyModel
6. Sorting
7. Filtering
8. Regular Expression Filtering
9. Mapping Indexes
10. Chaining Proxy Models
11. Custom Proxy Models
12. Performance Optimization
13. Enterprise Applications
14. Qt Internals
15. Qt 5 vs Qt 6
16. Best Practices
17. Common Mistakes
18. Interview Questions
19. Revision Notes

---

# 1. Introduction

Suppose you have a table containing **100,000 patients**.

```text id="7m31aa"
ID    Name      Age

1     John      25

2     Alice     34

3     David     41

...
```

Now the doctor wants to:

* Sort by age
* Show only cancer patients
* Search for "John"
* Hide archived records

Should the original model change?

**No.**

Instead, Qt inserts a **Proxy Model** between the Model and the View.

---

# 2. Why Proxy Models?

Without a Proxy Model:

```text id="lnw0n2"
Model

↓

Modify Data

↓

View
```

Problems:

* Original order is lost
* Filtering removes data
* Different views need different sorting

---

With a Proxy Model:

```text id="g6b6k5"
Original Model

↓

Proxy Model

↓

View
```

The original data remains untouched.

---

## Example

Medical TPS

Original Beam List

```text id="zjrmx1"
Beam 1

Beam 2

Beam 3

Beam 4
```

Proxy

```text id="9lmk7d"
Only Active Beams

Beam 1

Beam 4
```

The source model still contains all beams.

---

# 3. Proxy Model Architecture

```text id="u7xgoe"
Database

↓

Source Model

↓

Proxy Model

↓

View
```

---

Several proxies can exist simultaneously.

```text id="6dj6hm"
Source Model

↓

Sorting Proxy

↓

Filtering Proxy

↓

View
```

Each proxy has a single responsibility.

---

# 4. QAbstractProxyModel

Header

```cpp id="3wdl7l"
#include <QAbstractProxyModel>
```

This is the base class for all proxy models.

Responsibilities:

* Wrap another model
* Transform data
* Map indexes
* Forward updates

Normally, applications derive from `QSortFilterProxyModel`.

---

# 5. QSortFilterProxyModel

Header

```cpp id="7jmlkq"
#include <QSortFilterProxyModel>
```

Create:

```cpp id="qgyrh9"
QSortFilterProxyModel *proxy =
    new QSortFilterProxyModel;
```

Set source model:

```cpp id="pzx0s6"
proxy->setSourceModel(model);
```

Attach to View:

```cpp id="k7svwv"
table->setModel(proxy);
```

Architecture:

```text id="8th8l4"
Model

↓

Proxy

↓

QTableView
```

The View is unaware that it is displaying transformed data.

---

# 6. Sorting

Enable sorting in the View:

```cpp id="sln8z7"
table->setSortingEnabled(true);
```

Sort by column:

```cpp id="t6rkcz"
proxy->sort(2);
```

Ascending:

```text id="rjlwm1"
18

25

31

40
```

Descending:

```text id="jlwmr2"
40

31

25

18
```

The source model remains unchanged.

---

## Sorting Flow

```text id="jlwmr3"
Source Model

↓

Proxy Sort

↓

Sorted View
```

---

# 7. Filtering

Filter by text:

```cpp id="jlwmr4"
proxy->setFilterFixedString(
    "John");
```

Result:

```text id="jlwmr5"
John

John Smith

John Doe
```

Other rows remain in the source model.

---

## Filter Column

Example:

```cpp id="jlwmr6"
proxy->setFilterKeyColumn(1);
```

Meaning:

```text id="jlwmr7"
Only Search

Name Column
```

Instead of searching every column.

---

# 8. Regular Expression Filtering

Qt supports powerful filtering using regular expressions.

Example:

```cpp id="jlwmr8"
proxy->setFilterRegularExpression(
    "^A");
```

Matches:

```text id="jlwmr9"
Alice

Adam

Andrew
```

Does not match:

```text id="jlwm10"
John

Peter
```

---

## Qt 6 API

Qt 6 uses:

```cpp id="jlwm11"
QRegularExpression
```

instead of the older `QRegExp`.

---

# 9. Mapping Indexes

The Proxy rearranges rows.

Therefore:

```text id="jlwm12"
View Row

↓

Proxy Row

↓

Source Row
```

Qt provides mapping functions.

---

Proxy → Source

```cpp id="jlwm13"
mapToSource()
```

Source → Proxy

```cpp id="jlwm14"
mapFromSource()
```

---

Example

```text id="jlwm15"
View

Row 5

↓

Proxy

↓

Source

Row 20
```

These mappings are essential when handling selections or edits.

---

# 10. Chaining Proxy Models

Multiple Proxy Models can work together.

```text id="jlwm16"
Source Model

↓

Filter Proxy

↓

Sort Proxy

↓

View
```

Example:

```text id="jlwm17"
Patients

↓

Only Cancer

↓

Sort by Age

↓

Display
```

Each Proxy performs one transformation.

---

Advantages:

* Modular
* Reusable
* Easier debugging

---

# 11. Custom Proxy Models

Sometimes sorting and filtering are insufficient.

Example:

Medical TPS

Need:

```text id="jlwm18"
Only Show

High Priority Plans

AND

Approved Plans
```

Derive from:

```cpp id="jlwm19"
QSortFilterProxyModel
```

Override:

```cpp id="jlwm20"
filterAcceptsRow()
```

Example:

```text id="jlwm21"
Row

↓

Custom Logic

↓

Accepted

or

Rejected
```

---

You can also customize sorting by overriding:

```cpp id="jlwm22"
lessThan()
```

Example:

Sort doses numerically instead of alphabetically.

---

# 12. Performance Optimization

## Filter Only Needed Columns

Instead of searching:

```text id="jlwm23"
Every Column
```

Search only:

```text id="jlwm24"
Patient Name
```

using:

```cpp id="jlwm25"
setFilterKeyColumn()
```

---

## Avoid Repeated Filtering

Instead of:

```text id="jlwm26"
User Types

↓

Filter

↓

User Types

↓

Filter
```

Consider delaying filtering slightly in search boxes for large datasets.

---

## Avoid Heavy Work in `filterAcceptsRow()`

Bad:

```text id="jlwm27"
Database Query

↓

filterAcceptsRow()
```

Good:

```text id="jlwm28"
Cached Data

↓

filterAcceptsRow()
```

---

## Chain Small Proxies

Instead of one huge Proxy performing many unrelated tasks.

---

# 13. Enterprise Applications

---

## Medical TPS

```text id="jlwm29"
Treatment Plan Model

↓

Filter

Approved Plans

↓

Sort

Creation Date

↓

Table View
```

---

## CAD

```text id="jlwm30"
Object Model

↓

Visible Layers

↓

Sort

Object Name
```

---

## ERP

```text id="jlwm31"
Orders

↓

Pending Only

↓

Sort by Date

↓

Invoice View
```

---

## IDE

```text id="jlwm32"
Files

↓

Modified Files

↓

Alphabetical Order

↓

Project View
```

---

# 14. Qt Internals

Filtering pipeline:

```text id="jlwm33"
Source Model

↓

filterAcceptsRow()

↓

Accepted Rows

↓

View
```

Sorting pipeline:

```text id="jlwm34"
Source Model

↓

lessThan()

↓

Sorted Order

↓

View
```

Update flow:

```text id="jlwm35"
Source Model Changed

↓

Proxy Updated

↓

View Refreshed
```

The Proxy listens to source model changes and updates the transformed view automatically.

---

# 15. Qt 5 vs Qt 6

| Feature                 | Qt 5.15                          | Qt 6.11              |
| ----------------------- | -------------------------------- | -------------------- |
| `QSortFilterProxyModel` | ✔                                | ✔                    |
| Sorting                 | ✔                                | ✔                    |
| Filtering               | ✔                                | ✔                    |
| Index Mapping           | ✔                                | ✔                    |
| Regular Expressions     | `QRegExp` / `QRegularExpression` | `QRegularExpression` |

**Migration Note**

When porting from Qt 5 to Qt 6:

Replace:

```cpp
QRegExp
```

with:

```cpp
QRegularExpression
```

as `QRegExp` is no longer available in Qt 6.

---

# 16. Best Practices

✅ Keep the source model unchanged.

✅ Use `QSortFilterProxyModel` instead of modifying model data for sorting or filtering.

✅ Override `lessThan()` for custom sorting rules.

✅ Override `filterAcceptsRow()` for business-specific filtering.

✅ Map indexes correctly when communicating between the View and the source model.

---

# 17. Common Mistakes

### ❌ Editing the source model just to sort data

Sorting belongs in the Proxy.

---

### ❌ Forgetting index mapping

Selections from the View refer to proxy indexes, not source model indexes.

---

### ❌ Performing expensive work in `filterAcceptsRow()`

Filtering may be executed many times.

---

### ❌ Using one massive proxy for every transformation

Separate responsibilities when possible.

---

# 18. Interview Questions

## Easy

1. What is a Proxy Model?
2. What is `QSortFilterProxyModel`?
3. Why use a Proxy instead of modifying the Model?

---

## Medium

1. Explain index mapping.
2. How do you filter only one column?
3. What is the purpose of `lessThan()`?

---

## Hard

1. Explain the complete filtering pipeline.
2. How does a Proxy stay synchronized with the source model?
3. Why is chaining proxies useful?

---

## Expert

1. Design a filtering system for a Medical Treatment Planning System where doctors can filter by treatment status, physician, approval state, and creation date without modifying the original model.
2. Explain how to build a custom proxy model that sorts dose values numerically, filters inactive beams, and supports live search.
3. Compare performing sorting/filtering in SQL, the Model, and a Proxy Model, discussing the trade-offs of each approach.

---

# 19. Revision Notes

* A Proxy Model transforms data without modifying the source model.
* `QSortFilterProxyModel` supports sorting and filtering.
* `setSourceModel()` connects the proxy to the source model.
* `setFilterKeyColumn()` limits filtering to a specific column.
* `QRegularExpression` is used for advanced filtering in Qt 6.
* `mapToSource()` and `mapFromSource()` convert indexes between the proxy and source models.
* `lessThan()` customizes sorting.
* `filterAcceptsRow()` customizes filtering.
* Multiple Proxy Models can be chained together.

---

# 💡 Senior Engineer Tips

### When should you use a Proxy Model?

| Requirement                          | Use Proxy?                         |
| ------------------------------------ | ---------------------------------- |
| Sort table by a column               | ✔                                  |
| Search by patient name               | ✔                                  |
| Show only approved plans             | ✔                                  |
| Display only active CAD layers       | ✔                                  |
| Permanently reorder database records | ✘ (update the data source instead) |

### Medical TPS Example

```text id="tpsproxy1"
TreatmentPlanModel
          │
          ▼
ApprovalFilterProxy
          │
          ▼
DoseSortProxy
          │
          ▼
QTableView
```

This layered approach keeps the original treatment plan data intact while allowing different clinical workflows to present the same information in different ways.

---

# 🎯 Chapter 61 Complete

You now understand:

* Proxy Model architecture
* `QSortFilterProxyModel`
* Sorting
* Filtering
* Regular expression filtering
* Index mapping
* Chaining Proxy Models
* Custom filtering and sorting
* Performance optimization
* Enterprise usage
* Qt 5.15 vs Qt 6.11 compatibility

This chapter completes the transformation layer of Qt's Model/View architecture.

---

# 🚀 Next Chapter

## **Chapter 62 — MVC vs MVVM (Complete Deep Dive)**

