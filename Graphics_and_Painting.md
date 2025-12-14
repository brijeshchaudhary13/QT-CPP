

## **1. QPainter Basics**

### **Definition**

`QPainter` is the core Qt class used to **draw graphics** (shapes, text, images) on widgets, images, or other paint devices.

---

### **Why QPainter is needed**

Standard widgets are not enough when you need:

* Custom charts/graphs
* Medical imaging overlays
* Gauges, meters, dashboards
* Custom look & feel

---

### **How QPainter works**

1. Qt sends a **paint event**
2. You create a `QPainter`
3. Draw using painter APIs
4. Painter renders to screen buffer

---

### **Basic Example**

```cpp
void MyWidget::paintEvent(QPaintEvent *)
{
    QPainter painter(this);
    painter.drawLine(10, 10, 100, 100);
}
```

👉 Painting always happens inside `paintEvent()`.

---

## **2. Drawing Shapes**

### **Definition**

QPainter can draw **basic geometric shapes**.

---

### **Why drawing shapes**

* Custom UI components
* Graphs and plots
* Status indicators

---

### **How it works**

Use QPainter methods:

* `drawLine`
* `drawRect`
* `drawEllipse`
* `drawPolygon`

---

### **Example**

```cpp
void MyWidget::paintEvent(QPaintEvent *)
{
    QPainter p(this);

    p.drawRect(20, 20, 100, 60);
    p.drawEllipse(150, 20, 80, 80);
    p.drawLine(20, 120, 200, 120);
}
```

---

### **Pen & Brush**

```cpp
p.setPen(Qt::blue);
p.setBrush(Qt::yellow);
p.drawRect(10, 10, 100, 50);
```

* **Pen** → outline
* **Brush** → fill

---

## **3. Drawing Text**

### **Definition**

Drawing text means rendering **custom text** on a widget using QPainter.

---

### **Why draw text manually**

* Custom fonts
* Precise placement
* Labels on graphs
* Watermarks

---

### **How it works**

Use `drawText()` with coordinates or rectangle.

---

### **Example**

```cpp
void MyWidget::paintEvent(QPaintEvent *)
{
    QPainter p(this);
    p.setFont(QFont("Arial", 14));
    p.drawText(50, 50, "Hello Qt");
}
```

---

### **Text Alignment**

```cpp
p.drawText(rect(), Qt::AlignCenter, "Centered Text");
```

---

## **4. Drawing Images**

### **Definition**

Drawing images means rendering **bitmaps or vector images** on widgets.

---

### **Why draw images**

* Icons
* Backgrounds
* Medical images
* Maps

---

### **How it works**

Load image → draw using QPainter.

---

### **Example**

```cpp
void MyWidget::paintEvent(QPaintEvent *)
{
    QPainter p(this);
    QPixmap pix(":/images/logo.png");
    p.drawPixmap(10, 10, pix);
}
```

---

### **Scaling Images**

```cpp
p.drawPixmap(rect(), pix);
```

---

## **5. Custom Widgets Painting**

### **Definition**

A **custom widget** is a widget that **draws itself** using QPainter.

---

### **Why custom widgets**

* Specialized UI components
* Better performance
* Full control over appearance

---

### **How to create**

1. Inherit from `QWidget`
2. Override `paintEvent()`
3. Use QPainter

---

### **Example: Progress Bar**

```cpp
class MyProgress : public QWidget
{
protected:
    void paintEvent(QPaintEvent *) override {
        QPainter p(this);
        p.setBrush(Qt::green);
        p.drawRect(0, 0, width() / 2, height());
    }
};
```

---

## **6. Coordinate System**

### **Definition**

The coordinate system defines **where and how drawing happens**.

---

### **Why understanding coordinates is important**

* Precise drawing
* Scaling
* Rotation
* Zooming

---

### **Default Coordinate System**

* Origin `(0,0)` → top-left
* X → right
* Y → down

---

### **Example**

```cpp
p.drawPoint(0, 0);   // top-left corner
```

---

### **Transformations**

```cpp
p.translate(100, 100);
p.rotate(45);
p.scale(2, 2);
```

---

## **7. Double Buffering**

### **Definition**

Double buffering means **drawing to an off-screen buffer first**, then displaying it.

---

### **Why double buffering**

Without it:

* Flickering
* Incomplete drawing

Qt **enables double buffering by default** for widgets.

---

### **How Qt handles it**

* Paints to a back buffer
* Swaps buffer to screen
* Smooth rendering

---

### **Manual Double Buffering (Advanced)**

```cpp
QPixmap buffer(size());
buffer.fill(Qt::white);

QPainter p(&buffer);
p.drawRect(10, 10, 100, 50);

QPainter screen(this);
screen.drawPixmap(0, 0, buffer);
```

---

## **8. Graphics View Framework Overview**

### **Definition**

The **Graphics View Framework** is a **scene–view architecture** for managing large numbers of 2D graphics items.

Classes:

* `QGraphicsView`
* `QGraphicsScene`
* `QGraphicsItem`

---

### **Why Graphics View exists**

QPainter is good for:

* Simple/custom drawing

Graphics View is better for:

* Large scenes
* Zooming/panning
* Item interaction
* High performance

---

### **How it works**

```
QGraphicsView → displays
QGraphicsScene → manages items
QGraphicsItem → individual objects
```

---

### **Example**

```cpp
QGraphicsScene *scene = new QGraphicsScene();
scene->addRect(0, 0, 100, 50);

QGraphicsView *view = new QGraphicsView(scene);
view->show();
```

---

### **When to use what**

| Use Case                | Use           |
| ----------------------- | ------------- |
| Simple custom drawing   | QPainter      |
| Charts, overlays        | QPainter      |
| Large interactive scene | Graphics View |
| Zoom/Pan                | Graphics View |

---

## **Common Mistakes (Interview Traps)**

❌ Painting outside `paintEvent()`
❌ Creating QPainter without paint device
❌ Heavy computation inside `paintEvent()`
❌ Forgetting to call `update()`

---

## **Interview Questions (Chapter 15)**

**Q: Where should painting code go?**
👉 `paintEvent()`

**Q: Difference between QPainter and QGraphicsView?**
👉 Immediate vs scene-based drawing

**Q: Does Qt support double buffering?**
👉 Yes, by default

---

## **Interview Summary (One-liners)**

* QPainter → core drawing API
* paintEvent → entry point
* Pen = border, Brush = fill
* Coordinates start at top-left
* Graphics View → scene-based rendering

---

