Excellent.

**Chapter 43 is one of the most important chapters in professional Qt development.**

If you have ever used:

* Qt Creator
* Visual Studio
* Autodesk AutoCAD
* Blender
* Adobe Photoshop
* 3D Slicer
* Medical Treatment Planning Systems (TPS)
* Wireshark

then you have already used **Dock Widgets**.

Dock widgets are what make professional desktop software feel powerful and customizable.

Without `QDockWidget`, almost every professional desktop application would be much less flexible.

---

# Complete Qt Master Course (Qt 5.15 LTS → Qt 6.11)

# PART V — GUI Programming

# Chapter 43 — Dock Widgets (Complete Deep Dive)

## Part 1 — QDockWidget, Dock Areas, Floating, Dock Features & Workspace Architecture

> **Level:** Beginner → Expert

---

# Chapter Objectives

After completing this chapter, you will understand:

* What is a Dock Widget?
* `QDockWidget`
* Dock Areas
* Floating Dock Widgets
* Dock Features
* Dock Widget Lifecycle
* Workspace Architecture
* Qt 5 vs Qt 6

---

# Table of Contents

1. Introduction
2. What is QDockWidget?
3. Dock Areas
4. Floating Dock Widgets
5. Dock Features
6. Adding Widgets to Dock Widgets
7. Dock Widget Lifecycle
8. Workspace Architecture
9. Qt 5 vs Qt 6
10. Best Practices
11. Interview Questions
12. Revision Notes

---

# 1. Introduction

Unlike dialogs, dock widgets are designed to remain available while the user works.

Example:

```text
+--------------------------------------------------------------+
| Menu Bar                                                     |
+--------------------------------------------------------------+
| Toolbar                                                      |
+--------------------------------------------------------------+
| Patient |              CT Viewer              | Properties   |
| Browser |                                     |              |
|         |                                     |              |
|         |                                     |              |
+--------------------------------------------------------------+
| Status Bar                                                   |
+--------------------------------------------------------------+
```

Each side panel is typically a **QDockWidget**.

---

## Why Dock Widgets?

Imagine a Medical TPS.

The doctor wants to see:

* Patient Browser
* Structure List
* Beam List
* DVH
* Dose Statistics
* Properties
* Log Window

all at once.

Dialogs cannot accomplish this effectively.

Dock widgets solve this problem.

---

# 2. What is QDockWidget?

A `QDockWidget` is a movable panel that can be:

* Docked
* Undocked
* Floated
* Hidden
* Restored

Inheritance:

```text
QObject
    │
QPaintDevice
    │
QWidget
    │
QDockWidget
```

Header:

```cpp
#include <QDockWidget>
```

---

## Basic Example

```cpp
QDockWidget *dock =
    new QDockWidget("Patient Browser", this);
```

Add to the main window:

```cpp
addDockWidget(
    Qt::LeftDockWidgetArea,
    dock);
```

Result:

```text
+----------------------------------------------+
| Patient Browser |                            |
|                 |                            |
|                 |     Central Widget         |
|                 |                            |
+----------------------------------------------+
```

---

# 3. Dock Areas

Qt provides four standard docking areas.

```text
        Top

Left    Center    Right

      Bottom
```

Enumeration:

```cpp
Qt::LeftDockWidgetArea

Qt::RightDockWidgetArea

Qt::TopDockWidgetArea

Qt::BottomDockWidgetArea
```

---

## Example

```cpp
addDockWidget(
    Qt::RightDockWidgetArea,
    propertiesDock);
```

Result:

```text
+------------------------------------------------------+
|              Viewer              | Properties        |
|                                  |                   |
|                                  |                   |
+------------------------------------------------------+
```

---

# Restrict Dock Areas

Example:

```cpp
dock->setAllowedAreas(
    Qt::LeftDockWidgetArea |
    Qt::RightDockWidgetArea);
```

Now the user cannot dock it at the top or bottom.

---

# 4. Floating Dock Widgets

A dock widget can become an independent window.

Enable:

```cpp
dock->setFloating(true);
```

Result:

```text
Main Window

+----------------------+
|                      |
|                      |
+----------------------+

Floating Window

+------------------+
| Patient Browser  |
+------------------+
```

Useful for multi-monitor workstations.

---

# Check Floating State

```cpp
dock->isFloating();
```

---

# 5. Dock Features

Qt provides several configurable features.

---

## Closable

```cpp
dock->setFeatures(
    QDockWidget::DockWidgetClosable);
```

User can close the dock.

---

## Movable

```cpp
QDockWidget::DockWidgetMovable
```

Allows dragging.

---

## Floatable

```cpp
QDockWidget::DockWidgetFloatable
```

Allows detaching into a floating window.

---

## Vertical Title Bar

```cpp
QDockWidget::DockWidgetVerticalTitleBar
```

Useful when screen width is limited.

---

## All Features

```cpp
dock->setFeatures(
    QDockWidget::AllDockWidgetFeatures);
```

---

# Feature Summary

| Feature          | Purpose                      |
| ---------------- | ---------------------------- |
| Closable         | User can hide the dock       |
| Movable          | User can reposition the dock |
| Floatable        | User can undock the panel    |
| VerticalTitleBar | Saves horizontal space       |

---

# 6. Adding Widgets

A dock widget itself is only a container.

You place another widget inside it.

Example:

```cpp
QTreeWidget *tree =
    new QTreeWidget;

dock->setWidget(tree);
```

Hierarchy:

```text
MainWindow

↓

Dock Widget

↓

Tree Widget
```

---

## Other Examples

```cpp
dock->setWidget(new QListWidget);

dock->setWidget(new QTextEdit);

dock->setWidget(new QWidget);

dock->setWidget(customWidget);
```

Almost any `QWidget` can become dock content.

---

# 7. Dock Widget Lifecycle

```text
Create

↓

Set Widget

↓

Add To Main Window

↓

Show

↓

Move

↓

Float

↓

Hide

↓

Destroy
```

The lifetime usually follows the parent-child ownership model.

---

# 8. Workspace Architecture

Professional applications often have many dock widgets.

Example:

```text
+--------------------------------------------------------------------------------------+
| Menu                                                                                |
+--------------------------------------------------------------------------------------+
| Toolbar                                                                             |
+--------------------------------------------------------------------------------------+
| Patient |                         CT Viewer                       | Properties       |
| Browser |                                                         | Beam Settings    |
|         |                                                         | Dose             |
|---------+---------------------------------------------------------+------------------|
| Structure List              | DVH                                 | Log Window       |
+--------------------------------------------------------------------------------------+
| Status Bar                                                                          |
+--------------------------------------------------------------------------------------+
```

Typical dock widgets:

* Patient Browser
* Structure List
* Beam List
* Properties
* DVH
* Optimization
* Log Viewer
* Dose Statistics

---

# 9. Qt Source Code Concepts

Conceptually:

```text
Main Window
      │
      ▼
Dock Manager
      │
      ▼
QDockWidget
      │
      ▼
Contained Widget
      │
      ▼
Paint / Events
```

`QMainWindow` internally manages the docking layout and coordinates interactions between dock widgets.

---

# 10. Qt 5.15 vs Qt 6.11

| Feature       | Qt 5.15 | Qt 6.11 |
| ------------- | ------- | ------- |
| QDockWidget   | ✔       | ✔       |
| Floating      | ✔       | ✔       |
| Dock Areas    | ✔       | ✔       |
| Dock Features | ✔       | ✔       |

The API is largely unchanged.

---

# 11. Best Practices

✅ Place secondary tools inside dock widgets.

✅ Keep the central widget focused on the primary task.

✅ Allow users to move and hide docks.

✅ Group related information into separate docks.

✅ Restrict docking areas only when necessary.

---

# 12. Common Mistakes

### ❌ Putting everything in one dock

Separate responsibilities into logical panels.

---

### ❌ Using dialogs for persistent tools

Persistent tools belong in dock widgets.

---

### ❌ Filling the screen with too many visible docks

Provide sensible defaults and let users customize the layout.

---

### ❌ Embedding business logic inside dock widgets

Keep dock widgets focused on presentation and interaction.

---

# 13. Interview Questions

## Easy

1. What is `QDockWidget`?
2. What is the difference between a dock widget and a dialog?
3. What are the four dock areas?

---

## Medium

1. Explain floating dock widgets.
2. How do you restrict docking areas?
3. Why does a dock widget require another widget via `setWidget()`?

---

## Hard

1. Explain the lifecycle of a dock widget.
2. Describe how `QMainWindow` manages docking.
3. When should a panel be implemented as a dock widget instead of a toolbar?

---

## Expert

1. Design the workspace architecture of a Treatment Planning System using dock widgets.
2. Explain how floating docks improve multi-monitor workflows.
3. Compare dock widgets, dialogs, and toolbars in terms of user interaction and application architecture.

---

# 14. Architecture Diagram

```text
                      QMainWindow
                            │
      ┌─────────────────────┼─────────────────────┐
      ▼                     ▼                     ▼
 Left Dock             Central Widget        Right Dock
(Patient Tree)          (CT Viewer)         (Properties)
      │                                           │
      ▼                                           ▼
 QTreeWidget                              Custom QWidget
```

---

# 🏥 Production Example — Treatment Planning System

```text
+--------------------------------------------------------------------------------------------------------------+
| Menu Bar                                                                                                     |
+--------------------------------------------------------------------------------------------------------------+
| Toolbar                                                                                                      |
+--------------------------------------------------------------------------------------------------------------+
| Patient Browser |                CT / MR Viewer                 | Beam Properties                            |
|-----------------|                                               |--------------------------------------------|
| Structures      |                                               | Beam Energy                               |
| Beam List       |                                               | Gantry Angle                              |
| Plans           |                                               | Collimator                                |
|                 |                                               | MLC Settings                              |
|-----------------|-----------------------------------------------|--------------------------------------------|
| DVH             | Dose Statistics                               | Optimization                              |
+--------------------------------------------------------------------------------------------------------------+
| Status Bar                                                                                                   |
+--------------------------------------------------------------------------------------------------------------+
```

Each panel is implemented as an independent `QDockWidget`, allowing clinicians to rearrange the workspace according to their preferences.

---

# 15. Revision Notes

* `QDockWidget` creates movable, dockable panels.
* Dock widgets are managed by `QMainWindow`.
* A dock widget hosts another widget through `setWidget()`.
* Dock widgets can be docked, floated, hidden, or restored.
* Dock features control whether a dock is closable, movable, floatable, or uses a vertical title bar.
* Dock widgets are ideal for persistent tools and information panels.

---

Excellent.

This is the **most advanced Dock Widget chapter**. Mastering these topics will allow you to build desktop applications with workspaces comparable to **Qt Creator, Visual Studio, AutoCAD, 3D Slicer, Blender, and Medical Treatment Planning Systems (TPS)**.

The most important concept is:

> **The workspace itself becomes customizable.**

Users can decide:

* Which panels are visible
* Where panels are docked
* Which monitor displays a panel
* Which panels are tabbed together
* Whether panels are floating
* How the entire workspace is saved and restored

This is one of the biggest advantages of `QMainWindow`.

---

# Complete Qt Master Course (Qt 5.15 LTS → Qt 6.11)

# PART V — GUI Programming

# Chapter 43 — Dock Widgets (Complete Deep Dive)

## Part 2 — Tabified Docks, Nested Docking, Workspace Persistence, Custom Title Bars & Docking Internals

> **Level:** Advanced → Expert

---

# Chapter Objectives

After completing this chapter, you will understand:

* Tabified dock widgets
* Nested docking
* Dock widget signals
* Saving/restoring workspace layouts
* Custom title bars
* Visibility management
* Docking engine internals
* Enterprise workspace design

---

# Table of Contents

1. Tabified Dock Widgets
2. Nested Docking
3. Dock Widget Signals
4. Visibility Management
5. Saving & Restoring Workspace
6. Custom Dock Title Bars
7. Docking Engine Internals
8. Performance Optimization
9. Qt 5 vs Qt 6
10. Best Practices
11. Interview Questions
12. Revision Notes

---

# 1. Tabified Dock Widgets

Professional applications often group multiple dock widgets into a single tabbed area.

Example:

```text
+------------------------------------------------------+
| Patient | Structures | Beams | DVH |
+------------------------------------------------------+
|                                              |
|              Dock Content                    |
|                                              |
+------------------------------------------------------+
```

Instead of displaying four separate dock widgets side by side, Qt can stack them as tabs.

---

## Creating Tabified Docks

```cpp
tabifyDockWidget(patientDock, structureDock);

tabifyDockWidget(structureDock, beamDock);

tabifyDockWidget(beamDock, dvhDock);
```

Result:

```text
Patient | Structures | Beams | DVH
```

The user switches between tabs just like a web browser.

---

## Select Active Tab

```cpp
patientDock->raise();
```

This brings the corresponding dock tab to the front.

---

# TPS Example

```text
Left Dock

+--------------------------------------+

Patient

Structures

Beam List

Plans

----------------------------------------

Current Selected Panel

+--------------------------------------+
```

---

# 2. Nested Docking

By default, docks occupy separate areas.

Qt also supports **nested docking**.

Enable:

```cpp
setDockNestingEnabled(true);
```

---

Without nesting:

```text
+-------------------------------+
| Left Dock                     |
+-------------------------------+
| Central Widget                |
+-------------------------------+
```

With nesting:

```text
+---------------------------------------------+
| Patient | Structures                        |
|---------+-----------------------------------|
|         |                                   |
| Viewer  | Properties                        |
|         |                                   |
+---------------------------------------------+
```

Nested layouts make better use of screen space.

---

# 3. Dock Widget Signals

Dock widgets emit useful signals when their state changes.

---

## Visibility Changed

```cpp
connect(dock,
        &QDockWidget::visibilityChanged,
        this,
        &MainWindow::onDockVisibilityChanged);
```

Useful for:

* Updating menu checkmarks
* Saving workspace state
* Lazy loading data

---

## Top Level Changed

```cpp
connect(dock,
        &QDockWidget::topLevelChanged,
        this,
        &MainWindow::onFloatingChanged);
```

This signal is emitted when the dock changes between:

```text
Docked

↓

Floating
```

---

## Dock Location Changed

```cpp
connect(dock,
        &QDockWidget::dockLocationChanged,
        this,
        &MainWindow::onDockAreaChanged);
```

Useful for responding when a user moves a panel.

---

# 4. Visibility Management

Show:

```cpp
dock->show();
```

Hide:

```cpp
dock->hide();
```

Check:

```cpp
dock->isVisible();
```

---

## Toggle Visibility

```cpp
viewMenu->addAction(
    dock->toggleViewAction());
```

Result:

```text
View

✔ Patient Browser

✔ Structures

✔ DVH

✔ Beam List
```

Users can control which panels are displayed.

---

# 5. Saving & Restoring Workspace

One of the most valuable features in professional applications.

---

## Save Layout

```cpp
QSettings settings;

settings.setValue(
    "windowState",
    saveState());

settings.setValue(
    "geometry",
    saveGeometry());
```

---

## Restore Layout

```cpp
restoreGeometry(
    settings.value("geometry").toByteArray());

restoreState(
    settings.value("windowState").toByteArray());
```

---

Workflow:

```text
Application Exit

↓

Save Geometry

↓

Save Dock Positions

↓

Save Toolbar Positions

↓

Application Starts

↓

Restore Everything
```

Users expect the workspace to look exactly as they left it.

---

# 6. Custom Dock Title Bars

Qt allows replacing the default title bar.

Example:

```cpp
QWidget *customTitle =
    new QWidget;

dock->setTitleBarWidget(customTitle);
```

Possible additions:

* Search box
* Pin button
* Settings button
* Refresh button
* Custom colors

---

Example:

```text
+-------------------------------------------+
| Patient Browser    🔍  📌  ⚙  ↻          |
+-------------------------------------------+
```

---

# 7. Docking Engine Internals

Conceptually:

```text
QMainWindow
      │
      ▼
Dock Manager
      │
      ▼
Layout Engine
      │
      ▼
Dock Widgets
      │
      ▼
Contained Widgets
```

When the user drags a dock:

```text
Mouse Drag

↓

Hit Testing

↓

Dock Target Detection

↓

Dock Preview

↓

Drop

↓

Layout Recalculation

↓

Repaint
```

Qt handles all of this automatically.

---

# 8. Performance Optimization

Large applications may contain many dock widgets.

### Good Practice

Create lightweight dock widgets.

Load expensive content only when needed.

Example:

```text
User Opens DVH Dock

↓

Load DVH Graph

↓

Display
```

instead of loading every dock during startup.

---

## Lazy Initialization

```text
Application Starts

↓

Create Empty Dock

↓

User Opens Dock

↓

Initialize Widget

↓

Display
```

This reduces startup time.

---

# 9. Enterprise Workspace Example

```text
+--------------------------------------------------------------------------------------------------------------+
| Menu Bar                                                                                                     |
+--------------------------------------------------------------------------------------------------------------+
| Toolbar                                                                                                      |
+--------------------------------------------------------------------------------------------------------------+
| Patient | Structures | Plans |                    CT Viewer                     | Beam | Properties | DVH   |
|---------+---------------------+--------------------------------------------------+---------------------------|
|         |                     |                                                  |                           |
|         |                     |                                                  |                           |
|         |                     |                                                  |                           |
+--------------------------------------------------------------------------------------------------------------+
| Status Bar                                                                                                   |
+--------------------------------------------------------------------------------------------------------------+
```

The user can:

* Move any dock
* Float any dock
* Hide unused docks
* Tabify related docks
* Save the workspace
* Restore the workspace later

---

# 10. Qt Source Code Concepts

When a user drags a dock widget:

```text
Mouse Press
      │
      ▼
Drag Begins
      │
      ▼
Dock Manager
      │
      ▼
Calculate Drop Target
      │
      ▼
Show Dock Indicator
      │
      ▼
Mouse Release
      │
      ▼
Update Layout
      │
      ▼
Repaint
```

The docking engine manages this interaction transparently.

---

# 11. Qt 5.15 vs Qt 6.11

| Feature               | Qt 5.15 | Qt 6.11 |
| --------------------- | ------- | ------- |
| Tabified Docks        | ✔       | ✔       |
| Nested Docking        | ✔       | ✔       |
| Workspace Persistence | ✔       | ✔       |
| Custom Title Bars     | ✔       | ✔       |
| Dock Signals          | ✔       | ✔       |

The API remains stable across Qt versions.

---

# 12. Best Practices

✅ Group related panels using tabified docks.

✅ Enable nested docking for complex workspaces.

✅ Save and restore the workspace automatically.

✅ Use `toggleViewAction()` for the View menu.

✅ Delay loading expensive widgets until they are first shown.

✅ Keep the central widget focused on the application's primary task.

---

# 13. Common Mistakes

### ❌ Loading every dock at startup

This increases startup time unnecessarily.

---

### ❌ Not saving workspace state

Users lose their customized layouts.

---

### ❌ Putting primary content inside dock widgets

The central widget should usually contain the application's main content.

---

### ❌ Too many floating windows by default

Provide a sensible default layout and let users customize it.

---

# 14. Interview Questions

## Easy

1. What is a tabified dock widget?
2. What does `toggleViewAction()` return?
3. What is nested docking?

---

## Medium

1. Explain `tabifyDockWidget()`.
2. How do you save and restore a workspace?
3. What signals does `QDockWidget` provide?

---

## Hard

1. Explain how the docking engine updates layouts during drag-and-drop.
2. Describe lazy initialization for dock widgets.
3. How would you organize dozens of panels in a professional application?

---

## Expert

1. Design the complete docking workspace for a Treatment Planning System.
2. Explain why the central widget and dock widgets have different responsibilities.
3. Compare dock widgets with MDI subwindows and dialogs for complex engineering applications.

---

# 15. Architecture Diagram

```text
                         QMainWindow
                               │
        ┌──────────────────────┼──────────────────────┐
        ▼                      ▼                      ▼
 Left Dock Area         Central Widget        Right Dock Area
        │                      │                      │
  ┌─────┴─────┐          CT Viewer          ┌─────────┴─────────┐
  ▼           ▼                             ▼                   ▼
Patient   Structures                 Beam Properties        DVH
  │           │                             │                   │
  └───────────┴──────────── Tabified ───────┴───────────────────┘
                               │
                               ▼
                     Workspace Persistence
                               │
                               ▼
                 saveState() / restoreState()
```

---

# 🏥 Production Example — Treatment Planning System

```text
+--------------------------------------------------------------------------------------------------------------------+
| Menu | Toolbar                                                                                                     |
+--------------------------------------------------------------------------------------------------------------------+
| Patient | Structures | Plans |             CT / MRI Viewer              | Beam | DVH | Optimization | QA         |
|---------+---------------------+------------------------------------------+------------------------------------------|
|         |                     |                                          |                                          |
|         |                     |                                          |                                          |
|         |                     |                                          |                                          |
+--------------------------------------------------------------------------------------------------------------------+
| Status Bar                                                                                                         |
+--------------------------------------------------------------------------------------------------------------------+
```

A radiation oncologist can:

* Float the **DVH** panel onto a second monitor.
* Tabify **Patient**, **Structures**, and **Plans**.
* Hide **QA** when not needed.
* Save the workspace.
* Restore the exact layout the next time the application starts.

This level of flexibility is one of the defining characteristics of modern professional desktop software.

---

# 16. Revision Notes

* `tabifyDockWidget()` groups dock widgets into tabs.
* `setDockNestingEnabled(true)` enables nested docking layouts.
* `toggleViewAction()` provides a ready-made action for showing or hiding a dock.
* `saveState()` and `restoreState()` preserve the entire workspace.
* Dock widgets emit signals when they move, float, or change visibility.
* Lazy initialization improves startup performance.
* Keep the central widget focused on the application's primary content.

---

# 🚀 Next Chapter

## **Chapter 44 — Events and Event Handling (Complete Deep Dive)**

