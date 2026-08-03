# Complete Qt Master Course (Qt 5.15 LTS → Qt 6.11)

# PART XIII — Qt Multimedia & Specialized Modules

# Chapter 94 — Qt Charts (Complete Deep Dive)



---

# 1. Introduction

**Qt Charts** is a module that provides ready-made chart components for visualizing data.

It supports:

* Line charts
* Bar charts
* Pie charts
* Scatter charts
* Area charts
* Spline charts
* Polar charts
* Box plot charts
* Candlestick charts

Applications include:

* Medical dashboards
* Financial software
* Industrial monitoring
* Scientific visualization
* ERP reporting

---

## Architecture

```text id="chart01"
Application
      │
      ▼
Qt Charts
      │
      ▼
Chart View
      │
      ▼
Screen
```

---

# 2. Qt Charts Architecture

The main classes are:

```text id="chart02"
QChartView
      │
      ▼
QChart
      │
      ▼
Series
      │
      ▼
Axes
```

Each chart contains one or more **series** that represent the actual data.

---

# 3. QChart

`QChart` is the central chart object.

Header

```cpp id="chart03"
#include <QtCharts/QChart>
```

Create

```cpp id="chart04"
QChart *chart = new QChart;
```

Set title

```cpp id="chart05"
chart->setTitle(
"Monthly Sales");
```

Add series

```cpp id="chart06"
chart->addSeries(series);
```

---

## Architecture

```text id="chart07"
QChart

├── Series

├── Axes

└── Legend
```

---

# 4. QChartView

`QChartView` displays a chart inside a widget.

Example

```cpp id="chart08"
QChartView *view =
new QChartView(chart);
```

Enable antialiasing

```cpp id="chart09"
view->setRenderHint(
QPainter::Antialiasing);
```

---

Display pipeline

```text id="chart10"
Data

↓

QChart

↓

QChartView

↓

Window
```

---

# 5. Chart Series

A **series** stores chart data.

Common series:

* `QLineSeries`
* `QBarSeries`
* `QPieSeries`
* `QScatterSeries`
* `QSplineSeries`
* `QAreaSeries`
* `QBoxPlotSeries`
* `QCandlestickSeries`

---

## Example

```cpp id="chart11"
QLineSeries *series =
new QLineSeries;
```

Add points

```cpp id="chart12"
series->append(0,10);

series->append(1,20);

series->append(2,15);
```

---

Data flow

```text id="chart13"
Points

↓

Series

↓

Chart
```

---

# 6. Chart Types

## Line Chart

```text id="chart14"
Y

│

│

│

└──────── X
```

Applications

* Dose curves
* Temperature
* CPU usage

---

## Bar Chart

```text id="chart15"
█

██

████
```

Applications

* Sales
* Reports
* Statistics

---

## Pie Chart

```text id="chart16"
◔
```

Applications

* Percentage distribution
* Market share

---

## Scatter Chart

```text id="chart17"
• • •

 • •

•
```

Applications

* Scientific data
* Measurements

---

## Spline Chart

Smooth line

```text id="chart18"
~~~~~~~
```

Applications

* Medical graphs
* Financial data

---

## Area Chart

Filled region under a curve.

Useful for cumulative values and ranges.

---

## Polar Chart

Displays data in polar coordinates.

Useful for directional measurements and radar-like visualizations.

---

# 7. Axes

Axes define how data is displayed.

Common axis classes:

* `QValueAxis`
* `QCategoryAxis`
* `QDateTimeAxis`
* `QBarCategoryAxis`
* `QLogValueAxis`

---

## Value Axis

```cpp id="chart19"
QValueAxis *axis =
new QValueAxis;
```

Range

```cpp id="chart20"
axis->setRange(
0,
100);
```

---

## DateTime Axis

Applications

* Trend analysis
* Sensor history
* Stock prices

---

Axis architecture

```text id="chart21"
Series

↓

X Axis

Y Axis
```

---

# 8. Legends & Titles

Chart title

```cpp id="chart22"
chart->setTitle(
"Patient Dose");
```

Legend

```cpp id="chart23"
chart->legend()
->setVisible(true);
```

Legend positions

* Top
* Bottom
* Left
* Right

---

Example

```text id="chart24"
Dose Graph

──────────────

PTV

Heart

Lung
```

---

# 9. Dynamic Updates

Charts can update while the application is running.

Example

```cpp id="chart25"
series->append(x,y);
```

Remove

```cpp id="chart26"
series->remove(
0);
```

Clear

```cpp id="chart27"
series->clear();
```

---

Workflow

```text id="chart28"
Sensor

↓

Series

↓

Chart

↓

Screen
```

---

# 10. Real-Time Charts

Real-time charts update continuously.

Example

```text id="chart29"
Machine

↓

Sensor

↓

Chart
```

Applications

* ECG
* CPU Monitor
* Dose Delivery
* CAN Bus

---

Typical architecture

```text id="chart30"
Worker Thread

↓

Signal

↓

GUI Thread

↓

Chart Update
```

The worker thread gathers data, while the GUI thread updates the chart.

---

# 11. Charts in QML

Import

```qml id="chart31"
import QtCharts
```

Example

```qml id="chart32"
ChartView
{
}
```

Line series

```qml id="chart33"
LineSeries
{
}
```

Axis

```qml id="chart34"
ValueAxis
{
}
```

---

Architecture

```text id="chart35"
QML

↓

ChartView

↓

Series
```

---

# 12. Enterprise Applications

## Medical TPS

```text id="chart36"
Dose Engine

↓

DVH

↓

Chart
```

---

## Finance

```text id="chart37"
Stock

↓

Chart
```

---

## Industrial

```text id="chart38"
Temperature

↓

Trend
```

---

## Automotive

```text id="chart39"
CAN

↓

Charts
```

---

# 13. Qt Internals

```text id="chart40"
Series

↓

Chart

↓

Scene Graph

↓

GPU
```

For QML-based charts, rendering uses the Qt Quick Scene Graph. In widget-based applications, `QChartView` integrates with the Widgets framework.

Rendering pipeline

```text id="chart41"
Points

↓

Geometry

↓

Renderer

↓

Display
```

---

# 14. Qt 5 vs Qt 6

| Feature     | Qt 5.15 | Qt 6.11  |
| ----------- | ------- | -------- |
| Qt Charts   | ✔       | ✔        |
| QChart      | ✔       | ✔        |
| QChartView  | ✔       | ✔        |
| QML Charts  | ✔       | ✔        |
| Performance | Good    | Improved |

Qt Charts remains available in Qt 6 with API compatibility and ongoing improvements.

---

# 15. Best Practices

✅ Separate data acquisition from chart rendering.

✅ Update charts only from the GUI thread.

✅ Reuse series instead of recreating them.

✅ Limit the number of displayed points for long-running real-time charts.

✅ Enable antialiasing only when the quality/performance trade-off is acceptable.

---

# 16. Common Mistakes

### ❌ Recreating the Chart Frequently

Update the existing series instead.

---

### ❌ Updating Charts from Worker Threads

Use signals and slots to forward data to the GUI thread.

---

### ❌ Plotting Millions of Points

Downsample or use a sliding window to keep rendering responsive.

---

### ❌ Missing Axis Configuration

Charts become difficult to interpret without proper ranges and labels.

---

### ❌ Forgetting Legends

Multiple series should usually include a legend.

---

# 17. Interview Questions

## Easy

1. What is Qt Charts?
2. What is `QChart`?
3. What is `QChartView`?

---

## Medium

1. Explain the relationship between `QChart` and `QChartView`.
2. What are chart series?
3. How do you create a real-time chart?

---

## Hard

1. Explain dynamic chart updates.
2. Compare different chart types and their use cases.
3. Describe how Qt renders charts.

---

## Expert

1. Design a Treatment Planning System dashboard displaying DVH curves, dose-volume statistics, beam delivery progress, and machine performance charts.
2. Explain how to optimize a chart displaying millions of continuously updated data points.
3. Compare Qt Charts with QCustomPlot, VTK charting, and web-based chart libraries.

---

# 18. Revision Notes

* Qt Charts provides ready-made chart components.
* `QChart` manages the chart.
* `QChartView` displays the chart in widget-based applications.
* Data is stored in series.
* Multiple chart types are available.
* Axes control scaling and labeling.
* Legends identify multiple series.
* Charts can update dynamically.
* Use signals and slots for thread-safe updates.
* Qt Charts integrates with both Widgets and QML.

---

# 💡 Senior Engineer Tips

## Choosing the Right Chart

| Requirement             | Recommended Chart    |
| ----------------------- | -------------------- |
| Trend over time         | `QLineSeries`        |
| Smooth trend            | `QSplineSeries`      |
| Category comparison     | `QBarSeries`         |
| Percentage              | `QPieSeries`         |
| Scientific measurements | `QScatterSeries`     |
| Range visualization     | `QAreaSeries`        |
| Financial OHLC          | `QCandlestickSeries` |

---

## Enterprise Dashboard Architecture

```text id="chart42"
        Sensors / Database
               │
               ▼
        Worker Threads
               │
         Signals & Slots
               │
               ▼
        ViewModel (C++)
               │
               ▼
      QChart / ChartView
               │
               ▼
            Dashboard
```

The ViewModel transforms raw data into chart-friendly values while the UI focuses on presentation.

---

## Medical TPS Example — DVH Dashboard

```text id="chart43"
          Dose Engine
               │
               ▼
      Dose Calculation Results
               │
               ▼
        DVH Generator
               │
      ┌────────┼────────┐
      ▼        ▼        ▼
    PTV DVH  Lung DVH Heart DVH
      │        │        │
      └────────┼────────┘
               ▼
         QLineSeries
               │
               ▼
            QChart
               │
               ▼
         Clinical Display
```

This architecture allows clinicians to:

* Compare multiple organ DVH curves.
* Zoom and inspect dose distributions.
* Update charts automatically after recalculation.
* Maintain smooth performance with incremental updates.

---


## **Chapter 95 — Qt SVG (Complete Deep Dive)**

