

## **1. Debugging in Qt Creator**

### **Definition**

Debugging in Qt Creator means **running your application under a debugger** to:

* Pause execution
* Inspect variables
* Step through code
* Find logic and runtime errors

Qt Creator integrates:

* **GDB** (Linux/MinGW)
* **LLDB** (macOS)
* **CDB** (MSVC)

---

### **Why debugging is important**

* Fix crashes
* Understand unexpected behavior
* Validate logic flow
* Diagnose multi-threading issues

---

### **How debugging works**

1. Build project in **Debug mode**
2. Start application in Debug
3. Debugger attaches to process
4. Execution can be paused/stepped

---

### **Example**

Click **Debug ▶** instead of Run ▶
Execution stops at breakpoints.

---

## **2. Breakpoints**

### **Definition**

A **breakpoint** is a marker that **pauses program execution** at a specific line.

---

### **Why breakpoints**

* Inspect program state
* Analyze incorrect behavior
* Avoid adding temporary print statements

---

### **How breakpoints work**

* Debugger halts execution
* Memory and stack are frozen
* Developer inspects state

---

### **Types of Breakpoints**

* Line breakpoint
* Conditional breakpoint
* Function breakpoint

---

### **Example**

```cpp
int sum(int a, int b)
{
    int result = a + b;   // Breakpoint here
    return result;
}
```

Conditional breakpoint:

```text
Pause when a > 100
```

---

## **3. Watch Variables**

### **Definition**

**Watch variables** allow you to **monitor variable values in real time** during debugging.

---

### **Why watch variables**

* Track changing values
* Detect unexpected changes
* Debug loops and conditions

---

### **How watch works**

* Debugger reads memory values
* Updates when execution stops

---

### **Example**

```cpp
int counter = 0;
counter++;
```

Watch:

```text
counter = 1
```

---

### **Advanced Watching**

* Watch expressions:

```text
list.size()
```

---

## **4. Call Stack**

### **Definition**

The **call stack** shows the **sequence of function calls** that led to the current execution point.

---

### **Why call stack matters**

* Trace execution path
* Identify crash origin
* Understand recursion

---

### **How call stack works**

* Each function call is pushed onto stack
* Returned functions pop from stack

---

### **Example**

```cpp
main()
 └── process()
      └── calculate()
           └── crash here
```

---

### **Interview Tip**

> Use call stack to find **where crash originated**, not just where it occurred.

---

## **5. Qt Logging Categories**

### **Definition**

Qt Logging Categories allow you to **group log messages** and **enable/disable them selectively**.

---

### **Why logging categories**

* Control log verbosity
* Filter logs by module
* Reduce noise in production

---

### **How it works**

* Define a logging category
* Use it in logging calls
* Enable/disable at runtime

---

### **Example**

```cpp
#include <QLoggingCategory>

Q_LOGGING_CATEGORY(netLog, "network")
```

Use:

```cpp
qDebug(netLog) << "Connected to server";
```

Enable at runtime:

```bash
QT_LOGGING_RULES="network.debug=true"
```

---

## **6. qDebug(), qWarning(), qCritical()**

---

### **qDebug()**

#### **Definition**

Used for **development-time debug messages**.

```cpp
qDebug() << "Value:" << x;
```

---

### **qWarning()**

#### **Definition**

Used for **non-fatal warnings**.

```cpp
qWarning() << "File not found";
```

---

### **qCritical()**

#### **Definition**

Used for **serious runtime errors**.

```cpp
qCritical() << "Database connection failed";
```

---

### **Why different levels**

* Categorize severity
* Filter logs easily
* Production-ready logging

---

### **Comparison**

| Function  | Severity |
| --------- | -------- |
| qDebug    | Low      |
| qWarning  | Medium   |
| qCritical | High     |

---

## **7. Performance Profiling**

### **Definition**

Performance profiling measures:

* Execution time
* CPU usage
* Memory usage

---

### **Why profiling is important**

* Identify bottlenecks
* Optimize slow code
* Improve user experience

---

### **How profiling is done in Qt**

1. Built-in tools (Analyzer)
2. External tools (Valgrind, Perf)
3. Code-level measurement

---

### **Example – Measure Execution Time**

```cpp
QElapsedTimer timer;
timer.start();

// code to profile
doWork();

qDebug() << "Time:" << timer.elapsed() << "ms";
```

---

### **Memory Profiling**

* Detect leaks
* Monitor allocations
* Use Valgrind / Sanitizers

---

## **Common Debugging Mistakes (Interview Traps)**

❌ Debugging in Release mode
❌ Overusing qDebug in production
❌ Ignoring call stack
❌ Not checking thread context
❌ Logging sensitive data

---

## **Interview Questions (Chapter 20)**

**Q: Difference between Debug and Release builds?**
👉 Debug = symbols, slower; Release = optimized

**Q: How to find crash root cause?**
👉 Use call stack

**Q: How to disable logs in production?**
👉 Logging categories

---

## **Interview Summary (One-liners)**

* Debug mode → inspect code
* Breakpoints → pause execution
* Watch → track variables
* Call stack → trace calls
* Logging categories → control logs
* Profiling → performance tuning

---


