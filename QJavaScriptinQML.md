# Complete Qt Master Course (Qt 5.15 LTS → Qt 6.11)

# PART XII — QML & Qt Quick

# Chapter 88 — JavaScript in QML (Complete Deep Dive)

## Master JavaScript in QML, Signal Handlers, Dynamic Objects, Property Bindings & Enterprise Qt Quick Development

> **Level:** Beginner → Architect


---

# 1. Introduction

QML includes a JavaScript engine that allows you to add logic directly to your user interface.

Typical uses:

* Button click handling
* Input validation
* UI calculations
* Animations
* State changes
* Small utility functions

JavaScript in QML is intended for **UI behavior**, while heavy business logic should remain in C++.

---

## Architecture

```text
QML UI
   │
   ▼
JavaScript Engine
   │
   ▼
Property Bindings
   │
   ▼
UI Updates
```

---

# 2. JavaScript Engine

Qt embeds a JavaScript engine inside the QML runtime.

```text
QML File

↓

JavaScript Code

↓

QML Engine

↓

Execution
```

The engine evaluates:

* Functions
* Expressions
* Property bindings
* Signal handlers

---

Example

```qml
Text {
    text: "Qt " + 6
}
```

Output

```text
Qt 6
```

---

# 3. Variables & Data Types

Variables

```qml
property int age: 25
```

Inside JavaScript

```qml
Component.onCompleted: {
    var x = 10
}
```

---

## Data Types

```qml
var number = 25
var name = "John"
var enabled = true
var value = 3.14
var obj = {}
var list = []
```

---

## typeof

```qml
console.log(typeof number)
```

Output

```text
number
```

---

# 4. Functions

Example

```qml
function add(a, b)
{
    return a + b
}
```

Usage

```qml
Component.onCompleted:
{
    console.log(add(2,3))
}
```

Output

```text
5
```

---

Functions can also return objects.

```qml
function person()
{
    return {
        name: "John",
        age: 30
    }
}
```

---

# 5. Scope

Variables follow scope rules.

Local variable

```qml
function test()
{
    var x = 5
}
```

`x` exists only inside the function.

---

Global (component-level)

```qml
property int counter: 0
```

Accessible throughout the QML component.

---

## Scope Hierarchy

```text
Application

↓

Component

↓

Function

↓

Local Variable
```

---

# 6. Arrays & Objects

## Array

```qml
var numbers = [1,2,3]
```

Access

```qml
numbers[0]
```

Loop

```qml
for(var i=0;i<numbers.length;i++)
{
    console.log(numbers[i])
}
```

---

## Object

```qml
var patient =
{
    name:"John",

    age:45
}
```

Access

```qml
patient.name
```

---

# 7. Conditions & Loops

If

```qml
if(age > 18)
{
    console.log("Adult")
}
```

---

Switch

```qml
switch(day)
{
case 1:

break;
}
```

---

For Loop

```qml
for(var i=0;i<10;i++)
{
}
```

---

While

```qml
while(x<10)
{
}
```

---

Use loops carefully in QML to avoid blocking the UI thread.

---

# 8. Signal Handlers

Signals are where JavaScript is most commonly used.

Example

```qml
Button
{
    text:"Login"

    onClicked:
    {
        console.log("Clicked")
    }
}
```

---

Workflow

```text
Button Click

↓

Signal

↓

JavaScript

↓

UI Update
```

---

Custom signal

```qml
signal loginSuccess()
```

Handler

```qml
onLoginSuccess:
{
}
```

---

# 9. Property Bindings

QML properties may contain JavaScript expressions.

Example

```qml
Rectangle
{
    width: parent.width/2
}
```

---

Another example

```qml
Text
{
    text:
    patient.name
}
```

Whenever the source property changes,

the UI updates automatically.

---

Binding Flow

```text
Property Changes

↓

JavaScript Expression

↓

Binding Re-evaluated

↓

UI Updated
```

---

## Breaking a Binding

Original

```qml
width: parent.width
```

Later

```qml
width = 200
```

The assignment removes the binding and replaces it with a fixed value.

---

# 10. Timers

Timer

```qml
Timer
{
    interval:1000

    repeat:true

    running:true

    onTriggered:
    {
    }
}
```

---

Applications

* Clock
* Animation
* Polling
* Splash screen

---

Workflow

```text
Timer

↓

Interval

↓

Trigger

↓

JavaScript
```

---

# 11. Dynamic Object Creation

Sometimes UI objects are created at runtime.

```qml
Qt.createComponent()
```

Create instance

```qml
component.createObject()
```

---

Workflow

```text
QML File

↓

Component

↓

Object

↓

Display
```

Applications

* Dialogs
* Popups
* Dynamic forms
* Notifications

---

# 12. JavaScript Files

Logic can be moved into separate `.js` files.

Example

```qml
import "utils.js" as Utils
```

File

```javascript
function add(a,b)
{
    return a+b
}
```

Usage

```qml
Utils.add(2,3)
```

Advantages

* Cleaner QML
* Reusable logic
* Better organization

---

# 13. JavaScript vs C++

| JavaScript        | C++     |   |
| ----------------- | ------- | - |
| UI Logic          | ✔       |   |
| Heavy Computation | ✘       |   |
| Networking        | Limited | ✔ |
| DICOM Processing  | ✘       | ✔ |
| Dose Calculation  | ✘       | ✔ |
| Animations        | ✔       |   |
| Business Logic    | Limited | ✔ |

---

## Recommended Architecture

```text
QML

↓

JavaScript

↓

C++
```

* **QML:** Presentation
* **JavaScript:** UI behavior
* **C++:** Business logic and performance-critical code

---

# 14. Enterprise Applications

## Medical TPS

```text
Dose Engine (C++)

↓

QML

↓

JavaScript

↓

Animation
```

---

## Automotive

```text
Vehicle Data

↓

Backend

↓

Dashboard Animation
```

---

## ERP

```text
REST

↓

Backend

↓

Charts
```

---

## Industrial HMI

```text
PLC

↓

Backend

↓

Alarm Popup
```

---

# 15. Qt Internals

```text
QML

↓

JavaScript Parser

↓

Bytecode / Internal Representation

↓

QML Engine

↓

Execution
```

Property binding

```text
Property

↓

Dependency Tracking

↓

JavaScript

↓

Result
```

The engine tracks dependencies so bindings are re-evaluated only when needed.

---

# 16. Qt 5 vs Qt 6

| Feature           | Qt 5.15 | Qt 6.11 |
| ----------------- | ------- | ------- |
| JavaScript Engine | ✔       | ✔       |
| Property Binding  | ✔       | ✔       |
| Timers            | ✔       | ✔       |
| Dynamic Creation  | ✔       | ✔       |
| .js Files         | ✔       | ✔       |

The JavaScript programming model is largely unchanged between Qt 5 and Qt 6.

---

# 17. Best Practices

✅ Keep JavaScript focused on UI logic.

✅ Move heavy computations to C++.

✅ Reuse helper functions in `.js` files.

✅ Prefer property bindings over manual updates.

✅ Keep signal handlers short.

---

# 18. Common Mistakes

### ❌ Heavy Computation in JavaScript

Bad

```qml
onClicked:
{
    calculateDose()
}
```

Large computations should execute in C++ (and often in a worker thread).

---

### ❌ Long Loops

Avoid loops that block the UI thread.

---

### ❌ Breaking Property Bindings Accidentally

Remember that assigning directly to a bound property removes the binding.

---

### ❌ Large Signal Handlers

Move complex logic into helper functions or C++.

---

### ❌ Duplicated Code

Use reusable JavaScript functions or `.js` modules.

---

# 19. Interview Questions

## Easy

1. Why is JavaScript used in QML?
2. What is a property binding?
3. How do you handle button clicks?

---

## Medium

1. Explain JavaScript scope in QML.
2. How do `.js` files improve organization?
3. What happens when a property binding is replaced by an assignment?

---

## Hard

1. Explain dynamic object creation in QML.
2. Compare JavaScript and C++ responsibilities in a Qt Quick application.
3. Describe how property bindings are evaluated efficiently.

---

## Expert

1. Design a QML-based Treatment Planning System interface where JavaScript manages UI interactions while C++ performs dose calculations and DICOM processing.
2. Explain how excessive JavaScript execution can affect UI responsiveness.
3. Compare JavaScript in QML with JavaScript in web browsers and discuss key architectural differences.

---

# 20. Revision Notes

* JavaScript provides UI behavior in QML.
* The QML engine executes JavaScript expressions and functions.
* Variables, arrays, objects, and functions are supported.
* Signal handlers commonly contain JavaScript.
* Property bindings are JavaScript expressions.
* Timers execute JavaScript periodically.
* Dynamic objects can be created at runtime.
* `.js` files improve code reuse.
* Heavy processing belongs in C++.
* Keep JavaScript lightweight and UI-focused.

---

# 💡 Senior Engineer Tips

## Where Should Code Go?

| Task             | QML | JavaScript | C++               |
| ---------------- | --- | ---------- | ----------------- |
| Button Layout    | ✅   | ❌          | ❌                 |
| Animation        | ✅   | ✅          | ❌                 |
| Input Validation | ❌   | ✅          | ✅ (complex cases) |
| DICOM Parsing    | ❌   | ❌          | ✅                 |
| Dose Calculation | ❌   | ❌          | ✅                 |
| REST Client      | ❌   | ❌          | ✅                 |
| UI State Changes | ✅   | ✅          | ❌                 |

---

## Enterprise QML Architecture

```text
             QML UI
                │
                ▼
      JavaScript UI Logic
                │
                ▼
        C++ ViewModel
                │
                ▼
      Business Services
                │
      ┌─────────┼─────────┐
      ▼         ▼         ▼
  REST API   Database   Devices
```

JavaScript should coordinate UI behavior, while C++ handles business rules and external systems.

---

## Medical TPS Example

```text
Treatment Planning System
          │
          ▼
      QML Dashboard
          │
     JavaScript
          │
 ┌────────┼─────────┐
 ▼        ▼         ▼
Button   Dialog   Animation
          │
          ▼
      C++ Backend
          │
 ┌────────┼────────────┐
 ▼        ▼            ▼
Dose Engine  DICOM  Registration
          │
          ▼
      Treatment Data
```

This layered design:

* Keeps the UI responsive.
* Separates presentation from computation.
* Makes testing and maintenance easier.
* Scales well as the application grows.

---



## **Chapter 89 — Property Binding (Complete Deep Dive)**

