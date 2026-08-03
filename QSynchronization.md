# Complete Qt Master Course (Qt 5.15 LTS → Qt 6.11)

# PART XI — Multithreading

# Chapter 84 — Synchronization (Complete Deep Dive)

## Master QMutex, QReadWriteLock, QSemaphore, QWaitCondition, Atomics & Thread-Safe Qt Programming

> **Level:** Advanced → Architect

---

# Chapter Objectives

After completing this chapter, you will understand:

* What is Synchronization?
* Race Conditions
* Critical Sections
* `QMutex`
* `QMutexLocker`
* `QRecursiveMutex`
* `QReadWriteLock`
* `QReadLocker`
* `QWriteLocker`
* `QSemaphore`
* `QWaitCondition`
* `QAtomicInteger`
* `QAtomicPointer`
* Memory Ordering Concepts
* Deadlocks
* Lock Contention
* Enterprise Thread Safety
* Qt Internals
* Qt 5.15 vs Qt 6.11
* Best Practices
* Interview Questions

---

# Table of Contents

1. Introduction
2. Why Synchronization?
3. Race Conditions
4. Critical Sections
5. QMutex
6. QMutexLocker
7. QRecursiveMutex
8. QReadWriteLock
9. QSemaphore
10. QWaitCondition
11. QAtomicInteger & QAtomicPointer
12. Deadlocks
13. Lock Contention
14. Enterprise Applications
15. Qt Internals
16. Qt 5 vs Qt 6
17. Best Practices
18. Common Mistakes
19. Interview Questions
20. Revision Notes

---

# 1. Introduction

Multiple threads often share the same data.

Example:

```text id="sync01"
GUI Thread

↓

Patient List

↑

Dose Thread
```

If both threads modify the list simultaneously, the program may produce incorrect results or crash.

Synchronization coordinates access to shared resources.

---

# 2. Why Synchronization?

Suppose two threads increment the same variable.

Without synchronization

```text id="sync02"
Counter = 5

↓

Thread A Reads 5

↓

Thread B Reads 5

↓

Thread A Writes 6

↓

Thread B Writes 6
```

Expected

```text
7
```

Actual

```text
6
```

This is a **race condition**.

---

# 3. Race Conditions

A race condition occurs when:

* Multiple threads access shared data.
* At least one thread modifies it.
* Access is not synchronized.

Example

```text id="sync03"
Thread A

↓

Shared Object

↑

Thread B
```

Race conditions often produce intermittent bugs that are difficult to reproduce.

---

## Real Example

```cpp id="sync04"
counter++;
```

This is **not** an atomic operation.

Internally

```text id="sync05"
Read

↓

Modify

↓

Write
```

Another thread can interfere between these steps.

---

# 4. Critical Sections

A **critical section** is code that must not execute simultaneously in multiple threads.

Example

```text id="sync06"
Thread A

↓

Critical Section

↓

Thread B Waits
```

Synchronization primitives protect critical sections.

---

# 5. QMutex

`QMutex` provides **mutual exclusion**.

Header

```cpp id="sync07"
#include <QMutex>
```

Create

```cpp id="sync08"
QMutex mutex;
```

Lock

```cpp id="sync09"
mutex.lock();
```

Unlock

```cpp id="sync10"
mutex.unlock();
```

Workflow

```text id="sync11"
Lock

↓

Critical Section

↓

Unlock
```

Only one thread can hold the mutex at a time.

---

## tryLock()

Instead of blocking,

```cpp id="sync12"
if(mutex.tryLock())
{
    ...
}
```

Useful when work can be skipped or retried later.

---

# 6. QMutexLocker

Manual locking is error-prone.

Bad

```cpp id="sync13"
mutex.lock();

/* exception or early return */

mutex.unlock();
```

Unlock may never execute.

---

Better

```cpp id="sync14"
QMutexLocker locker(
    &mutex);
```

When the locker object goes out of scope,

the mutex is automatically released.

This follows the **RAII (Resource Acquisition Is Initialization)** pattern.

---

Workflow

```text id="sync15"
Create Locker

↓

Lock

↓

Scope Ends

↓

Unlock
```

---

# 7. QRecursiveMutex

Normally,

locking the same mutex twice from the same thread causes a deadlock.

`QRecursiveMutex` allows the owning thread to lock it multiple times.

```text id="sync16"
Thread

↓

Lock

↓

Lock Again

↓

Allowed
```

Use sparingly.

Often it indicates a design that can be simplified.

---

# 8. QReadWriteLock

Many applications have:

* Many readers
* Few writers

Example

```text id="sync17"
Reader A

Reader B

Reader C

↓

Shared Data
```

Multiple readers may proceed together.

A writer requires exclusive access.

---

Create

```cpp id="sync18"
QReadWriteLock lock;
```

Read lock

```cpp id="sync19"
lock.lockForRead();
```

Write lock

```cpp id="sync20"
lock.lockForWrite();
```

---

RAII Helpers

```cpp id="sync21"
QReadLocker readLocker(&lock);
```

```cpp id="sync22"
QWriteLocker writeLocker(&lock);
```

---

Comparison

| Operation     | Allowed Together |
| ------------- | ---------------- |
| Read + Read   | ✔                |
| Read + Write  | ✘                |
| Write + Write | ✘                |

---

# 9. QSemaphore

A semaphore controls access to a limited number of resources.

Example

```text id="sync23"
Printer Pool

3 Printers

↓

Semaphore
```

Acquire

```cpp id="sync24"
semaphore.acquire();
```

Release

```cpp id="sync25"
semaphore.release();
```

---

Example

```text id="sync26"
Resource Count

↓

Acquire

↓

Work

↓

Release
```

Applications

* Connection pools
* Resource pools
* Producer-consumer systems

---

# 10. QWaitCondition

Sometimes,

a thread should wait until another thread signals it.

Workflow

```text id="sync27"
Worker

↓

Wait

↓

Signal

↓

Continue
```

Create

```cpp id="sync28"
QWaitCondition condition;
```

Wait

```cpp id="sync29"
condition.wait(&mutex);
```

Wake one

```cpp id="sync30"
condition.wakeOne();
```

Wake all

```cpp id="sync31"
condition.wakeAll();
```

---

Typical Producer–Consumer Flow

```text id="sync32"
Producer

↓

Add Item

↓

Wake Consumer

↓

Consumer Continues
```

---

# 11. QAtomicInteger & QAtomicPointer

Some operations do not require a mutex.

Example

```cpp id="sync33"
QAtomicInteger<int> counter;
```

Increment

```cpp id="sync34"
counter.fetchAndAddRelaxed(1);
```

Advantages

* Very fast
* Lock-free on many platforms
* Suitable for simple shared state

---

`QAtomicPointer`

```cpp id="sync35"
QAtomicPointer<MyObject>
pointer;
```

Useful for atomically updating shared pointers (not a replacement for smart pointers).

---

## Memory Ordering Concepts

Modern CPUs may reorder memory operations for performance.

Qt provides different atomic memory ordering semantics such as:

* Relaxed
* Acquire
* Release
* Ordered (where supported)

Choose the weakest ordering that still guarantees correctness.

For many applications, higher-level synchronization primitives (`QMutex`, `QReadWriteLock`) are easier and safer.

---

# 12. Deadlocks

Deadlock example

```text id="sync36"
Thread A

Lock A

↓

Needs Lock B

------------------

Thread B

Lock B

↓

Needs Lock A
```

Neither thread can continue.

---

## Prevention

* Lock resources in a consistent order.
* Keep locks for the shortest possible time.
* Avoid nested locking when practical.
* Prefer RAII (`QMutexLocker`).

---

# 13. Lock Contention

Too many threads competing for one lock reduces performance.

```text id="sync37"
Many Threads

↓

One Mutex

↓

Waiting
```

Solutions

* Reduce shared state.
* Use finer-grained locks.
* Use `QReadWriteLock` where appropriate.
* Consider lock-free techniques for simple operations.

---

# 14. Enterprise Applications

## Medical TPS

```text id="sync38"
Dose Matrix

↓

Mutex

↓

Worker Threads
```

---

## DICOM Database

```text id="sync39"
Readers

↓

ReadWriteLock

↓

Database Cache
```

---

## CAD

```text id="sync40"
Geometry Cache

↓

Synchronization
```

---

## ERP

```text id="sync41"
Connection Pool

↓

Semaphore
```

---

# 15. Qt Internals

```text id="sync42"
Thread

↓

Mutex

↓

Operating System

↓

Scheduler
```

Qt synchronization primitives are implemented using efficient platform-specific operating system mechanisms.

---

## Event Loop Interaction

Avoid holding locks while:

* Waiting for user input
* Performing slow network operations
* Executing lengthy disk I/O

Long-held locks reduce concurrency.

---

# 16. Qt 5 vs Qt 6

| Feature         | Qt 5.15 | Qt 6.11 |
| --------------- | ------- | ------- |
| QMutex          | ✔       | ✔       |
| QMutexLocker    | ✔       | ✔       |
| QRecursiveMutex | ✔       | ✔       |
| QReadWriteLock  | ✔       | ✔       |
| QSemaphore      | ✔       | ✔       |
| QWaitCondition  | ✔       | ✔       |
| QAtomicInteger  | ✔       | ✔       |

The synchronization APIs are highly compatible between Qt 5 and Qt 6.

---

# 17. Best Practices

✅ Use `QMutexLocker` instead of manual locking.

✅ Keep critical sections short.

✅ Prefer `QReadWriteLock` for read-heavy workloads.

✅ Use atomics for simple counters and flags.

✅ Lock resources in a consistent order.

---

# 18. Common Mistakes

### ❌ Forgetting to unlock

Use RAII.

---

### ❌ Holding locks too long

Release locks as soon as possible.

---

### ❌ Using `QRecursiveMutex` unnecessarily

It may hide design problems.

---

### ❌ Protecting unrelated data with one mutex

Separate independent resources.

---

### ❌ Assuming atomics replace mutexes

Atomics are suitable only for specific operations.

---

# 19. Interview Questions

## Easy

1. What is a race condition?
2. What is `QMutex`?
3. What is a critical section?

---

## Medium

1. Explain `QMutexLocker`.
2. What is `QReadWriteLock`?
3. What is a semaphore?

---

## Hard

1. Compare mutexes, semaphores, and atomics.
2. Explain `QWaitCondition`.
3. How do deadlocks occur?

---

## Expert

1. Design the synchronization strategy for a Treatment Planning System where multiple worker threads update shared dose data while the GUI reads progress.
2. Explain lock contention and techniques to reduce it.
3. Compare `QMutex`, `std::mutex`, `QReadWriteLock`, and lock-free programming for enterprise Qt applications.

---

# 20. Revision Notes

* Synchronization prevents race conditions.
* `QMutex` provides mutual exclusion.
* `QMutexLocker` automatically unlocks via RAII.
* `QRecursiveMutex` allows recursive locking by the owning thread.
* `QReadWriteLock` supports multiple readers.
* `QSemaphore` controls access to limited resources.
* `QWaitCondition` coordinates waiting threads.
* `QAtomicInteger` enables efficient atomic operations.
* Keep locks short and consistent.
* Avoid deadlocks and unnecessary contention.

---

# 💡 Senior Engineer Tips

## Which Synchronization Primitive Should You Use?

| Requirement           | Recommended      |
| --------------------- | ---------------- |
| Protect shared object | `QMutex`         |
| Automatic unlock      | `QMutexLocker`   |
| Read-heavy cache      | `QReadWriteLock` |
| Resource pool         | `QSemaphore`     |
| Thread signaling      | `QWaitCondition` |
| Shared counter        | `QAtomicInteger` |

---

## Enterprise Synchronization Architecture

```text id="sync43"
GUI Thread
      │
      ▼
Shared Cache
      │
 ┌────┼───────────┐
 ▼    ▼           ▼
Reader Reader   Writer
 │    │           │
 └────┼───────────┘
      ▼
QReadWriteLock
```

This design allows many readers while ensuring exclusive access for updates.

---

## Medical TPS Example

```text id="sync44"
Dose Engine Threads
        │
 ┌──────┼────────┬────────┐
 ▼      ▼        ▼        ▼
Tile1  Tile2    Tile3    Tile4
        │
        ▼
 Shared Dose Matrix
        │
   QReadWriteLock
        │
        ▼
 DVH Calculation
        │
        ▼
 GUI Progress
```

Possible synchronization strategy:

* `QReadWriteLock` protects the shared dose matrix.
* `QAtomicInteger` tracks completed tiles.
* `QWaitCondition` coordinates producer-consumer stages.
* `QMutexLocker` protects short critical sections.

This minimizes contention while maintaining correctness.

---



## **Chapter 85 — Producer–Consumer Pattern (Complete Deep Dive)**

