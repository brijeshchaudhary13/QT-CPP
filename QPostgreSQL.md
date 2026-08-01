# Complete Qt Master Course (Qt 5.15 LTS → Qt 6.11)

# PART IX — Database Programming

# Chapter 72 — PostgreSQL (Complete Deep Dive)

## Master PostgreSQL, QPSQL Driver, MVCC, JSONB, Advanced SQL & Enterprise Qt Applications

> **Level:** Advanced → Architect

---

# Chapter Objectives

After completing this chapter, you will understand:

* What is PostgreSQL?
* PostgreSQL Architecture
* PostgreSQL vs MySQL
* Qt PostgreSQL Driver (`QPSQL`)
* Connecting Qt to PostgreSQL
* MVCC (Multi-Version Concurrency Control)
* JSONB
* Arrays
* Window Functions
* Common Table Expressions (CTEs)
* Index Types
* Transactions
* Performance Optimization
* Enterprise Applications
* Qt Internals
* Qt 5.15 vs Qt 6.11
* Best Practices
* Interview Questions

---

# Table of Contents

1. Introduction
2. PostgreSQL Architecture
3. PostgreSQL vs MySQL
4. Connecting Qt to PostgreSQL
5. PostgreSQL Data Types
6. MVCC
7. JSONB
8. Arrays
9. Common Table Expressions (CTEs)
10. Window Functions
11. Index Types
12. Transactions
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

**PostgreSQL** is one of the world's most powerful open-source relational database management systems (RDBMS).

It is widely used in:

* Enterprise software
* Banking
* Healthcare
* GIS
* Scientific computing
* Financial systems
* Government applications
* Cloud-native systems

Unlike SQLite, PostgreSQL is a **client-server** database.

Unlike MySQL, PostgreSQL is known for its:

* Advanced SQL support
* Strong ACID compliance
* Extensibility
* Rich data types
* High reliability

---

## Architecture

```text
Qt Application

      │
      ▼
Qt SQL (QPSQL Driver)

      │
      ▼
TCP/IP

      │
      ▼
PostgreSQL Server

      │
      ▼
Database Storage
```

---

# 2. PostgreSQL Architecture

```text
+------------------------+
|   Qt Application       |
+-----------+------------+
            │
            ▼
+------------------------+
| QPSQL Driver           |
+-----------+------------+
            │
            ▼
==========================
       TCP/IP
==========================
            │
            ▼
+------------------------+
| PostgreSQL Server      |
+-----------+------------+
            │
            ▼
+------------------------+
| Query Planner          |
+-----------+------------+
            │
            ▼
+------------------------+
| Storage Engine         |
+------------------------+
```

Major components:

* Query Parser
* Query Optimizer
* Execution Engine
* Storage Manager
* WAL (Write-Ahead Log)

---

# 3. PostgreSQL vs MySQL

| Feature                 | PostgreSQL   | MySQL              |
| ----------------------- | ------------ | ------------------ |
| SQL Standard Compliance | Excellent    | Good               |
| ACID Support            | Excellent    | Excellent (InnoDB) |
| JSON Support            | JSON + JSONB | JSON               |
| Window Functions        | Excellent    | Excellent          |
| CTE Support             | Excellent    | Excellent          |
| Extensibility           | Excellent    | Moderate           |
| GIS Support             | PostGIS      | Limited            |
| Scientific Workloads    | Excellent    | Good               |
| Enterprise Systems      | Excellent    | Excellent          |

---

## When Should You Choose PostgreSQL?

Ideal for:

* Medical systems
* GIS
* Financial applications
* Scientific software
* Large enterprise systems

---

# 4. Connecting Qt to PostgreSQL

Qt uses the **QPSQL** driver.

```cpp
QSqlDatabase db =
    QSqlDatabase::addDatabase("QPSQL");
```

Configure connection

```cpp
db.setHostName("localhost");

db.setDatabaseName("HospitalDB");

db.setUserName("postgres");

db.setPassword("password");
```

Open

```cpp
if(db.open())
{
    qDebug() << "Connected";
}
```

---

## Connection Workflow

```text
Qt Application

↓

QSqlDatabase

↓

QPSQL Driver

↓

TCP/IP

↓

PostgreSQL Server
```

---

# 5. PostgreSQL Data Types

Beyond standard SQL types, PostgreSQL offers many advanced data types.

| Type      | Example           |
| --------- | ----------------- |
| INTEGER   | 10                |
| NUMERIC   | 125.35            |
| TEXT      | "John"            |
| BOOLEAN   | true              |
| DATE      | 2026-08-01        |
| TIMESTAMP | Date & Time       |
| UUID      | Unique Identifier |
| JSON      | JSON document     |
| JSONB     | Binary JSON       |
| ARRAY     | List of values    |
| BYTEA     | Binary data       |

---

Example

```sql
CREATE TABLE Patient
(
    ID UUID PRIMARY KEY,

    Name TEXT,

    Age INTEGER
);
```

---

# 6. MVCC (Multi-Version Concurrency Control)

One of PostgreSQL's biggest strengths.

Instead of locking rows aggressively,

PostgreSQL creates multiple versions.

```text
User A

↓

Reads Row

↓

Version 1

------------------

User B

↓

Updates Row

↓

Version 2
```

Advantages

* High concurrency
* Fewer locks
* Better scalability
* Excellent multi-user performance

---

## Traditional Locking

```text
User A

↓

Lock

↓

User B Waits
```

---

## MVCC

```text
User A

↓

Old Version

User B

↓

New Version
```

No blocking in many read scenarios.

---

# 7. JSONB

PostgreSQL supports two JSON types.

| Type  | Description             |
| ----- | ----------------------- |
| JSON  | Stored as text          |
| JSONB | Stored in binary format |

---

Example

```sql
CREATE TABLE Config
(
    Data JSONB
);
```

Stored value

```json
{
    "theme":"dark",
    "language":"en"
}
```

Advantages

* Fast lookup
* Index support
* Efficient storage

---

# 8. Arrays

Unlike many databases,

PostgreSQL supports arrays directly.

Example

```sql
CREATE TABLE Beam
(
    EnergyLevels INTEGER[]
);
```

Stored

```text
[6,10,15]
```

Applications

* Medical beam energies
* CAD layers
* Scientific measurements

---

# 9. Common Table Expressions (CTEs)

CTEs improve readability.

Example

```sql
WITH AdultPatients AS
(
    SELECT *

    FROM Patient

    WHERE Age >=18
)

SELECT *

FROM AdultPatients;
```

Advantages

* Readable
* Modular SQL
* Recursive queries

---

# 10. Window Functions

Window functions perform calculations across related rows **without collapsing the result set**.

Example

```sql
SELECT

Name,

Salary,

RANK() OVER
(
ORDER BY Salary DESC
)

FROM Employee;
```

Applications

* Rankings
* Running totals
* Percentiles
* Analytics

---

# 11. Index Types

PostgreSQL supports multiple index types.

| Index   | Use Case                        |
| ------- | ------------------------------- |
| B-tree  | General-purpose                 |
| Hash    | Equality lookups                |
| GIN     | JSONB, Arrays, Full Text Search |
| GiST    | GIS, Spatial                    |
| BRIN    | Very large tables               |
| SP-GiST | Specialized spatial structures  |

---

Example

```sql
CREATE INDEX

idx_patient_name

ON Patient(Name);
```

---

JSONB Index

```sql
CREATE INDEX

idx_config

ON Config

USING GIN(Data);
```

---

# 12. Transactions

Exactly like Qt SQL.

Qt

```cpp
db.transaction();

/* SQL */

db.commit();
```

Rollback

```cpp
db.rollback();
```

PostgreSQL provides strong transaction guarantees with excellent concurrency.

---

# 13. Performance Optimization

## Use Indexes

```text
Query

↓

Index

↓

Fast
```

---

## Analyze Query

```sql
EXPLAIN ANALYZE
```

Provides:

* Query plan
* Execution time
* Index usage

---

## Avoid

```sql
SELECT *
```

when unnecessary.

---

## Batch Inserts

Better than one insert at a time for large imports.

---

# 14. Enterprise Applications

## Medical TPS

```text
Patient

↓

CT Study

↓

Treatment Plan

↓

Dose

↓

Audit
```

---

## GIS

```text
Map

↓

Spatial Data

↓

PostGIS
```

---

## Banking

```text
Accounts

↓

Transactions

↓

Reports
```

---

## Scientific Software

```text
Experiments

↓

Measurements

↓

Analytics
```

---

# 15. Qt Internals

```text
QSqlQuery

↓

QPSQL Driver

↓

TCP/IP

↓

PostgreSQL

↓

Planner

↓

Execution Engine
```

The PostgreSQL planner chooses the most efficient execution strategy based on table statistics and available indexes.

---

# 16. Qt 5 vs Qt 6

| Feature             | Qt 5.15          | Qt 6.11          |
| ------------------- | ---------------- | ---------------- |
| QPSQL Driver        | ✔                | ✔                |
| Transactions        | ✔                | ✔                |
| JSON Support        | ✔                | ✔                |
| Prepared Statements | ✔                | ✔                |
| Window Functions    | Database Feature | Database Feature |

Qt sends SQL to PostgreSQL. Features like JSONB, CTEs, and window functions are **database capabilities**, not Qt-specific APIs.

---

# 17. Best Practices

✅ Use prepared statements.

✅ Prefer UUIDs when globally unique identifiers are required.

✅ Use JSONB for searchable JSON.

✅ Create indexes based on actual query patterns.

✅ Use `EXPLAIN ANALYZE` to investigate slow queries.

✅ Keep SQL logic separate from UI code.

---

# 18. Common Mistakes

### ❌ Using `SELECT *` everywhere

Read only required columns.

---

### ❌ Forgetting indexes on frequently filtered columns

Performance suffers as data grows.

---

### ❌ Ignoring `EXPLAIN ANALYZE`

Never optimize blindly.

---

### ❌ Storing everything in JSONB

Use relational tables for structured data and JSONB only where flexibility is beneficial.

---

### ❌ Long-running transactions

They can increase storage usage and reduce system performance.

---

# 19. Interview Questions

## Easy

1. What is PostgreSQL?
2. How is PostgreSQL different from MySQL?
3. What is the QPSQL driver?

---

## Medium

1. Explain MVCC.
2. What is JSONB?
3. What are window functions?

---

## Hard

1. Explain PostgreSQL architecture.
2. Compare JSON and JSONB.
3. What are Common Table Expressions?

---

## Expert

1. Design a PostgreSQL schema for a Medical Treatment Planning System supporting patients, studies, treatment plans, dose results, audit logs, and machine configurations.
2. Explain how MVCC improves concurrency compared with traditional locking.
3. Compare PostgreSQL, MySQL, SQL Server, and SQLite for enterprise desktop engineering software.

---

# 20. Revision Notes

* PostgreSQL is an enterprise client-server database.
* Qt connects using the `QPSQL` driver.
* MVCC enables high concurrency with reduced blocking.
* JSONB stores binary JSON efficiently.
* Arrays are native PostgreSQL data types.
* CTEs improve SQL readability.
* Window functions support analytics.
* Multiple index types optimize different workloads.
* `EXPLAIN ANALYZE` is essential for query tuning.
* PostgreSQL excels in enterprise, scientific, and healthcare applications.

---

# 💡 Senior Engineer Tips

## MySQL vs PostgreSQL

| Requirement             | MySQL | PostgreSQL      |
| ----------------------- | ----- | --------------- |
| Simple web applications | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐            |
| Enterprise software     | ⭐⭐⭐⭐  | ⭐⭐⭐⭐⭐           |
| Healthcare systems      | ⭐⭐⭐⭐  | ⭐⭐⭐⭐⭐           |
| Scientific applications | ⭐⭐⭐   | ⭐⭐⭐⭐⭐           |
| GIS                     | ⭐⭐    | ⭐⭐⭐⭐⭐ (PostGIS) |
| Advanced SQL            | ⭐⭐⭐   | ⭐⭐⭐⭐⭐           |

---

## Enterprise Qt Architecture

```text
Qt UI

      │

      ▼

Repository Layer

      │

      ▼

QSqlQuery

      │

      ▼

QPSQL Driver

      │

      ▼

PostgreSQL Server

      │

      ▼

MVCC Storage Engine
```

---

## Medical TPS Example

```text
Patient
    │
    ▼
Treatment Plan
    │
    ├───────────────┐
    ▼               ▼
Prescription    Beam Data
    │               │
    └───────┬───────┘
            ▼
       Dose Results
            │
            ▼
        Audit Log
```

A hospital-scale Treatment Planning System can benefit from PostgreSQL's:

* High concurrency (MVCC)
* Strong transactional guarantees
* Advanced indexing
* JSONB for flexible configuration data
* Scalability across multiple users and systems

---

## **Chapter 73 — Transactions (Complete Deep Dive)**
