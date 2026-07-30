# Complete Qt Master Course (Qt 5.15 LTS → Qt 6.11)

# PART VI — 2D Graphics & Rendering

# Chapter 54 — QGraphicsItem (Complete Deep Dive)

## Master Custom Graphics Items, Painting, Event Handling & Interactive Scene Objects

> **Level:** Intermediate → Expert

---

# Chapter Objectives

After completing this chapter, you will understand:

* What is `QGraphicsItem`?
* Graphics Item Architecture
* Built-in Graphics Items
* Creating Custom Graphics Items
* `boundingRect()`
* `paint()`
* `shape()`
* Item Flags
* Parent-Child Hierarchy
* Item Coordinate Systems
* Item Transformations
* Item Events
* Z-Order
* Caching
* Performance Optimization
* Enterprise Applications
* Qt Internals
* Qt 5.15 vs Qt 6.11
* Best Practices
* Interview Questions

---

# Table of Contents

1. Introduction
2. Why QGraphicsItem?
3. Graphics Item Architecture
4. Built-in Graphics Items
5. Creating Custom Items
6. `boundingRect()`
7. `paint()`
8. `shape()`
9. Item Flags
10. Parent-Child Hierarchy
11. Coordinate Systems
12. Item Transformations
13. Item Events
14. Z-Order
15. Caching
16. Performance Optimization
17. Enterprise Applications
18. Qt Internals
19. Qt 5 vs Qt 6
20. Best Practices
21. Common Mistakes
22. Interview Questions
23. Revision Notes

---

# 1. Introduction

`QGraphicsItem` is the **base class for all objects displayed in a `QGraphicsScene`**.

Every visual object in the Graphics View Framework is either:

* A built-in graphics item, or
* A custom class derived from `QGraphicsItem`

Examples include:

* Rectangle
* Circle
* Image
* Text
* CAD objects
* Medical structures
* UML nodes
* Flowchart blocks

---

## Graphics View Architecture

```text
QGraphicsView
        │
        ▼
QGraphicsScene
        │
        ▼
QGraphicsItem
```

The **scene manages the items**, while **items are responsible for drawing themselves**.

---

# 2. Why QGraphicsItem?

Suppose you are developing a Medical Treatment Planning System (TPS).

You need to display:

* Beam aperture
* Isocenter marker
* CT contour
* Dose hotspot
* Measurement ruler

Each object:

* Draws differently
* Receives mouse events
* Can be selected
* Can be moved
* Can be rotated

Instead of storing everything in one large drawing function, each object becomes its own `QGraphicsItem`.

---

## Object-Oriented Graphics

```text
Beam Item

↓

paint()

↓

Mouse Events

↓

Selection

↓

Transformation
```

Each item manages its own behavior.

---

# 3. Graphics Item Architecture

```text
                 Scene
                   │
   ┌───────────────┼───────────────┐
   ▼               ▼               ▼
Rectangle      Beam Item      Image Item
```

Each item contains:

* Geometry
* Painting logic
* Event handling
* Transformations
* State

---

# 4. Built-in Graphics Items

Qt provides several ready-to-use item classes.

| Class                  | Purpose        |
| ---------------------- | -------------- |
| `QGraphicsRectItem`    | Rectangle      |
| `QGraphicsEllipseItem` | Circle/Ellipse |
| `QGraphicsLineItem`    | Line           |
| `QGraphicsPolygonItem` | Polygon        |
| `QGraphicsPixmapItem`  | Image          |
| `QGraphicsTextItem`    | Text           |
| `QGraphicsPathItem`    | Painter paths  |

Example:

```cpp
QGraphicsRectItem *rect =
    scene->addRect(20,20,100,60);
```

These classes are ideal for simple applications.

---

# 5. Creating Custom Items

Professional applications often require custom graphics.

Derive from `QGraphicsItem`.

```cpp
class BeamItem : public QGraphicsItem
{
public:
    QRectF boundingRect() const override;

    void paint(QPainter *painter,
               const QStyleOptionGraphicsItem *,
               QWidget *) override;
};
```

A custom item **must** implement:

* `boundingRect()`
* `paint()`

---

## Life Cycle

```text
Create Item

↓

Add To Scene

↓

Paint

↓

Events

↓

Destroy
```

---

# 6. `boundingRect()`

This function defines the item's logical boundary.

Example:

```cpp
QRectF BeamItem::boundingRect() const
{
    return QRectF(0,0,120,60);
}
```

---

## Why Is It Important?

Qt uses `boundingRect()` for:

* Repainting
* Collision detection
* Visibility testing
* Spatial indexing
* Item updates

---

## Visualization

```text
+---------------------------+
|                           |
|     Beam Aperture         |
|                           |
+---------------------------+

Bounding Rectangle
```

### Rule

The bounding rectangle **must completely contain everything painted by the item**.

---

# 7. `paint()`

Qt calls `paint()` whenever the item needs to be rendered.

Example:

```cpp
void BeamItem::paint(
    QPainter *painter,
    const QStyleOptionGraphicsItem *,
    QWidget *)
{
    painter->setPen(Qt::red);

    painter->drawRect(
        boundingRect());
}
```

Painting should only perform rendering.

Avoid expensive calculations inside `paint()`.

---

## Rendering Flow

```text
Scene

↓

Visible Item

↓

paint()

↓

QPainter

↓

Screen
```

---

# 8. `shape()`

`boundingRect()` defines the repaint area.

`shape()` defines the actual interactive area.

Example:

```cpp
QPainterPath BeamItem::shape() const
{
    QPainterPath path;

    path.addEllipse(boundingRect());

    return path;
}
```

---

## Why `shape()`?

Suppose you draw a circle.

```text
Bounding Rectangle

+---------+

    ○

+---------+
```

Clicking the corners of the rectangle should not select the circle.

Using `shape()` provides accurate hit testing.

---

Applications:

* CAD
* Medical contour editing
* Diagram editors

---

# 9. Item Flags

Flags enable built-in behavior.

Example:

```cpp
setFlag(
    ItemIsMovable);
```

Common flags:

| Flag                       | Purpose                |
| -------------------------- | ---------------------- |
| `ItemIsMovable`            | Drag item              |
| `ItemIsSelectable`         | Allow selection        |
| `ItemIsFocusable`          | Receive keyboard input |
| `ItemClipsToShape`         | Clip painting          |
| `ItemSendsGeometryChanges` | Notify movement        |

---

## Example

```cpp
setFlag(ItemIsSelectable);

setFlag(ItemIsMovable);
```

Result:

```text
Click

↓

Select

↓

Drag

↓

Move
```

No custom drag code is required for basic movement.

---

# 10. Parent-Child Hierarchy

Items can own other items.

Example:

```text
Robot

├── Body

├── Left Arm

├── Right Arm

└── Head
```

Code:

```cpp
childItem->setParentItem(parentItem);
```

Benefits:

* Automatic movement
* Automatic rotation
* Shared transformations
* Simplified scene management

---

# Example

```text
Parent Moves

↓

Children Move Automatically
```

---

# 11. Coordinate Systems

Every item has its own coordinate system.

```text
Local Coordinates

↓

Parent Coordinates

↓

Scene Coordinates

↓

View Coordinates
```

Example:

```text
Beam Item

Origin (0,0)

↓

Scene Position

(250,120)
```

The item draws itself using **local coordinates**, while the scene determines its final position.

---

# Coordinate Mapping

Useful functions include:

* `mapToScene()`
* `mapFromScene()`
* `mapToParent()`
* `mapFromParent()`

These help convert points between coordinate systems.

---

# 12. Item Transformations

Each item supports independent transformations.

Move:

```cpp
item->setPos(100,50);
```

Rotate:

```cpp
item->setRotation(30);
```

Scale:

```cpp
item->setScale(1.5);
```

Opacity:

```cpp
item->setOpacity(0.7);
```

Visualization:

```text
Item

↓

Translate

↓

Rotate

↓

Scale

↓

Display
```

Unlike widget painting, transformations are managed per item.

---

# 13. Item Events

`QGraphicsItem` can handle user interaction.

Common event handlers:

```cpp
mousePressEvent()

mouseMoveEvent()

mouseReleaseEvent()

hoverEnterEvent()

hoverLeaveEvent()

keyPressEvent()

wheelEvent()
```

---

## Event Flow

```text
Mouse Click

↓

QGraphicsView

↓

QGraphicsScene

↓

Target Item

↓

mousePressEvent()
```

---

## Example

```text
Click Beam

↓

Highlight Beam

↓

Show Properties
```

---

# 14. Z-Order

Items are painted according to their Z-value.

Example:

```cpp
item->setZValue(10);
```

Visualization:

```text
Z = 100

Selection Handles

↓

Beam

↓

CT Image

Z = 0
```

Higher Z-values appear above lower ones.

---

# 15. Caching

Frequently redrawn items can cache their rendered appearance.

Example:

```cpp
setCacheMode(
    DeviceCoordinateCache);
```

Benefits:

* Reduced repaint cost
* Faster scrolling
* Better performance for static items

Use caching only when the item's appearance changes infrequently.

---

# 16. Performance Optimization

## Keep `paint()` Lightweight

Bad:

```text
paint()

↓

Database Query

↓

Heavy Calculation

↓

Draw
```

Good:

```text
Prepare Data

↓

paint()

↓

Draw Only
```

---

## Accurate `boundingRect()`

A bounding rectangle that is much larger than necessary increases repaint work.

---

## Reuse Items

Instead of deleting and recreating items, update their properties.

---

## Use Caching Wisely

Cache:

* Icons
* Symbols
* Static annotations

Avoid caching highly dynamic objects.

---

# 17. Enterprise Applications

## Medical TPS

```text
Scene

├── CT Slice
├── Structure Item
├── Beam Item
├── Dose Item
└── Isocenter Item
```

Each object is a separate `QGraphicsItem` with its own painting and interaction logic.

---

## CAD

```text
Drawing

├── Line
├── Arc
├── Dimension
├── Text
└── Block
```

---

## GIS

```text
Map

├── Roads
├── Buildings
├── Rivers
└── Labels
```

---

## Diagram Editor

```text
Workflow

├── Node
├── Connector
├── Group
└── Comment
```

---

# 18. Qt Internals

Painting pipeline:

```text
Scene

↓

Visible Items

↓

Sort by Z-Value

↓

paint()

↓

QPainter

↓

Viewport

↓

Screen
```

---

Event pipeline:

```text
Mouse Event

↓

View

↓

Scene

↓

Hit Test

↓

shape()

↓

Target Item

↓

Event Handler
```

Notice that `shape()` is often used during hit testing, while `boundingRect()` is used for repainting and indexing.

---

# 19. Qt 5 vs Qt 6

| Feature         | Qt 5.15 | Qt 6.11 |
| --------------- | ------- | ------- |
| `QGraphicsItem` | ✔       | ✔       |
| Item Flags      | ✔       | ✔       |
| Transformations | ✔       | ✔       |
| Event Handling  | ✔       | ✔       |
| Caching         | ✔       | ✔       |

The `QGraphicsItem` API remains stable and fully supported in Qt 6.

---

# 20. Best Practices

✅ Keep each item responsible for one logical object.

✅ Implement `boundingRect()` accurately.

✅ Implement `shape()` for precise hit testing.

✅ Keep `paint()` fast and deterministic.

✅ Use parent-child relationships for grouped objects.

---

# 21. Common Mistakes

### ❌ Returning an incorrect `boundingRect()`

This can cause painting artifacts or clipped rendering.

---

### ❌ Performing business logic in `paint()`

Rendering should not trigger calculations, database access, or file I/O.

---

### ❌ Ignoring `shape()`

Complex items may become difficult to select accurately.

---

### ❌ Recreating items unnecessarily

Update existing items whenever possible.

---

# 22. Interview Questions

## Easy

1. What is `QGraphicsItem`?
2. Which two virtual functions must a custom item implement?
3. What is `boundingRect()` used for?

---

## Medium

1. Explain the difference between `boundingRect()` and `shape()`.
2. What are item flags?
3. How does event handling work for graphics items?

---

## Hard

1. Explain the rendering pipeline for a custom `QGraphicsItem`.
2. Why is `boundingRect()` critical for performance?
3. How do parent-child item relationships simplify scene management?

---

## Expert

1. Design a custom `BeamItem` for a Medical Treatment Planning System that supports selection, rotation, resizing, collision detection, and property editing.
2. Explain how `QGraphicsItem` enables efficient rendering of large CAD scenes.
3. Design a reusable graphics item framework for a diagram editor with snapping, grouping, and undo/redo support.

---

# 23. Revision Notes

* `QGraphicsItem` is the base class for graphical objects in a `QGraphicsScene`.
* Custom items must implement `boundingRect()` and `paint()`.
* `shape()` provides accurate hit testing.
* Item flags enable built-in interaction such as selection and movement.
* Each item has its own local coordinate system.
* Parent-child relationships simplify grouped transformations.
* Z-values determine drawing order.
* Caching can improve performance for static items.
* Keep painting code lightweight and efficient.

---

# 🎯 Chapter 54 Complete

You now understand:

* `QGraphicsItem` architecture
* Built-in and custom graphics items
* `boundingRect()`
* `paint()`
* `shape()`
* Item flags
* Parent-child hierarchies
* Coordinate mapping
* Transformations
* Item events
* Z-order
* Caching
* Performance optimization
* Enterprise applications
* Qt 5.15 vs Qt 6.11 compatibility

This chapter completes the core **Graphics View Framework** trilogy (`QGraphicsView`, `QGraphicsScene`, and `QGraphicsItem`) and prepares you for integrating hardware-accelerated rendering.

---

# 🚀 Next Chapter

## **Chapter 55 — OpenGL Integration (Complete Deep Dive)**

In the next chapter, you'll learn:

* Why integrate OpenGL with Qt
* `QOpenGLWidget`
* `QOpenGLFunctions`
* OpenGL rendering lifecycle
* Context creation and management
* Mixing `QPainter` with OpenGL
* Vertex buffers (VBOs)
* Shaders
* Texture rendering
* Performance considerations
* Enterprise examples (Medical TPS 3D, CAD, Scientific Visualization)
* Qt Internals
* Qt 5.15 vs Qt 6.11
* Best practices and interview questions
