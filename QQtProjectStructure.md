Excellent. Now we begin one of the most important foundational chapters.

Understanding the **Qt Project Structure** is essential because every Qt application—whether it's a small calculator or a large enterprise application like a **Medical Treatment Planning System (TPS)**, **CAD software**, or an **Automotive HMI**—follows this structure.

> **Senior Developer Note**
>
> One of the easiest ways to identify an experienced Qt developer is by looking at how they organize a project. A clean project structure improves maintainability, scalability, build times, and team collaboration.

---

# Complete Qt Master Course (Qt 5.15 LTS → Qt 6.11)

# PART I — Qt Fundamentals

# Chapter 4 — Qt Project Structure

> **Level:** Beginner → Intermediate → Advanced → Expert

---

# Chapter Objectives

By the end of this chapter, you will understand:

* What files make up a Qt project
* The purpose of each file type
* How Qt build tools (`moc`, `uic`, `rcc`) work together
* The difference between source files and generated files
* How CMake and qmake organize projects
* Build directory structure
* Recommended enterprise folder structures
* Common mistakes and best practices

---

# Table of Contents

1. Introduction
2. Anatomy of a Qt Project
3. Source Files (`.cpp`)
4. Header Files (`.h`)
5. UI Files (`.ui`)
6. Resource Files (`.qrc`)
7. Translation Files (`.ts`, `.qm`)
8. `moc` (Meta-Object Compiler)
9. `uic` (User Interface Compiler)
10. `rcc` (Resource Compiler)
11. Build Folder
12. CMake Project Structure
13. qmake Project Structure
14. Enterprise Folder Organization
15. Generated Files
16. Build Flow
17. Qt 5.15 vs Qt 6.11
18. Best Practices
19. Common Mistakes
20. Interview Questions
21. Revision Notes

---

# 1. Introduction

A Qt project is more than a collection of `.cpp` files.

It typically contains:

```text
Project

│

├── Source Files

├── Header Files

├── UI Files

├── Resource Files

├── Translation Files

├── Build Files

├── Generated Files

└── Assets
```

Each type of file has a specific purpose.

---

# 2. Anatomy of a Qt Project

A simple Qt Widgets application might look like this:

```text
Calculator/

│

├── CMakeLists.txt

├── main.cpp

├── mainwindow.h

├── mainwindow.cpp

├── mainwindow.ui

├── resources.qrc

├── icons/

│   ├── add.png

│   └── sub.png

├── translations/

│   └── calculator_en.ts

└── build/
```

---

# Project Relationship Diagram

```text
                Project

                   │

--------------------------------------------------

Source Files

Header Files

UI Files

Resource Files

Translation Files

Build Files
```

---

# 3. Source Files (`.cpp`)

## Definition

`.cpp` files contain the implementation of your classes and functions.

Example:

```cpp
#include "mainwindow.h"

MainWindow::MainWindow(QWidget *parent)
    : QMainWindow(parent)
{
}
```

---

## Responsibilities

* Function definitions
* Business logic
* Event handling
* Algorithms
* UI interaction
* Database operations
* Networking
* Rendering

---

## Typical Project

```text
src/

main.cpp

mainwindow.cpp

login.cpp

database.cpp

network.cpp
```

---

# 4. Header Files (`.h`)

Headers define the interface of a class.

Example:

```cpp
class MainWindow : public QMainWindow
{
    Q_OBJECT

public:
    MainWindow(QWidget *parent = nullptr);

private:
    Ui::MainWindow *ui;
};
```

---

## Responsibilities

* Class declarations
* Function declarations
* Member variables
* Enumerations
* Templates
* Constants

---

# Header Dependency

```text
mainwindow.cpp

↓

#include "mainwindow.h"

↓

Compiler knows class definition
```

---

# 5. UI Files (`.ui`)

A `.ui` file is an XML document created by Qt Designer.

Example:

```text
mainwindow.ui
```

Internally:

```xml
<ui version="4.0">
    ...
</ui>
```

---

## Purpose

Describe the widget hierarchy.

Instead of writing:

```cpp
QPushButton *button =
    new QPushButton(this);
```

You drag a button onto the form in Designer.

---

## Workflow

```text
Qt Designer

↓

mainwindow.ui

↓

uic

↓

ui_mainwindow.h

↓

Compiler
```

We'll explore `uic` in detail later.

---

# 6. Resource Files (`.qrc`)

Qt embeds application resources into the executable.

Example:

```xml
<RCC>
    <qresource prefix="/">
        <file>icons/open.png</file>
        <file>icons/save.png</file>
    </qresource>
</RCC>
```

---

## Advantages

* No need to ship separate image files (unless desired).
* Resources are platform-independent.
* Simplifies deployment.

---

## Usage

```cpp
QIcon icon(":/icons/open.png");
```

The `:/` prefix indicates a Qt resource.

---

# Resource Flow

```text
Image

↓

resources.qrc

↓

rcc

↓

Compiled Resource

↓

Executable
```

---

# 7. Translation Files (`.ts`, `.qm`)

Qt supports internationalization.

### `.ts`

Human-readable XML translation source.

Example:

```text
app_en.ts
```

---

### `.qm`

Compiled binary translation file.

Generated from `.ts`.

Used at runtime.

---

Workflow:

```text
Source Code

↓

lupdate

↓

.ts

↓

Qt Linguist

↓

lrelease

↓

.qm

↓

Application
```

---

# 8. Meta-Object Compiler (`moc`)

One of Qt's most important tools.

Input:

```cpp
class MyClass : public QObject
{
    Q_OBJECT
};
```

Output:

```text
moc_MyClass.cpp
```

`moc` generates code for:

* Signals
* Slots
* Runtime type information
* Properties
* Meta-object data

---

## Workflow

```text
Header

↓

Q_OBJECT

↓

moc

↓

Generated C++

↓

Compiler
```

We'll dedicate **Chapter 12** to MOC internals.

---

# 9. User Interface Compiler (`uic`)

Input:

```text
mainwindow.ui
```

Output:

```text
ui_mainwindow.h
```

Generated code creates the widget hierarchy described in the `.ui` file.

Conceptually:

```text
UI XML

↓

uic

↓

C++ Header

↓

Compiler
```

---

# 10. Resource Compiler (`rcc`)

Input:

```text
resources.qrc
```

Output:

Compiled C++ resource data.

This allows:

```cpp
QPixmap(":/images/logo.png");
```

without requiring the image to exist as a separate file at runtime.

---

# 11. Build Folder

Modern Qt projects use **out-of-source builds**.

Example:

```text
Project/

│

├── src/

├── CMakeLists.txt

└── build/
```

Build directory contains:

```text
build/

│

├── CMakeCache.txt

├── CMakeFiles/

├── Makefile (or Ninja files)

├── moc_*.cpp

├── ui_*.h

├── *.obj / *.o

├── executable

└── libraries
```

Never place generated files in your source tree.

---

# Why Out-of-Source Builds?

Advantages:

* Clean repository.
* Easy cleanup.
* Multiple build configurations.

Example:

```text
Project/

build-debug/

build-release/

build-clang/

build-msvc/
```

Each build directory is independent.

---

# 12. CMake Project Structure

Typical structure:

```text
MyProject/

│

├── CMakeLists.txt

├── src/

├── include/

├── resources/

├── translations/

├── tests/

└── docs/
```

Example:

```cmake
cmake_minimum_required(VERSION 3.21)

project(MyApp)

find_package(Qt6 REQUIRED COMPONENTS
    Core
    Gui
    Widgets)

add_executable(MyApp
    src/main.cpp
    src/mainwindow.cpp
)

target_link_libraries(MyApp PRIVATE
    Qt6::Core
    Qt6::Gui
    Qt6::Widgets)
```

---

# 13. qmake Project Structure

Legacy Qt projects often use:

```text
MyProject/

│

├── MyProject.pro

├── src/

├── include/

├── forms/

└── resources/
```

Example:

```pro
QT += core gui widgets

SOURCES += \
    src/main.cpp \
    src/mainwindow.cpp

HEADERS += \
    include/mainwindow.h

FORMS += \
    forms/mainwindow.ui

RESOURCES += \
    resources/resources.qrc
```

---

# 14. Enterprise Folder Structure

For medium and large applications, separate code by responsibility.

```text
MyApplication/

│

├── CMakeLists.txt

├── src/

├── include/

├── ui/

├── resources/

├── translations/

├── tests/

├── docs/

├── third_party/

├── scripts/

├── cmake/

├── plugins/

└── build/
```

For very large systems, use modules:

```text
MedicalTPS/

│

├── Core/

├── GUI/

├── DoseEngine/

├── DICOM/

├── Database/

├── Networking/

├── Planning/

├── Reports/

└── Tests/
```

We'll revisit enterprise architecture in **Chapter 131**.

---

# 15. Generated Files

Generated files should **never be edited manually**.

Examples:

```text
moc_MainWindow.cpp

ui_MainWindow.h

qrc_resources.cpp
```

They are recreated whenever the build system runs the appropriate tools.

---

# 16. Build Flow

The complete build process looks like this:

```text
Source Files
Headers
UI Files
Resource Files

        │

        ▼

CMake / qmake

        │

        ▼

moc
uic
rcc

        │

        ▼

Generated C++ Files

        │

        ▼

Compiler

        │

        ▼

Object Files

        │

        ▼

Linker

        │

        ▼

Executable
```

This pipeline is one of the most important concepts in Qt.

---

# 17. Qt 5.15 vs Qt 6.11

| Topic                       | Qt 5.15   | Qt 6.11              |
| --------------------------- | --------- | -------------------- |
| Project Structure           | ✔         | ✔                    |
| `.cpp`, `.h`, `.ui`, `.qrc` | ✔         | ✔                    |
| `moc`, `uic`, `rcc`         | ✔         | ✔                    |
| qmake                       | Primary   | Legacy support       |
| CMake                       | Supported | Primary build system |

There is **no fundamental difference** in the purpose of project files between Qt 5.15 and Qt 6.11.

The biggest change is that **CMake has become the recommended build system** for Qt 6.

---

# 18. Best Practices

* Use out-of-source builds.
* Keep generated files out of version control.
* Organize code into logical folders.
* Separate headers and source files.
* Use descriptive resource prefixes.
* Store UI files in a dedicated `ui/` directory.
* Place translations in a `translations/` directory.
* Prefer CMake for new projects.

---

# 19. Common Mistakes

* Editing generated files (`ui_*.h`, `moc_*.cpp`).
* Placing build artifacts inside the source directory.
* Mixing source code with generated files.
* Using absolute file paths instead of resources.
* Committing build directories to Git.

---

# 20. Interview Questions

## Easy

1. What is a `.ui` file?
2. What is a `.qrc` file?
3. What does `moc` do?

## Medium

1. Explain the difference between `uic` and `moc`.
2. Why should generated files not be edited?
3. Why are out-of-source builds recommended?

## Hard

1. Describe the complete Qt build pipeline.
2. Explain how `rcc` embeds resources into an executable.
3. Compare CMake and qmake project organization.

## Expert

1. Design a scalable folder structure for a 500,000-line Qt application.
2. Explain how Qt build tools cooperate during compilation.
3. Describe how you would organize a multi-module medical TPS project using CMake.

---

# 21. Revision Notes

* A Qt project consists of source, headers, UI, resources, translations, and build files.
* `.ui` files are XML descriptions of widget layouts.
* `.qrc` files embed application resources.
* `moc`, `uic`, and `rcc` generate C++ code during the build.
* Use out-of-source builds to keep repositories clean.
* Prefer CMake for new projects.
* Never edit generated files manually.

---

# Next Chapter

## **Chapter 5 — First Qt Application**

