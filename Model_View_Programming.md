

## **1. What is Model–View Architecture?**

### **Definition**

Model–View Architecture is a design pattern that **separates data from its presentation**.

In Qt:

* **Model** → stores and manages data
* **View** → displays data
* **Delegate** → controls editing and rendering

---

### **Why Model–View is needed**

Item-based widgets (`QListWidget`, `QTableWidget`) work fine for small data, but:

* They don’t scale well
* Duplicate data storage
* Hard to customize behavior

Model–View:

* Handles **large datasets**
* Clean separation of logic
* Multiple views for same data
* High performance

---

### **How it works**

```
Model  <---->  View
   ↑              |
   |           Delegate
```

* View asks model for data
* Model provides data on demand
* Delegate paints and edits items

---

### **Real-world Example**

* Database table → **Model**
* Table UI → **View**
* Custom editor (dropdown, checkbox) → **Delegate**

---

## **2. Model vs View vs Delegate**

### **Model**

#### **Definition**

Model stores **actual data** and exposes it via a standard interface.

#### **Responsibilities**

* Store data
* Provide row/column count
* Return data for display/edit

---

### **View**

#### **Definition**

View displays data provided by the model.

#### **Responsibilities**

* Visual representation
* User interaction (selection, scrolling)

---

### **Delegate**

#### **Definition**

Delegate controls **how items are drawn and edited**.

#### **Responsibilities**

* Paint items
* Provide editors (line edit, combo box)

---

### **Comparison Table**

| Component | Role               |
| --------- | ------------------ |
| Model     | Data               |
| View      | Display            |
| Delegate  | Editing & painting |

---

## **3. QStringListModel**

### **Definition**

`QStringListModel` is a **simple model** that stores a list of strings.

---

### **Why use QStringListModel**

* Quick and lightweight
* Ideal for simple lists
* No custom code needed

---

### **How it works**

* Stores `QStringList`
* Automatically implements required model functions

---

### **Example**

```cpp
QStringList list;
list << "C++" << "Qt" << "Python";

QStringListModel *model = new QStringListModel(list);

QListView *view = new QListView();
view->setModel(model);
view->show();
```

---

## **4. QStandardItemModel**

### **Definition**

`QStandardItemModel` is a **flexible, generic model** that supports:

* Rows & columns
* Hierarchical data
* Icons, fonts, colors

---

### **Why QStandardItemModel**

* More powerful than QStringListModel
* No need to write custom model
* Supports tree & table structures

---

### **How it works**

* Uses `QStandardItem` objects
* Each item holds data & properties

---

### **Example (Table)**

```cpp
QStandardItemModel *model = new QStandardItemModel(2, 2);

model->setItem(0, 0, new QStandardItem("Alice"));
model->setItem(0, 1, new QStandardItem("90"));

model->setItem(1, 0, new QStandardItem("Bob"));
model->setItem(1, 1, new QStandardItem("85"));

QTableView *view = new QTableView();
view->setModel(model);
view->show();
```

---

## **5. QListView**

### **Definition**

`QListView` displays data in a **vertical list** using a model.

---

### **Why QListView**

* Efficient for large lists
* Separates data from UI
* Supports custom delegates

---

### **How it works**

* Requests data from model
* Uses delegate to paint items

---

### **Example**

```cpp
QListView *view = new QListView();
view->setModel(model);
```

---

## **6. QTableView**

### **Definition**

`QTableView` displays data in **rows and columns**.

---

### **Why QTableView**

* Large tables
* Database views
* Spreadsheet-like UI

---

### **How it works**

* Model provides row/column count
* Delegate paints cells

---

### **Example**

```cpp
QTableView *table = new QTableView();
table->setModel(model);
table->setSelectionBehavior(QAbstractItemView::SelectRows);
```

---

## **7. QTreeView**

### **Definition**

`QTreeView` displays **hierarchical data** (parent–child).

---

### **Why QTreeView**

* File systems
* Menus
* XML/JSON structure

---

### **How it works**

* Model provides tree structure
* Items can be expanded/collapsed

---

### **Example**

```cpp
QTreeView *tree = new QTreeView();
tree->setModel(model);
tree->expandAll();
```

---

## **8. Custom Models**

### **Definition**

A custom model is created by **subclassing `QAbstractItemModel`** or its subclasses.

---

### **Why custom models**

* Use your own data structure
* Connect directly to databases
* Optimize memory & performance

---

### **How it works**

You must implement:

* `rowCount()`
* `columnCount()`
* `data()`
* `index()`
* `parent()` (for trees)

---

### **Simple Custom Model Example**

```cpp
class MyModel : public QAbstractListModel
{
    QStringList dataList;

public:
    int rowCount(const QModelIndex &) const override {
        return dataList.size();
    }

    QVariant data(const QModelIndex &index, int role) const override {
        if (role == Qt::DisplayRole)
            return dataList.at(index.row());
        return QVariant();
    }
};
```

---

## **9. Custom Delegates**

### **Definition**

A custom delegate controls **how items are drawn and edited**.

---

### **Why custom delegates**

* Custom editors (dropdown, checkbox)
* Special rendering
* Validation

---

### **How it works**

Subclass:

* `QStyledItemDelegate`

Override:

* `paint()`
* `createEditor()`
* `setEditorData()`
* `setModelData()`

---

### **Example – ComboBox Delegate**

```cpp
class ComboDelegate : public QStyledItemDelegate
{
public:
    QWidget *createEditor(QWidget *parent,
                           const QStyleOptionViewItem &,
                           const QModelIndex &) const override
    {
        QComboBox *box = new QComboBox(parent);
        box->addItems({"Low", "Medium", "High"});
        return box;
    }
};
```

Apply delegate:

```cpp
table->setItemDelegateForColumn(1, new ComboDelegate());
```

---

## **Item-based vs Model–View (Interview Favorite)**

| Feature       | Item-based | Model–View |
| ------------- | ---------- | ---------- |
| Performance   | Low        | High       |
| Scalability   | Poor       | Excellent  |
| Customization | Limited    | Advanced   |
| Memory        | High       | Optimized  |

---

## **Common Interview Questions (Chapter 16)**

**Q: Why not use QListWidget always?**
👉 Doesn’t scale, duplicates data

**Q: Which class is base of all models?**
👉 QAbstractItemModel

**Q: When to use delegates?**
👉 Custom editing/rendering

---

## **Interview Summary (One-liners)**

* Model stores data
* View displays data
* Delegate edits & paints
* Multiple views → same model
* Best for large datasets

---

