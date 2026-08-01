# Complete Qt Master Course (Qt 5.15 LTS → Qt 6.11)

# PART IX — Database Programming

# Chapter 69 — Qt SQL (Complete Deep Dive)

## Master QSqlDatabase, QSqlQuery, QSqlDriver, Prepared Statements & Enterprise Database Architecture

> **Level:** Advanced → Expert

---

# Chapter Objectives

After completing this chapter, you will understand:

* What is Qt SQL?
* Qt SQL Architecture
* SQL Module
* `QSqlDatabase`
* `QSqlDriver`
* `QSqlQuery`
* `QSqlError`
* Database Connections
* CRUD Operations
* Prepared Statements
* Parameter Binding
* Transactions
* Model/View Integration
* Connection Management
* Enterprise Database Architecture
* Qt Internals
* Qt 5.15 vs Qt 6.11
* Best Practices
* Interview Questions

---

# Table of Contents

1. Introduction
2. Qt SQL Architecture
3. SQL Module
4. QSqlDatabase
5. QSqlDriver
6. QSqlQuery
7. CRUD Operations
8. Prepared Statements
9. Parameter Binding
10. Transactions
11. Model/View Integration
12. Error Handling
13. Connection Management
14. Enterprise Applications
15. Qt Internals
16. Qt 5 vs Qt 6
17. Best Practices
18. Common Mistakes
19. Interview Questions
20. Revision Notes

---

# 1. Introduction

Almost every enterprise application stores data in a database.

Examples:

* Hospital Management System
* Medical TPS
* ERP
* Banking
* CRM
* Inventory
* HR Management

Qt provides the **Qt SQL Module**, which offers a database-independent API.

Instead of writing code for MySQL, SQLite, PostgreSQL, or Oracle separately, you write against the Qt SQL API.

---

## Architecture

```text id="qtsql01"
Application

↓

Qt SQL API

↓

Database Driver

↓

Database
```

Only the driver changes when switching databases.

---

# 2. Qt SQL Architecture

Qt SQL consists of several core classes.

```text id="qtsql02"
QSqlDatabase

↓

QSqlQuery

↓

QSqlDriver

↓

SQLite

MySQL

PostgreSQL

ODBC
```

Responsibilities

| Class        | Purpose           |
| ------------ | ----------------- |
| QSqlDatabase | Connection        |
| QSqlQuery    | Execute SQL       |
| QSqlDriver   | Database driver   |
| QSqlError    | Error information |
| QSqlRecord   | One database row  |
| QSqlField    | One column        |

---

# 3. SQL Module

Header

```cpp id="qtsql03"
#include <QtSql>
```

Qt 6 CMake

```cmake id="qtsql04"
find_package(Qt6 REQUIRED COMPONENTS Sql)

target_link_libraries(
    app
    PRIVATE
    Qt6::Sql)
```

The SQL module supports multiple databases through plugins.

---

Supported Drivers

| Driver  | Database                 |
| ------- | ------------------------ |
| QSQLITE | SQLite                   |
| QMYSQL  | MySQL / MariaDB          |
| QPSQL   | PostgreSQL               |
| QODBC   | ODBC                     |
| QMIMER  | Mimer SQL (if available) |

Availability depends on how Qt is built and which database client libraries are installed.

---

# 4. QSqlDatabase

Header

```cpp id="qtsql05"
#include <QSqlDatabase>
```

Create connection

```cpp id="qtsql06"
QSqlDatabase db =
    QSqlDatabase::addDatabase(
        "QSQLITE");
```

Database file

```cpp id="qtsql07"
db.setDatabaseName(
    "hospital.db");
```

Open

```cpp id="qtsql08"
if(db.open())
{
}
```

---

Workflow

```text id="qtsql09"
Application

↓

QSqlDatabase

↓

Connection

↓

Database
```

---

## Remote Database

Example

```cpp id="qtsql10"
db.setHostName(...);

db.setDatabaseName(...);

db.setUserName(...);

db.setPassword(...);
```

Used for MySQL or PostgreSQL servers.

---

# 5. QSqlDriver

Qt communicates through drivers.

```text id="qtsql11"
Application

↓

QSqlDatabase

↓

Driver

↓

SQLite
```

Advantages

* Portable code
* Database independence

Switching from SQLite to PostgreSQL often requires only connection configuration changes, assuming your SQL is compatible.

---

# 6. QSqlQuery

Header

```cpp id="qtsql12"
#include <QSqlQuery>
```

Create

```cpp id="qtsql13"
QSqlQuery query;
```

Execute

```cpp id="qtsql14"
query.exec(
    "SELECT * FROM Patient");
```

---

Reading

```cpp id="qtsql15"
while(query.next())
{
}
```

---

Architecture

```text id="qtsql16"
SQL

↓

QSqlQuery

↓

Rows

↓

Application
```

---

Access values

```cpp id="qtsql17"
query.value(0);

query.value("Name");
```

---

# 7. CRUD Operations

CRUD means:

| Operation | SQL    |
| --------- | ------ |
| Create    | INSERT |
| Read      | SELECT |
| Update    | UPDATE |
| Delete    | DELETE |

---

## INSERT

```sql id="qtsql18"
INSERT INTO Patient
VALUES(...)
```

---

## SELECT

```sql id="qtsql19"
SELECT *

FROM Patient
```

---

## UPDATE

```sql id="qtsql20"
UPDATE Patient

SET Age=30
```

---

## DELETE

```sql id="qtsql21"
DELETE FROM Patient
```

These operations form the foundation of most database applications.

---

# 8. Prepared Statements

Instead of

```cpp id="qtsql22"
QString sql =
    "SELECT ...";
```

Use

```cpp id="qtsql23"
query.prepare(
"SELECT *

FROM Patient

WHERE ID=?");
```

Advantages

* Better performance for repeated execution
* Protection against SQL injection
* Cleaner code

---

Workflow

```text id="qtsql24"
Prepare

↓

Bind

↓

Execute
```

---

# 9. Parameter Binding

Bind values

```cpp id="qtsql25"
query.bindValue(
    0,
    patientId);
```

or named placeholders

```cpp id="qtsql26"
query.prepare(
"SELECT *
 FROM Patient
 WHERE ID=:id");

query.bindValue(
":id",
patientId);
```

Execute

```cpp id="qtsql27"
query.exec();
```

Advantages

* Safe
* Readable
* Efficient

Named placeholders often improve readability in complex queries.

---

# 10. Transactions

Without transaction

```text id="qtsql28"
Update A

↓

Crash

↓

Update B

↓

Database Inconsistent
```

---

With transaction

```text id="qtsql29"
Begin

↓

Update A

↓

Update B

↓

Commit
```

or

```text id="qtsql30"
Rollback
```

if an error occurs.

---

Qt API

```cpp id="qtsql31"
db.transaction();

db.commit();

db.rollback();
```

Transactions are essential whenever multiple operations must succeed or fail together.

---

# 11. Model/View Integration

Qt SQL integrates naturally with the Model/View framework.

Classes

| Class                    | Purpose                   |
| ------------------------ | ------------------------- |
| QSqlTableModel           | Database table            |
| QSqlQueryModel           | Query results             |
| QSqlRelationalTableModel | Foreign-key relationships |

Architecture

```text id="qtsql32"
Database

↓

QSqlTableModel

↓

QTableView
```

This allows database-backed tables with minimal code.

---

# 12. Error Handling

Always check:

```cpp id="qtsql33"
if(!query.exec())
{
}
```

Retrieve error

```cpp id="qtsql34"
query.lastError();
```

Connection error

```cpp id="qtsql35"
db.lastError();
```

Typical errors

* Connection failed
* Table missing
* Syntax error
* Constraint violation
* Permission denied

---

# 13. Connection Management

Large applications often manage connections centrally.

Architecture

```text id="qtsql36"
Application

↓

Database Manager

↓

Connection Pool

↓

Database
```

Benefits

* Reuse connections
* Central configuration
* Easier maintenance

> **Note:** Qt does not provide a built-in connection pool. Enterprise applications typically implement their own pooling strategy or use a framework that provides one.

---

# 14. Enterprise Applications

## Medical TPS

```text id="qtsql37"
Patient

↓

Database

↓

Treatment Plans

↓

Dose Results
```

---

## ERP

```text id="qtsql38"
Customers

↓

Orders

↓

Invoices

↓

Reports
```

---

## Banking

```text id="qtsql39"
Accounts

↓

Transactions

↓

Audit Logs
```

---

## Hospital

```text id="qtsql40"
Patient

↓

Doctor

↓

Prescription

↓

Billing
```

---

# 15. Qt Internals

Connection

```text id="qtsql41"
Application

↓

QSqlDatabase

↓

Driver

↓

Database
```

Query

```text id="qtsql42"
SQL

↓

QSqlQuery

↓

Driver

↓

Database
```

Results

```text id="qtsql43"
Rows

↓

QSqlRecord

↓

Application
```

The driver translates Qt API calls into database-specific protocol operations.

---

# 16. Qt 5 vs Qt 6

| Feature             | Qt 5.15 | Qt 6.11 |
| ------------------- | ------- | ------- |
| Qt SQL              | ✔       | ✔       |
| QSqlDatabase        | ✔       | ✔       |
| QSqlQuery           | ✔       | ✔       |
| Prepared Statements | ✔       | ✔       |
| Transactions        | ✔       | ✔       |

The SQL module API remains highly compatible between Qt 5 and Qt 6.

---

# 17. Best Practices

✅ Use prepared statements instead of building SQL strings.

✅ Check every database operation for errors.

✅ Use transactions for related updates.

✅ Close or remove unused database connections when appropriate.

✅ Separate SQL logic from UI code.

---

# 18. Common Mistakes

### ❌ Building SQL with string concatenation

This can introduce SQL injection vulnerabilities and formatting issues.

---

### ❌ Ignoring transaction failures

Always verify whether `commit()` succeeded.

---

### ❌ Keeping SQL inside UI classes

Create repository or data-access classes instead.

---

### ❌ Opening multiple unnecessary connections

Reuse connections where practical.

---

# 19. Interview Questions

## Easy

1. What is Qt SQL?
2. What is `QSqlDatabase`?
3. What is `QSqlQuery`?

---

## Medium

1. Explain prepared statements.
2. Why is parameter binding important?
3. How do transactions work?

---

## Hard

1. Explain how Qt communicates with different database engines.
2. Compare `QSqlQueryModel` and `QSqlTableModel`.
3. Design a database access layer for a desktop application.

---

## Expert

1. Design the database architecture for a Medical Treatment Planning System storing patients, CT studies, RT Plans, RT Structures, RT Dose references, machine configurations, and audit logs.
2. Explain how you would implement a repository layer using Qt SQL while keeping the UI independent of database code.
3. Compare SQLite, PostgreSQL, and MySQL for desktop medical software, discussing performance, concurrency, deployment, and maintenance.

---

# 20. Revision Notes

* Qt SQL provides a database-independent API.
* `QSqlDatabase` manages connections.
* `QSqlQuery` executes SQL statements.
* `QSqlDriver` communicates with the database engine.
* CRUD operations are Create, Read, Update, and Delete.
* Prepared statements improve safety and performance.
* Parameter binding avoids SQL injection.
* Transactions maintain data consistency.
* Qt SQL integrates directly with the Model/View framework.
* Always handle database errors.

---

# 💡 Senior Engineer Tips

## Which SQL class should you use?

| Requirement               | Recommended Class          |
| ------------------------- | -------------------------- |
| Open database             | `QSqlDatabase`             |
| Execute custom SQL        | `QSqlQuery`                |
| Display entire table      | `QSqlTableModel`           |
| Display SELECT query      | `QSqlQueryModel`           |
| Foreign-key relationships | `QSqlRelationalTableModel` |

---

## Enterprise Database Architecture

```text id="qtenterprise01"
UI

↓

Controller / ViewModel

↓

Repository

↓

QSqlQuery

↓

QSqlDatabase

↓

SQLite / PostgreSQL
```

The Repository isolates SQL code from the UI, making the application easier to test and maintain.

---

## Medical TPS Example

```text id="qtenterprise02"
Patient Module

        │
        ▼
PatientRepository

        │
        ▼
QSqlQuery

        │
        ▼
SQLite Database

        │
        ▼
Patient Records
Treatment Plans
Machine Data
Audit Logs
```

In production TPS software, the database usually stores **metadata** (patients, plans, prescriptions, machine settings, audit history), while **large binary assets** such as CT volumes and dose matrices are often stored separately on disk or in specialized storage, with the database maintaining references to those files.

---


## **Chapter 70 — SQLite (Complete Deep Dive)**


