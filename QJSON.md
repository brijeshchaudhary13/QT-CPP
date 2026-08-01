# Complete Qt Master Course (Qt 5.15 LTS → Qt 6.11)

# PART VIII — File System & Data Storage

# Chapter 66 — JSON (Complete Deep Dive)

## Master QJsonDocument, QJsonObject, QJsonArray, REST Data & Configuration Files

> **Level:** Intermediate → Advanced

---

# Chapter Objectives

After completing this chapter, you will understand:

* What is JSON?
* Why JSON is widely used
* Qt JSON Architecture
* `QJsonDocument`
* `QJsonObject`
* `QJsonArray`
* `QJsonValue`
* Parsing JSON
* Creating JSON
* Reading and Writing JSON Files
* JSON and REST APIs
* JSON Performance
* Enterprise Applications
* Qt Internals
* Qt 5.15 vs Qt 6.11
* Best Practices
* Interview Questions

---

# Table of Contents

1. Introduction
2. What is JSON?
3. JSON Architecture in Qt
4. QJsonDocument
5. QJsonObject
6. QJsonArray
7. QJsonValue
8. Reading JSON
9. Writing JSON
10. Working with Nested JSON
11. JSON Files
12. JSON and REST APIs
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

Modern applications exchange data continuously.

Examples:

* REST APIs
* Configuration files
* Cloud services
* AI models
* Mobile applications
* Web applications

The most common data format today is **JSON (JavaScript Object Notation)**.

Qt provides a complete JSON framework that is easy to use and fully integrated with Qt types.

---

## Real Examples

Configuration

```json
{
    "language": "English",
    "theme": "Dark",
    "fontSize": 14
}
```

REST Response

```json
{
    "patientId": 101,
    "name": "John",
    "age": 45
}
```

---

# 2. What is JSON?

JSON is a lightweight text format used to represent structured data.

It consists of:

* Objects
* Arrays
* Values

---

## Object

```json
{
    "name": "John",
    "age": 25
}
```

Objects contain **key-value pairs**.

---

## Array

```json
[
    "Beam1",
    "Beam2",
    "Beam3"
]
```

Arrays contain ordered values.

---

## Nested Object

```json
{
    "patient": {
        "name": "John",
        "age": 25
    }
}
```

---

# JSON vs XML

| JSON            | XML                      |
| --------------- | ------------------------ |
| Lightweight     | Verbose                  |
| Easier to parse | More complex             |
| Compact         | Larger                   |
| Common for REST | Common in legacy systems |

---

# 3. JSON Architecture in Qt

Qt JSON classes

```text
QJsonDocument
      │
      ├──────────────┐
      ▼              ▼
QJsonObject     QJsonArray
      │              │
      └──────┬───────┘
             ▼
        QJsonValue
```

---

## Responsibilities

| Class         | Purpose              |
| ------------- | -------------------- |
| QJsonDocument | Entire JSON document |
| QJsonObject   | JSON object          |
| QJsonArray    | JSON array           |
| QJsonValue    | Single value         |

---

# 4. QJsonDocument

Header

```cpp
#include <QJsonDocument>
```

`QJsonDocument` represents the entire JSON document.

Example

```cpp
QJsonDocument document;
```

It acts as the entry point for parsing and generating JSON.

---

## Architecture

```text
JSON File

↓

QJsonDocument

↓

Object / Array
```

---

# 5. QJsonObject

Represents key-value pairs.

Example

```cpp
QJsonObject patient;

patient["name"] = "John";
patient["age"] = 25;
```

Result

```json
{
    "name": "John",
    "age": 25
}
```

---

## Reading Values

```cpp
QString name =
    patient["name"].toString();
```

Integer

```cpp
int age =
    patient["age"].toInt();
```

---

# 6. QJsonArray

Stores multiple values.

Example

```cpp
QJsonArray beams;

beams.append("Beam1");
beams.append("Beam2");
beams.append("Beam3");
```

Result

```json
[
    "Beam1",
    "Beam2",
    "Beam3"
]
```

---

## Reading

```cpp
QString beam =
    beams[0].toString();
```

---

## Loop

```cpp
for(const auto &value : beams)
{
    qDebug() << value;
}
```

---

# 7. QJsonValue

Every JSON value is represented by `QJsonValue`.

Possible types

| JSON    | Qt          |
| ------- | ----------- |
| String  | QString     |
| Number  | double/int  |
| Boolean | bool        |
| Object  | QJsonObject |
| Array   | QJsonArray  |
| Null    | Null        |

---

Example

```cpp
QJsonValue value =
    patient["age"];
```

Convert

```cpp
value.toInt();
```

or

```cpp
value.toString();
```

---

# 8. Reading JSON

Suppose we have

```json
{
    "name":"John",
    "age":25
}
```

---

Read file

```cpp
QFile file("patient.json");
```

Read bytes

```cpp
QByteArray data =
    file.readAll();
```

Parse

```cpp
QJsonDocument document =
    QJsonDocument::fromJson(data);
```

Get object

```cpp
QJsonObject object =
    document.object();
```

Read value

```cpp
QString name =
    object["name"].toString();
```

---

Workflow

```text
Disk

↓

QFile

↓

QByteArray

↓

QJsonDocument

↓

QJsonObject
```

---

# 9. Writing JSON

Create object

```cpp
QJsonObject patient;

patient["name"] = "John";

patient["age"] = 25;
```

Create document

```cpp
QJsonDocument document(patient);
```

Convert to JSON

```cpp
QByteArray data =
    document.toJson();
```

Write to file

```cpp
file.write(data);
```

---

Pipeline

```text
QJsonObject

↓

QJsonDocument

↓

QByteArray

↓

Disk
```

---

# 10. Working with Nested JSON

Medical example

```json
{
    "patient":
    {
        "name":"John",
        "age":45
    },
    "beams":
    [
        "Beam1",
        "Beam2"
    ]
}
```

Read nested object

```cpp
QJsonObject patient =
    object["patient"].toObject();
```

Read array

```cpp
QJsonArray beams =
    object["beams"].toArray();
```

Architecture

```text
Document

├── Patient Object

└── Beam Array
```

---

# 11. JSON Files

Common uses

* Configuration
* User settings
* Project files
* API cache

Example

```json
{
    "theme":"Dark",
    "language":"English",
    "autosave":true
}
```

Advantages

* Human-readable
* Easy to edit
* Cross-platform
* Widely supported

---

# 12. JSON and REST APIs

Typical REST response

```json
{
    "status":"Success",
    "patient":
    {
        "name":"John"
    }
}
```

Workflow

```text
HTTP Response

↓

QNetworkReply

↓

QByteArray

↓

QJsonDocument

↓

Application
```

This is one of the most common Qt workflows when consuming REST APIs.

---

# 13. Performance Optimization

## Avoid Repeated Parsing

Bad

```text
Read

↓

Parse

↓

Read

↓

Parse
```

Good

```text
Read Once

↓

Parse Once

↓

Reuse Object
```

---

## Large JSON Files

Instead of repeatedly accessing deeply nested values:

```text
Document

↓

Object

↓

Array

↓

Object

↓

Value
```

store intermediate objects in local variables when appropriate.

---

## Compact Output

```cpp
document.toJson(
    QJsonDocument::Compact);
```

Produces

```json
{"name":"John","age":25}
```

Useful for:

* Network traffic
* Storage

---

Indented output

```cpp
document.toJson(
    QJsonDocument::Indented);
```

Better for debugging and configuration files.

---

# 14. Enterprise Applications

## Medical TPS

```text
Configuration

↓

JSON

↓

Dose Engine

↓

Beam Settings
```

---

## CAD

```text
Drawing Metadata

↓

JSON

↓

Project Loader
```

---

## ERP

```text
REST API

↓

JSON

↓

Database
```

---

## AI

```text
Prompt

↓

JSON

↓

AI Service
```

---

# 15. Qt Internals

Reading

```text
JSON Text

↓

QByteArray

↓

Parser

↓

QJsonDocument

↓

Object / Array
```

Writing

```text
Objects

↓

QJsonDocument

↓

Serializer

↓

JSON Text
```

Qt stores JSON data internally in an efficient binary representation after parsing, allowing relatively fast access compared to reparsing text repeatedly.

---

# 16. Qt 5 vs Qt 6

| Feature       | Qt 5.15 | Qt 6.11 |
| ------------- | ------- | ------- |
| QJsonDocument | ✔       | ✔       |
| QJsonObject   | ✔       | ✔       |
| QJsonArray    | ✔       | ✔       |
| QJsonValue    | ✔       | ✔       |
| REST Parsing  | ✔       | ✔       |

The JSON API is stable across Qt 5 and Qt 6.

---

# 17. Best Practices

✅ Parse JSON only once.

✅ Validate expected keys before using values.

✅ Use `Compact` output for network transmission.

✅ Use `Indented` output for configuration files.

✅ Separate JSON parsing from business logic.

---

# 18. Common Mistakes

### ❌ Assuming every key exists

Missing keys return default values. Check for required fields when appropriate.

---

### ❌ Parsing the same JSON repeatedly

Cache parsed objects when possible.

---

### ❌ Storing huge binary data inside JSON

Use binary files and store references in JSON instead.

---

### ❌ Ignoring parse errors

Always verify that parsing succeeded before using the document.

Example:

```cpp
QJsonParseError error;

QJsonDocument document =
    QJsonDocument::fromJson(data, &error);

if (error.error != QJsonParseError::NoError)
{
    qDebug() << error.errorString();
}
```

---

# 19. Interview Questions

## Easy

1. What is JSON?
2. What is `QJsonDocument`?
3. What is the difference between `QJsonObject` and `QJsonArray`?

---

## Medium

1. Explain the JSON parsing workflow in Qt.
2. When should you use `Compact` vs `Indented` output?
3. How do you read nested JSON objects?

---

## Hard

1. Explain the relationship between `QJsonDocument`, `QJsonObject`, and `QJsonValue`.
2. How would you process a large REST API response efficiently?
3. Compare JSON and XML for desktop applications.

---

## Expert

1. Design the JSON configuration format for a Medical Treatment Planning System that stores machine configuration, beam parameters, optimization settings, and UI preferences.
2. Explain how you would implement versioned JSON configuration files while maintaining backward compatibility.
3. Compare JSON, XML, Protocol Buffers, and binary serialization (`QDataStream`) for configuration, communication, and persistent storage.

---

# 20. Revision Notes

* JSON is a lightweight text-based data format.
* `QJsonDocument` represents the entire JSON document.
* `QJsonObject` stores key-value pairs.
* `QJsonArray` stores ordered collections.
* `QJsonValue` represents individual values.
* JSON parsing starts with `QJsonDocument::fromJson()`.
* `toJson()` serializes the document back into text.
* `Compact` output is suitable for networks.
* `Indented` output is easier for humans to read.
* Always handle parse errors and validate input.

---

# 💡 Senior Engineer Tips

## When should you use JSON?

| Scenario            | Use JSON?                                    |
| ------------------- | -------------------------------------------- |
| Configuration files | ✔                                            |
| REST APIs           | ✔                                            |
| Cloud communication | ✔                                            |
| User preferences    | ✔                                            |
| Large binary images | ✘                                            |
| Medical dose matrix | ✘ (`QDataStream` or dedicated binary format) |

### Medical TPS Example

```text
MachineConfig.json

        │
        ▼
      QFile

        │
        ▼
 QJsonDocument

        │
        ▼
Configuration Parser

        │
        ▼
Dose Engine
```

A common enterprise pattern is to store **configuration and metadata in JSON**, while keeping **large numerical datasets** (such as dose matrices or medical images) in binary formats.

---


## **Chapter 67 — XML (Complete Deep Dive)**

