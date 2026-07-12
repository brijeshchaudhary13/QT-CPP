Excellent.

**Chapter 45 is one of the most important chapters in professional Qt development.**

Whenever Qt displays **anything on the screen**, it uses the **Qt Painting System**.

Examples include:

* Buttons
* Labels
* Tables
* Charts
* Images
* Medical CT/MRI viewers
* CAD drawings
* PDF viewers
* ECG graphs
* Dose heatmaps
* DVH graphs

All of them are ultimately rendered using **QPainter**.

If you plan to build a **Medical Treatment Planning System (TPS)**, understanding the Qt Painting System is essential.

---

# Complete Qt Master Course (Qt 5.15 LTS → Qt 6.11)

# PART VI — Event System & Application Architecture

# Chapter 45 — Qt Painting System (Complete Deep Dive)

## Part 1 — QPainter, QPaintDevice, QPaintEngine, paintEvent() & Rendering Architecture

> **Level:** Beginner → Expert

---

# Chapter Objectives

After completing this chapter, you will understand:

* What is the Qt Painting System?
* `QPainter`
* `QPaintDevice`
* `QPaintEngine`
* `paintEvent()`
* Painting lifecycle
* Rendering architecture
* Double buffering
* Qt 5 vs Qt 6

---

# Table of Contents

1. Introduction
2. Painting Architecture
3. QPainter
4. QPaintDevice
5. QPaintEngine
6. paintEvent()
7. Painting Lifecycle
8. Double Buffering
9. Qt Source Code Concepts
10. Qt 5 vs Qt 6
11. Best Practices
12. Interview Questions
13. Revision Notes

---

# 1. Introduction

Qt's painting system is responsible for drawing visual elements.

Examples:

```text id="xhxpw0"
Button

↓

Rectangle

↓

Text

↓

Icon
```

Chart:

```text id="bwzsjp"
Axes

↓

Lines

↓

Labels
```

Medical TPS:

```text id="1c0z1l"
CT Image

↓

Contours

↓

Dose Overlay

↓

Crosshair

↓

Annotations
```

Everything is drawn through the painting system.

---

# 2. Painting Architecture

Qt separates painting into three main components:

```text id="5t2vfh"
QPainter

↓

QPaintDevice

↓

QPaintEngine
```

Responsibilities:

| Class          | Responsibility                             |
| -------------- | ------------------------------------------ |
| `QPainter`     | High-level drawing API                     |
| `QPaintDevice` | Surface being painted                      |
| `QPaintEngine` | Platform-specific rendering implementation |

---

## Architecture Diagram

```text id="9jlwmn"
Application

↓

QPainter

↓

QPaintEngine

↓

QPaintDevice

↓

Screen / Image / Printer / PDF
```

---

# 3. QPainter

`QPainter` is the main drawing class.

Header:

```cpp id="z6gfqg"
#include <QPainter>
```

Basic usage:

```cpp id="oqhz2h"
void Widget::paintEvent(QPaintEvent *)
{
    QPainter painter(this);
}
```

Here:

```text id="v7i71t"
this

↓

Widget

↓

Paint Device
```

---

## What Can QPainter Draw?

* Points
* Lines
* Rectangles
* Ellipses
* Circles
* Polygons
* Images
* Text
* Paths
* Pixmaps

---

Example:

```text id="h4mvsl"
Line

Rectangle

Circle

Text

Image
```

---

# 4. QPaintDevice

A paint device is the destination for drawing.

Common paint devices:

| Class        | Description               |
| ------------ | ------------------------- |
| `QWidget`    | Screen widget             |
| `QPixmap`    | Off-screen pixmap         |
| `QImage`     | Image buffer              |
| `QPrinter`   | Printer output            |
| `QPicture`   | Recorded drawing commands |
| `QPdfWriter` | PDF output                |

---

Example:

```cpp id="slh5io"
QPainter painter(widget);
```

Destination:

```text id="y7kmww"
Widget
```

Another example:

```cpp id="95njn9"
QImage image(800,600,
             QImage::Format_ARGB32);

QPainter painter(&image);
```

Destination:

```text id="0qbzoi"
Image Buffer
```

The same drawing API works for different output targets.

---

# 5. QPaintEngine

Most developers never interact directly with `QPaintEngine`.

It is responsible for translating drawing commands into platform-specific rendering.

Conceptually:

```text id="s50t9m"
drawLine()

↓

Paint Engine

↓

Windows GDI

or

Core Graphics

or

X11

or

Raster Engine
```

Qt chooses the appropriate paint engine automatically.

---

# 6. paintEvent()

Qt only allows painting at the appropriate time.

Override:

```cpp id="k7s8di"
void Widget::paintEvent(
    QPaintEvent *event)
{
    QPainter painter(this);

    // Draw here
}
```

This is the correct place for custom painting.

---

## When Is paintEvent() Called?

Examples:

```text id="d7c4mh"
Window Shown

↓

Expose Event

↓

paintEvent()
```

Another:

```text id="h2lqto"
Resize

↓

paintEvent()
```

Another:

```text id="vlgqgh"
update()

↓

paintEvent()
```

---

# update() vs repaint()

### update()

```cpp id="g1d0o6"
update();
```

Behavior:

```text id="df1mzl"
Request Repaint

↓

Later

↓

Event Loop

↓

paintEvent()
```

Efficient because Qt may combine multiple update requests.

---

### repaint()

```cpp id="iikjlwm"
repaint();
```

Behavior:

```text id="g2m0wv"
Immediate Paint
```

Use `repaint()` sparingly, as it bypasses some optimizations.

---

# 7. Painting Lifecycle

Typical workflow:

```text id="0icmsl"
Widget Needs Painting

↓

update()

↓

Paint Event Posted

↓

Event Loop

↓

paintEvent()

↓

QPainter

↓

QPaintEngine

↓

Screen Updated
```

---

# 8. Double Buffering

Qt Widgets use double buffering by default.

Without double buffering:

```text id="m5w5y4"
Draw Line

↓

Visible

↓

Draw Rectangle

↓

Visible

↓

Flicker
```

With double buffering:

```text id="nkpkhn"
Off-Screen Buffer

↓

Complete Drawing

↓

Copy To Screen
```

The user sees only the finished frame, reducing flicker.

---

# 9. Paint Event Flow

```text id="jlwmkj"
Operating System

↓

Expose Event

↓

Qt Event Loop

↓

paintEvent()

↓

QPainter

↓

Paint Engine

↓

Screen
```

---

# 10. TPS Example

During dose visualization:

```text id="mfmwe5"
CT Slice

↓

Dose Matrix

↓

Contours

↓

Crosshair

↓

Annotations

↓

paintEvent()
```

Everything is drawn in one paint pass.

---

# 11. Qt Source Code Concepts

Conceptually:

```text id="qjlwm7"
update()

↓

QEvent::Paint

↓

Event Queue

↓

QWidget::event()

↓

paintEvent()

↓

QPainter

↓

QPaintEngine

↓

Raster Output
```

Qt ensures painting occurs at safe times within the event loop.

---

# 12. Qt 5.15 vs Qt 6.11

| Feature          | Qt 5.15 | Qt 6.11 |
| ---------------- | ------- | ------- |
| QPainter         | ✔       | ✔       |
| QPaintDevice     | ✔       | ✔       |
| paintEvent()     | ✔       | ✔       |
| Double Buffering | ✔       | ✔       |

The painting API is highly stable across versions.

---

# 13. Best Practices

✅ Perform custom drawing only inside `paintEvent()`.

✅ Use `update()` instead of `repaint()` whenever possible.

✅ Keep painting code efficient.

✅ Minimize allocations inside `paintEvent()`.

✅ Separate rendering logic from business logic.

---

# 14. Common Mistakes

### ❌ Painting outside `paintEvent()`

Example:

```cpp id="ejecnd"
QPainter painter(this);
```

Creating a `QPainter` on a widget outside a valid paint event is generally incorrect and can lead to undefined behavior or warnings.

---

### ❌ Calling `repaint()` repeatedly

This can reduce performance and responsiveness.

---

### ❌ Performing heavy calculations in `paintEvent()`

Compute data elsewhere and let `paintEvent()` focus on rendering.

---

### ❌ Forgetting to call the base implementation when required

For some widgets, preserving default painting behavior is important.

---

# 15. Interview Questions

## Easy

1. What is `QPainter`?
2. What is `QPaintDevice`?
3. What is `paintEvent()`?

---

## Medium

1. Explain the relationship between `QPainter`, `QPaintDevice`, and `QPaintEngine`.
2. Compare `update()` and `repaint()`.
3. Why is double buffering important?

---

## Hard

1. Describe the complete painting lifecycle in Qt.
2. Explain why painting should occur only in `paintEvent()`.
3. How does Qt reduce flicker during rendering?

---

## Expert

1. Design the rendering pipeline for a Medical TPS viewer displaying CT images, contours, and dose overlays.
2. Explain how `QPaintEngine` abstracts platform-specific rendering.
3. Compare immediate painting and deferred painting in terms of performance and responsiveness.

---

# 16. Architecture Diagram

```text id="2tv9sd"
                 Application Logic
                        │
                     update()
                        │
                        ▼
                 QEvent::Paint
                        │
                        ▼
                 QWidget::event()
                        │
                        ▼
                  paintEvent()
                        │
                        ▼
                    QPainter
                        │
                        ▼
                 QPaintEngine
                        │
                        ▼
                 QPaintDevice
                        │
                        ▼
         Screen / Image / Printer / PDF
```

---

# 🏥 Production Example — Treatment Planning System

```text id="6zwqaa"
Dose Engine Produces Dose Matrix
               │
               ▼
      Viewer Calls update()
               │
               ▼
          Paint Event
               │
      ┌────────┼─────────────┐
      ▼        ▼             ▼
 Draw CT   Draw Structures  Draw Dose
      │        │             │
      └────────┴─────────────┘
               ▼
      Draw Crosshair & Labels
               │
               ▼
          Display Frame
```

This layered approach keeps rendering organized and ensures all visual elements are drawn consistently in a single paint cycle.

---

# 17. Revision Notes

* `QPainter` is the high-level drawing API.
* `QPaintDevice` is the surface being drawn onto.
* `QPaintEngine` performs the underlying rendering.
* Custom painting belongs in `paintEvent()`.
* `update()` schedules a repaint; `repaint()` requests immediate painting.
* Double buffering helps eliminate flicker.
* Keep rendering fast and avoid heavy computation inside `paintEvent()`.

---
Excellent.

This is the chapter where **QPainter becomes truly powerful**.

Everything you see in professional applications—**CAD drawings, CT viewers, MRI viewers, dose overlays, graphs, annotations, vector editors, PDF viewers, and engineering software**—is built using the concepts in this chapter.

If you master these APIs, you'll be able to build applications similar to:

* Qt Creator
* AutoCAD
* Adobe Illustrator
* Photoshop (2D rendering)
* Medical TPS
* 3D Slicer (2D slice viewer)
* GIS Applications
* Diagram Editors

---

# Complete Qt Master Course (Qt 5.15 LTS → Qt 6.11)

# PART VI — Event System & Application Architecture

# Chapter 45 — Qt Painting System (Complete Deep Dive)

## Part 2 — QPen, QBrush, QColor, QPainterPath, Transformations, Clipping & High-Performance Rendering

> **Level:** Advanced → Expert

---

# Chapter Objectives

After completing this chapter, you will understand:

* `QPen`
* `QBrush`
* `QColor`
* `QFont`
* Drawing primitives
* `QPainterPath`
* Gradients
* Coordinate transformations
* Clipping
* Rendering hints
* High-DPI painting
* Performance optimization

---

# Table of Contents

1. QPen
2. QBrush
3. QColor
4. QFont
5. Drawing Primitives
6. QPainterPath
7. Gradients
8. Coordinate System
9. Transformations
10. Clipping
11. Rendering Hints
12. High-DPI Painting
13. Performance Optimization
14. Qt 5 vs Qt 6
15. Best Practices
16. Interview Questions
17. Revision Notes

---

# 1. QPen

A **QPen** defines **how outlines are drawn**.

Think of it as the drawing instrument.

Header:

```cpp
#include <QPen>
```

Example:

```cpp
QPen pen(Qt::red);

pen.setWidth(3);

painter.setPen(pen);
```

Result:

```text
────────────
Red Line
Thickness = 3
```

---

## Pen Properties

```text
Color

Width

Style

Cap Style

Join Style
```

---

## Line Styles

```cpp
pen.setStyle(Qt::SolidLine);
```

Available styles:

```text
Solid

Dash

Dot

Dash Dot

Dash Dot Dot
```

Visualization:

```text
──────────────

- - - - - - -

............

-.-.-.-.-.-.

-..-..-..-..
```

---

# 2. QBrush

A **QBrush** fills shapes.

Without a brush:

```text
Rectangle

□
```

With a brush:

```text
■■■■■■■■■■
```

Example:

```cpp
QBrush brush(Qt::blue);

painter.setBrush(brush);
```

---

## Brush Styles

```text
Solid

Dense

Cross

Diagonal

Texture

Gradient
```

---

# 3. QColor

Qt supports multiple ways to define colors.

Example:

```cpp
QColor red(Qt::red);
```

RGB:

```cpp
QColor(255,0,0);
```

RGBA:

```cpp
QColor(255,0,0,128);
```

Hex:

```cpp
QColor("#FF0000");
```

---

## Alpha Channel

```text
255

↓

Opaque
```

```text
128

↓

Semi Transparent
```

```text
0

↓

Invisible
```

Very useful for:

* Dose overlays
* Heatmaps
* Selection highlights
* Ghost objects

---

# 4. QFont

Text rendering:

```cpp
QFont font;

font.setPointSize(12);

font.setBold(true);

painter.setFont(font);
```

Then:

```cpp
painter.drawText(
    QRect(...),
    Qt::AlignCenter,
    "Dose");
```

---

# 5. Drawing Primitives

QPainter provides many drawing functions.

---

## Line

```cpp
painter.drawLine(
    x1,y1,
    x2,y2);
```

---

## Rectangle

```cpp
painter.drawRect(
    QRect(...));
```

---

## Rounded Rectangle

```cpp
painter.drawRoundedRect(
    rect,
    5,
    5);
```

---

## Ellipse

```cpp
painter.drawEllipse(rect);
```

---

## Circle

Special case of ellipse.

---

## Polygon

```cpp
QPolygon polygon;

polygon << QPoint(...)
        << QPoint(...);

painter.drawPolygon(polygon);
```

---

## Polyline

```cpp
painter.drawPolyline(points);
```

Useful for:

* ECG graphs
* DVH curves
* Waveforms

---

## Arc

```cpp
painter.drawArc(...);
```

---

## Pie

```cpp
painter.drawPie(...);
```

---

## Chord

```cpp
painter.drawChord(...);
```

---

# 6. QPainterPath

One of the most powerful Qt graphics classes.

Allows creation of complex vector paths.

Example:

```cpp
QPainterPath path;

path.moveTo(0,0);

path.lineTo(50,50);

path.cubicTo(...);
```

Draw:

```cpp
painter.drawPath(path);
```

---

Used for:

* Organ contours
* Freehand drawing
* SVG-like graphics
* CAD geometry
* Medical structures

---

Visualization:

```text
Move

↓

Line

↓

Curve

↓

Close

↓

Shape
```

---

# 7. Gradients

Qt supports:

* Linear Gradient
* Radial Gradient
* Conical Gradient

---

Example:

```cpp
QLinearGradient gradient(...);

gradient.setColorAt(0,Qt::red);

gradient.setColorAt(1,Qt::blue);
```

Result:

```text
Red

↓

Purple

↓

Blue
```

---

Useful for:

* Modern UI
* Heatmaps
* Medical visualization
* Buttons

---

# 8. Coordinate System

Qt uses a Cartesian-like coordinate system with the origin at the **top-left** of the paint device.

```text
(0,0)
 +------------------------→ X
 |
 |
 |
 ▼
 Y
```

Positive X moves right.

Positive Y moves downward.

---

# 9. Transformations

QPainter can transform the coordinate system.

---

## Translate

```cpp
painter.translate(100,50);
```

Moves the origin.

---

## Rotate

```cpp
painter.rotate(45);
```

Rotates subsequent drawing.

---

## Scale

```cpp
painter.scale(2.0,2.0);
```

Everything becomes twice as large.

---

## Shear

```cpp
painter.shear(0.2,0.0);
```

Produces a slanted effect.

---

Transformation Pipeline

```text
Original

↓

Translate

↓

Rotate

↓

Scale

↓

Draw
```

---

# 10. Clipping

Clipping restricts where drawing can occur.

Example:

```cpp
painter.setClipRect(rect);
```

Result:

```text
Only Inside Rectangle

↓

Painting Visible
```

Outside the clip region, drawing is discarded.

---

Useful for:

* Scroll areas
* CT viewer viewport
* Zoom windows
* Mini-map rendering

---

# 11. Rendering Hints

Improve visual quality.

Example:

```cpp
painter.setRenderHint(
    QPainter::Antialiasing);
```

Without antialiasing:

```text
########
```

With antialiasing:

```text
Smooth Edge
```

Other useful hints:

```cpp
QPainter::TextAntialiasing

QPainter::SmoothPixmapTransform
```

---

# 12. High-DPI Painting

Modern displays may use scaling factors greater than 1.0.

Examples:

```text
100%

150%

200%
```

Qt automatically scales many UI elements, but custom painting should avoid hard-coded assumptions about pixel density.

For raster images, use appropriately sized assets or high-resolution images when necessary.

---

# 13. Performance Optimization

Good practices:

✅ Repaint only the necessary region.

```cpp
update(rect);
```

instead of repainting the whole widget.

---

Cache expensive content.

Example:

```text
Background

↓

Render Once

↓

Reuse
```

---

Avoid repeated allocations in `paintEvent()`.

---

Avoid unnecessary state changes:

```text
Pen

↓

Brush

↓

Pen

↓

Brush
```

Batch similar drawing operations where practical.

---

# 14. Enterprise TPS Example

Paint order:

```text
CT Image

↓

Dose Overlay

↓

Contours

↓

Beam Geometry

↓

Crosshair

↓

Annotations

↓

Selection Handles
```

Rendering in a consistent order ensures overlays appear correctly.

---

# 15. Qt Source Code Concepts

```text
paintEvent()

↓

QPainter

↓

QPen

↓

QBrush

↓

Transformation

↓

Clip Region

↓

Paint Engine

↓

Screen
```

Each drawing operation is affected by the current painter state (pen, brush, font, transform, clip, opacity, etc.).

---

# 16. Qt 5.15 vs Qt 6.11

| Feature         | Qt 5.15 | Qt 6.11 |
| --------------- | ------- | ------- |
| QPen            | ✔       | ✔       |
| QBrush          | ✔       | ✔       |
| QPainterPath    | ✔       | ✔       |
| Transformations | ✔       | ✔       |
| Clipping        | ✔       | ✔       |
| Rendering Hints | ✔       | ✔       |

The painting API remains highly compatible across versions.

---

# 17. Best Practices

✅ Keep painting code inside `paintEvent()`.

✅ Use `QPainterPath` for complex vector graphics.

✅ Enable antialiasing only when it improves the result enough to justify the cost.

✅ Minimize overdraw.

✅ Cache expensive rendering when possible.

✅ Separate rendering from application logic.

---

# 18. Common Mistakes

### ❌ Performing heavy calculations during painting

Calculate first, render second.

---

### ❌ Forgetting to restore painter state

When changing transforms, pens, brushes, or clipping, use:

```cpp
painter.save();

// Modify painter state

painter.restore();
```

This avoids unintended side effects on later drawing.

---

### ❌ Excessive repainting

Calling `update()` too frequently can reduce performance.

---

### ❌ Ignoring clipping

Drawing outside the visible area wastes rendering time.

---

# 19. Interview Questions

## Easy

1. What is `QPen`?
2. What is `QBrush`?
3. What is `QPainterPath`?

---

## Medium

1. Explain the difference between a pen and a brush.
2. Compare `drawPolygon()` and `drawPath()`.
3. What is clipping?

---

## Hard

1. Explain the painter transformation pipeline.
2. Describe how gradients work.
3. How would you optimize painting for a large medical image viewer?

---

## Expert

1. Design the rendering pipeline for a Treatment Planning System showing CT images, dose heatmaps, contours, beam geometry, and annotations.
2. Explain how painter state affects rendering.
3. Compare vector rendering with raster rendering in Qt.

---

# 20. Architecture Diagram

```text
             paintEvent()
                   │
                   ▼
              QPainter
                   │
      ┌────────────┼────────────┐
      ▼            ▼            ▼
    QPen       QBrush       QFont
      │            │            │
      └────────────┼────────────┘
                   ▼
          Transformations
                   │
                   ▼
              Clipping
                   │
                   ▼
            QPaintEngine
                   │
                   ▼
             QPaintDevice
                   │
                   ▼
                Screen
```

---

# 🏥 Production Example — Treatment Planning System

```text
CT Slice
    │
    ▼
Draw Background Image
    │
    ▼
Draw Dose Heatmap (Semi-Transparent)
    │
    ▼
Draw Organ Contours (QPainterPath)
    │
    ▼
Draw Beam Isocenter
    │
    ▼
Draw Crosshair
    │
    ▼
Draw Text Labels
    │
    ▼
Draw Selection Handles
    │
    ▼
Present Frame
```

This layered rendering strategy is common in medical imaging and engineering applications because it keeps each visual component independent while producing a coherent final image.

---

# 21. Revision Notes

* `QPen` controls outlines.
* `QBrush` fills shapes.
* `QColor` supports RGB, RGBA, and hexadecimal formats.
* `QFont` controls text rendering.
* `QPainterPath` is ideal for complex vector graphics.
* Transformations modify the coordinate system.
* Clipping limits where drawing can occur.
* Rendering hints improve visual quality.
* Cache expensive rendering operations when possible.
* Use `save()` and `restore()` to manage painter state safely.

---

# 🎯 Chapter 45 Complete

You now have a comprehensive understanding of the **Qt Painting System**, including:

* `QPainter`
* `QPaintDevice`
* `QPaintEngine`
* `QPen`
* `QBrush`
* `QColor`
* `QFont`
* Drawing primitives
* `QPainterPath`
* Gradients
* Transformations
* Clipping
* Rendering hints
* High-DPI considerations
* Performance optimization
* Qt 5 → Qt 6 compatibility

This knowledge forms the foundation for implementing advanced rendering features in custom Qt widgets, including medical image viewers, CAD applications, charting systems, diagram editors, and other graphics-intensive desktop software.

---

# 🚀 Next Chapter

## **Chapter 46 — Graphics View Framework (Complete Deep Dive)**

