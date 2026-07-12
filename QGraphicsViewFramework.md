Excellent.

**Chapter 46 is one of the most powerful frameworks in Qt.**

Many developers confuse the **Qt Painting System** with the **Graphics View Framework**.

They are related, but they solve different problems.

| Qt Painting               | Graphics View                                     |
| ------------------------- | ------------------------------------------------- |
| Draw directly on a widget | Manage thousands or millions of graphical objects |
| Manual redraw             | Automatic scene management                        |
| Good for custom widgets   | Good for editors, CAD, GIS, TPS viewers           |
| Developer manages objects | Scene manages objects                             |

If your goal is to build a **Medical Treatment Planning System (TPS)**, **CAD software**, **PCB editor**, **diagram editor**, or **GIS application**, then `QGraphicsView` is one of the most important Qt frameworks to master.

---

# Complete Qt Master Course (Qt 5.15 LTS → Qt 6.11)

# PART VII — Graphics View Framework

# Chapter 46 — Graphics View Framework (Complete Deep Dive)

## Part 1 — QGraphicsScene, QGraphicsView, QGraphicsItem & Scene Architecture

> **Level:** Beginner → Expert

---

# Chapter Objectives

After completing this chapter, you will understand:

* What is the Graphics View Framework?
* `QGraphicsScene`
* `QGraphicsView`
* `QGraphicsItem`
* Scene architecture
* Coordinate systems
* Scene lifecycle
* Rendering flow
* Qt 5 vs Qt 6

---

# Table of Contents

1. Introduction
2. Graphics View Architecture
3. QGraphicsScene
4. QGraphicsView
5. QGraphicsItem
6. Coordinate Systems
7. Scene Lifecycle
8. Rendering Pipeline
9. Qt Source Code Concepts
10. Qt 5 vs Qt 6
11. Best Practices
12. Interview Questions
13. Revision Notes

---

# 1. Introduction

The Graphics View Framework is designed for applications that need to manage many graphical objects efficiently.

Examples:

* CAD software
* Medical TPS viewers
* Circuit editors
* Flowchart editors
* GIS applications
* Game editors
* Robotics simulators

Instead of drawing everything manually, you create **items** and add them to a **scene**.

---

# 2. Graphics View Architecture

Qt separates responsibilities into three main classes.

```text
          QGraphicsView
                 │
                 ▼
          QGraphicsScene
                 │
                 ▼
         QGraphicsItem
```

Responsibilities:

| Class            | Responsibility                  |
| ---------------- | ------------------------------- |
| `QGraphicsView`  | Displays the scene              |
| `QGraphicsScene` | Stores and manages items        |
| `QGraphicsItem`  | Represents an individual object |

---

## Architecture Diagram

```text
User

↓

Graphics View

↓

Graphics Scene

↓

Graphics Items

↓

Painter

↓

Screen
```

---

# 3. QGraphicsScene

The scene is the container for graphical objects.

Header:

```cpp
#include <QGraphicsScene>
```

Create:

```cpp
QGraphicsScene *scene =
    new QGraphicsScene(this);
```

Think of the scene as an infinite drawing canvas.

---

## Adding Items

Example:

```cpp
scene->addRect(0,0,100,50);

scene->addEllipse(50,50,40,40);

scene->addLine(0,0,200,200);
```

Result:

```text
Rectangle

Circle

Line
```

Each object becomes an independent graphics item.

---

# 4. QGraphicsView

The view displays the scene.

Header:

```cpp
#include <QGraphicsView>
```

Create:

```cpp
QGraphicsView *view =
    new QGraphicsView(scene);
```

The view does not own the objects directly.

It simply displays part of the scene.

---

Visualization:

```text
Large Scene

+---------------------------------------+

Entire World

+---------------------------------------+

↓

View

+---------------+

Visible Area

+---------------+
```

---

# Multiple Views

One scene can have multiple views.

```text
Scene

↓

View 1

↓

View 2

↓

View 3
```

Example:

Medical TPS

```text
Scene

↓

Axial View

↓

Sagittal View

↓

Coronal View
```

All views display the same underlying scene from different perspectives or with different transformations.

---

# 5. QGraphicsItem

Every object inside the scene is a `QGraphicsItem` (or a derived class).

Inheritance (simplified):

```text
QGraphicsItem
     │
     ├── QGraphicsRectItem
     ├── QGraphicsEllipseItem
     ├── QGraphicsPixmapItem
     ├── QGraphicsTextItem
     ├── QGraphicsLineItem
     └── Custom Item
```

Example:

```cpp
QGraphicsRectItem *rect =
    scene->addRect(0,0,100,50);
```

The returned item can later be modified.

---

## Common Item Types

```text
Rectangle

Ellipse

Line

Polygon

Pixmap

Text

Path
```

---

# 6. Coordinate Systems

Graphics View uses multiple coordinate systems.

```text
Screen Coordinates

↓

View Coordinates

↓

Scene Coordinates

↓

Item Coordinates
```

Each has a different purpose.

---

## Scene Coordinates

Example:

```text
(0,0)

↓

Center of Scene Region
```

An item may exist at:

```text
(5000,3000)
```

even if it is not currently visible in the view.

---

## Item Coordinates

Each item has its own local coordinate system.

```text
Item

(0,0)

↓

Local Origin
```

This simplifies transformations and drawing within the item.

---

# 7. Scene Lifecycle

Typical workflow:

```text
Create Scene

↓

Create View

↓

Create Items

↓

Add Items

↓

Show View

↓

User Interaction

↓

Update Scene

↓

Render
```

---

# 8. Rendering Pipeline

Conceptually:

```text
Graphics View

↓

Visible Region

↓

Graphics Scene

↓

Visible Items

↓

QPainter

↓

Screen
```

Only items that intersect the visible region generally need to be painted.

---

# 9. Qt Source Code Concepts

Internally:

```text
QGraphicsView

↓

Determine Visible Area

↓

Query Scene

↓

Retrieve Visible Items

↓

Sort by Z Value

↓

Paint Items
```

This makes rendering efficient even for large scenes.

---

# 10. Qt 5.15 vs Qt 6.11

| Feature        | Qt 5.15 | Qt 6.11 |
| -------------- | ------- | ------- |
| QGraphicsScene | ✔       | ✔       |
| QGraphicsView  | ✔       | ✔       |
| QGraphicsItem  | ✔       | ✔       |
| Multiple Views | ✔       | ✔       |

The Graphics View Framework is stable across Qt versions.

---

# 11. Best Practices

✅ Keep business logic separate from graphics items.

✅ Store graphical objects in the scene rather than manually managing painting.

✅ Use custom `QGraphicsItem` subclasses for reusable graphics.

✅ Use scene coordinates for object placement.

---

# 12. Common Mistakes

### ❌ Drawing everything manually

Instead, represent objects as graphics items whenever appropriate.

---

### ❌ Putting application logic inside paint code

Graphics items should primarily manage their visual representation and interaction.

---

### ❌ Forgetting coordinate system differences

Scene, view, and item coordinates are not interchangeable.

---

# 13. Interview Questions

## Easy

1. What is `QGraphicsScene`?
2. What is `QGraphicsView`?
3. What is `QGraphicsItem`?

---

## Medium

1. Explain the relationship between the scene, view, and item.
2. Why can one scene have multiple views?
3. What coordinate systems exist in the Graphics View Framework?

---

## Hard

1. Explain the rendering pipeline.
2. Describe how visible items are determined.
3. Why is Graphics View more suitable than manual painting for large editors?

---

## Expert

1. Design the graphics architecture for a Treatment Planning System using `QGraphicsScene`.
2. Explain how three synchronized medical image views could share one underlying model while using different `QGraphicsView` instances.
3. Compare the Graphics View Framework with direct painting using `QPainter`.

---

# 14. Architecture Diagram

```text
                    Application
                          │
                          ▼
                  QGraphicsScene
            ┌─────────────┼─────────────┐
            ▼             ▼             ▼
      Rect Item     Pixmap Item    Text Item
            │             │             │
            └─────────────┼─────────────┘
                          ▼
                   QGraphicsView
                          │
                          ▼
                     QPainter
                          │
                          ▼
                        Screen
```

---

# 🏥 Production Example — Treatment Planning System

```text
QGraphicsScene
│
├── CT Image (Pixmap Item)
├── Dose Overlay (Custom Item)
├── Organ Contours (Path Items)
├── Beam Geometry (Line Items)
├── Isocenter Marker
├── Measurement Tools
├── Annotation Text
└── Selection Handles
```

Rendering order:

```text
CT Image

↓

Dose Overlay

↓

Contours

↓

Beam Geometry

↓

Annotations

↓

Selection
```

Each visual component is an independent graphics item, making updates, selection, and interaction much easier than redrawing everything manually.

---

# 15. Revision Notes

* `QGraphicsScene` manages graphical objects.
* `QGraphicsView` displays a scene.
* `QGraphicsItem` represents an individual object.
* One scene can be displayed by multiple views.
* Graphics View uses scene, view, and item coordinate systems.
* The framework automatically renders visible items efficiently.
* Custom graphics items are the preferred way to implement specialized visual objects.

---

Excellent.

This is the **most advanced chapter of the Graphics View Framework**.

After this chapter, you'll understand how professional software such as:

* Qt Creator (designer components)
* AutoCAD
* Adobe Illustrator
* Blender (2D editors)
* KiCad
* Altium Designer
* Medical Treatment Planning Systems (TPS)
* 3D Slicer (2D slice interaction)

implements **selection, dragging, transformations, collision detection, custom graphics items, and high-performance rendering**.

These concepts are heavily used in enterprise engineering applications.

---

# Complete Qt Master Course (Qt 5.15 LTS → Qt 6.11)

# PART VII — Graphics View Framework

# Chapter 46 — Graphics View Framework (Complete Deep Dive)

## Part 2 — Custom Items, Transformations, Selection, Collision Detection & Performance

> **Level:** Advanced → Expert

---

# Chapter Objectives

After completing this chapter, you will understand:

* Custom `QGraphicsItem`
* Item transformations
* Selection
* Dragging
* Mouse & keyboard events
* Collision detection
* Z-order
* Grouping
* Animation
* Performance optimization

---

# Table of Contents

1. Custom Graphics Items
2. Item Transformations
3. Selection
4. Dragging
5. Event Handling
6. Collision Detection
7. Z-Order
8. Item Groups
9. Animation
10. Performance Optimization
11. Qt Internals
12. Qt 5 vs Qt 6
13. Best Practices
14. Interview Questions
15. Revision Notes

---

# 1. Custom Graphics Items

Qt provides built-in items such as rectangles and ellipses, but real applications usually define their own.

Examples:

* CT Slice Item
* Dose Overlay Item
* Beam Item
* MLC Item
* Annotation Item
* Measurement Tool
* Organ Contour Item

---

## Create Custom Item

Derive from `QGraphicsItem`.

```cpp
class DoseItem : public QGraphicsItem
{
public:
    QRectF boundingRect() const override;
    void paint(QPainter *,
               const QStyleOptionGraphicsItem *,
               QWidget *) override;
};
```

Every custom item must implement:

* `boundingRect()`
* `paint()`

---

# boundingRect()

Defines the area occupied by the item.

```cpp
QRectF boundingRect() const override
{
    return QRectF(0,0,200,200);
}
```

Qt uses this rectangle for:

* Painting
* Selection
* Collision detection
* Update optimization

---

# paint()

Draw the item.

```cpp
void paint(...)
{
    painter->drawEllipse(...);
}
```

Qt automatically calls `paint()` when the item needs repainting.

---

# 2. Item Transformations

Every graphics item has its own transformation.

---

## Move

```cpp
item->setPos(100,200);
```

---

## Rotate

```cpp
item->setRotation(45);
```

---

## Scale

```cpp
item->setScale(2.0);
```

---

## Transform Origin

```cpp
item->setTransformOriginPoint(
    item->boundingRect().center());
```

Rotation now occurs around the center.

---

Transformation pipeline:

```text
Local Coordinates

↓

Scale

↓

Rotate

↓

Translate

↓

Scene Coordinates
```

---

# 3. Selection

Enable selection:

```cpp
item->setFlag(
    QGraphicsItem::ItemIsSelectable);
```

Result:

```text
Click

↓

Selected

↓

Highlight
```

---

Multiple selection:

```text
Ctrl + Click

↓

Item A

Item B

Item C
```

Retrieve selection:

```cpp
scene->selectedItems();
```

---

# TPS Example

```text
Doctor Selects

↓

Beam

↓

Highlight Beam

↓

Show Beam Properties
```

---

# 4. Dragging

Enable movement:

```cpp
item->setFlag(
    QGraphicsItem::ItemIsMovable);
```

Result:

```text
Mouse Drag

↓

Move Item

↓

Update Scene
```

Useful for:

* Beam positioning
* Annotation placement
* ROI editing
* Diagram editing

---

# 5. Event Handling

Every graphics item can receive events.

Override:

```cpp
mousePressEvent()

mouseMoveEvent()

mouseReleaseEvent()

hoverEnterEvent()

hoverLeaveEvent()

keyPressEvent()
```

Example:

```cpp
void DoseItem::mousePressEvent(
    QGraphicsSceneMouseEvent *event)
{
}
```

Flow:

```text
Mouse

↓

Graphics View

↓

Scene

↓

Graphics Item

↓

Event Handler
```

---

# 6. Collision Detection

Qt can detect intersections automatically.

Example:

```cpp
item->collidesWithItem(otherItem);
```

Result:

```text
Beam

↓

Organ

↓

Collision

↓

Warning
```

Retrieve all collisions:

```cpp
scene->collidingItems(item);
```

---

Applications:

* CAD
* Robotics
* PCB Design
* Medical Planning
* Games

---

# 7. Z-Order

Controls drawing order.

Example:

```cpp
item->setZValue(10);
```

Higher value:

```text
Front
```

Lower value:

```text
Back
```

Example:

```text
Dose Overlay

↓

Contours

↓

Annotations
```

---

Visualization:

```text
Z = 100

Annotation

------------

Z = 50

Contour

------------

Z = 0

CT Image
```

---

# 8. Item Groups

Group items:

```cpp
scene->createItemGroup(items);
```

Result:

```text
Rectangle

Circle

Arrow

↓

One Group
```

Move:

```text
Entire Group
```

Destroy group:

```cpp
scene->destroyItemGroup(group);
```

---

# 9. Animation

Qt supports animation through the Graphics View framework.

Move:

```text
Position

↓

Position

↓

Position

↓

Smooth Motion
```

Rotation:

```text
0°

↓

45°

↓

90°
```

Typical uses:

* Robot simulation
* Beam movement
* Diagram transitions
* Educational software

---

# 10. Performance Optimization

Professional applications may display:

```text
100

1,000

10,000

100,000

1,000,000
```

graphics items.

Optimization becomes essential.

---

## Use Bounding Rectangles

Keep `boundingRect()` accurate.

Too large:

```text
Large Repaint
```

Too small:

```text
Drawing Errors
```

---

## Update Only Changed Items

Instead of:

```text
Entire Scene
```

update only the modified item or region.

---

## Cache

```cpp
item->setCacheMode(
    QGraphicsItem::DeviceCoordinateCache);
```

Useful for complex static items.

---

## Item Indexing

`QGraphicsScene` supports indexing methods to speed up item lookup and collision queries.

Choose an indexing strategy appropriate for your application's workload.

---

# 11. Enterprise TPS Example

Scene:

```text
Scene

↓

CT Image

↓

Dose Overlay

↓

Structures

↓

Beam Geometry

↓

MLC

↓

Crosshair

↓

Text
```

Interaction:

```text
Doctor Clicks Beam

↓

Beam Selected

↓

Property Panel Updated

↓

Dose Recomputed

↓

Scene Updated
```

---

# 12. Qt Internals

Rendering pipeline:

```text
Graphics View

↓

Visible Region

↓

Scene

↓

Visible Items

↓

Sort By Z

↓

paint()

↓

QPainter

↓

Screen
```

Interaction pipeline:

```text
Mouse Event

↓

Graphics View

↓

Scene

↓

Hit Test

↓

Top Item

↓

mousePressEvent()
```

---

# 13. Qt 5.15 vs Qt 6.11

| Feature             | Qt 5.15 | Qt 6.11 |
| ------------------- | ------- | ------- |
| Custom Items        | ✔       | ✔       |
| Selection           | ✔       | ✔       |
| Collision Detection | ✔       | ✔       |
| Z-Order             | ✔       | ✔       |
| Item Groups         | ✔       | ✔       |
| Animation Support   | ✔       | ✔       |

The Graphics View API remains stable across versions.

---

# 14. Best Practices

✅ Keep each graphics item responsible for a single visual object.

✅ Implement accurate `boundingRect()` values.

✅ Use Z-values to define clear rendering layers.

✅ Cache expensive static graphics.

✅ Separate rendering logic from application logic.

✅ Use scene indexing for large scenes.

---

# 15. Common Mistakes

### ❌ Returning an incorrect `boundingRect()`

This can cause repaint artifacts or incorrect collision detection.

---

### ❌ Performing heavy calculations inside `paint()`

Render quickly; compute elsewhere.

---

### ❌ Creating one giant graphics item

Break complex scenes into logical items.

---

### ❌ Ignoring item transformations

Remember that each item has its own local coordinate system and transformation.

---

# 16. Interview Questions

## Easy

1. What is a custom `QGraphicsItem`?
2. What does `boundingRect()` do?
3. How do you make an item movable?

---

## Medium

1. Explain Z-order.
2. How does collision detection work?
3. Compare scene coordinates and item coordinates.

---

## Hard

1. Explain the Graphics View rendering pipeline.
2. How would you optimize a scene containing 100,000 items?
3. Why is `boundingRect()` critical for performance?

---

## Expert

1. Design the Graphics View architecture for a Treatment Planning System containing CT images, organ contours, beams, dose overlays, annotations, and measurement tools.
2. Explain how hit testing identifies the top-most graphics item under the mouse.
3. Compare Graphics View with custom `QPainter`-based rendering for interactive engineering software.

---

# 17. Architecture Diagram

```text
                    QGraphicsView
                           │
                           ▼
                   QGraphicsScene
        ┌──────────────┼──────────────┐
        ▼              ▼              ▼
   CT Image      Dose Overlay     Beam Item
        │              │              │
        ├──────────────┼──────────────┤
        ▼              ▼              ▼
   Contours      Annotation      Measurement
        │
        ▼
   QPainter::paint()
        │
        ▼
       Screen
```

---

# 🏥 Production Example — Treatment Planning System

```text
QGraphicsScene
│
├── CT Image (Pixmap Item)
├── Dose Heatmap (Custom Item)
├── Organ Contours (Path Items)
├── Beam Geometry (Custom Item)
├── MLC Leaves (Graphics Items)
├── Isocenter Marker
├── Measurement Tool
├── Annotation Text
└── Selection Handles
```

User workflow:

```text
Doctor Selects Beam
        │
        ▼
Beam Highlighted
        │
        ▼
Beam Properties Updated
        │
        ▼
Dose Recalculated
        │
        ▼
Dose Overlay Repainted
        │
        ▼
Scene Rendered
```

This modular design makes it easier to update individual components without redrawing unrelated objects, resulting in a responsive interface even for complex scenes.

---

# 18. Revision Notes

* Derive from `QGraphicsItem` to create custom graphics objects.
* Implement `boundingRect()` and `paint()`.
* Use item flags to enable selection and dragging.
* Each item has its own coordinate system and transformation.
* `setZValue()` controls drawing order.
* `collidesWithItem()` and `collidingItems()` support collision detection.
* Group related items when they should move together.
* Optimize large scenes with accurate bounding rectangles, caching, and appropriate scene indexing.

---

# 🚀 Next Chapter

## **Chapter 47 — Model/View Architecture (Complete Deep Dive)**

