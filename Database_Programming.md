

## **1. Qt SQL Module**

### **Definition**

The **Qt SQL module** provides a **database-agnostic API** to connect, query, and display data from SQL databases using Qt.

Key classes:

* `QSqlDatabase`
* `QSqlQuery`
* `QSqlTableModel`
* `QSqlRelationalTableModel`
* `QSqlError`

---

### **Why Qt SQL is needed**

* One API for multiple databases
* Integrates with **Model–View**
* Reduces boilerplate C++ DB code
* Safer and cleaner than raw drivers

---

### **How it works**

Qt SQL sits between your app and the database driver:

```
Your App → Qt SQL API → DB Driver → Database
```

---

### **Enable Qt SQL**

* **qmake**

```pro
QT += sql
```

* **CMake**

```cmake
find_package(Qt6 REQUIRED COMPONENTS Sql)
target_link_libraries(app Qt6::Sql)
```

---

## **2. Database Drivers**

### **Definition**

A **database driver** is a plugin that allows Qt to communicate with a specific database engine.

---

### **Why drivers matter**

Each database has different protocols. Drivers abstract those differences.

---

### **Common Drivers**

| Driver  | Database                |
| ------- | ----------------------- |
| QSQLITE | SQLite                  |
| QMYSQL  | MySQL                   |
| QPSQL   | PostgreSQL              |
| QODBC   | ODBC (SQL Server, etc.) |

---

### **How to check available drivers**

```cpp
qDebug() << QSqlDatabase::drivers();
```

---

### **Interview Tip**

> SQLite driver is **built-in** with Qt. Others may require client libraries.

---

## **3. Connecting to Database**

### **Definition**

Connecting means creating a database session using a driver and credentials.

---

### **Why connection handling is important**

* Resource management
* Connection reuse
* Error diagnosis

---

### **How to connect (steps)**

1. Add database with driver
2. Set connection parameters
3. Open connection
4. Check for errors

---

### **Example (SQLite)**

```cpp
QSqlDatabase db = QSqlDatabase::addDatabase("QSQLITE");
db.setDatabaseName("app.db");

if (!db.open()) {
    qDebug() << "DB Error:" << db.lastError().text();
}
```

---

### **Example (MySQL)**

```cpp
QSqlDatabase db = QSqlDatabase::addDatabase("QMYSQL");
db.setHostName("localhost");
db.setDatabaseName("testdb");
db.setUserName("user");
db.setPassword("pass");

if (!db.open()) {
    qDebug() << db.lastError().text();
}
```

---

## **4. QSqlDatabase**

### **Definition**

`QSqlDatabase` represents a **connection** to a database.

---

### **Why QSqlDatabase**

* Manages connection lifecycle
* Supports multiple connections
* Provides transaction control

---

### **How it works**

* Identified by **connection name**
* Shared implicitly (lightweight copies)

---

### **Multiple Connections Example**

```cpp
QSqlDatabase db1 = QSqlDatabase::addDatabase("QSQLITE", "conn1");
QSqlDatabase db2 = QSqlDatabase::addDatabase("QSQLITE", "conn2");
```

---

### **Close Connection**

```cpp
db.close();
QSqlDatabase::removeDatabase("conn1");
```

---

## **5. QSqlQuery**

### **Definition**

`QSqlQuery` executes **SQL statements** (SELECT, INSERT, UPDATE, DELETE).

---

### **Why QSqlQuery**

* Execute custom SQL
* Prepared statements (security)
* Fast, flexible queries

---

### **How it works**

* Prepare SQL
* Bind values
* Execute
* Iterate results

---

### **Example: CREATE & INSERT**

```cpp
QSqlQuery query;

query.exec("CREATE TABLE users (id INTEGER, name TEXT)");

query.prepare("INSERT INTO users VALUES (?, ?)");
query.addBindValue(1);
query.addBindValue("Alice");
query.exec();
```

---

### **Example: SELECT**

```cpp
QSqlQuery query("SELECT id, name FROM users");

while (query.next()) {
    int id = query.value(0).toInt();
    QString name = query.value(1).toString();
}
```

---

### **Prepared Statements (Security)**

```cpp
query.prepare("SELECT * FROM users WHERE name = ?");
query.addBindValue("Alice");
query.exec();
```

👉 Prevents **SQL Injection**.

---

## **6. QSqlTableModel**

### **Definition**

`QSqlTableModel` is a **model** that represents a **single database table**.

---

### **Why QSqlTableModel**

* Automatic CRUD
* Direct integration with `QTableView`
* Less SQL code

---

### **How it works**

* Set table name
* Call `select()`
* View reflects DB data

---

### **Example**

```cpp
QSqlTableModel *model = new QSqlTableModel(this);
model->setTable("users");
model->select();

QTableView *view = new QTableView;
view->setModel(model);
view->show();
```

---

### **Editing Data**

```cpp
model->setEditStrategy(QSqlTableModel::OnFieldChange);
```

---

## **7. QSqlRelationalTableModel**

### **Definition**

`QSqlRelationalTableModel` handles **foreign key relationships** between tables.

---

### **Why use relational model**

* Display related data (JOIN-like behavior)
* Use dropdowns for foreign keys
* Cleaner UI

---

### **How it works**

* Define relations
* Use `QSqlRelation`

---

### **Example**

Tables:

* `orders(customer_id)`
* `customers(id, name)`

```cpp
QSqlRelationalTableModel *model = new QSqlRelationalTableModel(this);
model->setTable("orders");
model->setRelation(1, QSqlRelation("customers", "id", "name"));
model->select();
```

---

### **Delegate for Relation**

```cpp
view->setItemDelegate(new QSqlRelationalDelegate(view));
```

---

## **8. Transactions**

### **Definition**

A **transaction** is a group of SQL operations that **execute as a single unit**.

---

### **Why transactions are important**

* Data consistency
* Rollback on failure
* Critical for financial/medical apps

---

### **How transactions work**

1. Start transaction
2. Execute queries
3. Commit or rollback

---

### **Example**

```cpp
db.transaction();

QSqlQuery q;
q.exec("INSERT INTO users VALUES (2, 'Bob')");

if (!q.exec()) {
    db.rollback();
} else {
    db.commit();
}
```

---

### **Interview Tip**

> Transactions ensure **ACID** properties.

---

## **9. Error Handling**

### **Definition**

Error handling detects and reports **database failures**.

---

### **Why error handling is critical**

* Connection issues
* SQL syntax errors
* Constraint violations

---

### **How to handle errors**

* Check return values
* Use `QSqlError`

---

### **Example**

```cpp
if (!query.exec()) {
    QSqlError err = query.lastError();
    qDebug() << err.text();
}
```

---

### **Connection Error**

```cpp
if (!db.isOpen()) {
    qDebug() << db.lastError().text();
}
```

---

## **Common Mistakes (Interview Traps)**

❌ Not checking `open()` result
❌ Hardcoding SQL without prepared statements
❌ Forgetting to call `select()` on models
❌ Updating DB without transactions
❌ Not removing named connections

---

## **Interview Questions (Chapter 17)**

**Q: Difference between QSqlQuery and QSqlTableModel?**
👉 Query = manual SQL, Model = table abstraction

**Q: How to prevent SQL injection?**
👉 Prepared statements

**Q: Which class integrates DB with views?**
👉 QSqlTableModel / QSqlRelationalTableModel

---

## **Interview Summary (One-liners)**

* Qt SQL = DB abstraction
* Drivers connect to DB engines
* QSqlDatabase manages connections
* QSqlQuery executes SQL
* Table models bind DB to views
* Transactions ensure consistency
* QSqlError handles failures

---
