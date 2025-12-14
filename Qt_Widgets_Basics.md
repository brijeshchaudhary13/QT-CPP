

## **1. What are Widgets?**

### **Definition**

A **widget** is a **visual UI component** in Qt that:

* Appears on the screen
* Interacts with the user
* Inherits from `QWidget`

Examples:

* Buttons
* Labels
* Text boxes
* Windows

---

### **Why widgets exist**

* GUI applications need user interaction
* Widgets provide reusable UI building blocks
* Platform-independent UI components

---

### **How widgets work**

* Each widget is an object
* Widgets receive events (mouse, keyboard)
* Widgets can contain other widgets (parent-child)

---

### **Example**

```cpp
QWidget *w = new QWidget();
w->show();
```

---

## **2. Main Window vs Dialog vs Widget**

### **Definition**

Qt provides different **top-level widget types** based on usage.

---

### **Why multiple window types**

Different applications require:

* Menus
* Toolbars
* Popups
* Simple containers

---

### **Comparison Table**

| Type        | Class       | Use Case         |
| ----------- | ----------- | ---------------- |
| Main Window | QMainWindow | Full application |
| Dialog      | QDialog     | Popups, forms    |
| Widget      | QWidget     | Custom windows   |

---

### **QMainWindow Example**

```cpp
class MainWindow : public QMainWindow
{
};
```

Supports:

* Menu bar
* Tool bar
* Status bar
* Central widget

---

### **QDialog Example**

```cpp
QDialog dlg;
dlg.exec();  // Modal dialog
```

---

### **QWidget Example**

```cpp
QWidget w;
w.show();
```

---

## **3. QLabel**

### **Definition**

`QLabel` displays **text or images**.

---

### **Why QLabel**

* Display static information
* Show status messages
* Display icons/images

---

### **How QLabel works**

* Read-only widget
* Supports rich text (HTML)
* Can show pixmaps

---

### **Example**

```cpp
QLabel *label = new QLabel("Hello Qt");
label->show();
```

Image:

```cpp
label->setPixmap(QPixmap(":/icon.png"));
```

---

## **4. QPushButton**

### **Definition**

`QPushButton` is a **clickable button**.

---

### **Why QPushButton**

* Trigger actions
* User interaction

---

### **How it works**

* Emits `clicked()` signal
* Can be checkable

---

### **Example**

```cpp
QPushButton *btn = new QPushButton("Click Me");

connect(btn, &QPushButton::clicked, [](){
    qDebug() << "Button Clicked";
});
```

---

## **5. QLineEdit**

### **Definition**

`QLineEdit` is a **single-line text input** widget.

---

### **Why QLineEdit**

* Username
* Password
* Search fields

---

### **How it works**

* Emits `textChanged`
* Supports input validators

---

### **Example**

```cpp
QLineEdit *edit = new QLineEdit();
edit->setPlaceholderText("Enter name");
```

Password:

```cpp
edit->setEchoMode(QLineEdit::Password);
```

---

## **6. QTextEdit**

### **Definition**

`QTextEdit` is a **multi-line rich text editor**.

---

### **Why QTextEdit**

* Notes
* Logs
* Text editors

---

### **How it works**

* Supports HTML formatting
* Large text handling

---

### **Example**

```cpp
QTextEdit *text = new QTextEdit();
text->setText("Multi-line text");
```

---

## **7. QCheckBox**

### **Definition**

`QCheckBox` represents **ON/OFF** or **true/false** state.

---

### **Why QCheckBox**

* Enable/disable options
* Multiple selections allowed

---

### **How it works**

* Emits `stateChanged(int)`

---

### **Example**

```cpp
QCheckBox *cb = new QCheckBox("Accept Terms");

connect(cb, &QCheckBox::stateChanged, [](int state){
    qDebug() << state;
});
```

---

## **8. QRadioButton**

### **Definition**

`QRadioButton` allows **single selection** among multiple options.

---

### **Why QRadioButton**

* Gender selection
* Choice-based input

---

### **How it works**

* Only one active in group
* Use `QButtonGroup`

---

### **Example**

```cpp
QRadioButton *r1 = new QRadioButton("Male");
QRadioButton *r2 = new QRadioButton("Female");
```

---

## **9. QComboBox**

### **Definition**

`QComboBox` is a **drop-down list**.

---

### **Why QComboBox**

* Save space
* Multiple choices

---

### **How it works**

* Stores list items
* Emits `currentIndexChanged`

---

### **Example**

```cpp
QComboBox *combo = new QComboBox();
combo->addItems({"C++", "Qt", "Python"});
```

---

## **10. QListWidget**

### **Definition**

`QListWidget` displays a **list of items**.

---

### **Why QListWidget**

* Simple list display
* No model-view complexity

---

### **How it works**

* Item-based
* Easy API

---

### **Example**

```cpp
QListWidget *list = new QListWidget();
list->addItem("Item 1");
list->addItem("Item 2");
```

---

## **11. QTableWidget**

### **Definition**

`QTableWidget` displays data in **rows and columns**.

---

### **Why QTableWidget**

* Small datasets
* Simple tables

---

### **How it works**

* Item-based table
* Each cell is `QTableWidgetItem`

---

### **Example**

```cpp
QTableWidget *table = new QTableWidget(2, 2);
table->setItem(0, 0, new QTableWidgetItem("A"));
```

---

## **12. QTreeWidget**

### **Definition**

`QTreeWidget` displays **hierarchical data**.

---

### **Why QTreeWidget**

* File explorers
* Menu structures

---

### **How it works**

* Parent-child items

---

### **Example**

```cpp
QTreeWidget *tree = new QTreeWidget();
QTreeWidgetItem *root = new QTreeWidgetItem(tree, {"Root"});
new QTreeWidgetItem(root, {"Child"});
```

---

## **Interview Summary (Chapter 6)**

* QWidget → base class
* QMainWindow → full app
* QDialog → popups
* QPushButton → action
* QLineEdit → single-line input
* QTextEdit → multi-line input
* QList/QTable/QTree → data display

---

