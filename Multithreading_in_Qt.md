

# **Chapter 13: Multithreading in Qt**

---

## **1. Need for Multithreading**

### **Definition**

**Multithreading** means executing multiple parts of a program **concurrently** using multiple threads within the same process.

---

### **Why multithreading is needed**

In Qt GUI applications:

* The **main (GUI) thread** handles:

  * UI rendering
  * Mouse/keyboard events
* If a long task runs in GUI thread:

  * UI freezes
  * Application becomes “Not Responding”

---

### **Typical Long Tasks**

* File I/O
* Network calls
* Image processing
* Database queries
* Heavy computations

---

### ❌ Without Multithreading (Bad)

```cpp
void MainWindow::onButtonClicked()
{
    heavyComputation();   // UI freezes
}
```

---

### ✅ With Multithreading (Good)

```cpp
// Heavy task moved to worker thread
```

---

## **2. QThread Basics**

### **Definition**

`QThread` represents a **thread of execution** in Qt.

---

### **Why Qt has QThread**

* Platform-independent threading
* Integrated with Qt event loop
* Safe signal-slot communication

---

### **Important Concept (Interview Favorite)**

👉 **QThread is not the worker itself**
👉 **QObject does the work, QThread provides the thread**

---

### **Basic Lifecycle**

1. Create QThread
2. Move worker to thread
3. Start thread
4. Stop and clean up

---

### **Basic Example**

```cpp
QThread *thread = new QThread;
thread->start();
```

---

## **3. Worker Thread Pattern (Best Practice)**

### **Definition**

The **Worker Thread Pattern** separates:

* **Thread management** → QThread
* **Work logic** → QObject (Worker)

---

### **Why this pattern**

* Clean design
* Avoid subclassing QThread
* Recommended by Qt documentation

---

### **How it works**

1. Create Worker class (QObject)
2. Move worker to QThread
3. Connect signals & slots
4. Start thread

---

### **Example – Worker Class**

```cpp
class Worker : public QObject
{
    Q_OBJECT
public slots:
    void doWork() {
        qDebug() << "Working in thread:" << QThread::currentThread();
    }

signals:
    void finished();
};
```

---

### **Using Worker in Main Thread**

```cpp
QThread *thread = new QThread;
Worker *worker = new Worker;

worker->moveToThread(thread);

connect(thread, &QThread::started,
        worker, &Worker::doWork);

connect(worker, &Worker::finished,
        thread, &QThread::quit);

connect(thread, &QThread::finished,
        worker, &QObject::deleteLater);

thread->start();
```

---

## **4. Thread-safe Signals and Slots**

### **Definition**

Qt signals and slots are **thread-safe** when used correctly.

---

### **Why thread safety matters**

* Direct UI access from worker thread causes crashes
* Data races cause undefined behavior

---

### **How Qt ensures safety**

Qt uses **Queued Connections**:

* Signal is placed in event queue
* Slot executes in receiver’s thread

---

### **Example**

```cpp
connect(worker, &Worker::dataReady,
        this, &MainWindow::updateUI,
        Qt::QueuedConnection);
```

👉 Slot runs in **GUI thread**

---

## **5. Mutex and Synchronization**

### **Definition**

**Synchronization** ensures that multiple threads **do not access shared data simultaneously**.

---

### **Why synchronization is needed**

Without synchronization:

* Race conditions
* Corrupted data
* Random crashes

---

### **Shared Resource Example**

```cpp
int counter = 0;  // shared
```

Two threads modifying this → ❌ unsafe

---

## **6. QMutex**

### **Definition**

`QMutex` is a **mutual exclusion lock** that allows **only one thread** to access a resource at a time.

---

### **Why QMutex**

* Protect shared data
* Prevent race conditions

---

### **How QMutex works**

1. Thread locks mutex
2. Access resource
3. Unlock mutex

---

### **Example**

```cpp
QMutex mutex;

void increment()
{
    mutex.lock();
    counter++;
    mutex.unlock();
}
```

---

### **Better (RAII)**

```cpp
QMutexLocker locker(&mutex);
counter++;
```

---

## **7. QSemaphore**

### **Definition**

`QSemaphore` controls access to a resource with a **limited count**.

---

### **Why QSemaphore**

* Producer-consumer problems
* Resource pool management

---

### **How it works**

* `acquire()` → decrease count
* `release()` → increase count

---

### **Example**

```cpp
QSemaphore sem(2);  // allow 2 threads

sem.acquire();
// critical section
sem.release();
```

---

## **8. Thread Pools (QThreadPool)**

### **Definition**

`QThreadPool` manages a **pool of reusable threads**.

---

### **Why thread pools**

* Avoid overhead of creating threads
* Efficient for short tasks
* Automatic thread management

---

### **How it works**

* Threads are reused
* Tasks are queued
* Pool size controlled automatically

---

### **Example**

```cpp
QThreadPool::globalInstance()->setMaxThreadCount(4);
```

---

## **9. QRunnable**

### **Definition**

`QRunnable` represents a **task** that can be executed by a thread pool.

---

### **Why QRunnable**

* Lightweight tasks
* No need to manage thread lifecycle

---

### **How it works**

1. Inherit QRunnable
2. Implement `run()`
3. Submit to thread pool

---

### **Example**

```cpp
class Task : public QRunnable
{
public:
    void run() override {
        qDebug() << "Task running in thread pool";
    }
};
```

Submit task:

```cpp
QThreadPool::globalInstance()->start(new Task);
```

---

## **10. Common Multithreading Issues**

---

### **1. Updating UI from Worker Thread (❌)**

```cpp
ui->label->setText("Hello"); // WRONG
```

✅ Fix:

```cpp
emit updateUI("Hello");
```

---

### **2. Race Conditions**

* Shared data without mutex

---

### **3. Deadlocks**

* Two threads waiting on each other

---

### **4. Forgetting to stop threads**

* Leads to memory leaks or crashes

---

### **5. Blocking GUI Thread**

* Using `sleep()` in main thread

---

## **Interview Questions (Chapter 13)**

**Q: Can we subclass QThread?**
👉 Yes, but **not recommended**

**Q: How to update UI from worker thread?**
👉 Signals & slots (QueuedConnection)

**Q: Difference between QMutex and QSemaphore?**
👉 Mutex = 1 access, Semaphore = N access

**Q: When to use QThreadPool?**
👉 Short, frequent tasks

---

## **Interview Summary (One-liners)**

* GUI runs in main thread
* Heavy tasks → worker thread
* Use QObject + QThread
* Signals/slots are thread-safe
* Protect shared data with mutex
* ThreadPool for short jobs

---
