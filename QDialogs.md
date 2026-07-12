Excellent. **Chapter 39 is one of the most practical chapters in Qt.**

Almost every Qt desktop application uses dialogs dozens or even hundreds of times.

Examples:

* Login dialog
* Settings dialog
* Patient information dialog
* Beam properties dialog
* Dose calculation dialog
* About dialog
* File open/save dialog
* Color picker
* Font selector
* Warning dialogs
* Confirmation dialogs

A professional application such as a **Treatment Planning System (TPS)** may contain **100+ custom dialogs**.

Understanding `QDialog` is therefore essential.

---

# Complete Qt Master Course (Qt 5.15 LTS → Qt 6.11)

# PART V — GUI Programming

# Chapter 39 — Dialogs (Complete Deep Dive)

## Part 1 — QDialog Architecture, Lifecycle, Modal & Modeless Dialogs, Accept/Reject & Dialog Results

> **Level:** Beginner → Expert

---

# Chapter Objectives

After completing this chapter, you will understand:

* What is `QDialog`
* Dialog architecture
* Dialog lifecycle
* Modal dialogs
* Modeless dialogs
* `accept()`
* `reject()`
* `done()`
* Dialog results
* Qt 5 vs Qt 6

---

# Table of Contents

1. What is QDialog?
2. Dialog Architecture
3. Dialog Lifecycle
4. Modal Dialogs
5. Modeless Dialogs
6. Dialog Results
7. accept(), reject(), done()
8. Dialog Buttons
9. Qt 5 vs Qt 6
10. Best Practices
11. Interview Questions
12. Revision Notes

---

# 1. What is QDialog?

`QDialog` is the base class for dialog windows in Qt.

Inheritance:

```text
QObject
      │
QPaintDevice
      │
QWidget
      │
QDialog
```

Examples:

```text
Login Dialog

Settings Dialog

About Dialog

Patient Information

Beam Properties

Dose Calculation

Import DICOM
```

A dialog is usually a temporary window that asks the user for information or displays information.

---

# Header

```cpp
#include <QDialog>
```

Module:

```text
QtWidgets
```

---

# 2. Dialog Architecture

Typical application:

```text
Main Window
      │
      ▼
 Open Dialog
      │
      ▼
 User Interaction
      │
      ▼
 Dialog Closed
      │
      ▼
 Return To Main Window
```

Dialogs are usually owned by another window.

Example:

```cpp
SettingsDialog dialog(this);
```

The parent:

```text
MainWindow

↓

SettingsDialog
```

Benefits:

* Centered relative to parent
* Ownership
* Correct stacking
* Proper lifetime management

---

# 3. Dialog Lifecycle

Every dialog follows roughly this lifecycle:

```text
Constructor

↓

Initialize Widgets

↓

show()/open()/exec()

↓

Visible

↓

User Interaction

↓

accept()/reject()

↓

Close

↓

Destructor
```

---

Example:

```cpp
SettingsDialog dialog(this);

dialog.exec();
```

Execution:

```text
Constructor

↓

Show Dialog

↓

Event Loop

↓

Accept

↓

Close

↓

Destructor
```

---

# 4. Modal Dialogs

Modal dialogs block user interaction.

Example:

```cpp
dialog.exec();
```

Behavior:

```text
Main Window

↓

Disabled

↓

Dialog

↓

User Must Finish

↓

Dialog Closes

↓

Main Window Active
```

Typical examples:

* Save changes
* Delete confirmation
* Password dialog
* Import patient
* Machine calibration

---

# 5. Modeless Dialogs

Modeless dialogs allow continued interaction.

Example:

```cpp
dialog.show();
```

Behavior:

```text
Main Window

↓

Still Active

↓

Dialog

↓

Still Active
```

Typical examples:

* Search panel
* Toolbox
* Color palette
* Layer manager
* Patient browser

---

# 6. Dialog Results

Every dialog returns a result.

Qt provides:

```text
Accepted

Rejected
```

Values:

```cpp
QDialog::Accepted

QDialog::Rejected
```

Example:

```cpp
int result = dialog.exec();
```

---

Check:

```cpp
if(result == QDialog::Accepted)
{
    saveData();
}
```

---

Flow:

```text
Dialog

↓

OK

↓

Accepted

↓

Return

-------------

Dialog

↓

Cancel

↓

Rejected

↓

Return
```

---

# 7. accept(), reject(), done()

## accept()

```cpp
accept();
```

Behavior:

```text
Dialog

↓

Close

↓

Accepted
```

Equivalent result:

```cpp
QDialog::Accepted
```

---

## reject()

```cpp
reject();
```

Behavior:

```text
Dialog

↓

Close

↓

Rejected
```

---

## done()

Allows any integer result.

Example:

```cpp
done(10);
```

Result:

```text
Dialog Result

↓

10
```

Useful when an application needs more than two possible outcomes.

---

# Example

```cpp
switch(dialog.exec())
{
case QDialog::Accepted:
    break;

case QDialog::Rejected:
    break;
}
```

---

# 8. Dialog Buttons

Most dialogs contain:

```text
OK

Cancel
```

or

```text
Yes

No

Cancel
```

or

```text
Apply

OK

Cancel
```

Typical flow:

```text
User

↓

Press OK

↓

accept()

↓

Close
```

---

Cancel:

```text
User

↓

Cancel

↓

reject()

↓

Close
```

---

# Close Button

User presses:

```text
[X]
```

Qt usually calls:

```cpp
reject();
```

unless custom behavior is implemented.

---

# 9. Dialog Ownership

Example:

```cpp
SettingsDialog dialog(this);
```

Hierarchy:

```text
MainWindow

↓

SettingsDialog
```

Benefits:

* Proper stacking
* Automatic cleanup for heap-allocated child dialogs when appropriate
* Window centering
* Parent relationship

---

# 10. Dialog Geometry

Resize:

```cpp
dialog.resize(600,400);
```

Move:

```cpp
dialog.move(100,100);
```

Center relative to parent:

A common approach is to calculate the parent's geometry and position the dialog accordingly. Modern desktop environments may also position dialogs automatically based on the parent.

---

# 11. Qt Source Code Concepts

Conceptually:

```text
exec()

↓

Create Local Event Loop

↓

User Interaction

↓

accept()

↓

Exit Local Event Loop

↓

Return Result
```

This local event loop is the reason `exec()` blocks until the dialog closes.

---

# 12. Qt 5.15 vs Qt 6.11

| Feature  | Qt 5.15 | Qt 6.11 |
| -------- | ------- | ------- |
| QDialog  | ✔       | ✔       |
| accept() | ✔       | ✔       |
| reject() | ✔       | ✔       |
| done()   | ✔       | ✔       |
| exec()   | ✔       | ✔       |

The dialog API remains largely unchanged.

---

# 13. Best Practices

✅ Give dialogs a parent whenever appropriate.

✅ Use `exec()` only when blocking behavior is appropriate.

✅ Use `open()` or `show()` for asynchronous workflows.

✅ Validate user input before calling `accept()`.

✅ Keep dialogs focused on a single task.

---

# 14. Common Mistakes

### ❌ Using `exec()` for every dialog

Not every dialog needs to block the application.

---

### ❌ Forgetting the parent

```cpp
new SettingsDialog;
```

Without a parent or another ownership strategy, lifetime management becomes your responsibility.

---

### ❌ Performing heavy calculations inside the dialog

Long-running work should be delegated to worker threads to keep the dialog responsive.

---

### ❌ Closing without validation

Always verify user input before accepting the dialog.

---

# 15. Interview Questions

## Easy

1. What is `QDialog`?
2. What is the difference between a dialog and a widget?
3. What does `accept()` do?

---

## Medium

1. Compare `accept()`, `reject()`, and `done()`.
2. Explain modal versus modeless dialogs.
3. What values can `exec()` return?

---

## Hard

1. Explain the internal behavior of `exec()`.
2. Describe the dialog lifecycle.
3. Why should dialogs usually have a parent?

---

## Expert

1. Design a dialog architecture for a Treatment Planning System.
2. Explain how a local event loop works during `exec()`.
3. Compare blocking and asynchronous dialog workflows in enterprise applications.

---

# 16. Architecture Diagram

```text
                MainWindow
                     │
                     ▼
               SettingsDialog
                     │
             ┌───────┴────────┐
             ▼                ▼
           OK Button     Cancel Button
             │                │
             ▼                ▼
         accept()         reject()
             │                │
             └───────┬────────┘
                     ▼
             Dialog Closed
                     │
                     ▼
             Return Result
```

---

# 🏥 Production Example — Treatment Planning System

```text
Doctor Clicks

↓

Beam Properties

↓

Beam Dialog Opens

↓

Edit Energy

↓

Edit Gantry Angle

↓

Edit Collimator

↓

Press OK

↓

Validate Parameters

↓

accept()

↓

Update Treatment Plan

↓

Refresh Dose Display
```

If the user presses **Cancel**, no changes are applied to the treatment plan.

---

# 17. Revision Notes

* `QDialog` is the base class for dialog windows.
* Dialogs usually have a parent window.
* Modal dialogs block user interaction.
* Modeless dialogs allow continued interaction.
* `accept()` closes the dialog with `Accepted`.
* `reject()` closes the dialog with `Rejected`.
* `done()` allows custom result codes.
* `exec()` starts a local event loop and returns the dialog result.

---
Excellent. This chapter covers the **dialogs you will use almost every day** as a Qt developer.

If you build a real desktop application, you will almost certainly use:

* `QMessageBox`
* `QFileDialog`
* `QInputDialog`
* `QColorDialog`
* `QFontDialog`
* `QDialogButtonBox`

In fact, almost every professional Qt application—including **Qt Creator, Qt Designer, Medical TPS, CAD software, Photoshop-like editors, and IDEs**—uses these classes extensively.

---

# Complete Qt Master Course (Qt 5.15 LTS → Qt 6.11)

# PART V — GUI Programming

# Chapter 39 — Dialogs (Complete Deep Dive)

## Part 2 — QDialogButtonBox, QMessageBox, QFileDialog, QColorDialog, QFontDialog, QInputDialog & QWizard

> **Level:** Intermediate → Expert

---

# Chapter Objectives

After completing this chapter, you will understand:

* `QDialogButtonBox`
* `QMessageBox`
* `QFileDialog`
* `QColorDialog`
* `QFontDialog`
* `QInputDialog`
* `QWizard`
* Standard dialogs
* Dialog validation
* Enterprise dialog design

---

# Table of Contents

1. QDialogButtonBox
2. QMessageBox
3. QFileDialog
4. QColorDialog
5. QFontDialog
6. QInputDialog
7. QWizard
8. Dialog Validation
9. Enterprise Dialog Design
10. Qt 5 vs Qt 6
11. Best Practices
12. Interview Questions
13. Revision Notes

---

# 1. QDialogButtonBox

Instead of manually placing buttons:

```text
OK

Cancel

Apply
```

Qt provides:

```cpp
QDialogButtonBox
```

---

## Example

```cpp
QDialogButtonBox *buttons =
    new QDialogButtonBox(
        QDialogButtonBox::Ok |
        QDialogButtonBox::Cancel);
```

Result:

```text
+-----------------------+

      OK    Cancel

+-----------------------+
```

---

### Connect Buttons

```cpp
connect(buttons,
        &QDialogButtonBox::accepted,
        this,
        &QDialog::accept);

connect(buttons,
        &QDialogButtonBox::rejected,
        this,
        &QDialog::reject);
```

This is the recommended pattern for most dialogs.

---

### Standard Buttons

| Button | Purpose                |
| ------ | ---------------------- |
| Ok     | Accept changes         |
| Cancel | Cancel operation       |
| Apply  | Apply without closing  |
| Close  | Close window           |
| Save   | Save changes           |
| Open   | Open resource          |
| Yes    | Positive confirmation  |
| No     | Negative confirmation  |
| Retry  | Retry failed operation |
| Ignore | Ignore issue           |

---

# 2. QMessageBox

The most commonly used dialog.

Header:

```cpp
#include <QMessageBox>
```

---

## Information

```cpp
QMessageBox::information(
    this,
    "Information",
    "Patient imported successfully.");
```

---

Result:

```text
+-----------------------------------+

Information

Patient imported successfully.

          OK

+-----------------------------------+
```

---

## Warning

```cpp
QMessageBox::warning(
    this,
    "Warning",
    "Dose has not been calculated.");
```

---

## Critical

```cpp
QMessageBox::critical(
    this,
    "Error",
    "DICOM file is corrupted.");
```

---

## Question

```cpp
auto reply =
QMessageBox::question(
    this,
    "Save",
    "Save changes?");
```

Result:

```text
Yes

No

Cancel
```

---

Check:

```cpp
if(reply == QMessageBox::Yes)
{
    save();
}
```

---

# QMessageBox Types

| Function      | Purpose      |
| ------------- | ------------ |
| information() | Inform user  |
| warning()     | Show warning |
| critical()    | Show error   |
| question()    | Ask user     |

---

# 3. QFileDialog

Used for opening and saving files.

---

## Open File

```cpp
QString file =
QFileDialog::getOpenFileName(
    this,
    "Open Patient");
```

---

Result:

```text
+-------------------------+

Open File

Patient001.dcm

+-------------------------+
```

---

## Save File

```cpp
QString file =
QFileDialog::getSaveFileName(
    this,
    "Save RT Plan");
```

---

## Select Folder

```cpp
QString dir =
QFileDialog::getExistingDirectory(
    this,
    "Choose Folder");
```

---

## File Filters

```cpp
"DICOM (*.dcm);;Images (*.png *.jpg)"
```

Result:

```text
Only Supported Files
```

---

# TPS Example

```text
Import

↓

Choose Folder

↓

Find DICOM Files

↓

Import Patient
```

---

# 4. QColorDialog

Allows the user to choose a color.

Example:

```cpp
QColor color =
QColorDialog::getColor();
```

Result:

```text
Color Picker

↓

Red

↓

Green

↓

Blue
```

---

Typical Uses

* Contour color
* Dose color
* Theme color
* Annotation color

---

# 5. QFontDialog

Choose a font.

Example:

```cpp
bool ok;

QFont font =
QFontDialog::getFont(&ok);
```

Result:

```text
Font

↓

Size

↓

Preview
```

Useful for:

* Editors
* Reports
* Label customization

---

# 6. QInputDialog

Simple input dialogs.

---

## Text

```cpp
QString name =
QInputDialog::getText(
    this,
    "Name",
    "Patient Name");
```

---

## Integer

```cpp
int age =
QInputDialog::getInt(
    this,
    "Age",
    "Patient Age");
```

---

## Double

```cpp
double dose =
QInputDialog::getDouble(
    this,
    "Dose",
    "Prescription");
```

---

## Item Selection

```cpp
QString machine =
QInputDialog::getItem(
    this,
    "Machine",
    "Choose");
```

---

# 7. QWizard

For multi-step workflows.

Example:

```text
Step 1

↓

Step 2

↓

Step 3

↓

Finish
```

---

Typical Uses

```text
Installation

Registration

Patient Import

Treatment Wizard
```

---

Buttons:

```text
Back

Next

Finish

Cancel
```

---

TPS Example

```text
Import Patient

↓

Choose Folder

↓

Verify Patient

↓

Select Series

↓

Import

↓

Finish
```

---

# 8. Dialog Validation

Suppose:

```text
Patient Name

↓

Empty

↓

Press OK
```

Bad:

```text
Dialog Closes
```

---

Correct:

```cpp
void PatientDialog::accept()
{
    if(nameEdit->text().isEmpty())
    {
        QMessageBox::warning(
            this,
            "Error",
            "Patient name required");

        return;
    }

    QDialog::accept();
}
```

Flow:

```text
Press OK

↓

Validate

↓

Invalid?

↓

Show Error

↓

Stay Open

↓

Correct Data

↓

accept()
```

---

# 9. Enterprise Dialog Design

Professional dialog guidelines:

### Good

```text
Patient Information

----------------

Name

ID

DOB

Gender

Machine

Prescription

----------------

OK

Cancel
```

---

Bad

```text
100 Fields

↓

One Huge Dialog
```

Instead:

```text
Patient

Beam

Machine

Optimization

Export
```

Split large tasks into multiple dialogs or wizard pages.

---

# 10. Qt Source Code Concepts

Conceptually:

```text
Dialog

↓

Event Loop

↓

Button Click

↓

accept()

↓

Return Result

↓

Destroy
```

For standard dialogs like `QMessageBox::information()`, Qt internally creates a dialog, runs it, and returns the user's response.

---

# 11. Qt 5.15 vs Qt 6.11

| Feature      | Qt 5.15 | Qt 6.11 |
| ------------ | ------- | ------- |
| QMessageBox  | ✔       | ✔       |
| QFileDialog  | ✔       | ✔       |
| QColorDialog | ✔       | ✔       |
| QFontDialog  | ✔       | ✔       |
| QInputDialog | ✔       | ✔       |
| QWizard      | ✔       | ✔       |

The APIs remain highly compatible.

---

# 12. Best Practices

✅ Use `QDialogButtonBox` instead of manually managing standard buttons.

✅ Validate input before calling `accept()`.

✅ Use standard dialogs whenever they satisfy your requirements.

✅ Use file filters in `QFileDialog`.

✅ Use `QWizard` for multi-step workflows.

---

# 13. Common Mistakes

### ❌ Closing a dialog without validation

Always validate user input before accepting.

---

### ❌ Using `QInputDialog` for complex forms

Create a custom `QDialog` instead.

---

### ❌ Creating custom message dialogs unnecessarily

Prefer `QMessageBox` unless you need specialized behavior.

---

### ❌ Forgetting to check dialog results

```cpp
QString file =
QFileDialog::getOpenFileName(...);
```

Always verify that the returned string is not empty before using it.

---

# 14. Interview Questions

## Easy

1. What is `QMessageBox`?
2. What is `QFileDialog`?
3. What is `QDialogButtonBox`?

---

## Medium

1. Compare `QInputDialog` and `QDialog`.
2. Explain `QWizard`.
3. How do you validate a dialog?

---

## Hard

1. Describe the lifecycle of a standard dialog.
2. Explain why `QDialogButtonBox` is recommended.
3. How would you design a multi-step import wizard?

---

## Expert

1. Design all dialogs required for a Treatment Planning System.
2. Compare standard dialogs with custom dialogs.
3. Explain how Qt internally handles modal standard dialogs.

---

# 15. Architecture Diagram

```text
                MainWindow
                     │
     ┌───────────────┼─────────────────┐
     ▼               ▼                 ▼
QMessageBox     QFileDialog       QWizard
     │               │                 │
     ▼               ▼                 ▼
 User Action    File Selected     Multi-Step Workflow
     │               │                 │
     └───────────────┼─────────────────┘
                     ▼
               Return Result
```

---

# 🏥 Production Example — Treatment Planning System

```text
Doctor Clicks "Import Patient"
               │
               ▼
         QWizard Starts
               │
               ▼
     Select DICOM Folder
               │
               ▼
      QFileDialog Opens
               │
               ▼
      DICOM Files Found
               │
               ▼
      Patient Information
               │
               ▼
      Validate Data
               │
               ▼
      QMessageBox (Warning?)
               │
               ▼
      Import Successful
               │
               ▼
      QMessageBox::information()
```

This workflow combines several standard dialog classes to provide a smooth user experience while validating each step.

---

# 16. Revision Notes

* `QDialogButtonBox` standardizes dialog buttons.
* `QMessageBox` provides information, warning, error, and question dialogs.
* `QFileDialog` handles file and directory selection.
* `QColorDialog` selects colors.
* `QFontDialog` selects fonts.
* `QInputDialog` is suitable for simple user input.
* `QWizard` is designed for multi-step workflows.
* Always validate data before accepting a dialog.

---

# 🎯 Chapter 39 Complete

You now have a complete understanding of **Qt Dialogs**, including:

* `QDialog`
* Dialog lifecycle
* Modal and modeless dialogs
* `accept()`, `reject()`, and `done()`
* `QDialogButtonBox`
* `QMessageBox`
* `QFileDialog`
* `QColorDialog`
* `QFontDialog`
* `QInputDialog`
* `QWizard`
* Dialog validation
* Enterprise dialog design
* Qt 5 → Qt 6 compatibility

You now have the knowledge required to design professional dialog systems for desktop applications ranging from simple utilities to complex medical, CAD, and enterprise software.

---

# 🚀 Next Chapter

## **Chapter 40 — Menus (Complete Deep Dive)**

