# Complete Qt Master Course (Qt 5.15 LTS → Qt 6.11)

# PART XI — Multithreading

# Chapter 81 — Worker Pattern (Complete Deep Dive)

## Master QObject Workers, moveToThread(), Thread Ownership, Lifetime Management & Enterprise Qt Multithreading

> **Level:** Advanced → Architect

---

# Chapter Objectives

After completing this chapter, you will understand:

* Why the Worker Pattern is Recommended
* Worker Pattern Architecture
* `QObject` Worker
* `moveToThread()`
* Worker Thread Lifecycle
* Signal-Slot Communication
* Thread Ownership
* Object Lifetime Management
* Progress Reporting
* Error Handling
* Cooperative Cancellation
* Graceful Shutdown
* Enterprise Thread Architecture
* Qt Internals
* Qt 5.15 vs Qt 6.11
* Best Practices
* Interview Questions

---

# Table of Contents

1. Introduction
2. Why Worker Pattern?
3. Worker Pattern Architecture
4. Creating a Worker Object
5. moveToThread()
6. Starting the Worker
7. Cross-Thread Communication
8. Progress Reporting
9. Error Handling
10. Cooperative Cancellation
11. Lifetime Management
12. Graceful Shutdown
13. Enterprise Applications
14. Qt Internals
15. Qt 5 vs Qt 6
16. Best Practices
17. Common Mistakes
18. Interview Questions
19. Revision Notes

---

# 1. Introduction

Qt recommends using the **Worker Object Pattern** instead of subclassing `QThread` for most application-level tasks.

The key idea is simple:

* `QThread` manages **where** code runs.
* A `QObject` worker contains **what** work is done.

This separation improves maintainability and testability.

---

## Traditional Approach

```text id="wp01"
QThread

↓

Override run()

↓

Work
```

---

## Recommended Approach

```text id="wp02"
QObject Worker

↓

moveToThread()

↓

QThread
```

---

# 2. Why Worker Pattern?

Suppose you need to:

* Load DICOM files
* Perform image registration
* Calculate dose
* Export reports

The work belongs in a **worker object**, not inside the thread class itself.

Advantages:

* Cleaner architecture
* Better code reuse
* Easier testing
* Better signal-slot integration
* Supports event loops naturally

---

# 3. Worker Pattern Architecture

```text id="wp03"
GUI Thread

      │

      ▼

Worker Object

      │

moveToThread()

      │

      ▼

QThread

      │

      ▼

Background Work
```

The `QObject` executes in the thread to which it has affinity.

---

## Enterprise Architecture

```text id="wp04"
GUI

↓

Controller

↓

Worker

↓

QThread
```

The controller coordinates the worker and the thread.

---

# 4. Creating a Worker Object

Worker class

```cpp id="wp05"
class DoseWorker :
    public QObject
{
    Q_OBJECT

public slots:

    void process();
};
```

The worker derives from `QObject`, **not** from `QThread`.

---

## Signals

Typical signals

```cpp id="wp06"
signals:

void progress(int);

void finished();

void error(QString);
```

These allow communication with the GUI thread.

---

# 5. moveToThread()

Move the worker

```cpp id="wp07"
worker->moveToThread(
    &thread);
```

After this call:

```text id="wp08"
Worker

↓

Thread Affinity

↓

Worker Thread
```

Important:

* The object is **not copied**.
* The thread affinity changes.
* Slots invoked via queued connections execute in the worker thread.

---

# 6. Starting the Worker

Typical setup

```cpp id="wp09"
connect(
&thread,
&QThread::started,
worker,
&DoseWorker::process);
```

Workflow

```text id="wp10"
thread.start()

↓

started()

↓

Worker::process()
```

This avoids calling worker methods directly from the GUI thread.

---

# 7. Cross-Thread Communication

Worker → GUI

```text id="wp11"
Worker

↓

Signal

↓

GUI
```

Example

```cpp id="wp12"
emit progress(50);
```

Connected slot

```cpp id="wp13"
MainWindow::updateProgress()
```

Qt automatically queues the signal because the sender and receiver belong to different threads.

---

## Communication Flow

```text id="wp14"
Worker Thread

↓

Signal

↓

Event Queue

↓

GUI Thread

↓

Slot
```

---

# 8. Progress Reporting

Long-running tasks should report progress.

Example

```text id="wp15"
0%

↓

25%

↓

50%

↓

75%

↓

100%
```

Worker

```cpp id="wp16"
emit progress(percent);
```

GUI

```text id="wp17"
Progress Bar

↓

Updated
```

The worker never accesses the progress bar directly.

---

# 9. Error Handling

Workers should report errors using signals.

Example

```cpp id="wp18"
emit error(
"Cannot load DICOM");
```

Workflow

```text id="wp19"
Worker

↓

Error Signal

↓

GUI

↓

Message Box
```

This keeps error handling centralized.

---

# 10. Cooperative Cancellation

Avoid forcing threads to stop.

Instead

```text id="wp20"
GUI

↓

Cancel Requested

↓

Worker Checks Flag

↓

Stops Safely
```

Example

```cpp id="wp21"
if(cancelRequested)
    return;
```

Check periodically inside long-running loops.

---

## Cancellation Workflow

```text id="wp22"
Process

↓

Loop

↓

Cancel?

↓

Yes

↓

Exit
```

---

# 11. Lifetime Management

A common setup

```text id="wp23"
QThread

↓

Worker

↓

Finished

↓

Delete Worker

↓

Delete Thread
```

Qt connections

```cpp id="wp24"
connect(
worker,
&DoseWorker::finished,
worker,
&QObject::deleteLater);

connect(
&thread,
&QThread::finished,
&thread,
&QObject::deleteLater);
```

If the thread object is created on the stack instead of the heap, it should **not** be connected to `deleteLater()`.

---

# 12. Graceful Shutdown

Recommended shutdown

```text id="wp25"
Worker Finished

↓

thread.quit()

↓

thread.wait()

↓

Application Exit
```

Qt

```cpp id="wp26"
thread.quit();

thread.wait();
```

Never destroy a running thread.

---

# 13. Enterprise Applications

## Medical TPS

```text id="wp27"
GUI

↓

Dose Worker

↓

Dose Calculation
```

---

## DICOM Import

```text id="wp28"
GUI

↓

Import Worker

↓

Read Images
```

---

## CAD

```text id="wp29"
GUI

↓

Geometry Worker

↓

Mesh Processing
```

---

## ERP

```text id="wp30"
GUI

↓

Report Worker

↓

Generate PDF
```

---

# 14. Qt Internals

```text id="wp31"
QObject

↓

Thread Affinity

↓

Meta-Object

↓

Event Queue

↓

Slot
```

Signal delivery

```text id="wp32"
emit

↓

Meta-Object System

↓

Queued Event

↓

Receiver Thread
```

Queued connections rely on the receiver's event loop.

---

# 15. Qt 5 vs Qt 6

| Feature            | Qt 5.15 | Qt 6.11 |
| ------------------ | ------- | ------- |
| moveToThread()     | ✔       | ✔       |
| QObject Workers    | ✔       | ✔       |
| Queued Connections | ✔       | ✔       |
| Thread Affinity    | ✔       | ✔       |
| Event Loop         | ✔       | ✔       |

The Worker Object pattern is recommended in both Qt 5 and Qt 6.

---

# 16. Best Practices

✅ Keep workers focused on one responsibility.

✅ Use signals and slots for communication.

✅ Never update widgets from worker threads.

✅ Use cooperative cancellation.

✅ Shut down threads cleanly with `quit()` and `wait()`.

---

# 17. Common Mistakes

### ❌ Subclassing `QThread` for every task

Prefer `QObject` workers unless you have a specific reason to override `run()`.

---

### ❌ Calling worker methods directly after moving them

Use signals or queued invocations instead.

---

### ❌ Forgetting object ownership

Know who owns the worker and thread.

---

### ❌ Blocking the worker event loop

Long operations should periodically check for cancellation and avoid starving the event loop if it is needed.

---

### ❌ Accessing GUI objects

Workers should never manipulate `QWidget` objects directly.

---

# 18. Interview Questions

## Easy

1. What is the Worker Object pattern?
2. Why is it preferred over subclassing `QThread`?
3. What does `moveToThread()` do?

---

## Medium

1. Explain thread affinity.
2. How do workers report progress?
3. How should worker errors be propagated?

---

## Hard

1. Explain worker lifetime management.
2. Why are queued connections important?
3. Design a cancellation mechanism for long-running tasks.

---

## Expert

1. Design the worker architecture for a Medical Treatment Planning System where CT import, contour generation, dose calculation, DVH computation, and report generation execute independently.
2. Explain how Qt delivers cross-thread signals safely.
3. Compare the Worker Object pattern with subclassing `QThread`, thread pools, and `QtConcurrent`.

---

# 19. Revision Notes

* The Worker Object pattern is Qt's recommended multithreading approach.
* Workers derive from `QObject`.
* `moveToThread()` changes thread affinity.
* `QThread` manages execution.
* Workers communicate using signals and slots.
* Use queued connections for cross-thread communication.
* Report progress with signals.
* Support cooperative cancellation.
* Shut down threads gracefully.

---

# 💡 Senior Engineer Tips

## Worker Pattern vs Subclassing QThread

| Feature                | Worker Pattern | Subclass QThread                |
| ---------------------- | -------------- | ------------------------------- |
| Qt Recommendation      | ⭐⭐⭐⭐⭐          | ⭐⭐                              |
| Event Loop Support     | Excellent      | Manual if `run()` is overridden |
| Reusability            | High           | Lower                           |
| Testability            | High           | Moderate                        |
| Separation of Concerns | Excellent      | Weaker                          |

---

## Enterprise Thread Architecture

```text id="wp33"
GUI Thread
      │
      ▼
Task Controller
      │
 ┌────┼─────────────┐
 ▼    ▼             ▼
Import Worker   Dose Worker   Export Worker
 │    │             │
 ▼    ▼             ▼
QThread QThread   QThread
```

Each worker has a single responsibility and communicates with the controller through signals.

---

## Medical TPS Example

```text id="wp34"
GUI
 │
 ▼
Treatment Controller
 │
 ├──────────────┬──────────────┬──────────────┐
 ▼              ▼              ▼              ▼
CT Loader   Registration   Dose Engine   Report Export
 Worker         Worker         Worker        Worker
 │              │              │             │
 └──────────────┴──────────────┴─────────────┘
                    │
                    ▼
              Progress & Results
                    │
                    ▼
                   GUI
```

This design provides:

* Responsive UI
* Independent task execution
* Clear ownership
* Easy maintenance
* Better scalability

---

# 🎯 Chapter 81 Complete

You now understand:

* Worker Object pattern
* `QObject` workers
* `moveToThread()`
* Thread affinity
* Progress reporting
* Error propagation
* Cooperative cancellation
* Lifetime management
* Graceful shutdown
* Enterprise multithreading architecture
* Qt 5.15 vs Qt 6.11 compatibility

This chapter establishes the **Qt-recommended foundation** for building responsive, maintainable multithreaded applications.

---

# 🚀 Next Chapter

## **Chapter 82 — Thread Pool (Complete Deep Dive)**

In the next chapter, you'll learn:

* Why thread pools are used
* `QThreadPool`
* `QRunnable`
* Task scheduling
* Thread reuse
* Global thread pool
* Setting thread limits
* Priorities
* Performance tuning
* Enterprise architectures
* Medical TPS examples
* Interview questions
