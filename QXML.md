# Complete Qt Master Course (Qt 5.15 LTS → Qt 6.11)

# PART VIII — File System & Data Storage

# Chapter 67 — XML (Complete Deep Dive)

## Master QXmlStreamReader, QXmlStreamWriter, QDomDocument, DOM vs Streaming & Enterprise XML Processing

> **Level:** Advanced → Expert

---

# Chapter Objectives

After completing this chapter, you will understand:

* What is XML?
* Why XML is still important
* XML Architecture in Qt
* `QXmlStreamReader`
* `QXmlStreamWriter`
* `QDomDocument`
* DOM vs Stream Parsing
* Reading XML
* Writing XML
* XML Namespaces
* XML Validation Concepts
* Performance Optimization
* Enterprise Applications
* Qt Internals
* Qt 5.15 vs Qt 6.11
* Best Practices
* Interview Questions

---

# Table of Contents

1. Introduction
2. What is XML?
3. XML Architecture
4. DOM vs Streaming
5. QDomDocument
6. QXmlStreamReader
7. QXmlStreamWriter
8. Reading XML
9. Writing XML
10. XML Namespaces
11. XML Validation Concepts
12. Performance Optimization
13. Enterprise Applications
14. Qt Internals
15. Qt 5 vs Qt 6
16. Best Practices
17. Common Mistakes
18. Interview Questions
19. Revision Notes

---

# 1. Introduction

Before JSON became the dominant format for web APIs, **XML (eXtensible Markup Language)** was the standard for structured data exchange.

Even today, XML remains widely used in:

* Office document formats
* SVG
* Android manifests
* Build systems
* SOAP Web Services
* Industrial automation
* Medical systems
* CAD
* GIS

If you work in enterprise software, healthcare, automotive, or embedded systems, XML knowledge is still valuable.

---

## Example XML

```xml
<?xml version="1.0"?>

<patient>
    <name>John</name>
    <age>45</age>
</patient>
```

---

# 2. What is XML?

XML stores hierarchical structured data using tags.

Example

```xml
<hospital>
    <patient>
        <name>John</name>
        <age>45</age>
    </patient>
</hospital>
```

Hierarchy

```text
Hospital

└── Patient

      ├── Name

      └── Age
```

Unlike JSON, XML distinguishes between:

* Elements
* Attributes
* Text nodes
* Comments
* Processing instructions

---

# XML Example

```xml
<beam id="1" energy="6MV">
    <name>Beam1</name>
</beam>
```

Here:

* `beam` → Element
* `id`, `energy` → Attributes
* `Beam1` → Text node

---

# 3. XML Architecture

Qt provides two primary approaches.

```text
             XML

              │

     ┌────────┴─────────┐

     ▼                  ▼

DOM Parser      Stream Parser

(QDomDocument)  (QXmlStreamReader)
```

---

Qt Classes

| Class              | Purpose              |
| ------------------ | -------------------- |
| `QDomDocument`     | Load entire XML tree |
| `QXmlStreamReader` | Sequential reading   |
| `QXmlStreamWriter` | Sequential writing   |

---

# 4. DOM vs Streaming

## DOM

```text
XML File

↓

Entire Tree Loaded

↓

Memory

↓

Application
```

Advantages

* Easy navigation
* Random access
* Editable tree

Disadvantages

* High memory usage
* Slower for huge files

---

## Streaming

```text
XML File

↓

Read Token

↓

Process

↓

Next Token
```

Advantages

* Very low memory
* Fast
* Suitable for large files

Disadvantages

* Sequential only
* Cannot randomly access previous nodes

---

Comparison

| Feature       | DOM    | Stream |
| ------------- | ------ | ------ |
| Memory        | High   | Low    |
| Speed         | Medium | High   |
| Random Access | ✔      | ✘      |
| Huge Files    | ✘      | ✔      |

---

# 5. QDomDocument

Header

```cpp
#include <QDomDocument>
```

Load XML

```cpp
QDomDocument document;
```

Example

```text
XML

↓

QDomDocument

↓

Tree
```

Navigation

```text
Document

└── Patient

      ├── Name

      └── Age
```

Applications

* Small configuration files
* XML editors
* Document manipulation

---

# 6. QXmlStreamReader

Header

```cpp
#include <QXmlStreamReader>
```

Example

```cpp
QXmlStreamReader xml(file);
```

Workflow

```text
File

↓

Token

↓

Process

↓

Next Token
```

Possible tokens

* Start Element
* End Element
* Characters
* Attribute
* Comment
* Processing Instruction

---

Typical loop

```cpp
while (!xml.atEnd())
{
    xml.readNext();
}
```

---

Advantages

* Extremely memory efficient
* Fast parsing
* Suitable for enterprise systems

---

# 7. QXmlStreamWriter

Header

```cpp
#include <QXmlStreamWriter>
```

Example

```cpp
QXmlStreamWriter writer(&file);
```

Workflow

```text
Application

↓

Writer

↓

XML File
```

Useful functions

* Start document
* Start element
* Write attribute
* Write text
* End element
* End document

---

# 8. Reading XML

Example XML

```xml
<patient>

    <name>John</name>

    <age>45</age>

</patient>
```

Workflow

```text
Disk

↓

QFile

↓

QXmlStreamReader

↓

Token

↓

Application
```

Reading typically involves checking the current token and reacting when the desired element is encountered.

---

# 9. Writing XML

Workflow

```text
Objects

↓

QXmlStreamWriter

↓

XML

↓

Disk
```

Example structure

```xml
<patient>

    <name>John</name>

</patient>
```

Applications

* Export
* Reports
* Configuration
* CAD
* Medical metadata

---

# 10. XML Namespaces

Namespaces avoid name collisions.

Example

```xml
<h:table>

<f:table>
```

Same tag name

Different namespace

Applications

* SOAP
* Office documents
* SVG
* Complex enterprise XML

Qt stream readers and writers provide namespace-aware APIs.

---

# 11. XML Validation Concepts

Validation ensures that XML follows an expected structure.

Common standards include:

* DTD (Document Type Definition)
* XML Schema (XSD)

Example concept

```text
XML

↓

Validate

↓

Correct Structure

↓

Application
```

Qt's XML stream classes focus on parsing rather than comprehensive XML Schema validation. When schema validation is required, applications often use dedicated XML libraries or platform-specific tools alongside Qt.

---

# 12. Performance Optimization

## Prefer Streaming

For

```text
5 GB XML
```

Use

```text
QXmlStreamReader
```

instead of

```text
QDomDocument
```

---

## Process Immediately

Instead of

```text
Read

↓

Store

↓

Process
```

Prefer

```text
Read

↓

Process

↓

Discard
```

---

## Avoid Entire Tree

For large documents.

---

# 13. Enterprise Applications

---

## Medical TPS

```text
Treatment Plan XML

↓

QXmlStreamReader

↓

Parser

↓

Dose Engine
```

---

## CAD

```text
SVG

↓

XML Reader

↓

Graphics
```

---

## Industrial Automation

```text
PLC Configuration

↓

XML

↓

Machine
```

---

## GIS

```text
Map XML

↓

Parser

↓

Renderer
```

---

# 14. Qt Internals

DOM

```text
XML

↓

Parser

↓

Memory Tree

↓

Application
```

Streaming

```text
XML

↓

Reader

↓

Token

↓

Application
```

Unlike DOM, the streaming parser never loads the entire document into memory.

---

# 15. Qt 5 vs Qt 6

| Feature          | Qt 5.15 | Qt 6.11 |
| ---------------- | ------- | ------- |
| QXmlStreamReader | ✔       | ✔       |
| QXmlStreamWriter | ✔       | ✔       |
| QDomDocument     | ✔       | ✔*      |
| DOM Support      | ✔       | ✔       |

> **Note:** `QDomDocument` is still available in Qt 6, but it belongs to the **Qt XML** module (`Qt6::Xml`) rather than the Qt Core module.

The XML APIs are largely unchanged between Qt 5 and Qt 6.

---

# 16. Best Practices

✅ Use `QXmlStreamReader` for large XML files.

✅ Use `QDomDocument` only when random tree access is required.

✅ Validate input before trusting external XML.

✅ Handle parser errors gracefully.

✅ Keep parsing logic separate from business logic.

---

# 17. Common Mistakes

### ❌ Loading huge XML files into DOM

This wastes memory.

---

### ❌ Ignoring parser errors

Always check:

```cpp
xml.hasError()
```

and inspect:

```cpp
xml.errorString()
```

---

### ❌ Mixing business logic with parsing

Separate XML parsing into dedicated parser classes.

---

### ❌ Assuming every element exists

Check for missing or optional elements.

---

# 18. Interview Questions

## Easy

1. What is XML?
2. What is the difference between XML and JSON?
3. What is `QXmlStreamReader`?

---

## Medium

1. Compare `QDomDocument` and `QXmlStreamReader`.
2. What are XML namespaces?
3. Why is streaming more memory efficient?

---

## Hard

1. Explain the internal workflow of a streaming XML parser.
2. Design an XML parser for a 10 GB file.
3. Compare DOM and SAX-style/stream parsing.

---

## Expert

1. Design an XML import subsystem for a Medical Treatment Planning System that reads machine configurations, treatment plans, and patient metadata efficiently.
2. Explain how you would migrate an application from XML-based configuration files to JSON while preserving backward compatibility.
3. Compare XML, JSON, YAML, and binary serialization in terms of readability, extensibility, validation, and performance.

---

# 19. Revision Notes

* XML is a hierarchical markup language.
* `QDomDocument` loads the entire XML tree.
* `QXmlStreamReader` processes XML sequentially.
* `QXmlStreamWriter` generates XML incrementally.
* Streaming parsers are better for large files.
* DOM is convenient for random access and editing.
* XML namespaces prevent element name collisions.
* Always check parser errors.
* Separate parsing logic from application logic.

---

# 💡 Senior Engineer Tips

## When should you use XML?

| Scenario            | XML?                       |
| ------------------- | -------------------------- |
| REST API            | Usually ✘ (JSON preferred) |
| SVG Graphics        | ✔                          |
| Office Documents    | ✔                          |
| SOAP Services       | ✔                          |
| Medical Metadata    | ✔                          |
| Configuration Files | Sometimes                  |
| Huge Data Exchange  | Stream Parser ✔            |

---

## XML vs JSON in Enterprise Software

| Requirement               | JSON      | XML             |
| ------------------------- | --------- | --------------- |
| Human readability         | ✔         | ✔               |
| Compact size              | ✔         | ✘               |
| Schema validation         | Limited   | Excellent (XSD) |
| Rich metadata             | Limited   | ✔               |
| REST APIs                 | ✔         | Rare            |
| Legacy enterprise systems | Sometimes | ✔               |

---

## Medical TPS Example

```text
MachineConfiguration.xml

          │
          ▼
     QFile

          │
          ▼
QXmlStreamReader

          │
          ▼
MachineConfigParser

          │
          ▼
Treatment Planning Engine
```

Many legacy medical systems still exchange machine configurations and metadata using XML, making streaming parsers valuable for handling large or complex documents efficiently.

---

## **Chapter 68 — Serialization (Complete Deep Dive)**

