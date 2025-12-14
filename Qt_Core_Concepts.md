## **1. Qt Modules Overview**

### **Definition**

Qt is divided into **modules**, where each module provides a specific set of functionality.

---

### **Why modules exist**

* Avoid loading unnecessary code
* Better performance
* Cleaner project dependencies
* Faster build times

---

### **How modules work**

You explicitly include modules in your project:

* `.pro` → `QT += core widgets`
* CMake → `find_package(Qt6 COMPONENTS Core Widgets)`

---

### **Common Qt Modules**

| Module       | Purpose              |
| ------------ | -------------------- |
| QtCore       | Core non-GUI classes |
| QtGui        | Graphics, painting   |
| QtWidgets    | Traditional GUI      |
| QtNetwork    | Networking           |
| QtSql        | Database             |
| QtMultimedia | Audio/Video          |

---

### **Example**

```pro
QT += core widgets network
```

---

## **2. QObject Class**

### **Definition**

`QObject` is the **base class of almost all Qt classes**.
It enables:

* Signals and slots
* Object hierarchy
* Event handling
* Memory management

---

### **Why QObject is important**

Without QObject:

* No signals & slots
* No event system
* No automatic deletion
* No Qt introspection

---

### **How QObject works**

* Uses Qt Meta-Object System
* Each QObject can have a **parent**
* Parent automatically deletes children

---

### **Example**

```cpp
QObject *parent = new QObject();
QObject *child = new QObject(parent);

// child deleted automatically when parent is deleted
delete parent;
```

---

## **3. Meta-Object System**

### **Definition**

The Qt Meta-Object System provides **runtime information about objects**, enabling:

* Signals and slots
* Dynamic properties
* Object introspection

---

### **Why it exists**

C++ lacks:

* Reflection
* Runtime type information for custom features

Qt solves this using:

* `Q_OBJECT` macro
* Meta-object compiler (moc)

---

### **How it works**

1. `Q_OBJECT` macro used in class
2. moc generates extra C++ code
3. Runtime metadata is available

---

### **Example**

```cpp
class MyClass : public QObject
{
    Q_OBJECT
public slots:
    void mySlot();
};
```

---

## **4. Signals and Slots**

### **Definition**

Signals and slots are Qt’s **type-safe communication mechanism** between objects.

---

### **Why signals and slots**

Traditional callbacks:

* Tight coupling
* Hard to maintain
* Not thread-safe

Qt signals & slots:

* Loose coupling
* Cleaner design
* Thread-safe

---

### **How they work**

* Signal is emitted
* Connected slot is executed
* Qt manages invocation

---

### **Example**

```cpp
connect(button, &QPushButton::clicked,
        this, &MainWindow::onClicked);
```

---

## **5. Event Loop**

### **Definition**

The **event loop** is a continuous loop that processes events like:

* Mouse clicks
* Keyboard input
* Timers
* Signals

---

### **Why event loop is needed**

GUI applications must:

* Stay responsive
* Handle user input continuously

---

### **How event loop works**

* `app.exec()` starts event loop
* OS events enter queue
* Qt processes events one-by-one

---

### **Example**

```cpp
return app.exec();  // Starts event loop
```

---

## **6. Qt Data Types**

### **Definition**

Qt provides its own data types optimized for:

* Unicode
* Cross-platform compatibility
* Performance

---

### **Why Qt has its own types**

* OS-independent behavior
* Unicode by default
* Better integration with Qt APIs

---

### **Common Qt Types**

* QString
* QByteArray
* QDateTime
* QSize
* QPoint

---

### **Example**

```cpp
QString name = "Brijesh";
```

---

## **7. QString vs std::string**

### **Definition**

Both represent strings, but serve different purposes.

---

### **Why QString exists**

* Unicode support
* Internationalization
* Rich string operations

---

### **Comparison**

| Feature             | QString         | std::string |
| ------------------- | --------------- | ----------- |
| Unicode             | Yes             | No          |
| Qt Integration      | Full            | Limited     |
| Performance (ASCII) | Slightly slower | Faster      |

---

### **Example**

```cpp
QString q = "Qt";
std::string s = q.toStdString();
```

---

## **8. QVariant**

### **Definition**

`QVariant` is a **type-safe container** that can store **any Qt-supported data type**.

---

### **Why QVariant is useful**

* Dynamic data storage
* Model-View framework
* Property system

---

### **How it works**

Stores:

* int
* double
* QString
* custom types

---

### **Example**

```cpp
QVariant v = 10;
v = "Hello";
```

---

## **9. Qt Containers**

### **Definition**

Qt provides **container classes** similar to STL but optimized for Qt.

---

### **Why Qt Containers**

* Better Qt integration
* Implicit sharing
* Thread safety (read-only)

---

### **Types**

* QList
* QVector
* QMap
* QSet

---

## **10. QList**

### **Definition**

QList is a **dynamic array-like container**.

---

### **Example**

```cpp
QList<int> list;
list << 1 << 2 << 3;
```

---

## **11. QVector**

### **Definition**

QVector is similar to `std::vector`.

---

### **Why QVector**

* Contiguous memory
* Better performance for large data

---

### **Example**

```cpp
QVector<int> vec;
vec.append(10);
```

---

## **12. QMap**

### **Definition**

QMap stores **key-value pairs** in sorted order.

---

### **Example**

```cpp
QMap<QString, int> marks;
marks["Math"] = 90;
```

---

## **13. QSet**

### **Definition**

QSet stores **unique values**.

---

### **Example**

```cpp
QSet<int> set;
set << 1 << 2 << 2;  // stores only unique
```

---

## **14. Memory Management in Qt (Parent–Child Model)**

### **Definition**

Qt uses **automatic memory management** using **object ownership**.

---

### **Why it exists**

* Prevent memory leaks
* Simplify object lifetime management

---

### **How it works**

* Parent deletes all children
* Works only for QObject-derived classes

---

### **Example**

```cpp
QWidget *window = new QWidget();
QPushButton *btn = new QPushButton(window);

// delete window → btn deleted automatically
delete window;
```

---

## **Interview Summary (Chapter 4)**

* QObject → base of Qt
* Q_OBJECT → enables meta-object
* Signals/Slots → communication
* Event loop → heart of GUI
* QVariant → dynamic type
* Parent-child → auto deletion

---

