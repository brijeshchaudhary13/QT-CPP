# Chapter 40 — Menus 
---

# 1. Introduction

Menus provide users with access to application commands.

Example:

```text
+------------------------------------------------------+
| File Edit View Tools Window Help                     |
+------------------------------------------------------+
```

Selecting:

```text
File

↓

New

Open

Save

Save As

Exit
```

Each selectable item is represented by a **`QAction`**.

---

# 2. Menu Architecture

Qt organizes menus in three layers.

```text
QMenuBar
     │
     ▼
 QMenu
     │
     ▼
QAction
```

Hierarchy:

```text
MenuBar
│
├── File
│      ├── New
│      ├── Open
│      ├── Save
│      └── Exit
│
├── Edit
│      ├── Undo
│      ├── Redo
│      ├── Copy
│      └── Paste
│
└── Help
       └── About
```

---

# 3. QMenuBar

`QMenuBar` represents the top menu bar.

Header:

```cpp
#include <QMenuBar>
```

Example:

```cpp
QMenuBar *menuBar =
    new QMenuBar;
```

Usually, with `QMainWindow`:

```cpp
QMenuBar *menu =
    mainWindow->menuBar();
```

Qt automatically creates a menu bar for `QMainWindow`.

---

# Add Menus

```cpp
QMenu *fileMenu =
    menuBar->addMenu("File");

QMenu *editMenu =
    menuBar->addMenu("Edit");

QMenu *helpMenu =
    menuBar->addMenu("Help");
```

Result:

```text
File

Edit

Help
```

---

# 4. QMenu

A `QMenu` contains actions and submenus.

Example:

```cpp
QMenu *file =
    menuBar->addMenu("&File");
```

The `&` creates a keyboard mnemonic.

Result:

```text
Alt + F
```

opens the File menu on many platforms.

---

## Add Actions

```cpp
file->addAction("New");

file->addAction("Open");

file->addAction("Save");
```

Result:

```text
File

↓

New

Open

Save
```

---

## Add Separator

```cpp
file->addSeparator();
```

Result:

```text
Open

Save

----------------

Exit
```

Separators visually group related commands.

---

# 5. QAction

`QAction` represents a command.

It is **not a visual widget**.

Instead, it stores information such as:

* Text
* Icon
* Shortcut
* Status tip
* Tool tip
* Enabled state
* Check state

Example:

```cpp
QAction *openAction =
    new QAction("Open", this);
```

---

## Add to Menu

```cpp
fileMenu->addAction(openAction);
```

---

## Connect

```cpp
connect(openAction,
        &QAction::triggered,
        this,
        &MainWindow::openFile);
```

Flow:

```text
User Clicks

↓

Open

↓

triggered()

↓

openFile()
```

---

# QAction Properties

```cpp
openAction->setText("Open");

openAction->setEnabled(true);

openAction->setVisible(true);
```

---

## Disable Action

```cpp
saveAction->setEnabled(false);
```

Result:

```text
Save

↓

Gray

↓

Cannot Click
```

Useful when:

```text
No Document Open
```

---

# 6. Action Lifecycle

Create:

```cpp
QAction *action =
    new QAction(this);
```

Configure:

```cpp
action->setText("Open");
```

Insert:

```cpp
menu->addAction(action);
```

User clicks:

```text
Click

↓

triggered()
```

Slot executes:

```text
openFile()
```

Destroy:

Automatically with the parent.

---

# Action Architecture

```text
QAction

↓

Menu

↓

Toolbar

↓

Shortcut

↓

Context Menu
```

One `QAction` can be shared across multiple UI elements.

---

# Example

```cpp
QAction *save =
    new QAction("Save", this);

fileMenu->addAction(save);

toolBar->addAction(save);
```

Result:

```text
Menu

↓

Save

Toolbar

↓

Save Button

Shortcut

↓

Ctrl+S
```

All invoke the same action.

---

# 7. Menu Ownership

Example:

```cpp
QMenu *file =
    menuBar->addMenu("File");
```

Hierarchy:

```text
MainWindow

↓

MenuBar

↓

File Menu

↓

Actions
```

Deleting the main window automatically destroys the menus and actions it owns.

---

# 8. Nested Menus

Menus can contain submenus.

Example:

```cpp
QMenu *recent =
    file->addMenu("Recent Files");
```

Result:

```text
File

↓

Recent Files

↓

Patient1

Patient2

Patient3
```

Nested menus help organize large command sets.

---

# 9. Menu States

Actions can change dynamically.

Example:

```cpp
saveAction->setEnabled(documentModified);
```

Flow:

```text
Document Modified

↓

Save Enabled

----------------

No Changes

↓

Save Disabled
```

Menus often reflect the current application state.

---

# 10. Qt Source Code Concepts

Conceptually:

```text
Mouse Click

↓

Menu Item

↓

QAction

↓

triggered()

↓

Slot

↓

Application Logic
```

`QAction` acts as the central command object connecting the UI to application logic.

---

# 11. Qt 5.15 vs Qt 6.11

| Feature      | Qt 5.15 | Qt 6.11 |
| ------------ | ------- | ------- |
| QMenuBar     | ✔       | ✔       |
| QMenu        | ✔       | ✔       |
| QAction      | ✔       | ✔       |
| Nested Menus | ✔       | ✔       |

The menu API is virtually unchanged.

---

# 12. Best Practices

✅ Reuse the same `QAction` in menus and toolbars.

✅ Group related actions with separators.

✅ Disable unavailable commands instead of hiding them in most desktop applications.

✅ Use meaningful action names.

✅ Organize menus consistently (File, Edit, View, Tools, Help).

---

# 13. Common Mistakes

### ❌ Duplicating actions

Creating separate actions for the same command can lead to inconsistent behavior.

---

### ❌ Too many top-level menus

Keep the menu bar organized and easy to scan.

---

### ❌ Deep submenu nesting

```text
File

↓

Export

↓

Medical

↓

RT

↓

Dose

↓

...
```

Avoid excessive nesting that makes commands difficult to find.

---

### ❌ Hardcoding application logic inside menu creation

Keep UI construction separate from business logic when possible.

---

# 14. Interview Questions

## Easy

1. What is `QMenuBar`?
2. What is `QMenu`?
3. What is `QAction`?

---

## Medium

1. Explain the relationship between `QMenuBar`, `QMenu`, and `QAction`.
2. Why is `QAction` not a widget?
3. How can the same action be reused?

---

## Hard

1. Explain the lifecycle of a `QAction`.
2. Describe how menu ownership works.
3. How would you build a dynamic Recent Files menu?

---

## Expert

1. Design the complete menu system for a Treatment Planning System.
2. Explain why Qt separates commands (`QAction`) from their visual representation.
3. Describe how a menu click propagates to application logic.

---

# 15. Architecture Diagram

```text
               QMainWindow
                    │
                    ▼
               QMenuBar
        ┌────────┼─────────┐
        ▼        ▼         ▼
      File      Edit      Help
        │
        ▼
     QAction
        │
        ▼
  triggered()
        │
        ▼
 Application Logic
```

---

# 🏥 Production Example — Treatment Planning System

```text
Menu Bar
│
├── File
│     ├── New Patient
│     ├── Open Patient
│     ├── Import DICOM
│     ├── Export RT Plan
│     ├── Export RT Dose
│     ├── Recent Patients
│     └── Exit
│
├── Edit
│     ├── Undo
│     ├── Redo
│     ├── Preferences
│     └── Machine Configuration
│
├── View
│     ├── Axial View
│     ├── Sagittal View
│     ├── Coronal View
│     ├── 3D View
│     └── DVH
│
├── Tools
│     ├── Dose Calculation
│     ├── Beam Optimization
│     ├── Structure Editor
│     └── QA Tools
│
└── Help
      ├── User Manual
      ├── License
      └── About
```

Every command in this menu structure is represented by a `QAction`, allowing it to be reused in toolbars, keyboard shortcuts, and context menus.

---

# 16. Revision Notes

* `QMenuBar` is the container for top-level menus.
* `QMenu` groups related actions.
* `QAction` represents an application command.
* A `QAction` is not a widget.
* One `QAction` can be shared between menus, toolbars, and shortcuts.
* Menus support separators and nested submenus.
* Menu items should reflect the application's current state through enabled and disabled actions.

---

Excellent. This is the **advanced menu chapter**.

This chapter explains how professional desktop applications such as:

* Qt Creator
* Visual Studio
* AutoCAD
* Adobe Photoshop
* Medical TPS
* Enterprise ERP

implement **dynamic menus, context menus, keyboard shortcuts, action groups, and Recent Files menus**.

These concepts are used in almost every production-quality Qt application.

---

# Complete Qt Master Course (Qt 5.15 LTS → Qt 6.11)

# PART V — GUI Programming

# Chapter 40 — Menus (Complete Deep Dive)

## Part 2 — Context Menus, QActionGroup, Keyboard Shortcuts, Dynamic Menus & Recent Files

> **Level:** Advanced → Expert

---

# Chapter Objectives

After completing this chapter, you will understand:

* Context menus
* Dynamic menus
* Checkable actions
* `QActionGroup`
* Keyboard shortcuts
* Menu icons
* Recent Files
* Tear-off menus
* Menu event flow
* Enterprise menu design

---

# Table of Contents

1. Context Menus
2. Dynamic Menus
3. Checkable Actions
4. QActionGroup
5. Keyboard Shortcuts
6. Menu Icons
7. Recent Files
8. Tear-Off Menus
9. Menu Event Flow
10. Qt 5 vs Qt 6
11. Best Practices
12. Interview Questions
13. Revision Notes

---

# 1. Context Menus

A **context menu** appears when the user right-clicks on a widget.

Example:

```text
Right Click

↓

Context Menu

↓

Copy
Paste
Delete
Properties
```

Unlike the menu bar, a context menu is shown only when needed.

---

## Create a Context Menu

```cpp
QMenu menu(this);

menu.addAction("Copy");
menu.addAction("Paste");
menu.addAction("Delete");

menu.exec(QCursor::pos());
```

Result:

```text
+------------------+

Copy

Paste

Delete

+------------------+
```

---

## Using `contextMenuEvent()`

Override:

```cpp
void MyWidget::contextMenuEvent(QContextMenuEvent *event)
{
    QMenu menu(this);

    menu.addAction("Zoom In");
    menu.addAction("Zoom Out");

    menu.exec(event->globalPos());
}
```

`event->globalPos()` ensures the menu appears at the mouse position.

---

# TPS Example

Right-click inside the CT Viewer:

```text
CT Viewer

↓

Right Click

↓

Zoom In

Zoom Out

Center Patient

Measure Distance

Add Marker

Properties
```

---

# 2. Dynamic Menus

Professional applications rarely have completely static menus.

Menu items often depend on:

* Current document
* User permissions
* Selection
* Application mode

---

## Example

```cpp
if(documentModified)
{
    saveAction->setEnabled(true);
}
else
{
    saveAction->setEnabled(false);
}
```

Result:

```text
Document Modified

↓

Save Enabled

----------------

No Changes

↓

Save Disabled
```

---

## Building Menus Dynamically

```cpp
recentMenu->clear();

for(const QString &file : recentFiles)
{
    recentMenu->addAction(file);
}
```

The menu is rebuilt based on the current application state.

---

# 3. Checkable Actions

Some menu items represent an ON/OFF state.

Example:

```cpp
QAction *gridAction =
    new QAction("Show Grid", this);

gridAction->setCheckable(true);
```

---

## Toggle State

```cpp
gridAction->setChecked(true);
```

Result:

```text
✔ Show Grid
```

Click again:

```text
□ Show Grid
```

---

Typical uses:

* Show Grid
* Snap to Grid
* Dark Theme
* Display Axes
* Show Dose Overlay

---

# 4. QActionGroup

Sometimes only one option should be selected.

Example:

```text
Axial

Sagittal

Coronal
```

Only one should be active.

---

## Create Group

```cpp
QActionGroup *group =
    new QActionGroup(this);

group->setExclusive(true);
```

---

## Add Actions

```cpp
group->addAction(axialAction);

group->addAction(sagittalAction);

group->addAction(coronalAction);
```

Result:

```text
● Axial

○ Sagittal

○ Coronal
```

Selecting Coronal:

```text
○ Axial

○ Sagittal

● Coronal
```

---

# TPS Example

View menu:

```text
View

↓

● Axial

○ Coronal

○ Sagittal

○ 3D
```

---

# 5. Keyboard Shortcuts

One of the most important usability features.

Assign:

```cpp
saveAction->setShortcut(
    QKeySequence::Save);
```

Qt automatically maps this to the platform's standard shortcut (for example, **Ctrl+S** on Windows/Linux and **⌘S** on macOS).

---

## Standard Shortcuts

| Shortcut | QKeySequence          |
| -------- | --------------------- |
| Save     | `QKeySequence::Save`  |
| Open     | `QKeySequence::Open`  |
| Copy     | `QKeySequence::Copy`  |
| Paste    | `QKeySequence::Paste` |
| Undo     | `QKeySequence::Undo`  |
| Redo     | `QKeySequence::Redo`  |

---

## Custom Shortcut

```cpp
action->setShortcut(
    QKeySequence("Ctrl+Shift+D"));
```

---

Flow:

```text
Ctrl+S

↓

QAction

↓

triggered()

↓

Save Document
```

---

# 6. Menu Icons

Menus can display icons.

```cpp
openAction->setIcon(
    QIcon(":/icons/open.png"));
```

Result:

```text
📂 Open

💾 Save

❌ Exit
```

Icons improve discoverability, but use them consistently.

---

# 7. Recent Files Menu

Professional applications usually remember recently opened files.

Example:

```text
File

↓

Recent Files

↓

Patient001

Patient002

Patient003
```

---

Typical Implementation

Maintain a list:

```cpp
QStringList recentFiles;
```

Populate the menu:

```cpp
recentMenu->clear();

for(const QString &file : recentFiles)
{
    recentMenu->addAction(file);
}
```

Store the list using `QSettings` so it persists between application launches.

---

# 8. Tear-Off Menus

Qt supports detachable menus.

Enable:

```cpp
menu->setTearOffEnabled(true);
```

Result:

```text
Menu

↓

Detach

↓

Floating Menu Window
```

This feature is uncommon in modern desktop applications but can be useful for specialized workflows.

---

# 9. Menu Event Flow

Menu processing follows this general sequence:

```text
User Clicks Menu

↓

QMenu Receives Event

↓

QAction Activated

↓

triggered() Signal

↓

Connected Slot

↓

Application Logic
```

For keyboard shortcuts:

```text
Keyboard Shortcut

↓

Shortcut System

↓

Matching QAction

↓

triggered()

↓

Slot
```

---

# 10. Enterprise Menu Design

A professional TPS might use:

```text
File
├── New Patient
├── Open Patient
├── Recent Patients
├── Import DICOM
├── Export RT Plan
├── Export RT Dose
└── Exit

View
├── ✔ Show Grid
├── ✔ Show Dose
├── ✔ Show Structures
├── ───────────────
├── ● Axial
├── ○ Coronal
├── ○ Sagittal
└── ○ 3D View

Tools
├── Dose Calculation
├── Beam Optimization
├── QA Analysis
└── Machine Configuration
```

This combines:

* Standard actions
* Checkable actions
* Exclusive action groups
* Dynamic menus

---

# 11. Qt Source Code Concepts

Conceptually:

```text
Mouse Click
      │
      ▼
QMenu
      │
      ▼
Hit Test
      │
      ▼
Matching QAction
      │
      ▼
triggered()
      │
      ▼
Slot Function
      │
      ▼
Business Logic
```

The menu itself is only responsible for presentation and dispatching. The application's functionality resides in the connected slots or command handlers.

---

# 12. Qt 5.15 vs Qt 6.11

| Feature            | Qt 5.15 | Qt 6.11 |
| ------------------ | ------- | ------- |
| Context Menus      | ✔       | ✔       |
| QActionGroup       | ✔       | ✔       |
| Checkable Actions  | ✔       | ✔       |
| Keyboard Shortcuts | ✔       | ✔       |
| Tear-Off Menus     | ✔       | ✔       |
| Dynamic Menus      | ✔       | ✔       |

These APIs are stable across both versions.

---

# 13. Best Practices

✅ Use `QAction` as the single source of truth for each command.

✅ Reuse actions across menus, toolbars, and shortcuts.

✅ Use `QActionGroup` for mutually exclusive choices.

✅ Populate Recent Files dynamically.

✅ Prefer standard `QKeySequence` values where possible.

✅ Keep context menus focused on actions relevant to the current selection.

---

# 14. Common Mistakes

### ❌ Creating duplicate actions

```text
Menu Save Action

↓

Toolbar Save Action

↓

Shortcut Save Action
```

Instead, create **one** `QAction` and reuse it everywhere.

---

### ❌ Overloaded context menus

Don't place dozens of unrelated actions into a right-click menu.

---

### ❌ Hardcoded shortcuts

Prefer:

```cpp
QKeySequence::Save
```

instead of platform-specific strings whenever a standard shortcut exists.

---

### ❌ Forgetting to update dynamic menus

Menus like **Recent Files** should reflect the current application state every time they are displayed.

---

# 15. Interview Questions

## Easy

1. What is a context menu?
2. What is a checkable action?
3. What is `QActionGroup`?

---

## Medium

1. Explain how keyboard shortcuts work with `QAction`.
2. Why should a single `QAction` be reused?
3. How would you implement a Recent Files menu?

---

## Hard

1. Explain the event flow from a menu click to application logic.
2. Describe the difference between a menu bar and a context menu.
3. When should you use exclusive action groups?

---

## Expert

1. Design the menu system for a Medical Treatment Planning System.
2. Explain how dynamic menus should be updated efficiently.
3. Compare command-based architectures using `QAction` with manually connecting individual widgets.

---

# 16. Architecture Diagram

```text
                  QMenuBar
                      │
        ┌─────────────┼─────────────┐
        ▼             ▼             ▼
      File          View         Tools
        │             │             │
        ▼             ▼             ▼
    QAction      QActionGroup    QAction
        │             │             │
        ▼             ▼             ▼
  Keyboard       Exclusive      Context Menu
  Shortcut        Selection        Action
        └─────────────┼─────────────┘
                      ▼
              triggered() Signal
                      │
                      ▼
              Application Logic
```

---

# 🏥 Production Example — Treatment Planning System

```text
Doctor Right Clicks CT Viewer
                │
                ▼
          Context Menu
                │
 ┌──────────────┼───────────────┐
 ▼              ▼               ▼
Zoom In     Measure Distance   Add Marker
 │              │               │
 ▼              ▼               ▼
QAction      QAction         QAction
                │
                ▼
          triggered()
                │
                ▼
        Update CT Viewer
```

At the same time:

* **Ctrl+S** triggers the **Save Plan** action.
* The **Save** action appears in the **File** menu.
* The same **Save** action appears on the toolbar.
* The same **Save** action can also appear in a context menu if appropriate.

All of these interfaces reuse **one `QAction`**, ensuring consistent behavior and reducing duplicated code.

---

# 17. Revision Notes

* Context menus are displayed on demand, usually via right-click.
* Dynamic menus adapt to the current application state.
* Checkable actions represent toggleable settings.
* `QActionGroup` manages mutually exclusive actions.
* Keyboard shortcuts are typically attached to `QAction`.
* Menu icons improve usability when used consistently.
* Recent Files menus are commonly populated dynamically and persisted with `QSettings`.
* One `QAction` should represent one application command, regardless of how many UI elements expose it.

---
[⬅️ Dialogs](/QDialogs.md)      |          [Toolbars ➡️](/QToolbars.md)
---
## **License**
This project is licensed under the MIT License.

---

Happy Coding!


