Excellent. This chapter marks the transition from **using Qt** to **understanding how Qt itself works internally**.

Most developers know:

```cpp
app.exec();
```

Very few know what actually waits for:

* Mouse clicks
* Keyboard events
* Timers
* Socket notifications
* Window messages

The answer is **QAbstractEventDispatcher**.

---

# Complete Qt Master Course (Qt 5.15 LTS → Qt 6.11)

# PART IV — Application Architecture

# Chapter 29 — Event Dispatcher (Complete Deep Dive)

## Part 1 — QAbstractEventDispatcher, Platform Integration & Native Message Loops

**Level:** Advanced → Expert

---

# Chapter Objectives

After completing this chapter, you will understand:

* What an Event Dispatcher is
* Why Qt needs it
* `QAbstractEventDispatcher`
* Native OS message loops
* Windows integration
* Linux/X11 integration
* Wayland integration
* macOS integration
* Event Dispatcher architecture
* Qt5 vs Qt6

---

# Table of Contents

1. Introduction
2. Why Event Dispatcher?
3. Architecture
4. QAbstractEventDispatcher
5. Native Message Loops
6. Platform Integration
7. Event Dispatcher Flow
8. Internal Responsibilities
9. Qt5 vs Qt6
10. Best Practices
11. Interview Questions
12. Revision Notes

---

# 1. Introduction

Every operating system has its own event system.

Windows

```text
WM_MOUSEMOVE

WM_PAINT

WM_SIZE

WM_TIMER
```

Linux (X11/XCB)

```text
XCB events
```

Wayland

```text
Wayland protocol events
```

macOS

```text
Cocoa / NSApplication events
```

Qt cannot expose four completely different APIs to application developers.

Instead, Qt introduces a common abstraction:

```text
QAbstractEventDispatcher
```

---

# 2. Why Event Dispatcher?

Imagine Qt without an event dispatcher.

```text
Windows

↓

WM_MOUSEMOVE

↓

???

↓

QMouseEvent
```

No translation layer.

Qt applications would need OS-specific code everywhere.

Instead:

```text
Operating System

↓

Event Dispatcher

↓

Qt Events

↓

QObject
```

Now your application works the same way on Windows, Linux, and macOS.

---

# 3. Overall Architecture

```text
                QApplication
                      │
                      ▼
                 QEventLoop
                      │
                      ▼
         QAbstractEventDispatcher
                      │
     ┌────────┬────────────┬─────────┐
     ▼        ▼            ▼         ▼
  Timers   Socket I/O   Native OS   Wake-up
                        Events
                      │
                      ▼
               QObject::event()
```

The dispatcher is the bridge between the operating system and Qt.

---

# 4. QAbstractEventDispatcher

Header

```cpp
#include <QAbstractEventDispatcher>
```

Module

```text
QtCore
```

Inheritance

```text
QObject
        │
        ▼
QAbstractEventDispatcher
```

It is an **abstract base class**.

Qt provides platform-specific implementations.

Examples include:

* Windows event dispatcher
* X11/XCB event dispatcher
* Wayland event dispatcher
* Cocoa event dispatcher

The exact class names are internal implementation details and may change across Qt versions.

---

# Responsibilities

The dispatcher is responsible for:

* Waiting for native events
* Delivering timer events
* Delivering socket notifier events
* Waking sleeping event loops
* Integrating platform event sources

---

# 5. Native Message Loops

## Windows

Windows already has a message loop.

Conceptually:

```text
GetMessage()

↓

TranslateMessage()

↓

DispatchMessage()
```

Qt integrates with this loop.

Flow:

```text
Windows

↓

WM_MOUSEMOVE

↓

Event Dispatcher

↓

QMouseEvent

↓

QObject
```

---

## Linux (X11/XCB)

```text
XCB Event

↓

Qt Dispatcher

↓

QMouseEvent
```

---

## Wayland

```text
Wayland Event

↓

Dispatcher

↓

Qt Event
```

---

## macOS

```text
Cocoa Event

↓

Dispatcher

↓

Qt Event
```

---

# Why Is This Important?

Because your Qt code remains identical.

Example:

```cpp
void MainWindow::mousePressEvent(QMouseEvent *event)
{
}
```

Works on:

* Windows
* Linux
* macOS

without modification.

---

# 6. Event Dispatcher Flow

Complete flow:

```text
Mouse Click

↓

Operating System

↓

Native Event Queue

↓

Event Dispatcher

↓

Qt Event

↓

notify()

↓

QObject::event()

↓

mousePressEvent()
```

Exactly the same concept applies to:

* Keyboard events
* Resize events
* Paint events
* Timer events
* Socket events

---

# 7. Waiting for Events

The dispatcher does not constantly poll the CPU.

Conceptually:

```text
Wait

↓

Nothing Happens

↓

Sleep

↓

Mouse Click

↓

Wake Up

↓

Process Event

↓

Sleep Again
```

This efficient waiting keeps idle CPU usage very low.

---

# 8. Timers

Timers are also managed through the dispatcher.

```cpp
QTimer timer;
```

Conceptually:

```text
Timer

↓

Dispatcher

↓

Timeout Event

↓

Event Queue

↓

QObject
```

The dispatcher monitors timer expiration and injects the appropriate event into Qt's event system.

---

# 9. Socket Events

Networking is integrated too.

```text
Socket Ready

↓

Operating System

↓

Dispatcher

↓

Socket Notifier

↓

QTcpSocket

↓

readyRead()
```

This is why asynchronous networking requires an active event loop.

---

# 10. Wake-up Mechanism

Suppose another thread posts an event:

```cpp
QCoreApplication::postEvent(receiver, event);
```

The GUI thread may currently be sleeping.

Conceptually:

```text
Worker Thread

↓

postEvent()

↓

Wake Dispatcher

↓

Dispatcher Wakes

↓

Processes Event
```

Without a wake-up mechanism, posted events could remain pending until some unrelated OS event occurred.

---

# 11. Internal Responsibilities

Conceptually, the dispatcher manages:

```text
Native Events

Timers

Socket Notifiers

Wake-ups

Posted Events

Deferred Delete Events
```

It does **not** perform application logic.

Its job is to move events into Qt's event processing pipeline.

---

# 12. Qt Source Code Concepts

Simplified conceptual flow:

```text
QEventLoop::exec()

↓

QAbstractEventDispatcher::processEvents()

↓

Wait Native Event

↓

Translate Event

↓

Notify Application

↓

QObject::event()
```

Real Qt source code contains additional optimizations, platform abstractions, and synchronization logic.

---

# 13. Qt 5.15 vs Qt 6.11

| Feature                  | Qt 5.15 | Qt 6.11 |
| ------------------------ | ------- | ------- |
| QAbstractEventDispatcher | ✔       | ✔       |
| Timer Integration        | ✔       | ✔       |
| Socket Integration       | ✔       | ✔       |
| Platform Dispatchers     | ✔       | ✔       |

There is **no major conceptual difference**.

Qt 6 modernizes internal implementations and platform support while preserving the public architecture.

---

# 14. Best Practices

* Never subclass the dispatcher unless you are implementing a specialized platform integration.
* Do not bypass Qt's event system with native APIs unless absolutely necessary.
* Prefer Qt abstractions (`QTimer`, `QTcpSocket`, etc.) over OS-specific APIs.
* Keep the event loop responsive so the dispatcher can continue processing events.

---

# 15. Common Mistakes

❌ Assuming the event dispatcher is the same as the event loop.

The dispatcher **feeds** events into the event loop; they are related but distinct components.

❌ Polling continuously instead of using event-driven APIs.

❌ Using blocking native APIs in the GUI thread.

❌ Ignoring the dependency of timers and sockets on the event dispatcher.

---

# 16. Interview Questions

## Easy

1. What is `QAbstractEventDispatcher`?
2. Why does Qt need an event dispatcher?
3. Does every platform use the same dispatcher implementation?

---

## Medium

1. Explain how native OS events become Qt events.
2. How are timers handled by the dispatcher?
3. Why do asynchronous sockets require the event dispatcher?

---

## Hard

1. Describe the relationship between `QEventLoop` and `QAbstractEventDispatcher`.
2. Explain the wake-up mechanism for posted events.
3. Why is an abstraction layer necessary for cross-platform GUI development?

---

## Expert

1. Explain the path of a Windows `WM_MOUSEMOVE` message until it reaches `mouseMoveEvent()`.
2. Design a custom embedded platform integration conceptually using an event dispatcher.
3. Compare native operating system message loops with Qt's event dispatching architecture.

---

# 17. Complete Architecture Diagram

```text
                 Operating System
        (Windows / Linux / macOS)
                     │
                     ▼
        Native Message Queue / Event Source
                     │
                     ▼
      QAbstractEventDispatcher
      ┌────────┬────────┬────────┐
      │        │        │        │
      ▼        ▼        ▼        ▼
   Timers   Sockets  Wake-up  Native Events
      │        │        │        │
      └────────┴────────┴────────┘
                     │
                     ▼
                QEventLoop
                     │
                     ▼
          QCoreApplication::notify()
                     │
                     ▼
              QObject::event()
                     │
                     ▼
        mousePressEvent(), timerEvent(),
        readyRead(), custom events...
```

---

# 18. Revision Notes

* `QAbstractEventDispatcher` is the bridge between Qt and the operating system.
* Every platform has its own dispatcher implementation.
* The dispatcher waits efficiently for native events.
* It integrates timers, sockets, wake-up signals, and platform events.
* It feeds events into the Qt event loop.
* Qt applications remain platform-independent because of this abstraction layer.

---

# 🏥 Production Example — Treatment Planning System

```text
Radiation TPS

User Moves Mouse
        │
        ▼
Windows Message Queue
        │
        ▼
Qt Event Dispatcher
        │
        ▼
QMouseEvent
        │
        ▼
Dose View Widget
        │
        ▼
Update Crosshair
        │
        ▼
Update Slice View
        │
        ▼
Update DVH Cursor
        │
        ▼
Repaint Viewer
```

The application code never interacts directly with platform-specific messages, allowing the same TPS application to run on Windows, Linux, or other supported platforms.

---

# 🎯 Chapter 29 — Part 1 Complete

You now understand:

* What the Event Dispatcher is
* Why it exists
* `QAbstractEventDispatcher`
* Native message loops
* Platform integration
* Timer and socket integration
* Wake-up mechanism
* Internal architecture
* Qt 5 → Qt 6 behavior

---
Excellent. Now we're entering **Qt internals territory**.

This is knowledge typically expected from:

* Senior Qt Developers
* Qt Framework Engineers
* Medical Software Architects
* CAD Software Engineers
* Developers who debug Qt source code
* Developers working with platform plugins or embedded systems

Most application developers never need to subclass or replace an event dispatcher. However, understanding how it works helps explain many subtle behaviors in Qt applications.

---

# Complete Qt Master Course (Qt 5.15 LTS → Qt 6.11)

# PART IV — Application Architecture

# Chapter 29 — Event Dispatcher (Complete Deep Dive)

## Part 2 — `processEvents()`, Native Event Filters, Thread Dispatchers, Timer Registration & Performance

> **Level:** Advanced → Expert

---

# Chapter Objectives

After completing this chapter, you will understand:

* `QAbstractEventDispatcher::processEvents()`
* Event processing flags
* Thread-specific dispatchers
* Timer registration
* Socket notifier registration
* Native event filters
* Idle processing
* Performance optimization
* Debugging event dispatcher issues

---

# Table of Contents

1. `processEvents()` Internals
2. Event Processing Flags
3. Thread-specific Event Dispatchers
4. Timer Registration
5. Socket Notifier Registration
6. Native Event Filters
7. Idle Processing
8. Custom Event Dispatchers
9. Performance Considerations
10. Qt 5 vs Qt 6
11. Best Practices
12. Interview Questions
13. Revision Notes

---

# 1. `processEvents()` Internals

Earlier we learned:

```cpp
QCoreApplication::processEvents();
```

Internally, this relies on the current thread's event dispatcher to process eligible events.

Conceptually:

```text
processEvents()

↓

Current Thread Event Dispatcher

↓

Check Event Queue

↓

Dispatch Available Events

↓

Return
```

It does **not** create a new event loop.

It simply processes pending events according to the supplied flags.

---

## Typical Flow

```text
Application Code

↓

processEvents()

↓

QEventLoop

↓

QAbstractEventDispatcher

↓

Dispatch Pending Events

↓

Return To Caller
```

---

# 2. Event Processing Flags

Qt allows callers to control which events are processed.

Common examples include:

```cpp
QEventLoop::AllEvents
QEventLoop::ExcludeUserInputEvents
QEventLoop::ExcludeSocketNotifiers
QEventLoop::WaitForMoreEvents
```

Example:

```cpp
QCoreApplication::processEvents(
    QEventLoop::ExcludeUserInputEvents);
```

Conceptually:

```text
Mouse Events

×

Ignored

-------------------

Timers

✓

Processed

-------------------

Posted Events

✓

Processed
```

This selective processing can be useful in specialized situations, but it should be used carefully.

---

# 3. Thread-specific Event Dispatchers

Every thread **that runs a Qt event loop** has its own event dispatcher.

Conceptually:

```text
GUI Thread

↓

Dispatcher A

-------------------

Worker Thread

↓

Dispatcher B

-------------------

Network Thread

↓

Dispatcher C
```

Each dispatcher manages events for **its own thread**.

---

## Example

```text
GUI Thread

↓

Mouse Events

↓

GUI Dispatcher

-------------------

Worker Thread

↓

Timers

↓

Worker Dispatcher
```

Events never "float" between dispatchers automatically.

Cross-thread communication typically uses queued signal-slot connections or posted events.

---

# 4. Timer Registration

When you start a timer:

```cpp
timer.start(1000);
```

Conceptually:

```text
QTimer

↓

Current Thread Dispatcher

↓

Register Timer

↓

Operating System Timer

↓

Timeout Event

↓

Event Queue

↓

timeout()
```

The dispatcher keeps track of active timers for its thread.

---

## Multiple Timers

```text
Dispatcher

↓

Timer #1

Timer #2

Timer #3

Timer #4
```

As timers expire, timeout events are generated and delivered.

---

# 5. Socket Notifier Registration

Example:

```cpp
QTcpSocket socket;
```

Internally, Qt registers interest in socket readiness with the current thread's dispatcher.

Conceptually:

```text
QTcpSocket

↓

Dispatcher

↓

Operating System

↓

Socket Ready

↓

Dispatcher

↓

readyRead()
```

Again, this is why asynchronous networking requires an active event loop.

---

# 6. Native Event Filters

Sometimes you need access to **native operating system events** before Qt translates them.

Qt provides native event filters.

Conceptually:

```text
Operating System Event

↓

Native Event Filter

↓

Qt Translation

↓

QObject Event
```

Typical uses:

* Platform-specific integrations
* Low-level input processing
* Custom message handling
* Specialized embedded applications

---

## Example Flow (Windows)

```text
WM_INPUT

↓

Native Event Filter

↓

Application Code

↓

Qt Event Translation

↓

QMouseEvent
```

If your filter consumes the native event, Qt may not perform its usual translation.

---

# 7. Idle Processing

Suppose:

```text
No Mouse

No Keyboard

No Timers

No Network
```

Dispatcher:

```text
Wait

↓

Sleep
```

CPU usage remains low.

When something happens:

```text
Mouse Click

↓

Wake Up

↓

Dispatch Event

↓

Sleep Again
```

Efficient idle waiting is one reason Qt applications scale well.

---

# 8. Custom Event Dispatchers

This is a very advanced topic.

Qt allows specialized platforms to provide their own dispatcher implementations.

Typical scenarios:

* Embedded operating systems
* Custom hardware platforms
* Specialized real-time environments

Most application developers **never** implement a custom dispatcher.

Instead, they rely on the dispatcher supplied by Qt's platform plugin.

---

# 9. Performance Considerations

## Good

```text
Wait For Event

↓

Process

↓

Wait Again
```

Minimal CPU usage.

---

## Bad

Busy polling:

```cpp
while (true)
{
    checkSomething();
}
```

Results:

```text
100% CPU

↓

Battery Drain

↓

Poor Performance
```

Prefer:

```text
Operating System Event

↓

Dispatcher

↓

Your Slot
```

---

## Too Many Timers

Creating thousands of short-interval timers can increase dispatcher overhead.

Instead:

* Consolidate timers when practical.
* Reuse timers where appropriate.

---

## Long-running Event Handlers

Avoid:

```cpp
void mousePressEvent(...)
{
    calculateDose(); // 20 seconds
}
```

Better:

```text
Mouse Event

↓

Worker Thread

↓

Queued Signal

↓

GUI Update
```

---

# 10. Qt Source Code Concepts

Conceptually:

```text
QCoreApplication::exec()

↓

QEventLoop

↓

Dispatcher

↓

processEvents()

↓

Translate Native Events

↓

Deliver Qt Events
```

Thread view:

```text
GUI Thread

↓

Dispatcher

↓

GUI Events

--------------------

Worker Thread

↓

Dispatcher

↓

Worker Events
```

Remember that the exact implementation is platform-specific.

---

# 11. Qt 5.15 vs Qt 6.11

| Feature              | Qt 5.15 | Qt 6.11 |
| -------------------- | ------- | ------- |
| `processEvents()`    | ✔       | ✔       |
| Thread Dispatchers   | ✔       | ✔       |
| Native Event Filters | ✔       | ✔       |
| Timer Registration   | ✔       | ✔       |
| Socket Registration  | ✔       | ✔       |

There is **no major conceptual difference** between Qt 5.15 and Qt 6.11.

Qt 6 includes internal modernization and platform improvements while maintaining the same programming model.

---

# 12. Best Practices

* Avoid excessive calls to `processEvents()`.
* Use worker threads for long-running tasks.
* Keep event handlers short.
* Use native event filters only when Qt's cross-platform APIs are insufficient.
* Minimize the number of active timers where practical.
* Rely on event-driven programming rather than polling.

---

# 13. Common Mistakes

❌ Assuming all threads share one dispatcher.

Each event-loop thread has its own dispatcher.

---

❌ Polling continuously instead of using events.

---

❌ Registering unnecessary high-frequency timers.

---

❌ Using native event filters for logic that Qt already exposes through portable APIs.

---

❌ Blocking the dispatcher with expensive computations.

---

# 14. Interview Questions

## Easy

1. What does `processEvents()` do?
2. Does every thread have its own dispatcher?
3. Why do timers need the dispatcher?

---

## Medium

1. Explain native event filters.
2. How are socket notifications delivered?
3. What is idle processing?

---

## Hard

1. Describe thread-specific event dispatchers.
2. Explain timer registration conceptually.
3. Why is polling discouraged in Qt applications?

---

## Expert

1. Design an event-driven architecture for a multi-threaded Treatment Planning System.
2. Explain how native events become Qt events.
3. Discuss the performance implications of many timers and frequent `processEvents()` calls.

---

# 15. Architecture Summary

```text
                 Operating System
                        │
                        ▼
              Platform Plugin
                        │
                        ▼
          QAbstractEventDispatcher
        ┌────────┬─────────┬──────────┐
        │        │         │          │
        ▼        ▼         ▼          ▼
     Timers   Sockets   Native     Wake-up
                        Events
        │        │         │
        └────────┴─────────┘
                 │
                 ▼
            QEventLoop
                 │
                 ▼
     QCoreApplication::notify()
                 │
                 ▼
          QObject::event()
                 │
                 ▼
      Your Event Handlers / Slots
```

---

# 16. Revision Notes

* Every event-loop thread has its own event dispatcher.
* The dispatcher waits efficiently for native events.
* Timers and asynchronous sockets depend on the dispatcher.
* Native event filters allow platform-specific processing before Qt translates events.
* `processEvents()` delegates to the current thread's event dispatcher.
* Custom event dispatchers are primarily used by Qt itself and specialized platforms.
* Event-driven programming is preferred over polling for responsiveness and efficiency.

---

# 🏥 Production Example — Treatment Planning System

```text
GUI Thread
    │
    ▼
Event Dispatcher
    │
    ├── Mouse Events
    ├── Keyboard Events
    ├── Timer Events
    ├── Paint Events
    └── Queued GUI Updates
           │
           ▼
      Main Window

Worker Thread
    │
    ▼
Own Event Dispatcher (if an event loop is running)
    │
    ├── Timer Events
    ├── Network Events
    └── Posted Worker Events
           │
           ▼
    Dose Calculation Engine
```

The GUI thread remains responsive because heavy computation stays in worker threads, while each thread processes only the events intended for it.

---

# 🎯 Chapter 29 Complete

You now understand:

* `QAbstractEventDispatcher`
* `processEvents()` internals
* Thread-specific dispatchers
* Timer registration
* Socket notifier registration
* Native event filters
* Idle processing
* Performance considerations
* Qt 5 → Qt 6 behavior

At this point, you have a solid understanding of how Qt receives and dispatches events from the operating system.

---

# 🚀 Next Chapter

## **Chapter 30 — Events (Complete Deep Dive)**

This is one of the largest and most practical chapters in the course.

We'll study the Qt event system in depth, including:

* `QEvent`
* Event types
* `QObject::event()`
* Mouse events
* Keyboard events
* Focus events
* Paint events
* Resize events
* Move events
* Close events
* Show/Hide events
* Drag & Drop events
* Touch and gesture events
* Tablet events
* Wheel events
* Custom events
* Event propagation
* Event acceptance and ignoring
* Event filters
* Qt source code concepts
* Qt 5.15 vs Qt 6.11 differences

This chapter is essential because **every interaction in a Qt application is represented as an event**. Understanding it is the key to mastering event handling, custom widgets, and advanced GUI programming.
