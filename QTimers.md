Excellent. We now begin **Chapter 33 – Timers**, one of the most practical topics in Qt.

Almost every professional Qt application uses timers.

Examples:

* Medical TPS → Auto-save every 5 minutes
* CAD → Cursor blinking, background regeneration
* Automotive HMI → CAN bus status refresh
* Industrial Automation → PLC polling
* Enterprise ERP → Session timeout
* Chat Application → Heartbeat messages
* Media Player → Playback position updates

A common misconception is:

> **"QTimer creates a thread."**

❌ This is **false**.

A `QTimer` is **not** a thread. It is an event source managed by the **event loop** and **event dispatcher**.

---

# Complete Qt Master Course (Qt 5.15 LTS → Qt 6.11)

# PART IV — Application Architecture

# Chapter 33 — Timers (Complete Deep Dive)

## Part 1 — QTimer, Timer Events, startTimer(), killTimer() & Event Loop Integration

> **Level:** Beginner → Advanced

---

# Chapter Objectives

After this chapter, you will understand:

* What timers are
* Why Qt uses timers
* `QTimer`
* `QBasicTimer`
* `QObject::startTimer()`
* `QObject::killTimer()`
* `QTimerEvent`
* Timer lifecycle
* Event loop integration
* Qt 5 vs Qt 6

---

# Table of Contents

1. What is a Timer?
2. Why Timers?
3. Timer Architecture
4. QTimer
5. QBasicTimer
6. QObject Timers
7. QTimerEvent
8. Timer Lifecycle
9. Event Flow
10. Qt5 vs Qt6
11. Best Practices
12. Interview Questions
13. Revision Notes

---

# 1. What is a Timer?

A timer allows code to execute **after a delay** or **at regular intervals**.

Examples:

```text
Every 1 second

↓

Update Clock
```

```text
Every 5 minutes

↓

Auto Save
```

```text
After 3 seconds

↓

Close Splash Screen
```

Qt provides several timer mechanisms.

---

# Timer Family

```text
QObject Timer

↓

QBasicTimer

↓

QTimer

↓

QChronoTimer (Qt 6.8+)
```

> **Note:** `QChronoTimer` was introduced in Qt 6.8 and provides `std::chrono`-based APIs with improved precision and range. We'll cover it in an advanced section.

---

# 2. Why Timers?

Suppose you want:

```text
Update Time

Every Second
```

Without a timer:

```cpp
while(true)
{
    updateClock();
}
```

Problems:

```text
100% CPU

GUI Frozen

Battery Drain
```

---

With a timer:

```text
Wait

↓

1 Second

↓

Timeout Event

↓

updateClock()

↓

Wait
```

Efficient and event-driven.

---

# 3. Timer Architecture

```text
Application
      │
      ▼
QTimer::start()
      │
      ▼
Event Dispatcher
      │
      ▼
Operating System Timer
      │
      ▼
Timeout Event
      │
      ▼
Event Queue
      │
      ▼
QObject
```

---

# Internal Flow

```text
QTimer

↓

Register Timer

↓

Event Dispatcher

↓

Wait

↓

Timeout

↓

QTimerEvent

↓

timeout()
```

The event loop is responsible for delivering timer events.

---

# 4. QTimer

Header

```cpp
#include <QTimer>
```

Module

```text
QtCore
```

---

## Basic Example

```cpp
#include <QApplication>
#include <QLabel>
#include <QTimer>

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);

    QLabel label("Hello");
    label.show();

    QTimer timer;

    QObject::connect(&timer,
                     &QTimer::timeout,
                     [&]()
                     {
                         label.setText(QTime::currentTime().toString());
                     });

    timer.start(1000);

    return app.exec();
}
```

Every second:

```text
timeout()

↓

Lambda

↓

Update Label
```

---

## One-shot Timer

Run only once.

```cpp
QTimer::singleShot(
    3000,
    []()
    {
        qDebug() << "3 Seconds";
    });
```

Flow:

```text
Start

↓

Wait

↓

3 Seconds

↓

Execute

↓

Destroy
```

---

# 5. QBasicTimer

A lightweight timer wrapper.

Header

```cpp
#include <QBasicTimer>
```

Example:

```cpp
class MyWidget : public QWidget
{
    QBasicTimer timer;

protected:
    void timerEvent(QTimerEvent *event) override
    {
        Q_UNUSED(event);
    }
};
```

Start:

```cpp
timer.start(1000, this);
```

Unlike `QTimer`, `QBasicTimer` does **not** emit signals. It delivers events through `timerEvent()`.

---

# QTimer vs QBasicTimer

| Feature             | QTimer     | QBasicTimer      |
| ------------------- | ---------- | ---------------- |
| Signals             | ✔          | ✘                |
| Convenience         | High       | Low              |
| Performance         | Very good  | Slightly lighter |
| Uses `timerEvent()` | Internally | Directly         |

---

# 6. QObject Timers

Every `QObject` supports timers.

Start:

```cpp
int id = startTimer(1000);
```

Stop:

```cpp
killTimer(id);
```

Handle:

```cpp
void timerEvent(QTimerEvent *event) override
{
    Q_UNUSED(event);

    update();
}
```

---

# Internal Flow

```text
startTimer()

↓

Register Timer

↓

Dispatcher

↓

QTimerEvent

↓

timerEvent()
```

---

# 7. QTimerEvent

Header

```cpp
#include <QTimerEvent>
```

Used with:

```cpp
timerEvent()
```

Example:

```cpp
void MyWidget::timerEvent(QTimerEvent *event)
{
    qDebug() << event->timerId();
}
```

Useful API:

```cpp
event->timerId();
```

This identifies which timer fired when multiple timers are active.

---

# 8. Timer Lifecycle

```text
Create Timer

↓

Start

↓

Register

↓

Wait

↓

Timeout

↓

Event Queue

↓

timeout()

↓

Repeat

↓

Stop
```

---

# 9. Event Loop Integration

A timer **does not run by itself**.

It depends on:

```text
QTimer

↓

Event Dispatcher

↓

Event Loop

↓

timeout()
```

Without:

```cpp
app.exec();
```

The timer never fires.

---

# Blocked Event Loop

Suppose:

```cpp
timer.start(1000);

calculateDose(); // 20 seconds
```

Timeline:

```text
Timer Starts

↓

Event Loop Blocked

↓

20 Seconds Pass

↓

timeout() Delayed
```

The timeout cannot be delivered until the event loop resumes.

---

# 10. Thread Affinity

A timer belongs to the thread of the `QObject` that owns it.

```text
GUI Thread

↓

QTimer

↓

GUI Event Loop
```

Worker example:

```text
Worker Thread

↓

QTimer

↓

Worker Event Loop
```

A thread must have a running event loop for its timers to fire.

---

# 11. Qt 5.15 vs Qt 6.11

| Feature      | Qt 5.15 | Qt 6.11 |
| ------------ | ------- | ------- |
| QTimer       | ✔       | ✔       |
| QBasicTimer  | ✔       | ✔       |
| startTimer() | ✔       | ✔       |
| killTimer()  | ✔       | ✔       |
| QTimerEvent  | ✔       | ✔       |

There is **no major functional difference** for these APIs.

Qt 6.8 introduced `QChronoTimer` for modern `std::chrono`-based timing, but existing timer APIs remain fully supported.

---

# 12. Best Practices

✅ Use `QTimer` for most applications.

✅ Use `QBasicTimer` when implementing custom widgets that naturally handle `timerEvent()`.

✅ Stop timers when they are no longer needed.

✅ Keep timeout handlers short.

✅ Move long-running work to worker threads.

---

# 13. Common Mistakes

### ❌ Assuming QTimer creates a thread

It does **not**.

The event loop drives the timer.

---

### ❌ Forgetting to stop timers

```cpp
timer.stop();
```

Unnecessary timers continue generating events.

---

### ❌ Blocking the event loop

```cpp
while(true)
{
}
```

Result:

```text
No timeout()

GUI Frozen
```

---

### ❌ Creating a timer in a thread without an event loop

The timer will never fire because there is no event loop to dispatch timeout events.

---

# 14. Interview Questions

## Easy

1. What is `QTimer`?
2. What is `QBasicTimer`?
3. What is `QTimerEvent`?

---

## Medium

1. Compare `QTimer` and `QBasicTimer`.
2. Explain `startTimer()` and `killTimer()`.
3. Why does `QTimer` require an event loop?

---

## Hard

1. Describe the internal flow of a timer.
2. Why doesn't `QTimer` create a thread?
3. Explain thread affinity for timers.

---

## Expert

1. Design an auto-save system for a Treatment Planning System.
2. Compare `QTimer`, `QBasicTimer`, and `QObject::startTimer()`.
3. Explain how timer events are delivered through the event dispatcher.

---

# 15. Architecture Diagram

```text
          QTimer::start()
                 │
                 ▼
      QAbstractEventDispatcher
                 │
                 ▼
      Operating System Timer
                 │
                 ▼
          Timer Expires
                 │
                 ▼
          QTimerEvent
                 │
                 ▼
          Event Queue
                 │
                 ▼
         timeout() Signal
                 │
                 ▼
          Application Code
```

---

# 🏥 Production Example — Treatment Planning System

```text
Application Starts
        │
        ▼
Auto-save Timer (5 min)
        │
        ▼
timeout()
        │
        ▼
Save Patient
        │
        ▼
Save RT Plan
        │
        ▼
Save RT Structure
        │
        ▼
Write Audit Log
        │
        ▼
Restart Timer
```

This pattern is common in medical software, where periodic automatic saving helps reduce the risk of data loss while ensuring the UI remains responsive.

---

# 16. Revision Notes

* `QTimer` is the most commonly used timer class.
* `QBasicTimer` is a lightweight wrapper around timer events.
* Every `QObject` can use `startTimer()` and `killTimer()`.
* `QTimerEvent` is delivered through the event loop.
* Timers depend on the event dispatcher and event loop.
* `QTimer` does **not** create a thread.
* A timer only fires if the owning thread has a running event loop.

---

Excellent. This is the **advanced timer chapter**.

Understanding this chapter separates a **Qt application developer** from a **Qt framework engineer**.

Many developers assume:

> "If I set a timer to 10 ms, it will fire every 10 ms."

That is **not guaranteed**.

Timer accuracy depends on:

* Operating System scheduler
* CPU load
* Event loop
* Event Dispatcher
* Timer Type
* Thread scheduling
* Hardware clock resolution

Professional applications like:

* Medical TPS
* CAD
* Automotive HMI
* Industrial Automation
* Audio/Video Software

must understand these limitations.

---

# Complete Qt Master Course (Qt 5.15 LTS → Qt 6.11)

# PART IV — Application Architecture

# Chapter 33 — Timers (Complete Deep Dive)

## Part 2 — Timer Accuracy, Timer Types, QChronoTimer, High-Frequency Timers & Performance

> **Level:** Advanced → Expert

---

# Chapter Objectives

After completing this chapter, you will understand:

* Timer accuracy
* Timer types
* `Qt::PreciseTimer`
* `Qt::CoarseTimer`
* `Qt::VeryCoarseTimer`
* Zero-interval timers
* `QChronoTimer`
* High-frequency timers
* Timer drift
* Performance optimization

---

# Table of Contents

1. Timer Accuracy
2. Timer Types
3. Timer Drift
4. Zero-Interval Timers
5. QChronoTimer
6. High-Frequency Timers
7. Timers in Worker Threads
8. Qt Source Code Concepts
9. Qt 5 vs Qt 6
10. Best Practices
11. Interview Questions
12. Revision Notes

---

# 1. Timer Accuracy

Suppose:

```cpp
timer.start(1000);
```

Many developers imagine:

```text
0s
↓

1.000

↓

2.000

↓

3.000
```

Reality:

```text
0.000

↓

1.004

↓

2.011

↓

3.018
```

Because the operating system cannot guarantee exact delivery times.

Qt delivers the timeout when the event loop is able to process it.

---

# Why Delays Occur

```text
Timer Expires

↓

CPU Busy

↓

Event Loop Busy

↓

Timeout Delivered Later
```

Common causes:

* Heavy calculations
* High CPU usage
* Long-running event handlers
* Operating system scheduling

---

# 2. Timer Types

Qt provides three main timer accuracy modes.

```cpp
timer.setTimerType(Qt::PreciseTimer);
```

or

```cpp
timer.setTimerType(Qt::CoarseTimer);
```

---

## Qt::PreciseTimer

Highest accuracy available.

Example:

```cpp
timer.setTimerType(Qt::PreciseTimer);
timer.start(20);
```

Characteristics:

* Tries to fire as close as possible to the requested interval.
* Higher power consumption on some platforms.
* Suitable for animations, scientific visualization, and medical imaging updates.

---

## Qt::CoarseTimer

Default in many situations.

Characteristics:

* Allows the operating system to coalesce timer wake-ups.
* Lower CPU wake-up frequency.
* Better battery life.

Suitable for:

* Auto-save
* Status refresh
* Background polling

---

## Qt::VeryCoarseTimer

Lowest accuracy.

Example:

```cpp
timer.setTimerType(Qt::VeryCoarseTimer);
```

Characteristics:

* May fire with a large tolerance.
* Intended for infrequent tasks.

Examples:

```text
Every Minute

↓

Cleanup

Every Hour

↓

Statistics Upload
```

---

# Comparison

| Timer Type | Accuracy | CPU Usage | Typical Use        |
| ---------- | -------- | --------- | ------------------ |
| Precise    | High     | Higher    | Animation, Imaging |
| Coarse     | Medium   | Medium    | UI Updates         |
| VeryCoarse | Low      | Lowest    | Maintenance Tasks  |

---

# 3. Timer Drift

Suppose:

```cpp
timer.start(100);
```

Expected:

```text
100

200

300

400
```

Reality:

```text
101

204

307

410
```

Small delays accumulate over time.

This is known as **timer drift**.

---

## Why?

```text
Timer

↓

Event Queue

↓

Busy Event Loop

↓

Delayed Processing

↓

Next Timeout
```

The event loop cannot travel back in time to compensate for missed processing.

---

## Long-Running Slot Example

```cpp
void update()
{
    expensiveCalculation(); // 500 ms
}
```

Timer:

```text
100 ms
```

Reality:

```text
Timeout

↓

500 ms Work

↓

Next Timeout Delayed
```

The handler itself delays future executions.

---

# 4. Zero-Interval Timers

Example:

```cpp
timer.start(0);
```

Meaning:

```text
Run As Soon As Possible
```

Not:

```text
Run Continuously
```

Conceptually:

```text
Event Queue

↓

Other Pending Events

↓

Zero Timer

↓

Execute
```

A zero-interval timer fires when control returns to the event loop.

---

## Typical Uses

* Breaking large tasks into smaller chunks.
* Cooperative processing.
* Incremental loading.

---

# Example

Instead of:

```cpp
loadOneMillionImages();
```

Use:

```text
Load 100 Images

↓

Return To Event Loop

↓

Next Timeout

↓

Load Next 100
```

The GUI stays responsive.

---

# 5. QChronoTimer (Qt 6.8+)

Qt 6.8 introduced **`QChronoTimer`**.

It uses C++ `std::chrono` durations.

Example:

```cpp
QChronoTimer timer;

timer.setInterval(std::chrono::milliseconds(250));
```

Advantages:

* Modern C++ API
* Strongly typed durations
* Avoids confusion between milliseconds and other units

---

## Comparison

| Feature     | QTimer               | QChronoTimer  |
| ----------- | -------------------- | ------------- |
| Interval    | Integer milliseconds | `std::chrono` |
| Qt 5        | ✔                    | ✘             |
| Qt 6.8+     | ✔                    | ✔             |
| Type Safety | Medium               | High          |

---

# 6. High-Frequency Timers

Suppose:

```cpp
timer.start(1);
```

Requested:

```text
1000 Times / Second
```

Reality depends on:

* Operating system
* Hardware
* Scheduler
* Event loop load

Do **not** assume a 1 ms timer will fire exactly every millisecond.

---

## Better Design

Instead of:

```text
1000 Updates
```

Use:

```text
60 FPS

↓

Render

↓

Sleep
```

Graphics applications often synchronize rendering with the display rather than relying on extremely short timer intervals.

---

# Medical TPS Example

```text
Dose Viewer

↓

30 FPS

↓

Repaint
```

There is usually no benefit to repainting hundreds of times per second if the display refresh rate is much lower.

---

# 7. Timers in Worker Threads

Timers work in worker threads **only if** the thread has an event loop.

```text
Worker Thread

↓

exec()

↓

Event Loop

↓

Timer Works
```

Without an event loop:

```text
Worker Thread

↓

No Event Loop

↓

Timer Never Fires
```

---

# Example

```cpp
QThread workerThread;

// Move object to workerThread

workerThread.start();
```

Inside the worker object, a timer can function **after** the thread's event loop is running.

---

# 8. Timer Performance

Suppose:

```text
500 Timers
```

Qt manages them efficiently, but:

```text
5000 Timers
```

may introduce unnecessary overhead.

Better:

```text
One Timer

↓

Scheduler

↓

Multiple Jobs
```

Instead of many timers, maintain one timer that dispatches multiple periodic tasks when appropriate.

---

# 9. Qt Source Code Concepts

Conceptually:

```text
QTimer::start()

↓

Register Timer

↓

Dispatcher

↓

Operating System

↓

Wait

↓

Timer Expires

↓

QTimerEvent

↓

timeout()
```

Internally, the dispatcher keeps track of active timers and determines which ones have expired before generating the corresponding timeout events.

---

# 10. Qt 5 vs Qt 6

| Feature         | Qt 5.15 | Qt 6.11     |
| --------------- | ------- | ----------- |
| QTimer          | ✔       | ✔           |
| PreciseTimer    | ✔       | ✔           |
| CoarseTimer     | ✔       | ✔           |
| VeryCoarseTimer | ✔       | ✔           |
| QChronoTimer    | ✘       | ✔ (Qt 6.8+) |

---

# 11. Best Practices

✅ Use `Qt::CoarseTimer` for most background tasks.

✅ Use `Qt::PreciseTimer` only when higher accuracy is required.

✅ Keep timeout handlers lightweight.

✅ Avoid creating thousands of timers.

✅ Use zero-interval timers to split long operations instead of blocking the event loop.

✅ Consider `QChronoTimer` for new Qt 6.8+ projects that already use `std::chrono`.

---

# 12. Common Mistakes

### ❌ Expecting exact timing

```cpp
timer.start(10);
```

This requests an interval of approximately 10 ms—it does not guarantee perfect precision.

---

### ❌ Heavy timeout handlers

```cpp
timeout()

↓

20 Seconds
```

Long-running work blocks subsequent timer events and other GUI events.

---

### ❌ Too many timers

Creating a timer per object when a shared scheduler would suffice.

---

### ❌ Using a precise timer unnecessarily

Higher accuracy can increase wake-ups and power consumption.

---

# 13. Interview Questions

## Easy

1. What is timer drift?
2. What is `Qt::PreciseTimer`?
3. What is `QChronoTimer`?

---

## Medium

1. Compare timer types.
2. Explain zero-interval timers.
3. Why are timers not perfectly accurate?

---

## Hard

1. Explain timer drift in a busy event loop.
2. Compare `QTimer` and `QChronoTimer`.
3. Design a scheduler using a single timer instead of hundreds of timers.

---

## Expert

1. Design a high-performance timer architecture for a Treatment Planning System.
2. Explain how the event dispatcher manages timer expiration.
3. Discuss the trade-offs between accuracy, CPU usage, and battery life.

---

# 14. Architecture Diagram

```text
        QTimer::start()
               │
               ▼
   QAbstractEventDispatcher
               │
               ▼
      Operating System Timer
               │
               ▼
        Timer Expires
               │
               ▼
      Generate QTimerEvent
               │
               ▼
        Event Queue
               │
               ▼
      timeout() Signal
               │
               ▼
      Application Code
```

---

# 🏥 Production Example — Treatment Planning System

```text
Dose Calculation Running
         │
         ▼
Progress Timer (250 ms)
         │
         ▼
timeout()
         │
         ▼
Read Latest Progress
         │
         ▼
Update Progress Bar
         │
         ▼
Return Immediately
```

Notice that the timer does **not** perform the dose calculation itself. It only updates the GUI with the latest progress while the computation continues in a worker thread.

---

# 15. Revision Notes

* Timers are event-driven, not thread-driven.
* Timer accuracy depends on the OS and event loop.
* Qt provides Precise, Coarse, and VeryCoarse timer types.
* Zero-interval timers execute when the event loop is idle enough to process them.
* `QChronoTimer` introduces `std::chrono`-based APIs in Qt 6.8+.
* Worker-thread timers require an event loop.
* Prefer fewer timers with lightweight timeout handlers.

---

# 🎯 Chapter 33 Complete

You now have a complete understanding of **Qt Timers**, including:

* `QTimer`
* `QBasicTimer`
* `QObject::startTimer()`
* `QTimerEvent`
* Timer accuracy
* Timer types
* Timer drift
* Zero-interval timers
* `QChronoTimer`
* Worker-thread timers
* Performance optimization
* Qt 5 → Qt 6 migration

You now understand not only **how to use timers**, but also **how Qt implements and schedules them internally**.

---

# 🚀 Next Chapter

## **Chapter 34 — Thread Affinity (Complete Deep Dive)**

