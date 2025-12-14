
## **1. Event-driven Programming in Qt**

### **Definition**

Qt applications follow **event-driven programming**, where code reacts to **events** instead of running sequentially.

---

### **Why event-driven model**

* GUI apps must respond to user actions
* Non-blocking behavior
* High responsiveness

---

### **How it works**

1. OS generates events
2. Qt event loop receives events
3. Widgets handle events

---

## **2. QEvent Class**

### **Definition**

`QEvent` is the **base class for all events** in Qt.

---

### **Why QEvent**

* Common interface for all events
* Enables polymorphism

---

### **How it works**

Each event has a **type**:

```cpp
event->type()
```

---

## **3. Event Types**

### **Common Event Types**

* Mouse events
* Keyboard events
* Timer events
* Focus events
* Paint events

---

### **Example**

```cpp
if (event->type() == QEvent::MouseButtonPress) {
    // handle mouse press
}
```

---

## **4. Event Filters**

### **Definition**

Event filters allow one object to **intercept events of another object**.

---

### **Why event filters**

* Centralized event handling
* Modify behavior without subclassing

---

### **How it works**

1. Install filter
2. Override `eventFilter()`

---

### **Example**

```cpp
bool MainWindow::eventFilter(QObject *obj, QEvent *event)
{
    if (event->type() == QEvent::KeyPress) {
        qDebug() << "Key pressed";
        return true;
    }
    return QObject::eventFilter(obj, event);
}
```

---

## **5. Mouse Events**

### **Definition**

Mouse events handle **mouse interactions**.

---

### **Common Mouse Events**

* mousePressEvent
* mouseReleaseEvent
* mouseMoveEvent

---

### **Example**

```cpp
void MyWidget::mousePressEvent(QMouseEvent *event)
{
    qDebug() << event->pos();
}
```

---

## **6. Keyboard Events**

### **Definition**

Keyboard events respond to **key presses/releases**.

---

### **Why keyboard events**

* Shortcuts
* Text input control
* Accessibility

---

### **Example**

```cpp
void MyWidget::keyPressEvent(QKeyEvent *event)
{
    if (event->key() == Qt::Key_Escape)
        close();
}
```

---

## **7. Timer Events**

### **Definition**

Timer events execute code at **fixed intervals**.

---

### **Why timers**

* Periodic tasks
* UI updates
* Background checks

---

### **How it works**

* `QTimer` or `timerEvent()`

---

### **Example**

```cpp
QTimer *timer = new QTimer(this);
connect(timer, &QTimer::timeout, this, &MainWindow::updateTime);
timer->start(1000);
```

---

## **8. Focus Events**

### **Definition**

Focus events occur when a widget **gains or loses focus**.

---

### **Why focus events**

* Validate input
* Highlight active widget

---

### **Example**

```cpp
void MyWidget::focusInEvent(QFocusEvent *)
{
    qDebug() << "Focus gained";
}
```

---

## **9. Overriding `event()` Method**

### **Definition**

`event()` is the **central event handler** in Qt.

---

### **Why override event()**

* Handle multiple event types
* Custom event processing

---

### **How it works**

All events pass through `event()` first.

---

### **Example**

```cpp
bool MyWidget::event(QEvent *e)
{
    if (e->type() == QEvent::HoverEnter) {
        qDebug() << "Hover";
        return true;
    }
    return QWidget::event(e);
}
```

---

## **Interview Summary (Ch 8 & 9)**

* Qt Designer separates UI from logic
* `.ui` files are converted to C++
* Event loop drives everything
* Event filters intercept events
* Override event handlers for customization

---

