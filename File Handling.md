## **1. QFile**

### **Definition**

`QFile` is a Qt class used to **read from and write to files** in a **platform-independent** way.

---

### **Why QFile is needed**

* Same code works on Windows, Linux, macOS
* Integrates with Qt Resource System
* Supports text and binary files
* Better error handling than `fstream`

---

### **How QFile works**

1. Create `QFile` object with file path
2. Open file with mode
3. Read/write data
4. Close file

---

### **Example – Open a File**

```cpp
QFile file("data.txt");

if (!file.open(QIODevice::ReadOnly)) {
    qDebug() << "Cannot open file";
    return;
}
```

---

## **2. QTextStream**

### **Definition**

`QTextStream` is used to **read and write text data** using Unicode (UTF-8 by default).

---

### **Why QTextStream**

* Human-readable text
* Handles encoding automatically
* Easy line-by-line reading

---

### **How QTextStream works**

* Works on top of `QFile`
* Uses stream operators (`<<`, `>>`)

---

### **Example – Read Text**

```cpp
QFile file("data.txt");
file.open(QIODevice::ReadOnly | QIODevice::Text);

QTextStream in(&file);
QString line = in.readLine();
```

---

### **Example – Write Text**

```cpp
QFile file("out.txt");
file.open(QIODevice::WriteOnly | QIODevice::Text);

QTextStream out(&file);
out << "Hello Qt\n";
```

---

## **3. QDataStream**

### **Definition**

`QDataStream` is used to **read and write binary data** in a **platform-independent format**.

---

### **Why QDataStream**

* Fast binary I/O
* Data consistency across platforms
* Used for serialization

---

### **How QDataStream works**

* Writes raw binary
* Uses versioning
* Requires same read/write order

---

### **Example – Write Binary**

```cpp
QFile file("data.bin");
file.open(QIODevice::WriteOnly);

QDataStream out(&file);
out << 10 << 3.14 << QString("Qt");
```

---

### **Example – Read Binary**

```cpp
QFile file("data.bin");
file.open(QIODevice::ReadOnly);

QDataStream in(&file);
int i;
double d;
QString s;

in >> i >> d >> s;
```

---

## **4. Reading and Writing Files**

---

### **Text File Flow**

```text
QFile → QTextStream → QString
```

---

### **Binary File Flow**

```text
QFile → QDataStream → Raw data
```

---

### **Example – Append to File**

```cpp
QFile file("log.txt");
file.open(QIODevice::Append | QIODevice::Text);

QTextStream out(&file);
out << "New log entry\n";
```

---

## **5. Binary vs Text Files**

### **Text Files**

* Human-readable
* Larger size
* Slower

### **Binary Files**

* Machine-readable
* Smaller size
* Faster

---

### **Comparison**

| Feature  | Text         | Binary       |
| -------- | ------------ | ------------ |
| Readable | Yes          | No           |
| Speed    | Slower       | Faster       |
| Size     | Larger       | Smaller      |
| Usage    | Logs, config | Data storage |

---

## **6. File Permissions**

### **Definition**

File permissions control **read, write, execute access**.

---

### **Why permissions matter**

* Security
* Prevent unauthorized access
* OS compliance

---

### **How to check permissions**

```cpp
QFile::Permissions perms = file.permissions();

if (perms & QFile::ReadOwner) {
    qDebug() << "Readable";
}
```

---

### **How to set permissions**

```cpp
file.setPermissions(QFile::ReadOwner | QFile::WriteOwner);
```

---

## **7. Directory Handling using QDir**

### **Definition**

`QDir` is used to **work with directories**.

---

### **Why QDir**

* List files
* Create/remove folders
* Platform-independent paths

---

### **How QDir works**

* Represents a directory
* Provides filters and iterators

---

### **Example – List Files**

```cpp
QDir dir(".");

QStringList files = dir.entryList(QDir::Files);
for (const QString &f : files) {
    qDebug() << f;
}
```

---

### **Create Directory**

```cpp
QDir().mkdir("newFolder");
```

---

### **Remove Directory**

```cpp
QDir("newFolder").removeRecursively();
```

---

## **8. Drag and Drop File Handling**

---

### **Definition**

Drag & Drop allows users to **drag files from OS and drop them into the application**.

---

### **Why Drag & Drop**

* Better user experience
* Faster file selection
* Modern UI behavior

---

### **How Drag & Drop works**

1. Enable drag events
2. Accept drop events
3. Extract file paths

---

### **Example**

```cpp
class DropWidget : public QWidget
{
protected:
    void dragEnterEvent(QDragEnterEvent *event) override {
        if (event->mimeData()->hasUrls())
            event->acceptProposedAction();
    }

    void dropEvent(QDropEvent *event) override {
        for (const QUrl &url : event->mimeData()->urls()) {
            qDebug() << url.toLocalFile();
        }
    }
};
```

---

## **Common Mistakes (Interview Traps)**

❌ Not checking `open()` result
❌ Mixing text & binary streams
❌ Reading binary in wrong order
❌ Forgetting to close file

---

## **Interview Questions (Chapter 12)**

**Q: Difference between QTextStream and QDataStream?**
👉 Text vs binary, readable vs fast

**Q: Can QFile read resource files?**
👉 Yes, using `:/`

**Q: How to append to file?**
👉 `QIODevice::Append`

---

## **Interview Summary (One-liners)**

* QFile → file access
* QTextStream → text I/O
* QDataStream → binary I/O
* QDir → directory handling
* Drag & Drop → UX improvement

---

