Excellent. This chapter is where you move from **using Qt's event system** to **extending Qt's event system**.

Many enterprise Qt applications—including **Qt Creator, Qt Designer, Autodesk products, Medical TPS systems, Automotive HMIs, and CAD software**—use custom events internally.

For example:

* Dose calculation completed
* DICOM import finished
* Beam optimization completed
* Patient loaded
* CAD model regenerated
* CAN frame processed
* PLC status updated

These are **application-specific events**, so Qt provides **Custom Events**.

---

# Complete Qt Master Course (Qt 5.15 LTS → Qt 6.11)

# PART IV — Application Architecture

# Chapter 32 — Custom Events (Complete Deep Dive)

## Part 1 — Introduction, Custom QEvent, registerEventType(), postEvent() & sendEvent()

**Level:** Intermediate → Expert

---

# Chapter Objectives

After this chapter, you will understand:

* What Custom Events are
* Why use them
* How to create custom event classes
* `QEvent::registerEventType()`
* `postEvent()`
* `sendEvent()`
* Event delivery
* Thread-safe event communication
* Qt 5 vs Qt 6

---

# Table of Contents

1. What are Custom Events?
2. Why Custom Events?
3. Creating a Custom Event
4. Registering Event Types
5. Sending Custom Events
6. Receiving Custom Events
7. `postEvent()` vs `sendEvent()`
8. Event Flow
9. Qt 5 vs Qt 6
10. Best Practices
11. Interview Questions
12. Revision Notes

---

# 1. What are Custom Events?

Qt already provides many built-in events:

```text
QMouseEvent
QKeyEvent
QPaintEvent
QResizeEvent
QWheelEvent
QCloseEvent
```

But your application may need events such as:

```text
DoseCalculated

PatientLoaded

DicomImported

BeamOptimized

CanFrameReceived

AlarmTriggered
```

Qt does not know about these, so you define your own event types.

---

# 2. Why Custom Events?

Imagine a Treatment Planning System.

```text
Dose Engine Thread

↓

Dose Finished

↓

???

↓

GUI Updates
```

You could call GUI methods directly, but that tightly couples components.

Instead:

```text
Dose Engine

↓

DoseFinishedEvent

↓

GUI Event Queue

↓

GUI Updates
```

This keeps components loosely coupled and integrates naturally with Qt's event loop.

---

# 3. Creating a Custom Event

First, define a unique event type.

```cpp
class DoseFinishedEvent : public QEvent
{
public:
    static const QEvent::Type Type;

    DoseFinishedEvent()
        : QEvent(Type)
    {
    }
};

const QEvent::Type DoseFinishedEvent::Type =
    static_cast<QEvent::Type>(QEvent::registerEventType());
```

Why `registerEventType()`?

* Ensures uniqueness.
* Avoids collisions with built-in and third-party event types.
* Recommended over manually choosing numeric values.

---

# Adding Custom Data

Events usually carry data.

Example:

```cpp
class DoseFinishedEvent : public QEvent
{
public:
    static const QEvent::Type Type;

    DoseFinishedEvent(double maxDose,
                      QString patientId)
        : QEvent(Type),
          m_maxDose(maxDose),
          m_patientId(std::move(patientId))
    {
    }

    double maxDose() const
    {
        return m_maxDose;
    }

    const QString& patientId() const
    {
        return m_patientId;
    }

private:
    double m_maxDose;
    QString m_patientId;
};
```

Now the event transports meaningful information.

---

# 4. Registering Event Types

Qt reserves many values in `QEvent::Type`.

Never do:

```cpp
QEvent::Type(1001)
```

Although it may work today, it risks conflicts.

Correct approach:

```cpp
QEvent::registerEventType();
```

Internally:

```text
Qt Event Registry

↓

Allocate New ID

↓

Return Unique Type
```

---

# 5. Sending Custom Events

## Using postEvent()

```cpp
QCoreApplication::postEvent(
    receiver,
    new DoseFinishedEvent(74.5, "P001"));
```

Flow:

```text
Create Event

↓

Event Queue

↓

Event Loop

↓

Receiver
```

Asynchronous.

---

## Using sendEvent()

```cpp
DoseFinishedEvent event(74.5, "P001");

QCoreApplication::sendEvent(receiver, &event);
```

Flow:

```text
Create Event

↓

Receiver

↓

Return
```

Synchronous.

---

# 6. Receiving Custom Events

Override `event()`.

```cpp
bool DoseView::event(QEvent *event)
{
    if (event->type() == DoseFinishedEvent::Type)
    {
        auto *doseEvent =
            static_cast<DoseFinishedEvent *>(event);

        updateDoseDisplay(
            doseEvent->maxDose());

        return true;
    }

    return QWidget::event(event);
}
```

Always forward unhandled events to the base implementation.

---

# 7. postEvent() vs sendEvent()

| Feature         | postEvent()     | sendEvent()                                                     |
| --------------- | --------------- | --------------------------------------------------------------- |
| Delivery        | Later           | Immediate                                                       |
| Event Queue     | Yes             | No                                                              |
| Thread Friendly | Yes             | Limited to immediate delivery in the current processing context |
| Asynchronous    | Yes             | No                                                              |
| Typical Use     | Background work | Immediate notification                                          |

**Recommendation:**

* Prefer `postEvent()` when integrating with the event loop.
* Use `sendEvent()` only when immediate processing is required and you understand the implications.

---

# 8. Event Flow

```text
Worker Thread

↓

DoseFinishedEvent

↓

postEvent()

↓

GUI Event Queue

↓

QCoreApplication::notify()

↓

DoseView::event()

↓

Update GUI
```

This is a common pattern for background processing.

---

# 9. Qt 5 vs Qt 6

| Feature             | Qt 5.15 | Qt 6.11 |
| ------------------- | ------- | ------- |
| Custom QEvent       | ✔       | ✔       |
| registerEventType() | ✔       | ✔       |
| postEvent()         | ✔       | ✔       |
| sendEvent()         | ✔       | ✔       |

There is **no functional difference** between Qt 5.15 and Qt 6.11 for custom events.

---

# 10. Best Practices

✅ Use `QEvent::registerEventType()`.

✅ Keep custom events focused on a single purpose.

✅ Include only the data needed by the receiver.

✅ Prefer `postEvent()` for asynchronous workflows.

✅ Handle custom events in `event()` and delegate unknown events to the base class.

---

# 11. Common Mistakes

### ❌ Hard-coded event IDs

```cpp
QEvent::Type(1001)
```

Use `registerEventType()` instead.

---

### ❌ Forgetting to call the base implementation

```cpp
return QWidget::event(event);
```

for events you don't handle.

---

### ❌ Storing raw pointers to short-lived objects inside events

If an event outlives the pointed-to object, you'll have dangling pointers.

Prefer value types or clearly owned/shared data where appropriate.

---

# 12. Interview Questions

## Easy

1. What is a custom event?
2. Why use `QEvent::registerEventType()`?
3. What is `postEvent()`?

---

## Medium

1. Compare `postEvent()` and `sendEvent()`.
2. How do you receive a custom event?
3. How do you attach custom data to an event?

---

## Hard

1. Explain the lifecycle of a custom event.
2. Why is `event()` overridden instead of `mousePressEvent()`?
3. Discuss ownership and lifetime considerations for posted events.

---

## Expert

1. Design a custom event system for a Treatment Planning System.
2. Explain how custom events enable loose coupling between application components.
3. Compare custom events with queued signal-slot connections for cross-component communication.

---

# 13. Architecture Diagram

```text
Dose Engine Thread
        │
        ▼
Create DoseFinishedEvent
        │
        ▼
QCoreApplication::postEvent()
        │
        ▼
GUI Event Queue
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
Dose Engine
      │
      ▼
Calculate Dose
      │
      ▼
DoseFinishedEvent
      │
      ▼
GUI Thread
      │
      ▼
Update DVH
      │
      ▼
Update Dose Matrix
      │
      ▼
Update 3D Viewer
      │
      ▼
Refresh Screen
```

This allows the computational engine to notify the GUI without directly calling GUI methods.

---

# 14. Revision Notes

* Custom events extend Qt's event system.
* Derive from `QEvent`.
* Register event types with `QEvent::registerEventType()`.
* Override `event()` to handle custom events.
* Use `postEvent()` for asynchronous delivery.
* Use `sendEvent()` for immediate delivery when appropriate.
* Custom events help build loosely coupled, event-driven architectures.

---

tion will show how custom events are used in large-scale, production-quality Qt systems.
