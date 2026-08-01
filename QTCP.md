# Complete Qt Master Course (Qt 5.15 LTS → Qt 6.11)

# PART X — Networking

# Chapter 74 — TCP (Complete Deep Dive)

## Master TCP/IP, QTcpSocket, QTcpServer, Client-Server Architecture & Enterprise Networking

> **Level:** Advanced → Expert

---

# Chapter Objectives

After completing this chapter, you will understand:

* What is Networking?
* OSI Model
* TCP/IP Model
* What is TCP?
* TCP vs UDP
* Client-Server Architecture
* `QTcpSocket`
* `QTcpServer`
* TCP Connection Lifecycle
* Packet Framing
* Binary vs Text Protocols
* Multi-Client Server Design
* Enterprise Networking
* Qt Internals
* Qt 5.15 vs Qt 6.11
* Best Practices
* Interview Questions

---

# Table of Contents

1. Introduction
2. OSI Model
3. TCP/IP Model
4. What is TCP?
5. TCP vs UDP
6. Client-Server Architecture
7. QTcpSocket
8. QTcpServer
9. Connection Lifecycle
10. Reading & Writing Data
11. Packet Framing
12. Binary vs Text Protocols
13. Multi-Client Servers
14. Error Handling
15. Enterprise Applications
16. Qt Internals
17. Qt 5 vs Qt 6
18. Best Practices
19. Common Mistakes
20. Interview Questions
21. Revision Notes

---

# 1. Introduction

Networking allows applications running on different computers (or the same computer) to communicate.

Examples:

* Chat applications
* Web browsers
* Email
* Medical devices
* Hospital Information Systems
* Cloud applications
* Industrial automation

Qt provides networking support through the **Qt Network** module.

---

## Architecture

```text
Qt Application

↓

Qt Network

↓

Operating System

↓

TCP/IP

↓

Network
```

---

# 2. OSI Model

The OSI (Open Systems Interconnection) model divides networking into seven layers.

```text
+----------------------+
| 7. Application       |
+----------------------+
| 6. Presentation      |
+----------------------+
| 5. Session           |
+----------------------+
| 4. Transport         |
+----------------------+
| 3. Network           |
+----------------------+
| 2. Data Link         |
+----------------------+
| 1. Physical          |
+----------------------+
```

---

## Layer Responsibilities

| Layer        | Responsibility          |
| ------------ | ----------------------- |
| Application  | HTTP, FTP, SMTP         |
| Presentation | Encryption, Compression |
| Session      | Connection management   |
| Transport    | TCP, UDP                |
| Network      | IP Routing              |
| Data Link    | Ethernet, Wi-Fi         |
| Physical     | Cables, Radio           |

Qt developers mainly work at the **Application Layer**, while Qt abstracts most lower-level networking details.

---

# 3. TCP/IP Model

The TCP/IP model is the practical networking model used on the Internet.

```text
Application

↓

Transport

↓

Internet

↓

Link
```

Protocols:

| Layer       | Protocols       |
| ----------- | --------------- |
| Application | HTTP, FTP, SMTP |
| Transport   | TCP, UDP        |
| Internet    | IP              |
| Link        | Ethernet, Wi-Fi |

---

# 4. What is TCP?

**TCP (Transmission Control Protocol)** is a reliable, connection-oriented transport protocol.

Characteristics:

* Reliable delivery
* Ordered packets
* Error checking
* Flow control
* Congestion control

---

## Communication

```text
Client

↓

TCP

↓

Server
```

TCP guarantees that data arrives in order or reports a failure.

---

## Real Example

```text
Chat Client

↓

TCP

↓

Chat Server
```

Every message reaches the server in the same order it was sent.

---

# 5. TCP vs UDP

| Feature        | TCP                 | UDP            |
| -------------- | ------------------- | -------------- |
| Reliable       | ✔                   | ✘              |
| Connection     | Connection-Oriented | Connectionless |
| Packet Order   | Guaranteed          | Not Guaranteed |
| Speed          | Moderate            | Faster         |
| Error Recovery | ✔                   | ✘              |
| Streaming      | Good                | Limited        |

---

## Which Should You Use?

| Application   | TCP | UDP |
| ------------- | --- | --- |
| Chat          | ✔   |     |
| HTTP          | ✔   |     |
| Database      | ✔   |     |
| File Transfer | ✔   |     |
| Live Gaming   |     | ✔   |
| Live Video    |     | ✔   |
| VoIP          |     | ✔   |

---

# 6. Client-Server Architecture

Every TCP application consists of:

* Client
* Server

```text
Client

↓

TCP

↓

Server
```

The server waits for incoming connections.

The client initiates the connection.

---

## Example

```text
Qt Client

↓

Hospital Server

↓

Database
```

---

# 7. QTcpSocket

Header

```cpp
#include <QTcpSocket>
```

Create socket

```cpp
QTcpSocket socket;
```

Connect

```cpp
socket.connectToHost(
    "127.0.0.1",
    8080);
```

---

## Workflow

```text
Application

↓

QTcpSocket

↓

TCP

↓

Server
```

---

## Important Signals

| Signal          | Purpose                |
| --------------- | ---------------------- |
| connected()     | Connected successfully |
| disconnected()  | Connection closed      |
| readyRead()     | Data available         |
| errorOccurred() | Network error          |

---

# 8. QTcpServer

Header

```cpp
#include <QTcpServer>
```

Create server

```cpp
QTcpServer server;
```

Listen

```cpp
server.listen(
    QHostAddress::Any,
    8080);
```

Wait

```text
Server

↓

Listening

↓

New Client

↓

Accept
```

---

## Important Signals

| Signal          | Purpose              |
| --------------- | -------------------- |
| newConnection() | New client connected |
| acceptError()   | Accept failed        |

---

# 9. Connection Lifecycle

Complete TCP lifecycle

```text
Client

↓

Connect

↓

Server Accepts

↓

Exchange Data

↓

Disconnect

↓

Close Socket
```

---

TCP Handshake

```text
Client

↓

SYN

↓

Server

↓

SYN-ACK

↓

Client

↓

ACK
```

This is called the **three-way handshake**.

---

# 10. Reading & Writing Data

Send

```cpp
socket.write(data);
```

Read

```cpp
QByteArray data =
    socket.readAll();
```

Read when data arrives

```cpp
connect(
    &socket,
    &QTcpSocket::readyRead,
    this,
    &MyClass::readData);
```

---

Workflow

```text
Sender

↓

write()

↓

TCP

↓

Receiver

↓

readyRead()
```

---

# 11. Packet Framing

**Important Concept**

TCP is a **byte stream**, **not a message protocol**.

Example

Sender

```text
Message1

Message2
```

Receiver may receive

```text
Message1Message2
```

or

```text
Mes

sage1

Message2
```

TCP does **not** preserve application-level message boundaries.

---

## Length Prefix Protocol

Common solution

```text
Length

↓

Message
```

Example

```text
20

↓

Hello Qt Network...
```

Receiver

```text
Read Length

↓

Read Exactly N Bytes

↓

Process Message
```

This is the recommended approach for binary protocols.

---

# 12. Binary vs Text Protocols

## Text

```text
LOGIN John

GET FILE
```

Advantages

* Human-readable
* Easy debugging

---

## Binary

```text
010101101001...
```

Advantages

* Faster
* Smaller
* Efficient

---

Comparison

| Feature   | Text   | Binary  |
| --------- | ------ | ------- |
| Readable  | ✔      | ✘       |
| Size      | Larger | Smaller |
| Speed     | Lower  | Higher  |
| Debugging | Easy   | Hard    |

---

# 13. Multi-Client Servers

One server

Many clients

```text
          Server

      /     |     \

 Client1 Client2 Client3
```

Qt accepts each incoming connection as a separate `QTcpSocket`.

Typical architecture

```text
QTcpServer

↓

newConnection()

↓

QTcpSocket

↓

Client Handler
```

Each client should be managed independently.

---

# 14. Error Handling

Always monitor network errors.

Qt

```cpp
connect(
    socket,
    &QTcpSocket::errorOccurred,
    ...
);
```

Common errors

| Error             | Example             |
| ----------------- | ------------------- |
| HostNotFound      | Wrong hostname      |
| ConnectionRefused | Server offline      |
| RemoteHostClosed  | Server disconnected |
| NetworkError      | Network failure     |
| Timeout           | No response         |

Applications should recover gracefully where possible.

---

# 15. Enterprise Applications

## Chat

```text
Client

↓

Server

↓

Clients
```

---

## Hospital

```text
Medical Device

↓

TCP

↓

Hospital Server

↓

Database
```

---

## Industrial Automation

```text
PLC

↓

TCP

↓

HMI
```

---

## Medical TPS

```text
TPS

↓

TCP

↓

License Server
```

or

```text
TPS

↓

TCP

↓

DICOM Gateway
```

---

# 16. Qt Internals

```text
Application

↓

QTcpSocket

↓

QAbstractSocket

↓

Operating System

↓

TCP Stack

↓

Network
```

Incoming data

```text
Network

↓

OS TCP Buffer

↓

QTcpSocket

↓

readyRead()

↓

Application
```

Qt integrates socket events with the event loop, so networking is asynchronous by default.

---

# 17. Qt 5 vs Qt 6

| Feature          | Qt 5.15 | Qt 6.11 |
| ---------------- | ------- | ------- |
| QTcpSocket       | ✔       | ✔       |
| QTcpServer       | ✔       | ✔       |
| Signals/Slots    | ✔       | ✔       |
| IPv6 Support     | ✔       | ✔       |
| Asynchronous API | ✔       | ✔       |

The TCP networking API is largely unchanged between Qt 5 and Qt 6.

---

# 18. Best Practices

✅ Always handle partial reads.

✅ Use length-prefixed messages for binary protocols.

✅ Keep network operations asynchronous.

✅ Handle disconnects gracefully.

✅ Validate all incoming data.

---

# 19. Common Mistakes

### ❌ Assuming one `write()` equals one `readyRead()`

TCP is a stream; data may arrive in different-sized chunks.

---

### ❌ Blocking the UI thread

Long-running work should not execute directly in networking callbacks.

---

### ❌ Ignoring network errors

Always connect to `errorOccurred()`.

---

### ❌ Trusting client input

Validate protocol messages before processing them.

---

### ❌ Forgetting to clean up disconnected sockets

Release resources when clients disconnect.

---

# 20. Interview Questions

## Easy

1. What is TCP?
2. What is the difference between TCP and UDP?
3. What is `QTcpSocket`?

---

## Medium

1. Explain the TCP three-way handshake.
2. What is `QTcpServer`?
3. Why is packet framing necessary?

---

## Hard

1. Explain why TCP does not preserve message boundaries.
2. Design a multi-client TCP server in Qt.
3. How would you implement a binary protocol?

---

## Expert

1. Design the networking architecture for a Medical Treatment Planning System communicating with a license server, DICOM gateway, and treatment delivery machine.
2. Explain how to build a scalable Qt TCP server capable of handling thousands of concurrent clients.
3. Compare TCP, UDP, WebSockets, HTTP, and gRPC for desktop engineering applications.

---

# 21. Revision Notes

* TCP is a reliable, connection-oriented protocol.
* `QTcpSocket` implements TCP clients.
* `QTcpServer` accepts incoming TCP connections.
* TCP uses a three-way handshake.
* TCP provides a byte stream, not message boundaries.
* Packet framing is required for custom protocols.
* Qt networking is asynchronous by default.
* Each client is represented by its own `QTcpSocket`.
* Always handle partial reads and network errors.

---

# 💡 Senior Engineer Tips

## Which Networking Technology Should You Use?

| Requirement                  | Recommended |
| ---------------------------- | ----------- |
| Chat application             | TCP         |
| File transfer                | TCP         |
| REST API                     | HTTP        |
| Browser communication        | WebSocket   |
| Video streaming              | UDP         |
| Medical device communication | TCP         |

---

## Enterprise Qt Networking Architecture

```text
Qt UI
   │
   ▼
Network Manager
   │
   ▼
Protocol Layer
   │
   ▼
QTcpSocket
   │
   ▼
TCP/IP
   │
   ▼
Remote Server
```

Separating the **Protocol Layer** from the UI makes testing and maintenance much easier.

---

## Medical TPS Example

```text
Treatment Planning System
          │
          ▼
Network Service
          │
 ┌────────┼────────┐
 ▼        ▼        ▼
License  DICOM   Treatment
Server   Gateway  Machine
   │        │        │
   └────────┼────────┘
            ▼
      TCP Connections
```

Each external system should have its own connection manager, protocol parser, and error-handling logic rather than sharing a single socket for unrelated services.

---

## **Chapter 75 — UDP (Complete Deep Dive)**


