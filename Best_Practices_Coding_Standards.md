

## **1. Qt Coding Style**

### **Definition**

Qt coding style is a **set of conventions** for writing **consistent, readable, and maintainable** C++ code using Qt.

Qt follows:

* Clear formatting
* Explicit ownership
* Signal–slot driven design

---

### **Why coding style matters**

* Code is read more than written
* Easier code reviews
* Fewer bugs
* Faster onboarding for new developers

---

### **How Qt style looks**

* 4-space indentation
* Braces on same line
* Clear separation of declaration and implementation

---

### **Example (Good Style)**

```cpp
void MainWindow::updateStatus(int value)
{
    if (value > 0) {
        ui->label->setText("Active");
    } else {
        ui->label->setText("Inactive");
    }
}
```

❌ **Bad**

```cpp
void updateStatus(int value){if(value>0){label->setText("Active");}}
```

---

## **2. Naming Conventions**

### **Definition**

Naming conventions define **how variables, functions, classes, and files are named**.

---

### **Why naming is important**

* Self-documenting code
* Less need for comments
* Easier debugging and searching

---

### **Qt Naming Rules**

| Element    | Convention   | Example             |
| ---------- | ------------ | ------------------- |
| Class      | PascalCase   | `MainWindow`        |
| Function   | camelCase    | `loadData()`        |
| Variable   | camelCase    | `filePath`          |
| Member var | `m_` prefix  | `m_count`           |
| Constants  | Upper case   | `MAX_SIZE`          |
| Signals    | Verb phrase  | `dataReady()`       |
| Slots      | Action-based | `onButtonClicked()` |

---

### **Example**

```cpp
class FileManager
{
public:
    void loadFile(const QString &filePath);

private:
    int m_fileCount;
};
```

---

## **3. Memory Leak Prevention**

### **Definition**

Memory leak prevention ensures that **allocated memory is properly released**.

---

### **Why memory leaks are dangerous**

* Increased memory usage
* Slower performance
* Application crashes
* Critical in long-running apps (medical, industrial)

---

### **How Qt helps prevent leaks**

1. **Parent–Child Ownership**
2. **QObject::deleteLater()**
3. **Smart pointers (when needed)**

---

### **Example – Parent–Child (Best Practice)**

```cpp
QPushButton *btn = new QPushButton(this);
// auto deleted with parent
```

---

### **deleteLater() (Safe in threads)**

```cpp
worker->deleteLater();
```

---

### **Common Leak (❌)**

```cpp
QWidget *w = new QWidget();
// no parent, never deleted
```

---

## **4. Performance Optimization**

### **Definition**

Performance optimization improves **speed, memory usage, and responsiveness**.

---

### **Why performance matters**

* Smooth UI
* Better UX
* Real-time constraints
* Lower CPU usage

---

### **How to optimize Qt apps**

#### **a. Avoid Blocking GUI Thread**

❌

```cpp
sleep(5);  // freezes UI
```

✅

```cpp
QTimer::singleShot(5000, this, &MainWindow::task);
```

---

#### **b. Use Model–View for Large Data**

❌ `QTableWidget` for 100k rows
✅ `QTableView + model`

---

#### **c. Minimize Repaints**

```cpp
setUpdatesEnabled(false);
// bulk updates
setUpdatesEnabled(true);
```

---

#### **d. Use const & references**

```cpp
void process(const QString &name);
```

---

## **5. Error Handling**

### **Definition**

Error handling is the process of **detecting, reporting, and recovering from errors**.

---

### **Why error handling is critical**

* Prevent crashes
* Provide meaningful feedback
* Easier debugging

---

### **How to handle errors in Qt**

#### **a. Return Value Checks**

```cpp
if (!file.open(QIODevice::ReadOnly)) {
    qWarning() << "File open failed";
}
```

---

#### **b. Qt Error Classes**

* `QSqlError`
* `QNetworkReply::error()`
* `QFile::error()`

---

#### **c. User Feedback**

```cpp
QMessageBox::critical(this, "Error", "Database connection failed");
```

---

## **6. Code Reusability**

### **Definition**

Code reusability means **writing components that can be reused** across the application or projects.

---

### **Why reusability matters**

* Faster development
* Less duplication
* Easier maintenance

---

### **How to achieve reusability**

#### **a. Reusable Classes**

```cpp
class Logger : public QObject
{
public:
    void log(const QString &msg);
};
```

---

#### **b. Utility Functions**

```cpp
namespace Utils {
    QString formatDate(const QDate &date);
}
```

---

#### **c. Custom Widgets**

```cpp
class StatusIndicator : public QWidget
{
    Q_OBJECT
};
```

---

## **7. Modular Design**

### **Definition**

Modular design means **dividing an application into independent, well-defined modules**.

---

### **Why modular design**

* Better scalability
* Parallel development
* Easier testing
* Clear responsibilities

---

### **How to design modules**

* Separate UI, logic, data
* Use signals/slots for communication
* Minimize dependencies

---

### **Example – Module Separation**

```
ui/
 ├── mainwindow.ui
core/
 ├── datamanager.h/.cpp
network/
 ├── api_client.h/.cpp
```

---

### **Loose Coupling via Signals**

```cpp
connect(apiClient, &ApiClient::dataReady,
        dataManager, &DataManager::processData);
```

---

## **Common Mistakes (Interview Traps)**

❌ Hard-coded values
❌ Long functions
❌ UI logic mixed with business logic
❌ Raw pointers without ownership
❌ Ignoring const correctness

---

## **Interview Questions (Chapter 22)**

**Q: How does Qt help in memory management?**
👉 Parent–child model

**Q: How do you avoid UI freezing?**
👉 Threads, timers, async APIs

**Q: Why use signals/slots instead of direct calls?**
👉 Loose coupling

---

## **Interview Summary (One-liners)**

* Follow Qt coding style
* Use meaningful names
* Rely on parent–child ownership
* Keep GUI thread free
* Handle errors explicitly
* Write reusable modules
* Design loosely coupled systems

---


