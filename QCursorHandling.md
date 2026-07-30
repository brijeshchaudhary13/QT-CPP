# Complete Qt Master Course (Qt 5.15 LTS → Qt 6.11)

# PART V — Advanced Widget Architecture

# Chapter 47 — Cursor Handling (Complete Deep Dive)

## Master Mouse Cursors, Custom Cursors, Override Cursors & Cursor Management

> **Level:** Beginner → Expert

---

# Chapter Objectives

After completing this chapter, you will understand:

* What is a cursor?
* `QCursor`
* Standard cursor shapes
* Custom cursors
* Cursor hotspots
* Override cursors
* Wait and busy cursors
* Mouse tracking
* Cursor positioning
* Cursor handling in custom widgets
* Enterprise use cases
* Qt 5.15 vs Qt 6.11
* Best practices
* Common mistakes
* Interview questions

---

# Table of Contents

1. Introduction
2. Cursor Architecture
3. QCursor
4. Standard Cursor Shapes
5. Setting Widget Cursors
6. Override Cursor
7. Restoring the Cursor
8. Custom Cursors
9. Cursor Hotspots
10. Cursor Position
11. Mouse Tracking
12. Cursor Management in Applications
13. Enterprise Applications
14. Qt Internals
15. Qt 5 vs Qt 6
16. Best Practices
17. Common Mistakes
18. Interview Questions
19. Revision Notes

---

# 1. Introduction

A **cursor** is the visual indicator that represents the current mouse position and often communicates what action the user can perform.

Examples:

* Arrow
* Text insertion (I-beam)
* Resize
* Wait
* Crosshair
* Hand

A well-chosen cursor improves usability by giving immediate visual feedback.

---

## Typical Workflow

```text
Mouse Moves
      │
      ▼
Cursor Enters Widget
      │
      ▼
Widget Changes Cursor
      │
      ▼
User Understands Action
```

---

# 2. Cursor Architecture

Qt manages cursors through the `QCursor` class.

Architecture:

```text
Operating System
        │
        ▼
     QCursor
        │
        ▼
 Widget/Application
        │
        ▼
      Screen
```

The operating system draws the cursor, while Qt controls which cursor should be displayed.

---

# 3. QCursor

Header:

```cpp
#include <QCursor>
```

Create a cursor:

```cpp
QCursor cursor(Qt::CrossCursor);
```

Assign it to a widget:

```cpp
widget->setCursor(cursor);
```

Or directly:

```cpp
widget->setCursor(Qt::PointingHandCursor);
```

---

## Responsibilities

`QCursor` is responsible for:

* Cursor shape
* Custom cursor images
* Cursor hotspot
* Cursor position

---

# 4. Standard Cursor Shapes

Qt provides many predefined cursor shapes.

| Cursor                   | Description                 |
| ------------------------ | --------------------------- |
| `Qt::ArrowCursor`        | Default arrow               |
| `Qt::IBeamCursor`        | Text editing                |
| `Qt::CrossCursor`        | Precision selection         |
| `Qt::WaitCursor`         | Busy operation              |
| `Qt::BusyCursor`         | Background work in progress |
| `Qt::PointingHandCursor` | Hyperlinks and buttons      |
| `Qt::OpenHandCursor`     | Draggable object            |
| `Qt::ClosedHandCursor`   | Object being dragged        |
| `Qt::SizeHorCursor`      | Horizontal resize           |
| `Qt::SizeVerCursor`      | Vertical resize             |
| `Qt::SizeAllCursor`      | Move operation              |
| `Qt::ForbiddenCursor`    | Action not allowed          |

---

## Visual Meaning

```text
Arrow        → Normal

I-Beam       → Edit Text

Crosshair    → Precision

Hand         → Clickable

Wait         → Busy

Forbidden    → Invalid Operation
```

---

# 5. Setting Widget Cursors

Example:

```cpp
button->setCursor(Qt::PointingHandCursor);
```

Another example:

```cpp
graphicsView->setCursor(Qt::CrossCursor);
```

Workflow:

```text
Mouse Enters Widget
        │
        ▼
Cursor Automatically Changes
```

When the mouse leaves the widget, the previous cursor is restored unless overridden globally.

---

# 6. Override Cursor

Sometimes the entire application should display a specific cursor.

Example:

```cpp
QApplication::setOverrideCursor(
    Qt::WaitCursor);
```

Visualization:

```text
Entire Application

↓

Wait Cursor
```

Useful during:

* Loading
* Saving
* Printing
* Database queries
* Network operations

---

# 7. Restoring the Cursor

Always restore an override cursor after the operation completes.

```cpp
QApplication::restoreOverrideCursor();
```

Workflow:

```text
Start Operation

↓

Wait Cursor

↓

Operation Finished

↓

Restore Arrow Cursor
```

If multiple override cursors are stacked, each call to `restoreOverrideCursor()` removes the most recently installed one.

---

# 8. Custom Cursors

Applications can use their own cursor images.

Example:

```cpp
QPixmap pixmap(":/images/pencil.png");

QCursor cursor(pixmap);

widget->setCursor(cursor);
```

Applications:

* CAD
* Drawing tools
* Medical TPS
* GIS
* Image editors

---

# 9. Cursor Hotspots

The **hotspot** is the exact pixel used for clicking.

Example:

```cpp
QCursor cursor(pixmap, 4, 4);
```

Meaning:

```text
Cursor Image

      ●

Hotspot
```

For an arrow, the hotspot is usually the tip.

For a crosshair, it is typically the center.

---

# 10. Cursor Position

Current cursor position:

```cpp
QPoint position = QCursor::pos();
```

Move cursor:

```cpp
QCursor::setPos(100,200);
```

Applications:

* Automated testing
* Screen capture tools
* Accessibility
* Kiosk software

Use cursor repositioning sparingly, as unexpected movement can confuse users.

---

# 11. Mouse Tracking

By default:

```text
Mouse Events

↓

Only While Button Pressed
```

Enable continuous tracking:

```cpp
setMouseTracking(true);
```

Now:

```text
Mouse Moves

↓

mouseMoveEvent()

↓

No Button Required
```

Useful for:

* CAD crosshairs
* Medical viewers
* Tooltips
* Hover highlighting

---

# Example

```text
Move Mouse

↓

Highlight Object

↓

Update Cursor

↓

Show Coordinates
```

---

# 12. Cursor Management in Applications

Professional software changes the cursor based on the active tool.

Example:

```text
Selection Tool

↓

Arrow Cursor
```

```text
Zoom Tool

↓

Magnifier Cursor
```

```text
Draw Tool

↓

Crosshair Cursor
```

```text
Move Tool

↓

Open Hand Cursor
```

```text
Dragging

↓

Closed Hand Cursor
```

---

# 13. Enterprise Applications

## Medical TPS

```text
Arrow

↓

Select Structure
```

```text
Crosshair

↓

Measure Distance
```

```text
Wait

↓

Dose Calculation
```

---

## CAD

```text
Crosshair

↓

Draw Line
```

```text
Resize Cursor

↓

Stretch Geometry
```

---

## GIS

```text
Open Hand

↓

Pan Map
```

```text
Closed Hand

↓

Dragging Map
```

---

## IDE

```text
I-Beam

↓

Edit Code
```

```text
Wait

↓

Project Indexing
```

---

# 14. Qt Internals

Architecture:

```text
Operating System

↓

Mouse Event

↓

Qt Event Loop

↓

Widget

↓

Cursor Decision

↓

QCursor

↓

Operating System

↓

Screen
```

Cursor flow:

```text
Mouse Enters Widget

↓

enterEvent()

↓

setCursor()

↓

Operating System Updates Cursor
```

Qt requests the cursor change; the operating system performs the actual rendering.

---

# 15. Qt 5.15 vs Qt 6.11

| Feature          | Qt 5.15 | Qt 6.11 |
| ---------------- | ------- | ------- |
| QCursor          | ✔       | ✔       |
| Standard Cursors | ✔       | ✔       |
| Custom Cursors   | ✔       | ✔       |
| Override Cursor  | ✔       | ✔       |
| Mouse Tracking   | ✔       | ✔       |

The cursor API remains stable across Qt versions.

---

# 16. Best Practices

✅ Use standard cursor shapes whenever they clearly communicate the action.

✅ Display a wait cursor only while the application is genuinely busy.

✅ Restore override cursors immediately after the operation completes.

✅ Design custom cursors with clear hotspots.

✅ Keep cursor behavior consistent throughout the application.

---

# 17. Common Mistakes

### ❌ Forgetting to restore an override cursor

The application may remain stuck showing the wait cursor.

---

### ❌ Using the wrong cursor shape

For example, using a resize cursor for a move operation confuses users.

---

### ❌ Frequently changing the cursor

Rapid cursor changes can make the interface feel unstable.

---

### ❌ Repositioning the cursor unnecessarily

Unexpected cursor movement often creates a poor user experience.

---

# 18. Interview Questions

## Easy

1. What is `QCursor`?
2. How do you change a widget's cursor?
3. What is a wait cursor?

---

## Medium

1. Explain override cursors.
2. What is mouse tracking?
3. What is a cursor hotspot?

---

## Hard

1. Explain the cursor management lifecycle in Qt.
2. How would you implement custom cursors for a CAD application?
3. Compare widget-specific cursors with application-wide override cursors.

---

## Expert

1. Design the cursor management system for a Medical Treatment Planning System supporting selection, contour editing, measurement, beam placement, and dose calculation.
2. Explain how Qt coordinates cursor changes with the operating system.
3. Design a tool-based cursor framework similar to Adobe Photoshop or AutoCAD.

---

# 19. Revision Notes

* `QCursor` manages cursor appearance.
* Qt provides many standard cursor shapes.
* Widgets can define their own cursors.
* Override cursors affect the entire application.
* Always restore override cursors after use.
* Custom cursors use pixmaps and hotspots.
* Mouse tracking enables `mouseMoveEvent()` without mouse buttons.
* Cursor changes provide important visual feedback to users.

---

# 🎯 Chapter 47 Complete

You now understand:

* `QCursor`
* Standard cursor shapes
* Widget-specific cursors
* Override cursors
* Custom cursors
* Cursor hotspots
* Cursor positioning
* Mouse tracking
* Enterprise cursor management
* Qt 5.15 vs Qt 6.11 compatibility

These concepts help create intuitive, responsive user interfaces where the cursor communicates the current interaction mode clearly and consistently.

---

# 🚀 Next Chapter

## **Chapter 48 — Focus Handling (Complete Deep Dive)**

In the next chapter, you'll learn:

* Keyboard focus fundamentals
* Focus policies (`Qt::FocusPolicy`)
* Focus events (`focusInEvent()`, `focusOutEvent()`)
* Focus chain and tab order
* `setFocus()`, `clearFocus()`
* Focus proxies
* Default buttons
* Focus handling in custom widgets
* Accessibility considerations
* Enterprise examples
* Qt 5.15 vs Qt 6.11
* Best practices and interview questions
