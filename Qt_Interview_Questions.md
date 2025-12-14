## **1. Qt vs MFC**

### **Definition**

* **Qt** is a **cross-platform C++ application framework**.
* **MFC (Microsoft Foundation Classes)** is a **Windows-only C++ framework** built on Win32.

---

### **Why interviewers ask this**

They want to check:

* Platform understanding
* Modern vs legacy frameworks
* Architecture and maintainability thinking

---

### **How they differ (Core Concepts)**

| Aspect         | Qt                      | MFC                 |
| -------------- | ----------------------- | ------------------- |
| Platform       | Cross-platform          | Windows only        |
| UI             | Widgets / QML           | Win32 wrappers      |
| Architecture   | Signals & Slots         | Message maps        |
| Memory mgmt    | Parent–child            | Manual              |
| Modern C++     | Strong                  | Weak                |
| Industry usage | Medical, Auto, Embedded | Legacy Windows apps |

---

### **Example**

Qt:

```cpp
connect(button, &QPushButton::clicked,
        this, &MainWindow::onClick);
```

MFC:

```cpp
ON_BN_CLICKED(IDC_BUTTON1, OnButtonClick)
```

👉 **Qt is cleaner, loosely coupled, and portable**.

---

### **Interview Answer (Short)**

> Qt is cross-platform and modern, while MFC is Windows-specific and legacy.

---

## **2. Signals vs Callbacks**

### **Definition**

* **Callback**: A function pointer called directly.
* **Signal–Slot**: Qt’s **event-based communication mechanism**.

---

### **Why Qt avoids callbacks**

Callbacks cause:

* Tight coupling
* Hard-to-maintain code
* Thread-safety issues

Qt solves this with **signals & slots**.

---

### **How Signals & Slots work**

1. Signal is emitted
2. Qt checks connections
3. Slot is invoked (direct or queued)

---

### **Example**

**Callback style (❌)**

```cpp
void (*cb)();
cb();
```

**Qt Signal–Slot (✅)**

```cpp
connect(worker, &Worker::finished,
        this, &MainWindow::onFinished);
```

---

### **Key Advantage**

* Thread-safe
* Type-safe
* Decoupled

---

### **Interview One-liner**

> Signals & slots are safer and loosely coupled compared to callbacks.

---

## **3. Event Loop Explanation**

### **Definition**

The **event loop** is a loop that **continuously processes events** like:

* Mouse clicks
* Key presses
* Timers
* Network events

---

### **Why event loop is critical**

Without it:

* GUI freezes
* No user interaction
* No timers or signals

---

### **How it works internally**

```text
OS Event
 ↓
Qt Event Queue
 ↓
Event Loop (app.exec())
 ↓
QObject::event()
 ↓
Specific handler (mousePressEvent, etc.)
```

---

### **Example**

```cpp
return app.exec();  // starts event loop
```

---

### **Common Interview Trap**

**Q:** What happens if event loop is blocked?
**A:** UI freezes and app becomes unresponsive.

---

## **4. QObject Memory Management**

### **Definition**

Qt uses **parent–child ownership** to manage memory automatically.

---

### **Why Qt uses this**

Manual `delete`:

* Error-prone
* Causes leaks & crashes

Qt:

* Deletes children when parent is deleted

---

### **How it works**

```cpp
QObject *parent = new QObject();
QObject *child = new QObject(parent);

delete parent;  // child deleted automatically
```

---

### **deleteLater()**

Used when object lives in:

* Event loop
* Another thread

```cpp
object->deleteLater();
```

---

### **Interview One-liner**

> QObject uses hierarchical ownership to prevent memory leaks.

---

## **5. Thread Safety in Qt**

### **Definition**

Thread safety ensures **correct behavior when multiple threads run concurrently**.

---

### **Why thread safety matters**

* GUI must run in main thread
* Worker threads must not touch UI
* Race conditions cause crashes

---

### **How Qt ensures safety**

* Queued signal-slot connections
* Thread-aware event delivery
* Synchronization primitives

---

### **Correct UI update**

```cpp
connect(worker, &Worker::dataReady,
        this, &MainWindow::updateUI,
        Qt::QueuedConnection);
```

---

### **Wrong (❌)**

```cpp
ui->label->setText("Done"); // from worker thread
```

---

### **Interview Answer**

> Qt ensures thread safety using queued signal-slot communication.

---

## **6. QString vs std::string**

### **Definition**

* `QString`: Qt Unicode string class
* `std::string`: STL byte string

---

### **Why QString exists**

* Unicode by default
* Internationalization
* Tight Qt integration

---

### **How they differ**

| Feature             | QString         | std::string       |
| ------------------- | --------------- | ----------------- |
| Unicode             | Yes             | No                |
| Qt APIs             | Native          | Conversion needed |
| Performance (ASCII) | Slightly slower | Faster            |

---

### **Example**

```cpp
QString qs = "Qt";
std::string s = qs.toStdString();
```

---

### **Interview Rule**

> Use `QString` inside Qt, `std::string` for STL / low-level logic.

---

## **7. Common Qt Bugs**

### **Definition**

Recurring mistakes developers make when using Qt.

---

### **Why interviewers ask**

They want **real-world experience**, not theory.

---

### **Common Bugs & Causes**

#### ❌ UI updated from worker thread

Cause: Thread misuse

#### ❌ App fails with “platform plugin” error

Cause: Missing `platforms/` folder

#### ❌ Signals not working

Cause:

* Missing `Q_OBJECT`
* moc not run

#### ❌ Memory leak

Cause:

```cpp
new QWidget(); // no parent
```

---

### **Fix**

Always:

* Set parent
* Use Qt tools (windeployqt, macdeployqt)

---

## **8. Real-time Use Cases**

### **Definition**

Real-time use cases require:

* Deterministic behavior
* Fast UI response
* Continuous data flow

---

### **Why Qt is used in real-time systems**

* Event-driven
* Multithreaded
* Hardware integration
* Cross-platform

---

### **Industries Using Qt**

* Medical imaging (CT, MRI)
* Automotive dashboards
* Industrial automation
* Trading systems

---

### **Example: Medical UI**

* UI thread → rendering
* Worker threads → sensor/image processing
* Signals → data updates

```cpp
emit imageReady(frame);
```

---

### **Interview Answer**

> Qt is suitable for real-time systems due to its event loop, threading, and performance.

---

## **Final Interview Summary (Rapid Fire)**

* Qt > MFC → cross-platform, modern
* Signals > callbacks → loose coupling
* Event loop → heart of Qt
* QObject → auto memory management
* Threads → signals & slots
* QString → Unicode & Qt native
* Bugs → mostly ownership & threading
* Qt → widely used in real-time systems

---

