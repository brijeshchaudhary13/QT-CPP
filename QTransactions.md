# Complete Qt Master Course (Qt 5.15 LTS → Qt 6.11)

# PART IX — Database Programming

# Chapter 73 — Transactions (Complete Deep Dive)

## Master ACID, Commit, Rollback, Savepoints, Isolation Levels, Deadlocks & Enterprise Transaction Design

> **Level:** Advanced → Architect

---

# Chapter Objectives

After completing this chapter, you will understand:

* What is a Transaction?
* Why Transactions are Important
* ACID Properties
* Transaction Lifecycle
* Commit
* Rollback
* Savepoints
* Isolation Levels
* Concurrency Problems
* Deadlocks
* Optimistic vs Pessimistic Locking
* Distributed Transaction Concepts
* Qt Transaction APIs
* Enterprise Transaction Architecture
* Medical TPS Examples
* Qt 5.15 vs Qt 6.11
* Best Practices
* Interview Questions

---

# Table of Contents

1. Introduction
2. What is a Transaction?
3. ACID Properties
4. Transaction Lifecycle
5. Commit
6. Rollback
7. Savepoints
8. Isolation Levels
9. Concurrency Problems
10. Deadlocks
11. Optimistic vs Pessimistic Locking
12. Distributed Transaction Concepts
13. Qt Transaction APIs
14. Enterprise Applications
15. Qt Internals
16. Qt 5 vs Qt 6
17. Best Practices
18. Common Mistakes
19. Interview Questions
20. Revision Notes

---

# 1. Introduction

A **transaction** is a group of database operations that must be treated as a **single logical unit of work**.

Either:

* **All operations succeed**, or
* **None of them are applied**

Transactions protect data from becoming inconsistent.

---

## Example

Bank Transfer

```text id="txn01"
Account A

₹1000

↓

Withdraw ₹500

↓

Deposit ₹500

↓

Account B
```

If the application crashes after the withdrawal but before the deposit, money would disappear without transactions.

---

# 2. What is a Transaction?

A transaction groups multiple SQL statements together.

Example

```text id="txn02"
BEGIN

↓

INSERT

↓

UPDATE

↓

DELETE

↓

COMMIT
```

If something goes wrong:

```text id="txn03"
BEGIN

↓

INSERT

↓

Error

↓

ROLLBACK
```

---

# 3. ACID Properties

Every reliable relational database follows the **ACID** principles.

---

## A — Atomicity

"All or nothing."

```text id="txn04"
Step 1 ✔

Step 2 ✔

Step 3 ✘

↓

Rollback Everything
```

No partial updates remain.

---

## C — Consistency

The database always moves from one valid state to another.

Example

```text id="txn05"
Patient Exists

↓

Treatment Plan Created

↓

Prescription Created

↓

Valid Database
```

Constraints and business rules remain satisfied.

---

## I — Isolation

Multiple users should not interfere with each other.

```text id="txn06"
User A

↓

Transaction

↓

User B
```

Isolation controls what each user can see while transactions are in progress.

---

## D — Durability

After a successful commit:

```text id="txn07"
Commit

↓

Power Failure

↓

Data Still Exists
```

Committed data survives crashes through the database's recovery mechanisms.

---

# ACID Summary

| Property    | Meaning                                  |
| ----------- | ---------------------------------------- |
| Atomicity   | All or nothing                           |
| Consistency | Valid database state                     |
| Isolation   | Concurrent transactions behave correctly |
| Durability  | Committed data survives failures         |

---

# 4. Transaction Lifecycle

```text id="txn08"
BEGIN

↓

Execute SQL

↓

Success?

↓

Yes

↓

COMMIT

OR

↓

ROLLBACK
```

---

Qt Example

```cpp id="txn09"
db.transaction();

/* SQL */

db.commit();
```

---

# 5. Commit

A commit permanently saves all changes.

```text id="txn10"
Transaction

↓

Commit

↓

Disk

↓

Finished
```

Qt

```cpp id="txn11"
if (!db.commit())
{
    // Handle error
}
```

Always verify that the commit succeeds.

---

# 6. Rollback

Rollback cancels every change made within the transaction.

Example

```text id="txn12"
Insert

↓

Update

↓

Delete

↓

Error

↓

Rollback
```

Result

```text id="txn13"
Database

↓

Original State
```

Qt

```cpp id="txn14"
db.rollback();
```

---

# 7. Savepoints

Sometimes you want to roll back only part of a transaction.

Example

```text id="txn15"
BEGIN

↓

Insert Patient

↓

SAVEPOINT A

↓

Insert Plan

↓

SAVEPOINT B

↓

Insert Beam

↓

Error
```

Instead of rolling back everything:

```text id="txn16"
Rollback

↓

Savepoint B
```

The earlier work remains.

---

Typical SQL

```sql id="txn17"
SAVEPOINT PlanCreated;
```

Rollback

```sql id="txn18"
ROLLBACK TO SAVEPOINT PlanCreated;
```

Release

```sql id="txn19"
RELEASE SAVEPOINT PlanCreated;
```

Qt sends these SQL commands using `QSqlQuery`, since there is no dedicated savepoint API in `QSqlDatabase`.

---

# 8. Isolation Levels

Isolation determines how concurrent transactions interact.

---

## Read Uncommitted

```text id="txn20"
User A

↓

Uncommitted Change

↓

User B Can Read
```

Possible issue:

Dirty Reads

---

## Read Committed

```text id="txn21"
User A

↓

Commit

↓

User B Reads
```

Dirty reads are prevented.

---

## Repeatable Read

Within one transaction:

```text id="txn22"
Read

↓

Same Read Again

↓

Same Result
```

The same row appears unchanged during the transaction, though behavior varies by database implementation.

---

## Serializable

Transactions behave as though they execute one after another.

```text id="txn23"
Transaction A

↓

Transaction B
```

Highest consistency

Lowest concurrency

---

Comparison

| Level            | Dirty Reads | Non-Repeatable Reads | Phantom Reads*     |
| ---------------- | ----------- | -------------------- | ------------------ |
| Read Uncommitted | Possible    | Possible             | Possible           |
| Read Committed   | Prevented   | Possible             | Possible           |
| Repeatable Read  | Prevented   | Prevented            | Database-dependent |
| Serializable     | Prevented   | Prevented            | Prevented          |

> *The exact behavior depends on the database implementation (for example, PostgreSQL's MVCC differs from MySQL/InnoDB in some cases).

---

# 9. Concurrency Problems

## Dirty Read

```text id="txn24"
User A

↓

Update

(Not Committed)

↓

User B Reads
```

If User A rolls back, User B has read invalid data.

---

## Non-Repeatable Read

```text id="txn25"
Read Age

↓

Another User Updates

↓

Read Again

↓

Different Value
```

---

## Phantom Read

```text id="txn26"
SELECT Patients

↓

Another User Inserts

↓

SELECT Again

↓

Extra Row
```

---

# 10. Deadlocks

Deadlock

```text id="txn27"
User A

Locks Row 1

↓

Needs Row 2

-----------------

User B

Locks Row 2

↓

Needs Row 1
```

Neither transaction can continue.

Modern databases detect deadlocks and abort one transaction automatically.

---

# Avoid Deadlocks

* Lock resources in a consistent order.
* Keep transactions short.
* Avoid unnecessary locks.
* Retry failed transactions when appropriate.

---

# 11. Optimistic vs Pessimistic Locking

## Optimistic Locking

Assumption:

Conflicts are rare.

Workflow

```text id="txn28"
Read

↓

Modify

↓

Verify Version

↓

Commit
```

If another user modified the data first, the update is rejected or retried.

---

## Pessimistic Locking

Assumption:

Conflicts are likely.

```text id="txn29"
Lock Row

↓

Modify

↓

Unlock
```

Advantages

* Prevents conflicting updates

Disadvantages

* Reduced concurrency
* Higher chance of blocking

---

Comparison

| Feature        | Optimistic | Pessimistic |
| -------------- | ---------- | ----------- |
| Lock Early     | No         | Yes         |
| Concurrency    | High       | Lower       |
| Retry Required | Sometimes  | Rare        |
| Blocking       | Low        | Higher      |

---

# 12. Distributed Transaction Concepts

Some enterprise systems update multiple databases or services.

Example

```text id="txn30"
Hospital Database

↓

Billing System

↓

Insurance System
```

A transaction spanning multiple independent systems is much more complex.

Common approaches include:

* Two-Phase Commit (2PC)
* Saga Pattern (microservices)

Qt itself does not provide distributed transaction management.

---

# 13. Qt Transaction APIs

Qt provides a simple transaction API through `QSqlDatabase`.

Begin

```cpp id="txn31"
db.transaction();
```

Commit

```cpp id="txn32"
db.commit();
```

Rollback

```cpp id="txn33"
db.rollback();
```

Example

```cpp id="txn34"
if (db.transaction())
{
    // Execute queries

    if (success)
        db.commit();
    else
        db.rollback();
}
```

---

# 14. Enterprise Applications

## Banking

```text id="txn35"
Withdraw

↓

Deposit

↓

Commit
```

---

## Hospital

```text id="txn36"
Patient

↓

Appointment

↓

Billing

↓

Commit
```

---

## Medical TPS

```text id="txn37"
Patient

↓

Treatment Plan

↓

Prescription

↓

Beam Data

↓

Commit
```

If any step fails, the database should roll back the transaction to avoid incomplete treatment records.

---

## ERP

```text id="txn38"
Order

↓

Inventory

↓

Invoice

↓

Commit
```

---

# 15. Qt Internals

```text id="txn39"
QSqlDatabase

↓

Driver

↓

Database

↓

Transaction Log

↓

Storage
```

Most relational databases use a transaction log (such as WAL or redo logs) to recover committed transactions after crashes.

---

# 16. Qt 5 vs Qt 6

| Feature      | Qt 5.15          | Qt 6.11          |
| ------------ | ---------------- | ---------------- |
| Transactions | ✔                | ✔                |
| Commit       | ✔                | ✔                |
| Rollback     | ✔                | ✔                |
| Savepoints   | Via SQL          | Via SQL          |
| Isolation    | Database Feature | Database Feature |

Qt provides the API to start, commit, and roll back transactions, while the database engine implements the isolation semantics.

---

# 17. Best Practices

✅ Keep transactions as short as possible.

✅ Always check the result of `commit()`.

✅ Roll back on failure.

✅ Use prepared statements inside transactions.

✅ Retry operations that fail because of deadlocks or serialization conflicts when appropriate.

---

# 18. Common Mistakes

### ❌ Long-running transactions

They increase lock duration and resource usage.

---

### ❌ Forgetting rollback

An error should not leave the transaction open indefinitely.

---

### ❌ Mixing UI operations inside transactions

Collect user input before starting the transaction whenever possible.

---

### ❌ Ignoring commit failures

A successful SQL statement does not guarantee a successful commit.

---

### ❌ Assuming all databases implement isolation identically

Behavior varies between database engines.

---

# 19. Interview Questions

## Easy

1. What is a transaction?
2. What does ACID stand for?
3. What is the difference between commit and rollback?

---

## Medium

1. Explain savepoints.
2. What are isolation levels?
3. What is a dirty read?

---

## Hard

1. Explain MVCC versus locking-based concurrency.
2. What causes a deadlock?
3. Compare optimistic and pessimistic locking.

---

## Expert

1. Design the transaction strategy for a Medical Treatment Planning System where creating a treatment plan updates multiple related tables atomically.
2. Explain how you would handle deadlocks in a high-concurrency hospital application.
3. Compare transaction handling in SQLite, MySQL, and PostgreSQL.

---

# 20. Revision Notes

* A transaction is a logical unit of work.
* ACID guarantees reliability.
* `commit()` permanently saves changes.
* `rollback()` cancels changes.
* Savepoints allow partial rollbacks.
* Isolation levels define concurrent behavior.
* Deadlocks occur when transactions wait on each other.
* Optimistic locking favors concurrency.
* Pessimistic locking favors conflict prevention.
* Qt exposes transactions through `QSqlDatabase`.

---

# 💡 Senior Engineer Tips

## When should you use transactions?

| Operation                  | Use Transaction? |
| -------------------------- | ---------------- |
| Insert one row             | Usually optional |
| Insert parent + child rows | ✔ Yes            |
| Money transfer             | ✔ Mandatory      |
| Treatment plan creation    | ✔ Mandatory      |
| Inventory update           | ✔ Mandatory      |

---

## Enterprise Transaction Architecture

```text id="txn40"
UI

      │
      ▼

Service Layer

      │
      ▼

Repository Layer

      │
      ▼

Begin Transaction

      │
      ├──────────────┐
      ▼              ▼
 Update A       Update B
      │              │
      └──────┬───────┘
             ▼

         Commit
```

The **Service Layer** typically owns the transaction because it coordinates multiple repository operations. Individual repositories should generally execute SQL but avoid committing independently when participating in a larger business operation.

---

## Medical TPS Example

```text id="txn41"
Create Treatment Plan
          │
          ├──────────────┐
          ▼              ▼
Insert Patient     Insert Prescription
          │              │
          ├──────────────┤
          ▼              ▼
Insert Beams      Insert Dose Constraints
          │              │
          └──────┬───────┘
                 ▼
              Commit
```

If any insert fails (for example, an invalid beam configuration), the transaction should be rolled back so that no incomplete treatment plan exists in the database.

---


## **Chapter 74 — TCP (Complete Deep Dive)**
