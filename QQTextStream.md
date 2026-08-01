# Complete Qt Master Course (Qt 5.15 LTS → Qt 6.11)

# PART VIII — File System & Data Storage

# Chapter 64 — QTextStream (Complete Deep Dive)

## Master Text File Processing, UTF-8, CSV Handling, Formatting & Stream-Based I/O

> **Level:** Intermediate → Advanced

---

# Chapter Objectives

After completing this chapter, you will understand:

* What is `QTextStream`?
* Why use `QTextStream`?
* Architecture
* Reading Text Files
* Writing Text Files
* Character Encoding
* UTF-8, UTF-16, UTF-32
* Locale-Aware Formatting
* Reading Line by Line
* Stream Operators
* CSV Processing
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
2. Why QTextStream?
3. Architecture
4. Creating QTextStream
5. Reading Text
6. Writing Text
7. Character Encoding
8. Reading Line by Line
9. Stream Operators
10. Formatting
11. CSV Processing
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

`QFile` reads and writes **raw bytes**.

However, most applications deal with **text**, not bytes.

Examples:

* Configuration files
* CSV files
* Log files
* XML
* JSON
* Source code
* Reports

Qt provides **`QTextStream`** to make text processing simple, portable, and encoding-aware.

---

## QFile vs QTextStream

```text id="yap1mg"
QFile

↓

Raw Bytes
```

```text id="vtdh6o"
QTextStream

↓

Characters

↓

Strings
```

---

# 2. Why QTextStream?

Suppose we have:

```text id="czos67"
patients.txt

John

25

Cancer
```

Without `QTextStream`, you would manually:

* Read bytes
* Convert encoding
* Split lines
* Parse text

With `QTextStream`:

```text id="wrzjlwm"
Read Line

↓

QString

↓

Done
```

The stream handles text conversion for you.

---

# 3. Architecture

```text id="jlwm641"
Application

↓

QTextStream

↓

QIODevice

↓

QFile

↓

Operating System

↓

Disk
```

Notice that `QTextStream` operates on any `QIODevice`, not just `QFile`.

This means it can also work with:

* `QBuffer`
* `QTcpSocket`
* `QProcess`
* `QSaveFile`
* Other `QIODevice` subclasses

---

# 4. Creating QTextStream

Header

```cpp id="jlwm642"
#include <QTextStream>
```

Example

```cpp id="jlwm643"
QFile file("patients.txt");

file.open(
    QIODevice::ReadOnly |
    QIODevice::Text);

QTextStream stream(&file);
```

The stream now reads characters from the file.

---

# 5. Reading Text

Read entire file

```cpp id="jlwm644"
QString text =
    stream.readAll();
```

---

Read line

```cpp id="jlwm645"
QString line =
    stream.readLine();
```

---

Read until end

```cpp id="jlwm646"
while(!stream.atEnd())
{
    QString line =
        stream.readLine();
}
```

---

Workflow

```text id="jlwm647"
Disk

↓

QFile

↓

QTextStream

↓

QString

↓

Application
```

---

# Reading Words

Example

```cpp id="jlwm648"
QString word;

stream >> word;
```

Input

```text id="jlwm649"
John Smith 25
```

Reads

```text id="jlwm650"
John

↓

Smith

↓

25
```

using whitespace as the default separator.

---

# 6. Writing Text

Example

```cpp id="jlwm651"
stream << "Patient\n";
```

Multiple values

```cpp id="jlwm652"
stream

<< "John "

<< 25

<< "\n";
```

Output

```text id="jlwm653"
John 25
```

---

Workflow

```text id="jlwm654"
QString

↓

QTextStream

↓

QFile

↓

Disk
```

---

# 7. Character Encoding

A major advantage of `QTextStream` is handling text encodings.

Common encodings:

| Encoding | Description                 |
| -------- | --------------------------- |
| UTF-8    | Most common                 |
| UTF-16   | Unicode (16-bit code units) |
| UTF-32   | Unicode (32-bit code units) |
| Latin-1  | Legacy Western encoding     |

---

## Qt 6

In Qt 6, `QTextStream` uses UTF-8 by default unless configured otherwise.

You can explicitly set the encoding when needed.

Example:

```cpp
stream.setEncoding(QStringConverter::Utf8);
```

Other encodings are available through `QStringConverter`.

---

## Why Encoding Matters

Without correct encoding:

```text id="jlwm655"
नमस्ते
```

may appear as unreadable or corrupted characters if interpreted using the wrong encoding.

---

# 8. Reading Line by Line

Most enterprise applications process text incrementally.

Example

```text id="jlwm656"
Log File

↓

Line 1

↓

Line 2

↓

Line 3
```

Instead of loading everything into memory.

---

Example

```cpp id="jlwm657"
while(!stream.atEnd())
{
    QString line =
        stream.readLine();

    // Process
}
```

Applications:

* Logs
* CSV
* XML
* Source code

---

# 9. Stream Operators

`QTextStream` overloads stream operators.

Write

```cpp id="jlwm658"
stream << value;
```

Read

```cpp id="’wini659"
stream >> value;
```

Supported types include:

* `QString`
* `int`
* `double`
* `float`
* `bool`
* Many other Qt and C++ primitive types

---

Example

```cpp id="’wini660"
int age;

stream >> age;
```

Input

```text id="’wini661"
25
```

Output

```text id="’wini662"
age = 25
```

---

# 10. Formatting

`QTextStream` supports formatted output.

Example

```cpp id="’wini663"
stream.setFieldWidth(10);
```

Alignment

```cpp id="’wini664"
stream.setFieldAlignment(
    QTextStream::AlignLeft);
```

Number formatting

```cpp id="’wini665"
stream.setRealNumberNotation(
    QTextStream::FixedNotation);
```

Applications:

* Reports
* Tables
* Console output
* Export files

---

Example

```text id="’wini666"
Name       Age

John       25

Alice      30
```

---

# 11. CSV Processing

CSV files are commonly processed with `QTextStream`.

Example

```text id="’wini667"
ID,Name,Age

1,John,25

2,Alice,30
```

Read line

```cpp id="’wini668"
QString line =
    stream.readLine();
```

Split

```cpp id="’wini669"
QStringList fields =
    line.split(",");
```

Applications:

* Excel exports
* Reports
* Medical patient lists
* ERP

> **Note:** This simple approach works for basic CSV files. Production CSV parsers should correctly handle quoted fields, embedded commas, and escaped quotes.

---

# 12. Error Handling

Always verify the file opened successfully before constructing or using the stream.

```cpp id="’wini670"
if(file.open(...))
{
}
else
{
    qDebug()
        << file.errorString();
}
```

When reading, also consider:

* Unexpected end of file
* Invalid input format
* Encoding mismatches

---

# 13. Performance Optimization

## Avoid `readAll()` for Huge Files

Bad

```cpp id="’wini671"
stream.readAll();
```

for

```text id="’wini672"
10 GB Log
```

---

Better

```text id="’wini673"
Line

↓

Process

↓

Next Line
```

---

## Buffering

`QTextStream` performs buffering internally, reducing the number of operating system read/write calls.

---

## Avoid Repeated String Copies

Where practical, process data as it is read rather than storing every line.

---

# 14. Enterprise Applications

---

## Medical TPS

```text id="’wini674"
Configuration File

↓

QTextStream

↓

Parser

↓

Dose Engine
```

---

## IDE

```text id="’wini675"
Source Code

↓

QTextStream

↓

Syntax Analyzer
```

---

## Log Viewer

```text id="’wini676"
Log

↓

QTextStream

↓

Filter

↓

UI
```

---

## ERP

```text id="’wini677"
CSV

↓

Import

↓

Database
```

---

# 15. Qt Internals

Read pipeline

```text id="’wini678"
Disk

↓

QFile

↓

QTextStream

↓

Unicode

↓

QString
```

Write pipeline

```text id="’wini679"
QString

↓

Encoding

↓

QTextStream

↓

QFile

↓

Disk
```

`QTextStream` converts between bytes and Unicode text based on the configured encoding.

---

# 16. Qt 5 vs Qt 6

| Feature          | Qt 5.15      | Qt 6.11                              |
| ---------------- | ------------ | ------------------------------------ |
| QTextStream      | ✔            | ✔                                    |
| UTF-8 Support    | ✔            | ✔                                    |
| Unicode          | ✔            | ✔                                    |
| Formatted Output | ✔            | ✔                                    |
| Encoding API     | `setCodec()` | `setEncoding(QStringConverter::...)` |

### Migration Note

Qt 5:

```cpp
stream.setCodec("UTF-8");
```

Qt 6:

```cpp
stream.setEncoding(QStringConverter::Utf8);
```

The old codec-based API was replaced by the newer encoding API.

---

# 17. Best Practices

✅ Use `QTextStream` for text files.

✅ Use UTF-8 unless another encoding is required.

✅ Read large files line by line.

✅ Check file open errors before creating the stream.

✅ Use formatted output for reports.

---

# 18. Common Mistakes

### ❌ Using `QTextStream` for binary files

Binary formats should be handled with `QDataStream` or raw byte operations.

---

### ❌ Using `readAll()` on huge log files

This can consume excessive memory.

---

### ❌ Ignoring file encoding

Incorrect encoding can corrupt displayed text.

---

### ❌ Assuming every CSV can be split on commas

Quoted fields require a proper CSV parser.

---

# 19. Interview Questions

## Easy

1. What is `QTextStream`?
2. Why use it instead of `QFile` alone?
3. How do you read a line from a file?

---

## Medium

1. Explain UTF-8 handling in Qt.
2. What changed in the encoding API from Qt 5 to Qt 6?
3. Why is line-by-line reading preferred for large files?

---

## Hard

1. Explain how `QTextStream` converts bytes into `QString`.
2. Compare `QTextStream` and `QDataStream`.
3. How would you efficiently process a 20 GB log file?

---

## Expert

1. Design a log analysis tool that processes multi-gigabyte UTF-8 log files while keeping memory usage low.
2. Explain how you would build a robust CSV importer that correctly handles quoted fields, malformed rows, and different encodings.
3. Compare `QTextStream`, C++ iostreams, and C standard I/O (`FILE*`) for cross-platform Qt applications.

---

# 20. Revision Notes

* `QTextStream` provides text-oriented I/O.
* It operates on any `QIODevice`.
* It converts bytes to Unicode text.
* `readLine()` is ideal for sequential processing.
* Stream operators (`<<` and `>>`) simplify formatted I/O.
* Qt 6 uses `QStringConverter` for encoding configuration.
* UTF-8 is the default encoding in Qt 6.
* Avoid using `QTextStream` for binary formats.
* Process large text files incrementally instead of loading them entirely.

---

# 💡 Senior Engineer Tips

## When should you use `QTextStream`?

| Scenario           | Use QTextStream?  |
| ------------------ | ----------------- |
| Configuration file | ✔                 |
| CSV import/export  | ✔                 |
| Log file           | ✔                 |
| JSON (text)        | ✔                 |
| XML                | ✔                 |
| Binary DICOM file  | ✘                 |
| Serialized objects | ✘ (`QDataStream`) |

### Medical TPS Example

```text id="tpstext1"
DoseEngine.conf

        │
        ▼
      QFile

        │
        ▼
    QTextStream

        │
        ▼
Configuration Parser

        │
        ▼
Dose Engine Initialization
```

Configuration files, scripting files, and reports are ideal uses for `QTextStream`, while binary medical images such as DICOM pixel data should use binary I/O.

---


## **Chapter 65 — QDataStream (Complete Deep Dive)**

