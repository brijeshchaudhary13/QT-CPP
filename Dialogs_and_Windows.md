## **1. Dialogs and Windows – Overview**

### **Definition**

In Qt:

* A **Window** is a top-level widget that represents an application interface.
* A **Dialog** is a special type of window used to **interact with the user for a specific task** (confirmation, input, settings).

---

### **Why dialogs are needed**

* Confirm user actions
* Get user input
* Show warnings/errors
* Configure application settings

---

### **How dialogs work**

* Derived from `QDialog`
* Can be modal or modeless
* Return a result (`Accepted` / `Rejected`)

---

## **2. Modal vs Modeless Dialogs**

---

### **Modal Dialog**

#### **Definition**

A modal dialog **blocks interaction** with other windows until it is closed.

---

#### **Why use modal dialogs**

* Force user decision
* Prevent accidental actions
* Ensure input is provided

---

#### **How it works**

* Uses `exec()`
* Starts a local event loop

---

#### **Example**

```cpp
QDialog dlg;
dlg.exec();  // Blocks main window
```

---

### **Modeless Dialog**

#### **Definition**

A modeless dialog **does not block** other windows.

---

#### **Why use modeless dialogs**

* Tool windows
* Find/Replace dialogs
* Floating panels

---

#### **How it works**

* Uses `show()`
* Runs in main event loop

---

#### **Example**

```cpp
QDialog *dlg = new QDialog(this);
dlg->show();
```

---

### **Interview Tip**

> **exec() = modal, show() = modeless**

---

## **3. QMessageBox**

### **Definition**

`QMessageBox` is a **ready-made dialog** used to display:

* Information
* Warnings
* Errors
* Questions

---

### **Why QMessageBox**

* No custom UI needed
* Standard OS look
* Quick user feedback

---

### **How it works**

* Static functions or instance-based
* Returns user choice

---

### **Example – Information**

```cpp
QMessageBox::information(this,
                         "Info",
                         "Operation completed");
```

---

### **Example – Question**

```cpp
int ret = QMessageBox::question(this,
                                "Confirm",
                                "Are you sure?",
                                QMessageBox::Yes | QMessageBox::No);

if (ret == QMessageBox::Yes) {
    // proceed
}
```

---

## **4. QFileDialog**

### **Definition**

`QFileDialog` allows users to **select files or directories**.

---

### **Why QFileDialog**

* Standard file browsing UI
* OS-native dialogs
* Safe and user-friendly

---

### **How it works**

* Opens file system dialog
* Returns selected path

---

### **Example – Open File**

```cpp
QString file = QFileDialog::getOpenFileName(this,
                                            "Open File",
                                            "",
                                            "Text Files (*.txt)");
```

---

### **Example – Save File**

```cpp
QString file = QFileDialog::getSaveFileName(this,
                                            "Save File");
```

---

## **5. QColorDialog**

### **Definition**

`QColorDialog` allows users to **select a color**.

---

### **Why QColorDialog**

* Used in editors, design tools
* Avoid custom color pickers

---

### **How it works**

* Returns selected QColor

---

### **Example**

```cpp
QColor color = QColorDialog::getColor(Qt::white, this);

if (color.isValid()) {
    widget->setStyleSheet("background-color:" + color.name());
}
```

---

## **6. QFontDialog**

### **Definition**

`QFontDialog` allows users to **select a font**.

---

### **Why QFontDialog**

* Text editors
* Customizable UI
* Standard font selection

---

### **How it works**

* Returns selected font

---

### **Example**

```cpp
bool ok;
QFont font = QFontDialog::getFont(&ok, this);

if (ok) {
    textEdit->setFont(font);
}
```

---

## **7. Custom Dialog Creation**

### **Definition**

A custom dialog is a **user-defined dialog** created for specific needs.

---

### **Why custom dialogs**

* Complex forms
* Settings windows
* Data entry dialogs

---

### **How to create**

1. Create `QDialog` subclass
2. Design UI (Designer or code)
3. Handle OK/Cancel

---

### **Example**

```cpp
class LoginDialog : public QDialog
{
    Q_OBJECT
public:
    LoginDialog(QWidget *parent = nullptr);
};
```

Show dialog:

```cpp
LoginDialog dlg;
if (dlg.exec() == QDialog::Accepted) {
    // login success
}
```

---

## **8. Passing Data Between Dialogs**

---

### **Why data passing is needed**

* Send user input to main window
* Configure settings
* Share state

---

### **Method 1: Getter Functions**

```cpp
QString LoginDialog::username() const {
    return ui->lineEditUser->text();
}
```

Usage:

```cpp
LoginDialog dlg;
dlg.exec();
QString user = dlg.username();
```

---

### **Method 2: Signals & Slots**

Dialog:

```cpp
signals:
    void dataReady(QString);
```

Emit:

```cpp
emit dataReady(user);
```

Main Window:

```cpp
connect(&dlg, &LoginDialog::dataReady,
        this, &MainWindow::receiveData);
```

---

## **9. Multiple Windows Handling**

### **Definition**

Managing more than one window in a Qt application.

---

### **Why multiple windows**

* Tools
* Popups
* Child windows
* Dashboards

---

### **How it works**

* Each window is a QWidget
* Use parent-child relationships
* Manage lifetime carefully

---

### **Example**

```cpp
SecondWindow *w = new SecondWindow(this);
w->show();
```

---

### **Memory Management Tip**

If parent is set:

```cpp
new SecondWindow(this);  // auto deleted
```

---

## **Common Interview Questions (Chapter 10)**

**Q: Difference between exec() and show()?**
👉 exec() blocks, show() doesn’t

**Q: How to pass data from dialog?**
👉 Getter or signals/slots

**Q: When to use QMessageBox?**
👉 For standard messages

---

## **Interview Summary (One-liners)**

* QDialog → dialog window
* Modal → blocks UI
* Modeless → non-blocking
* QFileDialog → file selection
* Custom dialogs → user input
* Parent-child → memory safety

---

