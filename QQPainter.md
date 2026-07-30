# Complete Qt Master Course (Qt 5.15 LTS → Qt 6.11)

# PART VI — 2D Graphics & Rendering

# Chapter 49 — QPainter (Complete Deep Dive)

## Master 2D Painting, Drawing Primitives, Transformations & Rendering

> **Level:** Beginner → Expert

---

# Chapter Objectives

After completing this chapter, you will understand:

* What is `QPainter`?
* Qt Painting Architecture
* `QPaintDevice`
* `QPaintEngine`
* `QPaintEvent`
* Painting Lifecycle
* `QPainter`
* `QPen`
* `QBrush`
* `QColor`
* `QFont`
* Drawing Primitives
* Rendering Pipeline
* Double Buffering
* Performance Optimization
* Enterprise Examples
* Medical TPS Examples
* Qt 5.15 vs Qt 6.11
* Best Practices
* Interview Questions

---

# Table of Contents

1. Introduction
2. Why QPainter?
3. Qt Painting Architecture
4. Painting Lifecycle
5. QPainter Class
6. Paint Devices
7. Paint Events
8. QPen
9. QBrush
10. QColor
11. QFont
12. Drawing Primitives
13. Rendering Pipeline
14. Double Buffering
15. Enterprise Applications
16. Qt Internals
17. Qt 5 vs Qt 6
18. Performance Optimization
19. Best Practices
20. Common Mistakes
21. Interview Questions
22. Revision Notes

---

# 1. Introduction

Almost every GUI application displays graphics.

Examples include:

* Buttons
* Icons
* Charts
* Medical images
* CAD drawings
* Graphs
* Maps
* Animations

Qt performs all 2D drawing through **QPainter**.

`QPainter` is one of the most powerful classes in Qt.

---

## Examples

Using QPainter you can draw:

```text
✓ Line

✓ Rectangle

✓ Circle

✓ Ellipse

✓ Arc

✓ Polygon

✓ Image

✓ Pixmap

✓ Text

✓ Path

✓ Gradient
```

---

# Real Applications

| Application   | Uses QPainter |
| ------------- | ------------- |
| Paint Program | ✔             |
| Medical TPS   | ✔             |
| CAD           | ✔             |
| GIS           | ✔             |
| Charts        | ✔             |
| PDF Viewer    | ✔             |
| Qt Designer   | ✔             |

---

# 2. Why QPainter?

Suppose you want to display:

```text
Dose Distribution
```

or

```text
DVH Graph
```

or

```text
Patient Contours
```

Qt cannot guess how they should look.

Your application must explicitly draw them.

That is the role of **QPainter**.

---

## Example

Instead of:

```text
Widget
```

You want:

```text
+----------------------+

Patient

Dose

Beam

Graph

+----------------------+
```

Every pixel is painted by Qt's rendering system.

---

# 3. Qt Painting Architecture

The complete architecture is:

```text
Application

↓

paintEvent()

↓

QPainter

↓

QPaintEngine

↓

QPaintDevice

↓

Operating System

↓

GPU / CPU

↓

Screen
```

Each component has a specific responsibility.

---

## Responsibilities

| Component    | Responsibility            |
| ------------ | ------------------------- |
| paintEvent   | Starts painting           |
| QPainter     | Draws                     |
| QPaintEngine | Converts drawing commands |
| QPaintDevice | Receives drawing          |
| OS           | Displays result           |

---

# 4. Painting Lifecycle

Qt controls when painting happens.

The application **does not** paint continuously.

Typical workflow:

```text
Widget Created

↓

Needs Update

↓

update()

↓

Paint Event Generated

↓

paintEvent()

↓

QPainter Created

↓

Drawing

↓

Paint Finished
```

---

## Never call:

```cpp
paintEvent();
```

directly.

Instead request repainting:

```cpp
update();
```

or (less commonly):

```cpp
repaint();
```

---

# update() vs repaint()

| update()                    | repaint()                             |
| --------------------------- | ------------------------------------- |
| Schedules repaint           | Paints immediately                    |
| Coalesces multiple requests | Immediate execution                   |
| Better performance          | Can reduce responsiveness if overused |
| Recommended                 | Use only when necessary               |

---

# 5. QPainter Class

Header

```cpp
#include <QPainter>
```

Basic usage

```cpp
void Widget::paintEvent(QPaintEvent *)
{
    QPainter painter(this);

    painter.drawLine(10,10,100,100);
}
```

The constructor begins painting on the specified paint device, and painting ends automatically when the `QPainter` object is destroyed.

---

## Architecture

```text
paintEvent()

↓

QPainter

↓

Drawing Commands

↓

Screen
```

---

# 6. Paint Devices

A **paint device** is anything that can receive drawing commands.

Qt provides several paint devices.

| Class      | Purpose                  |
| ---------- | ------------------------ |
| QWidget    | Screen drawing           |
| QPixmap    | Off-screen image         |
| QImage     | Image processing         |
| QPicture   | Record painting commands |
| QPrinter   | Printing                 |
| QPdfWriter | PDF generation           |

---

## Example

Draw on widget

```cpp
QPainter painter(this);
```

Draw on image

```cpp
QPainter painter(&image);
```

Draw on pixmap

```cpp
QPainter painter(&pixmap);
```

---

# 7. Paint Events

Every custom drawing happens inside:

```cpp
paintEvent(QPaintEvent *)
```

Example

```cpp
void MyWidget::paintEvent(QPaintEvent *)
{
    QPainter painter(this);

    painter.drawRect(20,20,100,60);
}
```

Qt automatically calls this function whenever repainting is required.

---

## When paintEvent() is Called

```text
Window Created

Window Restored

Window Resized

Widget Exposed

update()

repaint()
```

---

# 8. QPen

`QPen` controls **how outlines are drawn**.

It defines:

* Color
* Width
* Style
* Cap style
* Join style

---

## Example

```cpp
QPen pen(Qt::red);

pen.setWidth(3);

painter.setPen(pen);
```

---

## Pen Styles

| Style          | Description      |
| -------------- | ---------------- |
| SolidLine      | Continuous       |
| DashLine       | Dashed           |
| DotLine        | Dotted           |
| DashDotLine    | Dash + Dot       |
| DashDotDotLine | Dash + Dot + Dot |
| NoPen          | No outline       |

---

Visualization

```text
Solid

────────────

Dash

- - - - - -

Dot

··········
```

---

# 9. QBrush

`QBrush` fills shapes.

Example

```cpp
QBrush brush(Qt::green);

painter.setBrush(brush);
```

---

Brush Styles

| Style        | Description |
| ------------ | ----------- |
| SolidPattern | Solid fill  |
| DensePattern | Dense       |
| HorPattern   | Horizontal  |
| VerPattern   | Vertical    |
| CrossPattern | Cross       |
| NoBrush      | No fill     |

---

Example

```text
Rectangle

Outline → Pen

Inside → Brush
```

---

# 10. QColor

Qt supports many ways to create colors.

Examples

```cpp
QColor(Qt::red);

QColor(255,0,0);

QColor("#FF0000");
```

RGBA

```cpp
QColor(255,0,0,128);
```

---

Color Models

* RGB
* RGBA
* HSV
* HSL
* CMYK

---

# 11. QFont

Text drawing uses `QFont`.

Example

```cpp
QFont font;

font.setPointSize(14);

font.setBold(true);

painter.setFont(font);
```

Draw

```cpp
painter.drawText(
    50,
    80,
    "Patient");
```

---

# 12. Drawing Primitives

QPainter provides many drawing functions.

---

## Draw Line

```cpp
painter.drawLine(
    10,10,
    100,100);
```

---

## Rectangle

```cpp
painter.drawRect(
    20,
    20,
    150,
    80);
```

---

## Ellipse

```cpp
painter.drawEllipse(
    30,
    30,
    100,
    60);
```

---

## Circle

A circle is simply an ellipse with equal width and height.

```cpp
painter.drawEllipse(
    50,
    50,
    80,
    80);
```

---

## Polygon

```cpp
QPolygon polygon;

polygon << QPoint(10,10)
        << QPoint(50,30)
        << QPoint(30,80);

painter.drawPolygon(polygon);
```

---

## Polyline

```cpp
painter.drawPolyline(points);
```

Useful for:

* ECG
* DVH
* Graphs
* Waveforms

---

## Arc

```cpp
painter.drawArc(...);
```

Applications:

* Gauges
* Circular charts

---

## Pie

```cpp
painter.drawPie(...);
```

Applications:

* Pie charts

---

## Chord

```cpp
painter.drawChord(...);
```

---

## Text

```cpp
painter.drawText(
    QRect(0,0,300,50),
    Qt::AlignCenter,
    "Treatment Plan");
```

---

## Image

```cpp
painter.drawImage(
    0,
    0,
    image);
```

---

## Pixmap

```cpp
painter.drawPixmap(
    0,
    0,
    pixmap);
```

---

# 13. Rendering Pipeline

Every drawing command follows this pipeline:

```text
drawRect()

↓

QPainter

↓

QPaintEngine

↓

Raster/OpenGL Backend

↓

QPaintDevice

↓

Frame Buffer

↓

Screen
```

At this level, you call `QPainter` methods without worrying about the underlying rendering implementation.

---

# 14. Double Buffering

Qt Widgets use **double buffering** by default.

Instead of drawing directly on the visible screen:

```text
Screen
```

Qt draws into an off-screen buffer first.

```text
Off-screen Buffer

↓

Completed Image

↓

Screen
```

Benefits:

* Reduces flicker
* Produces smoother rendering
* Avoids partially drawn frames

---

# 15. Enterprise Applications

## Medical TPS

```text
CT Image

↓

Contours

↓

Dose Overlay

↓

Beam Isocenter

↓

Patient Markers
```

All drawn using `QPainter` (or related graphics APIs depending on the application architecture).

---

## CAD

```text
Grid

↓

Lines

↓

Dimensions

↓

Symbols
```

---

## GIS

```text
Map

↓

Roads

↓

Labels

↓

Routes
```

---

## Charts

```text
Axes

↓

Grid

↓

Curve

↓

Legend
```

---

# 16. Qt Internals

Painting flow:

```text
update()

↓

Event Queue

↓

paintEvent()

↓

QPainter

↓

QPaintEngine

↓

Paint Device

↓

Platform Graphics API

↓

Display
```

Qt batches painting efficiently through its event system.

---

# 17. Qt 5.15 vs Qt 6.11

| Feature          | Qt 5.15 | Qt 6.11 |
| ---------------- | ------- | ------- |
| QPainter         | ✔       | ✔       |
| QPen             | ✔       | ✔       |
| QBrush           | ✔       | ✔       |
| QColor           | ✔       | ✔       |
| QFont            | ✔       | ✔       |
| Double Buffering | ✔       | ✔       |

The public `QPainter` API remains highly compatible across Qt 5 and Qt 6.

---

# 18. Performance Optimization

✅ Use `update()` instead of repeated `repaint()` calls.

✅ Paint only the region that actually changed when practical.

✅ Reuse pens, brushes, and fonts instead of recreating them inside tight loops.

✅ Cache expensive drawings in `QPixmap` where appropriate.

✅ Avoid unnecessary painting during animations.

---

# 19. Best Practices

✅ Perform all widget painting inside `paintEvent()`.

✅ Keep painting code focused on rendering only.

✅ Separate rendering logic from business logic.

✅ Use anti-aliasing only where visual quality justifies the cost.

✅ Prefer logical coordinate calculations over hard-coded values.

---

# 20. Common Mistakes

### ❌ Painting outside `paintEvent()`

For widgets, drawing directly in arbitrary functions is not persistent. The next repaint will overwrite it.

---

### ❌ Calling `paintEvent()` manually

Always request painting using `update()`.

---

### ❌ Creating heavy resources repeatedly

Avoid constructing large images, fonts, or gradients every time `paintEvent()` executes unless necessary.

---

### ❌ Ignoring clipping

Painting outside the visible area wastes rendering time.

---

# 21. Interview Questions

## Easy

1. What is `QPainter`?
2. What is a `QPaintDevice`?
3. What is `paintEvent()`?

---

## Medium

1. Explain the painting lifecycle in Qt.
2. Compare `update()` and `repaint()`.
3. What is the difference between `QPen` and `QBrush`?

---

## Hard

1. Explain the complete rendering pipeline from `paintEvent()` to the screen.
2. Why does Qt use double buffering?
3. How would you optimize painting for a real-time chart?

---

## Expert

1. Design the rendering architecture for a Medical Treatment Planning System that displays CT slices, contours, beam outlines, and dose overlays.
2. Compare raster-based painting with scene-based rendering (`QGraphicsView`), and explain when each is more appropriate.
3. Design a high-performance CAD viewer capable of rendering hundreds of thousands of primitives efficiently.

---

# 22. Revision Notes

* `QPainter` is Qt's primary 2D drawing class.
* All custom widget painting should occur inside `paintEvent()`.
* `QPen` controls outlines; `QBrush` controls fills.
* `QColor` and `QFont` define appearance.
* `QPaintDevice` represents the drawing target.
* `update()` schedules repainting and is generally preferred over `repaint()`.
* Qt uses double buffering to reduce flicker.
* Keep rendering code efficient and separate from application logic.

---

# 🎯 Chapter 49 Complete

You now understand:

* Qt painting architecture
* `QPainter`
* `QPaintDevice`
* `QPaintEvent`
* `QPen`
* `QBrush`
* `QColor`
* `QFont`
* Drawing primitives
* Rendering pipeline
* Double buffering
* Enterprise rendering patterns
* Qt 5.15 vs Qt 6.11 compatibility

This chapter provides the foundation for all 2D graphics in Qt.

---

# 🚀 Next Chapter

## **Chapter 50 — Paint Engine (Complete Deep Dive)**

In the next chapter, we'll go beneath `QPainter` and study **how Qt actually renders graphics internally**, including:

* `QPaintEngine`
* Raster paint engine
* Native paint engines
* OpenGL-backed paint engines
* Paint engine states
* Drawing command processing
* Backend selection
* Rendering optimization
* Internal architecture of Qt's painting system
* Performance considerations
* Enterprise rendering pipelines
