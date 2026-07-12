Excellent. **Chapter 38 is one of the most important chapters for desktop application developers.**

Every professional Qt application works with multiple windows.

Examples:

* Qt Creator
* Qt Designer
* Visual Studio
* Medical TPS
* AutoCAD
* Enterprise ERP Systems

These applications use:

* Main windows
* Dialogs
* Floating tool windows
* Dock windows
* Popup windows
* Full-screen viewers
* Multi-monitor support

Understanding window management is essential for building professional desktop applications.

---

# Complete Qt Master Course (Qt 5.15 LTS → Qt 6.11)

# PART V — GUI Programming

# Chapter 38 — Window Management (Complete Deep Dive)

## Part 1 — Top-Level Windows, Window States, Window Flags, QWidget vs QWindow & Window Lifecycle

**Level:** Beginner → Expert

---

# Chapter Objectives

After completing this chapter, you will understand:

* What a window is
* Top-level windows
* Child windows
* `QWidget` vs `QWindow`
* Window lifecycle
* Window states
* Window flags
* Window activation
* Qt 5 vs Qt 6

---

# Table of Contents

1. What is a Window?
2. Top-Level Windows
3. Child Windows
4. QWidget vs QWindow
5. Window Lifecycle
6. Window States
7. Window Flags
8. Window Activation
9. Qt5 vs Qt6
10. Best Practices
11. Interview Questions
12. Revision Notes

---

# 1. What is a Window?

A **window** is a top-level graphical object managed by the operating system.

Typical features:

* Title bar
* Borders
* Close button
* Minimize button
* Maximize button
* Resize support

Example:

```text
+---------------------------------------+
| Patient Viewer                  [X]   |
+---------------------------------------+
|                                       |
|      CT Image                         |
|                                       |
+---------------------------------------+
```

Qt creates and manages these windows while communicating with the operating system.

---

# 2. Top-Level Windows

A widget becomes a top-level window when it has **no parent widget**.

Example:

```cpp
QWidget *window = new QWidget;

window->show();
```

Hierarchy:

```text
Desktop

↓

Window
```

The operating system manages this window independently.

---

## Another Example

```cpp
QMainWindow *mainWindow =
    new QMainWindow;

mainWindow->show();
```

Result:

```text
Operating System

↓

Main Window
```

---

# Characteristics

Top-level windows:

* Have their own title bar
* Can be moved
* Can be resized
* Can receive focus independently
* Appear in the taskbar (platform-dependent)

---

# 3. Child Windows

Example:

```cpp
QPushButton *button =
    new QPushButton(parentWidget);
```

Hierarchy:

```text
Main Window

↓

Button
```

The button is **not** an operating-system window.

It is managed by Qt inside its parent.

---

## Visual Difference

Top-Level:

```text
Desktop

↓

Window
```

Child:

```text
Desktop

↓

Main Window

↓

Button
```

---

# 4. QWidget vs QWindow

This is a common interview topic.

---

## QWidget

Designed for traditional desktop widgets.

Examples:

```text
QPushButton

QLabel

QLineEdit

QDialog

QMainWindow
```

Uses Qt's Widgets framework.

---

## QWindow

Represents a native window abstraction.

Typical uses:

* OpenGL
* Vulkan
* Direct3D integration
* Custom rendering engines
* Qt Quick internals

---

# Comparison

| Feature                   | QWidget            | QWindow |
| ------------------------- | ------------------ | ------- |
| Traditional Widgets       | ✔                  | ✘       |
| Buttons                   | ✔                  | ✘       |
| Layouts                   | ✔                  | ✘       |
| Native Rendering          | Limited            | ✔       |
| OpenGL/Vulkan Integration | Via helper classes | ✔       |

For most desktop applications, `QWidget` is the correct choice.

---

# 5. Window Lifecycle

Every window follows a lifecycle.

```text
Constructor

↓

Create Native Window

↓

Show

↓

Visible

↓

Events

↓

Hide

↓

Close

↓

Destroy
```

---

## Example

```cpp
MainWindow window;

window.show();

return app.exec();
```

Execution:

```text
Constructor

↓

show()

↓

Window Created

↓

Paint Events

↓

Mouse Events

↓

Close Event

↓

Destructor
```

---

# 6. Window States

Qt supports several window states.

---

## Normal

```cpp
window.show();
```

State:

```text
Normal Window
```

---

## Maximized

```cpp
window.showMaximized();
```

State:

```text
Full Desktop

↓

Title Bar Visible
```

---

## Minimized

```cpp
window.showMinimized();
```

State:

```text
Taskbar
```

---

## Full Screen

```cpp
window.showFullScreen();
```

State:

```text
Entire Screen

↓

No Borders
```

Useful for:

* Medical image review
* Presentations
* Kiosks

---

## Restore

```cpp
window.showNormal();
```

Returns from minimized, maximized, or full-screen mode to its normal state.

---

# Window State APIs

```cpp
window.isMaximized();

window.isMinimized();

window.isFullScreen();

window.windowState();
```

---

# 7. Window Flags

Window flags control appearance and behavior.

Example:

```cpp
window.setWindowFlags(
    Qt::Window |
    Qt::WindowCloseButtonHint |
    Qt::WindowMinimizeButtonHint);
```

---

## Common Flags

| Flag                       | Purpose                  |
| -------------------------- | ------------------------ |
| `Qt::Window`               | Normal top-level window  |
| `Qt::Dialog`               | Dialog window            |
| `Qt::Tool`                 | Floating tool window     |
| `Qt::Popup`                | Popup window             |
| `Qt::FramelessWindowHint`  | No native frame          |
| `Qt::WindowStaysOnTopHint` | Keep window above others |

---

## Frameless Window

```cpp
window.setWindowFlag(
    Qt::FramelessWindowHint);
```

Used for:

* Splash screens
* Login overlays
* Custom title bars

---

# 8. Window Activation

Only one window is active at a time.

Activate:

```cpp
window.activateWindow();
```

Bring to front:

```cpp
window.raise();
```

Query:

```cpp
window.isActiveWindow();
```

---

# Example

```text
Desktop

↓

Main Window

↓

Dose Viewer

↓

Activated
```

---

# 9. Window Geometry

Position:

```cpp
window.move(100,100);
```

Size:

```cpp
window.resize(800,600);
```

Both:

```cpp
window.setGeometry(
    100,
    100,
    800,
    600);
```

Retrieve:

```cpp
QRect rect =
    window.geometry();
```

---

# 10. Close Event

When the user clicks:

```text
[X]
```

Qt generates:

```cpp
closeEvent(
    QCloseEvent *event);
```

Example:

```cpp
void MainWindow::closeEvent(
    QCloseEvent *event)
{
    event->accept();
}
```

Reject closing:

```cpp
event->ignore();
```

Useful when prompting the user to save unsaved work.

---

# 11. Qt Source Code Concepts

Conceptually:

```text
show()

↓

Platform Abstraction (QPA)

↓

Operating System

↓

Native Window Created

↓

Paint Event

↓

Visible
```

The Qt Platform Abstraction (QPA) layer translates Qt window operations into platform-specific APIs.

---

# 12. Qt 5.15 vs Qt 6.11

| Feature         | Qt 5.15 | Qt 6.11 |
| --------------- | ------- | ------- |
| Window States   | ✔       | ✔       |
| Window Flags    | ✔       | ✔       |
| QWidget Windows | ✔       | ✔       |
| QWindow         | ✔       | ✔       |

The basic window management APIs remain stable across Qt 5 and Qt 6.

---

# 13. Best Practices

✅ Use `QMainWindow` for the primary application window.

✅ Use dialogs for short user interactions.

✅ Choose window flags deliberately.

✅ Override `closeEvent()` to protect unsaved data.

✅ Use full-screen mode only when it improves the workflow.

---

# 14. Common Mistakes

### ❌ Creating multiple unnecessary top-level windows

This can clutter the user's desktop and complicate application management.

---

### ❌ Ignoring `closeEvent()`

Applications may lose unsaved work.

---

### ❌ Using `QWindow` instead of `QWidget`

Use `QWindow` only when you need low-level native rendering.

---

### ❌ Hardcoding window sizes

Prefer sensible defaults and let layouts manage the contents.

---

# 15. Interview Questions

## Easy

1. What is a top-level window?
2. What is a child widget?
3. What is `QWindow`?

---

## Medium

1. Compare `QWidget` and `QWindow`.
2. Explain window states.
3. What are window flags?

---

## Hard

1. Describe the lifecycle of a top-level window.
2. Explain how Qt creates a native window.
3. Compare frameless and normal windows.

---

## Expert

1. Design the window architecture for a Treatment Planning System.
2. Explain how `show()` interacts with the Qt Platform Abstraction layer.
3. Discuss when `QWindow` is more appropriate than `QWidget`.

---

# 16. Architecture Diagram

```text
           QApplication
                 │
                 ▼
           QMainWindow
                 │
        ┌────────┼────────┐
        ▼        ▼        ▼
    MenuBar  ToolBar  StatusBar
                 │
                 ▼
          Central Widget
                 │
                 ▼
         Child Widgets
                 │
                 ▼
      Platform Abstraction (QPA)
                 │
                 ▼
      Windows / Linux / macOS
```

---

# 🏥 Production Example — Treatment Planning System

```text
Desktop
│
├── Main Window
│      ├── Patient Browser
│      ├── CT Viewer
│      ├── Dose Viewer
│      ├── DVH Panel
│      ├── Beam Editor
│      └── Status Bar
│
├── Dose Calculation Dialog
│
├── DICOM Import Dialog
│
├── Preferences Dialog
│
└── About Dialog
```

During treatment planning:

```text
Main Window

↓

Doctor Clicks

↓

Import DICOM

↓

Modal Dialog Opens

↓

Import Completed

↓

Dialog Closes

↓

Main Window Active Again
```

This workflow prevents the user from interacting with the main window until the import operation is completed or cancelled.

---

# 17. Revision Notes

* A top-level widget has no parent widget.
* Child widgets are managed inside parent widgets.
* `QWidget` is used for traditional desktop UIs.
* `QWindow` provides lower-level native window functionality.
* Windows transition through creation, display, interaction, and destruction.
* Window flags customize appearance and behavior.
* `closeEvent()` allows an application to accept or reject closing.
* QPA connects Qt window management to the underlying operating system.

---

# 🎯 Chapter 38 — Part 1 Complete

You now understand:

* Top-level windows
* Child widgets
* `QWidget` vs `QWindow`
* Window lifecycle
* Window states
* Window flags
* Window activation
* Window geometry
* Close events
* Qt 5 → Qt 6 compatibility

This chapter forms the foundation of professional desktop window management.

---

Excellent. This is one of the **most important practical chapters** for desktop application development.

Almost every professional Qt application uses:

* Login dialogs
* Settings dialogs
* Progress dialogs
* File dialogs
* Message boxes
* Floating tool windows
* Multi-monitor support

Understanding **modal vs modeless windows** is essential.

For example, in a **Treatment Planning System (TPS)**:

* **Patient Import** should be **modal** (prevent changes while importing).
* **Dose Viewer** should be **modeless** (allow interaction with the main window).
* **Progress Window** is often **window-modal**.
* **Beam Properties Panel** is typically **modeless**.

---

# Complete Qt Master Course (Qt 5.15 LTS → Qt 6.11)

# PART V — GUI Programming

# Chapter 38 — Window Management (Complete Deep Dive)

## Part 2 — Modal Windows, Modeless Windows, QDialog, Multi-Monitor Support, High-DPI & Native Windows

> **Level:** Advanced → Expert

---

# Chapter Objectives

After completing this chapter, you will understand:

* Modal vs modeless windows
* `QDialog::exec()`
* `QDialog::open()`
* `show()`
* Window modality
* Multi-monitor support
* High-DPI windows
* Native window handles
* Window persistence
* Qt Platform Abstraction (QPA)

---

# Table of Contents

1. Modal Windows
2. Modeless Windows
3. `exec()` vs `open()` vs `show()`
4. Window Modality
5. Multi-Monitor Support
6. High-DPI Support
7. Native Window Handles
8. Window Persistence
9. QPA Internals
10. Qt 5 vs Qt 6
11. Best Practices
12. Interview Questions
13. Revision Notes

---

# 1. Modal Windows

A **modal window** blocks user interaction until it is closed.

Example:

```text
Main Window

↓

Open Dialog

↓

Main Window Disabled

↓

Close Dialog

↓

Main Window Enabled
```

Typical examples:

* Login dialog
* Password dialog
* Delete confirmation
* Patient import confirmation
* Save changes confirmation

---

## Example

```cpp
SettingsDialog dialog(this);

dialog.exec();
```

Execution:

```text
Main Window

↓

Dialog Opens

↓

User Must Finish

↓

Dialog Closes

↓

Continue Execution
```

The call to `exec()` blocks until the dialog finishes.

---

# 2. Modeless Windows

A **modeless window** does **not** block other windows.

Example:

```cpp
PropertiesWindow *window =
    new PropertiesWindow(this);

window->show();
```

Result:

```text
Main Window

↓

Properties Window

↓

Both Usable
```

The user can freely switch between them.

---

Typical examples:

* Toolbox
* Beam editor
* Color picker
* Patient browser
* Log window

---

# Comparison

| Feature         | Modal | Modeless |
| --------------- | ----- | -------- |
| Blocks Input    | ✔     | ✘        |
| User Must Close | ✔     | ✘        |
| `exec()`        | ✔     | ✘        |
| `show()`        | ✘     | ✔        |

---

# 3. exec() vs open() vs show()

This is one of the most common Qt interview questions.

---

## exec()

```cpp
dialog.exec();
```

Behavior:

```text
Open Dialog

↓

Start Local Event Loop

↓

Wait

↓

Close Dialog

↓

Return
```

Returns:

```cpp
QDialog::Accepted

QDialog::Rejected
```

Example:

```cpp
if (dialog.exec() == QDialog::Accepted)
{
    saveData();
}
```

---

## open()

```cpp
dialog.open();
```

Behavior:

```text
Open Dialog

↓

Return Immediately

↓

User Works

↓

finished(int) Signal
```

Unlike `exec()`, `open()` is asynchronous.

Handle the result using signals such as:

```cpp
connect(&dialog,
        &QDialog::finished,
        this,
        &MainWindow::onDialogFinished);
```

---

## show()

```cpp
dialog.show();
```

Behavior:

```text
Open Window

↓

Continue Execution
```

Usually used for **modeless** windows.

---

# Comparison

| Function | Blocks Caller | Local Event Loop | Typical Use                |
| -------- | ------------- | ---------------- | -------------------------- |
| `exec()` | ✔             | ✔                | Modal dialogs              |
| `open()` | ✘             | ✘                | Asynchronous modal dialogs |
| `show()` | ✘             | ✘                | Modeless windows           |

---

# 4. Window Modality

Qt supports different levels of modality.

---

## Application Modal

```cpp
dialog.setWindowModality(
    Qt::ApplicationModal);
```

Result:

```text
Application

↓

Everything Blocked
```

The user cannot interact with any window in the application.

---

## Window Modal

```cpp
dialog.setWindowModality(
    Qt::WindowModal);
```

Result:

```text
Parent Window

↓

Blocked

Other Windows

↓

Still Active
```

Only the parent window is blocked.

---

# Example

```text
Application

├── Main Window A

├── Main Window B

└── Dialog
```

Application modal:

```text
Everything Disabled
```

Window modal:

```text
Main Window A

↓

Blocked

Main Window B

↓

Still Works
```

---

# 5. Multi-Monitor Support

Qt supports multiple displays.

Example:

```cpp
QScreen *screen =
    window->screen();
```

Retrieve geometry:

```cpp
QRect rect =
    screen->geometry();
```

Example:

```text
Monitor 1

1920 × 1080

-------------------

Monitor 2

2560 × 1440
```

Move window:

```cpp
window->move(
    rect.center());
```

---

## Available Screens

```cpp
QGuiApplication::screens();
```

Returns all connected displays.

Useful for:

* Medical workstations
* Trading systems
* CAD software
* Control rooms

---

# TPS Example

```text
Monitor 1

↓

Patient List

----------------

Monitor 2

↓

CT Viewer

----------------

Monitor 3

↓

DVH

Dose Statistics
```

Many medical systems use multiple monitors for increased workspace.

---

# 6. High-DPI Support

Modern displays have:

* 125%
* 150%
* 200%
* 300%

Scaling.

Qt automatically adjusts widget rendering when High-DPI support is enabled.

---

Example:

```cpp
QScreen *screen =
    window->screen();

qreal scale =
    screen->devicePixelRatio();
```

Example:

```text
Scale = 2.0
```

One logical pixel corresponds to two physical pixels in each dimension on many high-DPI displays.

---

# High-DPI Best Practices

Use:

* Layouts
* Size policies
* Vector graphics (`SVG`) where appropriate
* High-resolution icons

Avoid:

```cpp
resize(800,600);
```

for every screen configuration.

---

# 7. Native Window Handles

Every top-level window may have an operating-system window handle.

Example:

```cpp
WId id =
    window->winId();
```

Use cases:

* Native APIs
* OpenGL
* DirectX
* Platform integration

---

Conceptually:

```text
QWidget

↓

QPA

↓

OS Window

↓

Window Handle
```

---

# 8. Window Persistence

Professional applications remember window positions.

Typical workflow:

```text
Application Exit

↓

Save Geometry

↓

Application Start

↓

Restore Geometry
```

Example:

```cpp
settings.setValue(
    "geometry",
    saveGeometry());
```

Restore:

```cpp
restoreGeometry(
    settings.value(
        "geometry").toByteArray());
```

Users appreciate applications that reopen exactly as they left them.

---

# 9. Qt Platform Abstraction (QPA)

Conceptually:

```text
show()

↓

QWidget

↓

QWindow

↓

QPA

↓

Windows

Linux

macOS
```

QPA converts Qt operations into platform-specific windowing calls.

---

# 10. Qt Source Code Concepts

Conceptually:

```text
show()

↓

Create Native Window

↓

Register Window

↓

Paint

↓

Event Loop

↓

Close

↓

Destroy Native Window
```

The exact implementation varies by platform plugin.

---

# 11. Qt 5.15 vs Qt 6.11

| Feature       | Qt 5.15 | Qt 6.11                       |
| ------------- | ------- | ----------------------------- |
| Modal Dialogs | ✔       | ✔                             |
| `exec()`      | ✔       | ✔                             |
| `open()`      | ✔       | ✔                             |
| Multi-Monitor | ✔       | ✔                             |
| High-DPI      | ✔       | ✔ (improved platform support) |

Qt 6 continues to improve High-DPI handling while preserving the same programming model.

---

# 12. Best Practices

✅ Use `exec()` only when blocking behavior is appropriate.

✅ Prefer `open()` for asynchronous dialog workflows in modern applications.

✅ Use `show()` for tool windows and modeless panels.

✅ Save and restore window geometry.

✅ Test applications on multiple monitors and different DPI settings.

---

# 13. Common Mistakes

### ❌ Calling `exec()` for every dialog

This can unnecessarily block the UI and make applications feel less responsive.

---

### ❌ Forgetting to restore window geometry

Users must reposition windows every launch.

---

### ❌ Hardcoding window positions

Different monitor layouts and resolutions make this unreliable.

---

### ❌ Ignoring High-DPI

Applications may appear blurry or incorrectly sized.

---

# 14. Interview Questions

## Easy

1. What is a modal dialog?
2. What is a modeless window?
3. What does `exec()` return?

---

## Medium

1. Compare `exec()`, `open()`, and `show()`.
2. Explain application-modal versus window-modal dialogs.
3. How do you retrieve the current screen?

---

## Hard

1. Explain how Qt supports multiple monitors.
2. Describe High-DPI support in Qt.
3. How would you persist window geometry across application launches?

---

## Expert

1. Design the window architecture for a Treatment Planning System running on three monitors.
2. Explain how `show()` reaches the operating system through QPA.
3. Compare synchronous (`exec()`) and asynchronous (`open()`) dialog workflows in large desktop applications.

---

# 15. Architecture Diagram

```text
               QApplication
                      │
                      ▼
                 Main Window
                      │
        ┌─────────────┼─────────────┐
        ▼             ▼             ▼
   Modal Dialog   Tool Window   Floating Panel
        │
        ▼
   QWindow
        │
        ▼
       QPA
        │
        ▼
 Windows / Linux / macOS
```

---

# 🏥 Production Example — Treatment Planning System

```text
                    Monitor 1
+---------------------------------------------+
| Patient Browser | Beam List | Properties    |
+---------------------------------------------+

                    Monitor 2
+---------------------------------------------+
| CT Viewer | Dose Overlay | RT Structures    |
+---------------------------------------------+

                    Monitor 3
+---------------------------------------------+
| DVH | Dose Statistics | Optimization Graphs |
+---------------------------------------------+

               Import DICOM Dialog
                      │
                      ▼
                Application Modal
                      │
                      ▼
           Import Completed Successfully
                      │
                      ▼
             Restore User Interaction
```

The dialog ensures that the patient database is not modified while a critical import operation is in progress.

---

# 16. Revision Notes

* Modal windows block user interaction until closed.
* Modeless windows remain open while the user continues working.
* `exec()` starts a local event loop and blocks until the dialog closes.
* `open()` is asynchronous and emits signals when finished.
* `show()` is typically used for modeless windows.
* Qt supports application-modal and window-modal behavior.
* Multi-monitor APIs are provided through `QScreen`.
* High-DPI support is built into Qt and works best with layouts and scalable assets.
* `saveGeometry()` and `restoreGeometry()` provide convenient window persistence.
* QPA bridges Qt window management with the native operating system.

---

# 🎯 Chapter 38 Complete

You now have a complete understanding of **Qt Window Management**, including:

* Top-level and child windows
* `QWidget` vs `QWindow`
* Window lifecycle
* Window states
* Window flags
* Modal and modeless windows
* `exec()`, `open()`, and `show()`
* Multi-monitor support
* High-DPI handling
* Native window handles
* Window persistence
* Qt Platform Abstraction (QPA)

You are now equipped to design professional, multi-window desktop applications that behave correctly across platforms and display configurations.

---

# 🚀 Next Chapter

## **Chapter 39 — Dialogs (Complete Deep Dive)**

