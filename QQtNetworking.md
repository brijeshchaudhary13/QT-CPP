Excellent.

Networking is one of the **core pillars of modern Qt applications**.

Almost every professional desktop application communicates with something:

* Database Server
* REST API
* PACS Server
* DICOM Server
* License Server
* Cloud Storage
* Update Server
* AI Service
* WebSocket Server

If you're building a **Medical Treatment Planning System (TPS)**, networking is indispensable for:

* PACS communication
* DICOM image transfer
* License validation
* Machine communication
* Cloud backup
* User authentication

Qt provides one of the cleanest asynchronous networking APIs among C++ frameworks.

---

# Complete Qt Master Course (Qt 5.15 LTS → Qt 6.11)

# PART X — Networking

# Chapter 49 — Qt Networking (Complete Deep Dive)

## Part 1 — Qt Network Module, TCP, UDP, HTTP, QNetworkAccessManager & Asynchronous Communication

> **Level:** Beginner → Expert

---

# Chapter Objectives

After completing this chapter, you will understand:

* Qt Network Module
* Client-Server architecture
* TCP vs UDP
* `QTcpSocket`
* `QTcpServer`
* `QUdpSocket`
* `QNetworkAccessManager`
* HTTP/HTTPS
* Asynchronous networking
* Qt 5 vs Qt 6

---

# Table of Contents

1. Introduction to Qt Networking
2. Client–Server Architecture
3. TCP vs UDP
4. QTcpSocket
5. QTcpServer
6. QUdpSocket
7. QNetworkAccessManager
8. HTTP & HTTPS
9. Asynchronous Communication
10. Qt Networking Internals
11. Qt 5 vs Qt 6
12. Best Practices
13. Interview Questions
14. Revision Notes

---

# 1. Introduction to Qt Networking

Qt's networking module allows applications to communicate over networks using a high-level asynchronous API.

Common use cases:

* REST APIs
* Web services
* Database gateways
* File transfer
* Device communication
* WebSockets
* Medical imaging servers (PACS)
* License servers

Include the module:

```cpp
#include <QTcpSocket>
#include <QTcpServer>
#include <QUdpSocket>
#include <QNetworkAccessManager>
```

The module is event-driven and integrates with Qt's event loop.

---

# 2. Client–Server Architecture

Most network applications follow a client-server model.

```text
          Client
             │
      Request
             │
             ▼
          Server
             │
      Response
             │
             ▼
          Client
```

Examples:

| Client          | Server         |
| --------------- | -------------- |
| TPS             | PACS           |
| Browser         | Website        |
| Desktop App     | REST API       |
| Mobile App      | Backend        |
| License Manager | License Server |

---

## TPS Example

```text
Treatment Planning System

↓

Request CT Images

↓

PACS Server

↓

Send DICOM Images

↓

TPS Displays Images
```

---

# 3. TCP vs UDP

## TCP

Characteristics:

* Connection-oriented
* Reliable
* Ordered delivery
* Error checking
* Retransmission

Workflow:

```text
Connect

↓

Send

↓

Receive

↓

Disconnect
```

Typical uses:

* REST APIs
* Database communication
* File transfer
* DICOM networking
* Login systems

---

## UDP

Characteristics:

* Connectionless
* Faster
* Lower overhead
* No delivery guarantee
* No ordering guarantee

Workflow:

```text
Send Datagram

↓

Receive Datagram
```

Typical uses:

* Live telemetry
* Discovery protocols
* Streaming
* Multiplayer games

---

## Comparison

| Feature        | TCP      | UDP    |
| -------------- | -------- | ------ |
| Reliable       | ✔        | ✘      |
| Ordered        | ✔        | ✘      |
| Connection     | ✔        | ✘      |
| Speed          | Moderate | Faster |
| Retransmission | ✔        | ✘      |

---

# 4. QTcpSocket

`QTcpSocket` implements a TCP client.

Header:

```cpp
#include <QTcpSocket>
```

Create:

```cpp
QTcpSocket *socket = new QTcpSocket(this);
```

Connect:

```cpp
socket->connectToHost(
    "example.com",
    80);
```

Send:

```cpp
socket->write(data);
```

Receive:

```cpp
connect(socket,
        &QTcpSocket::readyRead,
        this,
        &Client::readData);
```

Lifecycle:

```text
Create Socket

↓

Connect

↓

Connected

↓

Send Data

↓

Receive Data

↓

Disconnect
```

---

# 5. QTcpServer

Used to create TCP servers.

Header:

```cpp
#include <QTcpServer>
```

Example:

```cpp
QTcpServer *server =
    new QTcpServer(this);

server->listen(
    QHostAddress::Any,
    8080);
```

Workflow:

```text
Server Starts

↓

Listen

↓

Client Connects

↓

Accept Connection

↓

Exchange Data
```

---

# 6. QUdpSocket

Provides UDP communication.

Header:

```cpp
#include <QUdpSocket>
```

Create:

```cpp
QUdpSocket *socket =
    new QUdpSocket(this);
```

Send:

```cpp
socket->writeDatagram(...);
```

Receive:

```cpp
readyRead()
```

Typical uses:

* Broadcast discovery
* Lightweight messaging
* Telemetry

---

# 7. QNetworkAccessManager

High-level API for HTTP/HTTPS.

Header:

```cpp
#include <QNetworkAccessManager>
```

Create:

```cpp
QNetworkAccessManager manager;
```

GET request:

```cpp
manager.get(request);
```

POST request:

```cpp
manager.post(request,data);
```

PUT:

```cpp
manager.put(...);
```

DELETE:

```cpp
manager.deleteResource(...);
```

---

Architecture:

```text
Application

↓

NetworkAccessManager

↓

HTTP

↓

Server
```

---

# 8. HTTP & HTTPS

HTTP Methods:

```text
GET

POST

PUT

PATCH

DELETE
```

Examples:

GET:

```text
Download Patient Data
```

POST:

```text
Upload Plan
```

PUT:

```text
Update Record
```

DELETE:

```text
Delete Resource
```

HTTPS adds encryption using TLS.

---

# 9. Asynchronous Communication

Qt networking is asynchronous.

Instead of:

```text
Request

↓

Wait

↓

Freeze
```

Qt uses:

```text
Request

↓

Return Immediately

↓

Event Loop

↓

Response Arrives

↓

Signal
```

Example signals:

* `connected()`
* `readyRead()`
* `disconnected()`
* `errorOccurred()`

This keeps the GUI responsive.

---

# 10. Qt Networking Internals

Conceptually:

```text
Application

↓

Socket

↓

Operating System

↓

Network Stack

↓

Internet

↓

Remote Server
```

Data flow:

```text
write()

↓

TCP Buffer

↓

Network

↓

Remote Host

↓

Reply

↓

readyRead()
```

Qt integrates socket events into the event loop, so you usually don't need dedicated polling.

---

# 11. Qt 5.15 vs Qt 6.11

| Feature               | Qt 5.15 | Qt 6.11 |
| --------------------- | ------- | ------- |
| QTcpSocket            | ✔       | ✔       |
| QTcpServer            | ✔       | ✔       |
| QUdpSocket            | ✔       | ✔       |
| QNetworkAccessManager | ✔       | ✔       |
| HTTPS                 | ✔       | ✔       |

The networking APIs remain highly compatible.

---

# 12. Best Practices

✅ Prefer asynchronous networking.

✅ Connect to error signals and handle failures.

✅ Reuse `QNetworkAccessManager` instead of creating one per request.

✅ Validate server responses before processing.

✅ Keep networking code separate from UI code.

---

# 13. Common Mistakes

### ❌ Blocking the GUI waiting for network replies

Always use asynchronous APIs.

---

### ❌ Creating a new `QNetworkAccessManager` for every request

Reuse a long-lived manager when practical.

---

### ❌ Ignoring network errors

Handle connection failures, timeouts, and invalid responses gracefully.

---

### ❌ Assuming all data arrives in one `readyRead()`

TCP is a stream protocol. Messages may arrive in multiple chunks or multiple messages may arrive together. Your protocol should define how message boundaries are detected.

---

# 14. Interview Questions

## Easy

1. What is `QTcpSocket`?
2. What is `QTcpServer`?
3. What is `QNetworkAccessManager`?

---

## Medium

1. Compare TCP and UDP.
2. Explain asynchronous networking in Qt.
3. Why is `QNetworkAccessManager` preferred for HTTP?

---

## Hard

1. Describe the lifecycle of a TCP connection.
2. Explain why `readyRead()` may be emitted multiple times for one logical message.
3. Compare low-level socket APIs with `QNetworkAccessManager`.

---

## Expert

1. Design the networking architecture for a Treatment Planning System communicating with PACS, a license server, and cloud storage simultaneously.
2. Explain how Qt integrates socket notifications into its event loop.
3. Design a protocol that safely transfers large medical image datasets over TCP.

---

# 15. Architecture Diagram

```text
                 GUI Application
                        │
                        ▼
           QNetworkAccessManager
              │         │
              ▼         ▼
        QTcpSocket   QUdpSocket
              │         │
              ▼         ▼
          TCP/IP Stack  UDP/IP Stack
                │         │
                └────┬────┘
                     ▼
                 Network
                     │
                     ▼
          Remote Server / PACS
```

---

# 🏥 Production Example — Treatment Planning System

```text
Doctor Opens Patient
          │
          ▼
TPS Sends DICOM Query
          │
          ▼
PACS Server
          │
          ▼
Returns Study Information
          │
          ▼
Doctor Selects Study
          │
          ▼
TPS Downloads CT Images
          │
          ▼
Images Stored Locally
          │
          ▼
Viewer Displays CT
```

Meanwhile:

```text
GUI Thread
      │
      ├── User Browses Patients
      ├── Progress Bar Updates
      ├── Network Replies Processed
      └── Viewer Remains Responsive
```

The asynchronous design ensures that large image transfers do not freeze the interface.

---

# 16. Revision Notes

* Qt provides a comprehensive asynchronous networking framework.
* `QTcpSocket` implements TCP clients.
* `QTcpServer` implements TCP servers.
* `QUdpSocket` supports UDP communication.
* `QNetworkAccessManager` is the preferred API for HTTP/HTTPS.
* Qt networking integrates with the event loop.
* TCP is stream-based and reliable; UDP is message-based and lightweight.
* Always design protocols that correctly handle partial TCP reads.

---

Excellent.

This is the **most advanced Networking chapter** in Qt.

Professional applications rarely just open a TCP socket—they communicate with REST APIs, exchange JSON, upload and download files, maintain WebSocket connections, authenticate users, handle TLS certificates, retry failed requests, and recover from network interruptions.

Applications such as:

* Medical Treatment Planning Systems (TPS)
* PACS/DICOM clients
* Cloud desktop applications
* IDEs
* Banking software
* ERP systems
* AI clients

all rely on these concepts.

---

# Complete Qt Master Course (Qt 5.15 LTS → Qt 6.11)

# PART X — Networking

# Chapter 49 — Qt Networking (Complete Deep Dive)

## Part 2 — QNetworkReply, JSON, REST APIs, SSL/TLS, WebSockets & Enterprise Networking

> **Level:** Advanced → Expert

---

# Chapter Objectives

After completing this chapter, you will understand:

* `QNetworkReply`
* JSON support
* REST APIs
* Authentication
* File upload/download
* SSL/TLS basics
* `QWebSocket`
* Timeouts & retries
* Performance optimization
* Enterprise networking architecture

---

# Table of Contents

1. QNetworkReply
2. JSON Support
3. REST APIs
4. Authentication
5. File Upload & Download
6. SSL/TLS
7. WebSockets
8. Timeouts & Retries
9. Performance Optimization
10. Enterprise Architecture
11. Qt Internals
12. Qt 5 vs Qt 6
13. Best Practices
14. Interview Questions
15. Revision Notes

---

# 1. QNetworkReply

Every HTTP request returns a `QNetworkReply`.

```cpp
QNetworkReply *reply =
    manager.get(request);
```

Lifecycle:

```text
HTTP Request

↓

Server

↓

QNetworkReply

↓

finished()

↓

Read Data

↓

Delete Reply
```

Read data:

```cpp
QByteArray data =
    reply->readAll();
```

Always connect to:

```text
finished()

errorOccurred()
```

to determine success or failure.

---

# 2. JSON Support

Qt provides built-in JSON classes.

Core classes:

```text
QJsonDocument

QJsonObject

QJsonArray

QJsonValue
```

Hierarchy:

```text
JSON Text

↓

QJsonDocument

↓

Object / Array

↓

Values
```

Example JSON:

```json
{
  "patient":"John",
  "age":45,
  "plan":"Plan A"
}
```

Qt representation:

```text
Document

↓

Object

↓

patient

↓

John
```

---

## Arrays

```json
[
   "Beam1",
   "Beam2",
   "Beam3"
]
```

becomes:

```text
QJsonArray

↓

Beam1

Beam2

Beam3
```

---

# 3. REST APIs

REST uses HTTP methods.

```text
GET

POST

PUT

PATCH

DELETE
```

Medical TPS example:

```text
GET

↓

Download Patient
```

```text
POST

↓

Upload Treatment Plan
```

Workflow:

```text
GUI

↓

REST Request

↓

Cloud Server

↓

JSON

↓

GUI
```

---

# 4. Authentication

Common methods:

## Basic Authentication

```text
Username

Password
```

---

## Bearer Token

```text
Login

↓

Token

↓

Future Requests
```

Header:

```text
Authorization

Bearer token
```

---

## API Keys

```text
API Key

↓

Request

↓

Server
```

Always send credentials over HTTPS.

---

# 5. File Upload & Download

Download:

```text
Request

↓

Server

↓

File

↓

Disk
```

Progress:

```text
0%

25%

50%

75%

100%
```

Upload:

```text
Local File

↓

HTTP POST

↓

Server
```

Typical TPS examples:

* Upload treatment plan
* Download CT images
* Export reports
* Retrieve log files

---

# 6. SSL/TLS

HTTPS protects communication using TLS.

Workflow:

```text
Client

↓

TLS Handshake

↓

Encrypted Channel

↓

HTTP
```

Benefits:

* Encryption
* Integrity
* Authentication

Typical usage:

```text
TPS

↓

HTTPS

↓

License Server
```

or

```text
TPS

↓

Cloud

↓

Encrypted Data
```

Always verify certificates appropriately in production environments.

---

# 7. WebSockets

Unlike HTTP request/response,

WebSockets provide persistent communication.

Architecture:

```text
Client

⇅

Server
```

Both sides can send data at any time.

Qt provides:

```text
QWebSocket
```

Applications:

* Live dashboards
* Monitoring
* Chat
* Industrial automation
* Machine status

TPS example:

```text
Machine

↓

Status

↓

WebSocket

↓

TPS
```

The interface updates instantly without repeated polling.

---

# 8. Timeouts & Retries

Networks fail.

Applications must recover gracefully.

Workflow:

```text
Request

↓

Timeout

↓

Retry

↓

Success
```

Retry strategy:

```text
Attempt 1

↓

Attempt 2

↓

Attempt 3

↓

Show Error
```

Avoid retrying indefinitely.

Use exponential backoff where appropriate for repeated failures.

---

# 9. Performance Optimization

Good practices:

Reuse:

```text
QNetworkAccessManager
```

Connection reuse reduces overhead.

---

Avoid:

```text
Connect

↓

Disconnect

↓

Repeat
```

for every small request when keep-alive is available.

---

Batch requests when practical.

Cache reusable responses where appropriate.

Compress payloads if supported.

Process large downloads incrementally instead of keeping everything in memory.

---

# 10. Enterprise TPS Example

Architecture:

```text
GUI

↓

Networking Layer

↓

REST Client

↓

PACS Client

↓

License Client

↓

Cloud Client
```

Requests:

```text
Patient Query

↓

REST

↓

Cloud
```

Images:

```text
PACS

↓

DICOM

↓

TPS
```

License:

```text
License Server

↓

HTTPS

↓

Validation
```

Machine:

```text
Radiotherapy Machine

↓

WebSocket

↓

Live Status
```

---

# 11. Qt Internals

HTTP request:

```text
Application

↓

QNetworkAccessManager

↓

QNetworkReply

↓

TCP Socket

↓

Operating System

↓

Internet

↓

Server
```

JSON:

```text
Response

↓

QByteArray

↓

QJsonDocument

↓

Object

↓

Application
```

---

# 12. Qt 5.15 vs Qt 6.11

| Feature       | Qt 5.15 | Qt 6.11 |
| ------------- | ------- | ------- |
| QNetworkReply | ✔       | ✔       |
| JSON          | ✔       | ✔       |
| HTTPS         | ✔       | ✔       |
| QWebSocket    | ✔       | ✔       |
| REST Support  | ✔       | ✔       |

Qt 6 retains essentially the same networking model.

---

# 13. Best Practices

✅ Reuse `QNetworkAccessManager`.

✅ Always handle network errors.

✅ Delete or schedule deletion (`deleteLater()`) of finished `QNetworkReply` objects.

✅ Parse JSON carefully and validate required fields.

✅ Use HTTPS for authentication and sensitive data.

✅ Implement retries with sensible limits.

---

# 14. Common Mistakes

### ❌ Ignoring HTTP status codes

A successful TCP connection does not guarantee a successful HTTP request.

---

### ❌ Calling `readAll()` repeatedly expecting the same data

`readAll()` consumes the currently available buffered data.

---

### ❌ Trusting all SSL certificates

Never disable certificate verification in production.

---

### ❌ Assuming JSON always contains expected fields

Validate keys and handle malformed or incomplete responses gracefully.

---

# 15. Interview Questions

## Easy

1. What is `QNetworkReply`?
2. What is JSON?
3. What is a REST API?

---

## Medium

1. Explain Bearer token authentication.
2. Compare HTTP and WebSockets.
3. How do you parse JSON in Qt?

---

## Hard

1. Explain the lifecycle of an HTTP request in Qt.
2. Describe how TLS protects communication.
3. Design a retry strategy for unreliable networks.

---

## Expert

1. Design the networking architecture for a Treatment Planning System communicating with PACS, cloud storage, and a license server simultaneously.
2. Explain how to stream large downloads without exhausting memory.
3. Compare polling over HTTP with persistent WebSocket connections for real-time machine monitoring.

---

# 16. Architecture Diagram

```text
                 GUI
                  │
                  ▼
      QNetworkAccessManager
                  │
      ┌───────────┼───────────┐
      ▼           ▼           ▼
 REST API     WebSocket     File Transfer
      │           │           │
      ▼           ▼           ▼
 QNetworkReply   QWebSocket   HTTPS
      │
      ▼
 JSON Parser
      │
      ▼
 Application Data Model
```

---

# 🏥 Production Example — Treatment Planning System

```text
Doctor Logs In
        │
        ▼
HTTPS Authentication
        │
        ▼
Bearer Token Received
        │
        ▼
Patient Search
        │
        ▼
REST API
        │
        ▼
Patient List (JSON)
        │
        ▼
Doctor Selects Patient
        │
        ▼
PACS Query
        │
        ▼
Download DICOM Images
        │
        ▼
Viewer Displays CT
        │
        ▼
WebSocket Receives
Machine Status Updates
        │
        ▼
Status Bar Updated
```

This architecture allows different communication channels to coexist while keeping the user interface responsive.

---

# 17. Revision Notes

* `QNetworkReply` represents an asynchronous network response.
* Qt provides native JSON parsing and serialization classes.
* REST APIs are commonly implemented using HTTP methods.
* Authentication commonly uses Basic auth, Bearer tokens, or API keys.
* HTTPS uses TLS to encrypt communication.
* `QWebSocket` enables full-duplex, real-time communication.
* Handle network failures with retries, timeouts, and robust error handling.
* Reuse networking objects and process large transfers efficiently.

---

# 🎯 Chapter 49 Complete

You now have a comprehensive understanding of **Qt Networking**, including:

* `QTcpSocket`
* `QTcpServer`
* `QUdpSocket`
* `QNetworkAccessManager`
* `QNetworkReply`
* JSON (`QJsonDocument`, `QJsonObject`, `QJsonArray`)
* REST APIs
* Authentication
* File upload/download
* SSL/TLS
* WebSockets
* Timeouts and retries
* Performance optimization
* Enterprise networking architecture
* Qt 5 → Qt 6 compatibility

This knowledge equips you to build secure, asynchronous, network-enabled Qt applications that communicate with web services, devices, cloud platforms, and enterprise systems.

---

# 🚀 Next Chapter

## **Chapter 50 — File Handling & Serialization (Complete Deep Dive)**

This chapter covers persistent storage and data serialization in Qt, including:

* `QFile`
* `QFileInfo`
* `QDir`
* `QTemporaryFile`
* `QSaveFile`
* `QIODevice`
* `QTextStream`
* `QDataStream`
* `QBuffer`
* Binary vs text files
* JSON serialization
* XML support
* CSV handling
* Settings with `QSettings`
* File system monitoring (`QFileSystemWatcher`)
* Safe file saving
* Enterprise file architecture for Medical TPS, DICOM metadata, reports, configuration files, and scientific applications
