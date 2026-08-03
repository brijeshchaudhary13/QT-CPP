# Complete Qt Master Course (Qt 5.15 LTS → Qt 6.11)

# PART XI — Multithreading

# Chapter 82 — Thread Pool (Complete Deep Dive)

## Master QThreadPool, QRunnable, Task Scheduling, Thread Reuse & High-Performance Qt Applications

> **Level:** Advanced → Architect

---

# Chapter Objectives

After completing this chapter, you will understand:

* Why Thread Pools?
* What is `QThreadPool`?
* What is `QRunnable`?
* Thread Pool Architecture
* Global Thread Pool
* Thread Reuse
* Task Scheduling
* Thread Priorities
* Auto Deletion
* Performance Optimization
* Enterprise Thread Pool Design
* Qt Internals
* Qt 5.15 vs Qt 6.11
* Best Practices
* Interview Questions

---

# Table of Contents

1. Introduction
2. Why Thread Pools?
3. Thread Pool Architecture
4. QRunnable
5. QThreadPool
6. Global Thread Pool
7. Thread Reuse
8. Task Scheduling
9. Thread Priorities
10. Auto Deletion
11. Performance Considerations
12. Enterprise Applications
13. Qt Internals
14. Qt 5 vs Qt 6
15. Best Practices
16. Common Mistakes
17. Interview Questions
18. Revision Notes

---

# 1. Introduction

Creating and destroying threads repeatedly is expensive.

Every thread requires:

* Memory
* Stack allocation
* Operating system resources
* Context switching

If your application creates hundreds of short-lived threads, performance suffers.

A **Thread Pool** solves this problem by **reusing existing threads**.

---

## Without Thread Pool

```text id="tp01"
Task 1

↓

Create Thread

↓

Destroy Thread

↓

Task 2

↓

Create Thread

↓

Destroy Thread
```

---

## With Thread Pool

```text id="tp02"
Task 1

↓

Existing Thread

↓

Task 2

↓

Same Thread

↓

Task 3
```

The thread remains alive and executes multiple tasks.

---

# 2. Why Thread Pools?

Imagine processing 500 DICOM images.

Bad approach:

```text id="tp03"
500 Images

↓

500 Threads
```

Good approach:

```text id="tp04"
500 Images

↓

8 Threads

↓

500 Tasks
```

The operating system schedules work much more efficiently.

---

## Benefits

* Lower thread creation overhead
* Better CPU utilization
* Reduced memory usage
* Better scalability

---

# 3. Thread Pool Architecture

```text id="tp05"
Application

↓

Task Queue

↓

QThreadPool

↓

Worker Threads
```

Tasks are queued.

Available threads execute them.

---

## Enterprise View

```text id="tp06"
GUI

↓

Task Queue

↓

Thread Pool

↓

Worker Threads

↓

Results
```

---

# 4. QRunnable

`QRunnable` represents a task.

Header

```cpp id="tp07"
#include <QRunnable>
```

Example

```cpp id="tp08"
class ImageTask :
    public QRunnable
{
public:

void run() override;
};
```

`run()` contains the work to execute.

Unlike `QObject`, `QRunnable` does **not** provide signals and slots.

---

# 5. QThreadPool

Header

```cpp id="tp09"
#include <QThreadPool>
```

Create

```cpp id="tp10"
QThreadPool pool;
```

Start task

```cpp id="tp11"
pool.start(task);
```

Workflow

```text id="tp12"
QRunnable

↓

Thread Pool

↓

Thread

↓

run()
```

---

# 6. Global Thread Pool

Qt provides a shared global pool.

```cpp id="tp13"
QThreadPool::globalInstance()
```

Example

```cpp id="tp14"
QThreadPool::globalInstance()
->start(task);
```

Useful for small applications.

Large enterprise systems sometimes use dedicated pools for different workloads.

---

# 7. Thread Reuse

Without pool

```text id="tp15"
Thread 1

Destroyed

↓

Thread 2

Destroyed
```

With pool

```text id="tp16"
Thread 1

↓

Task A

↓

Task B

↓

Task C
```

The same thread executes multiple tasks.

---

# 8. Task Scheduling

Tasks enter a queue.

```text id="tp17"
Task Queue

↓

Thread Pool

↓

Available Thread
```

When a worker thread finishes,

it automatically retrieves another queued task.

---

## Multiple Tasks

```text id="tp18"
Task1

Task2

Task3

Task4

↓

Pool

↓

Threads
```

The exact execution order depends on thread availability and scheduling.

---

# 9. Thread Priorities

You can assign priorities to tasks.

Example

```cpp id="tp19"
pool.start(
task,
priority);
```

Higher-priority tasks may be scheduled before lower-priority ones, but exact behavior depends on the implementation and system state.

---

# 10. Auto Deletion

By default,

`QRunnable` objects are automatically deleted after `run()` completes.

```cpp id="tp20"
task->setAutoDelete(true);
```

Disable

```cpp id="tp21"
task->setAutoDelete(false);
```

Use manual deletion only when you have a clear ownership strategy.

---

# 11. Performance Considerations

Maximum threads

```cpp id="tp22"
pool.setMaxThreadCount(8);
```

Query

```cpp id="tp23"
pool.maxThreadCount();
```

Recommended

```cpp id="tp24"
QThread::idealThreadCount();
```

This returns the number of logical processors available as a guideline.

---

## CPU-bound Tasks

A thread count close to the number of CPU cores is often a good starting point.

---

## I/O-bound Tasks

More threads may improve throughput because many spend time waiting for I/O.

Measure performance before changing thread counts.

---

# 12. Enterprise Applications

## Image Processing

```text id="tp25"
500 Images

↓

Task Queue

↓

Thread Pool
```

---

## Medical TPS

```text id="tp26"
Dose Points

↓

Tasks

↓

Pool
```

---

## CAD

```text id="tp27"
Geometry

↓

Tasks

↓

Threads
```

---

## ERP

```text id="tp28"
Reports

↓

Thread Pool
```

---

# 13. Qt Internals

```text id="tp29"
QRunnable

↓

Task Queue

↓

QThreadPool

↓

Worker Thread
```

Execution

```text id="tp30"
Task

↓

run()

↓

Thread Returns

↓

Pool
```

The thread is returned to the pool for reuse after completing the task.

---

# 14. Qt 5 vs Qt 6

| Feature     | Qt 5.15 | Qt 6.11 |
| ----------- | ------- | ------- |
| QRunnable   | ✔       | ✔       |
| QThreadPool | ✔       | ✔       |
| Global Pool | ✔       | ✔       |
| AutoDelete  | ✔       | ✔       |
| Priorities  | ✔       | ✔       |

The API remains largely unchanged between Qt 5 and Qt 6.

---

# 15. Best Practices

✅ Reuse threads through `QThreadPool`.

✅ Keep tasks short and focused.

✅ Use `QThread::idealThreadCount()` as an initial guide.

✅ Avoid blocking worker threads unnecessarily.

✅ Measure performance before tuning thread counts.

---

# 16. Common Mistakes

### ❌ Creating thousands of threads

Use a thread pool instead.

---

### ❌ Sharing mutable data without synchronization

Protect shared resources appropriately.

---

### ❌ Very large tasks

Break long jobs into smaller tasks when practical.

---

### ❌ Incorrect `autoDelete` ownership

Understand who owns the `QRunnable`.

---

### ❌ Blocking GUI waiting for the pool

Keep the UI asynchronous.

---

# 17. Interview Questions

## Easy

1. What is a thread pool?
2. What is `QRunnable`?
3. What is `QThreadPool`?

---

## Medium

1. Why is thread reuse important?
2. Explain `autoDelete`.
3. What is the global thread pool?

---

## Hard

1. Explain thread pool scheduling.
2. How would you choose the maximum thread count?
3. Compare dedicated threads with a thread pool.

---

## Expert

1. Design a thread-pool architecture for a Treatment Planning System where millions of dose voxels are processed in parallel.
2. Explain how thread pools improve scalability compared to creating one thread per task.
3. Compare `QThread`, `QThreadPool`, `QtConcurrent`, and `std::async` for modern Qt applications.

---

# 18. Revision Notes

* `QThreadPool` manages reusable worker threads.
* `QRunnable` represents a task.
* Threads are reused instead of recreated.
* Tasks are queued until a thread is available.
* The global thread pool is convenient for many applications.
* `autoDelete` controls `QRunnable` lifetime.
* `idealThreadCount()` provides a hardware-based guideline.
* Thread pools improve performance and scalability.

---

# 💡 Senior Engineer Tips

## QThread vs QThreadPool

| Feature                     | QThread  | QThreadPool                                                |
| --------------------------- | -------- | ---------------------------------------------------------- |
| Long-running worker         | ⭐⭐⭐⭐⭐    | ⭐⭐                                                         |
| Short background tasks      | ⭐⭐       | ⭐⭐⭐⭐⭐                                                      |
| Thread reuse                | ✘        | ✔                                                          |
| Event Loop Support          | ✔        | Limited (tasks don't have their own event loop by default) |
| Fine-grained task execution | Moderate | Excellent                                                  |

---

## Enterprise Thread Pool Architecture

```text id="tp31"
GUI Thread
      │
      ▼
Task Manager
      │
      ▼
Task Queue
      │
      ▼
QThreadPool
      │
 ┌────┼────┬────┐
 ▼    ▼    ▼    ▼
T1   T2   T3   T4
```

A **Task Manager** coordinates task creation, progress tracking, cancellation, and result aggregation.

---

## Medical TPS Example

```text id="tp32"
Dose Calculation
        │
        ▼
 Divide Volume
        │
 ┌──────┼────────┬────────┐
 ▼      ▼        ▼        ▼
Tile1  Tile2    Tile3    Tile4
 │      │        │        │
 ▼      ▼        ▼        ▼
QRunnable Tasks (Thread Pool)
 │      │        │        │
 └──────┼────────┴────────┘
        ▼
 Merge Dose Results
        ▼
 Update GUI
```

This approach:

* Uses all available CPU cores efficiently.
* Avoids the overhead of creating thousands of threads.
* Scales well for large dose matrices and image-processing workloads.

---


## **Chapter 83 — Qt Concurrent (Complete Deep Dive)**

