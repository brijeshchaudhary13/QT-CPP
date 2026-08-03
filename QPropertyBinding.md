# Complete Qt Master Course (Qt 5.15 LTS → Qt 6.11)

# PART XII — QML & Qt Quick

# Chapter 89 — Property Binding (Complete Deep Dive)


---

# 1. Introduction

**Property Binding** is the core feature that makes QML reactive.

Instead of manually updating UI values whenever data changes, you declare a relationship between properties.

When the source changes, Qt automatically updates the dependent property.

---

## Without Property Binding

```text id="pb01"
Data Changes

↓

Call update()

↓

UI Changes
```

The developer is responsible for every update.

---

## With Property Binding

```text id="pb02"
Data Changes

↓

Binding

↓

UI Updates Automatically
```

This reduces boilerplate code and keeps the UI synchronized with data.

---

# 2. What is Property Binding?

A property can depend on another property.

Example

```qml id="pb03"
Rectangle
{
    width: parent.width
}
```

Whenever `parent.width` changes,

the rectangle width changes automatically.

---

Another example

```qml id="pb04"
Text
{
    text: patient.name
}
```

If `patient.name` changes,

the text updates automatically.

---

## Binding Flow

```text id="pb05"
Source Property

↓

Binding

↓

Target Property
```

---

# 3. Reactive Programming

QML follows the **reactive programming** model.

The UI reacts to changes instead of polling for updates.

Traditional approach

```text id="pb06"
Data Changes

↓

Developer Updates UI
```

Reactive approach

```text id="pb07"
Data Changes

↓

Qt Detects Change

↓

UI Updated
```

---

## Advantages

* Less code
* Fewer bugs
* Automatic synchronization
* Easier maintenance

---

# 4. Dependency Tracking

Consider

```qml id="pb08"
width: parent.width / 2
```

Qt records that:

```text id="pb09"
width

↓

Depends On

↓

parent.width
```

When `parent.width` changes,

the binding is automatically re-evaluated.

---

Multiple dependencies

```qml id="pb10"
width:
parent.width -
margin
```

Dependencies

```text id="pb11"
parent.width

↓

Binding

↑

margin
```

Either property changing triggers a recalculation.

---

# 5. Binding Expressions

Bindings can be simple or complex.

Simple

```qml id="pb12"
height: 200
```

Bound

```qml id="pb13"
height:
parent.height
```

Expression

```qml id="pb14"
height:
parent.height - 20
```

Conditional

```qml id="pb15"
color:
enabled ?
"green" :
"gray"
```

Function

```qml id="pb16"
text:
fullName()
```

Qt tracks the properties accessed during binding evaluation.

---

# 6. One-Way Binding

Bindings are **one-way**.

Example

```qml id="pb17"
width:
parent.width
```

Changing the parent updates the child.

Changing the child

```qml id="pb18"
width = 100
```

does **not** update the parent.

---

Architecture

```text id="pb19"
Parent Width

↓

Child Width
```

Only one direction exists.

---

# 7. Breaking Bindings

This surprises many developers.

Original

```qml id="pb20"
width:
parent.width
```

Later

```qml id="pb21"
width = 300
```

Result

```text id="pb22"
Binding Removed

↓

Static Value
```

The property is no longer reactive.

---

Example

Before

```text id="pb23"
Parent = 500

↓

Child = 500
```

Assignment

```text id="pb24"
Child = 300
```

Later

```text id="pb25"
Parent = 700

↓

Child = 300
```

The binding has already been removed.

---

# 8. Restoring Bindings

Qt provides the `Qt.binding()` function.

Example

```qml id="pb26"
width = Qt.binding(function() {
    return parent.width
})
```

Now the property becomes reactive again.

---

Workflow

```text id="pb27"
Assignment

↓

Binding Lost

↓

Qt.binding()

↓

Binding Restored
```

---

# 9. Binding Type

QML also provides the `Binding` element.

Example

```qml id="pb28"
Binding {
    target: rectangle
    property: "width"
    value: parent.width
}
```

Advantages

* Enable/disable bindings
* Conditional bindings
* Dynamic binding management

---

Conditional example

```qml id="pb29"
Binding {
    target: rectangle
    property: "visible"
    value: backend.connected
    when: backend.enabled
}
```

The binding is active only while `when` evaluates to `true`.

---

# 10. Binding Loops

Incorrect

```qml id="pb30"
A.width:
B.width

B.width:
A.width
```

Result

```text id="pb31"
Loop

↓

Infinite Updates
```

Qt detects many binding loops and prints warnings such as:

```text id="pb32"
Binding loop detected
```

---

Avoid circular dependencies.

---

# 11. Property Change Notifications

Bindings depend on change notifications.

In C++

```cpp id="pb33"
Q_PROPERTY(
int value

READ value

WRITE setValue

NOTIFY valueChanged)
```

When

```cpp id="pb34"
emit valueChanged();
```

the engine knows to re-evaluate dependent bindings.

---

Flow

```text id="pb35"
Value Changed

↓

Signal

↓

Binding

↓

UI Updated
```

---

# 12. Dynamic Bindings

Sometimes bindings change at runtime.

Example

```qml id="pb36"
if(compactMode)
{
    width:
    200
}
```

Or

```qml id="pb37"
Binding
{
    when:
    compactMode
}
```

Applications

* Responsive layouts
* Themes
* User preferences
* Device orientation

---

# 13. Performance Optimization

Bindings are efficient, but unnecessary work can still hurt performance.

Good

```qml id="pb38"
text:
patient.name
```

Bad

```qml id="pb39"
text:
expensiveFunction()
```

if `expensiveFunction()` performs significant computation.

Move heavy work to C++.

---

Guidelines

* Keep binding expressions simple.
* Avoid expensive JavaScript inside bindings.
* Minimize unnecessary dependencies.

---

# 14. Enterprise Applications

## Medical TPS

```text id="pb40"
Dose Value

↓

Binding

↓

Dose Label
```

---

## Automotive

```text id="pb41"
Vehicle Speed

↓

Binding

↓

Speedometer
```

---

## Industrial HMI

```text id="pb42"
Temperature

↓

Binding

↓

Gauge
```

---

## Finance

```text id="pb43"
Stock Price

↓

Binding

↓

Chart
```

---

# 15. Qt Internals

```text id="pb44"
Property

↓

Dependency Tracker

↓

Binding Engine

↓

Target Property
```

Binding evaluation

```text id="pb45"
Property Changes

↓

NOTIFY Signal

↓

Dependency Graph

↓

Recalculate

↓

Update UI
```

Qt builds an internal dependency graph so that only affected bindings are re-evaluated.

---

# 16. Qt 5 vs Qt 6

| Feature             | Qt 5.15 | Qt 6.11                      |
| ------------------- | ------- | ---------------------------- |
| Property Binding    | ✔       | ✔                            |
| Binding Type        | ✔       | ✔                            |
| Qt.binding()        | ✔       | ✔                            |
| Dependency Tracking | ✔       | ✔                            |
| Binding Engine      | ✔       | ✔ (Performance improvements) |

The property binding model is consistent across Qt 5 and Qt 6, with ongoing engine optimizations in Qt 6.

---

# 17. Best Practices

✅ Prefer bindings over manual UI updates.

✅ Keep binding expressions lightweight.

✅ Emit `NOTIFY` signals correctly in C++.

✅ Avoid binding loops.

✅ Use the `Binding` element for conditional or dynamic bindings.

---

# 18. Common Mistakes

### ❌ Breaking Bindings Accidentally

```qml
width = 200
```

replaces the existing binding.

---

### ❌ Heavy JavaScript in Bindings

Bindings execute whenever dependencies change.

---

### ❌ Missing `NOTIFY` Signal

Without a `NOTIFY` signal, QML cannot know that a C++ property has changed.

---

### ❌ Circular Bindings

Avoid properties depending on each other.

---

### ❌ Updating UI Manually

Use bindings whenever possible instead of repeatedly assigning property values.

---

# 19. Interview Questions

## Easy

1. What is property binding?
2. What is reactive programming?
3. What breaks a binding?

---

## Medium

1. Explain dependency tracking.
2. What is `Qt.binding()`?
3. Why are `NOTIFY` signals important?

---

## Hard

1. Explain how QML detects which properties a binding depends on.
2. What causes a binding loop?
3. Compare manual updates with property bindings.

---

## Expert

1. Design a QML dashboard for a Treatment Planning System where dose values, DVH charts, beam parameters, and machine status update automatically using property bindings.
2. Explain the internal dependency graph used by the QML binding engine.
3. Compare QML property bindings with data binding systems in WPF, Flutter, and React.

---

# 20. Revision Notes

* Property bindings are the foundation of QML's reactive programming model.
* Bindings automatically synchronize dependent properties.
* Qt tracks property dependencies automatically.
* Bindings are one-way.
* Direct assignments replace bindings.
* `Qt.binding()` restores bindings dynamically.
* The `Binding` element enables conditional bindings.
* `NOTIFY` signals drive updates from C++.
* Avoid binding loops and expensive binding expressions.
* Qt optimizes binding evaluation using dependency tracking.

---

# 💡 Senior Engineer Tips

## Manual Updates vs Property Binding

| Manual Code            | Property Binding   |
| ---------------------- | ------------------ |
| More code              | Less code          |
| Easy to forget updates | Automatic          |
| Error-prone            | Reliable           |
| Harder to maintain     | Easier to maintain |

---

## Enterprise MVVM Architecture

```text id="pb46"
        View (QML)
             │
             ▼
     Property Bindings
             │
             ▼
     ViewModel (C++)
             │
             ▼
      Business Logic
             │
     ┌───────┼────────┐
     ▼       ▼        ▼
 Database  REST API  Devices
```

The **View** never pulls data manually. It reacts automatically through bindings exposed by the ViewModel.

---

## Medical TPS Example

```text id="pb47"
 Dose Engine
      │
      ▼
 ViewModel (QObject)
      │
 ┌────┼─────────┬──────────┐
 ▼    ▼         ▼          ▼
Dose DVH   Beam Angle  Machine Status
 │    │         │          │
 └────┼─────────┴──────────┘
      ▼
 QML Property Bindings
      │
      ▼
 Live Dashboard
```

Whenever the backend emits a `NOTIFY` signal:

* Dose values refresh automatically.
* DVH graphs update.
* Beam information changes.
* Machine status indicators react immediately.

No manual UI refresh calls are required.

---

## **Chapter 90 — Scene Graph (Complete Deep Dive)**

