# Complete Qt Master Course (Qt 5.15 LTS → Qt 6.11)

# PART XI — Multithreading

# Chapter 80 — QThread (Complete Deep Dive)

## Master QThread, Thread Lifecycle, Thread Affinity, Event Loops & Enterprise Multithreading

> **Level:** Advanced → Architect



---

# 1. Introduction

A **thread** is the smallest unit of execution within a process.

A Qt application normally starts with **one thread**:

* Main Thread (GUI Thread)

All widgets, windows, and user interaction happen in this thread.

If a long-running task blocks the GUI thread, the application becomes unresponsive.

---

## Example

```text id="qt80_01"
GUI Thread

↓

Button Click

↓

Long Calculation

↓

GUI Freezes
```

Users experience this as a "Not Responding" application.

---

# 2. Why Multithreading?

Suppose your application needs to:

* Load a 2 GB DICOM dataset
* Perform dose calculation
* Download files
* Process images
* Compress data

Doing this in the GUI thread blocks the interface.

Instead:

```text id="qt80_02"
GUI Thread

↓

Responsive UI

--------------------

Worker Thread

↓

Heavy Calculation
```

The GUI remains responsive while the worker performs the task.

---

## Typical Use Cases

| Task                  | Separate Thread? |
| --------------------- | ---------------- |
| File Loading          | ✔                |
| Image Processing      | ✔                |
| Network Communication | Often            |
| Database Query        | Often            |
| Rendering Widgets     | ✘                |
| Updating QPushButton  | ✘                |

---

# 3. Process vs Thread

## Process

A process owns:

* Memory
* Resources
* Address Space

```text id="qt80_03"
Operating System

↓

Qt Application

↓

Memory
```

---

## Thread

Threads share the process memory.

```text id="qt80_04"
Process

├── GUI Thread

├── Worker Thread

└── Network Thread
```

Shared:

* Heap
* Global variables
* Static objects

Each thread has its own:

* Stack
* Program Counter
* Registers

---

## Comparison

| Feature        | Process  | Thread        |
| -------------- | -------- | ------------- |
| Memory         | Separate | Shared        |
| Communication  | IPC      | Shared Memory |
| Creation Cost  | Higher   | Lower         |
| Context Switch | Slower   | Faster        |

---

# 4. Thread Architecture

```text id="qt80_05"
Application

        │

        ▼

 Main Thread

   │        │

   ▼        ▼

Worker1   Worker2
```

Each worker performs independent tasks.

Example

```text id="qt80_06"
GUI

↓

Load CT

↓

Worker Thread

↓

Read DICOM

↓

Notify GUI
```

---

# 5. Thread Lifecycle

```text id="qt80_07"
Created

↓

Started

↓

Running

↓

Finished

↓

Destroyed
```

Qt emits signals during the lifecycle.

---

# 6. What is QThread?

`QThread` represents a thread of execution.

Header

```cpp id="qt80_08"
#include <QThread>
```

Create

```cpp id="qt80_09"
QThread thread;
```

Start

```cpp id="qt80_10"
thread.start();
```

Stop (cooperatively)

```cpp id="qt80_11"
thread.quit();

thread.wait();
```

`wait()` blocks until the thread finishes.

---

# 7. Creating Threads

Qt supports multiple approaches.

## Method 1 (Recommended)

Worker Object

```text id="qt80_12"
QObject

↓

moveToThread()

↓

QThread
```

This is the recommended Qt design.

---

## Method 2

Subclass `QThread`

```cpp id="qt80_13"
class MyThread :
public QThread
{
protected:

void run() override;
};
```

Suitable for specialized cases where overriding `run()` is appropriate.

---

## Starting

```cpp id="qt80_14"
thread.start();
```

---

# 8. Thread Affinity

Every `QObject` belongs to exactly one thread.

Example

```text id="qt80_15"
QObject

↓

GUI Thread
```

Move

```cpp id="qt80_16"
worker.moveToThread(
    &thread);
```

Now

```text id="qt80_17"
Worker Object

↓

Worker Thread
```

---

## Important Rule

Moving a `QObject` changes the thread that owns it, but **it does not move the underlying operating-system thread**.

---

# 9. Event Loops

The GUI thread has an event loop.

Worker threads can also have one.

```text id="qt80_18"
Thread

↓

Event Loop

↓

Events

↓

Slots
```

Default `QThread::run()` starts an event loop by calling `exec()`.

If you override `run()` and do **not** call `exec()`, that thread will not process queued events or timers.

---

# 10. Cross-Thread Signal-Slot

Suppose

```text id="qt80_19"
Worker

↓

Signal

↓

GUI
```

Qt automatically delivers queued signals safely across threads when appropriate.

Example

```cpp id="qt80_20"
connect(
worker,

&Worker::finished,

this,

&MainWindow::updateUI);
```

The slot executes in the receiver's thread.

---

## Connection Types

| Type           | Behavior                   |
| -------------- | -------------------------- |
| Auto           | Qt chooses                 |
| Direct         | Immediate call             |
| Queued         | Through event loop         |
| BlockingQueued | Sender waits               |
| Unique         | Avoid duplicate connection |

`Qt::AutoConnection` is usually the correct choice.

---

# 11. GUI Thread Rules

**Rule #1**

Never access QWidget-derived objects from a worker thread.

Wrong

```text id="qt80_21"
Worker Thread

↓

button->setText()
```

Correct

```text id="qt80_22"
Worker

↓

Signal

↓

GUI Thread

↓

Update Widget
```

Widgets must remain in the GUI thread.

---

# 12. Thread Synchronization Overview

Multiple threads may access shared data.

```text id="qt80_23"
Thread A

↓

Shared Data

↑

Thread B
```

Without synchronization,

race conditions occur.

Qt provides:

* `QMutex`
* `QReadWriteLock`
* `QSemaphore`
* `QWaitCondition`
* `QAtomicInteger`

These are covered in later chapters.

---

# 13. Thread Termination

Preferred

```cpp id="qt80_24"
thread.quit();

thread.wait();
```

Avoid

```cpp id="qt80_25"
thread.terminate();
```

`terminate()` can stop a thread abruptly and leave shared resources in an inconsistent state.

Use cooperative cancellation whenever possible.

---

# 14. Enterprise Applications

## Medical TPS

```text id="qt80_26"
GUI

↓

Worker

↓

Dose Engine
```

---

## Image Viewer

```text id="qt80_27"
GUI

↓

Worker

↓

DICOM Loading
```

---

## CAD

```text id="qt80_28"
GUI

↓

Geometry Thread
```

---

## ERP

```text id="qt80_29"
GUI

↓

Database Thread
```

---

# 15. Qt Internals

```text id="qt80_30"
QObject

↓

Thread Affinity

↓

Event Loop

↓

Queued Events
```

Execution

```text id="qt80_31"
Signal

↓

Meta-Object System

↓

Event Queue

↓

Receiver Thread
```

Queued signal-slot delivery relies on Qt's event system and meta-object system.

---

# 16. Qt 5 vs Qt 6

| Feature         | Qt 5.15 | Qt 6.11 |
| --------------- | ------- | ------- |
| QThread         | ✔       | ✔       |
| moveToThread()  | ✔       | ✔       |
| Queued Signals  | ✔       | ✔       |
| Event Loop      | ✔       | ✔       |
| Thread Affinity | ✔       | ✔       |

The threading API remains highly compatible across Qt 5 and Qt 6.

---

# 17. Best Practices

✅ Use the Worker Object pattern.

✅ Keep the GUI thread responsive.

✅ Use signals and slots for communication.

✅ Call `quit()` and `wait()` for shutdown.

✅ Keep threads focused on a single responsibility.

---

# 18. Common Mistakes

### ❌ Updating widgets from worker threads

Always update the UI in the GUI thread.

---

### ❌ Calling `terminate()`

Prefer cooperative shutdown.

---

### ❌ Sharing data without synchronization

Protect shared resources.

---

### ❌ Blocking the GUI thread

Move expensive work to worker threads.

---

### ❌ Forgetting thread ownership

Know which thread owns each `QObject`.

---

# 19. Interview Questions

## Easy

1. What is a thread?
2. What is `QThread`?
3. What is thread affinity?

---

## Medium

1. Explain the Worker Object pattern.
2. Why shouldn't widgets be updated from worker threads?
3. How do queued connections work?

---

## Hard

1. Explain Qt's event loop in worker threads.
2. Compare subclassing `QThread` with using `moveToThread()`.
3. What is thread affinity, and why is it important?

---

## Expert

1. Design the threading architecture for a Treatment Planning System where CT loading, contour generation, dose calculation, and DVH computation run concurrently while keeping the GUI responsive.
2. Explain how Qt safely delivers signals across threads.
3. Design a multithreaded CAD application handling rendering, file loading, and background geometry processing.

---

# 20. Revision Notes

* `QThread` represents a thread of execution.
* The GUI thread handles all widgets.
* Worker threads perform long-running tasks.
* `moveToThread()` is the preferred design.
* Every `QObject` has thread affinity.
* Cross-thread communication uses queued signals and slots.
* Worker threads can have event loops.
* Avoid `terminate()`.
* Synchronize shared data.

---

# 💡 Senior Engineer Tips

## Which Tasks Should Run in Worker Threads?

| Task                  | Worker Thread? |
| --------------------- | -------------- |
| Dose Calculation      | ✔              |
| CT Image Loading      | ✔              |
| DICOM Parsing         | ✔              |
| Network Requests      | Often          |
| Database Operations   | Often          |
| Button Click Handling | ✘              |
| QWidget Painting      | ✘              |

---

## Enterprise Thread Architecture

```text id="qt80_32"
GUI Thread
      │
      ├───────────────┐
      ▼               ▼
Network Thread   Database Thread
      │               │
      ▼               ▼
Result Signals   Result Signals
      └───────┬───────┘
              ▼
         GUI Updates
```

Each thread should have a clear responsibility, reducing contention and simplifying debugging.

---

## Medical TPS Example

```text id="qt80_33"
GUI Thread
      │
      ├─────────────┬──────────────┬─────────────┐
      ▼             ▼              ▼             ▼
CT Loader     Dose Engine     DVH Engine   Export Thread
      │             │              │             │
      └─────────────┴──────────────┴─────────────┘
                        │
                        ▼
                  Signal to GUI
```

This architecture allows the application to:

* Load DICOM images in the background.
* Compute dose without freezing the UI.
* Generate DVH charts concurrently.
* Export reports while users continue working.

---



## **Chapter 81 — Worker Pattern (Complete Deep Dive)**

