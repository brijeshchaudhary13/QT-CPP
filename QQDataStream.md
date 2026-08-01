# Complete Qt Master Course (Qt 5.15 LTS → Qt 6.11)

# PART VIII — File System & Data Storage

# Chapter 65 — QDataStream (Complete Deep Dive)

## Master Binary Serialization, Qt Data Streams, Versioning & Custom Type Serialization

> **Level:** Advanced → Expert

---

# Chapter Objectives

After completing this chapter, you will understand:

* What is `QDataStream`?
* Why use `QDataStream`?
* Binary Serialization
* Stream Architecture
* Reading and Writing Qt Types
* Endianness
* Stream Versions
* Custom Type Serialization
* Network Serialization
* Error Handling
* Performance Optimization
* Enterprise Applications
* Qt Internals
* Qt 5.15 vs Qt 6.11
* Best Practices
* Interview Questions

---

# Table of Contents

1. Introduction
2. Why QDataStream?
3. Architecture
4. Creating QDataStream
5. Writing Data
6. Reading Data
7. Supported Types
8. Stream Versions
9. Endianness
10. Custom Type Serialization
11. Network Serialization
12. Error Handling
13. Performance Optimization
14. Enterprise Applications
15. Qt Internals
16. Qt 5 vs Qt 6
17. Best Practices
18. Common Mistakes
19. Interview Questions
20. Revision Notes

---

# 1. Introduction

Unlike `QTextStream`, which processes **human-readable text**, `QDataStream` processes **binary data**.

Typical applications:

* Save application state
* Serialize Qt objects
* Exchange binary data
* Network communication
* Cache files
* Medical image metadata
* CAD project files

---

## QTextStream vs QDataStream

```text
QTextStream

↓

Human Readable

↓

John

25

Engineer
```

```text
QDataStream

↓

Binary

↓

010101101001...
```

---

# 2. Why QDataStream?

Suppose we have:

```cpp
QString name = "John";
int age = 25;
double dose = 75.5;
```

Using text:

```text
John
25
75.5
```

Problems:

* Parsing required
* Locale differences
* Larger file size

Using binary:

```text
Binary Stream

↓

Compact

↓

Fast

↓

Exact Representation
```

Qt automatically handles serialization of supported types.

---

# 3. Architecture

```text
Application

↓

QDataStream

↓

QIODevice

↓

QFile / QBuffer / QTcpSocket

↓

Operating System

↓

Storage / Network
```

Like `QTextStream`, `QDataStream` works with any `QIODevice`.

---

# 4. Creating QDataStream

Header

```cpp
#include <QDataStream>
```

Example

```cpp
QFile file("patient.dat");

file.open(QIODevice::WriteOnly);

QDataStream out(&file);
```

Reading

```cpp
QFile file("patient.dat");

file.open(QIODevice::ReadOnly);

QDataStream in(&file);
```

---

# 5. Writing Data

Writing is straightforward using stream operators.

Example

```cpp
QString name = "John";
int age = 25;
double dose = 75.5;

out << name
    << age
    << dose;
```

Pipeline

```text
Application

↓

QDataStream

↓

Binary Bytes

↓

Disk
```

The stream writes data in a structured binary format.

---

# 6. Reading Data

Reading follows the same order used for writing.

```cpp
QString name;
int age;
double dose;

in >> name
   >> age
   >> dose;
```

Result

```text
Binary

↓

Deserialize

↓

Variables
```

⚠️ **Important:** The read order **must match** the write order.

Incorrect order leads to corrupted data.

---

# 7. Supported Types

Qt overloads stream operators for many built-in types.

Examples:

| Type       | Supported                             |
| ---------- | ------------------------------------- |
| bool       | ✔                                     |
| int        | ✔                                     |
| double     | ✔                                     |
| QString    | ✔                                     |
| QByteArray | ✔                                     |
| QPoint     | ✔                                     |
| QRect      | ✔                                     |
| QSize      | ✔                                     |
| QColor     | ✔                                     |
| QDate      | ✔                                     |
| QTime      | ✔                                     |
| QDateTime  | ✔                                     |
| QList      | ✔ (if element type is streamable)     |
| QVector    | ✔ (if element type is streamable)     |
| QMap       | ✔ (if key/value types are streamable) |

Example

```cpp
QPoint point(10,20);

out << point;
```

No manual serialization is required.

---

# 8. Stream Versions

Binary formats evolve over time.

Qt allows versioning.

Example

```cpp
out.setVersion(
    QDataStream::Qt_6_5);
```

Reading

```cpp
in.setVersion(
    QDataStream::Qt_6_5);
```

---

## Why Versioning?

Suppose version 1 stores:

```text
Name

Age
```

Version 2 stores:

```text
Name

Age

Email
```

Without versioning:

```text
Old File

↓

New Program

↓

Incorrect Reads
```

Versioning helps maintain compatibility.

---

# 9. Endianness

Computers store bytes differently.

Two common formats:

---

Little Endian

```text
12345678

↓

78 56 34 12
```

---

Big Endian

```text
12345678

↓

12 34 56 78
```

Qt supports both.

Example

```cpp
out.setByteOrder(
    QDataStream::LittleEndian);
```

or

```cpp
out.setByteOrder(
    QDataStream::BigEndian);
```

---

Applications:

* Embedded systems
* Network protocols
* Binary file formats

---

# 10. Custom Type Serialization

Enterprise applications usually serialize custom classes.

Example

```cpp
class Patient
{
public:
    QString name;
    int age;
};
```

Implement stream operators.

Writing

```cpp
QDataStream&
operator<<(QDataStream& out,
           const Patient& p)
{
    out << p.name
        << p.age;

    return out;
}
```

Reading

```cpp
QDataStream&
operator>>(QDataStream& in,
           Patient& p)
{
    in >> p.name
       >> p.age;

    return in;
}
```

Now serialization becomes:

```cpp
Patient patient;

out << patient;
```

---

Workflow

```text
Patient

↓

operator<<

↓

QDataStream

↓

Binary File
```

---

# 11. Network Serialization

Because `QDataStream` works on `QTcpSocket`, it is useful for binary network protocols.

Architecture

```text
Client

↓

QDataStream

↓

QTcpSocket

↓

Network

↓

QTcpSocket

↓

QDataStream

↓

Server
```

Applications:

* Multiplayer games
* Medical devices
* Industrial automation
* Custom TCP protocols

---

# 12. Error Handling

Qt 6 introduced a clearer stream status API.

Example

```cpp
if (in.status() != QDataStream::Ok)
{
    // Handle error
}
```

Possible statuses include:

| Status            | Meaning                             |
| ----------------- | ----------------------------------- |
| `Ok`              | No error                            |
| `ReadPastEnd`     | Tried to read beyond available data |
| `ReadCorruptData` | Invalid or corrupted stream         |
| `WriteFailed`     | Write operation failed              |

Always verify:

* File opened successfully
* Stream status
* Expected data format

---

# 13. Performance Optimization

## Binary Is Faster

Text

```text
75.123456
```

Binary

```text
8 Bytes
```

No parsing required.

---

## Serialize Containers Directly

Instead of:

```cpp
for(...)
    out << value;
```

Often you can serialize an entire supported container:

```cpp
out << vector;
```

provided the contained type is streamable.

---

## Avoid Repeated File Opens

Bad

```text
Open

↓

Write

↓

Close

↓

Repeat
```

Better

```text
Open

↓

Many Writes

↓

Close
```

---

# 14. Enterprise Applications

## Medical TPS

```text
Treatment Plan

↓

Serialize

↓

Binary File

↓

Load Later
```

---

## CAD

```text
Drawing

↓

Binary Project

↓

Fast Loading
```

---

## ERP

```text
Cache

↓

QDataStream

↓

Disk
```

---

## Robotics

```text
Robot State

↓

Binary

↓

Network
```

---

# 15. Qt Internals

Writing pipeline

```text
Application

↓

QDataStream

↓

QIODevice

↓

Bytes

↓

Disk
```

Reading pipeline

```text
Disk

↓

Bytes

↓

QIODevice

↓

QDataStream

↓

Application
```

`QDataStream` knows how to serialize supported Qt types consistently across supported platforms.

---

# 16. Qt 5 vs Qt 6

| Feature              | Qt 5.15       | Qt 6.11                   |
| -------------------- | ------------- | ------------------------- |
| QDataStream          | ✔             | ✔                         |
| Binary Serialization | ✔             | ✔                         |
| Endianness           | ✔             | ✔                         |
| Versioning           | ✔             | ✔                         |
| Status API           | ✔ (available) | ✔ (expanded and improved) |

The API remains highly compatible between Qt 5 and Qt 6.

---

# 17. Best Practices

✅ Keep read and write order identical.

✅ Set an explicit stream version when storing persistent data.

✅ Serialize custom classes using stream operators.

✅ Check stream status after reading.

✅ Use binary serialization for performance-sensitive data.

---

# 18. Common Mistakes

### ❌ Reading fields in a different order

The stream becomes misaligned, producing incorrect values.

---

### ❌ Forgetting stream versioning

Future application versions may not read older files correctly.

---

### ❌ Using `QDataStream` for human-editable configuration files

Use `QTextStream`, JSON, XML, or INI files instead.

---

### ❌ Assuming binary files are portable forever

Changes in your own data format still require version management.

---

# 19. Interview Questions

## Easy

1. What is `QDataStream`?
2. How does it differ from `QTextStream`?
3. Why must read and write order match?

---

## Medium

1. Explain stream versioning.
2. What is endianness?
3. How do you serialize a custom class?

---

## Hard

1. Explain how `QDataStream` works with `QIODevice`.
2. Design a binary file format that supports backward compatibility.
3. Compare text serialization with binary serialization.

---

## Expert

1. Design the binary file format for a Medical Treatment Planning System that stores beam parameters, structures, optimization settings, and dose metadata while remaining backward compatible across software versions.
2. Explain how you would use `QDataStream` to communicate between a Qt desktop application and a medical device over TCP.
3. Compare `QDataStream`, Protocol Buffers, FlatBuffers, and JSON for inter-process communication and long-term data storage.

---

# 20. Revision Notes

* `QDataStream` provides binary serialization.
* It operates on any `QIODevice`.
* Read and write order must match.
* Many Qt types are streamable by default.
* Stream versions improve compatibility.
* Endianness can be configured.
* Custom classes can implement `operator<<` and `operator>>`.
* `QDataStream` is suitable for files and network communication.
* Binary serialization is typically faster and more compact than text serialization.

---

# 💡 Senior Engineer Tips

## When should you use `QDataStream`?

| Scenario               | Use QDataStream? |
| ---------------------- | ---------------- |
| Configuration file     | ✘                |
| JSON                   | ✘                |
| XML                    | ✘                |
| Binary cache           | ✔                |
| Medical binary format  | ✔                |
| Custom TCP protocol    | ✔                |
| Save application state | ✔                |

### Medical TPS Example

```text
TreatmentPlan

      │
      ▼
QDataStream

      │
      ▼
TreatmentPlan.tps

      │
      ▼
Later Restore

      │
      ▼
Dose Engine
```

Binary serialization allows treatment plans and calculation results to be saved and restored efficiently while preserving numeric precision.

---


## **Chapter 66 — JSON (Complete Deep Dive)**

