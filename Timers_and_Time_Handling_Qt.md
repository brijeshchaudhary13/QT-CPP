## **1. QTimer**

### **Definition**

`QTimer` is a Qt class used to **execute code after a specified interval** or **repeatedly at fixed intervals**.

It works using the **Qt event loop**.

---

### **Why QTimer is needed**

* GUI updates (clocks, progress bars)
* Periodic tasks (polling, refresh)
* Delayed execution
* Avoid blocking threads with `sleep()`

---

### **How QTimer works**

1. Timer is started with interval (ms)
2. Timer generates timeout events
3. `timeout()` signal is emitted
4. Connected slot executes

---

### **Basic Example**

```cpp
QTimer *timer = new QTimer(this);

connect(timer, &QTimer::timeout, this, [](){
    qDebug() << "Timer tick";
});

timer->start(1000);  // 1 second
```

---

## **2. Single-shot Timers**

### **Definition**

A **single-shot timer** fires **only once** after a specified delay.

---

### **Why single-shot timers**

* Delay an action
* Splash screens
* Deferred initialization
* One-time notifications

---

### **How it works**

* Timer runs once
* Stops automatically after timeout

---

### **Example (Static Method)**

```cpp
QTimer::singleShot(2000, this, [](){
    qDebug() << "Executed after 2 seconds";
});
```

---

### **Example (Object-based)**

```cpp
QTimer *timer = new QTimer(this);
timer->setSingleShot(true);
timer->start(3000);
```

---

## **3. Repeating Timers**

### **Definition**

A **repeating timer** fires **continuously** at regular intervals until stopped.

---

### **Why repeating timers**

* Clock updates
* Sensor polling
* Background monitoring
* Animations

---

### **How it works**

* `setSingleShot(false)` (default)
* Timer runs until `stop()` is called

---

### **Example**

```cpp
QTimer *timer = new QTimer(this);
timer->start(1000);   // repeats every 1 second
```

Stop:

```cpp
timer->stop();
```

---

## **4. QDate**

### **Definition**

`QDate` represents a **calendar date** (year, month, day).

---

### **Why QDate**

* Platform-independent date handling
* Built-in validation
* Formatting support

---

### **How QDate works**

* Stores date values
* Supports comparisons
* Supports arithmetic

---

### **Example**

```cpp
QDate today = QDate::currentDate();
qDebug() << today.toString("dd-MM-yyyy");
```

---

### **Date Arithmetic**

```cpp
QDate nextWeek = today.addDays(7);
```

---

## **5. QTime**

### **Definition**

`QTime` represents a **time of day** (hours, minutes, seconds).

---

### **Why QTime**

* Clock display
* Time comparisons
* Scheduling

---

### **How QTime works**

* Stores time
* Supports formatting and arithmetic

---

### **Example**

```cpp
QTime now = QTime::currentTime();
qDebug() << now.toString("hh:mm:ss");
```

---

### **Add Time**

```cpp
QTime later = now.addSecs(3600);  // +1 hour
```

---

## **6. QDateTime**

### **Definition**

`QDateTime` represents **date + time together**.

---

### **Why QDateTime**

* Logging
* Timestamps
* Scheduling
* Time zone handling

---

### **How QDateTime works**

* Combines QDate and QTime
* Supports UTC & local time
* Supports time zones

---

### **Example**

```cpp
QDateTime dt = QDateTime::currentDateTime();
qDebug() << dt.toString(Qt::ISODate);
```

---

### **UTC Time**

```cpp
QDateTime utc = QDateTime::currentDateTimeUtc();
```

---

## **7. Measuring Execution Time**

---

### **Why measure execution time**

* Performance optimization
* Identify slow functions
* Real-time constraints

---

### **Method 1: QElapsedTimer (Recommended)**

#### **Definition**

`QElapsedTimer` measures **elapsed time with high precision**.

---

#### **Example**

```cpp
QElapsedTimer timer;
timer.start();

// Code to measure
for (int i = 0; i < 1000000; i++) {}

qDebug() << "Elapsed:" << timer.elapsed() << "ms";
```

---

### **Method 2: QTime**

```cpp
QTime t;
t.start();

// code
qDebug() << t.elapsed();
```

---

## **Common Mistakes (Interview Traps)**

❌ Using `sleep()` in GUI thread
❌ Creating QTimer without event loop
❌ Forgetting to stop repeating timers
❌ Using QTime for performance-critical measurement

---

## **Interview Questions (Chapter 14)**

**Q: Difference between QTimer and sleep()?**
👉 QTimer is non-blocking, sleep blocks thread

**Q: Best class to measure execution time?**
👉 QElapsedTimer

**Q: Can QTimer run in worker thread?**
👉 Yes, if event loop exists

---

## **Interview Summary (One-liners)**

* QTimer → event-based timing
* Single-shot → one-time delay
* Repeating → periodic execution
* QDate/QTime → date & time
* QDateTime → timestamp
* QElapsedTimer → performance

---

