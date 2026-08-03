# Complete Qt Master Course (Qt 5.15 LTS → Qt 6.11)

# PART XII — QML & Qt Quick

# Chapter 90 — Scene Graph (Complete Deep Dive)

---

# 1. Introduction

The **Qt Quick Scene Graph** is the rendering engine used by **Qt Quick (QML)**.

Unlike Qt Widgets, which paint using `QPainter` on the CPU, the Scene Graph is designed to use the **GPU** for efficient rendering.

Every visual QML item becomes part of a scene graph that is rendered each frame.

---

## Architecture

```text
QML UI
   │
   ▼
Scene Graph
   │
   ▼
GPU
   │
   ▼
Screen
```

---

## Key Idea

QML describes **what** should appear on screen.

The Scene Graph determines **how** it is rendered efficiently.

---

# 2. Why Scene Graph?

Suppose your application displays:

* Hundreds of buttons
* Animated gauges
* Charts
* Images
* Video
* 3D previews

Rendering everything on the CPU would become expensive.

Instead:

```text
QML Items

↓

Scene Graph

↓

GPU Rendering
```

Advantages:

* Smooth animations
* High frame rates
* Hardware acceleration
* Efficient batching

---

## Qt Widgets vs Scene Graph

```text
Qt Widgets

↓

QPainter

↓

CPU
```

---

```text
Qt Quick

↓

Scene Graph

↓

GPU
```

---

# 3. Scene Graph Architecture

Every visual object becomes a node.

Example

```text
Window

├── Rectangle

│      ├── Text

│      └── Image

└── Button
```

Runtime

```text
Window Node

├── Rectangle Node

│      ├── Text Node

│      └── Image Node

└── Button Node
```

The tree is traversed every frame.

---

# 4. Rendering Pipeline

Rendering steps:

```text
QML Objects

↓

Scene Graph Nodes

↓

Geometry

↓

GPU Commands

↓

Rendering Hardware Interface

↓

Graphics API

↓

GPU

↓

Screen
```

The Scene Graph converts QML items into rendering commands.

---

## Rendering Stages

```text
Update

↓

Synchronize

↓

Render

↓

Swap Buffers
```

Each frame follows this pipeline.

---

# 5. Rendering Hardware Interface (RHI)

Qt 6 introduced the **Rendering Hardware Interface (RHI)**.

Instead of depending directly on OpenGL,

Qt renders through an abstraction layer.

Architecture

```text
Scene Graph

↓

RHI

↓

OpenGL

Direct3D

Vulkan

Metal
```

Advantages

* One rendering engine
* Multiple graphics APIs
* Better portability
* Future-proof architecture

---

## Platform Examples

| Platform | Graphics API                                            |
| -------- | ------------------------------------------------------- |
| Windows  | Direct3D 11 (default on many systems) / OpenGL / Vulkan |
| Linux    | OpenGL / Vulkan                                         |
| macOS    | Metal                                                   |
| Android  | OpenGL ES / Vulkan                                      |

Qt chooses an appropriate backend based on the platform and configuration.

---

# 6. QSGNode

Every renderable object is represented by a **QSGNode**.

Header

```cpp
#include <QSGNode>
```

Hierarchy

```text
QSGNode

├── QSGGeometryNode

├── QSGTransformNode

├── QSGClipNode

└── QSGOpacityNode
```

A `QSGNode` is **not** a `QObject`.

It is a lightweight rendering object used internally by the Scene Graph.

---

# 7. Geometry Nodes

`QSGGeometryNode` represents geometry.

Example

```text
Rectangle

↓

Vertices

↓

Triangles
```

The GPU renders triangles.

Even rectangles are internally represented as triangles.

---

Applications

* Custom charts
* Medical contours
* CAD geometry
* Graphs

---

# 8. Material Nodes

Geometry alone is not enough.

Materials describe how geometry is rendered.

Examples

* Color
* Shader
* Texture
* Lighting parameters

Architecture

```text
Geometry

↓

Material

↓

GPU
```

---

Typical Uses

* Solid color
* Gradient
* Custom shader
* Lighting effects

---

# 9. Texture Nodes

Textures allow images to be rendered efficiently.

Example

```text
Image File

↓

Texture

↓

GPU Memory

↓

Rectangle
```

Applications

* Icons
* Photos
* Video frames
* Medical CT slices

---

# 10. Render Loop

Qt continuously renders frames.

```text
Frame 1

↓

Frame 2

↓

Frame 3

↓

Frame 4
```

Each frame

```text
Events

↓

Animations

↓

Bindings

↓

Scene Graph Update

↓

Render

↓

Display
```

Qt only updates the parts of the scene that require changes whenever possible.

---

# 11. Scene Graph Threading

One of the biggest differences from Qt Widgets.

Typical architecture

```text
GUI Thread

↓

Update QML

-------------------

Render Thread

↓

GPU Rendering
```

Responsibilities

GUI Thread

* Handle events
* Update properties
* Execute JavaScript
* Evaluate bindings

Render Thread

* Synchronize scene graph
* Issue rendering commands
* Communicate with GPU

> The exact threading model depends on the platform and render loop implementation, but many Qt Quick applications use a dedicated render thread.

---

## Synchronization

```text
GUI Thread

↓

Synchronize

↓

Render Thread

↓

GPU
```

The render thread never modifies QML objects directly.

---

# 12. Custom Scene Graph Rendering

Developers can render custom graphics by subclassing `QQuickItem`.

Important function

```cpp
updatePaintNode()
```

Workflow

```text
QQuickItem

↓

updatePaintNode()

↓

QSGNode

↓

GPU
```

Applications

* Medical visualization
* Scientific plotting
* CAD
* GIS
* Waveforms

---

# 13. Performance Optimization

Qt Quick is already highly optimized, but good design still matters.

### Efficient

```text
Few Nodes

↓

GPU

↓

Fast
```

---

### Inefficient

```text
Thousands of Tiny Items

↓

Many Nodes

↓

Overhead
```

---

Tips

* Reuse items when possible.
* Minimize node count.
* Avoid unnecessary updates.
* Prefer transforms over recreating objects.
* Keep bindings lightweight.

---

# 14. Enterprise Applications

## Medical TPS

```text
Dose Matrix

↓

Texture

↓

Scene Graph

↓

GPU
```

---

## CAD

```text
Geometry

↓

QSGGeometryNode

↓

GPU
```

---

## Automotive Dashboard

```text
Speedometer

↓

Scene Graph

↓

Animation
```

---

## GIS

```text
Map Tiles

↓

Textures

↓

GPU
```

---

# 15. Qt Internals

```text
QML

↓

QQuickItem

↓

QSGNode

↓

Renderer

↓

RHI

↓

Graphics API

↓

GPU
```

Frame pipeline

```text
Property Changed

↓

Binding Updated

↓

Node Dirty

↓

Synchronize

↓

Render
```

Only "dirty" nodes (nodes that have changed) are typically updated, improving rendering efficiency.

---

# 16. Qt 5 vs Qt 6

| Feature                            | Qt 5.15                   | Qt 6.11  |
| ---------------------------------- | ------------------------- | -------- |
| Scene Graph                        | ✔                         | ✔        |
| GPU Rendering                      | ✔                         | ✔        |
| OpenGL Backend                     | Default on many platforms | Optional |
| Rendering Hardware Interface (RHI) | ✘                         | ✔        |
| Multi-API Support                  | Limited                   | ✔        |

The biggest architectural change in Qt 6 is the introduction of the **Rendering Hardware Interface (RHI)**.

---

# 17. Best Practices

✅ Let the Scene Graph handle rendering.

✅ Minimize the number of visual items.

✅ Use textures efficiently.

✅ Keep animations smooth.

✅ Avoid blocking the GUI thread.

---

# 18. Common Mistakes

### ❌ Creating Thousands of Small Items

Combine geometry where appropriate.

---

### ❌ Heavy JavaScript During Animation

Expensive JavaScript reduces frame rates.

---

### ❌ Frequent Object Creation

Reuse items instead of repeatedly creating and destroying them.

---

### ❌ Confusing `QPainter` with the Scene Graph

Qt Quick rendering is GPU-oriented, while `QPainter` is CPU-oriented.

---

### ❌ Accessing Scene Graph Objects from the Wrong Thread

`QSGNode` objects are tied to the rendering process and should only be manipulated through the appropriate Scene Graph APIs (such as `updatePaintNode()`).

---

# 19. Interview Questions

## Easy

1. What is the Qt Quick Scene Graph?
2. Why does Qt Quick use the GPU?
3. What is `QSGNode`?

---

## Medium

1. Explain the rendering pipeline.
2. What is the Rendering Hardware Interface (RHI)?
3. What is the difference between `QQuickItem` and `QSGNode`?

---

## Hard

1. Explain the Scene Graph threading model.
2. How does `updatePaintNode()` work?
3. Compare Qt Widgets rendering with the Scene Graph.

---

## Expert

1. Design a high-performance Treatment Planning System viewer capable of displaying CT slices, RT structures, dose heatmaps, and DVH overlays at interactive frame rates.
2. Explain how the Scene Graph minimizes rendering work using dirty nodes and synchronization.
3. Compare Qt Quick Scene Graph, OpenGL, Vulkan, Direct3D, Metal, and modern game-engine rendering pipelines.

---

# 20. Revision Notes

* The Scene Graph powers Qt Quick rendering.
* Every visual item becomes one or more `QSGNode` objects.
* Rendering is GPU accelerated.
* Qt 6 uses the Rendering Hardware Interface (RHI).
* `QSGGeometryNode` stores geometry.
* Materials determine how geometry is rendered.
* Textures store images in GPU memory.
* Rendering follows update → synchronize → render.
* Custom rendering uses `QQuickItem::updatePaintNode()`.
* Efficient Scene Graph design improves performance.

---

# 💡 Senior Engineer Tips

## Qt Widgets vs Qt Quick

| Feature                   | Qt Widgets       | Qt Quick          |
| ------------------------- | ---------------- | ----------------- |
| Rendering                 | CPU (`QPainter`) | GPU (Scene Graph) |
| Animations                | Moderate         | Excellent         |
| Touch UI                  | Limited          | Excellent         |
| 2D Graphics               | Good             | Excellent         |
| Large Animated Dashboards | Moderate         | Excellent         |

---

## Enterprise Graphics Architecture

```text
             QML UI
                │
                ▼
          QQuickItem
                │
                ▼
          Scene Graph
                │
                ▼
        Rendering Engine
                │
                ▼
               RHI
                │
     ┌──────────┼──────────┐
     ▼          ▼          ▼
 OpenGL    Direct3D    Vulkan/Metal
                │
                ▼
               GPU
```

This architecture lets Qt use the most suitable graphics API for each platform without changing application code.

---

## Medical TPS Example

```text
        Treatment Planning System
                 │
                 ▼
          QML Dose Viewer
                 │
      ┌──────────┼───────────┐
      ▼          ▼           ▼
 CT Slice    Dose Overlay   RT Structures
      │          │           │
      └──────────┼───────────┘
                 ▼
          Scene Graph Nodes
                 │
                 ▼
          Rendering Pipeline
                 │
                 ▼
                GPU
                 │
                 ▼
          High-FPS Visualization
```

Using the Scene Graph:

* CT images become GPU textures.
* RT structures become geometry nodes.
* Dose overlays are blended efficiently.
* Zooming and panning remain smooth even with large datasets.

---


## **Chapter 91 — Qt Quick Controls (Complete Deep Dive)**

