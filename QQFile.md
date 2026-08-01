# Complete Qt Master Course (Qt 5.15 LTS → Qt 6.11)

# PART VIII — File System & Data Storage

# Chapter 63 — QFile (Complete Deep Dive)

## Master File Handling, Binary I/O, Large File Processing & Cross-Platform File Operations

> **Level:** Intermediate → Advanced

---

# Chapter Objectives

After completing this chapter, you will understand:

* What is `QFile`?
* QFile Architecture
* Opening and Closing Files
* Reading Files
* Writing Files
* Text vs Binary Files
* File Permissions
* Copy, Move, Rename & Delete
* Temporary Files
* Large File Handling
* Random Access
* Error Handling
* Enterprise Applications
* Qt Internals
* Qt 5.15 vs Qt 6.11
* Best Practices
* Interview Questions

---

# Table of Contents

1. Introduction
2. QFile Architecture
3. Creating a QFile
4. Opening Files
5. Reading Files
6. Writing Files
7. Text vs Binary Files
8. Random Access
9. File Information
10. File Operations
11. File Permissions
12. Temporary Files
13. Error Handling
14. Large File Handling
15. Enterprise Applications
16. Qt Internals
17. Qt 5 vs Qt 6
18. Best Practices
19. Common Mistakes
20. Interview Questions
21. Revision Notes

---

# 1. Introduction

Almost every desktop application interacts with files.

Examples:

* Save user settings
* Read configuration files
* Export reports
* Load images
* Read DICOM files
* Save CAD drawings
* Store logs

Qt provides the `QFile` class for platform-independent file handling.

---

## QFile Hierarchy

```text
QObject
    │
    ▼
QIODevice
    │
    ▼
QFileDevice
    │
    ▼
QFile
```

`QFile` inherits from `QIODevice`, which means it uses the same API as many other Qt I/O classes (such as sockets and buffers).

---

# 2. QFile Architecture

```text
Application

↓

QFile

↓

QIODevice

↓

Operating System

↓

File System

↓

Disk
```

Qt abstracts platform differences so the same code works on:

* Windows
* Linux
* macOS

---

# 3. Creating a QFile

Header

```cpp
#include <QFile>
```

Create a file object

```cpp
QFile file("patients.txt");
```

At this point:

* No file is opened.
* No disk access occurs.

The object simply represents a file.

---

# 4. Opening Files

A file must be opened before use.

Example

```cpp
QFile file("patients.txt");

if(file.open(QIODevice::ReadOnly))
{
    // Read data
}
```

---

## Open Modes

| Mode        | Purpose                 |
| ----------- | ----------------------- |
| `ReadOnly`  | Read existing file      |
| `WriteOnly` | Write file              |
| `ReadWrite` | Read and write          |
| `Append`    | Add data to end         |
| `Truncate`  | Clear existing contents |
| `Text`      | Text mode               |

---

## Multiple Modes

```cpp
file.open(
    QIODevice::WriteOnly |
    QIODevice::Text);
```

---

## Lifecycle

```text
Create QFile

↓

Open

↓

Read/Write

↓

Close
```

---

# 5. Reading Files

Read entire file

```cpp
QByteArray data =
    file.readAll();
```

---

Read fixed number of bytes

```cpp
QByteArray data =
    file.read(100);
```

---

Read line

```cpp
QByteArray line =
    file.readLine();
```

---

Read until end

```cpp
while(!file.atEnd())
{
    QByteArray line =
        file.readLine();
}
```

---

## Workflow

```text
Disk

↓

QFile

↓

Memory

↓

Application
```

---

# 6. Writing Files

Write text

```cpp
file.write("Hello Qt");
```

Write binary data

```cpp
QByteArray buffer;

file.write(buffer);
```

---

Flush data

```cpp
file.flush();
```

Although `close()` also flushes buffered data, calling `flush()` can be useful when you want to ensure data reaches the operating system before closing the file.

---

Close file

```cpp
file.close();
```

---

## Writing Pipeline

```text
Application

↓

Memory Buffer

↓

QFile

↓

Operating System

↓

Disk
```

---

# 7. Text vs Binary Files

## Text File

```text
Patient

John

Age

45
```

Advantages:

* Human-readable
* Easy debugging
* Portable

Disadvantages:

* Larger size
* Slower parsing

---

## Binary File

```text
001010101010100101...
```

Advantages:

* Compact
* Fast
* Efficient

Disadvantages:

* Not human-readable
* Requires defined format

---

## Which Should You Use?

| Scenario              | Recommended |
| --------------------- | ----------- |
| Config files          | Text        |
| Logs                  | Text        |
| Images                | Binary      |
| DICOM                 | Binary      |
| Databases             | Binary      |
| Medical dose matrices | Binary      |

---

# 8. Random Access

`QFile` supports random access.

Move file pointer

```cpp
file.seek(100);
```

Current position

```cpp
qint64 pos =
    file.pos();
```

Move to beginning

```cpp
file.seek(0);
```

---

## Example

```text
File

ABCDEFGHIJKLMNOP

↓

seek(5)

↓

FGHIJK...
```

Applications:

* Large binary files
* Medical images
* Video
* Databases

---

# 9. File Information

Retrieve file size

```cpp
file.size();
```

Check existence

```cpp
file.exists();
```

File name

```cpp
file.fileName();
```

---

Use `QFileInfo` when you need richer metadata such as:

* Last modified time
* Absolute path
* Owner (platform-dependent)
* File type
* Permissions

We'll cover `QFileInfo` in a later chapter.

---

# 10. File Operations

Copy

```cpp
QFile::copy(
    "A.txt",
    "B.txt");
```

Rename

```cpp
QFile::rename(
    "Old.txt",
    "New.txt");
```

Remove

```cpp
QFile::remove(
    "Old.txt");
```

---

Example Workflow

```text
Old File

↓

Rename

↓

New File
```

---

# 11. File Permissions

Check permissions

```cpp
file.permissions();
```

Set permissions

```cpp
file.setPermissions(...);
```

Common permissions:

* Read
* Write
* Execute

Permission support varies somewhat across operating systems and file systems.

---

# 12. Temporary Files

Qt provides:

```cpp
QTemporaryFile
```

Applications:

* Intermediate reports
* Export buffers
* Image processing
* Medical dose calculations

Workflow

```text
Temporary File

↓

Use

↓

Automatic Cleanup
```

Temporary files help avoid leaving unnecessary files on disk.

---

# 13. Error Handling

Always check whether `open()` succeeds.

Good

```cpp
if(file.open(...))
{
}
else
{
    qDebug()
        << file.errorString();
}
```

Common errors:

* File not found
* Permission denied
* Disk full
* File locked
* Invalid path

---

## Error Pipeline

```text
Open File

↓

Success ?

↓

Yes

↓

Continue

OR

↓

Error

↓

Handle
```

---

# 14. Large File Handling

Never load huge files unnecessarily.

Bad

```cpp
file.readAll();
```

for:

```text
20 GB File
```

---

Better

```text
Read

↓

Chunk

↓

Process

↓

Next Chunk
```

Example concept

```cpp
while(!file.atEnd())
{
    QByteArray block =
        file.read(4096);

    // Process block
}
```

Advantages:

* Lower memory usage
* Better scalability
* Faster processing for streaming workflows

---

# 15. Enterprise Applications

## Medical TPS

```text
Patient Data

↓

QFile

↓

DICOM Loader

↓

Dose Engine
```

---

## CAD

```text
Drawing

↓

DWG / DXF Reader

↓

QFile

↓

Parser
```

---

## IDE

```text
Source Code

↓

QFile

↓

Syntax Highlighter
```

---

## Log Viewer

```text
Log File

↓

QFile

↓

Parser

↓

Table View
```

---

# 16. Qt Internals

Read pipeline

```text
Application

↓

QFile

↓

QIODevice

↓

Operating System

↓

Disk
```

Write pipeline

```text
Application

↓

QFile Buffer

↓

Operating System

↓

Disk
```

Because `QFile` inherits from `QIODevice`, many I/O classes in Qt expose a consistent interface for reading and writing.

---

# 17. Qt 5 vs Qt 6

| Feature       | Qt 5.15 | Qt 6.11 |
| ------------- | ------- | ------- |
| QFile         | ✔       | ✔       |
| Binary I/O    | ✔       | ✔       |
| Text Mode     | ✔       | ✔       |
| Random Access | ✔       | ✔       |
| Large Files   | ✔       | ✔       |

The `QFile` API is stable and essentially unchanged between Qt 5 and Qt 6.

---

# 18. Best Practices

✅ Always check the return value of `open()`.

✅ Close files when finished (or rely on RAII by letting the `QFile` object go out of scope).

✅ Read large files in chunks instead of using `readAll()`.

✅ Use binary mode for binary formats.

✅ Keep file paths configurable instead of hardcoding them.

---

# 19. Common Mistakes

### ❌ Forgetting to open the file

Operations such as `read()` and `write()` fail if the file is not open.

---

### ❌ Ignoring `errorString()`

Meaningful error messages simplify debugging and user feedback.

---

### ❌ Using `readAll()` for huge files

This can consume excessive memory.

---

### ❌ Forgetting to close long-lived files

Leaving files open unnecessarily may hold locks or consume resources.

---

# 20. Interview Questions

## Easy

1. What is `QFile`?
2. Why does `QFile` inherit from `QIODevice`?
3. What is the difference between `ReadOnly` and `WriteOnly`?

---

## Medium

1. Explain the difference between text and binary files.
2. What is `seek()` used for?
3. Why should `open()` always be checked?

---

## Hard

1. Explain how `QFile` interacts with `QIODevice`.
2. How would you process a 20 GB log file efficiently?
3. Compare chunk-based reading with `readAll()`.

---

## Expert

1. Design a file-loading subsystem for a Medical Treatment Planning System that imports large DICOM datasets while minimizing memory usage.
2. Explain how to implement a robust cross-platform file service that supports logging, configuration files, report generation, and temporary files.
3. Compare `QFile`, C++ standard file streams (`std::ifstream`/`std::ofstream`), and native OS APIs in terms of portability, integration with Qt, and maintainability.

---

# 21. Revision Notes

* `QFile` provides platform-independent file access.
* It inherits from `QIODevice`.
* Files must be opened before reading or writing.
* `QIODevice` open modes control access behavior.
* `readAll()`, `read()`, and `readLine()` provide different reading strategies.
* `write()` stores text or binary data.
* `seek()` enables random access.
* `QFile` supports copy, rename, and remove operations.
* `QTemporaryFile` is useful for temporary data.
* Chunk-based reading is preferred for very large files.

---

# 💡 Senior Engineer Tips

## Choosing the Right File Strategy

| Scenario             | Recommended Approach          |
| -------------------- | ----------------------------- |
| Configuration file   | `QFile` + `QTextStream`       |
| Log file             | `QFile` + append mode         |
| Binary medical image | `QFile` + binary reads        |
| Large log analysis   | Chunked reading with `read()` |
| Temporary export     | `QTemporaryFile`              |

### Medical TPS Example

```text
RTDose.dcm

        │
        ▼
      QFile

        │
        ▼
Chunk Reader

        │
        ▼
Dose Matrix Parser

        │
        ▼
Dose Engine
```

Instead of loading the entire file into memory, production TPS software often processes large datasets incrementally, improving memory efficiency and responsiveness.

---


## **Chapter 64 — QTextStream (Complete Deep Dive)**
