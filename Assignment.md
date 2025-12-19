## **Assignment 1: Directory Management Application**

### **Objective**

Create a GUI-based application to manage directories.

### **Requirements**

1. Create a directory at a user-specified location.
2. Delete an existing directory.
3. Validate directory name and path (should not be empty).
4. Show proper success and error messages.
5. Use Qt GUI components (buttons, text fields, labels).

### **Expected Outcome**

* User can add a new directory.
* User can delete a selected directory.
* Application handles invalid inputs gracefully.

---

# **Solution**

---

## 🧠 **Concept (Before Coding)**

Qt provides the **`QDir`** class to work with directories:

* Create directory → `QDir().mkdir()`
* Delete directory → `QDir().rmdir()`
* Check existence → `QDir.exists()`

✔ No OS-specific code
✔ No SQL
✔ Safe & portable

---

# 🧩 **STEP-BY-STEP IMPLEMENTATION**

---

## 🔹 STEP 1: Create Qt Project

1. Open **Qt Creator**
2. File → New Project
3. Application → **Qt Widgets Application**
4. Project Name: `DirectoryManager`
5. Base Class: `QWidget`
6. Finish

---

## 🔹 STEP 2: UI DESIGN (Qt Designer)

Open `mainwindow.ui`

### ➤ Main Window

* Widget: `QWidget`
* Title: **Directory Management Application**
* Size: `500 x 250`

---

### ➤ Layout

1. Right-click on main widget
2. Select **Lay Out → Vertically**

---

### ➤ Add Widgets

| Widget      | Object Name   | Purpose              |
| ----------- | ------------- | -------------------- |
| QLabel      | `labelPath`   | Text: Directory Path |
| QLineEdit   | `pathEdit`    | Enter directory path |
| QPushButton | `createBtn`   | Create directory     |
| QPushButton | `deleteBtn`   | Delete directory     |
| QLabel      | `statusLabel` | Show status          |

---

### ➤ Widget Properties

**QLineEdit (`pathEdit`)**

* Placeholder Text: `Enter full directory path`

**Status Label (`statusLabel`)**

* Text: empty
* Alignment: Center

---

### ➤ Final UI Structure

```
Directory Path: [_____________________]
[ Create Directory ]   [ Delete Directory ]
Status Message Here
```

---

## 🔹 STEP 3: Header File (`mainwindow.h`)

```cpp
#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QWidget>

QT_BEGIN_NAMESPACE
namespace Ui { class MainWindow; }
QT_END_NAMESPACE

class MainWindow : public QWidget
{
    Q_OBJECT

public:
    MainWindow(QWidget *parent = nullptr);
    ~MainWindow();

private slots:
    void on_createBtn_clicked();
    void on_deleteBtn_clicked();

private:
    Ui::MainWindow *ui;
};

#endif
```

---

## 🔹 STEP 4: Source File (`mainwindow.cpp`)

### ➤ Include Required Headers

```cpp
#include "mainwindow.h"
#include "ui_mainwindow.h"
#include <QDir>
#include <QMessageBox>
```

---

### ➤ Constructor

```cpp
MainWindow::MainWindow(QWidget *parent)
    : QWidget(parent)
    , ui(new Ui::MainWindow)
{
    ui->setupUi(this);
}

MainWindow::~MainWindow()
{
    delete ui;
}
```

---

## 🔹 STEP 5: Create Directory Logic

```cpp
void MainWindow::on_createBtn_clicked()
{
    QString path = ui->pathEdit->text();

    if(path.isEmpty())
    {
        ui->statusLabel->setText("Path cannot be empty");
        return;
    }

    QDir dir;

    if(dir.exists(path))
    {
        ui->statusLabel->setText("Directory already exists");
        return;
    }

    if(dir.mkdir(path))
    {
        ui->statusLabel->setStyleSheet("color:green");
        ui->statusLabel->setText("Directory created successfully");
    }
    else
    {
        ui->statusLabel->setStyleSheet("color:red");
        ui->statusLabel->setText("Failed to create directory");
    }
}
```

---

## 🔹 STEP 6: Delete Directory Logic

```cpp
void MainWindow::on_deleteBtn_clicked()
{
    QString path = ui->pathEdit->text();

    if(path.isEmpty())
    {
        ui->statusLabel->setText("Path cannot be empty");
        return;
    }

    QDir dir(path);

    if(!dir.exists())
    {
        ui->statusLabel->setText("Directory does not exist");
        return;
    }

    if(dir.rmdir(path))
    {
        ui->statusLabel->setStyleSheet("color:green");
        ui->statusLabel->setText("Directory deleted successfully");
    }
    else
    {
        ui->statusLabel->setStyleSheet("color:red");
        ui->statusLabel->setText("Directory not empty or deletion failed");
    }
}
```

---

# 🔍 **Validation Covered**

✔ Empty path check
✔ Directory existence check
✔ Safe creation
✔ Safe deletion

---

# 📌 **Limitations (Explain Honestly)**

* `rmdir()` deletes **only empty directories**
* For non-empty directories, recursive delete is required

---

# 📊 **SQL-Style Mapping**

| SQL Concept | Directory App |
| ----------- | ------------- |
| CREATE      | mkdir         |
| DROP        | rmdir         |
| EXISTS      | dir.exists()  |

---

# **Assignment 2: Login SignUp Application**

## **Objective**

Design and develop a **Qt GUI-based Login Application** with a **Signup (Registration) feature** that allows users to register first and then log in using the registered credentials.

---

## **Functional Requirements**

### **1. Signup (Registration)**

1. Provide a **Signup page** for new users.
2. User must enter:

   * Username
   * Password
   * Confirm Password
3. Username and password fields must **not be empty**.
4. Password and confirm password must **match**.
5. Registered user data must be stored in a **QVector class (in-memory storage)**.
6. Duplicate usernames should **not be allowed**.
7. After successful registration, user should be able to navigate to the **Login page**.

---

### **2. Login**

1. Provide a **Login page** with:

   * Username field
   * Password field
2. Username and password must **not be empty**.
3. Login credentials must be validated using the data stored in **QVector**.
4. If credentials are correct:

   * Login should be successful.
   * User should be redirected to a **Welcome screen**.
5. If credentials are incorrect:

   * Display an appropriate error message.

---

### **3. UI & UX Features**

The application must include the following UI features:

1. **Show / Hide Password**

   * Password visibility toggle button.
2. **Icons inside input fields**

   * Username icon in username field.
   * Lock icon in password field.
3. **Clear Button**

   * Clears all input fields on the screen.
4. **Full-Screen Window**

   * Application should open in full-screen or maximized mode.
5. **Centered Login / Signup Card**

   * Login and Signup forms must be centered on the screen.
6. Use a **clean, modern Qt GUI layout**.

---

### **4. Constraints**

1. ❌ SQL database must **not** be used.
2. ❌ File or Excel storage must **not** be used.
3. ✔ Only **QVector** should be used to store user data during runtime.
4. ✔ Use **Qt Widgets** and **C++** only.

---

## **Expected Outcome**

* A working **Signup → Login → Welcome** flow.
* Secure and validated user input.
* Clean UI with modern usability features.
* Demonstration of **Qt GUI design**, **C++ logic**, and **QVector-based data handling**.


---

#  **Solution**

---
1. **Signup (Register)**

   * Store users in `QVector<User>`
2. **Login**

   * Validate from QVector using username
3. **Show / Hide Password**
4. **Icons inside input fields**
5. **Clear button**
6. **Full-screen window**
7. **Login card centered on screen**
8. **Welcome screen after login**

---

# 🧱 DATA MODEL (COMMON)

```cpp
struct User {
    QString username;
    QString password;
};
```

```cpp
extern QVector<User> users;
```

---

# 🧩 PART-1: SIGNUP WINDOW

---

## 🔹 UI DESIGN (Qt Designer)

### Widgets Required

| Widget      | Object Name     |
| ----------- | --------------- |
| QLineEdit   | signupUserEdit  |
| QLineEdit   | signupPassEdit  |
| QLineEdit   | confirmPassEdit |
| QPushButton | showPassBtn     |
| QPushButton | clearBtn        |
| QPushButton | registerBtn     |
| QPushButton | gotoLoginBtn    |
| QLabel      | statusLabel     |

---

## 🔹 UI PROPERTIES

### Password Fields

* `EchoMode → Password`

### Show / Hide Button

* `checkable = true`
* Icon: 👁️ / 🙈

---

## 🔹 ICONS INSIDE INPUT FIELDS

### In Constructor (signupwindow.cpp)

```cpp
ui->signupUserEdit->addAction(
    QIcon(":/icons/user.png"),
    QLineEdit::LeadingPosition
);

ui->signupPassEdit->addAction(
    QIcon(":/icons/lock.png"),
    QLineEdit::LeadingPosition
);
```

---

## 🔹 SHOW / HIDE PASSWORD

```cpp
void SignupWindow::on_showPassBtn_toggled(bool checked)
{
    ui->signupPassEdit->setEchoMode(
        checked ? QLineEdit::Normal : QLineEdit::Password
    );
    ui->confirmPassEdit->setEchoMode(
        checked ? QLineEdit::Normal : QLineEdit::Password
    );
}
```

---

## 🔹 CLEAR BUTTON

```cpp
void SignupWindow::on_clearBtn_clicked()
{
    ui->signupUserEdit->clear();
    ui->signupPassEdit->clear();
    ui->confirmPassEdit->clear();
    ui->statusLabel->clear();
}
```

---

## 🔹 REGISTER LOGIC (QVector)

```cpp
QVector<User> users;

void SignupWindow::on_registerBtn_clicked()
{
    QString user = ui->signupUserEdit->text();
    QString pass = ui->signupPassEdit->text();
    QString confirm = ui->confirmPassEdit->text();

    if(user.isEmpty() || pass.isEmpty())
    {
        ui->statusLabel->setText("All fields required");
        return;
    }

    if(pass != confirm)
    {
        ui->statusLabel->setText("Passwords do not match");
        return;
    }

    for(const User &u : users)
    {
        if(u.username == user)
        {
            ui->statusLabel->setText("User already exists");
            return;
        }
    }

    users.push_back({user, pass});

    ui->statusLabel->setStyleSheet("color:green");
    ui->statusLabel->setText("Signup successful");
}
```

---

# 🧩 PART-2: LOGIN WINDOW

---

## 🔹 LOGIN UI WIDGETS

| Widget      | Object Name   |
| ----------- | ------------- |
| QLineEdit   | loginUserEdit |
| QLineEdit   | loginPassEdit |
| QPushButton | showPassBtn   |
| QPushButton | clearBtn      |
| QPushButton | loginBtn      |
| QLabel      | statusLabel   |

---

## 🔹 ICONS INSIDE LOGIN INPUTS

```cpp
ui->loginUserEdit->addAction(
    QIcon(":/icons/user.png"),
    QLineEdit::LeadingPosition
);

ui->loginPassEdit->addAction(
    QIcon(":/icons/lock.png"),
    QLineEdit::LeadingPosition
);
```

---

## 🔹 SHOW / HIDE PASSWORD (LOGIN)

```cpp
void LoginWindow::on_showPassBtn_toggled(bool checked)
{
    ui->loginPassEdit->setEchoMode(
        checked ? QLineEdit::Normal : QLineEdit::Password
    );
}
```

---

## 🔹 CLEAR BUTTON (LOGIN)

```cpp
void LoginWindow::on_clearBtn_clicked()
{
    ui->loginUserEdit->clear();
    ui->loginPassEdit->clear();
    ui->statusLabel->clear();
}
```

---

## 🔹 LOGIN VALIDATION (QVector)

```cpp
void LoginWindow::on_loginBtn_clicked()
{
    QString user = ui->loginUserEdit->text();
    QString pass = ui->loginPassEdit->text();

    for(const User &u : users)
    {
        if(u.username == user && u.password == pass)
        {
            QMessageBox::information(this, "Login", "Welcome " + user);
            // open Employee Management window
            return;
        }
    }

    ui->statusLabel->setText("Invalid username or password");
}
```

---

# 🧩 PART-3: FULL-SCREEN & CENTERED LOGIN CARD

---

## 🔹 FULL-SCREEN WINDOW

```cpp
this->showFullScreen();
```

OR

```cpp
this->setWindowState(Qt::WindowMaximized);
```

---

##  CENTER LOGIN CARD (IMPORTANT)

### Use Layouts ONLY (No manual positioning)

```
Central Widget
 └── QVBoxLayout
      ├── Spacer
      ├── LoginCard (QWidget)
      ├── Spacer
```

✔ This automatically centers the login box.

---

##  OPTIONAL STYLING (Modern Look)

```css
QWidget#loginCard {
    background-color: white;
    border-radius: 12px;
}
```

---

#  INTERVIEW EXPLANATION (PERFECT ANSWER)

> “The login system includes signup and login using QVector for in-memory storage.
> Password visibility toggle, icons, clear functionality, and a centered full-screen UI improve usability.
> This avoids SQL and is suitable for lightweight desktop applications.”

---

## **Assignment 3: Data Handling and Table Display (Without SQL)**

### **Objective**

After successful login, read data and display it in a table format without using SQL.

### **Requirements**

1. Read data from a file (e.g., text file, CSV, or in-memory data).
2. Store data using C++ data structures (e.g., arrays, vectors, structs).
3. Perform SQL-like operations:

   * Insert data
   * Delete data
   * Update data
   * Search/filter records
4. Display data using a table view (Qt Table Widget or Model-View approach).
5. Allow sorting and basic filtering of data.

### **Constraints**

* Do **not** use any SQL database.
* Data handling should be done using core C++ logic.

### **Expected Outcome**

* Data is displayed in a tabular format.
* Application behaves like a database system without SQL.
* Clean and readable table UI.

---

## **Technologies to be Used**

* **Language:** C++
* **Framework:** Qt (Qt Widgets)
* **Concepts:**

  * OOP
  * File Handling
  * GUI Programming
  * Data Structures

---

## **Conclusion**

This assignment demonstrates:

* GUI development skills using Qt
* Strong understanding of C++ fundamentals
* Logical thinking and data handling without database dependency
* Clean UI design and user interaction

---

## **Solution**

---

## 🎯 OBJECTIVE

After successful login:

* Read employee data
* Store data **without SQL**
* Display data in table format
* Perform SQL-like operations:

  * Insert
  * Delete
  * Search
  * Sort
* Maintain employee count

---

# 🧱 ARCHITECTURE OVERVIEW

```
Login (CSV Excel)
     ↓
Employee Management Window
     ↓
In-Memory Data (QVector)
     ↓
QTableWidget (UI Table)
     ↓
Sorting / Search / Count
```

---

# 🧩 TECHNOLOGIES USED

| Area       | Technology             |
| ---------- | ---------------------- |
| Language   | C++                    |
| GUI        | Qt Widgets             |
| Data Store | class with QVector     |
| Table      | QTableWidget           |
| Sorting    | Qt built-in            |
| SQL        | ❌ Not Used             |

---

# 🧩 DATA MODEL

### Employee Structure

```cpp
class Employee {
public:
    int id;
    QString name;
    QString department;
    int salary;
};
```

---

# 🧩 UI DESIGN (STEP-BY-STEP)

## 🔹 MAIN WINDOW

* Widget: `QMainWindow`
* Title: **Employee Management System**
* Size: `900 x 600`
* Central Layout: **Vertical Layout**

---

## 🔹 SECTION-1: Employee Information

**QGroupBox – “Employee Information”**
Layout: `QGridLayout`

| Field      | Widget      | Object Name  |
| ---------- | ----------- | ------------ |
| ID         | QLineEdit   | `idEdit`     |
| Name       | QLineEdit   | `nameEdit`   |
| Department | QLineEdit   | `deptEdit`   |
| Salary     | QLineEdit   | `salaryEdit` |
| Add        | QPushButton | `addBtn`     |

---

## 🔹 SECTION-2: Search & Actions

Layout: `QHBoxLayout`

| Widget        | Object Name  |
| ------------- | ------------ |
| Search Name   | `searchEdit` |
| Search Button | `searchBtn`  |
| Delete Button | `deleteBtn`  |

---

## 🔹 SECTION-3: Employee Table

**QGroupBox – “Employee Data”**

### QTableWidget Settings

| Property               | Value                        |
| ---------------------- | ---------------------------- |
| `objectName`           | tableWidget                  |
| `columnCount`          | 4                            |
| Headers                | ID, Name, Department, Salary |
| `sortingEnabled`       | true                         |
| `selectionBehavior`    | SelectRows                   |
| `editTriggers`         | NoEditTriggers               |
| `alternatingRowColors` | true                         |

✔ Sorting enabled by clicking headers:

* Name
* Department
* Salary

---

## 🔹 FOOTER

* QLabel → `countLabel`
* Text: **Total Employees: 0**

---

# 🧠 LOGIC IMPLEMENTATION

---

## 🔹 mainwindow.h

```cpp
#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QMainWindow>
#include <QVector>

QT_BEGIN_NAMESPACE
namespace Ui { class MainWindow; }
QT_END_NAMESPACE

class Employee {
public:
    int id;
    QString name;
    QString department;
    int salary;
};

class MainWindow : public QMainWindow
{
    Q_OBJECT

public:
    MainWindow(QWidget *parent = nullptr);
    ~MainWindow();

private slots:
    void on_addBtn_clicked();
    void on_deleteBtn_clicked();
    void on_searchBtn_clicked();

private:
    Ui::MainWindow *ui;
    QVector<Employee> employees;

    void loadTable();
    void updateEmployeeCount();
};

#endif
```

---

## 🔹 mainwindow.cpp

### Constructor

```cpp
MainWindow::MainWindow(QWidget *parent)
    : QMainWindow(parent)
    , ui(new Ui::MainWindow)
{
    ui->setupUi(this);

    ui->tableWidget->setColumnCount(4);
    ui->tableWidget->setHorizontalHeaderLabels(
        {"ID", "Name", "Department", "Salary"}
    );

    updateEmployeeCount();
}
```

---

## 🔹 ADD EMPLOYEE (INSERT like SQL)

```cpp
void MainWindow::on_addBtn_clicked()
{
    Employee emp;

    emp.id = ui->idEdit->text().toInt();
    emp.name = ui->nameEdit->text();
    emp.department = ui->deptEdit->text();
    emp.salary = ui->salaryEdit->text().toInt();

    if(emp.name.isEmpty() || emp.department.isEmpty())
    {
        QMessageBox::warning(this, "Error", "Fields cannot be empty");
        return;
    }

    employees.push_back(emp);

    loadTable();
    updateEmployeeCount();
}
```

---

## 🔹 LOAD DATA INTO TABLE

```cpp
void MainWindow::loadTable()
{
    ui->tableWidget->setRowCount(employees.size());

    for(int i = 0; i < employees.size(); i++)
    {
        ui->tableWidget->setItem(i, 0,
            new QTableWidgetItem(QString::number(employees[i].id)));

        ui->tableWidget->setItem(i, 1,
            new QTableWidgetItem(employees[i].name));

        ui->tableWidget->setItem(i, 2,
            new QTableWidgetItem(employees[i].department));

        ui->tableWidget->setItem(i, 3,
            new QTableWidgetItem(QString::number(employees[i].salary)));
    }
}
```

---

## 🔹 DELETE EMPLOYEE (DELETE like SQL)

```cpp
void MainWindow::on_deleteBtn_clicked()
{
    int row = ui->tableWidget->currentRow();

    if(row < 0)
    {
        QMessageBox::warning(this, "Error", "Select a row to delete");
        return;
    }

    employees.remove(row);

    loadTable();
    updateEmployeeCount();
}
```

---

## 🔹 SEARCH EMPLOYEE (SELECT WHERE)

```cpp
void MainWindow::on_searchBtn_clicked()
{
    QString name = ui->searchEdit->text();

    for(int i = 0; i < employees.size(); i++)
    {
        if(employees[i].name == name)
        {
            ui->tableWidget->selectRow(i);
            return;
        }
    }

    QMessageBox::information(this, "Result", "Employee not found");
}
```

---

## 🔹 EMPLOYEE COUNT

```cpp
void MainWindow::updateEmployeeCount()
{
    ui->countLabel->setText(
        "Total Employees: " + QString::number(employees.size())
    );
}
```

---

# 🔄 SORTING FEATURE (UPDATED)

### Enabled via UI (No extra code)

* `QTableWidget → sortingEnabled = true`
* Click column headers:

  * Name → A–Z / Z–A
  * Department → A–Z / Z–A
  * Salary → Low–High / High–Low

---

# 📊 SQL VS THIS SYSTEM

| SQL          | This App       |
| ------------ | -------------- |
| INSERT       | Add Button     |
| DELETE       | Delete Button  |
| SELECT WHERE | Search         |
| ORDER BY     | Header Sorting |
| COUNT(*)     | Employee Count |

---






