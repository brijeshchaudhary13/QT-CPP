Excellent. We are now entering **Part V – GUI Programming**, which is the heart of traditional Qt desktop application development.

If **`QObject`** is the foundation of Qt, then **`QWidget`** is the foundation of Qt Widgets.

Almost every classic Qt desktop application is built from `QWidget`.

Examples:

* Qt Creator
* Qt Designer
* Medical TPS (Isogray, Eclipse, RayStation-style applications)
* CAD software
* Enterprise ERP systems
* Automotive engineering tools

Everything visible on the screen—buttons, labels, text boxes, tables, dialogs, windows—is ultimately based on **`QWidget`**.

---

# Complete Qt Master Course (Qt 5.15 LTS → Qt 6.11)

# PART V — GUI Programming

# Chapter 35 — QWidget (Complete Deep Dive)

## Part 1 — Introduction, Architecture, Widget Lifecycle, Parent-Child Hierarchy & Visibility

**Level:** Beginner → Expert

---

# Chapter Objectives

After completing this chapter, you will understand:

* What `QWidget` is
* QWidget architecture
* Widget inheritance hierarchy
* Widget lifecycle
* Parent-child widgets
* Top-level vs child widgets
* Widget creation and destruction
* Visibility
* Qt 5 vs Qt 6

---

# Table of Contents

1. What is QWidget?
2. Why QWidget?
3. QWidget Architecture
4. Inheritance Hierarchy
5. Widget Lifecycle
6. Parent-Child Hierarchy
7. Top-Level vs Child Widgets
8. Widget Visibility
9. QWidget Memory Management
10. Qt 5 vs Qt 6
11. Best Practices
12. Interview Questions
13. Revision Notes

---

# 1. What is QWidget?

`QWidget` is the **base class for all visual components** in the Qt Widgets module.

Everything you see in a traditional Qt Widgets application ultimately derives from `QWidget`.

Examples:

```text
QPushButton

QLabel

QLineEdit

QTextEdit

QTreeWidget

QTableWidget

QMainWindow

QDialog

QDockWidget
```

All inherit directly or indirectly from `QWidget`.

---

# Header

```cpp
#include <QWidget>
```

Module

```text
QtWidgets
```

---

# 2. Why QWidget?

Imagine creating a button without `QWidget`.

You would need to manually implement:

* Window creation
* Mouse handling
* Keyboard handling
* Painting
* Focus
* Geometry
* Visibility
* Parent-child relationships
* Clipping
* Repainting

Qt provides all of this in `QWidget`.

Your widget only needs to implement the behavior specific to your application.

---

# 3. QWidget Architecture

```
QObject
    │
    ▼
QPaintDevice
    ▲
    │
QWidget
    │
 ┌──┼───────────────┐
 ▼  ▼               ▼
QFrame          QDialog
 │                │
 ▼                ▼
QLabel      QFileDialog

```

A more complete inheritance chain is:

```
QObject
    │
QPaintDevice
    │
QWidget
    │
 ├── QFrame
 │      ├── QLabel
 │      ├── QLineEdit
 │      ├── QTextEdit
 │      └── ...
 │
 ├── QDialog
 ├── QMainWindow
 ├── QPushButton
 ├── QListView
 └── ...
```

`QWidget` inherits functionality from both `QObject` (object model) and `QPaintDevice` (painting support).

---

# 4. QWidget Inheritance

Example

```cpp
class MyWidget : public QWidget
{
};
```

Now your widget automatically supports:

* Events
* Signals & Slots
* Timers
* Painting
* Keyboard
* Mouse
* Focus
* Geometry
* Visibility

All inherited from Qt.

---

# 5. Widget Lifecycle

A widget goes through several stages.

```
Constructor

↓

Initialize

↓

show()

↓

Visible

↓

Events

↓

hide()

↓

Invisible

↓

Destructor
```

---

## Example

```cpp
MyWidget widget;

widget.show();

return app.exec();
```

Execution

```
Constructor

↓

show()

↓

Window Created

↓

Paint Event

↓

Mouse Events

↓

Keyboard Events

↓

Close

↓

Destructor
```

---

# 6. Parent-Child Hierarchy

Qt widgets form a tree.

```
MainWindow
│
├── Toolbar
│
├── StatusBar
│
├── CentralWidget
│      │
│      ├── Button
│      ├── Label
│      └── LineEdit
│
└── DockWidget
```

Each child widget has:

```cpp
parentWidget()
```

Example

```cpp
QPushButton *button =
    new QPushButton(mainWindow);
```

Parent:

```
MainWindow

↓

Button
```

When the parent is destroyed, the child is automatically destroyed.

---

# Automatic Memory Management

```cpp
QWidget *parent =
    new QWidget;

QPushButton *button =
    new QPushButton(parent);
```

Deleting:

```cpp
delete parent;
```

Automatically deletes:

```
Button
```

This is one of Qt's most useful ownership features.

---

# 7. Top-Level vs Child Widgets

## Top-Level Widget

Created without a parent.

```cpp
QWidget *window =
    new QWidget;
```

Result:

```
Operating System Window
```

Top-level widgets:

* Have a title bar
* Can be moved
* Can be resized
* Appear independently on the desktop

---

## Child Widget

Created with a parent.

```cpp
QPushButton *button =
    new QPushButton(parent);
```

Result:

```
Main Window

↓

Button
```

The child is confined to the parent's client area.

---

# Comparison

| Feature     | Top-Level | Child                         |
| ----------- | --------- | ----------------------------- |
| Parent      | None      | Required for ownership/layout |
| Window      | Yes       | No                            |
| Title Bar   | Yes       | No                            |
| Independent | Yes       | No                            |

---

# 8. Widget Visibility

Initially:

```cpp
QWidget widget;
```

The widget is **not visible**.

Display it:

```cpp
widget.show();
```

Hide it:

```cpp
widget.hide();
```

Query:

```cpp
widget.isVisible();
```

---

# Visibility Flow

```
Constructor

↓

Hidden

↓

show()

↓

Visible

↓

hide()

↓

Hidden

↓

show()

↓

Visible
```

---

# Show Variants

Normal

```cpp
widget.show();
```

Maximized

```cpp
widget.showMaximized();
```

Minimized

```cpp
widget.showMinimized();
```

Fullscreen

```cpp
widget.showFullScreen();
```

---

# 9. QWidget Memory Management

Best practice:

```cpp
auto *button =
    new QPushButton(parent);
```

No need:

```cpp
delete button;
```

If the parent owns the button.

Qt automatically destroys child widgets.

---

# Bad Example

```cpp
auto *button =
    new QPushButton;

button->show();
```

No parent.

Memory leak if never deleted.

---

# 10. Qt 5.15 vs Qt 6.11

| Feature          | Qt 5.15 | Qt 6.11 |
| ---------------- | ------- | ------- |
| QWidget          | ✔       | ✔       |
| Parent Ownership | ✔       | ✔       |
| Visibility API   | ✔       | ✔       |
| Lifecycle        | ✔       | ✔       |

The `QWidget` lifecycle and ownership model remain essentially unchanged between Qt 5 and Qt 6.

---

# 11. Best Practices

✅ Always assign a parent when appropriate.

✅ Let Qt manage widget destruction through the parent-child hierarchy.

✅ Prefer layouts over manual positioning (covered in Chapter 37).

✅ Keep constructors lightweight.

✅ Perform expensive initialization after the widget is shown if possible.

---

# 12. Common Mistakes

### ❌ Forgetting `show()`

```cpp
QWidget window;
```

Nothing appears.

---

### ❌ Manually deleting child widgets

```cpp
delete button;
```

If the parent already owns the button, manual deletion is usually unnecessary and can complicate ownership management.

---

### ❌ Creating top-level widgets unintentionally

```cpp
new QPushButton;
```

Without a parent, it becomes a separate window.

---

### ❌ Performing heavy work in the constructor

This delays the first display of the window.

---

# 13. Interview Questions

## Easy

1. What is `QWidget`?
2. Which module contains `QWidget`?
3. What is a top-level widget?

---

## Medium

1. Explain the widget lifecycle.
2. Describe parent-child ownership.
3. What happens when a parent widget is destroyed?

---

## Hard

1. Compare top-level and child widgets.
2. Explain QWidget's inheritance hierarchy.
3. How does QWidget manage memory?

---

## Expert

1. Design the widget hierarchy for a Treatment Planning System main window.
2. Explain why Qt uses parent-child ownership instead of reference counting for widgets.
3. Describe the complete lifecycle of a widget from construction to destruction.

---

# 14. Architecture Diagram

```
QObject
      │
      ▼
QPaintDevice
      │
      ▼
QWidget
      │
 ┌────┼─────────────┐
 ▼    ▼             ▼
QFrame QDialog  QMainWindow
 │
 ├── QLabel
 ├── QPushButton
 ├── QLineEdit
 └── QTextEdit
```

---

# 🏥 Production Example — Treatment Planning System

```
MainWindow
│
├── Menu Bar
├── Tool Bar
├── Patient Browser
├── Beam Panel
├── Dose Viewer
├── DVH Widget
├── Structure List
├── Properties Panel
└── Status Bar
```

Every visual component in this hierarchy is ultimately a `QWidget`.

---

# 15. Revision Notes

* `QWidget` is the base class for visual widgets in Qt Widgets.
* It inherits from both `QObject` and `QPaintDevice`.
* Widgets form a parent-child hierarchy.
* Parent widgets automatically destroy their children.
* Widgets are hidden until `show()` is called.
* A widget without a parent is typically a top-level window.
* The QWidget ownership model is unchanged between Qt 5.15 and Qt 6.11.

---

# 🎯 Chapter 35 — Part 1 Complete

You now understand:

* What `QWidget` is
* QWidget architecture
* Inheritance hierarchy
* Widget lifecycle
* Parent-child ownership
* Top-level vs child widgets
* Visibility
* Memory management

This provides the foundation for building every Qt Widgets application.

---
Excellent. This is one of the **most important practical chapters** in Qt Widgets.

If Part 1 explained **what `QWidget` is**, Part 2 explains **how a widget behaves on the screen**.

Every professional Qt application—Medical TPS, CAD software, IDEs, GIS applications, and enterprise desktop tools—relies heavily on these APIs.

Understanding this chapter will help you write responsive, efficient, and maintainable Qt Widgets applications.

---

# Complete Qt Master Course (Qt 5.15 LTS → Qt 6.11)

# PART V — GUI Programming

# Chapter 35 — QWidget (Complete Deep Dive)

## Part 2 — Geometry, Coordinate Systems, Painting, Window Flags, Widget Attributes & Performance

> **Level:** Intermediate → Expert

---

# Chapter Objectives

After completing this chapter, you will understand:

* Widget geometry
* Coordinate systems
* `move()`, `resize()`, `setGeometry()`
* `update()` vs `repaint()`
* Window flags
* Widget attributes
* Native vs Alien widgets
* Performance optimization
* QWidget internals

---

# Table of Contents

1. Geometry
2. Coordinate Systems
3. Size Management
4. Painting
5. `update()` vs `repaint()`
6. Window Flags
7. Widget Attributes
8. Native vs Alien Widgets
9. Performance
10. Qt5 vs Qt6
11. Best Practices
12. Interview Questions
13. Revision Notes

---

# 1. Geometry

Every widget has a **geometry rectangle**.

The geometry defines:

* Position
* Width
* Height

Conceptually:

```text
+-----------------------------+
| x = 100                     |
| y = 50                      |
| width = 300                 |
| height = 200                |
+-----------------------------+
```

---

## Get Geometry

```cpp
QRect rect = widget->geometry();
```

Example:

```cpp
qDebug() << rect.x();
qDebug() << rect.y();
qDebug() << rect.width();
qDebug() << rect.height();
```

---

## Set Geometry

```cpp
widget->setGeometry(100, 50, 400, 300);
```

Equivalent to:

```text
Position

↓

(100,50)

↓

Size

↓

400 × 300
```

---

## Move Widget

```cpp
widget->move(200, 100);
```

Only position changes.

Size remains unchanged.

---

## Resize Widget

```cpp
widget->resize(800, 600);
```

Only width and height change.

Position remains unchanged.

---

# Geometry APIs

| Function        | Changes Position | Changes Size |
| --------------- | ---------------- | ------------ |
| `move()`        | ✔                | ✘            |
| `resize()`      | ✘                | ✔            |
| `setGeometry()` | ✔                | ✔            |

---

# 2. Coordinate Systems

Qt uses several coordinate systems.

---

## Local Coordinates

Origin:

```text
(0,0)
```

Top-left corner of the widget.

Example:

```text
Widget

(0,0)
+----------------------+
|                      |
|          X           |
|                      |
+----------------------+
```

---

## Parent Coordinates

A child widget's position is relative to its parent.

```text
Main Window

+----------------------------------+
|                                  |
|    Button                        |
|   (100,50)                       |
|                                  |
+----------------------------------+
```

The button's `(100,50)` is relative to the main window.

---

## Global Coordinates

Screen coordinates.

```cpp
QPoint global =
    widget->mapToGlobal(QPoint(0,0));
```

Useful for:

* Context menus
* Tooltips
* Drag & Drop
* Popup windows

---

## Coordinate Mapping

Parent → Child

```cpp
mapFromParent()
```

Child → Parent

```cpp
mapToParent()
```

Widget → Screen

```cpp
mapToGlobal()
```

Screen → Widget

```cpp
mapFromGlobal()
```

---

# 3. Size Management

Widgets can define preferred sizes.

---

## Minimum Size

```cpp
widget->setMinimumSize(200,100);
```

---

## Maximum Size

```cpp
widget->setMaximumSize(800,600);
```

---

## Fixed Size

```cpp
widget->setFixedSize(400,300);
```

User cannot resize beyond this fixed size.

---

## Size Hint

Layouts ask widgets:

> "How large would you like to be?"

Widgets answer through:

```cpp
QSize sizeHint() const;
```

You can override it:

```cpp
QSize MyWidget::sizeHint() const
{
    return QSize(300, 200);
}
```

Layouts use this recommendation when arranging widgets.

---

# 4. Painting

Qt paints widgets using:

```cpp
paintEvent(QPaintEvent *event)
```

Example:

```cpp
void MyWidget::paintEvent(QPaintEvent *event)
{
    Q_UNUSED(event);

    QPainter painter(this);

    painter.drawText(20, 30, "Hello Qt");
}
```

Never paint outside `paintEvent()` unless you have a specialized reason.

---

# Paint Flow

```text
update()

↓

Paint Event Posted

↓

Event Loop

↓

paintEvent()

↓

QPainter

↓

Screen
```

---

# 5. `update()` vs `repaint()`

This is a classic interview question.

---

## update()

```cpp
widget->update();
```

Behavior:

```text
Request Repaint

↓

Paint Event

↓

Later
```

Advantages:

* Event compression
* Better performance
* Non-blocking

Recommended for most applications.

---

## repaint()

```cpp
widget->repaint();
```

Behavior:

```text
Repaint Immediately
```

No event compression.

Can reduce responsiveness if used excessively.

---

## Comparison

| Feature           | `update()` | `repaint()` |
| ----------------- | ---------- | ----------- |
| Immediate         | ✘          | ✔           |
| Event Queue       | ✔          | ✘           |
| Compresses Paints | ✔          | ✘           |
| Recommended       | ✔          | Rarely      |

---

# 6. Window Flags

Control window behavior.

Example:

```cpp
widget->setWindowFlags(
    Qt::Window |
    Qt::WindowMinimizeButtonHint |
    Qt::WindowCloseButtonHint);
```

Common flags:

```text
Qt::Window
Qt::Dialog
Qt::Tool
Qt::Popup
Qt::FramelessWindowHint
Qt::CustomizeWindowHint
```

---

## Frameless Window

```cpp
widget->setWindowFlag(
    Qt::FramelessWindowHint);
```

Used for:

* Splash screens
* Custom title bars
* Kiosks

---

# 7. Widget Attributes

Attributes modify widget behavior.

Example:

```cpp
widget->setAttribute(Qt::WA_DeleteOnClose);
```

Selected useful attributes:

| Attribute                      | Purpose                                           |
| ------------------------------ | ------------------------------------------------- |
| `WA_DeleteOnClose`             | Delete widget after close                         |
| `WA_TransparentForMouseEvents` | Ignore mouse events                               |
| `WA_OpaquePaintEvent`          | Optimize painting for fully opaque widgets        |
| `WA_StyledBackground`          | Allow style sheets to paint the widget background |

Choose attributes only when they match your widget's behavior.

---

# 8. Native vs Alien Widgets

Historically, Qt distinguished between:

### Native Widget

Has an operating-system window handle.

```text
Qt Widget

↓

OS Window
```

---

### Alien Widget

Drawn inside its parent without its own native window.

Benefits:

* Less memory
* Faster painting
* Fewer OS resources

Modern Qt prefers alien widgets by default for most child widgets, creating native windows only when necessary.

---

# 9. Performance Optimization

## Good

```cpp
update();
```

Batch repaints.

---

## Avoid

```cpp
repaint();
```

inside:

```cpp
mouseMoveEvent()
```

It may repaint hundreds of times per second.

---

## Good

```text
Mouse Move

↓

update()

↓

Paint Event

↓

One Paint
```

---

## Bad

```text
Mouse Move

↓

repaint()

↓

Immediate Paint

↓

Mouse Move

↓

Immediate Paint
```

This can significantly increase CPU usage.

---

## Keep `paintEvent()` Fast

Good:

```text
Paint

↓

Draw
```

Bad:

```text
Paint

↓

Database Query

↓

Network Call

↓

Draw
```

Painting should only render data that is already available.

---

# 10. Qt Source Code Concepts

Conceptually:

```text
setGeometry()

↓

QMoveEvent

↓

QResizeEvent

↓

update()

↓

Paint Event

↓

paintEvent()
```

The exact sequence depends on what changed, but geometry updates often trigger move, resize, and repaint operations.

---

# 11. Qt 5.15 vs Qt 6.11

| Feature                  | Qt 5.15 | Qt 6.11 |
| ------------------------ | ------- | ------- |
| Geometry APIs            | ✔       | ✔       |
| Painting Model           | ✔       | ✔       |
| `update()` / `repaint()` | ✔       | ✔       |
| Window Flags             | ✔       | ✔       |
| Widget Attributes        | ✔       | ✔       |

The QWidget API remains highly stable across Qt 5 and Qt 6.

---

# 12. Best Practices

✅ Prefer layouts over manually calling `move()` and `resize()` for complex interfaces.

✅ Use `update()` instead of `repaint()` in normal code.

✅ Keep `paintEvent()` lightweight.

✅ Override `sizeHint()` for custom widgets.

✅ Use window flags only when needed.

---

# 13. Common Mistakes

### ❌ Manual positioning inside layouts

```cpp
button->move(100,100);
```

If the button is managed by a layout, the layout will reposition it.

---

### ❌ Calling `paintEvent()` directly

Always call:

```cpp
update();
```

instead.

---

### ❌ Heavy computations inside painting

Painting should only render.

---

### ❌ Excessive `repaint()`

This can cause unnecessary redraws and reduce performance.

---

# 14. Interview Questions

## Easy

1. What is widget geometry?
2. What is `move()`?
3. What is `resize()`?

---

## Medium

1. Compare `update()` and `repaint()`.
2. Explain local and global coordinates.
3. What is `sizeHint()`?

---

## Hard

1. Describe the painting pipeline.
2. Explain native versus alien widgets.
3. Why should layouts usually manage widget geometry?

---

## Expert

1. Design a custom medical image viewer that supports smooth panning and zooming with efficient repainting.
2. Explain how geometry changes propagate through the Qt event system.
3. Discuss the performance implications of calling `repaint()` repeatedly during mouse movement.

---

# 15. Architecture Diagram

```text
        QWidget
            │
            ▼
     setGeometry()
            │
     ┌──────┴──────┐
     ▼             ▼
 QMoveEvent   QResizeEvent
       │          │
       └──────┬───┘
              ▼
           update()
              │
              ▼
      Paint Event Posted
              │
              ▼
        paintEvent()
              │
              ▼
          QPainter
              │
              ▼
            Screen
```

---

# 🏥 Production Example — Treatment Planning System

```text
Doctor Resizes Main Window
           │
           ▼
      resizeEvent()
           │
           ▼
 Recalculate Layout
           │
           ├── Resize CT Viewer
           ├── Resize DVH Widget
           ├── Resize Beam Panel
           ├── Resize Patient Browser
           └── Resize 3D View
                   │
                   ▼
               update()
                   │
                   ▼
             paintEvent()
                   │
                   ▼
        Render Updated Interface
```

A well-designed TPS keeps painting fast by recalculating layout only when necessary and rendering efficiently.

---

# 16. Revision Notes

* Geometry defines a widget's position and size.
* `move()` changes position; `resize()` changes size; `setGeometry()` changes both.
* Qt uses local, parent, and global coordinate systems.
* `update()` schedules repainting; `repaint()` paints immediately.
* Window flags control window behavior.
* Widget attributes modify specific behaviors.
* Modern Qt generally uses alien widgets for child widgets unless native windows are required.
* Efficient painting is essential for responsive applications.

---

# 🎯 Chapter 35 Complete

You now have a complete understanding of **QWidget**, including:

* Widget architecture
* Lifecycle
* Parent-child ownership
* Geometry
* Coordinate systems
* Painting
* `update()` vs `repaint()`
* Window flags
* Widget attributes
* Native vs alien widgets
* Performance optimization

You are now ready to build custom widgets and understand how Qt renders and manages desktop user interfaces.

---

# 🚀 Next Chapter

## **Chapter 36 — QWidget Hierarchy (Complete Deep Dive)**

