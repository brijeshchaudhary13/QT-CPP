Excellent.

**Chapter 44 is arguably the most important chapter in all of Qt.**

Everything in Qt is driven by **events**.

When the user:

* clicks the mouse,
* presses a key,
* resizes a window,
* moves the mouse,
* closes a dialog,
* starts a timer,
* receives network data,
* drags a file,

Qt handles all of these through its **Event System**.

If you truly understand this chapter, you'll understand **how Qt itself works**.

This knowledge is expected from senior Qt developers working on products like:

* Qt Creator
* Autodesk AutoCAD
* Medical TPS
* CAD/CAM software
* Embedded HMI systems
* Industrial SCADA applications

---

# Complete Qt Master Course (Qt 5.15 LTS → Qt 6.11)

# PART VI — Event System & Application Architecture

# Chapter 44 — Events and Event Handling (Complete Deep Dive)

## Part 1 — Event Loop, QEvent, Event Delivery, Event Handlers & Event Propagation

> **Level:** Beginner → Expert

---

# Chapter Objectives

After completing this chapter, you will understand:

* What is an event?
* Qt Event Loop
* `QEvent`
* Event delivery
* Event propagation
* Event handlers
* Event acceptance
* Event lifecycle
* Qt 5 vs Qt 6

---

# Table of Contents

1. What is an Event?
2. Event Loop
3. QEvent
4. Event Delivery
5. Event Handlers
6. Event Acceptance & Propagation
7. Event Lifecycle
8. Qt Source Code Concepts
9. Qt 5 vs Qt 6
10. Best Practices
11. Interview Questions
12. Revision Notes

---

# 1. What is an Event?

An **event** represents something that happened and requires a response.

Examples:

```text
Mouse Click

Key Press

Window Resize

Paint Request

Timer Timeout

Close Window

Drag & Drop

Wheel Scroll
```

An event is simply **a notification** that something has occurred.

---

## Real-Life Analogy

Imagine a receptionist in an office.

```text
Visitor Arrives
        │
        ▼
Receptionist Receives Information
        │
        ▼
Manager Handles It
```

In Qt:

```text
Mouse Click
        │
        ▼
Qt Event System
        │
        ▼
Widget Handles It
```

---

# 2. Qt Event Loop

The Event Loop is the **heart of every Qt application**.

Example:

```cpp
QApplication app(argc, argv);

MainWindow window;

window.show();

return app.exec();
```

The important line is:

```cpp
app.exec();
```

This starts the **main event loop**.

---

## What Does It Do?

Conceptually:

```text
Application Starts
        │
        ▼
Event Loop Begins
        │
        ▼
Wait for Event
        │
        ▼
Receive Event
        │
        ▼
Dispatch Event
        │
        ▼
Repeat
```

The loop continues until the application exits.

---

## Continuous Processing

```text
Mouse Click
        │
        ▼
Process

↓

Key Press
        │
        ▼
Process

↓

Paint Event
        │
        ▼
Process

↓

Resize Event
        │
        ▼
Process

↓

...
```

Qt continuously waits for new events.

---

# 3. QEvent

Every event in Qt is represented by a `QEvent` object or one of its subclasses.

Inheritance:

```text
QEvent
   │
   ├── QMouseEvent
   ├── QKeyEvent
   ├── QPaintEvent
   ├── QResizeEvent
   ├── QWheelEvent
   ├── QCloseEvent
   ├── QFocusEvent
   ├── QMoveEvent
   └── ...
```

Header:

```cpp
#include <QEvent>
```

---

## Event Types

Each event has a type.

Example:

```cpp
event->type();
```

Returns values such as:

```text
MouseButtonPress

MouseMove

KeyPress

Paint

Resize

Close

Wheel
```

---

# 4. Event Delivery

Suppose the user clicks a button.

The flow is:

```text
Mouse Click
      │
      ▼
Operating System
      │
      ▼
Qt Event Dispatcher
      │
      ▼
QApplication
      │
      ▼
Target Widget
      │
      ▼
mousePressEvent()
```

Qt determines **which widget should receive the event**.

---

## Another Example

Keyboard input:

```text
Keyboard

↓

Operating System

↓

Qt

↓

Focused Widget

↓

keyPressEvent()
```

Only the widget with keyboard focus receives keyboard events.

---

# 5. Event Handlers

Widgets respond by overriding event handler functions.

Common handlers include:

| Event         | Handler                   |
| ------------- | ------------------------- |
| Mouse Press   | `mousePressEvent()`       |
| Mouse Move    | `mouseMoveEvent()`        |
| Mouse Release | `mouseReleaseEvent()`     |
| Double Click  | `mouseDoubleClickEvent()` |
| Key Press     | `keyPressEvent()`         |
| Key Release   | `keyReleaseEvent()`       |
| Paint         | `paintEvent()`            |
| Resize        | `resizeEvent()`           |
| Move          | `moveEvent()`             |
| Close         | `closeEvent()`            |
| Focus In      | `focusInEvent()`          |
| Focus Out     | `focusOutEvent()`         |
| Wheel         | `wheelEvent()`            |

---

## Example

```cpp
void MyWidget::mousePressEvent(QMouseEvent *event)
{
    qDebug() << "Mouse Pressed";
}
```

Flow:

```text
Click

↓

mousePressEvent()

↓

Application Logic
```

---

# 6. Event Acceptance & Propagation

Not every widget handles every event.

Qt allows widgets to:

* Accept the event
* Ignore the event

---

## Accept

```cpp
event->accept();
```

Meaning:

```text
Handled

↓

Stop Propagation
```

---

## Ignore

```cpp
event->ignore();
```

Meaning:

```text
Not Handled

↓

Parent May Handle It
```

---

## Propagation

Imagine:

```text
Main Window
      │
      ▼
Panel
      │
      ▼
Button
```

If the button ignores an event:

```text
Button

↓

Ignore

↓

Panel

↓

Maybe Handle

↓

Main Window
```

Propagation depends on the event type and widget hierarchy.

---

# 7. Event Lifecycle

A typical event goes through these stages:

```text
User Action
      │
      ▼
Operating System
      │
      ▼
Native Event
      │
      ▼
Qt Event Object
      │
      ▼
Event Queue
      │
      ▼
Event Dispatcher
      │
      ▼
Target Widget
      │
      ▼
Event Handler
      │
      ▼
Accept / Ignore
```

---

# 8. Qt Source Code Concepts

Internally, the process is conceptually similar to:

```text
app.exec()
      │
      ▼
QEventLoop
      │
      ▼
QAbstractEventDispatcher
      │
      ▼
Retrieve Native Event
      │
      ▼
Translate to QEvent
      │
      ▼
Deliver to QObject
      │
      ▼
event()
      │
      ▼
Specific Handler
```

This architecture allows Qt to provide a consistent programming model across Windows, Linux, and macOS.

---

# 9. Qt 5.15 vs Qt 6.11

| Feature           | Qt 5.15 | Qt 6.11 |
| ----------------- | ------- | ------- |
| Event Loop        | ✔       | ✔       |
| QEvent            | ✔       | ✔       |
| Event Handlers    | ✔       | ✔       |
| Event Propagation | ✔       | ✔       |

The event system remains fundamentally the same.

---

# 10. Best Practices

✅ Override only the event handlers you need.

✅ Call the base class implementation when appropriate.

Example:

```cpp
void MyWidget::resizeEvent(QResizeEvent *event)
{
    QWidget::resizeEvent(event);

    // Custom logic
}
```

✅ Keep event handlers lightweight.

✅ Avoid blocking the event loop.

---

# 11. Common Mistakes

### ❌ Performing long calculations inside an event handler

Bad:

```text
Mouse Click

↓

10-Second Calculation

↓

UI Frozen
```

Instead:

```text
Mouse Click

↓

Start Worker Thread

↓

Return Immediately
```

---

### ❌ Ignoring the base class unnecessarily

Some default behavior may be lost.

---

### ❌ Confusing signals with events

Events originate from the system or Qt infrastructure.

Signals are emitted by objects to notify other objects.

---

# 12. Interview Questions

## Easy

1. What is an event?
2. What is the Qt Event Loop?
3. What is `QEvent`?

---

## Medium

1. Explain `app.exec()`.
2. How are events delivered to widgets?
3. What is event propagation?

---

## Hard

1. Describe the lifecycle of a mouse click.
2. Explain why blocking the event loop freezes the UI.
3. Compare event handlers with signals and slots.

---

## Expert

1. Explain how Qt converts native OS events into `QEvent` objects.
2. Design the event flow for a Medical TPS viewer receiving mouse, keyboard, and timer events simultaneously.
3. Compare event-driven programming with polling-based architectures.

---

# 13. Architecture Diagram

```text
                  Operating System
                         │
                  Native Event
                         │
                         ▼
            QAbstractEventDispatcher
                         │
                         ▼
                  QApplication
                         │
                         ▼
                    QEventLoop
                         │
                         ▼
                  Target QObject
                         │
                         ▼
                     event()
                         │
          ┌──────────────┼──────────────┐
          ▼              ▼              ▼
 mousePressEvent()  keyPressEvent()  paintEvent()
                         │
                         ▼
                 Application Logic
```

---

# 🏥 Production Example — Treatment Planning System

Imagine a doctor interacting with the CT viewer.

```text
Mouse Click
      │
      ▼
Select Beam
      │
      ▼
Mouse Move
      │
      ▼
Update Crosshair
      │
      ▼
Wheel Event
      │
      ▼
Zoom CT Image
      │
      ▼
Key Press (Delete)
      │
      ▼
Remove Selected Marker
      │
      ▼
Paint Event
      │
      ▼
Redraw Viewer
```

Multiple event types work together to create a smooth, interactive experience.

---

# 14. Revision Notes

* Every user interaction is represented as an event.
* `app.exec()` starts the Qt event loop.
* `QEvent` is the base class for all events.
* Qt delivers events to the appropriate target object.
* Widgets respond by overriding event handlers.
* Events can be accepted or ignored.
* Long-running work should never block the event loop.

---
Excellent.

This is one of the **most advanced chapters in the Qt framework**.

If **Part 1** explained *how Qt delivers events*, this part explains **how you can intercept, modify, redirect, create, prioritize, and optimize events**.

These techniques are used inside professional software such as:

* Qt Creator
* Autodesk AutoCAD
* Medical Treatment Planning Systems (TPS)
* 3D Slicer
* Wireshark
* Industrial HMI/SCADA systems
* Embedded Linux applications

Understanding these concepts separates **intermediate Qt developers** from **senior Qt engineers**.

---

# Complete Qt Master Course (Qt 5.15 LTS → Qt 6.11)

# PART VI — Event System & Application Architecture

# Chapter 44 — Events and Event Handling (Complete Deep Dive)

## Part 2 — event(), Event Filters, sendEvent(), postEvent(), Custom Events & Event Dispatcher Internals

> **Level:** Advanced → Expert

---

# Chapter Objectives

After completing this chapter, you will understand:

* `event()`
* Event Filters
* Installing Event Filters
* `sendEvent()`
* `postEvent()`
* Custom Events
* Event Priorities
* Event Compression
* Native Event Filters
* Event Dispatcher Internals

---

# Table of Contents

1. `event()`
2. Event Filters
3. Installing Event Filters
4. `sendEvent()` vs `postEvent()`
5. Custom Events
6. Event Priorities
7. Event Compression
8. Native Event Filters
9. Event Dispatcher Internals
10. Qt 5 vs Qt 6
11. Best Practices
12. Interview Questions
13. Revision Notes

---

# 1. `event()`

Every `QObject` ultimately receives events through:

```cpp
virtual bool event(QEvent *event);
```

Most developers override specific handlers like:

```cpp
mousePressEvent()

keyPressEvent()

paintEvent()
```

Internally, however, Qt first calls:

```text
event()
        │
        ▼
Determine Event Type
        │
        ▼
Call Specific Handler
```

---

## Conceptual Flow

```text
Mouse Click
      │
      ▼
event()
      │
      ▼
mousePressEvent()
```

Keyboard:

```text
Key Press
      │
      ▼
event()
      │
      ▼
keyPressEvent()
```

---

## Example

```cpp
bool MyWidget::event(QEvent *event)
{
    if(event->type() == QEvent::ToolTip)
    {
        // Handle tooltip
        return true;
    }

    return QWidget::event(event);
}
```

This allows handling multiple event types in one place.

---

# 2. Event Filters

Sometimes you want to intercept another object's events **without modifying its source code**.

Qt provides:

```cpp
eventFilter()
```

Think of it as:

```text
Event

↓

Security Check

↓

Destination Widget
```

The filter can:

* Observe
* Modify
* Block

the event before the target receives it.

---

# Example

```cpp
bool Filter::eventFilter(QObject *obj,
                         QEvent *event)
{
    if(event->type() == QEvent::KeyPress)
    {
        return true;
    }

    return QObject::eventFilter(obj, event);
}
```

Returning:

```text
true

↓

Stop Event
```

Returning:

```text
false

↓

Continue
```

---

# 3. Installing Event Filters

Create filter:

```cpp
Filter *filter = new Filter(this);
```

Install:

```cpp
button->installEventFilter(filter);
```

Flow:

```text
Mouse Click

↓

Filter

↓

Button
```

One filter can observe many widgets.

---

## Global Filter

```cpp
qApp->installEventFilter(filter);
```

Now:

```text
Application

↓

Every Event

↓

Filter
```

This is useful for:

* Logging
* Global shortcuts
* Analytics
* Accessibility features

---

# 4. sendEvent() vs postEvent()

This is a very common interview topic.

---

## sendEvent()

```cpp
QApplication::sendEvent(
    widget,
    event);
```

Behavior:

```text
Send

↓

Immediately Delivered

↓

Return
```

The caller waits until the event has been processed.

---

## postEvent()

```cpp
QApplication::postEvent(
    widget,
    event);
```

Behavior:

```text
Post

↓

Queue

↓

Return Immediately

↓

Event Loop

↓

Deliver Later
```

---

## Comparison

| Feature          | sendEvent() | postEvent() |
| ---------------- | ----------- | ----------- |
| Immediate        | ✔           | ✘           |
| Queued           | ✘           | ✔           |
| Blocks Caller    | ✔           | ✘           |
| Uses Event Queue | ✘           | ✔           |

---

# 5. Custom Events

Qt allows applications to define their own event types.

Example:

```cpp
const QEvent::Type DoseFinishedEvent =
    static_cast<QEvent::Type>(
        QEvent::User + 1);
```

Create event:

```cpp
class DoseEvent : public QEvent
{
public:
    DoseEvent()
        : QEvent(DoseFinishedEvent)
    {}
};
```

---

Deliver:

```cpp
QApplication::postEvent(
    receiver,
    new DoseEvent());
```

Handle:

```cpp
bool MyWidget::event(QEvent *event)
{
    if(event->type() == DoseFinishedEvent)
    {
        // Update UI
        return true;
    }

    return QWidget::event(event);
}
```

---

# TPS Example

```text
Dose Engine

↓

Dose Finished Event

↓

Viewer

↓

Refresh Dose Display
```

This avoids tight coupling between components.

---

# 6. Event Priorities

When using `postEvent()`, Qt supports priorities.

Conceptually:

```text
High Priority

↓

Normal Priority

↓

Low Priority
```

Higher-priority posted events are processed first.

This is useful when some UI updates are more urgent than others.

---

# 7. Event Compression

Some events occur very frequently.

Example:

```text
Mouse Move

↓

1000 Events
```

Processing every event could be wasteful.

Qt compresses certain event types.

Example:

```text
Resize

↓

Resize

↓

Resize

↓

Resize
```

Instead of:

```text
4 Updates
```

Qt may deliver:

```text
Latest Resize
```

This improves performance.

Common compressible events include:

* Paint events
* Resize events
* Mouse move events (platform-dependent and situation-dependent)

---

# 8. Native Event Filters

Qt also allows filtering native operating system events before they are translated into `QEvent`.

Implement:

```cpp
QAbstractNativeEventFilter
```

Flow:

```text
Windows Message

↓

Native Filter

↓

Qt

↓

QEvent
```

Useful for:

* Platform-specific APIs
* System hotkeys
* Native integration

---

# 9. Event Dispatcher Internals

Conceptually:

```text
Operating System

↓

Native Event Queue

↓

QAbstractEventDispatcher

↓

QEventLoop

↓

QObject::event()

↓

Specific Event Handler
```

When using `postEvent()`:

```text
postEvent()

↓

Qt Event Queue

↓

Event Loop

↓

Dispatch

↓

Target Object
```

When using `sendEvent()`:

```text
sendEvent()

↓

Immediate Dispatch

↓

Target Object
```

---

# 10. Enterprise Example

Medical TPS workflow:

```text
Dose Engine Thread
        │
        ▼
Dose Finished
        │
        ▼
Custom Dose Event
        │
        ▼
Event Queue
        │
        ▼
Main Window
        │
        ▼
Update DVH

↓

Refresh Viewer

↓

Update Status Bar
```

The computation thread remains separate from the GUI, while the GUI updates safely through the event system.

---

# 11. Qt Source Code Concepts

Conceptually:

```text
Native Event
      │
      ▼
QAbstractEventDispatcher
      │
      ▼
QCoreApplication::notify()
      │
      ▼
QObject::event()
      │
      ▼
Specific Handler
```

`notify()` is responsible for forwarding events to the appropriate object after they are dispatched.

---

# 12. Qt 5.15 vs Qt 6.11

| Feature              | Qt 5.15 | Qt 6.11 |
| -------------------- | ------- | ------- |
| event()              | ✔       | ✔       |
| Event Filters        | ✔       | ✔       |
| sendEvent()          | ✔       | ✔       |
| postEvent()          | ✔       | ✔       |
| Custom Events        | ✔       | ✔       |
| Native Event Filters | ✔       | ✔       |

The event architecture remains stable across both versions.

---

# 13. Best Practices

✅ Override `event()` only when you need to handle multiple event types or custom events.

✅ Use event filters to extend behavior without modifying existing widgets.

✅ Prefer `postEvent()` for asynchronous communication.

✅ Use custom events to decouple subsystems.

✅ Always pass unhandled events to the base class implementation.

---

# 14. Common Mistakes

### ❌ Blocking the event loop

Long-running work inside event handlers makes the application unresponsive.

---

### ❌ Returning `true` from an event filter unnecessarily

This prevents the target object from receiving the event.

---

### ❌ Using `sendEvent()` when asynchronous delivery is more appropriate

Immediate delivery can lead to unexpected re-entrant behavior.

---

### ❌ Forgetting ownership rules for posted events

Events allocated with `new` and posted via `postEvent()` are owned and deleted by Qt after delivery. Do not delete them yourself after posting.

---

# 15. Interview Questions

## Easy

1. What is `event()`?
2. What is an event filter?
3. What is the difference between `sendEvent()` and `postEvent()`?

---

## Medium

1. How do you install an event filter?
2. Why would you override `event()` instead of `mousePressEvent()`?
3. What are custom events?

---

## Hard

1. Explain the complete lifecycle of a posted event.
2. Describe event compression and its benefits.
3. Compare native event filters with Qt event filters.

---

## Expert

1. Design an event architecture for a Treatment Planning System where the Dose Engine, DVH Viewer, and Status Bar communicate through custom events.
2. Explain how `QCoreApplication::notify()` participates in event delivery.
3. Compare signals/slots and custom events for cross-component communication in large Qt applications.

---

# 16. Architecture Diagram

```text
                 Operating System
                        │
                 Native Event Queue
                        │
                        ▼
          QAbstractEventDispatcher
                        │
                        ▼
                 QEventLoop
                        │
                QCoreApplication::notify()
                        │
                        ▼
                QObject::event()
          ┌─────────────┼──────────────┐
          ▼             ▼              ▼
   Event Filter   Custom Event   Mouse Event
          │             │              │
          └─────────────┼──────────────┘
                        ▼
                Application Logic
```

---

# 🏥 Production Example — Treatment Planning System

```text
Doctor Starts Dose Calculation
               │
               ▼
        Dose Engine Thread
               │
               ▼
      Dose Calculation Complete
               │
               ▼
     postEvent(DoseFinishedEvent)
               │
               ▼
         Qt Event Queue
               │
               ▼
        Main Window Receives Event
               │
      ┌────────┼───────────┐
      ▼        ▼           ▼
 Refresh CT  Update DVH  Status Bar
      │        │           │
      └────────┴───────────┘
               ▼
        Repaint Application
```

This architecture keeps computational code independent from GUI code while ensuring updates occur safely in the GUI thread.

---

# 17. Revision Notes

* `event()` is the central event handler used by Qt.
* Event filters allow observing or intercepting another object's events.
* `installEventFilter()` attaches a filter to an object.
* `sendEvent()` delivers events immediately.
* `postEvent()` queues events for later delivery.
* Custom events allow application-specific communication.
* Event compression reduces unnecessary processing.
* Native event filters operate before Qt translates platform events.
* Unhandled events should usually be forwarded to the base class implementation.

---


# 🚀 Next Chapter

## **Chapter 45 — Painting System (Complete Deep Dive)**

