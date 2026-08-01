# Complete Qt Master Course (Qt 5.15 LTS → Qt 6.11)

# PART VII — Model/View Framework

# Chapter 60 — Delegates (Complete Deep Dive)

## Master QStyledItemDelegate, Custom Painting, Editors & Cell Rendering

> **Level:** Advanced → Expert

---

# Chapter Objectives

After completing this chapter, you will understand:

* What is a Delegate?
* Why Delegates exist
* Delegate Architecture
* `QAbstractItemDelegate`
* `QStyledItemDelegate`
* Painting items
* Creating custom editors
* Editing lifecycle
* `paint()`
* `sizeHint()`
* `createEditor()`
* `setEditorData()`
* `setModelData()`
* `updateEditorGeometry()`
* Custom widgets in cells
* Performance optimization
* Enterprise applications
* Qt Internals
* Qt 5.15 vs Qt 6.11
* Best Practices
* Interview Questions

---

# Table of Contents

1. Introduction
2. Why Delegates?
3. Delegate Architecture
4. QAbstractItemDelegate
5. QStyledItemDelegate
6. Painting Items
7. Custom Editors
8. Editing Lifecycle
9. Custom Cell Rendering
10. Reusing Editors
11. Performance Optimization
12. Enterprise Applications
13. Qt Internals
14. Qt 5 vs Qt 6
15. Best Practices
16. Common Mistakes
17. Interview Questions
18. Revision Notes

---

# 1. Introduction

In the previous chapters, we learned:

* **Model** → Stores data
* **View** → Displays data

But who decides **how each cell looks**?

Who creates:

* Checkboxes
* Combo boxes
* Progress bars
* Date editors
* Custom graphics

The answer is the **Delegate**.

The Delegate is responsible for:

* Painting items
* Creating editors
* Transferring data between the editor and the model

---

## Complete Architecture

```text id="0c7p3n"
Business Data

↓

Model

↓

Delegate

↓

View

↓

Screen
```

The View asks the Delegate to paint and edit each visible item.

---

# 2. Why Delegates?

Suppose we have a patient table.

```text id="o8wyvr"
Patient

Status

Critical
```

Without a Delegate:

```text id="cxnm2l"
Critical
```

With a Delegate:

```text id="kj3d2x"
🔴 Critical
```

Or:

```text id="b5nj5d"
████████░░

80%
```

Or:

```text id="lf55jx"
☑ Completed
```

The underlying model still stores ordinary data.

The Delegate changes how it is presented.

---

# 3. Delegate Architecture

```text id="6uhh5g"
Model

↓

QStyledItemDelegate

↓

Paint Cell

↓

View

↓

User
```

---

Editing

```text id="fdyg56"
Double Click

↓

Delegate

↓

Editor Widget

↓

Model Updated
```

The View coordinates the process, but the Delegate performs the painting and editing work.

---

# 4. QAbstractItemDelegate

Header

```cpp id="sdq2gz"
#include <QAbstractItemDelegate>
```

This is the abstract base class for all delegates.

Responsibilities:

* Paint items
* Create editors
* Transfer data
* Commit edits

Normally, applications derive from `QStyledItemDelegate` instead of directly from `QAbstractItemDelegate`.

---

# 5. QStyledItemDelegate

Header

```cpp id="b2aqjx"
#include <QStyledItemDelegate>
```

Inheritance

```text id="x1t60s"
QObject

↓

QAbstractItemDelegate

↓

QStyledItemDelegate

↓

Custom Delegate
```

`QStyledItemDelegate` integrates with the application's current Qt Style, making widgets look native on each platform.

---

## Example

```cpp id="yewx86"
class PatientDelegate :
    public QStyledItemDelegate
{
};
```

This is the recommended starting point for custom delegates.

---

# 6. Painting Items

The most important painting function is:

```cpp id="3c4sfr"
paint(
    QPainter *,
    const QStyleOptionViewItem &,
    const QModelIndex &) const;
```

This function is called for every visible item.

---

## Workflow

```text id="wm0kmt"
Visible Cell

↓

View

↓

Delegate::paint()

↓

QPainter

↓

Screen
```

The delegate decides how the item is rendered.

---

## Example

Instead of:

```text id="kg6zt5"
Status

Completed
```

Paint:

```text id="djlwmz"
🟢 Completed
```

---

Or

```text id="z9g68o"
██████████

100%
```

using a progress bar style.

---

# 7. Custom Editors

Delegates also create editors.

Function:

```cpp id="w2pgw0"
createEditor()
```

Example

```text id="g4p4fr"
Double Click

↓

QLineEdit

↓

User Types

↓

Done
```

For different data types, you might return:

| Data Type | Editor      |
| --------- | ----------- |
| Text      | `QLineEdit` |
| Number    | `QSpinBox`  |
| Date      | `QDateEdit` |
| Boolean   | `QCheckBox` |
| Choice    | `QComboBox` |

---

# createEditor()

Prototype

```cpp id="zkuozr"
QWidget *createEditor(...)
```

Example

```text id="jlwmnj"
Cell

↓

Delegate

↓

QComboBox
```

This widget exists only while the user is editing.

---

# 8. Editing Lifecycle

Qt follows a well-defined editing sequence.

```text id="5fb4bh"
Double Click

↓

createEditor()

↓

setEditorData()

↓

User Edits

↓

setModelData()

↓

Model Updated

↓

View Refresh
```

Let's examine each step.

---

## setEditorData()

Copies model data into the editor.

Example:

```text id="o7evvq"
Model

Age = 25

↓

Spin Box

25
```

---

## setModelData()

Copies the edited value back into the model.

Example:

```text id="lr2g6d"
Spin Box

30

↓

Model

Age = 30
```

---

## updateEditorGeometry()

Positions the editor inside the cell.

Example:

```text id="hljmn3"
Cell

↓

Editor

↓

Correct Position
```

Without this step, the editor may appear in the wrong location.

---

# 9. Custom Cell Rendering

Delegates are commonly used to create richer visualizations.

---

## Progress Bar

```text id="kkrm6r"
██████░░░░

60%
```

Applications:

* File copy
* Downloads
* Dose optimization
* Build progress

---

## Checkbox

```text id="08rjlwm"
☑ Enabled

☐ Disabled
```

---

## Status Indicator

```text id="ppdr91"
🟢 Ready

🟡 Running

🔴 Error
```

---

## Rating

```text id="0clq7k"
★★★★★
```

---

## Color Preview

```text id="wytjlwm"
■ Red

■ Green

■ Blue
```

---

## Medical TPS Example

```text id="l0p7dt"
Structure

PTV

Dose

█████████

95%
```

The Delegate paints the dose bar while the Model stores only numerical values.

---

# 10. Reusing Editors

Qt creates editors only when needed.

Workflow

```text id="tjlwm6"
Edit Cell

↓

Editor Created

↓

Commit Data

↓

Destroy Editor
```

Some applications can reuse editors through editor factories or by carefully managing editor creation.

Creating thousands of permanent widgets inside a table is generally inefficient.

---

# Why Not `setCellWidget()`?

Many beginners do this:

```cpp id="6fjlwm"
table->setCellWidget(
    row,
    column,
    new QComboBox);
```

For:

```text id="ujlwm1"
10 Rows
```

it works.

For:

```text id="jlwmx2"
100,000 Rows
```

it consumes significant memory and reduces performance.

Delegates avoid this by creating editors only during editing.

---

# 11. Performance Optimization

## Paint Only

Keep `paint()` lightweight.

Bad:

```text id="jlwmd4"
paint()

↓

Database Query

↓

Draw
```

Good:

```text id="jlwmn5"
paint()

↓

Read Model Data

↓

Draw
```

---

## Reuse QStyle

Use the current application style when possible.

Avoid manually drawing standard controls unless necessary.

---

## Avoid Heavy Calculations

Complex image processing or network access does not belong inside `paint()`.

---

## Avoid Permanent Widgets

Prefer delegates over `setCellWidget()` for scalable applications.

---

# 12. Enterprise Applications

## Medical TPS

```text id="jlwmr6"
Beam Table

↓

Delegate

↓

Dose Bars

↓

Status Icons

↓

Checkboxes
```

---

## CAD

```text id="jlwmu7"
Layer

↓

Visible Icon

↓

Locked Icon

↓

Color Preview
```

---

## Database Manager

```text id="jlwmv8"
Table

↓

Delegate

↓

NULL

↓

Colored Cells
```

---

## IDE

```text id="jlwmw9"
Build Output

↓

Errors

↓

Warnings

↓

Icons
```

---

# 13. Qt Internals

Painting pipeline:

```text id="jlwm10"
View

↓

Visible Index

↓

Delegate::paint()

↓

QPainter

↓

Screen
```

---

Editing pipeline:

```text id="jlwm11"
User

↓

Double Click

↓

Delegate

↓

Editor Widget

↓

Model

↓

dataChanged()

↓

View Refresh
```

Notice that the Delegate sits between the View and the Model during editing.

---

# 14. Qt 5 vs Qt 6

| Feature               | Qt 5.15 | Qt 6.11 |
| --------------------- | ------- | ------- |
| `QStyledItemDelegate` | ✔       | ✔       |
| Custom Editors        | ✔       | ✔       |
| Custom Painting       | ✔       | ✔       |
| Editing Lifecycle     | ✔       | ✔       |

The Delegate API remains stable between Qt 5 and Qt 6.

---

# 15. Best Practices

✅ Derive from `QStyledItemDelegate` instead of `QAbstractItemDelegate` in most applications.

✅ Keep `paint()` focused only on rendering.

✅ Use delegates instead of `setCellWidget()` for large models.

✅ Reuse the current Qt Style where possible for native appearance.

✅ Keep editors lightweight and temporary.

---

# 16. Common Mistakes

### ❌ Creating permanent widgets for every cell

This wastes memory and hurts scrolling performance.

---

### ❌ Performing expensive calculations inside `paint()`

Painting should be fast because it occurs frequently during scrolling and updates.

---

### ❌ Forgetting to update the model in `setModelData()`

The editor changes, but the underlying data remains unchanged.

---

### ❌ Ignoring `QStyleOptionViewItem`

This can result in delegates that don't respect selection, focus, or platform styling.

---

# 17. Interview Questions

## Easy

1. What is a Delegate?
2. Why is `QStyledItemDelegate` preferred?
3. What is `paint()` used for?

---

## Medium

1. Explain the editing lifecycle.
2. What does `createEditor()` do?
3. Why are delegates better than `setCellWidget()`?

---

## Hard

1. Explain how a View, Delegate, and Model interact during editing.
2. How would you paint a custom progress bar inside a table cell?
3. How do delegates improve performance in large tables?

---

## Expert

1. Design a custom delegate for a Medical Treatment Planning System that displays beam dose percentages as colored progress bars, structure status icons, and editable prescription values.
2. Explain how to implement a reusable delegate supporting different editor widgets based on column type.
3. Compare `QStyledItemDelegate`, `QItemDelegate` (legacy), and `setCellWidget()` in terms of performance, scalability, and maintainability.

---

# 18. Revision Notes

* Delegates are responsible for painting and editing items.
* `QStyledItemDelegate` is the recommended base class.
* `paint()` renders visible items.
* `createEditor()` creates temporary editing widgets.
* `setEditorData()` copies data from the model to the editor.
* `setModelData()` writes edited values back to the model.
* `updateEditorGeometry()` positions the editor correctly.
* Delegates enable progress bars, checkboxes, combo boxes, icons, and custom rendering without creating permanent widgets.
* Proper delegates are far more scalable than `setCellWidget()`.

---

# 💡 Senior Engineer Tips

### Delegate vs `setCellWidget()`

| Feature                    | Delegate  | `setCellWidget()`     |
| -------------------------- | --------- | --------------------- |
| Memory Usage               | Very Low  | High                  |
| Scrolling Performance      | Excellent | Poor for large tables |
| Native Model/View Design   | ✔         | ✘                     |
| Suitable for 100,000+ rows | ✔         | ✘                     |
| Enterprise Applications    | ✔         | Rarely                |

> **Industry Practice:** In professional Qt applications (Medical TPS, CAD, ERP, IDEs), delegates are the standard way to customize cell appearance and editing. `setCellWidget()` is generally reserved for small, static tables where simplicity matters more than scalability.

---

## **Chapter 61 — Proxy Models (Complete Deep Dive)**

