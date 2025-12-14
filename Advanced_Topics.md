## **1. Custom Widgets**

### **Definition**

A **custom widget** is a user-defined UI component created by **subclassing QWidget (or another widget)** and implementing custom behavior or painting.

---

### **Why custom widgets are needed**

Built-in widgets are limited when you need:

* Specialized UI (gauges, meters, charts)
* Brand-specific design
* Performance-optimized drawing
* Reusable UI components

---

### **How custom widgets work**

1. Inherit from `QWidget`
2. Override `paintEvent()`
3. Handle input events if needed
4. Expose properties/signals

---

### **Example**

```cpp
class TemperatureWidget : public QWidget
{
    Q_OBJECT
protected:
    void paintEvent(QPaintEvent *) override {
        QPainter p(this);
        p.setBrush(Qt::red);
        p.drawEllipse(rect());
    }
};
```

---

### **Best Practice**

* Keep painting lightweight
* Separate logic from drawing
* Use properties for configuration

---

## **2. Plugin Development**

### **Definition**

A **Qt plugin** is a dynamically loaded module that extends application functionality **without recompiling the main app**.

---

### **Why plugins are useful**

* Modular architecture
* Optional features
* Third-party extensions
* Runtime extensibility

---

### **How Qt plugins work**

1. Define an interface (`QObject` + pure virtual methods)
2. Implement plugin class
3. Use `Q_PLUGIN_METADATA`
4. Load using `QPluginLoader`

---

### **Example – Plugin Interface**

```cpp
class ToolInterface
{
public:
    virtual QString name() const = 0;
};

Q_DECLARE_INTERFACE(ToolInterface, "com.myapp.ToolInterface")
```

---

### **Plugin Implementation**

```cpp
class MyPlugin : public QObject, public ToolInterface
{
    Q_OBJECT
    Q_PLUGIN_METADATA(IID "com.myapp.ToolInterface")
    Q_INTERFACES(ToolInterface)

public:
    QString name() const override {
        return "My Plugin";
    }
};
```

---

### **Loading Plugin**

```cpp
QPluginLoader loader("myplugin.dll");
QObject *plugin = loader.instance();
```

---

## **3. Internationalization (i18n)**

### **Definition**

Internationalization (i18n) is the process of making an application **adaptable to multiple languages and regions**.

---

### **Why i18n is important**

* Global user base
* Legal requirements
* Professional software standards

---

### **How Qt supports i18n**

* `tr()` for translatable strings
* `.ts` translation files
* `QTranslator` for loading languages

---

### **Example**

```cpp
label->setText(tr("File"));
```

---

### **Translation Workflow**

1. Mark strings with `tr()`
2. Generate `.ts` file (`lupdate`)
3. Translate using Qt Linguist
4. Load `.qm` file

---

### **Load Translator**

```cpp
QTranslator translator;
translator.load("app_fr.qm");
app.installTranslator(&translator);
```

---

## **4. Accessibility**

### **Definition**

Accessibility ensures applications are **usable by people with disabilities**.

---

### **Why accessibility matters**

* Inclusivity
* Legal compliance
* Better usability for all users

---

### **How Qt supports accessibility**

* Accessible object tree
* Screen reader support
* Keyboard navigation
* High-contrast themes

---

### **Example**

```cpp
button->setAccessibleName("Submit Button");
button->setAccessibleDescription("Submits the form");
```

---

### **Best Practices**

* Use meaningful labels
* Support keyboard shortcuts
* Avoid color-only indicators

---

## **5. Unit Testing (Qt Test)**

### **Definition**

Unit testing verifies **individual components** of an application to ensure correctness.

---

### **Why unit testing is critical**

* Catch bugs early
* Prevent regressions
* Improve code confidence
* Required in regulated industries

---

### **How Qt Test works**

* Uses `QTest` framework
* Test cases written as QObject classes
* Integrated with Qt Creator

---

### **Example**

```cpp
#include <QtTest>

class MathTest : public QObject
{
    Q_OBJECT
private slots:
    void testAddition() {
        QCOMPARE(2 + 3, 5);
    }
};

QTEST_MAIN(MathTest)
```

---

### **Interview Tip**

> Qt Test supports GUI testing, signals, and asynchronous tests.

---

## **6. Embedded Qt**

### **Definition**

Embedded Qt refers to running Qt on **embedded systems** (ARM boards, automotive ECUs, medical devices).

---

### **Why Qt is popular in embedded**

* Hardware acceleration
* Touch support
* Rich UI
* Cross-platform reuse

---

### **How Embedded Qt works**

1. Cross-compile Qt for target
2. Use framebuffer or Wayland
3. Optimize memory & startup
4. Prefer Qt Quick (QML)

---

### **Example Use Cases**

* Automotive dashboards
* Medical imaging consoles
* Industrial HMIs

---

### **Embedded Best Practices**

* Disable unused Qt modules
* Use static builds (if allowed)
* Minimize resource usage

---

## **7. Performance Tuning**

### **Definition**

Performance tuning optimizes **speed, memory, and responsiveness**.

---

### **Why performance tuning matters**

* Smooth UI
* Real-time constraints
* Battery efficiency
* User satisfaction

---

### **How to tune Qt apps**

#### **a. UI Performance**

* Avoid heavy work in `paintEvent()`
* Minimize repaints
* Use `update()` wisely

---

#### **b. Threading**

* Move heavy tasks to worker threads
* Use thread pools for short tasks

---

#### **c. Memory**

* Avoid unnecessary copies
* Use references & move semantics
* Clean unused objects

---

#### **d. Profiling**

```cpp
QElapsedTimer timer;
timer.start();
// code
qDebug() << timer.elapsed();
```

---

### **Interview Tip**

> Measure first, optimize later.

---

## **Common Advanced Mistakes (Interview Traps)**

❌ Custom painting in GUI thread with heavy logic
❌ Ignoring accessibility
❌ No unit tests
❌ Overusing signals for simple calls
❌ Premature optimization

---

## **Interview Summary (Chapter 25)**

* Custom widgets = full UI control
* Plugins = extensibility
* i18n = global-ready apps
* Accessibility = inclusive design
* Qt Test = quality assurance
* Embedded Qt = rich HMIs
* Performance tuning = production readiness

---


