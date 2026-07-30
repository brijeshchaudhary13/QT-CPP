# Complete Qt Master Course (Qt 5.15 LTS → Qt 6.11)

# PART VI — 2D Graphics & Rendering

# Chapter 53 — QGraphicsScene (Complete Deep Dive)

## Master Scene Management, Spatial Indexing, Collision Detection & Event Distribution

> **Level:** Intermediate → Expert

---

# Chapter Objectives

After completing this chapter, you will understand:

* What is `QGraphicsScene`?
* Why a scene is needed
* Scene architecture
* Scene rectangle (`sceneRect`)
* Adding, removing, and managing items
* Scene indexing
* Item lookup
* Selection management
* Collision detection
* Event distribution
* Scene layers
* Rendering updates
* Performance optimization
* Enterprise applications
* Qt Internals
* Qt 5.15 vs Qt 6.11
* Best practices
* Interview questions

---

# Table of Contents

1. Introduction
2. Why QGraphicsScene?
3. Scene Architecture
4. Creating a Scene
5. Scene Rectangle
6. Managing Items
7. Item Lookup
8. Selection Management
9. Collision Detection
10. Scene Events
11. Scene Layers
12. Rendering Updates
13. Performance Optimization
14. Enterprise Applications
15. Qt Internals
16. Qt 5 vs Qt 6
17. Best Practices
18. Common Mistakes
19. Interview Questions
20. Revision Notes

---

# 1. Introduction

`QGraphicsScene` is the **logical world** of the Graphics View Framework.

It does **not** display graphics directly.

Instead, it:

* Stores graphical items
* Manages their positions
* Handles selection
* Detects collisions
* Routes events
* Notifies views when changes occur

Think of the scene as a large virtual canvas that can be viewed from one or more windows.

---

## Simple Analogy

```text
City (Scene)

├── Buildings
├── Roads
├── Parks
├── Vehicles
└── People

↓

Camera (View)

↓

Visible Area
```

The city exists even if only a small portion is currently visible.

---

# 2. Why QGraphicsScene?

Without a scene:

```text
Widget

↓

Draw Everything

↓

Manually Track Objects

↓

Manually Handle Mouse

↓

Manually Detect Collisions
```

As the number of objects grows, this approach becomes difficult to maintain.

With `QGraphicsScene`:

```text
Scene

↓

Items

↓

Automatic Management

↓

Efficient Rendering

↓

Automatic Event Routing
```

---

# 3. Scene Architecture

The Graphics View Framework follows this structure:

```text
             User
               │
               ▼
        QGraphicsView
               │
         Displays Scene
               ▼
        QGraphicsScene
      ┌────────┼────────┐
      ▼        ▼        ▼
 Item A    Item B    Item C
```

### Responsibilities

| Component        | Responsibility               |
| ---------------- | ---------------------------- |
| `QGraphicsView`  | Displays the scene           |
| `QGraphicsScene` | Owns and manages items       |
| `QGraphicsItem`  | Represents graphical objects |

---

# 4. Creating a Scene

Header:

```cpp
#include <QGraphicsScene>
```

Create a scene:

```cpp
QGraphicsScene *scene = new QGraphicsScene(this);
```

Attach it to a view:

```cpp
QGraphicsView *view = new QGraphicsView(scene);
```

Now any item added to the scene can be displayed by the view.

---

# Scene Life Cycle

```text
Create Scene

↓

Add Items

↓

Connect View

↓

Display

↓

Update

↓

Destroy
```

---

# 5. Scene Rectangle

Every scene has a **scene rectangle**, which defines its logical boundaries.

Example:

```cpp
scene->setSceneRect(0, 0, 5000, 3000);
```

Visualization:

```text
Scene

+------------------------------------------+
|                                          |
|                                          |
|              Objects                     |
|                                          |
+------------------------------------------+

5000 × 3000 Logical Units
```

The scene rectangle does **not** have to match the window size.

---

## Retrieve the Scene Rectangle

```cpp
QRectF rect = scene->sceneRect();
```

Applications:

* CAD workspaces
* Large maps
* Medical images
* Diagram editors

---

# 6. Managing Items

Items are added directly to the scene.

---

## Add Rectangle

```cpp
scene->addRect(20, 20, 150, 80);
```

---

## Add Ellipse

```cpp
scene->addEllipse(50, 50, 100, 100);
```

---

## Add Text

```cpp
scene->addText("Qt Graphics");
```

---

## Add Image

```cpp
scene->addPixmap(pixmap);
```

---

## Add Custom Item

```cpp
scene->addItem(customItem);
```

---

## Remove Item

```cpp
scene->removeItem(item);
```

> **Important:** `removeItem()` detaches the item from the scene, but it does **not** delete the item. You are still responsible for deleting it if appropriate.

---

## Item Hierarchy

```text
Scene

├── Rectangle

├── Ellipse

├── Image

├── Text

└── Custom Beam
```

---

# 7. Item Lookup

Retrieve all items:

```cpp
QList<QGraphicsItem *> items =
    scene->items();
```

Find items at a position:

```cpp
scene->items(QPointF(120,80));
```

Visualization:

```text
Mouse Click

↓

Scene Position

↓

Find Items

↓

Return Matching Objects
```

Useful for:

* Selection
* Context menus
* Object inspection
* Editing tools

---

# 8. Selection Management

Enable selection:

```cpp
item->setFlag(
    QGraphicsItem::ItemIsSelectable);
```

Retrieve selected items:

```cpp
QList<QGraphicsItem *> selected =
    scene->selectedItems();
```

Clear selection:

```cpp
scene->clearSelection();
```

---

## Example

```text
Rectangle

Circle

Triangle

↓

Ctrl + Click

↓

Rectangle

Triangle

Selected
```

Applications:

* CAD
* Medical contour editing
* Diagram editors

---

# 9. Collision Detection

One of the most powerful features of `QGraphicsScene` is collision detection.

Example:

```cpp
QList<QGraphicsItem *> collisions =
    item->collidingItems();
```

Visualization:

```text
Rectangle

□□□□□

↓

Circle Moves

○

↓

Overlap

↓

Collision Detected
```

Applications:

* Games
* CAD
* Robotics
* Medical planning
* Interactive editors

---

## Typical Workflow

```text
Item Moves

↓

Scene Updates Position

↓

Collision Check

↓

Collision List Returned
```

---

# 10. Scene Events

The scene distributes events automatically.

Event flow:

```text
Mouse

↓

QGraphicsView

↓

QGraphicsScene

↓

Correct Item

↓

mousePressEvent()
```

Supported events include:

* Mouse press
* Mouse release
* Mouse move
* Double click
* Hover enter
* Hover leave
* Drag-and-drop
* Wheel events
* Keyboard events (via focused items)

---

# 11. Scene Layers

Although `QGraphicsScene` is conceptually one scene, applications often organize items into logical layers.

Example:

```text
Top Layer

Selection Handles

↓

Annotations

↓

Structures

↓

Dose Overlay

↓

CT Image

Bottom Layer
```

This is typically achieved using each item's **Z-value**.

Example:

```cpp
item->setZValue(100);
```

Higher Z-values are painted above lower ones.

---

# 12. Rendering Updates

Whenever something changes:

```text
Item Modified

↓

Scene Marks Region Dirty

↓

View Receives Update

↓

Visible Area Repainted
```

Qt repaints only the affected regions whenever possible, reducing unnecessary work.

---

# 13. Performance Optimization

## Spatial Indexing

`QGraphicsScene` can maintain an internal index to accelerate operations.

Conceptually:

```text
Scene

↓

Spatial Index

↓

Fast Item Lookup

↓

Fast Collision Detection
```

This avoids checking every item for every operation.

---

## Visible Item Rendering

```text
100,000 Items

↓

Visible Region

↓

Only Visible Items Painted
```

---

## Partial Updates

Only changed regions are redrawn.

```text
Small Object Changed

↓

Small Area Updated
```

---

## Avoid Excessive Item Recreation

Instead of:

```text
Delete Item

↓

Create Item

↓

Delete Item

↓

Create Item
```

Prefer:

```text
Update Existing Item
```

This reduces memory allocation and improves responsiveness.

---

# 14. Enterprise Applications

## Medical TPS

```text
Scene

├── CT Slice
├── MRI Overlay
├── Anatomical Structures
├── Dose Distribution
├── Beam Apertures
└── Measurement Tools
```

Each component can be independently selected, updated, and transformed.

---

## CAD

```text
Scene

↓

Grid

↓

Geometry

↓

Dimensions

↓

Annotations

↓

Selection Handles
```

---

## GIS

```text
Scene

↓

Terrain

↓

Roads

↓

Buildings

↓

Labels

↓

Routes
```

---

## Process Flow Editor

```text
Scene

↓

Nodes

↓

Connections

↓

Groups

↓

Comments
```

---

# 15. Qt Internals

## Item Storage

Conceptually:

```text
QGraphicsScene

↓

Item Collection

↓

Spatial Index

↓

Rendering

↓

View
```

---

## Event Pipeline

```text
Mouse Event

↓

QGraphicsView

↓

Coordinate Conversion

↓

QGraphicsScene

↓

Target Item

↓

Item Event Handler
```

---

## Rendering Pipeline

```text
Scene

↓

Visible Items

↓

Sort by Z-Value

↓

QPainter

↓

Viewport

↓

Screen
```

---

# 16. Qt 5 vs Qt 6

| Feature             | Qt 5.15 | Qt 6.11 |
| ------------------- | ------- | ------- |
| `QGraphicsScene`    | ✔       | ✔       |
| Spatial Indexing    | ✔       | ✔       |
| Collision Detection | ✔       | ✔       |
| Event Distribution  | ✔       | ✔       |
| Multiple Views      | ✔       | ✔       |

The `QGraphicsScene` API remains stable and fully supported in Qt 6.

---

# 17. Best Practices

✅ Use one scene for related graphical objects.

✅ Keep business logic outside scene management code.

✅ Reuse items instead of recreating them repeatedly.

✅ Set meaningful Z-values for layered rendering.

✅ Use scene coordinates consistently across the application.

---

# 18. Common Mistakes

### ❌ Confusing scene coordinates with view coordinates

Always know which coordinate space you're working in.

---

### ❌ Using `removeItem()` as if it deletes the object

`removeItem()` only removes the item from the scene.

---

### ❌ Adding too much logic to the scene

Keep `QGraphicsScene` focused on scene management, not business rules.

---

### ❌ Ignoring item ownership

Be clear about who owns dynamically allocated items and when they should be deleted.

---

# 19. Interview Questions

## Easy

1. What is `QGraphicsScene`?
2. What is the purpose of `sceneRect()`?
3. How do you add an item to a scene?

---

## Medium

1. Explain the relationship between `QGraphicsScene` and `QGraphicsView`.
2. How do you retrieve selected items?
3. How does collision detection work?

---

## Hard

1. Explain the event distribution pipeline in the Graphics View Framework.
2. How does spatial indexing improve performance?
3. Why is scene/view separation useful in large applications?

---

## Expert

1. Design the scene architecture for a Medical Treatment Planning System supporting CT images, dose overlays, beam apertures, and contour editing.
2. Explain how you would manage hundreds of thousands of graphical items efficiently.
3. Design a CAD scene supporting multiple layers, snapping, collision detection, and real-time interaction.

---

# 20. Revision Notes

* `QGraphicsScene` is the logical container for graphics items.
* It manages items, selection, collisions, and events.
* The scene rectangle defines the logical workspace.
* Items can be added, removed, and queried efficiently.
* Selection and collision detection are built into the framework.
* Scene updates trigger efficient partial repaints.
* Spatial indexing improves lookup and collision performance.
* Multiple views can display the same scene.

---

# 🎯 Chapter 53 Complete

You now understand:

* `QGraphicsScene`
* Scene architecture
* Scene rectangle
* Item management
* Selection handling
* Collision detection
* Event routing
* Scene layers
* Rendering updates
* Performance optimization
* Enterprise scene design
* Qt 5.15 vs Qt 6.11 compatibility

This chapter provides the foundation for managing large, interactive 2D scenes efficiently in professional applications.

---

# 🚀 Next Chapter

## **Chapter 54 — QGraphicsItem (Complete Deep Dive)**

In the next chapter, you'll learn:

* `QGraphicsItem` architecture
* Creating custom graphics items
* `boundingRect()`
* `paint()`
* Item flags
* Parent-child item hierarchy
* Coordinate mapping
* Transformations
* Item events
* Custom shapes and hit testing
* Caching
* Performance optimization
* Enterprise examples (Medical TPS, CAD, GIS, Diagram Editors)
* Qt Internals
* Best practices and interview questions
