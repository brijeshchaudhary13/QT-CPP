# Complete Qt Master Course (Qt 5.15 LTS → Qt 6.11)

# PART XI — Multithreading

# Chapter 83 — Qt Concurrent (Complete Deep Dive)

## Master QtConcurrent, QFuture, QFutureWatcher, Parallel Algorithms & High-Level Multithreading

> **Level:** Advanced → Architect

---

# Chapter Objectives

After completing this chapter, you will understand:

* What is Qt Concurrent?
* Why use Qt Concurrent?
* Qt Concurrent Architecture
* `QtConcurrent::run()`
* `QtConcurrent::map()`
* `QtConcurrent::mapped()`
* `QtConcurrent::filter()`
* `QtConcurrent::filtered()`
* `QtConcurrent::mappedReduced()`
* `QFuture`
* `QFutureWatcher`
* Progress Reporting
* Cancellation
* Exception Handling Considerations
* Enterprise Applications
* Qt Internals
* Qt 5.15 vs Qt 6.11
* Best Practices
* Interview Questions

---

# Table of Contents

1. Introduction
2. Why Qt Concurrent?
3. Architecture
4. QtConcurrent::run()
5. QFuture
6. QFutureWatcher
7. map()
8. mapped()
9. filter() & filtered()
10. mappedReduced()
11. Progress Reporting
12. Cancellation
13. Performance Considerations
14. Enterprise Applications
15. Qt Internals
16. Qt 5 vs Qt 6
17. Best Practices
18. Common Mistakes
19. Interview Questions
20. Revision Notes

---

# 1. Introduction

**Qt Concurrent** is a high-level multithreading framework built on top of **QThreadPool**.

Instead of manually creating:

* `QThread`
* Worker Objects
* `QRunnable`

you simply tell Qt **what** work should be done.

Qt decides:

* Which thread executes it
* When it runs
* How tasks are scheduled

---

## Architecture

```text id="qc01"
Application

↓

Qt Concurrent

↓

QThreadPool

↓

Worker Threads
```

---

# 2. Why Qt Concurrent?

Without Qt Concurrent

```text id="qc02"
Create Thread

↓

Move Worker

↓

Connect Signals

↓

Manage Lifetime
```

---

With Qt Concurrent

```text id="qc03"
QtConcurrent::run()

↓

Done
```

Far less boilerplate.

---

## Best Use Cases

* Image processing
* File conversion
* Mathematical computation
* Batch operations
* Parallel algorithms

---

# 3. Architecture

```text id="qc04"
Application

↓

Qt Concurrent

↓

QFuture

↓

QThreadPool
```

Results are returned using `QFuture`.

---

# 4. QtConcurrent::run()

Simplest API.

Example

```cpp id="qc05"
auto future =
QtConcurrent::run(
heavyFunction);
```

Function executes in the background.

GUI continues.

---

Passing parameters

```cpp id="qc06"
auto future =
QtConcurrent::run(
calculateDose,
beam,
patient);
```

---

Using lambdas

```cpp id="qc07"
auto future =
QtConcurrent::run(
[]
{
    doWork();
});
```

---

Workflow

```text id="qc08"
QtConcurrent::run()

↓

Thread Pool

↓

Result
```

---

# 5. QFuture

A `QFuture<T>` represents the eventual result of an asynchronous computation.

Example

```cpp id="qc09"
QFuture<int> future;
```

Get result

```cpp id="qc10"
int value =
future.result();
```

Check completion

```cpp id="qc11"
future.isFinished();
```

Wait

```cpp id="qc12"
future.waitForFinished();
```

> Avoid `waitForFinished()` in the GUI thread because it blocks the user interface.

---

## Future Lifecycle

```text id="qc13"
Started

↓

Running

↓

Finished

↓

Result
```

---

# 6. QFutureWatcher

`QFutureWatcher` notifies your application when a `QFuture` changes state.

Header

```cpp id="qc14"
#include <QFutureWatcher>
```

Example

```cpp id="qc15"
QFutureWatcher<int>
watcher;
```

Associate future

```cpp id="qc16"
watcher.setFuture(
future);
```

Signals

| Signal                 | Purpose          |
| ---------------------- | ---------------- |
| started()              | Task started     |
| finished()             | Task completed   |
| canceled()             | Task canceled    |
| progressValueChanged() | Progress updated |

---

Workflow

```text id="qc17"
Future

↓

Watcher

↓

Signal

↓

GUI
```

---

# 7. map()

`map()` modifies every element **in place**.

Example

Before

```text id="qc18"
1

2

3
```

After

```text id="qc19"
2

4

6
```

Each element is processed in parallel.

---

Applications

* Image pixels
* Dose voxels
* CAD vertices

---

# 8. mapped()

`mapped()` creates a **new collection**.

Example

Input

```text id="qc20"
1

2

3
```

Output

```text id="qc21"
1²

2²

3²
```

Original collection remains unchanged.

---

Comparison

| Function | Modifies Input |
| -------- | -------------- |
| map()    | ✔              |
| mapped() | ✘              |

---

# 9. filter() & filtered()

`filter()` removes unwanted elements **in place**.

Example

```text id="qc22"
1

2

3

4
```

Remove odd values

```text id="qc23"
2

4
```

---

`filtered()`

Creates a new filtered collection.

Original remains unchanged.

---

Applications

* Remove invalid DICOM slices
* Filter empty contours
* Ignore disconnected devices

---

# 10. mappedReduced()

A two-stage algorithm.

Stage 1

Map

```text id="qc24"
Input

↓

Transform
```

Stage 2

Reduce

```text id="qc25"
Mapped Results

↓

Single Result
```

Example

```text id="qc26"
Dose Voxels

↓

Dose Contribution

↓

Total Dose
```

This pattern is useful for statistics, reductions, and aggregations.

---

# 11. Progress Reporting

Qt Concurrent supports progress notifications.

```text id="qc27"
0%

↓

20%

↓

40%

↓

60%

↓

100%
```

Using

```cpp id="qc28"
QFutureWatcher
```

Signal

```cpp id="qc29"
progressValueChanged()
```

Update

```text id="qc30"
Progress Bar
```

---

# 12. Cancellation

Some Qt Concurrent operations support cancellation.

```cpp id="qc31"
future.cancel();
```

Workflow

```text id="qc32"
Running

↓

Cancel

↓

Finished
```

> Cancellation is cooperative. Whether a task can actually stop depends on the specific Qt Concurrent algorithm and whether the running code periodically checks for cancellation.

---

# 13. Performance Considerations

Qt Concurrent uses

```text id="qc33"
QThreadPool
```

internally.

Advantages

* Thread reuse
* Automatic scheduling
* Parallel execution

---

Not ideal for

* Long-lived worker objects
* Tasks requiring a thread event loop
* Complex thread affinity requirements

For those cases,

use `QThread`.

---

# 14. Enterprise Applications

## Medical TPS

```text id="qc34"
Dose Grid

↓

Qt Concurrent

↓

Parallel Calculation
```

---

## CAD

```text id="qc35"
Vertices

↓

Parallel

↓

Normals
```

---

## Image Viewer

```text id="qc36"
Images

↓

Parallel Filters
```

---

## ERP

```text id="qc37"
Reports

↓

Parallel Generation
```

---

# 15. Qt Internals

```text id="qc38"
Qt Concurrent

↓

QFuture

↓

QThreadPool

↓

Worker Threads
```

Execution

```text id="qc39"
Task

↓

Thread Pool

↓

Future

↓

Watcher

↓

GUI
```

Qt Concurrent is built on top of the thread pool rather than creating dedicated threads for each operation.

---

# 16. Qt 5 vs Qt 6

| Feature             | Qt 5.15 | Qt 6.11 |
| ------------------- | ------- | ------- |
| QtConcurrent::run() | ✔       | ✔       |
| map()               | ✔       | ✔       |
| mapped()            | ✔       | ✔       |
| filtered()          | ✔       | ✔       |
| mappedReduced()     | ✔       | ✔       |
| QFuture             | ✔       | ✔       |
| QFutureWatcher      | ✔       | ✔       |

Qt 6 introduces improvements in the broader concurrency APIs, but the core Qt Concurrent programming model remains familiar.

---

# 17. Best Practices

✅ Use Qt Concurrent for independent, parallel computations.

✅ Use `QFutureWatcher` for GUI notifications.

✅ Avoid blocking the GUI with `waitForFinished()`.

✅ Prefer `mappedReduced()` for parallel reductions.

✅ Profile before optimizing.

---

# 18. Common Mistakes

### ❌ Using Qt Concurrent for everything

Use `QThread` when you need long-lived workers or event loops.

---

### ❌ Blocking on `future.result()`

Retrieve results asynchronously when possible.

---

### ❌ Updating widgets inside concurrent tasks

Return data to the GUI thread first.

---

### ❌ Sharing mutable state without synchronization

Protect shared resources.

---

### ❌ Launching tiny tasks excessively

Very small tasks may spend more time in scheduling than in useful work.

---

# 19. Interview Questions

## Easy

1. What is Qt Concurrent?
2. What is `QFuture`?
3. What is `QFutureWatcher`?

---

## Medium

1. Explain `QtConcurrent::run()`.
2. Compare `map()` and `mapped()`.
3. What does `mappedReduced()` do?

---

## Hard

1. Explain how Qt Concurrent uses `QThreadPool`.
2. When should you choose `QThread` instead of Qt Concurrent?
3. Design a parallel image-processing pipeline.

---

## Expert

1. Design a parallel dose-calculation engine for a Treatment Planning System using `mappedReduced()`.
2. Compare `QThread`, `QThreadPool`, `QtConcurrent`, and C++ Standard Library concurrency facilities for enterprise Qt software.
3. Explain the trade-offs between task-based parallelism and thread-based programming.

---

# 20. Revision Notes

* Qt Concurrent is a high-level parallel programming framework.
* It uses `QThreadPool` internally.
* `QtConcurrent::run()` executes functions asynchronously.
* `QFuture` represents asynchronous results.
* `QFutureWatcher` reports progress and completion.
* `map()` modifies collections in place.
* `mapped()` creates new collections.
* `filtered()` creates filtered collections.
* `mappedReduced()` combines parallel mapping with reduction.
* Qt Concurrent simplifies many parallel programming tasks.

---

# 💡 Senior Engineer Tips

## Choosing the Right Tool

| Requirement                      | Recommended                        |
| -------------------------------- | ---------------------------------- |
| Long-running worker with signals | `QThread` + Worker                 |
| Many short tasks                 | `QThreadPool`                      |
| Simple background function       | `QtConcurrent::run()`              |
| Parallel collection processing   | `QtConcurrent::map()` / `mapped()` |
| Parallel aggregation             | `QtConcurrent::mappedReduced()`    |

---

## Enterprise Architecture

```text id="qc40"
GUI
 │
 ▼
Task Manager
 │
 ├──────────────┬──────────────┐
 ▼              ▼              ▼
QtConcurrent  QFuture     QFutureWatcher
 │              │              │
 └──────────────┼──────────────┘
                ▼
          Thread Pool
                ▼
           CPU Cores
```

The **Task Manager** coordinates background computations and updates the UI only through `QFutureWatcher` notifications.

---

## Medical TPS Example

```text id="qc41"
Dose Matrix
      │
      ▼
Divide Into Tiles
      │
 ┌────┼────┬────┬────┐
 ▼    ▼    ▼    ▼
Tile1 Tile2 Tile3 Tile4
 │    │    │    │
 └────┼────┴────┘
      ▼
QtConcurrent::mappedReduced()
      │
      ▼
Combined Dose Matrix
      │
      ▼
DVH Calculation
      │
      ▼
GUI Update
```

This architecture:

* Utilizes all available CPU cores.
* Minimizes thread-management code.
* Scales well for computationally intensive medical imaging workloads.

---

# 🎯 Chapter 83 Complete

You now understand:

* Qt Concurrent architecture
* `QtConcurrent::run()`
* `map()`, `mapped()`, `filtered()`
* `mappedReduced()`
* `QFuture`
* `QFutureWatcher`
* Progress reporting
* Cancellation
* Performance considerations
* Enterprise parallel programming
* Qt 5.15 vs Qt 6.11 compatibility

This chapter completes the high-level parallel programming facilities provided by Qt.

---

# 🚀 Next Chapter

## **Chapter 84 — Synchronization (Complete Deep Dive)**

