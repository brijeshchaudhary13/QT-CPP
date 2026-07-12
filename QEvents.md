Excellent. We are now entering one of the **largest and most important chapters** in the entire Qt framework.

As a Senior Qt Architect, I consider **Chapter 30 – Events** to be one of the core pillars of Qt, together with:

* QObject
* Signals & Slots
* Event Loop
* Events
* Model/View

Everything a user does eventually becomes a **QEvent**.

Examples:

* Mouse click → `QMouseEvent`
* Keyboard press → `QKeyEvent`
* Window resize → `QResizeEvent`
* Paint request → `QPaintEvent`
* Touch → `QTouchEvent`
* Wheel scroll → `QWheelEvent`
* Timer timeout → `QTimerEvent`
* Close window → `QCloseEvent`

If you master this chapter, you'll understand how Qt applications react to user input and system events.

---

# Complete Qt Master Course (Qt 5.15 LTS → Qt 6.11)

# PART IV — Application Architecture

# Chapter 30 — Events (Complete Deep Dive)

## Part 1 — QEvent Fundamentals, Event Types & Event Delivery

> **Level:** Beginner → Advanced

---

# Chapter Objectives

After completing this chapter, you will understand:

* What a `QEvent` is
* Why Qt uses an event system
* Event lifecycle
* Event delivery
* `QObject::event()`
* Event types
* Event acceptance
* Event propagation
* Qt 5 vs Qt 6 differences

---

# Table of Contents

1. What is an Event?
2. Why Events?
3. QEvent Class
4. Event Lifecycle
5. Event Delivery
6. QObject::event()
7. Event Types
8. Event Acceptance
9. Event Propagation
10. Qt5 vs Qt6
11. Best Practices
12. Interview Questions
13. Revision Notes

---

# 1. What is an Event?

## Definition

An **event** represents something that happened and requires a response.

Examples:

```text
Mouse Click

Key Press

Window Resize

Paint Request

Timer Timeout

Network Ready

Touch Input

Drag Operation
```

Qt represents each of these as an object derived from `QEvent`.

---

# Header

```cpp
#include <QEvent>
```

Module

```text
QtCore
```

---

# Class Hierarchy

```text
QObject

↓

QCoreApplication

↓

QEvent
```

> **Correction:** `QEvent` is **not** derived from `QObject` or `QCoreApplication`. It is an independent class. It is shown separately below:

```text
QEvent

├── QMouseEvent

├── QKeyEvent

├── QPaintEvent

├── QResizeEvent

├── QMoveEvent

├── QCloseEvent

├── QTimerEvent

├── QWheelEvent

├── QFocusEvent

├── ...
```

Unlike `QObject`, `QEvent` has no parent-child ownership.

---

# 2. Why Events?

Imagine clicking a button.

Without an event system:

```text
Operating System

↓

Mouse Click

↓

???

↓

Application
```

No standard mechanism exists.

With Qt:

```text
Mouse Click

↓

QMouseEvent

↓

QApplication

↓

QObject

↓

mousePressEvent()
```

A consistent, cross-platform model.

---

# 3. QEvent Class

Simplified view:

```cpp
class QEvent
{
public:
    enum Type;

    Type type() const;

    bool isAccepted() const;

    void accept();

    void ignore();
};
```

Most event classes derive from `QEvent`.

---

# 4. Event Lifecycle

Suppose the user presses the left mouse button.

```text
User

↓

Operating System

↓

Native Mouse Event

↓

Qt Platform Plugin

↓

QMouseEvent

↓

Event Queue

↓

notify()

↓

QObject::event()

↓

mousePressEvent()

↓

Event Destroyed
```

Every event follows a similar lifecycle.

---

# Event Creation

Events are created:

* By Qt
* By the operating system
* By your application (custom events)

Example:

```cpp
QCoreApplication::postEvent(
    receiver,
    new MyCustomEvent);
```

---

# 5. Event Delivery

Conceptually:

```text
Operating System

↓

Event Dispatcher

↓

QCoreApplication

↓

notify()

↓

QObject::event()

↓

Specific Handler
```

Example:

```text
QMouseEvent

↓

event()

↓

mousePressEvent()
```

---

# 6. QObject::event()

Every `QObject` can receive events.

For widgets:

```cpp
bool QWidget::event(QEvent *event)
```

This function examines the event type and forwards it to specialized handlers.

Conceptually:

```cpp
bool QWidget::event(QEvent *event)
{
    switch(event->type())
    {
        case QEvent::MouseButtonPress:
            mousePressEvent(...);
            break;

        case QEvent::KeyPress:
            keyPressEvent(...);
            break;

        case QEvent::Paint:
            paintEvent(...);
            break;

        default:
            break;
    }
}
```

The real implementation is much more extensive, but this illustrates the mechanism.

---

# 7. Event Types

Qt defines many event types.

Common examples:

| Event Class       | Typical Event Type          |
| ----------------- | --------------------------- |
| `QMouseEvent`     | Mouse button, move, release |
| `QKeyEvent`       | Key press, key release      |
| `QPaintEvent`     | Paint                       |
| `QResizeEvent`    | Resize                      |
| `QMoveEvent`      | Move                        |
| `QFocusEvent`     | Focus in/out                |
| `QCloseEvent`     | Close                       |
| `QWheelEvent`     | Mouse wheel                 |
| `QTimerEvent`     | Timer                       |
| `QDragEnterEvent` | Drag enter                  |

The `QEvent::Type` enumeration contains many more values.

---

# Example

```cpp
void MyWidget::event(QEvent *event)
{
    if(event->type() == QEvent::MouseButtonPress)
    {
        ...
    }
}
```

---

# 8. Event Acceptance

Every event has an acceptance state.

```cpp
event->accept();
```

means:

```text
Event Handled
```

---

Ignoring:

```cpp
event->ignore();
```

means:

```text
I Didn't Handle It
```

The meaning of "ignored" depends on the event type. For many widget events, it allows further processing or propagation.

---

# Example

```cpp
void MyWidget::mousePressEvent(QMouseEvent *event)
{
    event->accept();
}
```

---

# 9. Event Propagation

Suppose:

```text
MainWindow

↓

Central Widget

↓

Button
```

User clicks button.

```text
Mouse Event

↓

Button

↓

Handled?
```

If handled:

```text
Stop
```

If ignored:

Depending on the event type and widget behavior, Qt may propagate or otherwise continue processing the event.

Conceptually:

```text
Button

↓

Parent Widget

↓

Main Window
```

Not every event propagates in the same way. Mouse, key, focus, and drag events each have their own propagation rules.

---

# Event Flow Diagram

```text
Operating System

↓

Event Dispatcher

↓

Event Queue

↓

QApplication::notify()

↓

QObject::event()

↓

Specific Event Handler

↓

accept() / ignore()
```

---

# 10. Qt 5.15 vs Qt 6.11

| Feature        | Qt 5.15 | Qt 6.11 |
| -------------- | ------- | ------- |
| `QEvent`       | ✔       | ✔       |
| Event Types    | ✔       | ✔       |
| Acceptance     | ✔       | ✔       |
| Delivery Model | ✔       | ✔       |

There is **no major conceptual difference** in the event model between Qt 5.15 and Qt 6.11.

Qt 6 introduced updates to some specific event classes (for example, changes to pointer and input event APIs), but the overall architecture remains the same.

---

# 11. Best Practices

* Override specialized handlers (`mousePressEvent()`, `paintEvent()`, etc.) instead of `event()` unless you need to intercept multiple event types.
* Call the base class implementation when appropriate.
* Accept events only when your widget has actually handled them.
* Avoid performing long-running work inside event handlers.
* Use custom events when event-driven communication is more appropriate than direct calls.

---

# 12. Common Mistakes

❌ Forgetting to call the base implementation when required.

Example:

```cpp
void MyWidget::keyPressEvent(QKeyEvent *event)
{
    // Forgot QWidget::keyPressEvent(event);
}
```

This may prevent default behavior such as focus navigation.

---

❌ Handling every event in `event()` when a specialized handler would be clearer.

---

❌ Blocking the event handler with expensive calculations.

---

❌ Calling `accept()` without actually processing the event.

---

# 13. Interview Questions

## Easy

1. What is a `QEvent`?
2. Why does Qt use an event system?
3. What is `QEvent::Type`?

---

## Medium

1. Explain the lifecycle of an event.
2. What does `QObject::event()` do?
3. What is the difference between `accept()` and `ignore()`?

---

## Hard

1. Describe the path of a mouse click from the operating system to `mousePressEvent()`.
2. When should you override `event()` instead of a specialized event handler?
3. Explain event propagation.

---

## Expert

1. Design a custom event-based communication system for a Treatment Planning System.
2. Explain why Qt uses event objects rather than calling handlers directly.
3. Discuss the advantages of a platform-independent event model.

---

# 14. Revision Notes

* `QEvent` is the base class for all Qt events.
* Every user interaction is represented as an event object.
* Events travel from the operating system through the event dispatcher to `QObject::event()`.
* Specialized handlers such as `mousePressEvent()` are called based on the event type.
* Events can be accepted or ignored.
* Different event types have different propagation rules.
* The overall event architecture is stable across Qt 5.15 and Qt 6.11.

---

# 🏥 Production Example — Treatment Planning System

```text
Radiologist Clicks CT Slice

↓

Operating System

↓

QMouseEvent

↓

Slice Viewer Widget

↓

mousePressEvent()

↓

Convert Screen Coordinates

↓

Patient Coordinates

↓

Move Crosshair

↓

Update Axial View

↓

Update Coronal View

↓

Update Sagittal View

↓

Repaint All Viewports
```

This is a typical event-processing chain in a medical imaging application.

---

# 🎯 Chapter 30 — Part 1 Complete

You now understand:

* What `QEvent` is
* Event lifecycle
* Event delivery
* `QObject::event()`
* Event types
* Event acceptance
* Event propagation
* Qt 5 → Qt 6 behavior

---

# 🚀 Next Section

## **Chapter 30 — Part 2**

Excellent. This chapter covers the **events you will use every day** as a Qt developer.

If you are developing:

* Medical TPS
* CAD software
* Automotive HMIs
* GIS applications
* Enterprise desktop applications
* Image viewers
* Custom widgets

then **90% of your event handling** will involve the classes in this chapter.

As a Senior Qt Architect, I recommend mastering these classes before moving to advanced topics like gesture events or tablet events.

---

# Complete Qt Master Course (Qt 5.15 LTS → Qt 6.11)

# PART IV — Application Architecture

# Chapter 30 — Events (Complete Deep Dive)

## Part 2 — Mouse, Keyboard, Paint, Resize, Close & Widget Events

> **Level:** Beginner → Expert

---

# Chapter Objectives

After this chapter you will understand:

* `QMouseEvent`
* `QKeyEvent`
* `QWheelEvent`
* `QFocusEvent`
* `QPaintEvent`
* `QResizeEvent`
* `QMoveEvent`
* `QCloseEvent`
* `QShowEvent`
* `QHideEvent`

including their APIs, lifecycle, Qt 5 vs Qt 6 differences, and production usage.

---

# 1. QMouseEvent

## Purpose

Represents mouse activity.

Examples:

* Left click
* Right click
* Middle click
* Mouse move
* Double click
* Button release

---

## Header

```cpp
#include <QMouseEvent>
```

Module

```text
QtGui
```

---

## Event Flow

```text
User Click

↓

Operating System

↓

Native Mouse Message

↓

QMouseEvent

↓

QWidget::event()

↓

mousePressEvent()
```

---

## Common Virtual Functions

```cpp
void mousePressEvent(QMouseEvent *event)

void mouseReleaseEvent(QMouseEvent *event)

void mouseMoveEvent(QMouseEvent *event)

void mouseDoubleClickEvent(QMouseEvent *event)
```

---

## Frequently Used APIs

### Mouse Button

```cpp
event->button()
```

Returns the button responsible for the event.

Examples:

```text
Qt::LeftButton

Qt::RightButton

Qt::MiddleButton
```

---

### Current Button State

```cpp
event->buttons()
```

Returns all buttons currently pressed.

Example:

```text
Left + Right
```

---

### Position

Qt 5:

```cpp
event->pos()
```

Returns integer widget coordinates.

Qt 6:

```cpp
event->position()
```

Returns floating-point coordinates (`QPointF`).

This improves precision, especially on high-DPI displays.

---

### Global Position

Qt 5:

```cpp
event->globalPos()
```

Qt 6:

```cpp
event->globalPosition()
```

Again, Qt 6 uses floating-point coordinates.

---

## Medical TPS Example

```text
Mouse Click

↓

CT Slice

↓

Determine Pixel

↓

Convert To Patient Coordinates

↓

Move Crosshair

↓

Update All Views
```

---

# Qt 5 vs Qt 6

| Qt5                 | Qt6                        |
| ------------------- | -------------------------- |
| `pos()`             | `position()`               |
| `globalPos()`       | `globalPosition()`         |
| Integer coordinates | Floating-point coordinates |

**Migration Example**

Qt 5:

```cpp
QPoint p = event->pos();
```

Qt 6:

```cpp
QPointF p = event->position();
```

If integer coordinates are needed:

```cpp
QPoint p = event->position().toPoint();
```

---

# 2. QKeyEvent

Represents keyboard input.

---

## Header

```cpp
#include <QKeyEvent>
```

---

## Event Flow

```text
Keyboard

↓

Native Event

↓

QKeyEvent

↓

keyPressEvent()
```

---

## Virtual Functions

```cpp
keyPressEvent()

keyReleaseEvent()
```

---

## Common APIs

### Key

```cpp
event->key();
```

Returns values such as:

```text
Qt::Key_A

Qt::Key_Enter

Qt::Key_F5

Qt::Key_Delete
```

---

### Text

```cpp
event->text();
```

Useful for entered characters.

---

### Modifiers

```cpp
event->modifiers();
```

Examples:

```text
Ctrl

Shift

Alt

Meta
```

---

## Example

```cpp
void Editor::keyPressEvent(QKeyEvent *event)
{
    if (event->key() == Qt::Key_Delete)
    {
        deleteSelectedObject();
        event->accept();
    }
    else
    {
        QWidget::keyPressEvent(event);
    }
}
```

---

# 3. QWheelEvent

Represents mouse wheel scrolling.

---

## Typical Usage

```text
Zoom

Scroll

Rotate
```

---

## Qt 5 vs Qt 6

Qt 5 commonly uses:

```cpp
event->angleDelta()
```

Qt 6 continues to use:

```cpp
event->angleDelta()
```

High-resolution devices may also provide:

```cpp
event->pixelDelta()
```

for smooth scrolling.

---

## CAD Example

```text
Wheel

↓

Zoom Drawing
```

---

## Medical TPS

```text
Wheel

↓

Zoom CT Slice
```

---

# 4. QFocusEvent

Occurs when a widget gains or loses keyboard focus.

Functions:

```cpp
focusInEvent()

focusOutEvent()
```

Example:

```text
Click Text Box

↓

Focus In

↓

Type

↓

Focus Out
```

---

# Production Usage

```text
Highlight Active Widget

↓

Cursor Visible

↓

Editing Enabled
```

---

# 5. QPaintEvent

One of the most important events.

Whenever a widget needs repainting:

```text
Move Window

Resize

Expose Window

update()

↓

Paint Event
```

---

Virtual Function

```cpp
paintEvent(QPaintEvent *event)
```

---

Never call:

```cpp
paintEvent(...)
```

directly.

Instead:

```cpp
update();
```

Qt schedules a paint event.

---

## Why?

Multiple repaint requests can be merged (event compression), reducing unnecessary drawing.

---

# 6. QResizeEvent

Occurs when the widget changes size.

Virtual Function

```cpp
resizeEvent(QResizeEvent *event)
```

Useful APIs:

```cpp
event->size();

event->oldSize();
```

---

Example

```text
Resize Window

↓

Update Layout

↓

Recalculate Graphics

↓

update()
```

---

# Medical TPS Example

```text
Window Resize

↓

Resize OpenGL View

↓

Resize CT Viewer

↓

Resize DVH
```

---

# 7. QMoveEvent

Occurs when a widget moves.

Function:

```cpp
moveEvent(QMoveEvent *event)
```

Useful APIs:

```cpp
event->pos();

event->oldPos();
```

---

Typically used less often than resize events.

---

# 8. QCloseEvent

Occurs when the user attempts to close a window.

Function:

```cpp
closeEvent(QCloseEvent *event)
```

---

Example

```cpp
void MainWindow::closeEvent(QCloseEvent *event)
{
    if (hasUnsavedChanges())
    {
        event->ignore();
    }
    else
    {
        event->accept();
    }
}
```

---

Typical Uses

* Save confirmation
* Cleanup
* Stop worker threads
* Close database connections

---

# 9. QShowEvent

Occurs when a widget becomes visible.

Function:

```cpp
showEvent(QShowEvent *event)
```

Typical Uses:

* Lazy initialization
* Loading large datasets
* Starting animations
* Initial layout adjustments

---

# 10. QHideEvent

Occurs when a widget becomes hidden.

Function:

```cpp
hideEvent(QHideEvent *event)
```

Typical Uses:

* Pause animations
* Stop timers
* Release temporary resources

---

# Event Flow Summary

```text
Operating System

↓

Native Event

↓

QApplication::notify()

↓

QObject::event()

↓

Specific Handler

├── mousePressEvent()

├── keyPressEvent()

├── wheelEvent()

├── paintEvent()

├── resizeEvent()

├── moveEvent()

├── closeEvent()

├── showEvent()

└── hideEvent()
```

---

# Qt 5.15 vs Qt 6.11 Summary

| Event           | Qt5           | Qt6                |
| --------------- | ------------- | ------------------ |
| QMouseEvent     | `pos()`       | `position()`       |
| Global Position | `globalPos()` | `globalPosition()` |
| QKeyEvent       | Same          | Same               |
| QWheelEvent     | Same          | Same               |
| Paint Events    | Same          | Same               |
| Resize Events   | Same          | Same               |
| Close Events    | Same          | Same               |

The most significant API migration in this group is the move from integer mouse coordinates to floating-point coordinate APIs in Qt 6.

---

# Performance Tips

✅ Keep `paintEvent()` lightweight.

✅ Call `update()` instead of `repaint()` in most cases.

✅ Avoid heavy computations inside event handlers.

✅ Handle only the events your widget needs.

---

# Common Mistakes

❌ Calling `paintEvent()` directly.

❌ Ignoring the base implementation when default behavior is required.

❌ Performing expensive image processing inside `mouseMoveEvent()` without throttling.

❌ Using deprecated Qt 5 mouse-position APIs when porting to Qt 6.

---

# Interview Questions

## Easy

1. What is `QMouseEvent`?
2. What is `QKeyEvent`?
3. What is `QPaintEvent`?

---

## Medium

1. Why should `update()` be preferred over directly invoking painting?
2. Explain `closeEvent()`.
3. What information does `QResizeEvent` provide?

---

## Hard

1. Compare `QMouseEvent` APIs in Qt 5 and Qt 6.
2. Explain why Qt compresses paint events.
3. Describe the lifecycle of a repaint request.

---

## Expert

1. Design a custom medical image viewer that supports mouse-driven window/level adjustment, zooming, and panning.
2. Explain how `paintEvent()` interacts with the event loop and event dispatcher.
3. Discuss performance considerations when handling high-frequency mouse move events.

---

# Revision Notes

* `QMouseEvent` handles mouse input.
* `QKeyEvent` handles keyboard input.
* `QWheelEvent` supports scrolling and zooming.
* `QPaintEvent` triggers widget rendering.
* `QResizeEvent` reports size changes.
* `QMoveEvent` reports position changes.
* `QCloseEvent` controls window closing.
* `QShowEvent` and `QHideEvent` notify visibility changes.
* Qt 6 introduces floating-point mouse position APIs for improved precision.

---

# 🏥 Production Example — Medical TPS Interaction

```text
User Scrolls Mouse Wheel
           │
           ▼
      QWheelEvent
           │
           ▼
 Increase Zoom Level
           │
           ▼
     update()
           │
           ▼
      QPaintEvent
           │
           ▼
Render Updated CT Slice
           │
           ▼
Display Refreshed Image
```

This event sequence is typical in professional medical imaging software, CAD applications, and GIS viewers.

---

# 🎯 Chapter 30 — Part 2 Complete

You now understand:

* `QMouseEvent`
* `QKeyEvent`
* `QWheelEvent`
* `QFocusEvent`
* `QPaintEvent`
* `QResizeEvent`
* `QMoveEvent`
* `QCloseEvent`
* `QShowEvent`
* `QHideEvent`
* Qt 5 → Qt 6 migration for common event classes

---

# 🚀 Next Section

## **Chapter 30 — Part 3**

Excellent. This is one of the **most practical chapters** for developers building professional desktop software.

Many enterprise Qt applications—including **AutoCAD-like tools, Treatment Planning Systems (TPS), Photoshop-like editors, IDEs, and automotive HMIs**—rely heavily on:

* Drag & Drop
* Hover events
* Context menus
* Touch screens
* Tablet devices (Wacom)
* Event Filters
* Custom Events

This chapter completes your understanding of the Qt Event System.

---

# Complete Qt Master Course (Qt 5.15 LTS → Qt 6.11)

# PART IV — Application Architecture

# Chapter 30 — Events (Complete Deep Dive)

## Part 3 — Touch, Gesture, Hover, Drag & Drop, Context Menu, Custom Events & Event Filters

> **Level:** Advanced → Expert

---

# Chapter Objectives

After completing this chapter, you will understand:

* `QTouchEvent`
* `QGestureEvent`
* `QTabletEvent`
* `QHoverEvent`
* `QContextMenuEvent`
* Drag & Drop events
* Enter/Leave events
* Custom events
* Event propagation
* Event filters
* Qt 5 vs Qt 6 differences

---

# Table of Contents

1. Touch Events
2. Gesture Events
3. Tablet Events
4. Hover Events
5. Enter & Leave Events
6. Context Menu Events
7. Drag & Drop Events
8. Custom Events
9. Event Filters
10. Event Propagation
11. Qt 5 vs Qt 6
12. Best Practices
13. Interview Questions
14. Revision Notes

---

# 1. Touch Events

Modern devices support:

```text
Finger

↓

Touch Screen

↓

QTouchEvent
```

Examples:

* Medical touch monitors
* Industrial HMI
* Embedded Linux kiosks
* Tablets

---

## Header

```cpp
#include <QTouchEvent>
```

---

## Event Flow

```text
Finger Touch

↓

Operating System

↓

QTouchEvent

↓

event()

↓

touchEvent()
```

---

## Touch Points

One finger

```text
Point 1
```

Two fingers

```text
Point 1

Point 2
```

Multiple fingers

```text
Point 1

Point 2

Point 3

...
```

---

## Medical Example

```text
Two Finger Gesture

↓

Zoom CT

↓

Update Viewer
```

---

# 2. Gesture Events

Qt supports gestures.

Examples

```text
Pinch

Swipe

Pan

Tap

Tap and Hold
```

Header

```cpp
#include <QGestureEvent>
```

---

## Typical Flow

```text
Touch

↓

Gesture Recognizer

↓

QGestureEvent

↓

gestureEvent()
```

---

Example

```text
Pinch

↓

Zoom Image
```

---

# 3. Tablet Events

Professional software often supports pen tablets.

Header

```cpp
#include <QTabletEvent>
```

Used in:

* CAD
* Photoshop
* Medical contouring
* Digital drawing

---

Provides information such as:

* Position
* Pressure
* Tilt
* Rotation
* Pointer type

---

Medical TPS Example

```text
Stylus

↓

Draw Contour

↓

RT Structure
```

---

# 4. Hover Events

Unlike mouse move:

Hover occurs even when **no mouse button is pressed**.

Header

```cpp
#include <QHoverEvent>
```

Functions

```cpp
hoverEnterEvent()

hoverMoveEvent()

hoverLeaveEvent()
```

---

Typical Uses

```text
Tooltips

Highlight

Preview

Crosshair
```

---

CAD Example

```text
Hover

↓

Highlight Edge
```

---

# 5. Enter & Leave Events

When cursor enters widget

```cpp
enterEvent(...)
```

Leaves

```cpp
leaveEvent(...)
```

---

Flow

```text
Cursor Outside

↓

Cursor Inside

↓

enterEvent()

↓

Cursor Leaves

↓

leaveEvent()
```

---

Used for

```text
Hover Highlight

Status Messages

Animations
```

---

# 6. Context Menu Events

Right click

↓

Context Menu

Header

```cpp
#include <QContextMenuEvent>
```

Function

```cpp
contextMenuEvent(...)
```

---

Example

```text
Right Click Beam

↓

Context Menu

↓

Delete

Rename

Copy

Properties
```

---

Medical TPS

```text
Right Click ROI

↓

Rename ROI

↓

Delete ROI

↓

ROI Color
```

---

# 7. Drag & Drop Events

Qt supports complete drag and drop.

Events

```text
Drag Enter

Drag Move

Drop

Drag Leave
```

Classes

```text
QDragEnterEvent

QDragMoveEvent

QDropEvent

QDragLeaveEvent
```

---

Example

```text
Drag DICOM Folder

↓

TPS Window

↓

Import Patient
```

---

Flow

```text
Drag

↓

Drag Enter

↓

Drag Move

↓

Drop

↓

Load Data
```

---

Enable

```cpp
setAcceptDrops(true);
```

---

# 8. Custom Events

Qt allows custom events.

Define

```cpp
class DoseFinishedEvent
    : public QEvent
{
};
```

Post

```cpp
QCoreApplication::postEvent(
    receiver,
    new DoseFinishedEvent);
```

Receive

```cpp
bool event(QEvent *event)
{
}
```

---

Flow

```text
Worker Thread

↓

Custom Event

↓

GUI Thread

↓

Update Dose
```

---

## Registering Custom Event Types

Qt provides:

```cpp
int myType = QEvent::registerEventType();
```

This returns a unique event type value, helping avoid conflicts with other custom event types.

Example:

```cpp
class DoseFinishedEvent : public QEvent
{
public:
    static const QEvent::Type Type;

    DoseFinishedEvent()
        : QEvent(Type)
    {}
};

const QEvent::Type DoseFinishedEvent::Type =
    static_cast<QEvent::Type>(QEvent::registerEventType());
```

---

# 9. Event Filters

One of Qt's most powerful features.

Install

```cpp
object->installEventFilter(filter);
```

Flow

```text
Event

↓

Event Filter

↓

Widget
```

The filter sees the event **before** the target object.

---

Example

```text
Key Press

↓

Event Filter

↓

Consume?

↓

Yes

↓

Stop

----------

No

↓

Widget
```

---

Uses

```text
Global Shortcuts

Logging

Security

Custom Behavior

Validation
```

We'll study Event Filters in detail in **Chapter 31**.

---

# 10. Event Propagation

Suppose

```text
Main Window

↓

Panel

↓

Button
```

Mouse Event

↓

Button

Handled?

Yes

↓

Stop

---

Ignored?

↓

Panel

↓

Main Window

Again, the exact propagation behavior depends on the event type.

---

# 11. Qt 5 vs Qt 6

| Feature        | Qt 5.15 | Qt 6.11                                  |
| -------------- | ------- | ---------------------------------------- |
| Touch Events   | ✔       | ✔ (updated pointer event infrastructure) |
| Gesture Events | ✔       | ✔                                        |
| Tablet Events  | ✔       | ✔ (some API modernization)               |
| Drag & Drop    | ✔       | ✔                                        |
| Event Filters  | ✔       | ✔                                        |

The overall concepts remain the same.

Qt 6 introduced improvements to pointer event handling and modernized several input event APIs.

---

# 12. Best Practices

✅ Use event filters only when interception is required.

✅ Use custom events for asynchronous event-driven communication.

✅ Keep event handlers lightweight.

✅ Use drag-and-drop APIs instead of manually tracking drag state.

✅ Prefer Qt's gesture framework over platform-specific gesture APIs.

---

# 13. Common Mistakes

❌ Forgetting:

```cpp
setAcceptDrops(true);
```

---

❌ Returning `true` from an event filter unintentionally, preventing the target object from receiving the event.

---

❌ Creating custom event types with hard-coded numeric values instead of using `QEvent::registerEventType()`.

---

❌ Performing expensive work inside hover or mouse-move events without throttling.

---

# 14. Interview Questions

## Easy

1. What is `QTouchEvent`?
2. What is `QHoverEvent`?
3. What is an event filter?

---

## Medium

1. Explain drag-and-drop event flow.
2. How do custom events work?
3. What is `QEvent::registerEventType()`?

---

## Hard

1. Compare hover events and mouse move events.
2. Explain event propagation.
3. Describe the role of event filters.

---

## Expert

1. Design a drag-and-drop DICOM importer using Qt events.
2. Explain how a custom event can be used to notify the GUI that dose calculation has completed.
3. Design a global keyboard shortcut manager using event filters.

---

# 15. Complete Event Family

```text
QEvent
│
├── QMouseEvent
├── QKeyEvent
├── QWheelEvent
├── QPaintEvent
├── QResizeEvent
├── QMoveEvent
├── QCloseEvent
├── QFocusEvent
├── QHoverEvent
├── QTouchEvent
├── QTabletEvent
├── QGestureEvent
├── QContextMenuEvent
├── QDragEnterEvent
├── QDragMoveEvent
├── QDropEvent
├── QDragLeaveEvent
├── QTimerEvent
└── Custom Events
```

---

# 🏥 Production Example — Treatment Planning System

```text
Doctor Drags DICOM Folder
          │
          ▼
    QDragEnterEvent
          │
          ▼
    Validate MIME Data
          │
          ▼
      Accept Drag
          │
          ▼
       QDropEvent
          │
          ▼
    Load Patient Data
          │
          ▼
   Background Import Thread
          │
          ▼
  DoseFinishedEvent Posted
          │
          ▼
      GUI Event Queue
          │
          ▼
 Update Patient Browser
          │
          ▼
 Refresh Slice Views
```

---

# 16. Revision Notes

* `QTouchEvent` handles multi-touch input.
* `QGestureEvent` represents high-level gestures.
* `QTabletEvent` supports stylus devices.
* `QHoverEvent` occurs when the pointer moves without buttons pressed.
* `QContextMenuEvent` handles context menus.
* Drag-and-drop uses a sequence of dedicated event classes.
* Use `QEvent::registerEventType()` for custom event types.
* Event filters intercept events before the target object receives them.

---

# 🎯 Chapter 30 Complete

Congratulations! You have completed one of the largest and most important chapters in Qt.

You now understand:

* The complete Qt event architecture
* Event lifecycle
* Event delivery
* Standard event classes
* Touch and gesture events
* Drag-and-drop
* Context menus
* Custom events
* Event propagation
* Event filters
* Qt 5 → Qt 6 migration considerations

This knowledge forms the foundation for building highly interactive Qt applications.

---

# 🚀 Next Chapter

## **Chapter 31 — Event Filters (Complete Deep Dive)**
