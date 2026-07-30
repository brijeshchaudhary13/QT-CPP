
# Chapter 45 — Drag and Drop (Complete Deep Dive)

---

# 1. Introduction

Drag and Drop (DnD) allows users to move or copy data by clicking, dragging, and dropping it.

Examples:

* Draging files into a file explorer
* Moving emails between folders
* Rearranging tabs
* Dragging widgets in Qt Designer
* Moving beams in a TPS
* Rearranging layers in Photoshop

Instead of using **Copy → Paste**, users simply drag an object from one place and drop it somewhere else.

---

## General Workflow

```text
User Selects Object
        │
        ▼
Starts Drag
        │
        ▼
Moves Mouse
        │
        ▼
Drop Target Accepts
        │
        ▼
Drop Completed
```

---

# 2. Drag-and-Drop Architecture

Qt divides Drag and Drop into two parts.

```text
Drag Source
      │
      ▼
 QDrag
      │
      ▼
QMimeData
      │
      ▼
Drop Target
```

Responsibilities:

| Component   | Responsibility          |
| ----------- | ----------------------- |
| Drag Source | Starts drag             |
| QDrag       | Manages drag operation  |
| QMimeData   | Stores transferred data |
| Drop Target | Receives data           |

---

# Architecture Diagram

```text
Source Widget

↓

QDrag

↓

QMimeData

↓

Operating System

↓

Target Widget
```

---

# 3. Drag Source

The widget that starts dragging is called the **Drag Source**.

Examples:

* QListWidget
* QTreeWidget
* QLabel
* Custom Widget

A drag usually starts after the user presses the mouse and moves it beyond a minimum distance.

Typical sequence:

```text
Mouse Press

↓

Mouse Move

↓

Create QDrag

↓

Execute Drag
```

---

# 4. Drop Target

A widget that accepts dropped data is called a **Drop Target**.

Enable dropping:

```cpp
setAcceptDrops(true);
```

Without enabling this property:

```text
Drop Ignored
```

---

# 5. QDrag

`QDrag` controls the drag operation.

Header:

```cpp
#include <QDrag>
```

Create:

```cpp
QDrag *drag = new QDrag(this);
```

Attach data:

```cpp
drag->setMimeData(mimeData);
```

Start:

```cpp
drag->exec();
```

Flow:

```text
Create Drag

↓

Attach Data

↓

Start

↓

Drop
```

---

# 6. QMimeData

`QMimeData` stores the transferred data.

Header:

```cpp
#include <QMimeData>
```

Create:

```cpp
QMimeData *mime = new QMimeData;
```

Store text:

```cpp
mime->setText("Patient001");
```

Store URL:

```cpp
mime->setUrls(urls);
```

Store image:

```cpp
mime->setImageData(image);
```

Store HTML:

```cpp
mime->setHtml(html);
```

---

## Common MIME Types

| MIME Type            | Example     |
| -------------------- | ----------- |
| text/plain           | Text        |
| text/html            | HTML        |
| image/png            | PNG Image   |
| text/uri-list        | Files       |
| application/json     | JSON        |
| application/x-custom | Custom Data |

---

# 7. Drag-and-Drop Events

Qt provides several event handlers.

---

## dragEnterEvent()

Called when dragged data enters the widget.

```cpp
void dragEnterEvent(QDragEnterEvent *event)
{
}
```

Accept:

```cpp
event->acceptProposedAction();
```

---

## dragMoveEvent()

Called while moving inside the widget.

```cpp
void dragMoveEvent(QDragMoveEvent *event)
{
}
```

---

## dragLeaveEvent()

Called when the drag leaves the widget.

```cpp
void dragLeaveEvent(QDragLeaveEvent *event)
{
}
```

---

## dropEvent()

Called when the user drops the data.

```cpp
void dropEvent(QDropEvent *event)
{
}
```

Typical flow:

```text
dragEnterEvent()

↓

dragMoveEvent()

↓

dropEvent()
```

---

# 8. Drop Actions

Qt supports several actions.

```text
Copy

Move

Link

Ignore
```

Enumeration:

```cpp
Qt::CopyAction

Qt::MoveAction

Qt::LinkAction
```

---

## Copy

```text
Original Remains

↓

Duplicate Created
```

Example:

Copy file.

---

## Move

```text
Original Removed

↓

Moved
```

Example:

Move email.

---

## Link

```text
Shortcut Created
```

Example:

Desktop shortcut.

---

# 9. Internal Drag and Drop

Source and destination are inside the same application.

Example:

```text
Project Explorer

↓

Drag File

↓

Different Folder
```

Common examples:

* Reordering list items
* Tree restructuring
* Dock rearrangement

---

# 10. External Drag and Drop

Different applications communicate.

Example:

```text
Windows Explorer

↓

Qt Application
```

or

```text
Qt Application

↓

Desktop
```

Qt automatically works with operating system drag-and-drop mechanisms.

---

# 11. File Drag and Drop

Very common feature.

Workflow:

```text
Explorer

↓

Drag Files

↓

Qt Window

↓

Open Files
```

Retrieve files:

```cpp
event->mimeData()->urls();
```

Example:

```text
Patient001.dcm

Patient002.dcm

Patient003.dcm
```

Used in:

* DICOM Viewer
* Image Editor
* IDE
* Media Player

---

# 12. Custom MIME Types

Professional applications often exchange custom data.

Example:

```text
application/x-patient
```

or

```text
application/x-beam
```

Workflow:

```text
Beam

↓

Serialize

↓

QMimeData

↓

Drop

↓

Deserialize
```

Useful when transferring objects within the same application.

---

# 13. Drag Pixmap & Cursor

Qt allows customizing the drag appearance.

Example:

```cpp
drag->setPixmap(iconPixmap);
```

Result:

```text
Mouse Cursor

↓

Object Preview
```

Hotspot:

```cpp
drag->setHotSpot(QPoint(10,10));
```

The hotspot defines where the cursor appears relative to the drag pixmap.

---

# 14. Model/View Drag and Drop

Qt's Model/View framework has built-in support.

Views:

```text
QTreeView

QListView

QTableView
```

Models can implement:

* Supported drag actions
* Supported drop actions
* MIME data generation
* MIME data parsing

This enables:

* Row reordering
* Tree restructuring
* Item movement

without manually handling every mouse event.

---

# 15. Enterprise Examples

## Medical TPS

```text
Patient Browser

↓

Drag Patient

↓

Plan Viewer
```

---

```text
Beam Library

↓

Drag Beam

↓

Treatment Plan
```

---

## IDE

```text
Project Explorer

↓

Drag File

↓

Folder
```

---

## CAD

```text
Symbol Library

↓

Drag Symbol

↓

Drawing
```

---

## GIS

```text
Layer Panel

↓

Drag Layer

↓

Map
```

---

# 16. Qt Internals

Conceptually:

```text
Mouse Press

↓

Mouse Move

↓

QDrag

↓

QMimeData

↓

Operating System

↓

Target Widget

↓

dropEvent()
```

Internally:

```text
Drag Source

↓

MIME Package

↓

OS Drag Manager

↓

Target

↓

Event Loop
```

Qt integrates with the platform's native drag-and-drop system, so dragging between Qt and non-Qt applications is generally supported when compatible MIME types are used.

---

# 17. Qt 5.15 vs Qt 6.11

| Feature      | Qt 5.15 | Qt 6.11 |
| ------------ | ------- | ------- |
| QDrag        | ✔       | ✔       |
| QMimeData    | ✔       | ✔       |
| Internal DnD | ✔       | ✔       |
| External DnD | ✔       | ✔       |
| Custom MIME  | ✔       | ✔       |

The Drag-and-Drop API is stable across Qt versions.

---

# 18. Best Practices

✅ Accept only supported MIME types.

✅ Validate dropped data before processing.

✅ Use meaningful custom MIME types for application-specific objects.

✅ Provide visual feedback while dragging.

✅ Use copy or move actions that match user expectations.

---

# 19. Common Mistakes

### ❌ Forgetting `setAcceptDrops(true)`

The widget will never receive drag events.

---

### ❌ Accepting every MIME type

Always check:

```cpp
event->mimeData()->hasText()

event->mimeData()->hasUrls()

event->mimeData()->hasImage()
```

or your custom MIME type before accepting.

---

### ❌ Not handling unsupported drops

Reject invalid data gracefully.

---

### ❌ Assuming dropped files always exist

Files may have been moved, deleted, or become inaccessible.

---

# 20. Interview Questions

## Easy

1. What is Drag and Drop?
2. What is `QDrag`?
3. What is `QMimeData`?

---

## Medium

1. Explain the drag-and-drop workflow.
2. Compare internal and external drag-and-drop.
3. What are MIME types?

---

## Hard

1. Explain the sequence of drag-and-drop events.
2. How would you implement drag-and-drop in a `QTreeView` using the Model/View framework?
3. Why are custom MIME types useful?

---

## Expert

1. Design a drag-and-drop architecture for a Medical Treatment Planning System where beams can be dragged from a beam library into a treatment plan.
2. Explain how Qt integrates with the operating system's drag-and-drop manager.
3. Design a custom MIME protocol for transferring CAD objects between two Qt applications.

---

[⬅️ MDI Applications](/QMDIApplications.md)      |          [Clipboard ➡️](/Clipboard.md)
---
## **License**
This project is licensed under the MIT License.

---

Happy Coding!



