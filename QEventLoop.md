Excellent. This is one of the **most important chapters in the entire Qt framework**.

As a **Senior Qt Architect**, if I had to choose only **five chapters** that every Qt developer must master, they would be:

1. ✅ QObject
2. ✅ Signals & Slots
3. ✅ Event Loop (**This Chapter**)
4. ✅ Event System
5. ✅ Model/View Architecture

---

# Why is the Event Loop so Important?

Without the event loop, **nothing in Qt works properly**.

The event loop is responsible for:

* Mouse clicks
* Keyboard input
* Window painting
* Timers
* Networking
* Signals (queued connections)
* `deleteLater()`
* Animations
* Drag & Drop
* Clipboard
* Socket events
* Process events
* Deferred execution

If the event loop stops:

```text
GUI Freezes

Timers Stop

Network Stops

Signals Stop

Animations Stop

Application Looks Dead
```

---

# Complete Qt Master Course (Qt 5.15 LTS → Qt 6.11)

# PART IV — Application Architecture

# Chapter 28 — Event Loop (Complete Deep Dive)

## Part 1 — Fundamentals, Architecture, Event Queue & Event Processing

**Level:** Beginner → Expert

---

# Chapter Objectives

After completing this chapter, you will understand:

* What an event loop is
* Why it exists
* Internal architecture
* Event queue
* Event processing
* `QEventLoop`
* `exec()`
* Idle state
* Event lifecycle
* Qt5 vs Qt6

---

# Table of Contents

1. Introduction
2. Why Event Loop?
3. Event Loop Architecture
4. Event Queue
5. Event Lifecycle
6. QEventLoop
7. exec()
8. Waiting State
9. Event Processing
10. Qt5 vs Qt6
11. Best Practices
12. Interview Questions
13. Revision Notes

---

# 1. Introduction

Imagine a GUI application.

```cpp
int main(int argc,char* argv[])
{
    QApplication app(argc,argv);

    MainWindow window;

    window.show();

    return app.exec();
}
```

Everyone writes:

```cpp
app.exec();
```

Very few know what it actually does.

---

# app.exec()

Conceptually:

```text
Start Infinite Loop

↓

Wait For Event

↓

Receive Event

↓

Dispatch Event

↓

Repeat
```

Until:

```cpp
quit();
```

---

# 2. Why Event Loop?

Suppose:

```cpp
QPushButton button;

button.show();
```

Without

```cpp
app.exec();
```

Program:

```text
Create Button

↓

Show Button

↓

Exit
```

Window disappears immediately.

---

With event loop

```text
Create Window

↓

Wait

↓

Mouse Click

↓

Keyboard

↓

Paint

↓

Resize

↓

Timer

↓

Repeat
```

The application stays alive and responsive.

---

# 3. Event Loop Architecture

Conceptually

```text
Operating System

↓

Native Event Queue

↓

Qt Platform Plugin

↓

QAbstractEventDispatcher

↓

QEventLoop

↓

QObject

↓

event()

↓

mousePressEvent()
```

---

# Relationship

```text
QCoreApplication

↓

QEventLoop

↓

QAbstractEventDispatcher

↓

Operating System
```

---

# 4. Event Queue

Qt keeps an event queue.

Conceptually

```text
+------------------+

Paint Event

+------------------+

Mouse Event

+------------------+

Keyboard Event

+------------------+

Timer Event

+------------------+

Custom Event

+------------------+
```

The dispatcher removes one event at a time.

---

# FIFO

Normally

```text
First In

↓

First Out
```

Although event priorities and event compression can influence the effective processing order for some events.

---

# 5. Event Lifecycle

Suppose user clicks.

Lifecycle

```text
Mouse Click

↓

Operating System

↓

Native Event

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
```

Finally

```text
Your Code Executes
```

---

# Every Event

```text
Generated

↓

Queued

↓

Dispatched

↓

Processed

↓

Destroyed
```

---

# 6. QEventLoop

Header

```cpp
#include <QEventLoop>
```

Module

```text
QtCore
```

Normally

```cpp
app.exec();
```

internally uses a `QEventLoop`.

You can also create one manually:

```cpp
QEventLoop loop;

loop.exec();
```

Used in specialized scenarios, such as waiting for an asynchronous operation to complete.

---

# 7. exec()

Main Loop

```cpp
return app.exec();
```

Conceptually

```text
while(applicationRunning)
{
    Wait Event

    Dispatch Event
}
```

Qt's real implementation is platform-specific and considerably more complex, but this captures the idea.

---

# Internal Flow

```text
exec()

↓

QEventLoop

↓

QAbstractEventDispatcher

↓

Wait Native Event

↓

Translate

↓

Dispatch

↓

Repeat
```

---

# 8. Waiting State

Suppose

Nothing happens.

Qt

```text
Wait

Wait

Wait

Wait
```

CPU usage

```text
Near Zero
```

The event dispatcher blocks efficiently until new events arrive.

---

Mouse Click

```text
Wake Up

↓

Process Event

↓

Wait Again
```

---

# 9. Event Processing

Event arrives

```text
Queue

↓

notify()

↓

event()

↓

Specific Handler
```

Example

```text
QMouseEvent

↓

event()

↓

mousePressEvent()
```

Keyboard

```text
QKeyEvent

↓

event()

↓

keyPressEvent()
```

Timer

```text
QTimerEvent

↓

timerEvent()
```

---

# Multiple Events

Suppose

```text
Mouse

Keyboard

Timer

Paint

Resize
```

Queue

```text
Mouse

↓

Keyboard

↓

Paint

↓

Resize

↓

Timer
```

Processed sequentially by the event loop.

---

# 10. Event Sources

Events originate from many places.

```text
Operating System

↓

Mouse

Keyboard

Touch

Tablet

Network

Timers

Sockets

Custom Events

Signals (Queued)

Deferred Delete
```

Everything eventually reaches the event loop.

---

# 11. Idle State

When no events exist

```text
Event Queue Empty

↓

Wait
```

No busy polling.

No unnecessary CPU consumption.

This efficient waiting is one reason Qt applications can remain responsive while using little CPU when idle.

---

# 12. Memory Ownership

Events

Usually

```cpp
new QMouseEvent
```

or other event objects are created internally by Qt or by your code for custom events.

Posted events are generally owned by the event system after they are posted and are destroyed after processing.

Stack-allocated events are commonly used with `sendEvent()` because delivery is immediate.

---

# 13. Qt5 vs Qt6

| Feature     | Qt5 | Qt6 |
| ----------- | --- | --- |
| Event Loop  | ✔   | ✔   |
| QEventLoop  | ✔   | ✔   |
| Event Queue | ✔   | ✔   |
| exec()      | ✔   | ✔   |

There is **no major conceptual difference** between Qt5.15 and Qt6.11.

Qt6 contains internal improvements, but the overall event loop model remains the same.

---

# 14. Best Practices

✅ Never block the event loop.

✅ Move heavy computation to worker threads.

✅ Use queued communication for background tasks.

✅ Keep event handlers short.

✅ Avoid recursive event loops unless necessary.

---

# 15. Common Mistakes

### Infinite Loop

```cpp
while(true)
{
}
```

Result

```text
GUI Frozen
```

---

### Long Calculation

```cpp
calculateDose();
```

taking several seconds in the GUI thread.

Result

```text
Application Not Responding
```

Instead:

```text
Worker Thread

↓

Signal

↓

GUI Update
```

---

### Forgetting exec()

```cpp
return 0;
```

Window appears briefly or not at all because the event loop never starts.

---

# 16. Interview Questions

## Easy

1. What is the Event Loop?
2. Why is `app.exec()` needed?
3. What is `QEventLoop`?

---

## Medium

1. Explain event processing.
2. What happens when the event queue is empty?
3. Describe the event lifecycle.

---

## Hard

1. Explain the conceptual relationship between `QEventLoop` and `QAbstractEventDispatcher`.
2. How does Qt receive native events?
3. What happens if the event loop is blocked?

---

## Expert

1. Design an event-driven architecture for a Treatment Planning System.
2. Explain the path of a mouse click from the operating system to `mousePressEvent()`.
3. Discuss why efficient event handling is essential for responsive GUI applications.

---

# 17. Revision Notes

* The event loop is the heart of every Qt application.
* `app.exec()` starts the main event loop.
* Events are received from the operating system and Qt subsystems.
* The event queue stores pending events.
* Events are dispatched one by one.
* The event loop waits efficiently when idle.
* Blocking the event loop freezes the application.

---

# 🏥 Production Example — Treatment Planning System

```text
Operating System

↓

QApplication

↓

QEventLoop

↓

Event Dispatcher

↓

Patient Clicks Beam

↓

QMouseEvent

↓

Beam Editor

↓

Dose Recalculation Request

↓

Worker Thread

↓

Queued Signal

↓

GUI Update

↓

DVH Refresh

↓

3D Dose View Refresh
```

This architecture keeps the user interface responsive while computationally intensive dose calculations execute in background threads.

---

Excellent. This is the **most advanced Event Loop chapter**.

If you understand this chapter, you will understand why Qt applications sometimes:

* Freeze
* Randomly crash
* Execute slots unexpectedly
* Deadlock
* Process events in a surprising order
* Behave differently when dialogs are opened
* Become slow after long-running operations

These issues often trace back to the **event loop**.

This chapter is based on concepts used in **Qt's own source code**, though the explanations below are intentionally simplified to aid understanding.

---

# Complete Qt Master Course (Qt 5.15 LTS → Qt 6.11)

# PART IV — Application Architecture

# Chapter 28 — Event Loop (Complete Deep Dive)

## Part 2 — Nested Event Loops, Event Compression, Re-entrancy, DeferredDelete & Platform Internals

> **Level:** Advanced → Expert

---

# Chapter Objectives

After completing this chapter you will understand:

* Nested event loops
* Event starvation
* Event compression
* Deferred deletion
* Re-entrancy
* Timer integration
* Socket integration
* Platform dispatchers
* Performance optimization
* Qt source code concepts

---

# Table of Contents

1. Nested Event Loops
2. Event Starvation
3. Event Compression
4. DeferredDelete Events
5. Re-entrancy
6. Timers & Event Loop
7. Socket Notifiers
8. Platform Event Dispatchers
9. Performance
10. Qt 5 vs Qt 6
11. Best Practices
12. Interview Questions
13. Revision Notes

---

# 1. Nested Event Loops

Normally:

```text
Main Event Loop

↓

Application Running
```

However:

```cpp
QDialog dialog;

dialog.exec();
```

creates another event loop.

Conceptually:

```text
Main Event Loop
      │
      ▼
dialog.exec()
      │
      ▼
Nested Event Loop
      │
      ▼
Dialog Closed
      │
      ▼
Return To Main Event Loop
```

Qt now has:

* Main loop
* Dialog loop

running in a nested fashion.

---

## Why?

Because modal dialogs must:

* receive keyboard input
* receive mouse input
* repaint
* process timers

while blocking interaction with the rest of the application.

---

# Nested Loop Example

```cpp
QMessageBox::information(
    this,
    "Done",
    "Dose calculation finished");
```

Internally:

```text
QMessageBox

↓

exec()

↓

Nested Event Loop
```

---

# Risks

Nested loops can cause:

* unexpected signal delivery
* object deletion while waiting
* re-entrant execution
* difficult debugging

Use them only when appropriate.

---

# 2. Event Starvation

Suppose:

```cpp
while(processing)
{
    heavyWork();
}
```

Result:

```text
Event Queue

Paint

Mouse

Keyboard

Timer

↓

Never Processed
```

The application freezes because the event loop cannot process pending events.

---

# Solution

Better:

```text
Heavy Work

↓

Worker Thread

↓

Queued Signal

↓

GUI Thread
```

The GUI thread remains responsive.

---

# 3. Event Compression

Qt does **not always process every posted event individually**.

For efficiency, certain event types may be compressed.

Example:

Window resize.

User drags window.

Operating system generates:

```text
Resize

Resize

Resize

Resize

Resize

Resize

Resize
```

Qt may effectively process only the latest relevant resize event.

Conceptually:

```text
Resize

↓

Latest Resize

↓

Deliver
```

---

Another example:

```text
Paint

Paint

Paint

Paint
```

Qt may merge repaint requests so unnecessary painting is avoided.

This significantly improves GUI performance.

---

# Which Events Are Commonly Compressed?

Typically:

* Paint events
* Resize events
* Move events (depending on circumstances)

Custom events are **not** automatically compressed unless you implement such behavior yourself.

---

# 4. DeferredDelete Events

When:

```cpp
object->deleteLater();
```

Qt posts a special event.

Conceptually:

```text
deleteLater()

↓

DeferredDelete Event

↓

Event Queue

↓

Process Event

↓

QObject Destructor
```

This ensures:

* current event processing completes
* stack unwinds safely
* object destruction happens later

---

# Why Not delete?

Suppose:

```cpp
void Worker::finished()
{
    delete this;
}
```

Danger.

The current member function is still executing.

Safer:

```cpp
deleteLater();
```

---

# 5. Re-entrancy

One of the hardest Qt concepts.

Suppose:

```cpp
slotA()
```

Inside:

```cpp
QCoreApplication::processEvents();
```

Now another event arrives:

```text
slotA()

↓

processEvents()

↓

New Event

↓

slotA()

Again
```

Now:

```text
slotA()

↓

slotA()
```

The function is executing recursively.

This is called **re-entrancy**.

---

# Why Dangerous?

Example:

```cpp
if(processing)
    return;

processing = true;

// ...

QCoreApplication::processEvents();

// ...

processing = false;
```

Without proper guards, the function can be entered again before it finishes, leading to inconsistent state.

---

# 6. Timers & Event Loop

`QTimer`

does **not** create a thread.

Instead:

```text
Operating System Timer

↓

Event Dispatcher

↓

Event Queue

↓

QTimerEvent

↓

timeout()
```

If the event loop is blocked:

```text
Timer Stops
```

The timeout signal cannot be delivered until the event loop runs again.

---

# Example

```cpp
QTimer timer;

connect(&timer,
        &QTimer::timeout,
        []()
{
    qDebug() << "Tick";
});

timer.start(1000);
```

Flow:

```text
1 Second

↓

Timer Event

↓

Event Queue

↓

timeout()
```

---

# 7. Socket Notifiers

Networking also depends on the event loop.

Example:

```text
Socket Ready

↓

Operating System

↓

Event Dispatcher

↓

Socket Event

↓

QTcpSocket

↓

readyRead()
```

Without the event loop:

```text
readyRead()

Never Called
```

This is why asynchronous networking requires an active event loop.

---

# 8. Platform Event Dispatchers

Qt uses different dispatchers on different platforms.

```text
Windows

↓

Win32 Message Queue

↓

QEventDispatcherWin32
```

---

Linux (X11)

```text
X11

↓

XCB

↓

QEventDispatcher
```

---

Wayland

```text
Wayland

↓

Wayland Dispatcher
```

---

macOS

```text
Cocoa

↓

Native Event Loop
```

All platform-specific events are translated into platform-independent Qt events.

---

# 9. Performance Optimization

## Keep Event Handlers Short

Bad:

```cpp
mousePressEvent()
{
    calculateDose();
}
```

GUI freezes.

---

Better:

```text
Mouse Click

↓

Signal

↓

Worker Thread

↓

Dose Calculation

↓

Queued Signal

↓

GUI Update
```

---

## Avoid Busy Waiting

Wrong:

```cpp
while(!finished)
{
}
```

Correct:

```text
Signal

↓

Event Loop

↓

Slot
```

---

## Minimize processEvents()

Calling:

```cpp
QCoreApplication::processEvents();
```

too often can:

* reduce performance
* increase complexity
* introduce re-entrancy

Prefer redesigning long operations to use background threads.

---

# 10. Qt Source Code Concepts

Conceptually:

```text
exec()

↓

QEventLoop

↓

QAbstractEventDispatcher

↓

Wait Native Event

↓

Translate

↓

Notify

↓

QObject::event()

↓

Handler
```

Deferred deletion:

```text
deleteLater()

↓

DeferredDelete Event

↓

Queue

↓

Dispatcher

↓

QObject Destructor
```

Again, the actual implementation is more sophisticated and platform-dependent, but this illustrates the architecture.

---

# 11. Qt 5.15 vs Qt 6.11

| Feature            | Qt 5.15 | Qt 6.11 |
| ------------------ | ------- | ------- |
| Nested Event Loops | ✔       | ✔       |
| Event Compression  | ✔       | ✔       |
| DeferredDelete     | ✔       | ✔       |
| Timers             | ✔       | ✔       |
| Socket Integration | ✔       | ✔       |

There is **no major conceptual difference** between Qt 5.15 and Qt 6.11 for these mechanisms.

---

# 12. Best Practices

* Avoid nested event loops unless they are truly required (for example, modal dialogs).
* Never perform heavy work in the GUI thread.
* Prefer worker threads and queued signal-slot connections.
* Keep event handlers short and non-blocking.
* Use `deleteLater()` for `QObject` instances participating in the event loop.
* Avoid unnecessary calls to `processEvents()`.

---

# 13. Common Mistakes

❌ Calling `processEvents()` inside complex algorithms without understanding re-entrancy.

❌ Blocking the event loop with long computations.

❌ Assuming `QTimer` runs in its own thread.

❌ Ignoring event compression when debugging repaint behavior.

❌ Calling `delete this` from within event handlers when deferred deletion is more appropriate.

---

# 14. Interview Questions

## Easy

1. What is a nested event loop?
2. What does `deleteLater()` do?
3. Does `QTimer` create a thread?

---

## Medium

1. Explain event compression.
2. Why is `processEvents()` considered risky?
3. How does a socket become `readyRead()`?

---

## Hard

1. Describe event starvation.
2. Explain re-entrancy with an example.
3. How does Qt integrate with native operating system event loops?

---

## Expert

1. Design a responsive TPS GUI that performs long-running dose calculations without freezing.
2. Explain why modal dialogs create nested event loops and what risks this introduces.
3. Discuss how event compression improves rendering performance.

---

# 15. Event Loop Flow Diagram

```text
                Operating System
                       │
                       ▼
             Native Event Dispatcher
                       │
                       ▼
        QAbstractEventDispatcher
                       │
                       ▼
                 QEventLoop
                       │
            ┌──────────┼──────────┐
            ▼          ▼          ▼
      Event Queue   Timer     Socket
            │          │          │
            └──────────┼──────────┘
                       ▼
          QCoreApplication::notify()
                       │
                       ▼
               QObject::event()
                       │
                       ▼
          Specific Event Handler
```

---

# 16. Revision Notes

* The event loop is the heart of every Qt application.
* Modal dialogs create nested event loops.
* Event compression reduces unnecessary processing for certain event types.
* `deleteLater()` posts a deferred deletion event.
* `QTimer` and asynchronous networking rely on the event loop.
* Blocking the event loop freezes the application.
* `processEvents()` should be used with caution because it can introduce re-entrancy.

---

# 🏥 Production Example — Treatment Planning System

```text
User Clicks "Calculate Dose"
            │
            ▼
     GUI Event Loop
            │
            ▼
      Start Worker Thread
            │
            ▼
     Dose Calculation Engine
            │
            ▼
   Queued Signal Emitted
            │
            ▼
      GUI Event Queue
            │
            ▼
     Update DVH Graph
            │
            ▼
     Update 3D Dose View
            │
            ▼
     GUI Remains Responsive
```

This architecture is used in many professional desktop applications to keep the interface responsive while computationally intensive work executes in background threads.

---


# 🚀 Next Chapter

## **Chapter 29 — Event Dispatcher (Complete Deep Dive)**

N
