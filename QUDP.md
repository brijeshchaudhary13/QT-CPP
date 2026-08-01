# Complete Qt Master Course (Qt 5.15 LTS → Qt 6.11)

# PART X — Networking

# Chapter 75 — UDP (Complete Deep Dive)

## Master UDP, QUdpSocket, Broadcast, Multicast, Datagram Communication & Real-Time Networking

> **Level:** Advanced → Expert

---

# Chapter Objectives

After completing this chapter, you will understand:

* What is UDP?
* UDP Architecture
* UDP vs TCP
* Datagram Communication
* `QUdpSocket`
* Sending and Receiving Datagrams
* Broadcasting
* Multicasting
* Packet Loss
* Packet Ordering
* Reliability over UDP
* Real-Time Applications
* Enterprise Networking
* Qt Internals
* Qt 5.15 vs Qt 6.11
* Best Practices
* Interview Questions

---

# Table of Contents

1. Introduction
2. UDP Architecture
3. UDP vs TCP
4. What is a Datagram?
5. QUdpSocket
6. Sending Data
7. Receiving Data
8. Broadcasting
9. Multicasting
10. Packet Loss & Ordering
11. Building Reliability on UDP
12. Enterprise Applications
13. Qt Internals
14. Qt 5 vs Qt 6
15. Best Practices
16. Common Mistakes
17. Interview Questions
18. Revision Notes

---

# 1. Introduction

**UDP (User Datagram Protocol)** is a lightweight, connectionless transport protocol.

Unlike TCP:

* No connection setup
* No guaranteed delivery
* No retransmission
* No ordering guarantee
* Very low latency

UDP is designed for applications where **speed is more important than perfect reliability**.

---

## Architecture

```text
Qt Application

↓

Qt Network

↓

UDP

↓

IP

↓

Network
```

Unlike TCP, there is **no handshake** before sending data.

---

# 2. UDP Architecture

```text
+----------------------+
| Qt Application       |
+----------+-----------+
           │
           ▼
+----------------------+
| QUdpSocket           |
+----------+-----------+
           │
           ▼
+----------------------+
| UDP                  |
+----------+-----------+
           │
           ▼
+----------------------+
| IP                   |
+----------+-----------+
           │
           ▼
Network
```

Each message is transmitted as an independent **datagram**.

---

# 3. UDP vs TCP

| Feature           | TCP      | UDP     |
| ----------------- | -------- | ------- |
| Connection        | Yes      | No      |
| Reliable          | Yes      | No      |
| Ordered Delivery  | Yes      | No      |
| Retransmission    | Yes      | No      |
| Speed             | Moderate | High    |
| Header Size       | Larger   | Smaller |
| Latency           | Higher   | Lower   |
| Broadcast Support | No       | Yes     |
| Multicast Support | No       | Yes     |

---

## When to Use UDP

| Application      | TCP | UDP |
| ---------------- | --- | --- |
| File Transfer    | ✔   |     |
| Chat             | ✔   |     |
| HTTP             | ✔   |     |
| DNS              |     | ✔   |
| Live Video       |     | ✔   |
| Voice Call       |     | ✔   |
| Online Gaming    |     | ✔   |
| Device Discovery |     | ✔   |

---

# 4. What is a Datagram?

Unlike TCP streams,

UDP sends **individual packets**.

```text
Datagram 1

↓

Datagram 2

↓

Datagram 3
```

Each datagram is independent.

The receiver either receives the complete datagram or not at all.

Unlike TCP, UDP preserves message boundaries.

---

# 5. QUdpSocket

Header

```cpp
#include <QUdpSocket>
```

Create socket

```cpp
QUdpSocket socket;
```

Bind to a local port

```cpp
socket.bind(45454);
```

Binding allows the application to receive incoming UDP datagrams.

---

## Workflow

```text
Application

↓

QUdpSocket

↓

UDP

↓

Network
```

---

# 6. Sending Data

Send a datagram

```cpp
QUdpSocket socket;

socket.writeDatagram(
    "Hello",
    QHostAddress("192.168.1.10"),
    45454);
```

Workflow

```text
Application

↓

writeDatagram()

↓

UDP Packet

↓

Receiver
```

No connection establishment is required.

---

# 7. Receiving Data

Connect signal

```cpp
connect(
    &socket,
    &QUdpSocket::readyRead,
    this,
    &Receiver::processPendingDatagrams);
```

Typical receive loop

```cpp
while (socket.hasPendingDatagrams())
{
    QByteArray data;
    data.resize(socket.pendingDatagramSize());

    socket.readDatagram(
        data.data(),
        data.size());
}
```

Workflow

```text
Network

↓

UDP Packet

↓

QUdpSocket

↓

readyRead()

↓

Application
```

---

# 8. Broadcasting

Broadcast sends one datagram to **all devices on the local network**.

```text
Sender

↓

Broadcast

↓

PC 1

PC 2

PC 3

Printer

Medical Device
```

Qt example

```cpp
socket.writeDatagram(
    "DISCOVER",
    QHostAddress::Broadcast,
    45454);
```

Applications

* Device discovery
* Industrial automation
* Medical equipment detection
* LAN services

---

# 9. Multicasting

Broadcast reaches everyone.

Multicast reaches **only interested devices**.

```text
            Sender

              │

       Multicast Group

     ┌────────┴─────────┐

     ▼                  ▼

 Device A          Device B
```

Join group

```cpp
socket.joinMulticastGroup(
    QHostAddress("239.255.0.1"));
```

Leave group

```cpp
socket.leaveMulticastGroup(
    QHostAddress("239.255.0.1"));
```

Applications

* Live video
* Stock market feeds
* Sensor networks
* Industrial monitoring

---

# 10. Packet Loss & Ordering

UDP does **not** guarantee delivery.

Possible scenarios

```text
Packet 1 ✔

Packet 2 ✘ Lost

Packet 3 ✔
```

or

```text
Packet 3

↓

Packet 1

↓

Packet 2
```

Packets may:

* Arrive late
* Arrive out of order
* Be duplicated
* Be dropped

Applications must tolerate these situations if they matter.

---

# 11. Building Reliability on UDP

Some protocols add reliability themselves.

Example

```text
Packet

↓

Sequence Number

↓

Checksum

↓

Acknowledgment
```

Possible workflow

```text
Sender

↓

Packet #15

↓

Receiver

↓

ACK #15
```

If no acknowledgment arrives within a timeout,

the sender may retransmit.

This is how many real-time protocols implement selective reliability.

---

# 12. Enterprise Applications

## Device Discovery

```text
Application

↓

Broadcast

↓

Available Devices
```

---

## Industrial Automation

```text
PLC

↓

UDP

↓

HMI
```

---

## Medical Systems

```text
Treatment Machine

↓

Discovery Packet

↓

TPS
```

---

## Gaming

```text
Player

↓

Movement Packet

↓

Game Server
```

Small delays are often preferable to waiting for retransmissions.

---

# 13. Qt Internals

```text
Application

↓

QUdpSocket

↓

QAbstractSocket

↓

Operating System

↓

UDP Stack

↓

Network
```

Receiving

```text
Network

↓

OS UDP Buffer

↓

QUdpSocket

↓

readyRead()

↓

Application
```

Unlike TCP, each received datagram remains a distinct packet.

---

# 14. Qt 5 vs Qt 6

| Feature          | Qt 5.15 | Qt 6.11 |
| ---------------- | ------- | ------- |
| QUdpSocket       | ✔       | ✔       |
| Broadcast        | ✔       | ✔       |
| Multicast        | ✔       | ✔       |
| IPv6             | ✔       | ✔       |
| Asynchronous API | ✔       | ✔       |

The UDP API is almost unchanged between Qt 5 and Qt 6.

---

# 15. Best Practices

✅ Use UDP only when reliability is not essential or is handled by your protocol.

✅ Keep datagrams reasonably small to reduce fragmentation.

✅ Include sequence numbers if packet order matters.

✅ Validate every received packet.

✅ Use multicast instead of broadcast when only a subset of devices should receive data.

---

# 16. Common Mistakes

### ❌ Assuming every packet arrives

UDP offers no delivery guarantee.

---

### ❌ Assuming packets arrive in order

Always handle out-of-order packets if ordering matters.

---

### ❌ Sending excessively large datagrams

Large packets are more likely to be fragmented or dropped.

---

### ❌ Ignoring packet validation

Malformed or unexpected packets should be rejected.

---

### ❌ Using UDP for reliable file transfer without additional protocol logic

TCP is generally the better choice unless you implement your own reliability mechanisms.

---

# 17. Interview Questions

## Easy

1. What is UDP?
2. How is UDP different from TCP?
3. What is `QUdpSocket`?

---

## Medium

1. What is a datagram?
2. Explain broadcast and multicast.
3. Why doesn't UDP guarantee delivery?

---

## Hard

1. Design a UDP-based device discovery protocol.
2. How would you add reliability to UDP?
3. Compare TCP streams with UDP datagrams.

---

## Expert

1. Design the networking architecture for automatic discovery of radiation therapy machines on a hospital LAN using UDP broadcast, followed by TCP for reliable communication.
2. Explain how multiplayer games maintain smooth movement despite packet loss.
3. Compare UDP, TCP, QUIC, and RTP for real-time desktop applications.

---

# 18. Revision Notes

* UDP is a connectionless transport protocol.
* `QUdpSocket` provides UDP communication in Qt.
* UDP sends independent datagrams.
* UDP preserves message boundaries.
* Broadcast sends to all devices on a subnet.
* Multicast sends to subscribed devices only.
* Packet loss and reordering are normal.
* Reliability must be implemented by the application if required.
* Qt networking is asynchronous and event-driven.

---

# 💡 Senior Engineer Tips

## TCP vs UDP Decision Guide

| Requirement         | TCP       | UDP |
| ------------------- | --------- | --- |
| Guaranteed delivery | ✔         | ✘   |
| Lowest latency      | ✘         | ✔   |
| Device discovery    | ✘         | ✔   |
| File transfer       | ✔         | ✘   |
| Real-time telemetry | Sometimes | ✔   |
| Live audio/video    | ✘         | ✔   |

---

## Enterprise Qt Networking Architecture

```text
Qt UI
   │
   ▼
Network Manager
   │
   ├──────────────┐
   ▼              ▼
TCP Service   UDP Service
   │              │
   ▼              ▼
Reliable      Discovery /
Messaging     Telemetry
```

Using separate services for TCP and UDP keeps responsibilities clear and simplifies maintenance.

---

## Medical TPS Example

```text
Treatment Planning System
          │
          ├──────────────────────────┐
          ▼                          ▼
UDP Broadcast                 TCP Connection
(Device Discovery)        (Reliable Communication)
          │                          │
          ▼                          ▼
Treatment Machine          Patient Data
MLC Controller             Treatment Plan
Imaging Device             Delivery Status
```

A common architecture is:

* **UDP** for discovering devices on the local network.
* **TCP** for transferring treatment plans, machine status, and other critical data where reliability is essential.

---

## **Chapter 76 — HTTP (Complete Deep Dive)**

