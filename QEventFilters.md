Excellent. **Chapter 31 is one of the most powerful topics in Qt.**

Many developers use Qt for years without understanding Event Filters properly.

However, Event Filters are used extensively in:

* Qt Creator
* Qt Designer
* AutoCAD
* Photoshop
* Medical TPS
* IDEs
* Enterprise Desktop Applications

Almost every large Qt application uses Event Filters for implementing global shortcuts, input validation, custom behavior, and centralized event handling.

As a Qt Architect, I can confidently say:

> **If Signals & Slots are Qt's communication mechanism, Event Filters are Qt's interception mechanism.**

---

# Complete Qt Master Course (Qt 5.15 LTS → Qt 6.11)

# PART IV — Application Architecture

# Chapter 31 — Event Filters (Complete Deep Dive)

## Part 1 — Introduction, Architecture, installEventFilter(), eventFilter() & Event Flow

**Level:** Beginner → Expert

---

# Chapter Objectives

After this chapter you will understand:

* What Event Filters are
* Why they exist
* How `installEventFilter()` works
* `eventFilter()`
* Event interception
* Event consumption
* Local Event Filters
* Event flow
* Qt5 vs Qt6

---

# Table of Contents

1. Introduction
2. Why Event Filters?
3. Architecture
4. installEventFilter()
5. eventFilter()
6. Event Flow
7. Returning true vs false
8. Local Event Filters
9. Qt5 vs Qt6
10. Best Practices
11. Interview Questions
12. Revision Notes

---

# 1. Introduction

Normally:

```text
Operating System

↓

Event Dispatcher

↓

QObject::event()

↓

mousePressEvent()
```

But sometimes we want to intercept the event **before** it reaches the target object.

Qt provides:

```text
Event Filter
```

---

Without Event Filter

```text
Mouse Click

↓

Button

↓

mousePressEvent()
```

---

With Event Filter

```text
Mouse Click

↓

Event Filter

↓

Button

↓

mousePressEvent()
```

The filter gets the **first opportunity** to inspect the event.

---

# 2. Why Event Filters?

Suppose an application has **100 text boxes**.

Requirement:

```text
Only Numbers Allowed
```

Without Event Filters

```text
TextBox1

↓

Override keyPressEvent()

----------------

TextBox2

↓

Override keyPressEvent()

----------------

...

100 Times
```

A lot of duplicated code.

---

With Event Filter

```text
One Event Filter

↓

100 Widgets
```

Much cleaner.

---

Real Uses

```text
Global Shortcut

Input Validation

Logging

Analytics

Security

Monitoring

Accessibility
```

---

# 3. Architecture

Normal Flow

```text
Operating System

↓

Event Dispatcher

↓

QObject

↓

event()

↓

Handler
```

---

With Filter

```text
Operating System

↓

Event Dispatcher

↓

Event Filter

↓

QObject

↓

event()

↓

Handler
```

---

# 4. installEventFilter()

Syntax

```cpp
object->installEventFilter(filterObject);
```

Example

```cpp
lineEdit->installEventFilter(this);
```

Meaning

```text
lineEdit

↓

Whenever Event Arrives

↓

Send To

↓

this->eventFilter()
```

---

# 5. eventFilter()

Prototype

```cpp
bool eventFilter(QObject *watched,
                 QEvent *event) override;
```

Parameters

```text
watched

↓

Object Receiving Event

--------------------

event

↓

Current Event
```

---

Basic Example

```cpp
bool MainWindow::eventFilter(QObject *watched,
                             QEvent *event)
{
    if (watched == lineEdit &&
        event->type() == QEvent::KeyPress)
    {
        qDebug() << "Key Press";
    }

    return QObject::eventFilter(watched, event);
}
```

---

# Event Flow

```text
Key Press

↓

Event Filter

↓

Log Message

↓

Return false

↓

lineEdit

↓

keyPressEvent()
```

---

# 6. Returning true vs false

This is the most important concept.

---

## Return false

```cpp
return false;
```

Meaning

```text
Continue

↓

Deliver Event

↓

Target Widget
```

---

Flow

```text
Event

↓

Event Filter

↓

false

↓

Widget

↓

Handler
```

---

## Return true

```cpp
return true;
```

Meaning

```text
Event Consumed

↓

Stop

↓

Widget Never Receives Event
```

---

Flow

```text
Event

↓

Event Filter

↓

true

↓

Stop
```

---

Example

```cpp
bool MainWindow::eventFilter(QObject *watched,
                             QEvent *event)
{
    if (event->type() == QEvent::MouseButtonPress)
    {
        return true;
    }

    return false;
}
```

Mouse press never reaches the widget.

---

# 7. Local Event Filters

Install

```cpp
button->installEventFilter(this);
```

Only

```text
button
```

is monitored.

---

Example

```text
Button1

↓

Filter

----------------

Button2

↓

No Filter
```

---

Useful For

```text
Single Widget

Custom Editor

Dialog

Specific Control
```

---

# 8. Multiple Filters

Suppose

```cpp
button->installEventFilter(filterA);

button->installEventFilter(filterB);
```

Conceptually:

```text
Event

↓

FilterB

↓

FilterA

↓

Widget
```

Qt invokes installed event filters in **reverse order of installation** (the most recently installed filter gets the first chance to process the event).

If any filter returns `true`, processing stops and earlier filters (and the target object) will not receive the event.

---

# 9. Removing Filter

```cpp
button->removeEventFilter(this);
```

Now

```text
Event

↓

Widget
```

Filter removed.

---

# 10. Real Project Example

Medical TPS

Need

```text
Disable

Mouse Wheel

During Dose Calculation
```

Install filter

```text
Dose View

↓

Wheel Event

↓

Blocked
```

User cannot accidentally zoom while the calculation is running.

---

CAD Example

```text
Mouse Move

↓

Event Filter

↓

Snap Engine

↓

Grid

↓

Cursor
```

The filter can perform centralized preprocessing before individual widgets react.

---

# 11. Qt Source Code Concept

Simplified

```text
notify()

↓

sendToFilters()

↓

Filter?

↓

event()

↓

mousePressEvent()
```

Conceptually:

```cpp
for (each filter)
{
    if (filter->eventFilter(...))
        return true;
}

receiver->event(event);
```

The real implementation includes additional checks, but this reflects the overall logic.

---

# 12. Qt 5 vs Qt 6

| Feature              | Qt5 | Qt6 |
| -------------------- | --- | --- |
| installEventFilter() | ✔   | ✔   |
| eventFilter()        | ✔   | ✔   |
| Local Filters        | ✔   | ✔   |
| Remove Filter        | ✔   | ✔   |

There is **no functional difference** between Qt 5.15 and Qt 6.11 for this feature.

---

# 13. Best Practices

✅ Install filters only where needed.

✅ Return `true` **only** if you intentionally consume the event.

✅ Return `false` when normal widget processing should continue.

✅ Keep filtering logic lightweight.

✅ Use descriptive helper methods when filters become large.

---

# 14. Common Mistakes

### Returning true accidentally

```cpp
return true;
```

Everything stops.

Widget appears "broken."

---

### Forgetting to remove filters

Long-lived filters installed on short-lived objects (or vice versa) can lead to confusing behavior. Ensure object lifetimes are well understood.

---

### Huge eventFilter()

Bad

```text
2000 Lines
```

Better

```text
eventFilter()

↓

handleMouse()

↓

handleKeyboard()

↓

handleWheel()
```

Keep the implementation modular.

---

# 15. Interview Questions

## Easy

1. What is an Event Filter?
2. Why use `installEventFilter()`?
3. What is `eventFilter()`?

---

## Medium

1. Difference between returning `true` and `false`?
2. Explain local event filters.
3. How do you remove an event filter?

---

## Hard

1. Describe the complete event flow with an event filter.
2. Explain multiple event filters and invocation order.
3. When should you use an event filter instead of overriding `mousePressEvent()`?

---

## Expert

1. Design a centralized keyboard shortcut system using event filters.
2. Build an input validation framework for hundreds of widgets without subclassing each one.
3. Explain how Qt internally invokes event filters before delivering events to the receiver.

---

# 16. Complete Event Flow

```text
Operating System
        │
        ▼
Native Event
        │
        ▼
Event Dispatcher
        │
        ▼
QCoreApplication::notify()
        │
        ▼
Installed Event Filters
        │
        ├── return true  ─────────────► Event Consumed
        │
        └── return false
                │
                ▼
        QObject::event()
                │
                ▼
      mousePressEvent()
      keyPressEvent()
      wheelEvent()
      ...
```

---

# 17. Revision Notes

* Event Filters intercept events **before** the target object receives them.
* Install a filter using `installEventFilter()`.
* Remove it using `removeEventFilter()`.
* Returning `true` consumes the event.
* Returning `false` allows normal processing.
* Filters are invoked in reverse installation order.
* Event Filters are ideal for cross-cutting behavior such as logging, validation, shortcuts, and centralized input handling.

---

# 🏥 Production Example — Treatment Planning System

```text
Doctor Presses Delete Key
          │
          ▼
Global Event Filter
          │
          ▼
Is Dose Calculation Running?
          │
     ┌────┴────┐
     │         │
    Yes        No
     │         │
     ▼         ▼
 Consume   Forward Event
     │         │
     ▼         ▼
 Ignore   ROI Deleted
```

This allows the application to temporarily disable destructive actions while critical calculations are in progress.

---
Excellent. This is the **advanced Event Filter chapter**.

After this chapter, you'll understand how applications like:

* **Qt Creator**
* **Qt Designer**
* **AutoCAD**
* **Visual Studio**
* **Medical TPS**
* **Adobe Photoshop**

implement features such as:

* Global shortcuts
* Application-wide logging
* Input restrictions
* Keyboard interception
* Mouse gesture handling
* Centralized security
* Enterprise auditing

This is how large Qt applications avoid duplicating event-handling logic across hundreds of widgets.

---

# Complete Qt Master Course (Qt 5.15 LTS → Qt 6.11)

# PART IV — Application Architecture

# Chapter 31 — Event Filters (Complete Deep Dive)

## Part 2 — Global Event Filters, Keyboard & Mouse Interception, Performance, Multi-threading & Enterprise Usage

> **Level:** Advanced → Expert

---

# Chapter Objectives

After completing this chapter, you will understand:

* Global Event Filters
* Application-wide event interception
* Keyboard filtering
* Mouse filtering
* Wheel filtering
* Performance considerations
* Multi-threading limitations
* Qt source code concepts
* Production architecture

---

# Table of Contents

1. Global Event Filters
2. Keyboard Filtering
3. Mouse Filtering
4. Wheel Filtering
5. Event Filters & Threads
6. Performance
7. Qt Source Code Concepts
8. Qt5 vs Qt6
9. Best Practices
10. Interview Questions
11. Revision Notes

---

# 1. Global Event Filters

So far we installed a filter on a single object:

```cpp
button->installEventFilter(this);
```

This affects only **that button**.

Sometimes you want to observe **every event in the application**.

Example requirements:

* Global shortcut manager
* Audit logging
* Input recorder
* Accessibility
* Debug event tracing

For this, install an event filter on the application object.

```cpp
qApp->installEventFilter(this);
```

or

```cpp
QCoreApplication::instance()->installEventFilter(this);
```

Now almost every event delivered through the application can pass through your filter before reaching its receiver.

---

# Global Event Flow

```text
Operating System
        │
        ▼
Event Dispatcher
        │
        ▼
QCoreApplication::notify()
        │
        ▼
Global Event Filter
        │
        ▼
Receiver's Local Event Filters
        │
        ▼
QObject::event()
        │
        ▼
Widget Handler
```

This is a conceptual view of the processing order.

---

# 2. Keyboard Filtering

One of the most common uses.

Example:

```text
Ctrl + S

↓

Save

----------------

Ctrl + Z

↓

Undo

----------------

Ctrl + Shift + P

↓

Command Palette
```

Example:

```cpp
bool MainWindow::eventFilter(QObject *obj,
                             QEvent *event)
{
    if (event->type() == QEvent::KeyPress)
    {
        auto *keyEvent =
            static_cast<QKeyEvent *>(event);

        if (keyEvent->modifiers() & Qt::ControlModifier &&
            keyEvent->key() == Qt::Key_S)
        {
            saveDocument();
            return true;
        }
    }

    return QObject::eventFilter(obj, event);
}
```

The shortcut is handled before the focused widget processes the key press.

> **Production Tip:** For standard application shortcuts, prefer `QShortcut` or `QAction` with shortcuts. Use an event filter only when you need custom interception logic.

---

# 3. Mouse Filtering

Suppose your application has:

```text
200 Widgets
```

Requirement:

```text
Log Every Mouse Click
```

Instead of overriding `mousePressEvent()` in every widget:

```text
One Global Filter

↓

Every Mouse Click
```

Example:

```cpp
if (event->type() == QEvent::MouseButtonPress)
{
    auto *mouseEvent =
        static_cast<QMouseEvent *>(event);

    qDebug() << mouseEvent->position();
}
```

Useful for:

* Analytics
* Recording user actions
* Debugging
* Automated testing

---

# 4. Wheel Filtering

Medical TPS example:

```text
Dose Calculation Running

↓

Disable Zoom
```

Implementation:

```cpp
if (event->type() == QEvent::Wheel)
{
    if (doseCalculationRunning)
        return true;
}
```

The wheel event is consumed.

The viewer never zooms.

---

# 5. Event Filters & Threads

A common interview topic.

Each `QObject` belongs to a thread.

```text
GUI Thread

↓

Main Window

-------------------

Worker Thread

↓

Worker Object
```

An event filter must execute in the context of the thread where the watched object processes its events.

If an object is moved to another thread, its event processing (and therefore its filtering) follows that thread's event loop.

**Important:**

* GUI widgets must remain in the GUI thread.
* Do not attempt to manipulate GUI widgets from worker threads inside an event filter.

---

# 6. Performance Considerations

Global filters receive a very large number of events.

Example:

```text
Mouse Move

Mouse Move

Mouse Move

Paint

Timer

Key

Hover

Resize
```

Potentially thousands of events per second.

Avoid:

```cpp
qDebug() << "Every event";
```

in production builds.

Instead:

```cpp
if (event->type() == QEvent::KeyPress)
{
    // Process only what you need
}
```

Filter only relevant event types.

---

# Fast Event Filter Pattern

```cpp
bool MyFilter::eventFilter(QObject *obj,
                           QEvent *event)
{
    switch (event->type())
    {
        case QEvent::KeyPress:
            return handleKey(
                obj,
                static_cast<QKeyEvent *>(event));

        case QEvent::MouseButtonPress:
            return handleMouse(
                obj,
                static_cast<QMouseEvent *>(event));

        default:
            return QObject::eventFilter(obj, event);
    }
}
```

This keeps the code organized and minimizes unnecessary work.

---

# 7. Enterprise Architecture Pattern

Large applications often centralize input handling.

```text
                QApplication
                       │
                       ▼
            Global Event Filter
                       │
        ┌──────────────┼──────────────┐
        ▼              ▼              ▼
 Shortcut Manager   Audit Logger   Security Filter
        │              │              │
        └──────────────┼──────────────┘
                       ▼
              Application Widgets
```

Each component has a clear responsibility.

---

# Medical TPS Example

```text
Doctor Presses Delete

↓

Global Filter

↓

Treatment Approved?
        │
   ┌────┴────┐
   │         │
  Yes        No
   │         │
   ▼         ▼
 Block    Forward Event
```

This prevents accidental modification of approved treatment plans.

---

# CAD Example

```text
Mouse Move

↓

Global Filter

↓

Snap Manager

↓

Grid

↓

Object Snap

↓

Forward Event

↓

Canvas
```

The filter enriches the event before it reaches the drawing widget.

---

# 8. Qt Source Code Concepts

Conceptually, event delivery looks like this:

```text
QCoreApplication::notify()
        │
        ▼
Application Event Filters
        │
        ▼
Receiver Event Filters
        │
        ▼
QObject::event()
        │
        ▼
Specific Event Handler
```

Qt internally iterates through installed filters.

Conceptually:

```cpp
for (auto *filter : filters)
{
    if (filter->eventFilter(receiver, event))
        return true;
}

return receiver->event(event);
```

The real implementation includes thread-safety checks, object lifetime handling, and other optimizations.

---

# 9. Qt 5.15 vs Qt 6.11

| Feature              | Qt 5.15 | Qt 6.11 |
| -------------------- | ------- | ------- |
| Global Event Filters | ✔       | ✔       |
| Keyboard Filtering   | ✔       | ✔       |
| Mouse Filtering      | ✔       | ✔       |
| Wheel Filtering      | ✔       | ✔       |
| API                  | Same    | Same    |

There is **no functional difference** between Qt 5.15 and Qt 6.11 for event filters.

---

# 10. Best Practices

✅ Use global filters only for application-wide behavior.

✅ Use local filters for widget-specific behavior.

✅ Filter only the event types you need.

✅ Return `true` only when intentionally consuming an event.

✅ Keep filter logic lightweight.

✅ Separate complex filtering logic into helper functions or dedicated classes.

---

# 11. Common Mistakes

### ❌ Logging every event

```cpp
qDebug() << event->type();
```

This can flood the console and significantly reduce performance.

---

### ❌ Heavy processing

```cpp
calculateDose();
```

inside an event filter.

This blocks event delivery for the application.

---

### ❌ Returning `true` unintentionally

```cpp
return true;
```

This prevents the target object from receiving the event.

---

### ❌ Using global filters for widget-specific behavior

Prefer installing the filter only on the relevant widget.

---

# 12. Interview Questions

## Easy

1. What is a global event filter?
2. How do you install one?
3. When should you return `true`?

---

## Medium

1. Compare local and global event filters.
2. How would you implement a global keyboard shortcut?
3. Why can event filters affect application performance?

---

## Hard

1. Describe the event flow through application and object event filters.
2. Explain how event filters interact with object threads.
3. Design an audit logger using global event filters.

---

## Expert

1. Design a centralized shortcut manager for a CAD application.
2. Build a TPS security layer that blocks editing during treatment approval.
3. Explain the conceptual implementation of event filter invocation inside `QCoreApplication::notify()`.

---

# 13. Architecture Diagram

```text
                  Operating System
                         │
                         ▼
                Event Dispatcher
                         │
                         ▼
             QCoreApplication::notify()
                         │
                         ▼
           Application Event Filters
                         │
                         ▼
            Object Event Filters
                         │
                         ▼
                 QObject::event()
                         │
                         ▼
      mousePressEvent()
      keyPressEvent()
      wheelEvent()
      paintEvent()
```

---

# 14. Revision Notes

* Install a global filter on the application object.
* Global filters see events from many objects.
* Local filters apply to specific watched objects.
* Event filters execute before the receiver processes the event.
* Returning `true` consumes the event.
* Keep filters efficient because they may process thousands of events.

---

# 🏥 Production Example — Treatment Planning System

```text
Doctor Presses Ctrl + S
          │
          ▼
 Global Event Filter
          │
          ▼
 Is Dose Calculation Running?
          │
     ┌────┴────┐
     │         │
    Yes        No
     │         │
     ▼         ▼
 Show Message  Save Patient Plan
     │
     ▼
 Consume Event
```

This ensures patient data cannot be saved while critical background operations are still modifying the treatment plan.

---

# 🎯 Chapter 31 Complete

You now understand:

* Local event filters
* Global event filters
* Keyboard interception
* Mouse interception
* Wheel interception
* Event filter architecture
* Performance considerations
* Enterprise usage patterns
* Qt 5 → Qt 6 behavior

At this point, you have mastered the complete Qt Event Filter system, from basic widget interception to application-wide event processing.

---

# 🚀 Next Chapter

## **Chapter 32 — Custom Events (Complete Deep Dive)**

The next chapter focuses entirely on creating your own event types and integrating them into Qt's event system.

Topics include:

* Why custom events are useful
* Creating classes derived from `QEvent`
* `QEvent::registerEventType()`
* `postEvent()` vs `sendEvent()`
* Handling custom events in `event()`
* Cross-thread event delivery
* Event priorities
* Performance considerations
* Qt source code concepts
* Enterprise use cases
* Medical TPS and CAD examples

This chapter will teach you how to extend Qt's event system with application-specific events in a clean, scalable, and thread-safe way.
