Excellent. This chapter teaches **how professional Qt applications organize hundreds or even thousands of widgets**.

A beginner may build a window with 10 widgets.

A professional application like:

* Qt Creator
* Qt Designer
* Medical Treatment Planning System (TPS)
* AutoCAD
* Enterprise ERP
* GIS Software

may contain **thousands of QWidget objects**.

Without a proper widget hierarchy, such applications would be impossible to maintain.

---

# Complete Qt Master Course (Qt 5.15 LTS → Qt 6.11)

# PART V — GUI Programming

# Chapter 36 — QWidget Hierarchy (Complete Deep Dive)

## Part 1 — Parent-Child Hierarchy, Ownership Tree, Visual Tree, Widget Traversal & Dynamic Widgets

**Level:** Beginner → Expert

---

# Chapter Objectives

After completing this chapter, you will understand:

* QWidget hierarchy
* Parent-child relationships
* Ownership tree
* Visual tree
* Widget traversal
* `findChild()`
* `findChildren()`
* Dynamic widget creation
* Reparenting
* Qt 5 vs Qt 6

---

# Table of Contents

1. Introduction
2. Parent-Child Hierarchy
3. Ownership Tree
4. Visual Tree
5. Widget Traversal
6. `findChild()`
7. `findChildren()`
8. Dynamic Widgets
9. Reparenting Widgets
10. Qt5 vs Qt6
11. Best Practices
12. Interview Questions
13. Revision Notes

---

# 1. Introduction

Every Qt Widgets application is organized as a **tree**.

Example:

```text
MainWindow
│
├── MenuBar
├── ToolBar
├── StatusBar
└── CentralWidget
     ├── LeftPanel
     │    ├── TreeWidget
     │    └── SearchBox
     │
     ├── Viewer
     │    ├── DoseView
     │    └── DVHWidget
     │
     └── PropertyPanel
```

Each node is a `QWidget`.

---

# Why a Tree?

Without hierarchy:

```text
1000 Widgets

↓

No Ownership

↓

No Structure

↓

Memory Problems

↓

Hard Maintenance
```

Qt uses parent-child relationships to organize everything.

---

# 2. Parent-Child Hierarchy

Example:

```cpp
QWidget *window = new QWidget;

QPushButton *button =
    new QPushButton(window);

QLabel *label =
    new QLabel(window);
```

Hierarchy:

```text
Window
│
├── Button
│
└── Label
```

Parent:

```cpp
button->parentWidget();
```

Children:

```cpp
window->children();
```

---

# Internal Object Tree

Qt internally stores something conceptually similar to:

```text
Window
│
├── Button
├── Label
├── LineEdit
└── ComboBox
```

This enables:

* Automatic deletion
* Event propagation
* Visibility propagation
* Enable/disable propagation

---

# 3. Ownership Tree

One of Qt's strongest features.

Example:

```cpp
QWidget *window =
    new QWidget;

QPushButton *button =
    new QPushButton(window);
```

Ownership:

```text
Window

↓

Owns Button
```

Delete:

```cpp
delete window;
```

Automatically:

```text
Delete Window

↓

Delete Button
```

No manual cleanup required.

---

# Example

```cpp
MainWindow

↓

CentralWidget

↓

Viewer

↓

DoseView

↓

Crosshair
```

Destroy:

```cpp
delete mainWindow;
```

Everything below it is destroyed automatically.

---

# 4. Visual Tree

Ownership and visual placement are usually aligned.

Example:

```text
Main Window
│
├── Toolbar
│
├── Viewer
│     ├── CT Image
│     └── Dose Overlay
│
└── Status Bar
```

Visual representation follows the widget hierarchy.

> **Note:** Ownership and visual hierarchy are often the same, but not always. Some helper objects are `QObject`s rather than `QWidget`s, and some specialized widget arrangements can differ.

---

# Visibility Propagation

Hide parent:

```cpp
viewer->hide();
```

Automatically:

```text
Viewer

↓

Dose View Hidden

↓

Overlay Hidden

↓

Crosshair Hidden
```

Children become invisible because their parent is hidden.

---

# Enable/Disable Propagation

Disable parent:

```cpp
viewer->setEnabled(false);
```

Result:

```text
Viewer

↓

Children Disabled
```

Useful when:

```text
Dose Calculation Running

↓

Disable Viewer
```

---

# 5. Widget Traversal

Sometimes we need to visit every widget.

Example:

```text
Main Window

↓

All Widgets

↓

Update Theme
```

Qt allows traversal through the object hierarchy.

---

# Children List

```cpp
QObjectList list =
    window->children();
```

Loop:

```cpp
for (QObject *obj : window->children())
{
    qDebug() << obj;
}
```

---

# Recursive Traversal

Conceptually:

```text
Main Window

↓

Central Widget

↓

Viewer

↓

Dose View

↓

Crosshair
```

You can recursively walk the hierarchy.

Example:

```cpp
void printTree(QObject *object)
{
    qDebug() << object->objectName();

    for (QObject *child : object->children())
    {
        printTree(child);
    }
}
```

---

# 6. findChild()

Find a specific child object.

Example:

```cpp
QPushButton *button =
    window->findChild<QPushButton *>("saveButton");
```

Requires:

```cpp
button->setObjectName("saveButton");
```

Searches recursively by default.

---

# Example

```text
Main Window
│
└── Toolbar
      │
      └── Save Button
```

Call:

```cpp
findChild()
```

Result:

```text
Save Button
```

---

# 7. findChildren()

Find all matching widgets.

Example:

```cpp
QList<QPushButton *> buttons =
    window->findChildren<QPushButton *>();
```

Returns:

```text
Save

Open

Close

Print
```

Useful for:

* Applying themes
* Enabling/disabling groups
* Automated testing
* Bulk configuration

---

# Example

```cpp
for (auto *button : buttons)
{
    button->setEnabled(false);
}
```

---

# 8. Dynamic Widget Creation

Large applications often create widgets at runtime.

Example:

```cpp
QPushButton *button =
    new QPushButton("Beam");
```

Later:

```cpp
layout->addWidget(button);
```

Result:

```text
Beam 1

Beam 2

Beam 3

Beam 4
```

The interface grows dynamically.

---

# TPS Example

```text
Beam List

↓

Beam Added

↓

Create Widget

↓

Insert Into Layout
```

No need to redesign the UI.

---

# 9. Reparenting Widgets

A widget's parent can change.

Example:

```cpp
widget->setParent(newParent);
```

Conceptually:

Before:

```text
Left Panel

↓

Viewer
```

After:

```text
Right Panel

↓

Viewer
```

---

# Important

Changing the parent:

* Changes ownership.
* Changes coordinate system.
* Usually affects visibility.
* Often requires the layout to be updated.

---

# Example

Docking systems.

```text
Floating Window

↓

Dock Widget

↓

Main Window
```

Qt uses reparenting internally.

---

# 10. Widget Hierarchy in QMainWindow

Typical structure:

```text
QMainWindow
│
├── MenuBar
├── ToolBar
├── DockWidget
│     ├── Property Panel
│     └── Patient Browser
├── CentralWidget
│     ├── Viewer
│     ├── DVH
│     └── Beam Editor
└── StatusBar
```

This is the architecture used in many professional desktop applications.

---

# 11. Qt Source Code Concepts

Conceptually:

```text
Parent Widget
        │
        ▼
children()
        │
        ▼
Child Widget
        │
        ▼
Grandchild Widget
```

Many Qt operations—painting, event propagation, and destruction—traverse this hierarchy.

---

# 12. Qt 5.15 vs Qt 6.11

| Feature            | Qt 5.15 | Qt 6.11 |
| ------------------ | ------- | ------- |
| Parent-Child Model | ✔       | ✔       |
| `findChild()`      | ✔       | ✔       |
| `findChildren()`   | ✔       | ✔       |
| Reparenting        | ✔       | ✔       |

The hierarchy model remains unchanged.

---

# 13. Best Practices

✅ Give important widgets meaningful `objectName()` values.

✅ Use parent-child ownership instead of manual memory management.

✅ Prefer layouts over manual positioning.

✅ Use `findChild()` sparingly in production code; direct pointers are usually clearer and faster when available.

✅ Keep widget hierarchies organized and modular.

---

# 14. Common Mistakes

### ❌ Forgetting to assign a parent

```cpp
new QPushButton;
```

Without a parent or another ownership mechanism, you are responsible for deleting it.

---

### ❌ Excessive use of `findChild()`

Repeated tree searches in performance-critical code are inefficient.

---

### ❌ Reparenting without updating layouts

The widget may not appear where expected until it is inserted into an appropriate layout.

---

### ❌ Deep, unnecessary hierarchies

Avoid creating many nested container widgets when a simpler layout will do.

---

# 15. Interview Questions

## Easy

1. What is the QWidget hierarchy?
2. What is parent-child ownership?
3. What does `findChild()` do?

---

## Medium

1. Compare `findChild()` and `findChildren()`.
2. Explain visibility propagation.
3. What happens when a parent widget is deleted?

---

## Hard

1. Explain ownership versus visual hierarchy.
2. Describe widget reparenting.
3. How does Qt traverse the widget tree?

---

## Expert

1. Design the widget hierarchy for a Treatment Planning System.
2. Explain how Qt uses the widget tree for destruction and event propagation.
3. Compare storing widget pointers directly versus locating them with `findChild()`.

---

# 16. Architecture Diagram

```text
                    QMainWindow
                         │
        ┌────────────────┼────────────────┐
        ▼                ▼                ▼
    MenuBar          ToolBar         StatusBar
                         │
                         ▼
                  CentralWidget
                         │
        ┌────────────────┼────────────────┐
        ▼                ▼                ▼
   Patient Tree      Dose Viewer      DVH Widget
```

---

# 🏥 Production Example — Treatment Planning System

```text
MainWindow
│
├── MenuBar
├── ToolBar
├── Patient Browser
│
├── Beam Panel
│
├── CT Viewer
│      ├── Image Layer
│      ├── Dose Layer
│      ├── Structure Layer
│      └── Crosshair Layer
│
├── DVH Widget
├── Property Panel
└── Status Bar
```

This hierarchical organization allows Qt to automatically manage ownership, repaint propagation, visibility, and cleanup for a very large interface.

---

# 17. Revision Notes

* Every Qt Widgets application is organized as a tree.
* Parent-child relationships provide ownership.
* Deleting a parent automatically deletes its children.
* Visibility and enabled state propagate from parent to child.
* `findChild()` finds a single matching descendant.
* `findChildren()` returns all matching descendants.
* Dynamic widgets are commonly created at runtime.
* Reparenting changes ownership and often requires layout updates.

---

# 🎯 Chapter 36 — Part 1 Complete

You now understand:

* QWidget hierarchy
* Ownership tree
* Visual hierarchy
* Widget traversal
* `findChild()`
* `findChildren()`
* Dynamic widget creation
* Reparenting
* Qt 5 → Qt 6 compatibility

These concepts are fundamental to building large, maintainable Qt desktop applications.

---

Excellent. This is the **advanced QWidget hierarchy chapter**.

Understanding these concepts is essential for building professional desktop applications like:

* Qt Creator
* Qt Designer
* Medical Treatment Planning Systems (TPS)
* CAD software
* GIS applications
* Automotive engineering tools

These applications often contain **thousands of widgets** spread across multiple windows, dock widgets, dialogs, and panels. Efficient management of the widget hierarchy directly affects correctness, maintainability, and performance.

---

# Complete Qt Master Course (Qt 5.15 LTS → Qt 6.11)

# PART V — GUI Programming

# Chapter 36 — QWidget Hierarchy (Complete Deep Dive)

## Part 2 — Z-Order, Event Propagation, Focus Chain, Painting Hierarchy & Performance

**Level:** Advanced → Expert

---

# Chapter Objectives

After this chapter, you will understand:

* Z-order
* Widget stacking
* `raise()`
* `lower()`
* `stackUnder()`
* Event propagation
* Focus chain
* Child painting
* Hierarchy optimization
* Qt source code concepts

---

# Table of Contents

1. Z-Order
2. Widget Stacking
3. Event Propagation
4. Focus Chain
5. Painting Hierarchy
6. Native Window Hierarchy
7. Performance
8. Qt Source Code Concepts
9. Qt 5 vs Qt 6
10. Best Practices
11. Interview Questions
12. Revision Notes

---

# 1. Z-Order

When widgets overlap, Qt needs to know:

> **Which widget should appear on top?**

This is called the **Z-order** (or stacking order).

Example:

```text
Before

+-----------------------+
|     Widget A          |
|   +-------------+     |
|   |  Widget B   |     |
|   +-------------+     |
+-----------------------+
```

If Widget B is above Widget A, the overlapping area shows Widget B.

---

# Default Stacking Order

Generally, child widgets created later are stacked above earlier sibling widgets.

Example:

```cpp
QLabel *background = new QLabel(parent);

QPushButton *button =
    new QPushButton(parent);
```

Conceptually:

```text
Button

▲

Background
```

The button is painted above the background label.

---

# 2. Widget Stacking APIs

Qt provides three important APIs.

---

## raise()

Moves the widget to the top.

```cpp
widget->raise();
```

Result:

```text
Top

↓

Widget
```

Typical uses:

* Floating tool panels
* Temporary overlays
* Selection handles

---

## lower()

Moves the widget behind its sibling widgets.

```cpp
widget->lower();
```

Useful for:

* Background decorations
* Watermarks
* Grid overlays

---

## stackUnder()

Places one widget directly underneath another sibling.

```cpp
widgetA->stackUnder(widgetB);
```

Conceptually:

```text
Top

↓

Widget B

↓

Widget A
```

This provides explicit control over sibling stacking.

---

# Z-Order Example

```text
Initial

Top

↓

Button

↓

Viewer

↓

Background
```

After:

```cpp
viewer->raise();
```

Result:

```text
Top

↓

Viewer

↓

Button

↓

Background
```

---

# 3. Event Propagation

Suppose:

```text
Main Window

↓

Viewer

↓

Crosshair Widget
```

Mouse click:

```text
Mouse

↓

Crosshair
```

If the child accepts the event:

```text
Event

↓

Crosshair

↓

Accepted
```

Processing stops.

If the child ignores the event:

```text
Mouse

↓

Crosshair

↓

Ignored

↓

Parent
```

Some event types can propagate when ignored, while others have different handling rules depending on the event class.

---

## Example

```cpp
void Crosshair::mousePressEvent(QMouseEvent *event)
{
    event->ignore();
}
```

The parent widget may then get an opportunity to handle the event.

---

# Event Flow

```text
Mouse Click

↓

Child Widget

↓

Accepted?

↓

Yes → Stop

↓

No

↓

Parent Widget

↓

Grandparent
```

---

# 4. Focus Chain

Only one widget normally has keyboard focus at a time.

Example:

```text
Line Edit

↓

Password

↓

Login Button
```

Press:

```text
Tab
```

Focus moves:

```text
Username

↓

Password

↓

Login

↓

Username
```

---

## Set Focus

```cpp
lineEdit->setFocus();
```

---

## Check Focus

```cpp
widget->hasFocus();
```

---

## Focus Policy

```cpp
widget->setFocusPolicy(
    Qt::StrongFocus);
```

Common policies:

| Policy            | Description                                                 |
| ----------------- | ----------------------------------------------------------- |
| `Qt::NoFocus`     | Never receives keyboard focus                               |
| `Qt::TabFocus`    | Focus via Tab key                                           |
| `Qt::ClickFocus`  | Focus by mouse click                                        |
| `Qt::StrongFocus` | Focus by Tab and mouse click                                |
| `Qt::WheelFocus`  | Also accepts focus through the mouse wheel where applicable |

---

# Focus Chain Example

```text
Main Window

↓

Name

↓

Age

↓

Address

↓

OK

↓

Cancel
```

Qt maintains an internal focus chain that users navigate with the keyboard.

---

# 5. Painting Hierarchy

Qt paints from parent to child.

Conceptually:

```text
Parent

↓

Background

↓

Child

↓

Grandchild
```

Typical sequence:

```text
Parent paintEvent()

↓

Child paintEvent()

↓

Grandchild paintEvent()
```

Each widget paints only its own area.

---

## Clipping

Children are clipped to the visible region of their parent.

Example:

```text
Parent

+-------------------+
|                   |
|   Child           |
|   +-----------+   |
|   | Visible   |   |
|   |           |   |
+---+-----------+---+
```

Anything outside the parent's drawable area is not shown.

---

# 6. Native Window Hierarchy

Conceptually:

```text
Operating System Window

↓

QMainWindow

↓

QWidget

↓

QPushButton
```

Usually only the top-level widget has an operating-system window handle.

Most child widgets are managed internally by Qt.

---

# 7. Large Widget Trees

Suppose:

```text
5000 Widgets
```

Qt can manage large widget hierarchies efficiently, but design still matters.

---

## Good Architecture

```text
Main Window

↓

Panels

↓

Controls
```

Reasonable depth.

---

## Poor Architecture

```text
Widget

↓

Widget

↓

Widget

↓

Widget

↓

Widget

↓

Button
```

Excessive nesting complicates maintenance and may increase layout and repaint overhead.

---

# Batch Updates

Suppose:

```cpp
button1->setText("A");

button2->setText("B");

button3->setText("C");
```

Each change may trigger updates.

When performing many modifications, temporarily disabling updates can reduce unnecessary repainting.

Example:

```cpp
parentWidget->setUpdatesEnabled(false);

// Update many child widgets

parentWidget->setUpdatesEnabled(true);
```

Qt will repaint again after updates are re-enabled.

---

# 8. Debugging Widget Hierarchies

Useful APIs:

```cpp
widget->parentWidget();
```

```cpp
widget->children();
```

```cpp
widget->geometry();
```

```cpp
widget->isVisible();
```

```cpp
widget->hasFocus();
```

These help diagnose ownership, visibility, and focus problems.

---

# Debug Example

```cpp
qDebug() << widget->objectName();

qDebug() << widget->parentWidget();

qDebug() << widget->geometry();
```

Giving important widgets meaningful `objectName()` values greatly improves debugging.

---

# 9. Qt Source Code Concepts

Conceptually:

```text
Parent

↓

children()

↓

Sort by Z-order

↓

Paint

↓

Dispatch Events

↓

Destroy Children
```

The actual implementation is considerably more complex, but this illustrates the overall flow.

---

# 10. Qt 5.15 vs Qt 6.11

| Feature           | Qt 5.15 | Qt 6.11 |
| ----------------- | ------- | ------- |
| Z-order APIs      | ✔       | ✔       |
| Focus Chain       | ✔       | ✔       |
| Widget Hierarchy  | ✔       | ✔       |
| Event Propagation | ✔       | ✔       |

There are no major behavioral changes in these areas between Qt 5.15 and Qt 6.11.

---

# 11. Best Practices

✅ Keep widget hierarchies shallow where practical.

✅ Use layouts instead of deeply nested container widgets.

✅ Assign meaningful `objectName()` values to important widgets.

✅ Use `raise()` and `lower()` only when needed.

✅ Disable updates temporarily during large UI changes.

---

# 12. Common Mistakes

### ❌ Deep widget nesting

Too many container widgets make layouts harder to understand and maintain.

---

### ❌ Calling `raise()` repeatedly

Frequent stacking changes can lead to unnecessary repainting.

---

### ❌ Ignoring focus management

Without proper focus policies, keyboard navigation becomes frustrating.

---

### ❌ Forgetting to re-enable updates

```cpp
widget->setUpdatesEnabled(false);
```

If updates are never re-enabled, the interface will stop repainting correctly.

---

# 13. Interview Questions

## Easy

1. What is Z-order?
2. What does `raise()` do?
3. What is the focus chain?

---

## Medium

1. Compare `raise()`, `lower()`, and `stackUnder()`.
2. Explain event propagation between parent and child widgets.
3. How does keyboard focus move?

---

## Hard

1. Explain the widget painting hierarchy.
2. Why are child widgets clipped to the parent?
3. How would you optimize a hierarchy containing thousands of widgets?

---

## Expert

1. Design the widget hierarchy for a Medical TPS with dockable panels and overlay widgets.
2. Explain how Qt manages stacking order internally.
3. Describe how painting, event delivery, and ownership interact within a QWidget hierarchy.

---

# 14. Architecture Diagram

```text
                 QMainWindow
                      │
      ┌───────────────┼────────────────┐
      ▼               ▼                ▼
   MenuBar        ToolBar         StatusBar
                      │
                      ▼
               CentralWidget
                      │
      ┌───────────────┼────────────────┐
      ▼               ▼                ▼
 Patient Tree     CT Viewer       DVH Widget
                      │
          ┌───────────┴───────────┐
          ▼                       ▼
     Dose Overlay          Crosshair Widget
```

---

# 🏥 Production Example — Treatment Planning System

```text
MainWindow
│
├── Menu Bar
├── Tool Bar
├── Patient Browser
├── Beam List
├── CT Viewer
│      ├── CT Image
│      ├── RT Structure Overlay
│      ├── Dose Heat Map
│      ├── Isodose Curves
│      ├── Crosshair
│      └── Measurement Tools
├── DVH Panel
├── Optimization Panel
└── Status Bar
```

When the doctor clicks inside the CT Viewer:

```text
Mouse Click
      │
      ▼
Crosshair Widget
      │
      ▼
Dose Overlay
      │
      ▼
CT Viewer
      │
      ▼
Main Window
```

Depending on which widget accepts or ignores the event, it may continue propagating through the hierarchy.

---

# 15. Revision Notes

* Z-order determines which overlapping widget appears on top.
* `raise()`, `lower()`, and `stackUnder()` control stacking.
* Events are delivered to the target widget and may propagate depending on the event type and whether they are accepted.
* Only one widget normally has keyboard focus.
* Qt paints widgets hierarchically from parent to child.
* Child widgets are clipped to their parent's visible region.
* Large widget trees should be organized thoughtfully and updated efficiently.

---

# 🎯 Chapter 36 Complete

You now have a complete understanding of **QWidget Hierarchy**, including:

* Parent-child relationships
* Ownership tree
* Visual hierarchy
* Z-order
* Event propagation
* Focus chain
* Painting hierarchy
* Large widget tree optimization
* Debugging techniques
* Qt 5 → Qt 6 compatibility

You now understand how Qt organizes, paints, manages, and destroys complex user interface hierarchies in professional desktop applications.

---

# 🚀 Next Chapter

## **Chapter 37 — Layout Management (Complete Deep Dive)**

