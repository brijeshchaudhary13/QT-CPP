# Complete Qt Master Course (Qt 5.15 LTS → Qt 6.11)

# PART IX — Database Programming

# Chapter 71 — MySQL (Complete Deep Dive)

## Master MySQL, Client-Server Architecture, Qt Integration, Performance Optimization & Enterprise Database Development

> **Level:** Advanced → Expert

---

# Chapter Objectives

After completing this chapter, you will understand:

* What is MySQL?
* MySQL Architecture
* MySQL Server vs SQLite
* Installing MySQL
* Connecting Qt to MySQL
* Authentication
* CRUD Operations
* Prepared Statements
* Indexes
* Views
* Stored Procedures
* Transactions
* Connection Pooling Concepts
* Replication Overview
* Enterprise Architecture
* Qt Internals
* Qt 5.15 vs Qt 6.11
* Best Practices
* Interview Questions

---

# Table of Contents

1. Introduction
2. MySQL Architecture
3. SQLite vs MySQL
4. Installing MySQL
5. Connecting Qt to MySQL
6. Authentication
7. CRUD Operations
8. Prepared Statements
9. Indexes
10. Views
11. Stored Procedures
12. Transactions
13. Connection Pooling Concepts
14. Replication Overview
15. Enterprise Applications
16. Qt Internals
17. Qt 5 vs Qt 6
18. Best Practices
19. Common Mistakes
20. Interview Questions
21. Revision Notes

---

# 1. Introduction

Unlike SQLite, **MySQL** is a **client-server relational database management system (RDBMS)**.

The database runs as a **separate server process**, and applications connect to it over a local socket or a network.

Typical use cases:

* Enterprise ERP
* Hospital Management Systems
* CRM
* Banking
* E-Commerce
* Cloud Applications
* Multi-user Desktop Software

---

## Architecture

```text
Qt Application

      │
      ▼
Qt SQL (QMYSQL Driver)

      │
      ▼
MySQL Server

      │
      ▼
Database Files
```

Unlike SQLite, multiple clients can connect to the same server simultaneously.

---

# 2. MySQL Architecture

```text
+----------------------+
|   Qt Application     |
+----------+-----------+
           |
           v
+----------------------+
| Qt SQL (QSqlQuery)   |
+----------+-----------+
           |
           v
+----------------------+
| QMYSQL Driver        |
+----------+-----------+
           |
           v
========================
   TCP/IP or Socket
========================
           |
           v
+----------------------+
| MySQL Server         |
+----------+-----------+
           |
           v
+----------------------+
| Storage Engine       |
| (Usually InnoDB)     |
+----------+-----------+
           |
           v
+----------------------+
| Database Files       |
+----------------------+
```

---

# 3. SQLite vs MySQL

| Feature            | SQLite             | MySQL                 |
| ------------------ | ------------------ | --------------------- |
| Architecture       | Embedded           | Client-Server         |
| Installation       | None               | Server Required       |
| Multiple Users     | Limited            | Excellent             |
| Network Access     | No                 | Yes                   |
| Scalability        | Small to Medium    | Medium to Very Large  |
| Concurrency        | Good               | Excellent             |
| Backup             | Copy Database File | Database Backup Tools |
| Enterprise Support | Limited            | Excellent             |

---

## Which Should You Choose?

| Scenario                         | Recommended |
| -------------------------------- | ----------- |
| Desktop CAD                      | SQLite      |
| Medical TPS (Single Workstation) | SQLite      |
| Hospital Information System      | MySQL       |
| ERP                              | MySQL       |
| Online Application               | MySQL       |

---

# 4. Installing MySQL

Typical installation steps:

1. Install MySQL Server.
2. Create a database.
3. Create users.
4. Grant permissions.
5. Start the server.
6. Connect from Qt.

Example database

```sql
CREATE DATABASE HospitalDB;
```

---

# 5. Connecting Qt to MySQL

Create connection

```cpp
QSqlDatabase db =
    QSqlDatabase::addDatabase("QMYSQL");
```

Configure connection

```cpp
db.setHostName("127.0.0.1");

db.setDatabaseName("HospitalDB");

db.setUserName("admin");

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
Application

↓

QSqlDatabase

↓

QMYSQL Driver

↓

TCP/IP

↓

MySQL Server
```

---

# 6. Authentication

Authentication verifies that a user is allowed to access the database.

Typical credentials:

* Host
* Username
* Password
* Database

Example

```text
Host:
192.168.1.20

↓

Username:
admin

↓

Password:
********

↓

Login
```

---

## Security Tips

Never:

```cpp
QString password =
"123456";
```

inside source code.

Instead:

* Environment variables
* Configuration files
* Secure credential stores

---

# 7. CRUD Operations

Exactly the same SQL used with SQLite.

Insert

```sql
INSERT INTO Patient
(Name, Age)

VALUES
('John',45);
```

---

Read

```sql
SELECT *

FROM Patient;
```

---

Update

```sql
UPDATE Patient

SET Age=50

WHERE ID=1;
```

---

Delete

```sql
DELETE FROM Patient

WHERE ID=1;
```

---

# 8. Prepared Statements

Qt

```cpp
QSqlQuery query;

query.prepare(
"SELECT *

FROM Patient

WHERE ID=?");
```

Bind

```cpp
query.addBindValue(id);
```

Execute

```cpp
query.exec();
```

---

Advantages

* Faster repeated execution
* SQL Injection protection
* Cleaner code

---

# 9. Indexes

Without index

```text
Patient Table

↓

Scan

↓

1 Million Rows
```

---

With index

```text
PatientID Index

↓

Direct Lookup

↓

Fast
```

---

Create

```sql
CREATE INDEX idx_patient_name

ON Patient(Name);
```

---

# 10. Views

A **View** is a virtual table created from a query.

Example

```sql
CREATE VIEW AdultPatients AS

SELECT *

FROM Patient

WHERE Age >=18;
```

Query

```sql
SELECT *

FROM AdultPatients;
```

Advantages

* Simplifies complex queries
* Improves security
* Reusable

---

# 11. Stored Procedures

A stored procedure is SQL logic stored inside the database server.

Example concept

```text
Application

↓

Call Procedure

↓

MySQL Executes

↓

Results
```

Advantages

* Centralized logic
* Reuse
* Reduced network traffic

> **Note:** Qt executes stored procedures by sending the appropriate SQL command (such as `CALL procedure_name(...)`) through `QSqlQuery`. The exact syntax depends on the database.

---

# 12. Transactions

Example

```text
Transfer Money

↓

Debit

↓

Credit
```

Without transaction

Crash after debit

↓

Money Lost

---

With transaction

```text
BEGIN

↓

Debit

↓

Credit

↓

COMMIT
```

Qt

```cpp
db.transaction();

/* queries */

db.commit();
```

or

```cpp
db.rollback();
```

---

# 13. Connection Pooling Concepts

Opening a database connection is relatively expensive.

Bad

```text
Open

↓

Query

↓

Close

↓

Repeat
```

Better

```text
Pool

↓

Reuse

↓

Query
```

Large enterprise applications commonly maintain a pool of reusable connections.

> Qt does not include a built-in connection pool. Applications typically implement their own pool or use a framework that provides one.

---

# 14. Replication Overview

Replication copies data between servers.

```text
Primary Server

      │

      ▼

Replica 1

Replica 2

Replica 3
```

Benefits

* High availability
* Reporting
* Disaster recovery
* Read scalability

Qt applications usually connect transparently to the configured server.

---

# 15. Enterprise Applications

## Hospital

```text
Reception

↓

MySQL

↓

Doctors

↓

Billing
```

---

## ERP

```text
Inventory

↓

Sales

↓

Finance

↓

Reports
```

---

## Banking

```text
Accounts

↓

Transactions

↓

Audit
```

---

## Medical

```text
Patient

↓

Treatment

↓

Prescription

↓

Reports
```

---

# 16. Qt Internals

```text
QSqlQuery

↓

QMYSQL Driver

↓

TCP/IP

↓

MySQL Server

↓

Storage Engine
```

Execution

```text
SQL

↓

Parser

↓

Optimizer

↓

Execution Engine

↓

Rows
```

The MySQL server parses, optimizes, and executes the SQL before returning results to the Qt application.

---

# 17. Qt 5 vs Qt 6

| Feature             | Qt 5.15 | Qt 6.11 |
| ------------------- | ------- | ------- |
| QMYSQL Driver       | ✔       | ✔       |
| Prepared Statements | ✔       | ✔       |
| Transactions        | ✔       | ✔       |
| Views               | ✔       | ✔       |
| Stored Procedures   | ✔       | ✔       |

The Qt SQL API is almost identical across both versions.

---

# 18. Best Practices

✅ Use prepared statements.

✅ Create indexes only where needed.

✅ Use transactions for related updates.

✅ Keep SQL out of UI classes.

✅ Store credentials securely.

✅ Close or recycle idle connections.

---

# 19. Common Mistakes

### ❌ Hardcoding passwords

Use secure configuration management.

---

### ❌ Using `SELECT *` unnecessarily

Retrieve only required columns.

---

### ❌ Opening a connection for every query

Reuse connections.

---

### ❌ Ignoring transaction failures

Always verify commit success.

---

### ❌ Missing indexes

Large tables can become very slow.

---

# 20. Interview Questions

## Easy

1. What is MySQL?
2. How does MySQL differ from SQLite?
3. What is the QMYSQL driver?

---

## Medium

1. Explain prepared statements.
2. What is a database view?
3. What is a stored procedure?

---

## Hard

1. Explain MySQL client-server architecture.
2. What is connection pooling?
3. How does replication work?

---

## Expert

1. Design the database architecture for a Hospital Information System supporting thousands of concurrent users.
2. Explain how you would scale a Qt desktop application from SQLite to MySQL with minimal code changes.
3. Compare SQLite, MySQL, PostgreSQL, and SQL Server for enterprise engineering software.

---

# 21. Revision Notes

* MySQL is a client-server RDBMS.
* Qt connects using the `QMYSQL` driver.
* Authentication requires host, database, username, and password.
* CRUD operations are the same as in other SQL databases.
* Prepared statements improve security and performance.
* Views simplify query reuse.
* Stored procedures execute on the database server.
* Transactions ensure consistency.
* Connection pooling improves scalability.
* Replication improves availability and read scalability.

---

# 💡 Senior Engineer Tips

## SQLite vs MySQL Decision

| Requirement               | SQLite | MySQL |
| ------------------------- | ------ | ----- |
| Single-user desktop       | ⭐⭐⭐⭐⭐  | ⭐⭐    |
| Embedded system           | ⭐⭐⭐⭐⭐  | ⭐     |
| Multi-user application    | ⭐⭐     | ⭐⭐⭐⭐⭐ |
| Cloud deployment          | ⭐      | ⭐⭐⭐⭐⭐ |
| Easy deployment           | ⭐⭐⭐⭐⭐  | ⭐⭐    |
| Large concurrent workload | ⭐⭐     | ⭐⭐⭐⭐⭐ |

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

QMYSQL Driver

     │

     ▼

MySQL Server

     │

     ▼

InnoDB Storage Engine
```

---

## Medical Software Example

For a **Hospital Information System**:

```text
Patient Module
      │
      ▼
PatientRepository
      │
      ▼
QSqlQuery
      │
      ▼
MySQL Server
      │
      ├── Patients
      ├── Doctors
      ├── Appointments
      ├── Prescriptions
      └── Billing
```

For a standalone **Treatment Planning System (TPS)** running on a single workstation, **SQLite** is often the better choice because it simplifies deployment. If the TPS is integrated into a hospital-wide system with shared patient data, **MySQL or PostgreSQL** becomes a more suitable backend.

---



## **Chapter 72 — PostgreSQL (Complete Deep Dive)**

