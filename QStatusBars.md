Excellent. **The Status Bar is one of the most underrated components in Qt.**

Many beginners think it is only for displaying text like:

```text
Ready
```

In reality, professional applications use the status bar to display:

* Current tool
* Mouse coordinates
* Zoom level
* Progress
* Background tasks
* Memory usage
* CPU usage
* Cursor position
* Network status
* Database status
* Patient information
* Calculation progress

Applications such as:

* Qt Creator
* Visual Studio
* AutoCAD
* Adobe Photoshop
* Medical TPS
* Enterprise ERP

all use the status bar extensively.

---

# Complete Qt Master Course (Qt 5.15 LTS → Qt 6.11)

# PART V — GUI Programming

# Chapter 42 — Status Bars (Complete Deep Dive)

## Part 1 — QStatusBar, Status Messages, Permanent Widgets, Progress Indicators & Status Tips

> **Level:** Beginner → Expert

---

# Chapter Objectives

After completing this chapter, you will understand:

* What is a status bar?
* `QStatusBar`
* Temporary messages
* Permanent widgets
* Progress indicators
* Status tips
* Embedded widgets
* Status bar architecture
* Qt 5 vs Qt 6

---

# Table of Contents

1. Introduction
2. QStatusBar
3. Temporary Messages
4. Permanent Widgets
5. Embedded Widgets
6. Progress Indicators
7. QAction Status Tips
8. Status Bar Architecture
9. Qt 5 vs Qt 6
10. Best Practices
11. Interview Questions
12. Revision Notes

---

# 1. Introduction

A status bar displays information about the current state of the application.

Example:

```text
+--------------------------------------------------------------+
| Ready                                                100%    |
+--------------------------------------------------------------+
```

Unlike a dialog, the status bar does not interrupt the user.

It provides continuous feedback.

---

# Professional Examples

Visual Studio:

```text
Ln 120

Col 35

Spaces: 4

UTF-8
```

Medical TPS:

```text
Patient Loaded

Dose Ready

Zoom 150%

Machine Connected
```

---

# 2. QStatusBar

Header:

```cpp
#include <QStatusBar>
```

Usually obtained from `QMainWindow`:

```cpp
QStatusBar *status =
    statusBar();
```

Qt automatically creates one when needed.

---

# Basic Message

```cpp
statusBar()->showMessage("Ready");
```

Result:

```text
Ready
```

---

# Timed Message

```cpp
statusBar()->showMessage(
    "Patient Imported",
    3000);
```

Meaning:

```text
Show Message

↓

3 Seconds

↓

Disappear
```

The second argument is in milliseconds.

---

# Clear Message

```cpp
statusBar()->clearMessage();
```

---

# 3. Temporary Messages

Temporary messages replace the current status text.

Example:

```text
Ready
```

User opens a file:

```text
Opening Patient...
```

After completion:

```text
Ready
```

Flow:

```text
User Action

↓

Temporary Message

↓

Operation Complete

↓

Default Status
```

---

# Typical Temporary Messages

```text
Saving...

Loading...

Printing...

Importing DICOM...

Calculating Dose...

Export Complete
```

---

# 4. Permanent Widgets

Permanent widgets stay visible.

Example:

```cpp
QLabel *zoom =
    new QLabel("100%");

statusBar()->addPermanentWidget(zoom);
```

Result:

```text
Ready                                   100%
```

Even if temporary messages change, the zoom label remains visible.

---

# Add Multiple Widgets

```cpp
statusBar()->addPermanentWidget(cpuLabel);

statusBar()->addPermanentWidget(memoryLabel);

statusBar()->addPermanentWidget(networkLabel);
```

Example:

```text
Ready        CPU: 20%   RAM: 1.5GB   Online
```

---

# 5. Embedded Widgets

A status bar can contain almost any widget.

---

## QLabel

```cpp
QLabel *label =
    new QLabel("Ready");

statusBar()->addWidget(label);
```

---

## QProgressBar

```cpp
QProgressBar *progress =
    new QProgressBar;

statusBar()->addPermanentWidget(progress);
```

Example:

```text
Calculating Dose...

[██████████------]

65%
```

---

## QPushButton

```cpp
QPushButton *button =
    new QPushButton("Cancel");

statusBar()->addPermanentWidget(button);
```

Useful for canceling long-running operations.

---

## QToolButton

```cpp
QToolButton *button =
    new QToolButton;
```

Useful for compact actions in the status bar.

---

# 6. Progress Indicators

Long-running tasks should provide feedback.

Example:

```text
Dose Calculation

↓

Progress Bar

↓

Finished
```

Typical workflow:

```cpp
progress->setValue(0);

// ...

progress->setValue(50);

// ...

progress->setValue(100);
```

---

# TPS Example

```text
Calculating Dose...

15%

42%

73%

100%

Completed
```

The user knows the application is still working.

---

# 7. QAction Status Tips

Each `QAction` can provide a descriptive status message.

Example:

```cpp
openAction->setStatusTip(
    "Open an existing patient");
```

When the user hovers over the menu item or toolbar button:

```text
Open an existing patient
```

appears in the status bar automatically.

---

## Another Example

```cpp
saveAction->setStatusTip(
    "Save current treatment plan");
```

Hover:

```text
Save current treatment plan
```

This provides contextual help without cluttering the interface.

---

# 8. Status Bar Architecture

Typical layout:

```text
+--------------------------------------------------------------------------------+
| Status Message        Progress Bar        Zoom      Memory      Connection      |
+--------------------------------------------------------------------------------+
```

Conceptually:

```text
QMainWindow
      │
      ▼
 QStatusBar
      │
 ┌────┼──────────────────────────────────────┐
 ▼    ▼              ▼            ▼          ▼
Text Progress     Zoom Label   Memory     Network
```

---

# 9. Typical Professional Status Bar

```text
+--------------------------------------------------------------------------------------------+
| Ready | Dose: Valid | Zoom: 150% | Cursor: (145, 312) | RAM: 1.8GB | Connected | UTC+05:30 |
+--------------------------------------------------------------------------------------------+
```

Information may update continuously while the application runs.

---

# 10. Qt Source Code Concepts

Conceptually:

```text
User Action

↓

QAction

↓

Status Tip

↓

QStatusBar

↓

Display Message
```

For temporary messages:

```text
showMessage()

↓

Internal Timer (optional)

↓

Display

↓

Timeout

↓

Restore Default
```

---

# 11. Qt 5.15 vs Qt 6.11

| Feature           | Qt 5.15 | Qt 6.11 |
| ----------------- | ------- | ------- |
| QStatusBar        | ✔       | ✔       |
| Permanent Widgets | ✔       | ✔       |
| Status Tips       | ✔       | ✔       |
| Progress Widgets  | ✔       | ✔       |

The API remains stable.

---

# 12. Best Practices

✅ Keep temporary messages short and meaningful.

✅ Use permanent widgets for persistent information.

✅ Display progress for long-running tasks.

✅ Provide status tips for important actions.

✅ Avoid placing too many widgets in the status bar.

---

# 13. Common Mistakes

### ❌ Displaying critical errors only in the status bar

Critical problems should use dialogs or dedicated notifications.

---

### ❌ Never clearing temporary messages

Old messages can confuse users.

---

### ❌ Overloading the status bar

Avoid turning it into a dashboard with excessive information.

---

### ❌ Updating widgets excessively

For example, refreshing a memory label hundreds of times per second wastes CPU resources.

---

# 14. Interview Questions

## Easy

1. What is `QStatusBar`?
2. What is a temporary status message?
3. What is a permanent widget?

---

## Medium

1. Explain `showMessage()`.
2. What is the difference between `addWidget()` and `addPermanentWidget()`?
3. How do status tips work?

---

## Hard

1. Explain the architecture of `QStatusBar`.
2. How would you display the progress of a long-running operation?
3. Why should the status bar not be overloaded?

---

## Expert

1. Design a professional status bar for a Medical Treatment Planning System.
2. Explain how `QAction` status tips reach the status bar.
3. Compare status bars with dialogs and notifications for user feedback.

---

# 15. Architecture Diagram

```text
                    QMainWindow
                          │
                          ▼
                     QStatusBar
        ┌────────────┼───────────────┬───────────────┬──────────────┐
        ▼            ▼               ▼               ▼              ▼
 Status Text   Progress Bar     Zoom Label     Memory Label   Connection
        │
        ▼
  showMessage()
        │
        ▼
 User Feedback
```

---

# 🏥 Production Example — Treatment Planning System

```text
+------------------------------------------------------------------------------------------------------+
| Ready | Patient: John Doe | Beam: 4 | Dose: Valid | Zoom: 200% | Cursor: (245,188) | Machine: Online |
+------------------------------------------------------------------------------------------------------+
```

During dose calculation:

```text
+------------------------------------------------------------------------------------------------------+
| Calculating Dose... | ████████████░░░░░░░ 68% | Cancel | CPU: 45% | ETA: 00:18                      |
+------------------------------------------------------------------------------------------------------+
```

After completion:

```text
+------------------------------------------------------------------------------------------------------+
| Dose calculation completed successfully. | Zoom: 200% | Machine: Online                             |
+------------------------------------------------------------------------------------------------------+
```

The status bar provides continuous feedback without interrupting the user's workflow.

---

# 16. Revision Notes

* `QStatusBar` displays application status information.
* `showMessage()` displays temporary messages.
* `clearMessage()` removes the current temporary message.
* Permanent widgets remain visible even when temporary messages change.
* `QProgressBar` is commonly embedded for long-running tasks.
* `QAction` status tips automatically appear in the status bar.
* Status bars are intended for non-intrusive feedback.

---

# 🎯 Chapter 42 — Part 1 Complete

You now understand:

* `QStatusBar`
* Temporary messages
* Permanent widgets
* Embedded widgets
* Progress indicators
* `QAction` status tips
* Status bar architecture
* Professional status bar design
* Qt 5 → Qt 6 compatibility

You now know how to build informative and user-friendly status bars for professional desktop applications.

---
Excellent.

Now we'll move to the **advanced Status Bar** concepts used in enterprise desktop applications.

This chapter explains how applications like **Qt Creator, Visual Studio, AutoCAD, Photoshop, Medical TPS, and CAD software** provide live information about the application's current state without interrupting the user.

---

# Complete Qt Master Course (Qt 5.15 LTS → Qt 6.11)

# PART V — GUI Programming

# Chapter 42 — Status Bars (Complete Deep Dive)

## Part 2 — Real-Time Updates, Background Tasks, Custom Widgets, Performance & Enterprise Architecture

> **Level:** Advanced → Expert

---

# Chapter Objectives

After completing this chapter, you will understand:

* Real-time status updates
* Background task integration
* Busy indicators
* Multiple progress operations
* Custom status widgets
* Memory and CPU monitoring
* Network/database status
* Status bar performance
* Qt internals

---

# Table of Contents

1. Real-Time Status Updates
2. Background Task Integration
3. Busy Indicators
4. Multiple Progress Operations
5. Custom Status Widgets
6. Memory & CPU Monitoring
7. Network & Database Indicators
8. Performance Optimization
9. Qt Internals
10. Qt 5 vs Qt 6
11. Best Practices
12. Interview Questions
13. Revision Notes

---

# 1. Real-Time Status Updates

A professional application continuously updates information.

Example:

```text
Cursor Position

↓

(125, 350)

↓

(126, 351)

↓

(127, 352)
```

Typical real-time values:

* Mouse position
* Zoom level
* Selected object
* Active tool
* Current layer
* Current patient
* Active beam

---

## Example

```cpp
cursorLabel->setText(
    QString("(%1,%2)")
        .arg(x)
        .arg(y));
```

Result:

```text
Cursor

(325,210)
```

---

# TPS Example

```text
Mouse Moves

↓

CT Slice

↓

Update Coordinates

↓

Status Bar
```

---

# 2. Background Task Integration

Long-running operations should not freeze the UI.

Instead:

```text
Background Thread

↓

Progress Signal

↓

Status Bar

↓

Progress Updated
```

Example:

```cpp
connect(worker,
        &DoseWorker::progressChanged,
        progressBar,
        &QProgressBar::setValue);
```

The worker thread emits progress, and the status bar reflects it.

---

# 3. Busy Indicators

Sometimes progress cannot be calculated.

Example:

```text
Connecting...

Unknown Time
```

Use an indeterminate progress bar:

```cpp
progressBar->setRange(0, 0);
```

Result:

```text
████████████
Moving Animation
████████████
```

When the operation finishes:

```cpp
progressBar->setRange(0, 100);
progressBar->setValue(100);
```

---

Typical uses:

* Database connection
* Network communication
* DICOM import discovery
* License validation

---

# 4. Multiple Progress Operations

Large applications often perform several tasks simultaneously.

Example:

```text
Import Images

35%

----------------

Dose Calculation

80%

----------------

Export

15%
```

Possible approaches:

* One combined progress indicator
* Separate progress widgets
* A task manager dialog for detailed progress

Keep the status bar uncluttered.

---

# 5. Custom Status Widgets

You can embed your own widget.

Example:

```cpp
class ConnectionWidget : public QWidget
{
    // Custom painting
};
```

Add:

```cpp
statusBar()->addPermanentWidget(
    connectionWidget);
```

Example:

```text
🟢 Connected

🔴 Offline

🟡 Connecting
```

---

# 6. Memory & CPU Monitoring

Professional software often displays resource usage.

Example:

```text
Memory

1.8 GB

CPU

32%
```

Update periodically:

```cpp
timer->start(1000);
```

Every second:

```text
Read System Statistics

↓

Update Labels
```

Avoid updating too frequently.

---

# 7. Network & Database Status

Enterprise applications frequently communicate with servers.

Example:

```text
🟢 Database Connected
```

Loss of connection:

```text
🔴 Database Offline
```

Medical TPS example:

```text
Machine Connected

↓

License Server Connected

↓

PACS Connected

↓

DICOM Server Connected
```

Displaying these states in the status bar gives users immediate feedback.

---

# 8. Status Bar Performance

The status bar is updated often, so efficiency matters.

### Good

```text
Update Once Per Second
```

### Avoid

```text
Update Every Millisecond
```

Excessive updates waste CPU time and may cause flickering.

---

## Event-Driven Updates

Prefer:

```text
Dose Completed

↓

Update Status
```

Instead of:

```text
Repeated Polling

↓

Update Continuously
```

Signals and slots are generally more efficient than constant polling.

---

# 9. Enterprise Status Bar Example

```text
+-----------------------------------------------------------------------------------------------------------+
| Ready | Patient: John Doe | Beam: 6 | Slice: 145 | Zoom: 200% | RAM: 2.1 GB | PACS: 🟢 | Machine: 🟢 |
+-----------------------------------------------------------------------------------------------------------+
```

During calculation:

```text
+-----------------------------------------------------------------------------------------------------------+
| Calculating Dose... | ████████████████░░░░ 75% | ETA: 00:12 | Cancel | CPU: 48%                         |
+-----------------------------------------------------------------------------------------------------------+
```

After completion:

```text
+-----------------------------------------------------------------------------------------------------------+
| Dose calculation completed successfully. | Zoom: 200% | Machine: 🟢 | PACS: 🟢                          |
+-----------------------------------------------------------------------------------------------------------+
```

---

# 10. Qt Source Code Concepts

Conceptually:

```text
Worker Thread
      │
      ▼
progressChanged(int)
      │
      ▼
Signal/Slot Queue
      │
      ▼
Main GUI Thread
      │
      ▼
QProgressBar::setValue()
      │
      ▼
Repaint
```

All UI updates must occur in the GUI thread.

---

# 11. Qt 5.15 vs Qt 6.11

| Feature            | Qt 5.15 | Qt 6.11 |
| ------------------ | ------- | ------- |
| QStatusBar         | ✔       | ✔       |
| Embedded Widgets   | ✔       | ✔       |
| Progress Bars      | ✔       | ✔       |
| Signals & Slots    | ✔       | ✔       |
| Thread Integration | ✔       | ✔       |

The APIs remain stable across versions.

---

# 12. Best Practices

✅ Keep updates event-driven whenever possible.

✅ Use progress bars for long operations.

✅ Use indeterminate progress when the duration is unknown.

✅ Display only essential information.

✅ Update resource monitors at reasonable intervals (for example, once per second).

✅ Keep all UI updates on the GUI thread.

---

# 13. Common Mistakes

### ❌ Updating the status bar from a worker thread

Always communicate through signals and slots or other thread-safe mechanisms.

---

### ❌ Displaying too much information

A crowded status bar becomes difficult to read.

---

### ❌ Polling continuously

Prefer event-driven updates.

---

### ❌ Showing every log message

The status bar should summarize important state, not replace a logging window.

---

# 14. Interview Questions

## Easy

1. What is a busy indicator?
2. How do you display progress in a status bar?
3. Can a status bar contain custom widgets?

---

## Medium

1. Explain indeterminate progress bars.
2. How do worker threads update the status bar?
3. Why should status updates be event-driven?

---

## Hard

1. Explain why UI updates must happen in the GUI thread.
2. Design a status bar for a CAD application.
3. How would you display multiple concurrent operations?

---

## Expert

1. Design the status bar architecture for a Treatment Planning System with DICOM, PACS, and machine connectivity.
2. Explain how queued signals safely update UI widgets.
3. Compare polling-based and signal-driven status updates in terms of performance and responsiveness.

---

# 15. Architecture Diagram

```text
                     Worker Thread
                           │
                    progressChanged(int)
                           │
                           ▼
                  Queued Signal/Slot
                           │
                           ▼
                   Main GUI Thread
                           │
        ┌──────────────────┼──────────────────┐
        ▼                  ▼                  ▼
  QProgressBar       QLabel(Status)     QLabel(Connection)
        │                  │                  │
        └──────────────────┼──────────────────┘
                           ▼
                      QStatusBar
                           │
                           ▼
                        User
```

---

# 🏥 Production Example — Treatment Planning System

```text
+----------------------------------------------------------------------------------------------------------------+
| Patient: John Doe | Plan: Prostate | Beam: 7 | Dose: Valid | Zoom: 150% | PACS: 🟢 | LINAC: 🟢 | RAM: 2.3 GB |
+----------------------------------------------------------------------------------------------------------------+
```

While importing:

```text
+----------------------------------------------------------------------------------------------------------------+
| Importing DICOM... ██████████░░░░░░░░ 48% | Files: 126/262 | Cancel | PACS: 🟢                              |
+----------------------------------------------------------------------------------------------------------------+
```

During optimization:

```text
+----------------------------------------------------------------------------------------------------------------+
| Optimizing Plan... █████████████████░░ 86% | Iteration: 43/50 | Objective: Improving                        |
+----------------------------------------------------------------------------------------------------------------+
```

The status bar provides continuous, non-intrusive feedback while allowing the user to continue monitoring the application's state.

---

# 16. Revision Notes

* Use the status bar for continuous, non-blocking feedback.
* Update status information in response to events rather than constant polling.
* Use indeterminate progress bars when the completion time is unknown.
* Embed custom widgets for connection status, progress, or resource usage.
* Perform UI updates only in the GUI thread.
* Keep the status bar concise and focused on high-value information.

---



# 🚀 Next Chapter

## **Chapter 43 — Dock Widgets (Complete Deep Dive)**
