Excellent. **Toolbars are the second most frequently used command interface after menus.**

In professional applications, users rarely open menus repeatedly. Instead, they use toolbars because they provide **one-click access** to commonly used commands.

Applications such as:

* Qt Creator
* Visual Studio
* AutoCAD
* Adobe Photoshop
* Blender
* Medical TPS
* Enterprise ERP

all rely heavily on well-designed toolbars.

The most important concept to remember is:

> **A toolbar does not contain business logic. It displays `QAction` objects.**

The same `QAction` can simultaneously appear in:

* Menu
* Toolbar
* Context Menu
* Keyboard Shortcut

This is one of Qt's most elegant design patterns.

---

# Complete Qt Master Course (Qt 5.15 LTS → Qt 6.11)

# PART V — GUI Programming

# Chapter 41 — Toolbars (Complete Deep Dive)

## Part 1 — QToolBar, QAction Integration, Toolbar Architecture & Embedded Widgets

> **Level:** Beginner → Expert

---

# Chapter Objectives

After completing this chapter, you will understand:

* What is a toolbar?
* `QToolBar`
* Toolbar architecture
* Toolbar ownership
* `QAction` integration
* Toolbar separators
* Embedded widgets
* Toolbar lifecycle
* Qt 5 vs Qt 6

---

# Table of Contents

1. Introduction
2. Toolbar Architecture
3. QToolBar
4. Adding Actions
5. Reusing QAction
6. Toolbar Separators
7. Embedded Widgets
8. Toolbar Lifecycle
9. Qt 5 vs Qt 6
10. Best Practices
11. Interview Questions
12. Revision Notes

---

# 1. Introduction

A toolbar is a collection of frequently used commands displayed as icons, text, or both.

Example:

```text
+---------------------------------------------------------------+
| 🆕 📂 💾 | ↶ ↷ | ✂ 📋 📄 | 🔍 ➕ 🔍 ➖ |
+---------------------------------------------------------------+
```

Instead of:

```text
File

↓

Open

↓

Click
```

the user simply clicks:

```text
📂 Open
```

---

# Why Toolbars?

Menus are excellent for organizing commands.

Toolbars are excellent for **speed**.

Example:

```text
Menu

↓

File

↓

Save

↓

Click
```

versus

```text
Toolbar

↓

💾

↓

Click
```

Professional users often use toolbars hundreds of times per day.

---

# 2. Toolbar Architecture

Qt uses the following hierarchy.

```text
QMainWindow
      │
      ▼
QToolBar
      │
      ▼
QAction
```

Example:

```text
Main Window

↓

Toolbar

↓

Open Action

↓

triggered()

↓

openFile()
```

The toolbar is simply another visual representation of `QAction` objects.

---

# 3. QToolBar

Header:

```cpp
#include <QToolBar>
```

---

Create:

```cpp
QToolBar *toolBar =
    new QToolBar("File", this);
```

---

Add to Main Window:

```cpp
addToolBar(toolBar);
```

Result:

```text
+--------------------------------+

Toolbar

+--------------------------------+
```

---

Usually:

```text
Menu Bar

↓

Toolbar

↓

Central Widget

↓

Status Bar
```

---

# Toolbar Areas

Qt supports multiple docking areas.

```text
Top

Left

Right

Bottom
```

Example:

```cpp
addToolBar(
    Qt::LeftToolBarArea,
    toolBar);
```

---

Visualization:

```text
+--------------------------------------+
| Toolbar                              |
+--------------------------------------+
|                                      |
|             Central Widget           |
|                                      |
+--------------------------------------+
```

---

# 4. Adding Actions

Example:

```cpp
QAction *openAction =
    new QAction("Open", this);

toolBar->addAction(openAction);
```

Result:

```text
📂 Open
```

---

Multiple Actions:

```cpp
toolBar->addAction(newAction);

toolBar->addAction(openAction);

toolBar->addAction(saveAction);
```

Toolbar:

```text
🆕

📂

💾
```

---

Connect:

```cpp
connect(openAction,
        &QAction::triggered,
        this,
        &MainWindow::openFile);
```

---

Flow:

```text
Toolbar Button

↓

QAction

↓

triggered()

↓

Slot
```

---

# 5. Reusing QAction

One of Qt's greatest strengths.

Example:

```cpp
QAction *save =
    new QAction("Save", this);

fileMenu->addAction(save);

toolBar->addAction(save);
```

Also:

```cpp
save->setShortcut(
    QKeySequence::Save);
```

Result:

```text
Menu

↓

Save

----------------

Toolbar

↓

💾

----------------

Ctrl+S
```

Everything executes:

```text
Save Document
```

No duplicated logic.

---

# Why Reuse?

Suppose the document becomes read-only.

Simply:

```cpp
save->setEnabled(false);
```

Automatically:

```text
Menu Save

↓

Disabled

Toolbar Save

↓

Disabled

Shortcut

↓

Disabled
```

One change updates every UI representation.

---

# 6. Toolbar Separators

Separate logical groups.

Example:

```cpp
toolBar->addSeparator();
```

Result:

```text
🆕

📂

💾

------------

Undo

Redo
```

Typical grouping:

```text
File

------------

Edit

------------

View
```

---

# 7. Embedded Widgets

A toolbar is not limited to actions.

Qt allows standard widgets inside a toolbar.

---

## QComboBox

```cpp
QComboBox *combo =
    new QComboBox;

toolBar->addWidget(combo);
```

Example:

```text
Zoom

↓

100%
```

---

## QSpinBox

```cpp
QSpinBox *spin =
    new QSpinBox;

toolBar->addWidget(spin);
```

Example:

```text
Brush Size

↓

10
```

---

## QLineEdit

```cpp
QLineEdit *search =
    new QLineEdit;

toolBar->addWidget(search);
```

Example:

```text
Search...
```

---

## QPushButton

```cpp
QPushButton *button =
    new QPushButton("Run");

toolBar->addWidget(button);
```

---

Professional Example

```text
+------------------------------------------------------------+
| Open Save | Undo Redo | Zoom ▼ | Search | Beam Size | Run |
+------------------------------------------------------------+
```

---

# 8. Toolbar Ownership

Hierarchy:

```text
QMainWindow

↓

Toolbar

↓

Actions

↓

Widgets
```

Ownership generally follows the Qt parent-child model. Widgets added with `addWidget()` are reparented appropriately by the toolbar.

---

# Toolbar Lifecycle

```text
Create Toolbar

↓

Add Actions

↓

Add Widgets

↓

Add To Main Window

↓

Show

↓

User Interaction

↓

Destroy
```

---

# 9. Qt Source Code Concepts

Conceptually:

```text
Mouse Click

↓

Toolbar Button

↓

Associated QAction

↓

triggered()

↓

Slot Function

↓

Business Logic
```

Notice that the toolbar button itself does not implement the command—it delegates to the associated `QAction`.

---

# 10. Qt 5.15 vs Qt 6.11

| Feature          | Qt 5.15 | Qt 6.11 |
| ---------------- | ------- | ------- |
| QToolBar         | ✔       | ✔       |
| QAction          | ✔       | ✔       |
| Embedded Widgets | ✔       | ✔       |
| Toolbar Areas    | ✔       | ✔       |

The API is essentially unchanged.

---

# 11. Best Practices

✅ Reuse the same `QAction` in menus and toolbars.

✅ Group related actions using separators.

✅ Keep frequently used commands on the toolbar.

✅ Use embedded widgets only when they improve productivity.

✅ Keep toolbars uncluttered.

---

# 12. Common Mistakes

### ❌ Creating duplicate actions

```text
Menu Save

↓

Toolbar Save
```

These should normally reference the same `QAction`.

---

### ❌ Overcrowded toolbars

Avoid placing dozens of rarely used buttons on the main toolbar.

---

### ❌ Mixing unrelated commands

Keep file operations, editing operations, and viewing operations in separate groups.

---

### ❌ Putting large forms into a toolbar

Toolbars should remain compact.

---

# 13. Interview Questions

## Easy

1. What is `QToolBar`?
2. What is the advantage of a toolbar?
3. Can a toolbar contain widgets?

---

## Medium

1. Explain how `QAction` is shared between menus and toolbars.
2. How do you insert a separator?
3. How do you place a toolbar on the left side?

---

## Hard

1. Explain the ownership hierarchy of a toolbar.
2. Why is `QAction` considered a command object?
3. Describe the event flow when a toolbar button is clicked.

---

## Expert

1. Design the toolbar architecture for a Treatment Planning System.
2. Explain why Qt separates command objects from their visual representations.
3. Compare embedding widgets in a toolbar versus placing them in a dock widget.

---

# 14. Architecture Diagram

```text
                 QMainWindow
                      │
        ┌─────────────┴─────────────┐
        ▼                           ▼
     Menu Bar                   QToolBar
                                      │
          ┌───────────────────────────┼─────────────────────────┐
          ▼                           ▼                         ▼
      QAction(Open)             QAction(Save)             QComboBox
          │                           │                         │
          └───────────────┬───────────┴───────────────┐
                          ▼                           ▼
                     triggered()              User Selection
                          │
                          ▼
                  Application Logic
```

---

# 🏥 Production Example — Treatment Planning System

```text
+--------------------------------------------------------------------------------+
| 🆕 📂 💾 | ↶ ↷ | Import DICOM | Dose Calc | Optimize | 100% ▼ | Search Patient |
+--------------------------------------------------------------------------------+
```

Toolbar groups:

```text
File
│
├── New Patient
├── Open Patient
└── Save Plan

Edit
│
├── Undo
└── Redo

DICOM
│
└── Import

Planning
│
├── Calculate Dose
├── Optimize
└── QA Check

View
│
├── Zoom
└── Display Options
```

Each toolbar button is backed by a reusable `QAction`, ensuring consistent behavior across menus, keyboard shortcuts, and context menus.

---

# 15. Revision Notes

* `QToolBar` displays frequently used commands.
* Toolbars are usually attached to `QMainWindow`.
* `QAction` objects should be reused across menus and toolbars.
* Toolbars support separators to organize related commands.
* Widgets such as `QComboBox`, `QSpinBox`, and `QLineEdit` can be embedded in toolbars.
* Toolbar buttons invoke the associated `QAction`, which emits `triggered()`.

---
Excellent. This is the **advanced toolbar chapter**.

Professional desktop applications such as:

* Qt Creator
* Visual Studio
* AutoCAD
* Adobe Photoshop
* Blender
* Medical TPS
* Enterprise ERP

allow users to:

* Move toolbars
* Dock toolbars
* Float toolbars
* Hide/show toolbars
* Customize toolbars
* Save toolbar layouts

These capabilities make the application more flexible and improve productivity.

---

# Complete Qt Master Course (Qt 5.15 LTS → Qt 6.11)

# PART V — GUI Programming

# Chapter 41 — Toolbars (Complete Deep Dive)

## Part 2 — Movable Toolbars, Floating Toolbars, QToolButton, Customization, State Persistence & Internals

> **Level:** Advanced → Expert

---

# Chapter Objectives

After completing this chapter, you will understand:

* Movable toolbars
* Floatable toolbars
* `QToolButton`
* Toolbar customization
* Icon sizes
* Tool button styles
* Overflow handling
* Saving and restoring toolbar layouts
* Toolbar internals
* Enterprise toolbar architecture

---

# Table of Contents

1. Movable Toolbars
2. Floating Toolbars
3. QToolButton
4. Tool Button Styles
5. Icon Management
6. Toolbar Customization
7. Saving & Restoring State
8. Overflow Handling
9. Toolbar Internals
10. Qt 5 vs Qt 6
11. Best Practices
12. Interview Questions
13. Revision Notes

---

# 1. Movable Toolbars

By default, a toolbar in `QMainWindow` can usually be moved by the user.

Example:

```cpp
toolBar->setMovable(true);
```

Disable movement:

```cpp
toolBar->setMovable(false);
```

---

## Example

Before:

```text
+------------------------------------------------------+
| File Toolbar                                         |
+------------------------------------------------------+
```

User drags:

```text
+------------------------------------------------------+
| Edit Toolbar                                         |
|------------------------------------------------------|
| File Toolbar                                         |
+------------------------------------------------------+
```

Qt automatically manages the docking operation.

---

# 2. Floating Toolbars

A toolbar can be detached from the main window.

Enable floating:

```cpp
toolBar->setFloatable(true);
```

Disable:

```cpp
toolBar->setFloatable(false);
```

---

## Floating Example

Before:

```text
+---------------------------------------------+
| Toolbar                                     |
+---------------------------------------------+
```

After dragging away:

```text
Main Window

+---------------------------+
|                           |
|                           |
+---------------------------+

Floating Toolbar

+------------------+
| Open Save Undo   |
+------------------+
```

Floating toolbars behave like small independent windows.

---

# 3. Toolbar Dock Areas

A toolbar can be docked in different positions.

```cpp
addToolBar(Qt::TopToolBarArea, toolBar);
```

Other options:

```text
Qt::TopToolBarArea

Qt::BottomToolBarArea

Qt::LeftToolBarArea

Qt::RightToolBarArea
```

---

## Restrict Allowed Areas

Example:

```cpp
toolBar->setAllowedAreas(
    Qt::TopToolBarArea |
    Qt::BottomToolBarArea);
```

Now the toolbar cannot be docked on the left or right.

---

# 4. QToolButton

A toolbar usually displays `QAction` objects, but sometimes you need additional behavior.

Qt provides:

```cpp
QToolButton
```

Header:

```cpp
#include <QToolButton>
```

---

## Example

```cpp
QToolButton *button =
    new QToolButton;

button->setText("Zoom");
```

Add:

```cpp
toolBar->addWidget(button);
```

---

## Why QToolButton?

Unlike a plain action, a `QToolButton` supports features such as:

* Popup menus
* Drop-down buttons
* Custom display modes
* Delayed popup behavior

---

# 5. Tool Button Popup Modes

Suppose:

```text
Zoom ▼
```

Clicking the arrow shows:

```text
50%

100%

200%

400%
```

Example:

```cpp
button->setPopupMode(
    QToolButton::MenuButtonPopup);
```

Popup modes:

| Mode              | Description                         |
| ----------------- | ----------------------------------- |
| `DelayedPopup`    | Hold button to show menu            |
| `MenuButtonPopup` | Separate arrow opens menu           |
| `InstantPopup`    | Clicking immediately opens the menu |

---

# 6. Tool Button Styles

Qt supports different toolbar display styles.

---

## Icons Only

```cpp
toolBar->setToolButtonStyle(
    Qt::ToolButtonIconOnly);
```

Result:

```text
📂 💾 ↶ ↷
```

---

## Text Only

```cpp
Qt::ToolButtonTextOnly
```

Result:

```text
Open

Save

Undo
```

---

## Text Under Icon

```cpp
Qt::ToolButtonTextUnderIcon
```

Result:

```text
📂
Open
```

---

## Text Beside Icon

```cpp
Qt::ToolButtonTextBesideIcon
```

Result:

```text
📂 Open
```

---

# 7. Icon Size

Toolbar icon size:

```cpp
toolBar->setIconSize(
    QSize(32,32));
```

Common sizes:

```text
16×16

24×24

32×32

48×48
```

Choose a size appropriate for the application and display.

---

# 8. Toolbar Customization

Qt allows users to:

* Show or hide toolbars
* Move toolbars
* Float toolbars
* Reorder toolbars

Example:

```cpp
toolBar->toggleViewAction();
```

This returns a `QAction` that can be placed in a **View** menu.

Example:

```text
View

↓

✔ File Toolbar

✔ Edit Toolbar

✔ View Toolbar
```

The user can toggle visibility directly.

---

# 9. Saving Toolbar Layout

Professional applications remember toolbar positions.

Save:

```cpp
QSettings settings;

settings.setValue(
    "mainWindowState",
    saveState());
```

Restore:

```cpp
restoreState(
    settings.value(
        "mainWindowState").toByteArray());
```

Typical startup flow:

```text
Application Starts

↓

Read Settings

↓

Restore Toolbar Layout

↓

Restore Dock Widgets

↓

Restore Window Geometry
```

This gives users a consistent workspace every time.

---

# 10. Overflow Handling

If the window becomes too small:

```text
+------------------------------------------------------+
| Open Save Undo Redo Print Export Settings Help ...   |
+------------------------------------------------------+
```

Qt automatically creates an overflow menu for actions that no longer fit.

Conceptually:

```text
Toolbar

↓

Window Shrinks

↓

Extra Buttons Hidden

↓

Overflow Button

↓

Hidden Actions
```

No manual implementation is required.

---

# 11. Toolbar Internals

Conceptually:

```text
QMainWindow
      │
      ▼
QToolBar
      │
      ▼
QAction
      │
      ▼
QToolButton (created internally for display)
      │
      ▼
Mouse Click
      │
      ▼
triggered()
      │
      ▼
Application Logic
```

Although you add `QAction` objects, the toolbar internally creates tool buttons to present them visually.

---

# 12. Qt Source Code Concepts

When you write:

```cpp
toolBar->addAction(saveAction);
```

Qt conceptually performs:

```text
Create Internal QToolButton

↓

Associate QAction

↓

Display Icon/Text

↓

Connect Click

↓

Emit triggered()
```

This separation keeps the command (`QAction`) independent from its visual representation (`QToolButton`).

---

# 13. Qt 5.15 vs Qt 6.11

| Feature           | Qt 5.15 | Qt 6.11 |
| ----------------- | ------- | ------- |
| Movable Toolbars  | ✔       | ✔       |
| Floating Toolbars | ✔       | ✔       |
| QToolButton       | ✔       | ✔       |
| saveState()       | ✔       | ✔       |
| restoreState()    | ✔       | ✔       |

The API is stable across versions.

---

# 14. Best Practices

✅ Keep the most frequently used actions on the main toolbar.

✅ Group related commands with separators.

✅ Allow users to move and customize toolbars.

✅ Save and restore toolbar state.

✅ Use `QToolButton` for actions requiring drop-down menus.

✅ Choose icon sizes that work well on High-DPI displays.

---

# 15. Common Mistakes

### ❌ Placing every command on the toolbar

Not every menu action belongs on a toolbar.

---

### ❌ Using different actions for the same command

Always reuse the same `QAction`.

---

### ❌ Forgetting to restore toolbar state

Users expect their customized workspace to persist.

---

### ❌ Overcrowding with embedded widgets

Keep toolbars compact and focused.

---

# 16. Interview Questions

## Easy

1. What is a movable toolbar?
2. What is a floating toolbar?
3. What is `QToolButton`?

---

## Medium

1. Compare `QAction` and `QToolButton`.
2. How do you save a toolbar layout?
3. How do you change toolbar icon size?

---

## Hard

1. Explain how `QToolBar` displays `QAction` objects internally.
2. Describe toolbar docking and floating behavior.
3. How would you implement toolbar customization?

---

## Expert

1. Design the toolbar architecture for a Treatment Planning System.
2. Explain why `QAction` and `QToolButton` are separate classes.
3. Compare toolbars with ribbons and dock widgets for professional desktop applications.

---

# 17. Architecture Diagram

```text
                     QMainWindow
                           │
        ┌──────────────────┴──────────────────┐
        ▼                                     ▼
     Menu Bar                           QToolBar
                                              │
      ┌───────────────────────────────────────┼────────────────────────┐
      ▼                                       ▼                        ▼
 QAction(Open)                         QAction(Save)            QAction(Zoom)
      │                                       │                        │
      ▼                                       ▼                        ▼
 Internal QToolButton                  Internal QToolButton     QToolButton + Menu
      │                                       │                        │
      └──────────────────────────┬────────────┴────────────────────────┘
                                 ▼
                           triggered()
                                 │
                                 ▼
                        Application Logic
```

---

# 🏥 Production Example — Treatment Planning System

```text
+--------------------------------------------------------------------------------------+
| 🆕 📂 💾 | ↶ ↷ | Import | Dose Calc | Optimize | QA | Zoom ▼ | Beam ▼ | Search      |
+--------------------------------------------------------------------------------------+
```

Toolbar organization:

```text
File
├── New Patient
├── Open
└── Save

Planning
├── Import DICOM
├── Calculate Dose
├── Optimize
└── QA Analysis

View
├── Zoom ▼
├── Layout ▼
└── Display Options ▼

Patient
├── Search
└── Active Plan
```

Users can:

* Drag the toolbar to another docking area.
* Float it onto a second monitor.
* Hide unused toolbars.
* Restore their preferred layout at the next application launch.

---

# 18. Revision Notes

* Toolbars can be movable and floatable.
* `QToolButton` provides advanced button behavior such as popup menus.
* Tool button styles control how icons and text are displayed.
* Toolbar icon size can be customized.
* `toggleViewAction()` allows users to show or hide toolbars.
* `saveState()` and `restoreState()` preserve toolbar layouts.
* Qt automatically handles toolbar overflow.
* Internally, `QToolBar` displays `QAction` objects using `QToolButton` instances.

---


# 🚀 Next Chapter

## **Chapter 42 — Status Bars (Complete Deep Dive)**

