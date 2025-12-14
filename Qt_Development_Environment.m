
## **1. What is Qt Creator?**

### **Definition**

Qt Creator is a **cross-platform Integrated Development Environment (IDE)** designed specifically for developing applications using the **Qt framework and C++**.

It provides:

* Code editor
* UI designer
* Debugger
* Build & run tools
* Project management

All in **one tool**.

---

### **Why Qt Creator is needed**

Without Qt Creator:

* You would manually manage compiler, linker, UI files, and builds.
* Debugging Qt apps would be complex.
* UI design would require writing large amounts of code.

Qt Creator:

* Simplifies **Qt-specific workflows**
* Integrates **Designer, Debugger, and Build system**
* Improves productivity and code quality

---

### **How Qt Creator works**

Qt Creator:

1. Uses **Qt libraries** and **toolchains**
2. Generates build files (qmake/CMake)
3. Invokes compiler (GCC, MSVC, Clang)
4. Launches debugger (GDB/LLDB)
5. Deploys and runs application

---

### **Example**

Instead of manually running:

```bash
g++ main.cpp -lQt5Widgets
```

Qt Creator:

* Builds
* Links
* Runs
* Debugs
  with **one click**

---

## **2. Installing Qt and Qt Creator**

### **Definition**

Qt is installed using the **Qt Online Installer**, which installs:

* Qt libraries
* Qt Creator IDE
* Compilers & tools (optional)

---

### **Why installation matters**

* Correct installation ensures:

  * Compatible compiler
  * Correct Qt version
  * Proper debugging support

Wrong setup → build failures.

---

### **How to install**

1. Download installer from Qt official site
2. Choose:

   * Qt version (e.g., Qt 6.x)
   * Compiler (MinGW / MSVC / GCC)
   * Qt Creator
3. Set installation path
4. Complete installation

---

### **Example (Windows)**

* Qt 6.x
* MinGW compiler
* Desktop Qt

Result:

```text
Qt Creator + Qt Libraries + Compiler
```

---

## **3. Qt Creator Interface Overview**

### **Definition**

Qt Creator UI is divided into **modes**, each focused on a development task.

---

### **Why modes exist**

* Separation of concerns
* Cleaner workflow
* Faster navigation

---

### **Main Modes**

1. Welcome Mode
2. Edit Mode
3. Design Mode
4. Debug Mode
5. Projects Mode

---

## **4. Welcome Mode**

### **Definition**

Welcome Mode is the **starting screen** of Qt Creator.

---

### **Why it exists**

* Quick access to:

  * Recent projects
  * Examples
  * Documentation
  * Tutorials

---

### **How it is used**

* Open recent project
* Create new project
* Learn Qt via examples

---

### **Example**

Click:

```
Examples → Widgets → Calculator
```

👉 Opens a ready-made Qt project

---

## **5. Edit Mode**

### **Definition**

Edit Mode is where you **write and edit C++ code**.

---

### **Why Edit Mode is important**

* Smart code completion
* Syntax highlighting
* Error detection
* Refactoring tools

---

### **How it works**

* Parses Qt headers
* Uses Clang-based code model
* Understands Qt macros (Q_OBJECT)

---

### **Example**

```cpp
void MainWindow::onButtonClicked()
{
    ui->label->setText("Clicked");
}
```

Qt Creator:

* Auto-completes functions
* Shows compile errors inline

---

## **6. Design Mode**

### **Definition**

Design Mode provides a **visual UI designer** using `.ui` files.

---

### **Why Design Mode is useful**

* No need to write UI code manually
* Faster UI creation
* Easy layout management

---

### **How it works**

* Drag & drop widgets
* Designer generates `.ui` XML file
* Converted to C++ at build time

---

### **Example**

Drag:

* QPushButton
* QLabel

Qt auto-generates:

```cpp
ui->setupUi(this);
```

---

## **7. Debug Mode**

### **Definition**

Debug Mode is used to **find and fix runtime errors**.

---

### **Why debugging is critical**

* Find crashes
* Fix logic errors
* Analyze runtime behavior

---

### **How Debug Mode works**

* Uses GDB / LLDB
* Pauses execution
* Inspects variables and memory

---

### **Example**

Set breakpoint:

```cpp
button->setText("Test");
```

Run in Debug:

* Execution stops
* View variable values
* Step through code

---

## **8. Projects Mode**

### **Definition**

Projects Mode manages **build, run, and deployment settings**.

---

### **Why Projects Mode matters**

* Different platforms need different builds
* Debug vs Release configuration
* Device selection

---

### **How it works**

* Select Kit
* Configure build steps
* Configure run steps

---

### **Example**

* Build: Debug
* Run: Desktop Qt 6.5 MinGW

---

## **9. Creating Your First Qt Project**

### **Definition**

Qt Creator can generate a **ready-to-run project structure**.

---

### **Why this helps**

* Correct project setup
* No manual configuration
* Follows Qt best practices

---

### **How to create**

1. File → New Project
2. Qt Widgets Application
3. Choose project name
4. Select Kit
5. Finish

---

### **Generated Files**

```text
main.cpp
mainwindow.h
mainwindow.cpp
mainwindow.ui
.pro / CMakeLists.txt
```

---

### **Example (main.cpp)**

```cpp
#include <QApplication>
#include "mainwindow.h"

int main(int argc, char *argv[])
{
    QApplication a(argc, argv);
    MainWindow w;
    w.show();
    return a.exec();
}
```

---

## **10. Understanding Qt Kits**

### **Definition**

A Qt Kit defines **how your application is built and run**.

---

### **Why Kits are required**

Different platforms need:

* Different compilers
* Different Qt builds

---

### **What a Kit contains**

* Compiler
* Qt version
* Debugger
* Device type

---

### **Example**

| Kit                | Platform |
| ------------------ | -------- |
| Desktop Qt 6 MinGW | Windows  |
| Desktop Qt 6 GCC   | Linux    |
| Android Qt         | Mobile   |

---

## **11. Build Systems in Qt (qmake, CMake)**

### **qmake**

#### Definition

qmake uses `.pro` files to build Qt projects.

#### Example

```pro
QT += widgets
SOURCES += main.cpp mainwindow.cpp
HEADERS += mainwindow.h
```

---

### **CMake**

#### Definition

CMake is a modern, industry-standard build system.

#### Example

```cmake
find_package(Qt6 REQUIRED COMPONENTS Widgets)

add_executable(app main.cpp)
target_link_libraries(app Qt6::Widgets)
```

---

### **Why CMake is preferred now**

* Cross-platform
* Industry adoption
* Better tooling

---

## **12. Debugging Setup in Qt Creator**

### **Definition**

Debugging setup connects:

* Compiler
* Debugger
* Qt symbols

---

### **Why setup is important**

* Without symbols → no variable info
* Incorrect debugger → crash without details

---

### **How to verify**

* Projects → Build → Debug
* Check debugger path
* Ensure Debug build

---

## **13. Running Qt Applications**

### **Definition**

Running executes the built application using selected Kit.

---

### **Why this step matters**

* Tests application behavior
* Validates build environment

---

### **How it runs**

1. Build project
2. Deploy (if needed)
3. Execute binary

---

### **Example**

Click ▶ **Run**

* App window appears
* Event loop starts

---

