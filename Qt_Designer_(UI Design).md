## **1. Introduction to Qt Designer**

### **Definition**

Qt Designer is a **visual UI design tool** integrated into **Qt Creator** that allows developers to design user interfaces using **drag & drop**, without writing UI code manually.

UI designs are stored in **`.ui` files** (XML-based).

---

### **Why Qt Designer exists**

Without Designer:

* You must manually create and position widgets in code
* UI changes require recompilation
* UI and logic become tightly coupled

Qt Designer:

* Separates **UI** from **business logic**
* Speeds up development
* Makes UI changes easier and safer

---

### **How Qt Designer works**

1. You design UI visually
2. Designer saves it as `.ui`
3. At build time, Qt converts `.ui` → C++ code
4. UI is loaded via `setupUi()`

---

### **Example**

```cpp
ui->setupUi(this);
```

---

## **2. Creating UI using Drag & Drop**

### **Definition**

Drag & Drop UI creation means placing widgets visually onto a form.

---

### **Why Drag & Drop**

* Faster UI design
* No manual geometry calculations
* Better alignment and spacing

---

### **How to create UI**

1. Open `.ui` file
2. Drag widgets from **Widget Box**
3. Place on form
4. Apply layouts

---

### **Example**

Drag:

* QLabel
* QLineEdit
* QPushButton

Resulting UI (no manual code required).

---

## **3. Widget Properties**

### **Definition**

Properties define **behavior, appearance, and identity** of a widget.

---

### **Why properties matter**

* Control text, size, fonts
* Set object name (important for auto-connect)
* Change behavior without code

---

### **Common Properties**

* `objectName`
* `text`
* `enabled`
* `visible`
* `geometry`

---

### **Example**

Set in Designer:

```text
objectName = pushButtonLogin
text = Login
```

Used in code:

```cpp
ui->pushButtonLogin->setEnabled(false);
```

---

## **4. Signals/Slots Editor**

### **Definition**

Signals/Slots Editor visually connects widget signals to slots.

---

### **Why use it**

* No manual `connect()` code
* Clean and visual
* Ideal for simple interactions

---

### **How it works**

1. Open Signals/Slots Editor
2. Drag from widget signal
3. Drop on target slot

---

### **Example**

Connect:

```text
pushButton → clicked()
→ MainWindow → close()
```

---

## **5. Layouts in Designer**

### **Definition**

Layouts in Designer manage **automatic resizing and positioning**.

---

### **Why layouts are critical**

* Responsive UI
* Cross-platform consistency
* Avoid hard-coded sizes

---

### **How to apply layouts**

1. Select widgets
2. Right-click
3. Choose layout:

   * Vertical
   * Horizontal
   * Grid
   * Form

---

### **Example**

Login form:

* Labels + LineEdits → **QFormLayout**
* Buttons → **QHBoxLayout**

---

## **6. Promoted Widgets**

### **Definition**

Promoted widgets allow you to replace a standard widget with a **custom widget class** in Designer.

---

### **Why promoted widgets**

* Use custom logic
* Reusable UI components
* Cleaner architecture

---

### **How it works**

1. Place base widget (e.g., QWidget)
2. Right-click → Promote
3. Enter custom class name

---

### **Example**

Promote `QWidget` → `MyCustomWidget`

```cpp
class MyCustomWidget : public QWidget
{
    Q_OBJECT
};
```

---

## **7. Custom Widgets**

### **Definition**

Custom widgets are user-defined widgets created by **subclassing QWidget or another widget**.

---

### **Why custom widgets**

* Custom behavior
* Custom drawing
* Specialized UI components

---

### **How to create**

1. Inherit from QWidget
2. Override paint or event methods
3. Use in Designer or code

---

### **Example**

```cpp
class ColorWidget : public QWidget
{
protected:
    void paintEvent(QPaintEvent *) override {
        QPainter p(this);
        p.fillRect(rect(), Qt::red);
    }
};
```

---

## **8. UI to Code Integration**

### **Definition**

UI to code integration connects `.ui` elements with C++ logic.

---

### **Why integration is important**

* UI must trigger actions
* Logic must update UI

---

### **How it works**

* `ui` pointer gives access to widgets
* Signals connect UI to slots

---

### **Example**

```cpp
connect(ui->pushButton,
        &QPushButton::clicked,
        this,
        &MainWindow::onLoginClicked);
```

---

## **9. Best Practices for UI Design**

### **Best Practices**

* Always use layouts
* Meaningful `objectName`
* Keep UI simple
* Separate UI and logic
* Avoid hard-coded sizes
* Use consistent fonts

---

