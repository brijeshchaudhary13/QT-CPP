# Complete Qt Master Course (Qt 5.15 LTS → Qt 6.11)

# PART VI — 2D Graphics & Rendering

# Chapter 51 — Coordinate System (Complete Deep Dive)

## Master Qt Coordinate Systems, Transformations, QTransform & High-DPI Rendering

> **Level:** Intermediate → Expert

---

# Chapter Objectives

After completing this chapter, you will understand:

* What is a coordinate system?
* Logical vs Device Coordinates
* Qt Coordinate System
* World Coordinates
* Window & Viewport Mapping
* `QTransform`
* Translation
* Scaling
* Rotation
* Shearing
* Saving & Restoring Painter State
* Transformation Order
* High-DPI Rendering
* Enterprise Applications
* Qt Internals
* Qt 5.15 vs Qt 6.11
* Best Practices
* Interview Questions

---

# Table of Contents

1. Introduction
2. Why Coordinate Systems Matter
3. Qt Coordinate System
4. Logical vs Device Coordinates
5. Window and Viewport
6. World Transformations
7. QTransform
8. Translation
9. Scaling
10. Rotation
11. Shearing
12. Transformation Order
13. Saving & Restoring Painter State
14. High-DPI Rendering
15. Enterprise Applications
16. Qt Internals
17. Qt 5 vs Qt 6
18. Best Practices
19. Common Mistakes
20. Interview Questions
21. Revision Notes

---

# 1. Introduction

Every drawing operation in Qt happens at a **coordinate**.

For example:

```cpp
painter.drawPoint(100, 50);
```

Qt needs to know:

* Where is `(100, 50)`?
* Which direction is X?
* Which direction is Y?
* What happens after zooming or rotating?

These questions are answered by the **coordinate system**.

Without coordinate systems, rendering graphics accurately would be impossible.

---

# 2. Why Coordinate Systems Matter

Imagine drawing a rectangle:

```cpp
painter.drawRect(10, 10, 100, 50);
```

If the user zooms to **200%**, should the rectangle stay the same size?

If the canvas rotates **90°**, should the rectangle rotate too?

Qt solves these problems using coordinate transformations.

---

## Example

```text
Before Zoom

+----------------------+
|   ██████████         |
+----------------------+

↓

Zoom ×2

+----------------------+
| ██████████████████   |
+----------------------+
```

The drawing code remains the same; only the coordinate transformation changes.

---

# 3. Qt Coordinate System

By default, QWidget uses the following coordinate system:

```text
(0,0)
 +--------------------------→ X
 |
 |
 |
 |
 |
 ↓
 Y
```

Important points:

* Origin `(0,0)` is at the **top-left corner**.
* X increases to the **right**.
* Y increases **downwards**.

Example:

```text
(0,0)

+-----------------------+

        (100,50)

             ●

+-----------------------+
```

---

## Default Coordinates

| Direction | Value     |
| --------- | --------- |
| Left      | Smaller X |
| Right     | Larger X  |
| Top       | Smaller Y |
| Bottom    | Larger Y  |

---

# 4. Logical vs Device Coordinates

Qt distinguishes between **logical coordinates** and **device coordinates**.

## Logical Coordinates

These are the coordinates used in your code.

```cpp
painter.drawLine(0, 0, 100, 100);
```

Your application works entirely in logical coordinates.

---

## Device Coordinates

These are the actual screen pixels after all transformations have been applied.

Example:

```text
Logical Point

(50,50)

↓

Scale ×2

↓

Device Point

(100,100)
```

---

### Why This Separation?

It allows:

* Zooming
* Rotation
* High-DPI support
* Printing
* Different screen resolutions

without changing application logic.

---

# 5. Window and Viewport

Qt provides a mapping between a logical **window** and a physical **viewport**.

Conceptually:

```text
Logical Window

↓

Coordinate Mapping

↓

Viewport

↓

Screen
```

---

## Window

Represents the logical coordinate space.

Example:

```text
Window

0 → 1000
```

---

## Viewport

Represents the actual drawing area.

Example:

```text
Viewport

0 → 500 pixels
```

Qt automatically maps logical coordinates to the viewport.

---

# Example

```cpp
painter.setWindow(0, 0, 1000, 1000);

painter.setViewport(0, 0, 500, 500);
```

Result:

```text
1000 logical units

↓

500 pixels

↓

Scale = 0.5
```

---

# 6. World Transformations

A **world transformation** modifies the coordinate system before drawing.

Instead of moving every object manually:

```cpp
drawObject(x + 100, y);
```

You transform the coordinate system once:

```cpp
painter.translate(100, 0);

drawObject(x, y);
```

Every subsequent drawing command automatically uses the translated coordinates.

---

# 7. QTransform

`QTransform` stores transformation matrices.

Header:

```cpp
#include <QTransform>
```

Example:

```cpp
QTransform transform;

transform.translate(100, 0);

transform.rotate(45);

painter.setTransform(transform);
```

`QTransform` combines multiple operations into a single transformation matrix.

---

## Architecture

```text
Drawing

↓

QTransform

↓

Mapped Coordinates

↓

Paint Engine

↓

Screen
```

---

# 8. Translation

Translation moves the coordinate system.

Example:

```cpp
painter.translate(100, 50);
```

Visualization:

```text
Before

●

↓

Translate

            ●
```

Applications:

* Panning
* Moving diagrams
* Scrollable views

---

# 9. Scaling

Scaling changes size.

Example:

```cpp
painter.scale(2.0, 2.0);
```

Result:

```text
Original

□

↓

Scale ×2

■■
■■
```

Applications:

* Zoom
* Medical image enlargement
* CAD zoom
* Map viewers

---

# 10. Rotation

Rotate the coordinate system.

Example:

```cpp
painter.rotate(45);
```

Visualization:

```text
Before

□

↓

Rotate

◇
```

Applications:

* CAD
* GIS
* Robotics
* Compass displays

---

# 11. Shearing

Shearing slants objects.

Example:

```cpp
painter.shear(0.5, 0);
```

Visualization:

```text
Rectangle

████

↓

Shear

/////
```

Applications:

* Special visual effects
* Perspective-like transformations
* Graphics editors

---

# 12. Transformation Order

Transformation order is **important**.

Example A:

```cpp
translate();

rotate();
```

Example B:

```cpp
rotate();

translate();
```

These usually produce **different results**.

---

## Visualization

```text
Object

↓

Translate

↓

Rotate

↓

Result A
```

versus

```text
Object

↓

Rotate

↓

Translate

↓

Result B
```

Matrix multiplication is **not commutative**, so changing the order changes the final position and orientation.

---

# 13. Saving & Restoring Painter State

Complex applications often apply temporary transformations.

Qt provides:

```cpp
painter.save();
```

and

```cpp
painter.restore();
```

Example:

```cpp
painter.save();

painter.rotate(45);

// Draw object

painter.restore();
```

After `restore()`, the previous pen, brush, font, clip region, and transformation state are recovered.

---

## Workflow

```text
Current State

↓

save()

↓

Modify State

↓

Draw

↓

restore()

↓

Original State
```

---

# 14. High-DPI Rendering

Modern displays often have device pixel ratios greater than 1.

Example:

```text
Logical Size

100 × 100

↓

Device Pixel Ratio = 2

↓

200 × 200 Pixels
```

Qt helps applications remain resolution-independent by working in logical coordinates while handling the underlying scaling automatically where appropriate.

Benefits:

* Sharper graphics
* Better text quality
* Consistent UI across displays

---

# 15. Enterprise Applications

## Medical TPS

```text
CT Slice

↓

Zoom

↓

Pan

↓

Rotate

↓

Contour Editing
```

Transformations allow users to inspect anatomy without modifying the original image.

---

## CAD

```text
Drawing

↓

Zoom

↓

Rotate

↓

Measure
```

The underlying geometry remains unchanged; only the view is transformed.

---

## GIS

```text
Map

↓

Pan

↓

Zoom

↓

Rotate

↓

Display
```

---

## Scientific Charts

```text
Graph

↓

Scale

↓

Translate

↓

Display
```

Useful for inspecting data ranges interactively.

---

# 16. Qt Internals

Rendering flow:

```text
Logical Coordinates

↓

World Transform

↓

Window/Viewport Mapping

↓

Device Coordinates

↓

QPaintEngine

↓

Frame Buffer

↓

Screen
```

Each drawing command passes through this transformation pipeline before pixels are generated.

---

# 17. Qt 5 vs Qt 6

| Feature           | Qt 5.15 | Qt 6.11                           |
| ----------------- | ------- | --------------------------------- |
| Coordinate System | ✔       | ✔                                 |
| QTransform        | ✔       | ✔                                 |
| Translation       | ✔       | ✔                                 |
| Scaling           | ✔       | ✔                                 |
| Rotation          | ✔       | ✔                                 |
| Shearing          | ✔       | ✔                                 |
| High-DPI Support  | ✔       | ✔ (improved platform integration) |

The coordinate system APIs remain largely unchanged between Qt 5 and Qt 6.

---

# 18. Best Practices

✅ Work in logical coordinates instead of hard-coded screen pixels.

✅ Use `save()` and `restore()` around temporary transformations.

✅ Prefer transformations over manually modifying every object's coordinates.

✅ Keep transformation order intentional and well documented.

✅ Test rendering on both standard and High-DPI displays.

---

# 19. Common Mistakes

### ❌ Forgetting to restore painter state

Subsequent drawing operations may inherit unintended transformations.

---

### ❌ Assuming transformation order doesn't matter

Translation followed by rotation is not equivalent to rotation followed by translation.

---

### ❌ Mixing logical and device coordinates

This can lead to inconsistent rendering across displays.

---

### ❌ Hard-coding pixel values

Prefer logical coordinates and scalable layouts.

---

# 20. Interview Questions

## Easy

1. What is Qt's default coordinate system?
2. What is `QTransform`?
3. What does `translate()` do?

---

## Medium

1. Explain logical vs device coordinates.
2. What is the purpose of `save()` and `restore()`?
3. Compare scaling and translation.

---

## Hard

1. Explain window and viewport mapping.
2. Why does transformation order matter?
3. Describe the complete coordinate transformation pipeline in Qt.

---

## Expert

1. Design the coordinate system for a Medical Treatment Planning System that supports CT navigation, contour editing, zoom, and rotation without modifying patient data.
2. Explain how High-DPI rendering affects coordinate transformations.
3. Design a CAD viewer capable of smooth pan, zoom, and rotation using `QTransform`.

---

# 21. Revision Notes

* Qt's origin is at the top-left corner by default.
* Applications use logical coordinates; Qt maps them to device coordinates.
* `QTransform` manages coordinate transformations.
* Translation moves the coordinate system.
* Scaling changes size.
* Rotation changes orientation.
* Shearing skews objects.
* Transformation order affects the final result.
* `save()` and `restore()` simplify temporary state changes.
* High-DPI rendering relies on logical coordinates for resolution independence.

---

# 🎯 Chapter 51 Complete

You now understand:

* Qt coordinate systems
* Logical vs device coordinates
* Window and viewport mapping
* `QTransform`
* Translation, scaling, rotation, and shearing
* Transformation order
* Saving and restoring painter state
* High-DPI rendering
* Enterprise graphics workflows
* Qt 5.15 vs Qt 6.11 compatibility

This chapter gives you the mathematical and architectural foundation needed for advanced graphics programming in Qt.

---

# 🚀 Next Chapter

## **Chapter 52 — Graphics View Framework (Complete Deep Dive)**

In the next chapter, you'll begin learning Qt's powerful scene-graph architecture, including:

* Why the Graphics View Framework exists
* `QGraphicsView`
* `QGraphicsScene`
* `QGraphicsItem`
* Scene/View architecture
* Rendering thousands of objects efficiently
* Event propagation
* Selection, dragging, and transformations
* Performance optimizations
* Enterprise examples (Medical TPS, CAD, GIS, Diagram Editors)
* Qt 5.15 vs Qt 6.11
* Best practices and interview questions
