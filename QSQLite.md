# Complete Qt Master Course (Qt 5.15 LTS → Qt 6.11)

# PART IX — Database Programming

# Chapter 70 — SQLite (Complete Deep Dive)

## Master SQLite Database Design, Transactions, Indexing, WAL Mode & Enterprise Qt Integration

> **Level:** Advanced → Expert

---

# Chapter Objectives

After completing this chapter, you will understand:

* What is SQLite?
* SQLite Architecture
* Why SQLite is used in Desktop Applications
* Creating Databases
* Tables
* Data Types
* Primary Keys
* Foreign Keys
* Constraints
* Indexes
* CRUD Operations
* Transactions
* WAL Mode
* Query Optimization
* Backup & Restore
* Enterprise Architecture
* Medical TPS Database Design
* Qt Internals
* Qt 5.15 vs Qt 6.11
* Best Practices
* Interview Questions

---

# Table of Contents

1. Introduction
2. SQLite Architecture
3. Why SQLite?
4. Creating a Database
5. SQLite Data Types
6. Tables
7. Primary Keys
8. Foreign Keys
9. Constraints
10. Indexes
11. CRUD Operations
12. Transactions
13. WAL Mode
14. Query Optimization
15. Backup & Restore
16. Enterprise Applications
17. Qt Internals
18. Qt 5 vs Qt 6
19. Best Practices
20. Common Mistakes
21. Interview Questions
22. Revision Notes

---

# 1. Introduction

SQLite is one of the most widely used databases in the world.

It powers applications such as:

* Desktop software
* Mobile apps
* Embedded devices
* Browsers
* Medical devices
* IoT systems

Unlike MySQL or PostgreSQL, SQLite is **not a database server**.

It is a **library** that stores the database inside a single file.

---

## SQLite Database

```text id="sqlite01"
Application

↓

SQLite Library

↓

hospital.db
```

There is **no separate database server** to install or manage.

---

# 2. SQLite Architecture

```text id="sqlite02"
Qt Application

↓

Qt SQL

↓

SQLite Driver

↓

SQLite Engine

↓

Database File
```

Everything runs in the application's process.

---

## Advantages

* Zero configuration
* Lightweight
* Portable
* Fast
* Easy deployment

---

# 3. Why SQLite?

Desktop software usually runs on a single computer.

Examples:

* CAD
* Medical TPS
* IDE
* Accounting
* POS
* Note-taking apps

SQLite is ideal because:

* No server
* One database file
* Easy backup
* Cross-platform

---

## SQLite vs Client-Server Database

| SQLite              | PostgreSQL/MySQL            |
| ------------------- | --------------------------- |
| Embedded            | Server                      |
| Single file         | Multiple files              |
| Zero configuration  | Server installation         |
| Easy deployment     | Network setup               |
| Best for local apps | Best for multi-user systems |

---

# 4. Creating a Database

Qt Example

```cpp id="sqlite03"
QSqlDatabase db =
    QSqlDatabase::addDatabase(
        "QSQLITE");
```

Database file

```cpp id="sqlite04"
db.setDatabaseName(
    "hospital.db");
```

Open

```cpp id="sqlite05"
db.open();
```

If the file does not exist, SQLite creates it automatically.

---

# 5. SQLite Data Types

SQLite uses a flexible type system based on **type affinity** rather than enforcing strict column types in the way many server databases do.

Common affinities:

| SQLite Type | Typical Usage          |
| ----------- | ---------------------- |
| INTEGER     | Whole numbers          |
| REAL        | Floating-point numbers |
| TEXT        | Strings                |
| BLOB        | Binary data            |
| NULL        | No value               |

---

Example

```sql id="sqlite06"
CREATE TABLE Patient
(
    Name TEXT,

    Age INTEGER
);
```

---

# 6. Tables

Example

```sql id="sqlite07"
CREATE TABLE Patient
(
    ID INTEGER PRIMARY KEY,

    Name TEXT,

    Age INTEGER
);
```

Structure

```text id="sqlite08"
Patient

ID

Name

Age
```

Each table represents one entity.

---

# 7. Primary Keys

Every table should have a primary key.

```sql id="sqlite09"
ID INTEGER PRIMARY KEY
```

Advantages

* Unique
* Fast lookup
* Relationships

---

Auto Increment

SQLite automatically generates row IDs for an `INTEGER PRIMARY KEY`. Use the `AUTOINCREMENT` keyword only if you specifically require its stricter behavior, as it has additional overhead.

```sql id="sqlite10"
ID INTEGER PRIMARY KEY AUTOINCREMENT
```

---

# 8. Foreign Keys

Relationships

```text id="sqlite11"
Patient

↓

TreatmentPlan
```

Example

```sql id="sqlite12"
PatientID

REFERENCES Patient(ID)
```

---

Important

SQLite requires foreign key enforcement to be enabled.

```sql id="sqlite13"
PRAGMA foreign_keys = ON;
```

This should typically be executed after opening the database connection.

---

# 9. Constraints

Examples

```sql id="sqlite14"
NOT NULL

UNIQUE

CHECK

DEFAULT
```

Example

```sql id="sqlite15"
Age INTEGER

CHECK(Age > 0)
```

Benefits

* Prevent invalid data
* Improve integrity

---

# 10. Indexes

Without index

```text id="sqlite16"
Search

↓

1 Million Rows

↓

Slow
```

With index

```text id="sqlite17"
Search

↓

Index

↓

Direct Row
```

---

Example

```sql id="sqlite18"
CREATE INDEX idx_name

ON Patient(Name);
```

---

When to Create Indexes

Good candidates:

* Search columns
* Join columns
* Foreign keys
* Frequently sorted columns

---

Avoid indexing every column, as indexes consume disk space and slow down inserts and updates.

---

# 11. CRUD Operations

Insert

```sql id="sqlite19"
INSERT INTO Patient
VALUES(...)
```

---

Read

```sql id="sqlite20"
SELECT *

FROM Patient
```

---

Update

```sql id="sqlite21"
UPDATE Patient

SET Age=30
```

---

Delete

```sql id="sqlite22"
DELETE FROM Patient
```

These operations are identical to standard SQL.

---

# 12. Transactions

Bad

```text id="sqlite23"
Insert

↓

Crash

↓

Half Saved
```

Good

```text id="sqlite24"
BEGIN

↓

Insert

↓

Update

↓

COMMIT
```

or

```text id="sqlite25"
ROLLBACK
```

---

Qt

```cpp id="sqlite26"
db.transaction();

db.commit();

db.rollback();
```

Transactions improve both consistency and performance for multiple operations.

---

# 13. WAL Mode

SQLite supports two journaling modes.

Default

```text id="sqlite27"
Database

↓

Journal

↓

Write
```

---

WAL (Write-Ahead Logging)

```text id="sqlite28"
Database

↓

WAL File

↓

Later Merge
```

Enable

```sql id="sqlite29"
PRAGMA journal_mode=WAL;
```

Advantages

* Better read concurrency
* Improved write performance in many workloads
* Reduced database locking

---

# 14. Query Optimization

## Bad

```sql id="sqlite30"
SELECT *

FROM Patient
```

when only one column is required.

---

Better

```sql id="sqlite31"
SELECT Name

FROM Patient
```

---

Use Indexes

```text id="sqlite32"
Query

↓

Index

↓

Fast
```

---

Analyze Query Plan

SQLite provides

```sql id="sqlite33"
EXPLAIN QUERY PLAN
```

This helps identify table scans and index usage.

---

# 15. Backup & Restore

Simplest backup

```text id="sqlite34"
hospital.db

↓

Copy File
```

This approach is appropriate only when the database is not actively being modified.

For live databases, SQLite provides an online backup API, and applications should ensure consistency before copying the file.

---

Restore

```text id="sqlite35"
Copy Back

↓

Application
```

---

Enterprise Backup

```text id="sqlite36"
Database

↓

Backup

↓

Cloud

↓

Archive
```

---

# 16. Enterprise Applications

---

## Medical TPS

```text id="sqlite37"
Patient

↓

Plan

↓

Beam

↓

Prescription

↓

Audit
```

---

## CAD

```text id="sqlite38"
Projects

↓

Layers

↓

Objects
```

---

## ERP

```text id="sqlite39"
Customer

↓

Orders

↓

Invoices
```

---

## POS

```text id="sqlite40"
Products

↓

Sales

↓

Inventory
```

---

# 17. Qt Internals

Workflow

```text id="sqlite41"
QSqlQuery

↓

SQLite Driver

↓

SQLite Engine

↓

Database File
```

Execution

```text id="sqlite42"
SQL

↓

SQLite Parser

↓

Query Planner

↓

Storage Engine
```

SQLite optimizes queries internally using its query planner and available indexes.

---

# 18. Qt 5 vs Qt 6

| Feature       | Qt 5.15 | Qt 6.11 |
| ------------- | ------- | ------- |
| SQLite Driver | ✔       | ✔       |
| WAL Mode      | ✔       | ✔       |
| Transactions  | ✔       | ✔       |
| Foreign Keys  | ✔       | ✔       |
| Indexes       | ✔       | ✔       |

SQLite support remains consistent across Qt versions.

---

# 19. Best Practices

✅ Enable foreign key enforcement.

✅ Use prepared statements.

✅ Create indexes only where beneficial.

✅ Use transactions for grouped operations.

✅ Consider WAL mode for desktop applications with concurrent reads.

✅ Normalize your schema before optimizing.

---

# 20. Common Mistakes

### ❌ Forgetting `PRAGMA foreign_keys = ON`

Foreign key constraints are not enforced unless enabled.

---

### ❌ Using `SELECT *` everywhere

Retrieve only the columns you need.

---

### ❌ Creating unnecessary indexes

Indexes improve reads but slow writes.

---

### ❌ Using `AUTOINCREMENT` without understanding its cost

`INTEGER PRIMARY KEY` is sufficient for most applications.

---

### ❌ Storing huge binary files directly in the database

Large files such as CT volumes or dose matrices are often better stored as files, with the database storing paths or identifiers.

---

# 21. Interview Questions

## Easy

1. What is SQLite?
2. Why is SQLite popular for desktop applications?
3. What is a primary key?

---

## Medium

1. Explain foreign keys.
2. What is WAL mode?
3. Why are indexes important?

---

## Hard

1. Explain SQLite's architecture.
2. How would you optimize a slow SQLite query?
3. Compare SQLite and PostgreSQL.

---

## Expert

1. Design a normalized SQLite schema for a Medical Treatment Planning System that stores patients, image studies, RT Plans, prescriptions, treatment sessions, and audit logs.
2. Explain how you would use WAL mode and transactions to improve performance while maintaining consistency.
3. Compare SQLite, MySQL, PostgreSQL, and SQL Server for desktop engineering applications in terms of deployment, concurrency, maintenance, and scalability.

---

# 22. Revision Notes

* SQLite is an embedded database engine.
* Databases are stored in a single file.
* `QSQLITE` is the Qt driver for SQLite.
* SQLite uses a flexible type system.
* Primary keys uniquely identify rows.
* Foreign keys maintain relationships.
* Constraints improve data integrity.
* Indexes speed up searches.
* Transactions provide atomic updates.
* WAL mode improves many desktop workloads.
* `EXPLAIN QUERY PLAN` helps optimize queries.

---

# 💡 Senior Engineer Tips

## When should you choose SQLite?

| Scenario                                  | SQLite?                   |
| ----------------------------------------- | ------------------------- |
| Single-user desktop application           | ✔ Excellent               |
| Embedded device                           | ✔ Excellent               |
| Medical TPS workstation                   | ✔ Excellent               |
| Local cache                               | ✔ Excellent               |
| Enterprise server with thousands of users | ✘ Prefer PostgreSQL/MySQL |

---

## Medical TPS Database Design

```text id="sqlite43"
Patient
    │
    ├────────────┐
    ▼            ▼
Study       TreatmentPlan
                  │
          ┌───────┴────────┐
          ▼                ▼
      Beam            Prescription
          │
          ▼
      Audit Log
```

Large assets such as:

* CT image volumes
* RT Dose voxel data
* 3D meshes

are commonly stored as external files, while SQLite stores metadata, relationships, and file references.

---


## **Chapter 71 — MySQL (Complete Deep Dive)**

