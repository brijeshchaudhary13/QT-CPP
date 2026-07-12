Excellent. **Chapter 34 is one of the most important chapters in the entire Qt framework.**

If you misunderstand **Thread Affinity**, you will eventually encounter errors like:

```text
QObject::setParent:
Cannot set parent, new parent is in a different thread
```

or

```text
QObject::moveToThread:
Current thread is not the object's thread.
```

or random crashes caused by accessing `QObject` instances from the wrong thread.

Many Qt interview questions revolve around this topic.

---

# Complete Qt Master Course (Qt 5.15 LTS → Qt 6.11)

# PART IV — Application Architecture

# Chapter 34 — Thread Affinity (Complete Deep Dive)

## Part 1 — QObject Thread Affinity, moveToThread(), Object Ownership & Event Delivery

> **Level:** Intermediate → Expert

---

# Chapter Objectives

After completing this chapter, you will understand:

* What Thread Affinity is
* Why Qt has Thread Affinity
* `QObject::thread()`
* `QObject::moveToThread()`
* Object ownership
* Parent-child restrictions
* Event delivery
* Timers and thread affinity
* Qt 5 vs Qt 6

---

# Table of Contents

1. What is Thread Affinity?
2. Why Thread Affinity Exists
3. QObject and Threads
4. QObject::thread()
5. QObject::moveToThread()
6. Parent-Child Rules
7. Event Delivery
8. Timer Affinity
9. Qt5 vs Qt6
10. Best Practices
11. Interview Questions
12. Revision Notes

---

# 1. What is Thread Affinity?

Every `QObject` belongs to exactly one thread.

That relationship is called **Thread Affinity**.

Example:

```text
GUI Thread

↓

MainWindow

↓

QPushButton

↓

QLabel
```

All these objects belong to the GUI thread.

---

Worker Thread

```text
Worker Thread

↓

DoseEngine

↓

NetworkManager

↓

Parser
```

These objects belong to the worker thread.

---

## Important

A `QObject` **executes its event handlers and queued slots in the thread it belongs to**, provided that thread has a running event loop.

Thread affinity is **not** the thread that currently has a pointer to the object.

---

# 2. Why Thread Affinity Exists

Suppose two threads simultaneously modify a widget.

```text
GUI Thread

↓

Change Text

------------

Worker Thread

↓

Change Text
```

Result:

```text
Race Condition

↓

Crash

↓

Undefined Behavior
```

Qt prevents this by assigning every `QObject` to one owning thread.

---

# 3. QObject and Threads

Example:

```cpp
QObject *object = new QObject;
```

Which thread owns it?

Answer:

The thread that executes the constructor.

Example:

```cpp
int main(...)
{
    QObject obj;
}
```

Affinity:

```text
Main Thread
```

---

Worker example:

```cpp
void Worker::run()
{
    QObject obj;
}
```

Affinity:

```text
Worker Thread
```

---

# 4. QObject::thread()

Qt allows checking an object's affinity.

Example:

```cpp
QObject *object = new QObject;

QThread *owner = object->thread();
```

Returns:

```text
Owning Thread
```

Useful for debugging:

```cpp
qDebug() << object->thread();
qDebug() << QThread::currentThread();
```

If these differ, you're executing code in a different thread than the object's affinity.

---

# 5. QObject::moveToThread()

Move an object to another thread.

Example:

```cpp
QThread *workerThread = new QThread;

Worker *worker = new Worker;

worker->moveToThread(workerThread);

workerThread->start();
```

Architecture:

```text
Initially

GUI Thread

↓

Worker Object

----------------

moveToThread()

↓

Worker Thread

↓

Worker Object
```

---

## Important

`moveToThread()` changes **thread affinity**, not where the object was allocated in memory.

Memory stays where it was allocated by the allocator.

Only event delivery and queued slot execution move to the new thread.

---

# 6. Parent-Child Rules

One of the most common mistakes.

Suppose:

```text
GUI Thread

↓

MainWindow
```

Worker Thread

↓

Worker

Attempt:

```cpp
worker->setParent(mainWindow);
```

Result:

```text
Error

↓

Different Threads
```

Qt requires parent and child `QObject`s to have the same thread affinity.

---

## Another Example

Wrong:

```cpp
Worker *worker = new Worker(parentWidget);
worker->moveToThread(thread);
```

Because:

```text
Parent

↓

GUI Thread

Child

↓

Worker Thread
```

This violates Qt's ownership model.

---

## Correct

```cpp
Worker *worker = new Worker;

worker->moveToThread(thread);
```

No parent.

Manage lifetime separately (for example, with `QObject::deleteLater()` when appropriate).

---

# 7. Event Delivery

Suppose:

```text
GUI Thread

↓

Button
```

Worker Thread

↓

Parser

Button receives:

```text
Mouse Event
```

Parser receives:

```text
Custom Event
```

Each object's events are processed by the event loop of its own thread.

---

Flow:

```text
Event

↓

Object's Thread

↓

Event Loop

↓

QObject::event()
```

---

# 8. Timer Affinity

Timers follow the thread affinity of their owning `QObject`.

Example:

```cpp
Worker worker;

QTimer timer;
```

If both belong to the GUI thread:

```text
GUI Thread

↓

Timer

↓

timeout()
```

After moving the worker:

```cpp
worker.moveToThread(thread);
```

A `QTimer` that is a child of `worker` (or created in the worker's thread) will also operate according to that thread's event loop.

The thread must have a running event loop.

---

# 9. Thread Affinity Diagram

```text
                GUI Thread
+--------------------------------+
| MainWindow                     |
| QPushButton                    |
| QLabel                         |
+--------------------------------+

                Worker Thread
+--------------------------------+
| Dose Engine                    |
| DICOM Importer                 |
| Registration Engine            |
+--------------------------------+
```

Each object processes events in its own thread.

---

# 10. Qt 5.15 vs Qt 6.11

| Feature          | Qt 5.15 | Qt 6.11 |
| ---------------- | ------- | ------- |
| Thread Affinity  | ✔       | ✔       |
| `moveToThread()` | ✔       | ✔       |
| `thread()`       | ✔       | ✔       |
| Parent Rules     | ✔       | ✔       |

The thread affinity model is unchanged.

---

# 11. Best Practices

✅ Keep all GUI objects in the GUI thread.

✅ Move worker objects—not GUI widgets—to worker threads.

✅ Check `QObject::thread()` when debugging.

✅ Avoid assigning parents across threads.

✅ Use `deleteLater()` when deleting `QObject`s from another thread.

---

# 12. Common Mistakes

### ❌ Moving a widget

```cpp
button->moveToThread(thread);
```

GUI widgets must remain in the GUI thread.

---

### ❌ Cross-thread parenting

```cpp
worker->setParent(window);
```

Invalid if they belong to different threads.

---

### ❌ Assuming `moveToThread()` moves memory

It only changes thread affinity.

---

### ❌ Accessing GUI objects directly from worker threads

Instead, use:

* Queued signal-slot connections
* `postEvent()`
* `QMetaObject::invokeMethod()` with an appropriate queued connection when needed

---

# 13. Interview Questions

## Easy

1. What is thread affinity?
2. What does `QObject::thread()` return?
3. What does `moveToThread()` do?

---

## Medium

1. Why can't a widget be moved to a worker thread?
2. Explain parent-child restrictions.
3. How does thread affinity affect event delivery?

---

## Hard

1. Explain how timers relate to thread affinity.
2. Design a worker object using `moveToThread()`.
3. Compare memory location and thread affinity.

---

## Expert

1. Design a multi-threaded architecture for a Treatment Planning System using worker objects.
2. Explain why `QObject` ownership is tied to thread affinity.
3. Describe the lifecycle of a queued event delivered to an object in another thread.

---

# 14. Architecture Diagram

```text
                GUI Thread
                     │
                     ▼
              MainWindow
                     │
                     ▼
              QPushButton
                     │
             Mouse Events
                     │
────────────────────────────────────────
                     │
             Worker Thread
                     ▼
              Dose Engine
                     │
               QTimer
                     │
             Custom Events
```

The GUI thread remains responsible for user interaction, while computational work executes in worker threads.

---

# 🏥 Production Example — Treatment Planning System

```text
GUI Thread
     │
     ├── Main Window
     ├── Dose Viewer
     ├── DVH Widget
     └── Patient Browser

Worker Thread
     │
     ├── Dose Engine
     ├── Monte Carlo Solver
     ├── DICOM Importer
     └── Registration Engine
```

Communication:

```text
Worker Thread

↓

Queued Signal / postEvent()

↓

GUI Thread

↓

Update Widgets
```

No worker thread directly manipulates GUI controls.

---

# 15. Revision Notes

* Every `QObject` has thread affinity.
* `QObject::thread()` returns the owning thread.
* `moveToThread()` changes thread affinity, not memory location.
* Parent and child objects must belong to the same thread.
* Events are processed in the object's owning thread.
* Timers depend on the event loop of the thread they belong to.
* GUI widgets must always remain in the GUI thread.

---

# 🎯 Chapter 34 — Part 1 Complete

You now understand:

* Thread affinity
* `QObject::thread()`
* `QObject::moveToThread()`
* Parent-child restrictions
* Event delivery
* Timer affinity
* Qt 5 → Qt 6 behavior

This foundation is essential before learning queued signal-slot connections, worker-object patterns, and advanced multi-threaded application architecture.

---

Excellent. This is one of the **most important chapters for professional Qt developers**.

Most threading bugs in Qt are **not caused by `QThread` itself**, but by misunderstanding:

* Signal-slot connection types
* Event delivery
* `moveToThread()`
* `deleteLater()`
* Object lifetime

If you understand this chapter, you'll be able to build stable, responsive, and thread-safe Qt applications.

---

# Complete Qt Master Course (Qt 5.15 LTS → Qt 6.11)

# PART IV — Application Architecture

# Chapter 34 — Thread Affinity (Complete Deep Dive)

## Part 2 — Connection Types, Worker Object Pattern, `deleteLater()`, `invokeMethod()` & Thread Cleanup

> **Level:** Advanced → Expert

---

# Chapter Objectives

After this chapter, you will understand:

* Signal-slot connection types
* `Qt::AutoConnection`
* `Qt::DirectConnection`
* `Qt::QueuedConnection`
* `Qt::BlockingQueuedConnection`
* `QMetaObject::invokeMethod()`
* Worker Object Pattern
* `deleteLater()`
* Safe thread shutdown
* Qt 5 vs Qt 6

---

# Table of Contents

1. Connection Types
2. AutoConnection
3. DirectConnection
4. QueuedConnection
5. BlockingQueuedConnection
6. `QMetaObject::invokeMethod()`
7. Worker Object Pattern
8. `deleteLater()`
9. Thread Shutdown
10. Qt5 vs Qt6
11. Best Practices
12. Interview Questions
13. Revision Notes

---

# 1. Connection Types

When connecting a signal and a slot:

```cpp
connect(sender,
        &Sender::finished,
        receiver,
        &Receiver::update);
```

Qt must decide:

> **How should the slot be executed?**

That is determined by the **connection type**.

Qt provides:

```text
Qt::AutoConnection
Qt::DirectConnection
Qt::QueuedConnection
Qt::BlockingQueuedConnection
Qt::UniqueConnection
Qt::SingleShotConnection (Qt 6)
```

---

# 2. Qt::AutoConnection

This is the default.

```cpp
connect(sender,
        &Sender::finished,
        receiver,
        &Receiver::update,
        Qt::AutoConnection);
```

### Behavior

If sender and receiver belong to the **same thread**:

```text
Signal
   │
   ▼
Slot Called Immediately
```

If sender and receiver belong to **different threads**:

```text
Signal
   │
   ▼
Event Queue
   │
   ▼
Receiver Thread
   │
   ▼
Slot Executes
```

Qt automatically chooses between **Direct** and **Queued**.

---

# AutoConnection Decision Table

| Sender Thread | Receiver Thread | Connection Used |
| ------------- | --------------- | --------------- |
| Same          | Same            | Direct          |
| Different     | Different       | Queued          |

This is why `Qt::AutoConnection` is usually the recommended choice.

---

# 3. Qt::DirectConnection

```cpp
connect(sender,
        &Sender::finished,
        receiver,
        &Receiver::update,
        Qt::DirectConnection);
```

Execution:

```text
emit signal()

↓

Immediately Call Slot

↓

Return
```

The slot executes **in the thread that emits the signal**, not necessarily the receiver's affinity thread.

### Important

If sender and receiver are in different threads, a direct connection can execute receiver code in the wrong thread.

For GUI objects, this is unsafe.

---

# Example

```text
Worker Thread

↓

emit finished()

↓

MainWindow Slot

↓

GUI Access
```

This is incorrect if the slot updates widgets.

---

# 4. Qt::QueuedConnection

```cpp
connect(sender,
        &Sender::finished,
        receiver,
        &Receiver::update,
        Qt::QueuedConnection);
```

Flow:

```text
Signal

↓

Create Meta Call Event

↓

Receiver Event Queue

↓

Receiver Thread

↓

Slot Executes
```

The slot runs in the receiver's thread.

This is the preferred mechanism for communication between threads.

---

# Example

```text
Dose Thread

↓

Dose Finished Signal

↓

GUI Event Queue

↓

Update DVH

↓

Update Dose Viewer
```

No GUI code runs in the worker thread.

---

# 5. Qt::BlockingQueuedConnection

```cpp
Qt::BlockingQueuedConnection
```

Flow:

```text
Thread A

↓

Emit Signal

↓

Wait

──────────────

Thread B

↓

Execute Slot

↓

Return

↓

Thread A Continues
```

The emitting thread blocks until the slot finishes.

### Use Carefully

If both objects are in the same thread:

```text
Thread

↓

Wait For Itself

↓

Deadlock
```

Qt documentation warns against using `BlockingQueuedConnection` within the same thread.

Typical use cases are limited to specialized synchronization scenarios.

---

# 6. QMetaObject::invokeMethod()

Sometimes you want to execute a method in another object's thread without defining a signal.

Example:

```cpp
QMetaObject::invokeMethod(
    receiver,
    "refresh",
    Qt::QueuedConnection);
```

Conceptually:

```text
Worker Thread

↓

invokeMethod()

↓

Receiver Queue

↓

GUI Thread

↓

refresh()
```

This is useful for scheduling work in another thread's event loop.

---

# 7. Worker Object Pattern

This is the **recommended Qt threading pattern**.

## Step 1

Create a worker class.

```cpp
class DoseWorker : public QObject
{
    Q_OBJECT

public slots:
    void calculateDose();
};
```

---

## Step 2

Create a thread.

```cpp
QThread *thread = new QThread;
```

---

## Step 3

Create the worker.

```cpp
DoseWorker *worker = new DoseWorker;
```

---

## Step 4

Move the worker.

```cpp
worker->moveToThread(thread);
```

---

## Step 5

Connect signals.

```cpp
connect(thread,
        &QThread::started,
        worker,
        &DoseWorker::calculateDose);
```

---

## Architecture

```text
GUI Thread
     │
     ▼
 MainWindow

──────────────

Worker Thread
     │
     ▼
 DoseWorker

──────────────

Queued Signal

──────────────

GUI Thread
```

This pattern keeps the GUI responsive while long-running work executes in the worker thread.

---

# 8. deleteLater()

Suppose:

```cpp
delete worker;
```

What if the worker is currently processing events?

That may be unsafe.

Instead:

```cpp
worker->deleteLater();
```

Flow:

```text
deleteLater()

↓

Deferred Delete Event

↓

Worker Event Queue

↓

Safe Destruction
```

Qt deletes the object when control returns to its event loop.

---

## Why?

If the object is in the middle of handling a slot or event, immediate deletion could invalidate the current execution.

`deleteLater()` avoids that risk.

---

# 9. Safe Thread Shutdown

Typical sequence:

```cpp
thread->quit();
thread->wait();
```

Flow:

```text
Thread Running

↓

quit()

↓

Event Loop Stops

↓

Thread Finishes

↓

wait()

↓

Cleanup
```

For worker objects:

```cpp
connect(thread,
        &QThread::finished,
        worker,
        &QObject::deleteLater);

connect(thread,
        &QThread::finished,
        thread,
        &QObject::deleteLater);
```

This is a common and recommended cleanup pattern.

---

# 10. Enterprise Architecture

```text
                 GUI Thread
+--------------------------------------+
| MainWindow                           |
| Dose Viewer                          |
| DVH                                  |
+----------------▲---------------------+
                 │
         Queued Signals
                 │
+----------------┼---------------------+
| Dose Worker Thread                  |
| Registration Thread                 |
| DICOM Thread                        |
+--------------------------------------+
```

Each worker performs computation and communicates back to the GUI through queued connections.

---

# 11. Qt Source Code Concepts

Conceptually, a queued connection behaves like this:

```text
emit signal()

↓

Create Meta Call Event

↓

Receiver Event Queue

↓

Receiver Event Loop

↓

Invoke Slot
```

A direct connection behaves like:

```text
emit signal()

↓

Call Slot Immediately
```

No event queue is involved.

---

# 12. Qt 5.15 vs Qt 6.11

| Feature                    | Qt 5.15 | Qt 6.11 |
| -------------------------- | ------- | ------- |
| AutoConnection             | ✔       | ✔       |
| QueuedConnection           | ✔       | ✔       |
| DirectConnection           | ✔       | ✔       |
| BlockingQueuedConnection   | ✔       | ✔       |
| `invokeMethod()`           | ✔       | ✔       |
| `Qt::SingleShotConnection` | ✘       | ✔       |

`Qt::SingleShotConnection` was introduced in Qt 6 and automatically disconnects after the first successful signal delivery.

---

# 13. Best Practices

✅ Prefer `Qt::AutoConnection` unless you have a specific reason to choose another type.

✅ Use queued connections between worker threads and the GUI.

✅ Use the Worker Object Pattern instead of subclassing `QThread` for application logic.

✅ Use `deleteLater()` for `QObject` cleanup across event-driven code.

✅ Shut down threads with `quit()` and `wait()`.

---

# 14. Common Mistakes

### ❌ Updating GUI from a worker thread

```cpp
label->setText("Done");
```

Never do this from a worker thread.

---

### ❌ Using DirectConnection across threads

This can execute receiver code in the wrong thread.

---

### ❌ Deleting running workers

```cpp
delete worker;
```

Prefer `deleteLater()` when appropriate.

---

### ❌ Forgetting `wait()`

Destroying a `QThread` before it has actually finished can lead to undefined behavior.

---

# 15. Interview Questions

## Easy

1. What is `Qt::AutoConnection`?
2. What is a queued connection?
3. Why use `deleteLater()`?

---

## Medium

1. Compare direct and queued connections.
2. Explain the Worker Object Pattern.
3. What does `invokeMethod()` do?

---

## Hard

1. Explain how queued signal-slot delivery works internally.
2. Why is `BlockingQueuedConnection` dangerous in the same thread?
3. Describe a safe thread shutdown sequence.

---

## Expert

1. Design a multi-threaded Treatment Planning System using worker objects.
2. Compare custom events and queued signal-slot connections.
3. Explain how Qt schedules queued slot execution through the event loop.

---

# 16. Architecture Diagram

```text
           GUI Thread
                │
                ▼
         MainWindow
                ▲
                │
        Queued Signal
                │
────────────────────────────────
                │
                ▼
         Worker Thread
                │
                ▼
         DoseWorker
                │
                ▼
      Long Calculation
```

---

# 🏥 Production Example — Treatment Planning System

```text
Doctor Clicks "Calculate Dose"
            │
            ▼
      MainWindow
            │
            ▼
Queued Signal
            │
            ▼
 DoseWorker::calculateDose()
            │
            ▼
 Monte Carlo Solver
            │
            ▼
 Dose Complete Signal
            │
            ▼
 GUI Thread
            │
            ▼
 Refresh Dose Viewer
            │
            ▼
 Refresh DVH
            │
            ▼
 Enable "Export RT Dose"
```

The GUI never blocks while the dose engine performs computation.

---

# 17. Revision Notes

* `Qt::AutoConnection` automatically chooses direct or queued behavior.
* `Qt::DirectConnection` executes the slot immediately in the emitting thread.
* `Qt::QueuedConnection` posts execution to the receiver's event loop.
* `Qt::BlockingQueuedConnection` blocks the sender until the slot completes and should not be used within the same thread.
* `QMetaObject::invokeMethod()` can schedule work in another thread.
* The Worker Object Pattern is the preferred Qt threading design.
* `deleteLater()` safely defers object destruction.
* Shut down threads using `quit()` followed by `wait()`.

---

# 🎯 Chapter 34 Complete

You now have a complete understanding of **Qt Thread Affinity**, including:

* Thread ownership
* `moveToThread()`
* Connection types
* Queued vs direct execution
* Worker Object Pattern
* `deleteLater()`
* Thread shutdown
* Qt 5 → Qt 6 differences

At this point, you have mastered one of the most important foundations of professional Qt application development.

---

# 🚀 Next Chapter

## **Chapter 35 — QWidget (Complete Deep Dive)**

