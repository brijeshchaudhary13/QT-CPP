# Complete Qt Master Course (Qt 5.15 LTS → Qt 6.11)

# PART XII — QML & Qt Quick

# Chapter 91 — Qt Quick Controls (Complete Deep Dive)


---

# 1. Introduction

**Qt Quick Controls** is a library of ready-to-use QML UI components.

Instead of creating every UI element manually, you can use built-in controls such as:

* Button
* Label
* TextField
* ComboBox
* Slider
* CheckBox
* TableView
* TreeView
* Dialog

These controls are optimized for desktop, embedded, and mobile applications.

---

## Architecture

```text id="qqc01"
Application
      │
      ▼
Qt Quick Controls
      │
      ▼
Scene Graph
      │
      ▼
GPU
```

---

# 2. Qt Quick Controls Architecture

Import

```qml id="qqc02"
import QtQuick
import QtQuick.Controls
```

Typical application

```text id="qqc03"
ApplicationWindow

├── MenuBar

├── ToolBar

├── Drawer

├── StackView

└── StatusBar
```

Controls are implemented on top of Qt Quick and rendered using the Scene Graph.

---

# 3. ApplicationWindow

`ApplicationWindow` is the root window for most Qt Quick applications.

Example

```qml id="qqc04"
ApplicationWindow
{
    visible: true

    width: 1200

    height: 800

    title: "Qt Application"
}
```

---

Typical structure

```text id="qqc05"
ApplicationWindow

├── Header

├── Content

└── Footer
```

---

Useful properties

```qml id="qqc06"
width

height

visible

title
```

---

# 4. Basic Controls

## Button

```qml id="qqc07"
Button
{
    text: "Save"
}
```

---

## Label

```qml id="qqc08"
Label
{
    text: "Patient Name"
}
```

---

## Text

```qml id="qqc09"
Text
{
    text: "Qt Quick"
}
```

Use `Label` for standard application text that follows the active control style, and `Text` for more customizable text rendering.

---

## Image

```qml id="qqc10"
Image
{
    source:
    "logo.png"
}
```

---

## BusyIndicator

```qml id="qqc11"
BusyIndicator
{
    running: true
}
```

Applications

* Loading data
* Waiting for REST APIs
* Dose calculation

---

# 5. Input Controls

## TextField

```qml id="qqc12"
TextField
{
    placeholderText:
    "Username"
}
```

---

## TextArea

```qml id="qqc13"
TextArea
{
}
```

---

## ComboBox

```qml id="qqc14"
ComboBox
{
    model:
    ["AAA","BBB"]
}
```

---

## CheckBox

```qml id="qqc15"
CheckBox
{
    text:
    "Remember"
}
```

---

## RadioButton

```qml id="qqc16"
RadioButton
{
    text:
    "Male"
}
```

---

## Slider

```qml id="qqc17"
Slider
{
    from:0

    to:100
}
```

Applications

* Zoom
* Brightness
* Opacity
* Dose Level

---

## SpinBox

```qml id="qqc18"
SpinBox
{
    from:1

    to:100
}
```

---

# 6. Container Controls

Containers organize content.

---

## Frame

```qml id="qqc19"
Frame
{
}
```

---

## GroupBox

```qml id="qqc20"
GroupBox
{
    title:"Beam Settings"
}
```

---

## TabBar

```qml id="qqc21"
TabBar
{
}
```

---

## SwipeView

```qml id="qqc22"
SwipeView
{
}
```

---

## StackView

```qml id="qqc23"
StackView
{
}
```

Navigation

```text id="qqc24"
Page1

↓

Page2

↓

Page3
```

Useful for wizard-style interfaces.

---

# 7. Navigation Controls

## Drawer

```qml id="qqc25"
Drawer
{
}
```

---

## ToolBar

```qml id="qqc26"
ToolBar
{
}
```

---

## MenuBar

```qml id="qqc27"
MenuBar
{
}
```

---

## ToolButton

```qml id="qqc28"
ToolButton
{
}
```

---

Architecture

```text id="qqc29"
Application

↓

Menu

↓

Toolbar

↓

Content

↓

Status
```

---

# 8. Dialogs & Popups

## Dialog

```qml id="qqc30"
Dialog
{
}
```

---

## Popup

```qml id="qqc31"
Popup
{
}
```

---

## MessageDialog

Qt Quick Dialogs module provides platform dialogs.

```qml id="qqc32"
MessageDialog
{
}
```

> Depending on your Qt version, `MessageDialog` is provided by the **Qt Quick Dialogs** module rather than `QtQuick.Controls`.

---

Workflow

```text id="qqc33"
Button

↓

Popup

↓

User Action
```

---

# 9. TableView & TreeView

## TableView

```qml id="qqc34"
TableView
{
}
```

Applications

* Database
* ERP
* Patient List

---

## TreeView

```qml id="qqc35"
TreeView
{
}
```

Applications

* File Explorer
* CAD Tree
* DICOM Hierarchy

---

Architecture

```text id="qqc36"
Model

↓

View

↓

Delegate
```

The view displays data provided by a model using delegates.

---

# 10. Layouts

Qt Quick Layouts

```qml id="qqc37"
import QtQuick.Layouts
```

---

## RowLayout

```qml id="qqc38"
RowLayout
{
}
```

---

## ColumnLayout

```qml id="qqc39"
ColumnLayout
{
}
```

---

## GridLayout

```qml id="qqc40"
GridLayout
{
}
```

Advantages

* Responsive
* Resizable
* Cross-platform

---

# 11. Themes

Qt Quick Controls support built-in styles.

Examples

* Basic
* Fusion
* Imagine
* Material
* Universal

Depending on the target platform, an appropriate default style may be selected.

---

Material

```text id="qqc41"
Google Style
```

---

Universal

```text id="qqc42"
Windows Style
```

---

Fusion

```text id="qqc43"
Desktop Style
```

---

# 12. Styling

Customize appearance.

Example

```qml id="qqc44"
Button
{
    background:
    Rectangle
    {
        color:"blue"
    }
}
```

---

Customize

* Colors
* Borders
* Radius
* Fonts
* Icons

---

Applications

* Dark Mode
* Corporate Branding
* Medical UI

---

# 13. Custom Controls

Reusable component

```text id="qqc45"
MyButton.qml
```

Usage

```qml id="qqc46"
MyButton
{
}
```

Architecture

```text id="qqc47"
Custom Control

↓

Reusable

↓

Application
```

Advantages

* Reuse
* Consistency
* Easier maintenance

---

# 14. Enterprise Applications

## Medical TPS

```text id="qqc48"
ApplicationWindow

↓

Patient Panel

↓

Dose Panel

↓

DVH Panel
```

---

## Automotive

```text id="qqc49"
Dashboard

↓

Speed

↓

Fuel

↓

Navigation
```

---

## ERP

```text id="qqc50"
Menu

↓

Table

↓

Forms
```

---

## Industrial HMI

```text id="qqc51"
Alarm

↓

Gauge

↓

Controls
```

---

# 15. Qt Internals

```text id="qqc52"
ApplicationWindow

↓

Controls

↓

QQuickItem

↓

Scene Graph

↓

GPU
```

Control lifecycle

```text id="qqc53"
Create

↓

Bindings

↓

Layout

↓

Render
```

Each control is ultimately represented by `QQuickItem` objects rendered by the Scene Graph.

---

# 16. Qt 5 vs Qt 6

| Feature             | Qt 5.15   | Qt 6.11                          |
| ------------------- | --------- | -------------------------------- |
| Qt Quick Controls 2 | ✔         | ✔                                |
| ApplicationWindow   | ✔         | ✔                                |
| TableView           | ✔         | ✔ (Improved API and performance) |
| TreeView            | Available | Improved                         |
| Material Style      | ✔         | ✔                                |
| Universal Style     | ✔         | ✔                                |

Qt 6 includes significant improvements to `TableView`, `TreeView`, and overall performance.

---

# 17. Best Practices

✅ Use `ApplicationWindow` as the application root.

✅ Prefer layouts over absolute positioning.

✅ Build reusable custom controls.

✅ Keep styling consistent.

✅ Separate UI from business logic.

---

# 18. Common Mistakes

### ❌ Deeply Nested Layouts

Excessive nesting complicates maintenance and can increase layout overhead.

---

### ❌ Hardcoded Sizes

Prefer layouts and anchors.

---

### ❌ Business Logic Inside Controls

Move application logic to C++ or a ViewModel.

---

### ❌ Duplicating UI Components

Create reusable controls.

---

### ❌ Mixing Styles

Use a consistent application theme.

---

# 19. Interview Questions

## Easy

1. What are Qt Quick Controls?
2. What is `ApplicationWindow`?
3. What is `Button`?

---

## Medium

1. Explain `StackView`.
2. What is `TableView`?
3. Why should layouts be preferred?

---

## Hard

1. Explain Qt Quick Controls architecture.
2. Compare `TableView` and `TreeView`.
3. Explain styling in Qt Quick Controls.

---

## Expert

1. Design the UI for a Treatment Planning System using Qt Quick Controls with modules for patient management, beam configuration, dose visualization, and reporting.
2. Compare Qt Widgets and Qt Quick Controls for enterprise desktop software.
3. Explain how Qt Quick Controls are rendered by the Scene Graph.

---

# 20. Revision Notes

* Qt Quick Controls provides ready-made UI components.
* `ApplicationWindow` is the standard root window.
* Controls include buttons, labels, text fields, dialogs, and views.
* Layouts provide responsive UI design.
* Themes define application appearance.
* Custom controls improve reuse.
* Controls are built on top of `QQuickItem`.
* Rendering is GPU accelerated via the Scene Graph.
* Keep business logic outside the UI.
* Qt 6 improves performance and view controls.

---

# 💡 Senior Engineer Tips

## Choosing the Right Control

| Requirement           | Recommended Control |
| --------------------- | ------------------- |
| Single-line input     | `TextField`         |
| Multi-line input      | `TextArea`          |
| Option selection      | `ComboBox`          |
| Numeric value         | `SpinBox`           |
| Progress              | `BusyIndicator`     |
| Data table            | `TableView`         |
| Hierarchical data     | `TreeView`          |
| Multi-page navigation | `StackView`         |

---

## Enterprise Qt Quick Architecture

```text id="qqc54"
ApplicationWindow
        │
 ┌──────┼──────────────┐
 ▼      ▼              ▼
Header Navigation   Content Area
        │              │
        ▼              ▼
    StackView      Custom Pages
        │              │
        └──────┬───────┘
               ▼
         ViewModel (C++)
               │
               ▼
       Business Services
```

This structure keeps the UI modular and allows navigation between independent application pages.

---

## Medical TPS Example

```text id="qqc55"
          ApplicationWindow
                  │
     ┌────────────┼────────────┐
     ▼            ▼            ▼
 Patient List  Beam Panel  DVH Panel
     │            │            │
     ▼            ▼            ▼
 TableView   GroupBox      Chart View
     │            │            │
     └────────────┼────────────┘
                  ▼
          ViewModel (C++)
                  │
     ┌────────────┼────────────┐
     ▼            ▼            ▼
 Dose Engine   DICOM     Machine Control
```

This architecture provides:

* A scalable modular UI.
* Clear separation between presentation and business logic.
* Responsive layouts for different screen sizes.
* Easy maintenance and testing.

---



## **Chapter 92 — Custom QML Types (Complete Deep Dive)**

