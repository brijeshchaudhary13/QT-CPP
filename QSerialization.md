# Complete Qt Master Course (Qt 5.15 LTS → Qt 6.11)

# PART VIII — File System & Data Storage

# Chapter 68 — Serialization (Complete Deep Dive)

## Master Object Serialization, Persistence, Versioning, Compatibility & Enterprise Data Storage

> **Level:** Advanced → Architect

---

# Chapter Objectives

After completing this chapter, you will understand:

* What is Serialization?
* Why Serialization is Important
* Serialization vs Persistence
* Binary vs Text Serialization
* Serialization Formats
* Object Graph Serialization
* Versioning Strategies
* Backward & Forward Compatibility
* Custom Serialization
* Enterprise Serialization Architecture
* Medical TPS Serialization
* Performance Optimization
* Qt Internals
* Qt 5.15 vs Qt 6.11
* Best Practices
* Interview Questions

---

# Table of Contents

1. Introduction
2. What is Serialization?
3. Serialization vs Persistence
4. Serialization Formats
5. Binary vs Text Serialization
6. Object Graph Serialization
7. Serialization Workflow
8. Versioning Strategies
9. Backward & Forward Compatibility
10. Custom Serialization
11. Enterprise Serialization Architecture
12. Medical TPS Example
13. Performance Optimization
14. Qt Internals
15. Qt 5 vs Qt 6
16. Best Practices
17. Common Mistakes
18. Interview Questions
19. Revision Notes

---

# 1. Introduction

Imagine you have created a complete **Treatment Plan** in a Medical TPS.

It contains:

* Patient Information
* CT Images
* Structures
* Beams
* Dose Constraints
* Optimization Parameters
* DVH Settings

All of this exists only in RAM while the application is running.

If the application closes, everything is lost unless it is **serialized**.

Serialization converts in-memory objects into a format that can be:

* Saved to disk
* Sent over a network
* Stored in a database
* Cached
* Restored later

---

# 2. What is Serialization?

Serialization is the process of converting an object's state into a storable or transferable representation.

```text
Memory Object

↓

Serialization

↓

Bytes / Text

↓

Disk / Network

↓

Deserialization

↓

Memory Object
```

---

## Example

Memory

```text
Patient

Name = John

Age = 45
```

Serialized

```text
Binary

or

JSON

or

XML
```

Deserialized

```text
Patient

Name = John

Age = 45
```

The goal is to reconstruct the object accurately.

---

# 3. Serialization vs Persistence

These terms are related but different.

## Serialization

Converts an object into another representation.

```text
Object

↓

Binary
```

---

## Persistence

Ensures data survives after the application exits.

```text
Object

↓

Serialization

↓

Database

↓

Disk

↓

Later Restore
```

Serialization is often one step in implementing persistence.

---

# 4. Serialization Formats

Common formats:

| Format                 | Human Readable | Compact   | Typical Use                    |
| ---------------------- | -------------- | --------- | ------------------------------ |
| Binary (`QDataStream`) | ✘              | ✔         | Application state              |
| JSON                   | ✔              | Moderate  | APIs, configuration            |
| XML                    | ✔              | Large     | Enterprise, legacy             |
| CSV                    | ✔              | Simple    | Tables                         |
| SQLite                 | Partial        | Efficient | Persistent storage             |
| Protocol Buffers       | ✘              | ✔✔        | High-performance communication |
| FlatBuffers            | ✘              | ✔✔        | Zero-copy access               |

---

# 5. Binary vs Text Serialization

## Binary

```text
Object

↓

Binary Stream

↓

Disk
```

Advantages

* Small size
* Fast
* Exact numeric representation

Disadvantages

* Not human-readable
* Requires compatible reader

---

## Text

```text
Object

↓

JSON

↓

Disk
```

Advantages

* Easy debugging
* Editable
* Portable

Disadvantages

* Larger
* Slower parsing
* Numeric formatting considerations

---

Comparison

| Feature     | Binary    | JSON/XML |
| ----------- | --------- | -------- |
| Speed       | Excellent | Good     |
| Readability | No        | Yes      |
| Size        | Small     | Larger   |
| Debugging   | Hard      | Easy     |
| APIs        | Rare      | Common   |

---

# 6. Object Graph Serialization

Real applications rarely consist of one object.

Example

```text
TreatmentPlan

├── Patient

├── Machine

├── Beam 1

├── Beam 2

├── Beam 3

└── Dose Matrix
```

This is an **object graph**.

Serialization must preserve relationships.

---

## Object References

Example

```text
Beam

↓

Machine
```

After deserialization:

```text
Beam

↓

Same Machine
```

Maintaining relationships is an important design consideration in large systems.

---

# 7. Serialization Workflow

General workflow

```text
Objects

↓

Serializer

↓

Binary / JSON / XML

↓

Disk

↓

Deserializer

↓

Objects
```

Qt example

```text
Patient Object

↓

QDataStream

↓

patient.dat

↓

QDataStream

↓

Patient Object
```

---

# 8. Versioning Strategies

Applications evolve.

Version 1

```text
Patient

Name

Age
```

Version 2

```text
Patient

Name

Age

Phone
```

Old files still need to be read.

---

## Store Version Number

Example

```text
File

Version = 2
```

Read

```text
if version == 1

↓

Old Logic

else

↓

New Logic
```

---

## Qt Example

`QDataStream`

```cpp
out.setVersion(
    QDataStream::Qt_6_5);
```

Application-specific versioning is often added on top of stream versioning.

---

# 9. Backward & Forward Compatibility

## Backward Compatibility

New software reads old files.

```text
Version 1 File

↓

Version 3 Application

↓

Works
```

---

## Forward Compatibility

Old software reads new files.

```text
Version 3 File

↓

Version 1 Application

↓

Usually Limited
```

Forward compatibility is harder and often only partially supported.

---

## Best Strategy

Add new optional fields instead of changing the meaning of existing ones whenever possible.

---

# 10. Custom Serialization

Example class

```cpp
class Beam
{
public:
    QString name;
    double energy;
};
```

Binary serialization

```text
Beam

↓

operator<<

↓

QDataStream
```

JSON serialization

```text
Beam

↓

QJsonObject

↓

JSON
```

XML serialization

```text
Beam

↓

XML Writer

↓

XML
```

Separate serialization code from business logic whenever possible.

---

# 11. Enterprise Serialization Architecture

A layered design

```text
UI

↓

Business Objects

↓

Serialization Layer

↓

Storage Layer

↓

Disk / Database
```

Responsibilities

| Layer            | Responsibility   |
| ---------------- | ---------------- |
| UI               | User interaction |
| Business Objects | Domain logic     |
| Serializer       | Convert objects  |
| Storage          | Read/write       |
| Database         | Persistence      |

---

# Repository Pattern

```text
PatientRepository

↓

Serializer

↓

QFile

↓

Disk
```

The repository manages persistence while serializers focus on data conversion.

---

# 12. Medical TPS Example

Treatment plan

```text
TreatmentPlan

├── Patient

├── Structures

├── Beams

├── Dose Constraints

├── Prescription

├── Optimization

└── Results
```

Storage

```text
TreatmentPlan

↓

Serializer

↓

TPS File

↓

Disk
```

Dose matrices are usually stored separately from metadata because they are much larger.

Architecture

```text
Metadata

↓

JSON

Beam Parameters

↓

Binary

Dose Matrix

↓

Binary
```

This hybrid approach combines readability with performance.

---

# 13. Performance Optimization

## Serialize Only Required Data

Bad

```text
Entire Cache

↓

Disk
```

Better

```text
Active Project

↓

Disk
```

---

## Incremental Save

Instead of

```text
Entire Project

↓

Rewrite
```

consider

```text
Modified Data

↓

Update
```

when the file format supports it.

---

## Compression

Large serialized data may be compressed.

Example

```text
Serialize

↓

Compress

↓

Disk
```

Compression reduces storage at the cost of CPU time.

---

# 14. Qt Internals

Serialization pipeline

```text
QObject

↓

Serializer

↓

QIODevice

↓

Disk
```

Deserialization

```text
Disk

↓

QIODevice

↓

Deserializer

↓

Objects
```

Qt itself does not automatically serialize arbitrary C++ objects. Instead, applications define how their classes are converted to and from storage formats.

---

# 15. Qt 5 vs Qt 6

| Feature                | Qt 5.15 | Qt 6.11 |
| ---------------------- | ------- | ------- |
| QDataStream            | ✔       | ✔       |
| JSON                   | ✔       | ✔       |
| XML                    | ✔       | ✔       |
| Serialization Concepts | ✔       | ✔       |

The underlying serialization concepts are independent of the Qt version.

---

# 16. Best Practices

✅ Store explicit file format versions.

✅ Separate serialization from business logic.

✅ Keep file formats backward compatible whenever practical.

✅ Validate data while deserializing.

✅ Serialize only the data needed to reconstruct object state.

---

# 17. Common Mistakes

### ❌ Mixing UI code with serialization

Keep serialization in dedicated classes or repositories.

---

### ❌ Ignoring versioning

Future releases may be unable to read older files.

---

### ❌ Serializing raw pointers

Pointers are memory addresses and are not meaningful after restarting the application.

Serialize identifiers or referenced objects instead.

---

### ❌ Trusting external files blindly

Always validate imported data.

---

# 18. Interview Questions

## Easy

1. What is serialization?
2. What is the difference between serialization and persistence?
3. Why is versioning important?

---

## Medium

1. Compare binary and JSON serialization.
2. What is an object graph?
3. Why should serialization logic be separated from business logic?

---

## Hard

1. Design a backward-compatible file format.
2. Explain how to serialize object relationships.
3. Compare serialization to ORM/database persistence.

---

## Expert

1. Design a serialization architecture for a Medical Treatment Planning System supporting treatment plans, beam configurations, optimization results, and dose matrices while remaining backward compatible for ten years.
2. Explain how you would serialize a CAD project containing shared objects, references, and reusable blocks.
3. Compare `QDataStream`, JSON, XML, SQLite, Protocol Buffers, and FlatBuffers for enterprise desktop software.

---

# 19. Revision Notes

* Serialization converts objects into transferable or storable formats.
* Persistence ensures data survives application restarts.
* Binary serialization is compact and fast.
* JSON and XML are human-readable.
* Versioning is essential for long-term compatibility.
* Object graphs require careful handling of relationships.
* Separate serialization from storage and business logic.
* Repositories often coordinate persistence in enterprise applications.
* Never serialize raw pointers directly.

---

# 💡 Senior Engineer Tips

## Choosing a Serialization Format

| Requirement                   | Recommended Format             |
| ----------------------------- | ------------------------------ |
| Application settings          | JSON                           |
| REST communication            | JSON                           |
| Legacy enterprise integration | XML                            |
| Fast application state        | `QDataStream`                  |
| Database storage              | SQLite                         |
| High-performance IPC          | Protocol Buffers / FlatBuffers |

---

## Enterprise Medical TPS Architecture

```text
TreatmentPlan
      │
      ├──────────────┐
      ▼              ▼
Metadata        Dose Matrix
(JSON)           (Binary)

      │              │
      └──────┬───────┘
             ▼
      Project Repository
             │
             ▼
        TreatmentPlan.tps
```

A common production approach is:

* **JSON** for human-readable metadata (patient information, beam settings, optimization parameters)
* **Binary** for large numerical datasets (dose matrices, voxel grids, image volumes)

This balances readability, compatibility, and performance.

---


## **Chapter 69 — Qt SQL (Complete Deep Dive)**

