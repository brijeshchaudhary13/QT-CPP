

## **1. What are Signals and Slots?**

### **Definition**

**Signals and slots** are Qt’s **object communication mechanism** used to notify one object when something happens in another object.

* **Signal** → emitted when an event occurs
* **Slot** → function that reacts to the signal

---

### **Why Signals and Slots exist**

Traditional callbacks:

* Create tight coupling
* Are error-prone
* Hard to maintain

Qt signals & slots:

* Loose coupling
* Type-safe
* Thread-safe
* Cleaner architecture

---

### **How they work**

1. An object **emits a signal**
2. Qt checks all connected slots
3. Connected slots are automatically invoked

---

### **Example**

```cpp
connect(button, &QPushButton::clicked,
        this, &MainWindow::onClicked);
```

---

## **2. Syntax (Old vs New)**

### **Old Syntax (Qt 4 style)**

#### **Definition**

Uses string-based signal-slot matching.

```cpp
connect(button, SIGNAL(clicked()),
        this, SLOT(onClicked()));
```

---

#### **Why it existed**

* C++ did not support function pointers well
* Needed runtime flexibility

---

#### **Problems**

* No compile-time checking
* Typos cause runtime errors

---

### **New Syntax (Qt 5/6 – Recommended)**

#### **Definition**

Uses **function pointers**.

```cpp
connect(button, &QPushButton::clicked,
        this, &MainWindow::onClicked);
```

---

#### **Why new syntax**

* Compile-time safety
* Better performance
* Refactoring friendly

---

### **Interview Answer**

👉 Always prefer **new syntax**.

---

## **3. Connecting Signals and Slots**

### **Definition**

Connecting establishes a relationship between:

* **Sender**
* **Signal**
* **Receiver**
* **Slot**

---

### **Why explicit connection is needed**

Qt does not guess relationships.
Explicit connections:

* Improve readability
* Avoid unintended behavior

---

### **How connection works**

```cpp
connect(sender, signal, receiver, slot);
```

---

### **Example**

```cpp
connect(slider, &QSlider::valueChanged,
        label, &QLabel::setNum);
```

👉 When slider moves → label updates

---

## **4. Custom Signals and Slots**

### **Definition**

Developers can define their **own signals and slots** in custom classes.

---

### **Why custom signals**

* Encapsulation
* Event-driven design
* Clean separation of logic

---

### **How to create custom signal**

1. Inherit from QObject
2. Add `Q_OBJECT`
3. Declare signal

---

### **Example**

```cpp
class Sensor : public QObject
{
    Q_OBJECT
public:
    void detect() {
        emit valueChanged(42);
    }

signals:
    void valueChanged(int value);
};
```

Slot:

```cpp
class Display : public QObject
{
    Q_OBJECT
public slots:
    void showValue(int v) {
        qDebug() << v;
    }
};
```

Connection:

```cpp
connect(&sensor, &Sensor::valueChanged,
        &display, &Display::showValue);
```

---

## **5. Lambda-based Connections**

### **Definition**

Qt allows connecting signals to **lambda functions**.

---

### **Why lambdas**

* Avoid writing small slot functions
* Inline logic
* Cleaner code

---

### **How it works**

Lambda acts as a slot.

---

### **Example**

```cpp
connect(button, &QPushButton::clicked,
        this, []() {
            qDebug() << "Button clicked";
        });
```

---

### **With parameters**

```cpp
connect(slider, &QSlider::valueChanged,
        this, [](int value) {
            qDebug() << value;
        });
```

---

## **6. Disconnecting Signals**

### **Definition**

`disconnect()` removes an existing signal-slot connection.

---

### **Why disconnect**

* Avoid unwanted calls
* Prevent crashes
* Manage object lifetime

---

### **How to disconnect**

```cpp
disconnect(sender, signal, receiver, slot);
```

---

### **Example**

```cpp
disconnect(button, &QPushButton::clicked,
           this, &MainWindow::onClicked);
```

---

### **Disconnect all**

```cpp
disconnect(button, nullptr, nullptr, nullptr);
```

---

## **7. Auto Connection Mechanism**

### **Definition**

Qt automatically connects signals to slots based on **naming convention**.

---

### **Why auto connection**

* Less boilerplate code
* Cleaner UI integration

---

### **How it works**

Slot name format:

```text
on_<objectName>_<signalName>()
```

---

### **Example**

Object name: `pushButton`

Signal:

```cpp
clicked()
```

Slot:

```cpp
void on_pushButton_clicked();
```

👉 Automatically connected by `setupUi()`.

---

### **Important Note**

* Works mainly with `.ui` files
* Relies on `QObject::objectName`

---

## **8. Thread-safe Signal-Slot Communication**

### **Definition**

Qt signals and slots can communicate **across threads safely**.

---

### **Why thread safety matters**

* GUI runs in main thread
* Background tasks in worker threads
* Direct access causes crashes

---

### **How Qt handles it**

Qt uses **Queued Connections**.

---

### **Connection Types**

* DirectConnection
* QueuedConnection
* BlockingQueuedConnection
* AutoConnection (default)

---

### **Example**

```cpp
connect(worker, &Worker::dataReady,
        this, &MainWindow::updateUI,
        Qt::QueuedConnection);
```

👉 Slot executes in **receiver’s thread**.

---

## **9. Common Errors and Debugging**

### **Common Errors**

1. Missing `Q_OBJECT`
2. Class not inheriting QObject
3. Signature mismatch
4. Using old syntax incorrectly
5. Connecting destroyed objects

---

### **Example Error**

```cpp
QObject::connect: No such slot
```

---

### **How to debug**

* Check signal/slot signature
* Ensure moc is running
* Use `qDebug()` in slot
* Check object lifetime

---

### **Debugging Tip**

```cpp
bool ok = connect(...);
qDebug() << ok;
```

---

## **Interview Summary (Chapter 5)**

* Signals emit events
* Slots receive events
* Loose coupling
* Thread-safe
* New syntax preferred
* Q_OBJECT mandatory
* Auto-connect via naming

---

