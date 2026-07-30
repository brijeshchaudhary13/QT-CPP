
# Chapter 44 — MDI Applications
---

# 1. Introduction to MDI

Many desktop applications allow users to open multiple documents simultaneously.

Examples:

* Microsoft Visual Studio
* Qt Designer
* Adobe Photoshop
* AutoCAD
* LibreOffice Draw
* Medical Treatment Planning Systems (TPS)

Instead of opening each document in a separate top-level window, the application manages multiple child windows inside a single main window.

This approach is called the **Multiple Document Interface (MDI)**.

---

# 2. What is SDI?

**SDI** stands for **Single Document Interface**.

An SDI application displays one document per main window.

Example:

```text
+---------------------------+
|      Main Window          |
|                           |
|      Document             |
|                           |
+---------------------------+
```

To open another document:

```text
Document A → Window 1

Document B → Window 2

Document C → Window 3
```

Examples:

* Windows Notepad
* Paint (classic versions)
* Many simple editors

---

## Advantages of SDI

* Simple implementation
* Easier window management
* Good for small applications
* Minimal memory overhead

---

## Disadvantages of SDI

* Many windows clutter the desktop.
* Hard to compare documents.
* Hard to synchronize multiple views.

---

# 3. What is MDI?

MDI stands for **Multiple Document Interface**.

One main window contains multiple document windows.

```text
+------------------------------------------------------+
| Menu  Toolbar                                        |
|------------------------------------------------------|
|                                                      |
|  +-------------+    +-------------+                  |
|  | Document A  |    | Document B  |                  |
|  |             |    |             |                  |
|  +-------------+    +-------------+                  |
|                                                      |
|          +-------------+                             |
|          | Document C  |                             |
|          +-------------+                             |
|                                                      |
+------------------------------------------------------+
```

All documents remain inside the main application.

---

# 4. SDI vs MDI

| Feature             | SDI            | MDI                           |
| ------------------- | -------------- | ----------------------------- |
| Main Windows        | Multiple       | One                           |
| Documents           | One per window | Many in one window            |
| Resource Sharing    | Limited        | Easy                          |
| Document Comparison | Difficult      | Easy                          |
| Window Management   | OS             | Application                   |
| Best For            | Simple editors | Professional desktop software |

---

# 5. MDI Architecture

Qt uses two primary classes.

```text
QMainWindow
      │
      ▼
 QMdiArea
      │
      ▼
QMdiSubWindow
      │
      ▼
Document Widget
```

Each document is usually represented by a widget.

Example:

```text
QTextEdit

QTableView

Image Viewer

Custom Widget
```

---

# 6. QMdiArea

`QMdiArea` is the central container that manages all subwindows.

Header:

```cpp
#include <QMdiArea>
```

Create:

```cpp
QMdiArea *mdiArea = new QMdiArea(this);

setCentralWidget(mdiArea);
```

The `QMdiArea` becomes the workspace where all document windows are displayed.

---

## Responsibilities

* Manage subwindows
* Activate windows
* Arrange windows
* Handle tabbed mode
* Maintain focus

---

## Architecture

```text
Main Window

↓

QMdiArea

↓

SubWindow 1

↓

SubWindow 2

↓

SubWindow 3
```

---

# 7. QMdiSubWindow

Each document lives inside a `QMdiSubWindow`.

Example:

```cpp
QMdiSubWindow *subWindow =
    mdiArea->addSubWindow(editor);
```

Where:

```cpp
editor
```

can be:

* QTextEdit
* QTableWidget
* Image Viewer
* CAD View
* Medical Image Viewer

Show it:

```cpp
subWindow->show();
```

---

# 8. Creating an MDI Application

Typical workflow:

```text
Create MainWindow

↓

Create QMdiArea

↓

Set as Central Widget

↓

Create Document Widget

↓

Add SubWindow

↓

Show
```

Example:

```cpp
QMdiArea *mdiArea = new QMdiArea;

setCentralWidget(mdiArea);

QTextEdit *editor = new QTextEdit;

mdiArea->addSubWindow(editor);

editor->show();
```

---

# 9. Window Management

Qt allows access to all open subwindows.

Example:

```cpp
mdiArea->subWindowList();
```

Returns:

```text
Window 1

Window 2

Window 3
```

Active window:

```cpp
mdiArea->activeSubWindow();
```

Activate another:

```cpp
mdiArea->setActiveSubWindow(window);
```

---

# 10. Cascading Windows

Arrange windows in a cascading layout.

```cpp
mdiArea->cascadeSubWindows();
```

Visualization:

```text
+-------------+

   +-------------+

      +-------------+
```

Useful when users need to switch quickly between multiple documents.

---

# 11. Tiling Windows

Arrange windows side by side.

```cpp
mdiArea->tileSubWindows();
```

Visualization:

```text
+----------+----------+

| Window1  | Window2  |

+----------+----------+

| Window3  | Window4  |

+----------+----------+
```

Useful for comparing multiple documents simultaneously.

---

# 12. Tabbed View Mode

Instead of floating subwindows, Qt can display each document as a tab.

```cpp
mdiArea->setViewMode(
    QMdiArea::TabbedView);
```

Visualization:

```text
+------------------------------------------------------+
| File Edit View                                       |
|------------------------------------------------------|
| [Plan A] [Plan B] [Plan C]                           |
|------------------------------------------------------|
|                                                      |
|           Active Document                            |
|                                                      |
+------------------------------------------------------+
```

This resembles modern IDEs and editors.

---

# 13. Managing Documents

Typical document lifecycle:

```text
New

↓

Edit

↓

Save

↓

Close
```

Each document can track:

* File name
* Modified state
* Window title
* Undo/Redo history

Example:

```text
Patient001.dcm *

(* indicates unsaved changes)
```

---

# 14. Menus and Toolbars

Typical MDI applications include:

```text
File
Edit
View
Window
Help
```

The **Window** menu often provides:

* Cascade
* Tile
* Next Window
* Previous Window
* Close Active
* Close All

---

# 15. Saving and Restoring State

Professional applications remember:

* Window positions
* Active document
* Tab order
* Window layout

Typically, this is implemented using `QSettings`.

Example workflow:

```text
Application Closes

↓

Save Layout

↓

Application Starts

↓

Restore Layout
```

---

# 16. Enterprise Applications

## Medical TPS

```text
Main Window

↓

QMdiArea

├── CT Viewer
├── Dose Viewer
├── DVH Viewer
├── Beam Editor
├── Structure Editor
└── Plan Comparison
```

Doctors can compare multiple plans side by side.

---

## CAD Software

```text
QMdiArea

├── Drawing A
├── Drawing B
├── Drawing C
└── Symbol Library
```

---

## IDE

```text
QMdiArea

├── main.cpp
├── patient.cpp
├── doseengine.cpp
└── CMakeLists.txt
```

---

# 17. Qt Internals

Architecture:

```text
QMainWindow
      │
      ▼
QMdiArea
      │
      ▼
QMdiSubWindow
      │
      ▼
Child Widget
```

Event flow:

```text
Mouse Click

↓

QMdiArea

↓

Active SubWindow

↓

Child Widget
```

The MDI area manages activation, focus changes, and window arrangement while forwarding input to the active child widget.

---

# 18. Qt 5.15 vs Qt 6.11

| Feature       | Qt 5.15 | Qt 6.11 |
| ------------- | ------- | ------- |
| QMdiArea      | ✔       | ✔       |
| QMdiSubWindow | ✔       | ✔       |
| Tabbed View   | ✔       | ✔       |
| Cascade       | ✔       | ✔       |
| Tile          | ✔       | ✔       |

The MDI API is stable across Qt 5 and Qt 6.

---

# 19. Best Practices

✅ Use MDI only when users genuinely benefit from multiple open documents.

✅ Use descriptive document titles.

✅ Prompt users before closing unsaved documents.

✅ Prefer tabbed MDI for modern applications unless floating windows are required.

✅ Keep document logic separate from window management.

---

# 20. Common Mistakes

### ❌ Using MDI for simple applications

If your application only opens one document at a time, SDI is often simpler.

---

### ❌ Not tracking document modification state

Users should be warned before losing unsaved work.

---

### ❌ Creating document widgets without proper ownership

Add them through `QMdiArea` so Qt manages their lifecycle correctly.

---

### ❌ Ignoring keyboard shortcuts for window navigation

Professional MDI applications usually support switching between documents efficiently.

---

# 21. Interview Questions

## Easy

1. What is MDI?
2. What is SDI?
3. What is `QMdiArea`?
4. What is `QMdiSubWindow`?

---

## Medium

1. Compare SDI and MDI.
2. How do you create a tabbed MDI interface?
3. How do you retrieve the active subwindow?

---

## Hard

1. Explain the internal architecture of Qt's MDI framework.
2. How would you implement document management in a large editor?
3. How do you save and restore an MDI workspace?

---

## Expert

1. Design an MDI architecture for a Medical Treatment Planning System supporting CT viewers, DVH graphs, beam editors, and plan comparison windows.
2. Compare MDI with modern dock-based interfaces (`QDockWidget`) and explain when each is more appropriate.
3. Design an IDE capable of opening hundreds of source files efficiently using Qt's MDI framework.

---

[⬅️ Dock Widgets](/QDockWidgets.md)      |          [Drag and Drop ➡️](/QMDIApplications.md)
---
## **License**
This project is licensed under the MIT License.

---

Happy Coding!

