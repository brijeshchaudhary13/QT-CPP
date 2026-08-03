
# Chapter 100 — Qt Serial Port (Complete Deep Dive)



---

# 1. Introduction

Serial communication is one of the oldest and most widely used methods for communication between computers and external devices.

Qt provides the **Qt Serial Port** module to communicate with:

* Medical devices
* CNC machines
* PLCs
* Industrial controllers
* GPS modules
* Barcode scanners
* Sensors
* Microcontrollers (Arduino, STM32, ESP32)

---

## Architecture

```text id="sp01"
Qt Application

↓

Qt Serial Port

↓

Operating System Driver

↓

COM Port

↓

Device
```

---

# 2. Serial Communication Fundamentals

Serial communication sends data **one bit at a time**.

Unlike parallel communication, only a small number of wires are required.

---

Typical communication

```text id="sp02"
Computer

↓

Serial Port

↓

Device
```

---

Applications

* Industrial automation
* Robotics
* Medical systems
* Embedded devices

---

# 3. UART

UART stands for

**Universal Asynchronous Receiver/Transmitter**

UART defines how data is transmitted asynchronously.

Typical frame

```text id="sp03"
Start

↓

Data Bits

↓

Parity

↓

Stop
```

Example (8N1)

```text id="sp04"
1 Start

8 Data

No Parity

1 Stop
```

8N1 is one of the most common serial configurations.

---

# 4. RS-232 vs RS-422 vs RS-485

## RS-232

* Point-to-point
* Short distance
* Common for legacy devices

---

## RS-422

* Longer distance
* Differential signaling
* Better noise immunity

---

## RS-485

* Multi-device bus
* Industrial automation
* Long distance
* Excellent noise resistance

---

Comparison

| Feature        | RS-232  | RS-422             | RS-485             |
| -------------- | ------- | ------------------ | ------------------ |
| Devices        | 2       | Multiple receivers | Multi-drop network |
| Distance       | Short   | Long               | Long               |
| Noise Immunity | Low     | High               | Very High          |
| Industrial Use | Limited | Good               | Excellent          |

---

# 5. Qt Serial Port Architecture

Qt classes

* `QSerialPort`
* `QSerialPortInfo`

Architecture

```text id="sp05"
Application

↓

QSerialPort

↓

Driver

↓

COM Port

↓

Device
```

---

# 6. QSerialPortInfo

Header

```cpp id="sp06"
#include <QSerialPortInfo>
```

Enumerate ports

```cpp id="sp07"
QSerialPortInfo::
availablePorts()
```

Information available

* Port name
* Manufacturer
* Description
* Vendor ID
* Product ID
* Serial number (if provided by the device)

---

Typical workflow

```text id="sp08"
Scan

↓

COM Ports

↓

User Selects Port
```

---

# 7. QSerialPort

Header

```cpp id="sp09"
#include <QSerialPort>
```

Create

```cpp id="sp10"
QSerialPort port;
```

Select port

```cpp id="sp11"
port.setPortName(
"COM3");
```

> On Linux, device names are typically `/dev/ttyUSB0`, `/dev/ttyS0`, or `/dev/ttyACM0`.

---

Open

```cpp id="sp12"
port.open(
QIODevice::ReadWrite);
```

---

Configure baud rate

```cpp id="sp13"
port.setBaudRate(
115200);
```

---

Configure data bits

```cpp id="sp14"
port.setDataBits(
QSerialPort::Data8);
```

---

Parity

```cpp id="sp15"
port.setParity(
QSerialPort::NoParity);
```

---

Stop bits

```cpp id="sp16"
port.setStopBits(
QSerialPort::OneStop);
```

---

Flow control

```cpp id="sp17"
port.setFlowControl(
QSerialPort::NoFlowControl);
```

---

# 8. Reading & Writing Data

Write

```cpp id="sp18"
port.write(data);
```

Read

```cpp id="sp19"
QByteArray data =
port.readAll();
```

---

Signal

```cpp id="sp20"
readyRead()
```

Workflow

```text id="sp21"
Device

↓

Serial Port

↓

readyRead()

↓

Application
```

---

Write pipeline

```text id="sp22"
Application

↓

QSerialPort

↓

Driver

↓

Device
```

---

# 9. Binary Protocol Design

Most embedded devices use binary protocols.

Example packet

```text id="sp23"
Header

↓

Command

↓

Length

↓

Payload

↓

CRC
```

Example

```text id="sp24"
AA

01

04

11 22 33 44

CRC
```

Advantages

* Fast
* Compact
* Efficient

---

Typical parser

```text id="sp25"
Receive Bytes

↓

Buffer

↓

Frame Parser

↓

Command Handler
```

---

# 10. Asynchronous Communication

Avoid blocking the GUI thread.

Use Qt signals.

```text id="sp26"
Device

↓

Driver

↓

readyRead()

↓

Parser

↓

UI
```

If packet parsing or processing is computationally expensive, move that work to a worker thread after receiving the data.

---

# 11. Error Handling

Possible errors

* Port unavailable
* Device disconnected
* Timeout
* Parity error
* Framing error
* Buffer overflow

Qt signal

```cpp id="sp27"
errorOccurred()
```

Recovery

```text id="sp28"
Detect

↓

Log

↓

Reconnect
```

---

# 12. Enterprise Applications

## Medical Device

```text id="sp29"
LINAC

↓

Serial

↓

Qt
```

---

## PLC

```text id="sp30"
PLC

↓

Serial

↓

Dashboard
```

---

## Robotics

```text id="sp31"
Robot

↓

UART

↓

Qt
```

---

## CNC

```text id="sp32"
Controller

↓

RS-485

↓

Application
```

---

# 13. Qt Internals

```text id="sp33"
Qt

↓

QSerialPort

↓

OS Driver

↓

UART

↓

Device
```

Receiving

```text id="sp34"
Interrupt

↓

Driver Buffer

↓

QSerialPort

↓

Signal

↓

Application
```

Qt integrates with the operating system's serial driver and delivers incoming data asynchronously through the event loop.

---

# 14. Qt 5 vs Qt 6

| Feature         | Qt 5.15 | Qt 6.11 |
| --------------- | ------- | ------- |
| QSerialPort     | ✔       | ✔       |
| QSerialPortInfo | ✔       | ✔       |
| Async API       | ✔       | ✔       |
| Cross-platform  | ✔       | ✔       |

The Qt Serial Port API is highly stable across Qt 5 and Qt 6.

---

# 15. Best Practices

✅ Use asynchronous communication.

✅ Parse complete packets instead of assuming one `readyRead()` equals one message.

✅ Validate checksums or CRC values.

✅ Handle unexpected disconnections gracefully.

✅ Keep protocol parsing separate from UI code.

---

# 16. Common Mistakes

### ❌ Assuming `readyRead()` Delivers a Complete Packet

Serial communication is stream-based. A packet may arrive in multiple chunks.

---

### ❌ Blocking the GUI Thread

Avoid long processing inside `readyRead()`.

---

### ❌ Ignoring Timeouts

Implement timeout handling for incomplete packets.

---

### ❌ Hardcoding Protocol Values

Define commands and packet formats in shared protocol headers.

---

### ❌ Forgetting to Close the Port

Release the port cleanly when communication ends.

---

# 17. Interview Questions

## Easy

1. What is UART?
2. What is `QSerialPort`?
3. What is `QSerialPortInfo`?

---

## Medium

1. Compare RS-232, RS-422, and RS-485.
2. Explain `readyRead()`.
3. How do you configure a serial port?

---

## Hard

1. Explain why serial communication is stream-based.
2. Design a packet parser for a binary protocol.
3. How would you recover from serial communication failures?

---

## Expert

1. Design a communication layer for a LINAC controller that exchanges commands, status updates, and alarms over RS-485.
2. Explain how to build a reusable serial communication framework supporting multiple devices with different protocols.
3. Compare Qt Serial Port with Boost.Asio, libserialport, and native Win32/POSIX serial APIs.

---

# 18. Revision Notes

* Qt Serial Port provides cross-platform serial communication.
* `QSerialPortInfo` discovers available ports.
* `QSerialPort` manages communication.
* UART defines asynchronous serial transmission.
* RS-232, RS-422, and RS-485 serve different physical communication needs.
* Serial communication is stream-based.
* `readyRead()` signals incoming data.
* Use packet framing and CRC validation.
* Handle errors and reconnection properly.
* Qt 5 and Qt 6 APIs are largely identical.

---

# 💡 Senior Engineer Tips

## Choosing the Right Interface

| Requirement                   | Recommended |
| ----------------------------- | ----------- |
| Microcontroller               | UART        |
| Legacy instrument             | RS-232      |
| Industrial PLC                | RS-485      |
| Multi-drop industrial network | RS-485      |
| Automotive ECU                | CAN Bus     |
| IoT Sensor                    | BLE         |

---

## Enterprise Serial Communication Architecture

```text id="sp35"
            Qt UI
              │
              ▼
     Device Communication Manager
              │
      ┌───────┼────────┐
      ▼       ▼        ▼
 Serial   Protocol   Logger
 Driver    Parser
      │       │
      └───────┼────────┘
              ▼
         QSerialPort
              │
              ▼
         COM / UART
              │
              ▼
        External Device
```

A dedicated communication manager should:

* Manage connections.
* Buffer incoming data.
* Parse protocol packets.
* Dispatch commands.
* Log communication.
* Handle reconnection.

---

## Medical TPS / LINAC Example

```text id="sp36"
       Treatment Planning System
                 │
                 ▼
        Machine Controller
                 │
      ┌──────────┼──────────┐
      ▼          ▼          ▼
 Beam Cmds   Status    Fault Monitor
      │          │          │
      └──────────┼──────────┘
                 ▼
        Protocol Encoder
                 │
                 ▼
          QSerialPort
                 │
                 ▼
          RS-485 Network
                 │
                 ▼
             LINAC Device
```

Features:

* Reliable command transmission.
* CRC validation.
* Alarm monitoring.
* Automatic timeout detection.
* Safe reconnection after communication failures.

This architecture is commonly used in **industrial automation**, **medical equipment**, and **embedded control systems**.

---



## **Chapter 101 — Modern CMake (Complete Deep Dive)**

