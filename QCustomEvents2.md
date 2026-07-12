Excellent. Now we're entering the **expert-level** part of Custom Events.

This chapter explains how Qt itself uses the event system internally and how you should design **high-performance, production-quality event-driven architectures**.

This knowledge is commonly used in:

* Medical Treatment Planning Systems (TPS)
* CAD software
* Automotive HMIs
* Embedded Linux systems
* Enterprise desktop applications
* IDEs such as Qt Creator

---

# Complete Qt Master Course (Qt 5.15 LTS → Qt 6.11)

# PART IV — Application Architecture

# Chapter 32 — Custom Events (Complete Deep Dive)

## Part 2 — Cross-Thread Events, Event Priorities, Memory Management, Performance & Enterprise Architecture

> **Level:** Advanced → Expert

---

# Chapter Objectives

After completing this chapter, you will understand:

* Cross-thread event delivery
* Memory ownership of posted events
* Event priorities
* Custom event architecture
* Performance optimization
* Qt source code concepts
* Enterprise design patterns
* Medical TPS usage

---

# Table of Contents

1. Cross-Thread Event Delivery
2. Memory Ownership
3. Event Priorities
4. Event Compression
5. Thread Safety
6. Enterprise Architecture
7. Qt Source Code Concepts
8. Qt 5 vs Qt 6
9. Best Practices
10. Interview Questions
11. Revision Notes

---

# 1. Cross-Thread Event Delivery

One of the biggest advantages of `postEvent()` is that it works naturally across threads.

Example architecture:

```text
+------------------------+
| GUI Thread             |
|------------------------|
| MainWindow             |
| DoseView               |
| DVHWidget              |
+-----------▲------------+
            │
       postEvent()
            │
+-----------▼------------+
| Worker Thread          |
|------------------------|
| Dose Engine            |
| Optimization Engine    |
+------------------------+
```

Example:

```cpp
QCoreApplication::postEvent(
    doseView,
    new DoseFinishedEvent(maxDose, patientId));
```

The event is placed into the **GUI thread's event queue**, because `doseView` belongs to the GUI thread.

The worker thread returns immediately and does **not** execute GUI code.

---

## Internal Flow

```text
Worker Thread

↓

Create Event

↓

Lock Receiver Queue

↓

Append Event

↓

Wake GUI Dispatcher

↓

GUI Thread

↓

Event Loop

↓

DoseView::event()
```

Qt handles the synchronization internally.

---

# 2. Memory Ownership

This is a common interview question.

## postEvent()

```cpp
QCoreApplication::postEvent(
    receiver,
    new MyEvent());
```

### Who owns the event?

After a successful `postEvent()` call:

```text
Qt Event Queue
        │
        ▼
Owns Event
```

You **must not** delete it yourself.

Qt destroys the event after it has been delivered (or discarded if appropriate).

---

## Wrong

```cpp
MyEvent *event = new MyEvent();

QCoreApplication::postEvent(receiver, event);

delete event;   // ❌ Wrong
```

This can lead to use-after-free errors.

---

## Correct

```cpp
QCoreApplication::postEvent(
    receiver,
    new MyEvent());
```

Qt manages the event lifetime.

---

## sendEvent()

Example:

```cpp
MyEvent event;

QCoreApplication::sendEvent(
    receiver,
    &event);
```

The caller owns the event because delivery is immediate.

Stack allocation is common here.

---

# 3. Event Priorities

`postEvent()` supports priorities.

Example:

```cpp
QCoreApplication::postEvent(
    receiver,
    new DoseFinishedEvent(),
    Qt::HighEventPriority);
```

Common priority values include:

```text
High Priority

Normal Priority

Low Priority
```

Conceptually:

```text
High
──────────────
Normal
──────────────
Low
```

Higher-priority events are processed before lower-priority events that are waiting in the queue.

---

## TPS Example

```text
Emergency Stop Event

↓

High Priority

-------------------

Dose Progress Update

↓

Normal Priority
```

Emergency actions should not wait behind routine updates.

---

# 4. Event Compression

By default, **custom events are not automatically compressed**.

Suppose:

```text
DoseProgress

1%

2%

3%

4%

5%

...
```

If every progress update becomes a posted event:

```text
Queue

↓

1

2

3

4

5

...
```

The queue can grow unnecessarily.

---

## Better Design

Instead of posting every update:

```text
Worker Thread

↓

Update Shared Progress

↓

Post One Refresh Event
```

When the GUI processes the refresh event, it reads the latest progress value.

This reduces queue growth.

---

# 5. Thread Safety

`postEvent()`

✔ Thread-safe.

Designed for communication between threads.

---

`sendEvent()`

Immediate delivery.

Should only be used when the receiver can safely process the event in the current execution context.

For GUI objects, direct cross-thread `sendEvent()` is **not appropriate** because GUI objects must only be accessed from the GUI thread.

---

# Safe Pattern

```text
Worker Thread

↓

postEvent()

↓

GUI Thread

↓

event()

↓

Update Widget
```

---

# Unsafe Pattern

```text
Worker Thread

↓

sendEvent()

↓

GUI Widget
```

This violates Qt's GUI thread rules.

---

# 6. Enterprise Architecture

A large Medical TPS might look like this:

```text
                 GUI Thread
+--------------------------------------+
| MainWindow                           |
| Dose Viewer                          |
| DVH                                  |
| Patient Browser                      |
+----------------▲---------------------+
                 │
        Custom Events
                 │
+----------------┼---------------------+
| Dose Engine Thread                  |
| Optimization Thread                 |
| DICOM Import Thread                 |
| Registration Thread                 |
+--------------------------------------+
```

Each worker posts events to the GUI.

No worker directly manipulates widgets.

---

# 7. Real Production Example

## DICOM Import

```text
Import Thread

↓

Read Files

↓

PatientLoadedEvent

↓

GUI Queue

↓

Patient Browser

↓

Refresh Tree
```

---

## Dose Engine

```text
Dose Thread

↓

DoseCalculatedEvent

↓

GUI Queue

↓

Dose View

↓

DVH

↓

3D Window
```

---

## Auto Save

```text
Timer Thread

↓

AutoSaveEvent

↓

Main Window

↓

Save Patient
```

(Alternatively, a queued signal-slot connection is also a common design choice.)

---

# 8. Qt Source Code Concepts

Conceptually:

```text
postEvent()

↓

Lock Queue

↓

Insert Event

↓

Wake Dispatcher

↓

Event Loop

↓

notify()

↓

Receiver::event()
```

Simplified conceptual implementation:

```cpp
postEvent(receiver, event)
{
    lock(receiverQueue);

    receiverQueue.push(event);

    unlock(receiverQueue);

    wakeDispatcher();
}
```

The real Qt implementation is more sophisticated, but the concept is similar.

---

# 9. Custom Events vs Signals/Slots

| Feature                          | Custom Events            | Signals/Slots                                                    |
| -------------------------------- | ------------------------ | ---------------------------------------------------------------- |
| Event Queue                      | Yes (with `postEvent()`) | Queued connections use an event queue; direct connections do not |
| Immediate Delivery               | Yes (`sendEvent()`)      | Yes (Direct Connection)                                          |
| Carries Arbitrary Event Object   | ✔                        | ✘ (uses typed function arguments)                                |
| Integrates with `event()`        | ✔                        | ✘                                                                |
| Best for Extending Event System  | ✔                        | ✘                                                                |
| Best for Component Communication | Sometimes                | Usually ✔                                                        |

### Recommendation

Use:

* **Signals & Slots** for most application communication.
* **Custom Events** when extending the event system or when an event-oriented design is more appropriate.

---

# 10. Performance Optimization

## Avoid Thousands of Events

Bad:

```text
10000 Progress Events
```

Better:

```text
Latest Progress Value

↓

Single Refresh Event
```

---

## Keep Events Small

Good:

```cpp
double dose;
int beamId;
```

Avoid embedding very large objects directly in an event unless there is a compelling reason.

---

## Avoid Heavy Processing

Bad:

```cpp
bool event(QEvent *event)
{
    calculateDose();   // 20 seconds
}
```

Instead:

```text
event()

↓

Start Worker

↓

Return
```

Keep event handlers responsive.

---

# 11. Qt 5.15 vs Qt 6.11

| Feature              | Qt 5.15 | Qt 6.11 |
| -------------------- | ------- | ------- |
| `postEvent()`        | ✔       | ✔       |
| `sendEvent()`        | ✔       | ✔       |
| Priorities           | ✔       | ✔       |
| Custom Events        | ✔       | ✔       |
| Cross-thread Posting | ✔       | ✔       |

There is **no major functional difference** for custom event architecture between Qt 5.15 and Qt 6.11.

---

# 12. Best Practices

✅ Prefer `postEvent()` for worker-to-GUI communication.

✅ Keep event objects lightweight.

✅ Use event priorities only when necessary.

✅ Do not manually delete events after posting them.

✅ Handle custom events quickly.

✅ Use signals and slots unless there is a clear reason to model the interaction as an event.

---

# 13. Common Mistakes

### ❌ Deleting posted events

```cpp
delete event;
```

Never do this after `postEvent()` succeeds.

---

### ❌ Large event payloads

Embedding huge image volumes or large datasets directly in an event object increases memory usage and copy costs.

Prefer passing lightweight identifiers or shared data structures when appropriate.

---

### ❌ Updating GUI directly from worker threads

Always communicate back to the GUI using:

* `postEvent()`
* Queued signal-slot connections
* Other thread-safe synchronization mechanisms

---

### ❌ Flooding the event queue

Posting thousands of low-value events can delay more important work.

Throttle or coalesce updates where appropriate.

---

# 14. Interview Questions

## Easy

1. Who owns a posted event?
2. Is `postEvent()` thread-safe?
3. What is event priority?

---

## Medium

1. Compare `postEvent()` and `sendEvent()`.
2. Explain event ownership.
3. Why shouldn't worker threads update GUI widgets directly?

---

## Hard

1. Design a custom event system for a Treatment Planning System.
2. Explain cross-thread event delivery.
3. Discuss event queue performance.

---

## Expert

1. Compare custom events with queued signal-slot connections for a large TPS architecture.
2. Design a high-performance event-driven communication framework for CAD software.
3. Explain how Qt wakes the GUI thread after a worker posts an event.

---

# 15. Complete Architecture Diagram

```text
              Worker Thread
                     │
                     ▼
        Create DoseFinishedEvent
                     │
                     ▼
      QCoreApplication::postEvent()
                     │
                     ▼
        Receiver's Event Queue
                     │
                     ▼
      Wake Event Dispatcher
                     │
                     ▼
           GUI Event Loop
                     │
                     ▼
     QCoreApplication::notify()
                     │
                     ▼
        DoseView::event()
                     │
                     ▼
         Update Dose Display
```

---

# 🏥 Production Example — Treatment Planning System

```text
Dose Engine Thread
        │
        ▼
Dose Calculation Complete
        │
        ▼
DoseCalculatedEvent
        │
        ▼
GUI Event Queue
        │
        ▼
Dose Viewer
        │
        ├── Update Dose Matrix
        ├── Refresh DVH
        ├── Refresh Isodose Lines
        ├── Refresh 3D Viewer
        └── Enable "Export RT Dose"
```

This keeps the computational engine completely independent from the GUI while ensuring all interface updates occur safely in the GUI thread.

---

# 16. Revision Notes

* `postEvent()` is thread-safe and asynchronous.
* Qt owns posted events after successful posting.
* `sendEvent()` is immediate and does not transfer ownership.
* Custom events are not automatically compressed.
* Use event priorities carefully.
* Keep event handlers short.
* Use custom events for event-driven architectures and signals/slots for most routine component communication.

---

# 🎯 Chapter 32 Complete

You now have a complete understanding of **Qt Custom Events**, including:

* Creating custom event classes
* Registering event types
* Posting and sending events
* Cross-thread event delivery
* Memory ownership
* Event priorities
* Performance optimization
* Enterprise design patterns
* Qt 5 → Qt 6 compatibility

At this point, you have mastered the **entire Qt Event System**, including:

* Event Loop
* Event Dispatcher
* Built-in Events
* Event Filters
* Custom Events

---

# 🚀 Next Chapter

## **Chapter 33 — Timers (Complete Deep Dive)**

