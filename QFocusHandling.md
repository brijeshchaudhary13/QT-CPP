# Complete Qt Master Course (Qt 5.15 LTS → Qt 6.11)

# PART V — Advanced Widget Architecture

# Chapter 48 — Focus Handling (Complete Deep Dive)

## Master Keyboard Focus, Focus Policies, Tab Order & Focus Management

> **Level:** Beginner → Expert

---

# Chapter Objectives

After completing this chapter, you will understand:

* What is keyboard focus?
* Focus architecture
* Focus policies (`Qt::FocusPolicy`)
* `setFocus()` and `clearFocus()`
* `focusInEvent()` and `focusOutEvent()`
* Focus chain
* Tab order
* Focus proxies
* Default buttons
* Focus management in custom widgets
* Accessibility considerations
* Enterprise use cases
* Qt 5.15 vs Qt 6.11
* Best practices
* Common mistakes
* Interview questions

---

# Table of Contents

1. Introduction
2. Focus Architecture
3. Keyboard Focus
4. Focus Policies
5. Setting and Clearing Focus
6. Focus Events
7. Focus Chain
8. Tab Order
9. Focus Proxies
10. Default Buttons
11. Focus Management in Custom Widgets
12. Accessibility and Keyboard Navigation
13. Enterprise Applications
14. Qt Internals
15. Qt 5 vs Qt 6
16. Best Practices
17. Common Mistakes
18. Interview Questions
19. Revision Notes

---

# 1. Introduction

Keyboard focus determines **which widget receives keyboard input**.

If the user types:

```text
Hello
```

Qt must know **where** those characters should go.

Example:

```text id="h1"
+---------------------------+
| Name: [John          ]    |
| Age : [25            ]    |
| City: [Pune          ]    |
+---------------------------+
```

If the cursor is inside **Name**, typing affects only the Name field.

If the cursor moves to **City**, typing affects only the City field.

Only **one widget** normally has keyboard focus at a time within an active window.

---

# 2. Focus Architecture

Qt manages focus through the widget hierarchy.

```text
Keyboard

↓

Operating System

↓

Qt Event Loop

↓

Focused Widget

↓

keyPressEvent()
```

Every key event is delivered to the widget that currently owns the keyboard focus.

---

# 3. Keyboard Focus

The focused widget is called the **focus widget**.

Retrieve it:

```cpp
QWidget *widget =
    QApplication::focusWidget();
```

Example:

```text
User Presses Tab

↓

Focus Changes

↓

Another Widget Receives Input
```

---

## Focus Example

```text
+----------------------+

Name: [John]

Age : [25]

City: [Pune]

+----------------------+
```

Current focus:

```text
Age
```

Typing:

```text
3
```

Result:

```text
Age = 253
```

because the **Age** field owns the keyboard focus.

---

# 4. Focus Policies

Every widget has a **focus policy**.

Set:

```cpp
widget->setFocusPolicy(
    Qt::StrongFocus);
```

---

## Available Policies

### NoFocus

```cpp
Qt::NoFocus
```

The widget never receives focus.

Example:

```text
Decoration Widget
```

---

### TabFocus

```cpp
Qt::TabFocus
```

Receives focus only by pressing **Tab**.

---

### ClickFocus

```cpp
Qt::ClickFocus
```

Receives focus only after a mouse click.

---

### StrongFocus

```cpp
Qt::StrongFocus
```

Supports:

* Mouse click
* Tab key

Most editable widgets use this policy.

---

### WheelFocus

```cpp
Qt::WheelFocus
```

Supports:

* Mouse wheel
* Tab
* Mouse click

Useful for widgets like spin boxes.

---

## Summary

| Policy      | Tab | Click | Wheel |
| ----------- | --- | ----- | ----- |
| NoFocus     | ✘   | ✘     | ✘     |
| TabFocus    | ✔   | ✘     | ✘     |
| ClickFocus  | ✘   | ✔     | ✘     |
| StrongFocus | ✔   | ✔     | ✘     |
| WheelFocus  | ✔   | ✔     | ✔     |

---

# 5. Setting and Clearing Focus

Give focus:

```cpp
widget->setFocus();
```

Remove focus:

```cpp
widget->clearFocus();
```

Check:

```cpp
widget->hasFocus();
```

Workflow:

```text
Widget

↓

setFocus()

↓

Focused

↓

Keyboard Input
```

---

# 6. Focus Events

Qt notifies widgets when focus changes.

---

## focusInEvent()

Called when a widget gains focus.

```cpp
void focusInEvent(
    QFocusEvent *event)
{
}
```

Applications:

* Highlight field
* Start editing
* Show caret

---

## focusOutEvent()

Called when focus is lost.

```cpp
void focusOutEvent(
    QFocusEvent *event)
{
}
```

Applications:

* Validate input
* Save changes
* Hide caret

---

Workflow:

```text
Focus Enter

↓

focusInEvent()

↓

Typing

↓

Focus Leaves

↓

focusOutEvent()
```

---

# 7. Focus Chain

Qt maintains an ordered list of focusable widgets.

Example:

```text
Name

↓

Age

↓

City

↓

Phone
```

Press:

```text
Tab
```

Result:

```text
Name

↓

Age

↓

City
```

Press:

```text
Shift + Tab
```

Result:

```text
City

↓

Age

↓

Name
```

---

# 8. Tab Order

Default order usually follows widget creation order.

Customize:

```cpp
QWidget::setTabOrder(
    widget1,
    widget2);
```

Example:

```text
Name

↓

Age

↓

Address

↓

Save Button
```

A good tab order improves usability and accessibility.

---

# 9. Focus Proxies

Sometimes a composite widget wants another child widget to receive focus.

Example:

```cpp
setFocusProxy(lineEdit);
```

Architecture:

```text
Composite Widget

↓

Focus Proxy

↓

Line Edit
```

Useful when creating reusable custom widgets.

---

# 10. Default Buttons

Dialogs often have a **default button**.

Example:

```text
+-----------------------+

Save

Cancel

+-----------------------+
```

Press:

```text
Enter
```

Result:

```text
Save
```

Enable:

```cpp
button->setDefault(true);
```

This improves keyboard usability.

---

# 11. Focus Management in Custom Widgets

Custom widgets should cooperate with Qt's focus system.

Typical steps:

* Set an appropriate focus policy.
* Reimplement focus events if needed.
* Paint a visual focus indicator.
* Process keyboard input in `keyPressEvent()`.

Example:

```text
Widget Receives Focus

↓

Draw Focus Border

↓

Accept Keyboard
```

---

# 12. Accessibility and Keyboard Navigation

Good keyboard navigation is essential.

Guidelines:

* Every important control should be reachable with the keyboard.
* Use logical tab order.
* Provide visible focus indicators.
* Do not rely only on mouse interaction.

Benefits:

* Accessibility
* Faster workflows
* Better usability

---

# 13. Enterprise Applications

## Medical TPS

```text
Patient Search

↓

Patient List

↓

Plan List

↓

Beam Table

↓

Dose Button
```

Doctors can work efficiently without constantly switching between keyboard and mouse.

---

## IDE

```text
Project Tree

↓

Editor

↓

Output Window

↓

Terminal
```

Keyboard shortcuts and focus transitions enable rapid development.

---

## CAD

```text
Property Panel

↓

Coordinate Input

↓

Command Line

↓

Drawing Area
```

---

## ERP

```text
Customer ID

↓

Name

↓

Address

↓

Submit
```

Efficient data entry depends on good focus management.

---

# 14. Qt Internals

Focus flow:

```text
Operating System

↓

Keyboard Event

↓

Qt Event Loop

↓

Focus Widget

↓

keyPressEvent()
```

Focus change:

```text
Current Widget

↓

focusOutEvent()

↓

Next Widget

↓

focusInEvent()
```

Qt ensures that focus transitions are consistent throughout the widget hierarchy.

---

# 15. Qt 5.15 vs Qt 6.11

| Feature        | Qt 5.15 | Qt 6.11 |
| -------------- | ------- | ------- |
| Focus Policies | ✔       | ✔       |
| Focus Events   | ✔       | ✔       |
| Tab Order      | ✔       | ✔       |
| Focus Proxy    | ✔       | ✔       |
| Default Button | ✔       | ✔       |

Focus handling APIs remain stable across Qt versions.

---

# 16. Best Practices

✅ Use `Qt::StrongFocus` for editable custom widgets.

✅ Define a logical tab order.

✅ Show a visible focus indicator.

✅ Validate user input when focus leaves a field if appropriate.

✅ Ensure all important controls are keyboard accessible.

---

# 17. Common Mistakes

### ❌ Forgetting to set a focus policy

A widget with `Qt::NoFocus` will never receive keyboard input.

---

### ❌ Poor tab order

Users should not have to jump unpredictably through the interface.

---

### ❌ Removing focus indicators

Users need to know where keyboard input will go.

---

### ❌ Performing heavy processing in `focusInEvent()`

Keep focus transitions fast and responsive.

---

# 18. Interview Questions

## Easy

1. What is keyboard focus?
2. What is `Qt::StrongFocus`?
3. What is `setFocus()`?

---

## Medium

1. Explain different focus policies.
2. What is a focus chain?
3. What is a focus proxy?

---

## Hard

1. Explain how keyboard events reach the focused widget.
2. How would you design keyboard navigation for a complex dialog?
3. Compare `focusInEvent()` and `focusOutEvent()`.

---

## Expert

1. Design the keyboard navigation for a Medical Treatment Planning System containing patient lists, beam editors, dose settings, and image viewers.
2. Explain how Qt maintains consistent focus across nested widgets.
3. Design a reusable custom widget with correct focus handling, keyboard navigation, and accessibility support.

---

# 19. Revision Notes

* Keyboard focus determines which widget receives keyboard input.
* Only one widget generally has keyboard focus within an active window.
* Focus policies control how widgets receive focus.
* `setFocus()` and `clearFocus()` manage focus programmatically.
* `focusInEvent()` and `focusOutEvent()` notify widgets of focus changes.
* Tab order improves keyboard navigation.
* Focus proxies allow composite widgets to redirect focus.
* Good focus management is essential for usability and accessibility.

---

# 🎯 Chapter 48 Complete

You now understand:

* Keyboard focus
* Focus policies
* `setFocus()` and `clearFocus()`
* Focus events
* Focus chains
* Tab order
* Focus proxies
* Default buttons
* Custom widget focus handling
* Accessibility
* Qt 5.15 vs Qt 6.11 compatibility

These concepts enable you to build professional Qt applications with intuitive keyboard navigation and accessible user interfaces.

---

# 🚀 Next Chapter

## **Chapter 49 — QPainter (Complete Deep Dive)**

In the next chapter, we'll begin the graphics and rendering section of your roadmap, covering:

* Introduction to `QPainter`
* Painting architecture
* `QPaintDevice`
* Basic drawing operations
* Pens (`QPen`)
* Brushes (`QBrush`)
* Colors (`QColor`)
* Fonts (`QFont`)
* Drawing lines, rectangles, ellipses, polygons, and text
* Painting lifecycle
* `paintEvent()`
* Double buffering
* Enterprise examples (Medical TPS, CAD, GIS, charting)
* Qt 5.15 vs Qt 6.11
* Best practices and interview questions

**From this point onward, we will continue following your roadmap exactly:**

* **49:** QPainter
* **50:** Paint Engine
* **51:** Coordinate System
* **52:** Graphics View Framework
* **53:** QGraphicsScene
* **54:** QGraphicsItem
* …and so on through **Chapter 160**.
