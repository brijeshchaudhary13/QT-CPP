# Chapter 2 — Installing Qt

> **Course Level:** Beginner → Intermediate → Advanced → Expert

---

# Chapter Overview

In this chapter, you will learn:

* What is included in the Qt SDK
* Online Installer
* Offline Installation
* Choosing the correct Qt version
* Selecting Kits
* Installing Qt Creator
* Installing MinGW, MSVC and Clang
* SDK Folder Structure
* Environment Variables
* Verifying Installation
* Common Installation Errors
* Qt 5.15 vs Qt 6.11 Installation Differences
* Best Practices for Enterprise Development

---

# Table of Contents

1. Introduction
2. What is the Qt SDK?
3. System Requirements
4. Downloading Qt
5. Online Installer
6. Offline Installation
7. Choosing Qt Version
8. Choosing Compiler (Kit)
9. Installing Qt Creator
10. SDK Folder Structure
11. Qt Installation Components
12. Environment Variables
13. Verify Installation
14. Common Installation Problems
15. Qt 5.15 vs Qt 6.11
16. Best Practices
17. Interview Questions
18. Revision Notes

---

# 1. Introduction

Before writing a Qt application, we need a complete development environment.

A Qt installation is much more than a compiler.

It includes:

```text
Qt SDK

│

├── Qt Libraries

├── Qt Creator IDE

├── Build Tools

├── Documentation

├── Examples

├── Designer

├── Assistant

├── Linguist

├── CMake

├── qmake

├── Debugging Tools

└── Platform Plugins
```

Think of the SDK as a complete toolbox.

---

# 2. What is the Qt SDK?

SDK stands for

> Software Development Kit

It contains everything required to develop Qt applications.

A typical SDK contains:

* Qt Framework
* Qt Creator
* Qt Designer
* Documentation
* Examples
* Translation Tools
* Build Tools
* Debugging Tools
* Platform Plugins

---

# SDK Architecture

```text
                 Qt SDK

                     │

     ------------------------------------

     Qt Libraries

     Qt Creator

     Designer

     Assistant

     Linguist

     Build Tools

     Examples

     Documentation

     Compilers

     Debuggers
```

---

# 3. System Requirements

## Windows

Recommended:

* Windows 10/11 (64-bit)
* 8 GB RAM minimum (16 GB recommended)
* SSD storage
* Visual Studio 2022 or MinGW
* CMake

---

## Linux

Recommended:

* Ubuntu 22.04+
* Fedora
* Debian
* openSUSE

Compiler:

```text
GCC

or

Clang
```

---

## macOS

Recommended:

* Recent macOS version supported by your chosen Qt release
* Xcode Command Line Tools
* Apple Clang

---

# Hardware Recommendation

For enterprise development:

| Component | Recommended                                      |
| --------- | ------------------------------------------------ |
| CPU       | Intel i7 / Ryzen 7 or better                     |
| RAM       | 16–32 GB                                         |
| SSD       | 512 GB+                                          |
| Monitor   | Dual monitors recommended                        |
| GPU       | Optional unless using graphics-intensive modules |

---

# 4. Downloading Qt

Qt provides two installation methods.

## Online Installer

Downloads selected packages during installation.

Advantages:

* Latest versions
* Smaller initial download
* Easy updates

Disadvantages:

* Requires internet
* Longer installation if many components are selected

---

## Offline Installer

Contains pre-packaged components.

Advantages:

* No internet required after download
* Faster installation in isolated environments
* Useful for enterprise networks

Disadvantages:

* Large download size
* Must download a new installer for updates

---

# Which Should You Choose?

| Scenario              | Recommended       |
| --------------------- | ----------------- |
| Personal learning     | Online Installer  |
| Office network        | Online or Offline |
| Air-gapped systems    | Offline Installer |
| Enterprise deployment | Often Offline     |

---

# 5. Installing Using the Online Installer

Typical workflow:

```text
Download Installer

↓

Run Installer

↓

Login (if required)

↓

Choose Installation Folder

↓

Select Components

↓

Install

↓

Launch Qt Creator
```

---

# Installation Screens

Typical sequence:

```text
Welcome

↓

License Agreement

↓

Login

↓

Installation Folder

↓

Component Selection

↓

Install

↓

Finish
```

---

# Installation Directory

Typical Windows location:

```text
C:\Qt
```

Typical Linux:

```text
~/Qt
```

or

```text
/opt/Qt
```

Typical macOS:

```text
~/Qt
```

or another user-selected location.

---

# 6. Component Selection

This is one of the most important installation steps.

Typical components include:

```text
Qt 5.15

Qt 6.8

Qt 6.9

Qt 6.10

Qt 6.11

Qt Creator

Examples

Documentation

Sources

Designer

Linguist
```

---

# Which Qt Versions Should You Install?

For this course, I recommend:

```text
Qt 5.15 LTS

+

Latest Qt 6.x (preferably Qt 6.11 when available)
```

Why?

Qt 5.15 is still widely used in enterprise applications.

Qt 6.x is the future of Qt development.

---

# Should You Install Sources?

Yes.

```text
Qt Source Code

✔ Install
```

Why?

Later in this course we will study:

* Qt internals
* MOC implementation
* QObject implementation
* Signal-slot implementation
* Event loop internals
* Source code reading

---

# Install Examples?

Yes.

Examples are invaluable for learning.

---

# Install Documentation?

Definitely.

Offline documentation is useful when internet access is unavailable.

---

# 7. Choosing a Compiler (Kit)

A **Kit** in Qt Creator is a combination of:

* Qt version
* Compiler
* Debugger
* CMake/qmake
* Device

Think of it as a complete build configuration.

---

# Kit Architecture

```text
Kit

│

├── Qt Version

├── Compiler

├── Debugger

├── CMake

├── Device

└── Environment
```

---

# Windows Compiler Options

## MinGW

Advantages:

* Free
* Easy setup
* Good for learning

Disadvantages:

* Different ABI from MSVC
* Not ideal if your project depends on MSVC-built libraries

---

## MSVC

Advantages:

* Microsoft compiler
* Excellent debugger
* Common choice in enterprise Windows development

Recommended for professional Windows applications.

---

## Clang

Less common on Windows but supported.

Useful for static analysis and cross-platform consistency.

---

# Linux

Usually:

```text
GCC

or

Clang
```

---

# macOS

Usually:

```text
Apple Clang
```

---

# Recommended Kits

| Platform             | Recommended |
| -------------------- | ----------- |
| Windows (Learning)   | MinGW       |
| Windows (Enterprise) | MSVC        |
| Linux                | GCC         |
| macOS                | Apple Clang |

---

# 8. Installing Qt Creator

Qt Creator is Qt's official IDE.

Features:

* Code Editor
* Project Manager
* Debugger
* Profiler
* Designer Integration
* CMake Support
* Git Integration
* Static Analysis

We'll explore it in detail in Chapter 3.

---

# 9. SDK Folder Structure

Typical structure:

```text
C:\Qt

│

├── 5.15.2

├── 6.11.0

├── Docs

├── Examples

├── MaintenanceTool.exe

├── Qt Creator

├── Tools
```

---

# Qt Version Folder

Example:

```text
6.11.0

│

├── bin

├── include

├── lib

├── plugins

├── qml

├── translations

├── examples

├── mkspecs
```

---

# Important Directories

## bin

Contains executable tools.

Examples:

```text
qmake

moc

uic

rcc

designer

assistant

linguist
```

---

## include

Header files.

Example:

```text
QObject

QString

QWidget
```

---

## lib

Libraries.

Examples:

```text
Qt6Core

Qt6Gui

Qt6Widgets
```

---

## plugins

Platform plugins.

Example:

```text
platforms

imageformats

styles

sqldrivers
```

---

## qml

QML modules.

---

## translations

Localization files.

---

# 10. Build Tools

Qt installation includes:

| Tool  | Purpose                 |
| ----- | ----------------------- |
| moc   | Meta Object Compiler    |
| uic   | User Interface Compiler |
| rcc   | Resource Compiler       |
| qmake | Legacy Build Tool       |
| CMake | Modern Build System     |

Each will be covered in dedicated chapters.

---

# 11. Environment Variables

Usually Qt Creator configures these automatically.

Common variables include:

```text
PATH

QTDIR

CMAKE_PREFIX_PATH
```

When building from the command line, correctly setting these variables helps the compiler locate Qt tools and libraries.

---

# 12. Verifying Installation

Open Qt Creator.

Create:

```text
Qt Widgets Application
```

Build.

Run.

If you see a simple window, the installation is working.

---

# Command-Line Verification

Examples:

```bash
qmake --version
```

or

```bash
cmake --version
```

You can also verify the compiler:

```bash
g++ --version
```

or

```bash
cl
```

(on Windows with the MSVC developer environment configured).

---

# 13. Common Installation Problems

## No Kit Found

Symptoms:

```text
No suitable kits found.
```

Cause:

Compiler or Qt version not configured.

Solution:

Open:

```text
Tools

↓

Options

↓

Kits
```

Verify:

* Compiler
* Qt Version
* Kit

---

## Missing Compiler

Symptoms:

```text
Compiler not found.
```

Solution:

Install:

* MinGW
* MSVC
* GCC
* Clang

depending on your platform.

---

## CMake Cannot Find Qt

Typical error:

```text
Could NOT find Qt6
```

Common causes:

* Incorrect `CMAKE_PREFIX_PATH`
* Qt not installed
* Wrong Kit selected

---

## Platform Plugin Error

One of the most famous Qt errors:

```text
Could not load the Qt platform plugin "xcb"
```

or

```text
Could not load the Qt platform plugin "windows"
```

Possible causes:

* Missing plugin
* Incorrect deployment
* Environment configuration issues

We'll cover deployment and plugin troubleshooting in Chapters 104 and 116.

---

# 14. Qt 5.15 vs Qt 6.11

| Feature          | Qt 5.15         | Qt 6.11                    |
| ---------------- | --------------- | -------------------------- |
| qmake            | Fully supported | Still available but legacy |
| CMake            | Supported       | Primary build system       |
| Qt Creator       | ✔               | ✔                          |
| Online Installer | ✔               | ✔                          |
| Maintenance Tool | ✔               | ✔                          |
| MSVC Support     | ✔               | ✔                          |
| MinGW Support    | ✔               | ✔                          |

### Migration Recommendation

For new projects:

* Prefer **Qt 6 + CMake**.

For maintaining existing enterprise software:

* Continue supporting **Qt 5.15** where required while planning migration.

---

# 15. Best Practices

* Install both Qt 5.15 LTS and Qt 6.x.
* Install source code, documentation, and examples.
* Use MSVC for enterprise Windows projects.
* Use GCC or Clang on Linux.
* Use CMake for new projects.
* Keep Qt versions in a common installation directory.
* Regularly update Kits after installing new compilers or Qt versions.

---

# 16. Interview Questions

## Easy

1. What is the Qt SDK?
2. What is a Kit?
3. What is Qt Creator?

## Medium

1. Compare MinGW and MSVC.
2. Explain the purpose of the `bin`, `include`, and `lib` directories.
3. Why should you install Qt source code?

## Hard

1. Explain how a Kit is constructed in Qt Creator.
2. Describe how Qt Creator finds the compiler and Qt libraries.
3. How would you troubleshoot a "No suitable kits found" error?

## Expert

1. Design a development environment for a team maintaining both Qt 5.15 and Qt 6.11 applications.
2. Explain how CMake locates Qt installations.
3. Describe how you would standardize Qt installations across an enterprise development team.

---

# 17. Revision Notes

* The Qt SDK includes libraries, tools, documentation, and examples.
* A **Kit** combines the Qt version, compiler, debugger, build system, and target device.
* Install both Qt 5.15 LTS and Qt 6.x if you work with legacy and modern projects.
* Prefer CMake for new applications.
* Install Qt source code for debugging and learning framework internals.
* Verify your installation by creating and running a simple Qt Widgets application.

---

# What's Next?

## Chapter 3 — Qt Creator IDE

