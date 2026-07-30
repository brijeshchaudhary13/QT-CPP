
# Chapter 46 — Clipboard

---

# 1. Introduction

The **clipboard** is a temporary storage area provided by the operating system for transferring data between applications.

Common operations:

* Copy
* Cut
* Paste

Examples:

* Copy text from a browser to a Qt application.
* Paste an image into an image editor.
* Copy cells between spreadsheet applications.
* Copy beam parameters between treatment plans.

---

## Clipboard Workflow

```text
User Selects Data
        │
        ▼
      Copy
        │
        ▼
 Operating System Clipboard
        │
        ▼
      Paste
        │
        ▼
Destination Application
```

The clipboard enables communication even between unrelated applications.

---

# 2. Clipboard Architecture

Qt provides a wrapper around the operating system clipboard.

```text
Application A
      │
      ▼
 QClipboard
      │
      ▼
Operating System Clipboard
      │
      ▼
 QClipboard
      │
      ▼
Application B
```

Qt automatically integrates with:

* Windows Clipboard
* macOS Pasteboard
* Linux Clipboard Systems

---

# 3. QClipboard

The primary class is:

```cpp
#include <QClipboard>
```

A `QClipboard` object is obtained through the application object.

Example:

```cpp
QClipboard *clipboard =
    QApplication::clipboard();
```

Usually, you do **not** create `QClipboard` yourself.

---

# Responsibilities

`QClipboard` allows you to:

* Store text
* Store images
* Store pixmaps
* Store MIME data
* Read clipboard contents
* Monitor clipboard changes

---

# 4. Accessing the Clipboard

Retrieve the clipboard:

```cpp
QClipboard *clipboard =
    QApplication::clipboard();
```

Now you can:

```text
Read

Write

Clear

Monitor
```

---

# 5. Copy Operation

Simplest example:

```cpp
clipboard->setText("Hello Qt");
```

Workflow:

```text
Application

↓

setText()

↓

Clipboard Updated
```

Now:

* Ctrl + V
* Paste menu
* Another application

can retrieve the copied text.

---

# Copy Image

```cpp
clipboard->setImage(image);
```

---

# Copy Pixmap

```cpp
clipboard->setPixmap(pixmap);
```

---

# 6. Cut Operation

Qt does **not** have a dedicated `cut()` function.

Cut consists of two steps:

```text
Copy

↓

Delete Original
```

Example:

```text
Selected Text

↓

Copy To Clipboard

↓

Remove Selection
```

Most widgets such as `QLineEdit` and `QTextEdit` already implement Cut functionality.

---

# 7. Paste Operation

Retrieve text:

```cpp
QString text =
    clipboard->text();
```

Workflow:

```text
Clipboard

↓

Read Text

↓

Insert Into Widget
```

Image:

```cpp
QImage image =
    clipboard->image();
```

Pixmap:

```cpp
QPixmap pixmap =
    clipboard->pixmap();
```

---

# 8. Clipboard Modes

Qt supports multiple clipboard modes.

Enumeration:

```cpp
QClipboard::Clipboard

QClipboard::Selection

QClipboard::FindBuffer
```

---

## Clipboard

The standard clipboard.

Used on all platforms.

---

## Selection

Primarily used on X11/Linux.

Workflow:

```text
Select Text

↓

Automatically Available

↓

Middle Mouse Button

↓

Paste
```

No explicit Ctrl+C is required.

---

## FindBuffer

Available on platforms that support a separate find buffer (for example, some macOS functionality).

Stores search strings independently of the main clipboard.

---

# 9. QMimeData with Clipboard

The clipboard can store much more than plain text.

Example:

```cpp
QMimeData *mime =
    new QMimeData;
```

Store HTML:

```cpp
mime->setHtml(html);
```

Store URLs:

```cpp
mime->setUrls(urls);
```

Store Image:

```cpp
mime->setImageData(image);
```

Assign:

```cpp
clipboard->setMimeData(mime);
```

---

## Architecture

```text
Clipboard

↓

QMimeData

├── Text

├── HTML

├── Image

├── URLs

└── Custom Data
```

---

# 10. Working with Text

Copy:

```cpp
clipboard->setText(text);
```

Read:

```cpp
QString text =
    clipboard->text();
```

Applications:

* Editors
* IDEs
* Medical reports
* SQL tools

---

# 11. Working with Images

Store:

```cpp
clipboard->setImage(image);
```

Retrieve:

```cpp
QImage img =
    clipboard->image();
```

Applications:

* Screenshot tools
* Paint programs
* Medical image viewers
* CAD software

---

# 12. Working with Files (URLs)

Files are transferred as URLs.

Example:

```text
C:/Patients/John/CT001.dcm
```

Retrieve:

```cpp
mimeData->urls();
```

Workflow:

```text
Explorer

↓

Copy File

↓

Clipboard

↓

Qt Application

↓

Import File
```

---

# 13. Clipboard Signals

Qt notifies when clipboard contents change.

Important signal:

```cpp
changed(QClipboard::Mode)
```

Another useful signal:

```cpp
dataChanged()
```

Workflow:

```text
Clipboard Updated

↓

Signal Emitted

↓

Application Responds
```

Applications:

* Clipboard managers
* Live preview tools
* History managers

---

# 14. Cross-Platform Behavior

Qt hides platform differences.

| Platform    | Clipboard Support      |
| ----------- | ---------------------- |
| Windows     | Standard Clipboard     |
| Linux (X11) | Clipboard + Selection  |
| macOS       | Pasteboard Integration |

Your application typically uses the same Qt API regardless of the platform.

---

# 15. Enterprise Applications

## Medical TPS

```text
Beam Parameters

↓

Copy

↓

Clipboard

↓

Paste Into Another Plan
```

---

## CAD

```text
Selected Geometry

↓

Copy

↓

Paste

↓

Duplicate Object
```

---

## IDE

```text
Copy Code

↓

Clipboard

↓

Paste

↓

Different File
```

---

## Spreadsheet

```text
Cells

↓

Clipboard

↓

Another Sheet
```

---

# 16. Qt Internals

Conceptually:

```text
Application

↓

QClipboard

↓

QMimeData

↓

Operating System Clipboard

↓

Other Application
```

Clipboard update:

```text
Copy

↓

QClipboard

↓

OS Notification

↓

Clipboard Changed

↓

Signal
```

Qt synchronizes clipboard operations with the underlying platform clipboard service.

---

# 17. Qt 5.15 vs Qt 6.11

| Feature    | Qt 5.15 | Qt 6.11 |
| ---------- | ------- | ------- |
| QClipboard | ✔       | ✔       |
| Text       | ✔       | ✔       |
| Images     | ✔       | ✔       |
| MIME Data  | ✔       | ✔       |
| Signals    | ✔       | ✔       |

The Clipboard API remains essentially unchanged.

---

# 18. Best Practices

✅ Use `QMimeData` for complex data.

✅ Validate clipboard contents before using them.

✅ Handle empty clipboard cases gracefully.

✅ Support standard keyboard shortcuts (`Ctrl+C`, `Ctrl+X`, `Ctrl+V`) where appropriate.

✅ Preserve formatting when copying rich text if your application supports it.

---

# 19. Common Mistakes

### ❌ Assuming the clipboard always contains text

Always check before reading.

Example:

```cpp
clipboard->mimeData()->hasText()
```

---

### ❌ Ignoring image or file formats

Check the available MIME types before processing.

---

### ❌ Forgetting clipboard ownership differences on Linux

Selection and Clipboard are separate concepts on X11.

---

### ❌ Storing application-specific objects directly

Serialize them into a standard or custom MIME format first.

---

# 20. Interview Questions

## Easy

1. What is `QClipboard`?
2. How do you copy text to the clipboard?
3. How do you retrieve clipboard text?

---

## Medium

1. Explain clipboard modes.
2. What is `QMimeData`?
3. How do you copy an image?

---

## Hard

1. Explain clipboard ownership across different operating systems.
2. How would you implement copy/paste for a custom CAD object?
3. Why is MIME data preferred over plain text for complex clipboard operations?

---

## Expert

1. Design the clipboard architecture for a Medical Treatment Planning System that allows copying beams, structures, and dose constraints between treatment plans.
2. Explain how Qt abstracts different platform clipboard implementations.
3. Design a clipboard manager capable of handling text, images, files, and custom application objects.

---

# 21. Revision Notes

* `QClipboard` provides access to the operating system clipboard.
* Copy writes data to the clipboard.
* Cut is implemented as copy followed by deletion.
* Paste reads data from the clipboard.
* `QMimeData` supports text, HTML, images, URLs, and custom formats.
* Clipboard signals notify applications of content changes.
* Qt provides a consistent clipboard API across Windows, Linux, and macOS.

---


[⬅️ Drag and Drop](/DragandDrop.md)      |          [Cursor Handling ➡️](/QCursorHandling.md)
---
## **License**
This project is licensed under the MIT License.

---

Happy Coding!


## **Chapter 47 — Cursor Handling (Complete Deep Dive)**

