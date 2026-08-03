# Complete Qt Master Course (Qt 5.15 LTS → Qt 6.11)

# PART X — Networking

# Chapter 78 — WebSocket (Complete Deep Dive)

## Master QWebSocket, Full-Duplex Communication, Real-Time Messaging & Enterprise Qt Applications

> **Level:** Advanced → Architect


---

# 1. Introduction

A **WebSocket** is a communication protocol that provides a **persistent, full-duplex connection** between a client and a server.

Unlike HTTP:

* One connection stays open.
* Both client and server can send messages at any time.
* No repeated request-response cycle.

Typical applications:

* Chat
* Stock market updates
* Multiplayer games
* Live dashboards
* IoT monitoring
* Medical device monitoring
* Notifications

---

## Architecture

```text
Qt Client

↓

WebSocket

↓

Server
```

---

# 2. Why WebSocket?

Suppose you want to display machine status every second.

Using HTTP

```text
Client

↓

GET

↓

Server

↓

Response

↓

Repeat
```

Every update requires a new request.

---

Using WebSocket

```text
Connect Once

↓

Server Pushes Updates

↓

Client Receives Instantly
```

This greatly reduces overhead.

---

# 3. HTTP vs WebSocket

| Feature       | HTTP             | WebSocket   |
| ------------- | ---------------- | ----------- |
| Connection    | Short-lived      | Persistent  |
| Communication | Request-Response | Full-Duplex |
| Server Push   | Limited          | Native      |
| Latency       | Higher           | Very Low    |
| Real-Time     | Poor             | Excellent   |
| Chat          | Possible         | Excellent   |
| Notifications | Polling          | Native      |

---

## When Should You Use WebSocket?

| Application        | HTTP | WebSocket |
| ------------------ | ---- | --------- |
| REST API           | ✔    |           |
| File Download      | ✔    |           |
| Login              | ✔    |           |
| Chat               |      | ✔         |
| Live Dashboard     |      | ✔         |
| Medical Monitoring |      | ✔         |
| Stock Prices       |      | ✔         |

---

# 4. WebSocket Architecture

```text
+----------------------+
| Qt Application       |
+----------+-----------+
           │
           ▼
+----------------------+
| QWebSocket           |
+----------+-----------+
           │
           ▼
========================
    WebSocket Protocol
========================
           │
           ▼
+----------------------+
| WebSocket Server     |
+----------------------+
```

A WebSocket connection starts with an HTTP handshake and then upgrades to the WebSocket protocol.

---

# 5. WebSocket Handshake

Connection sequence

```text
Client

↓

HTTP Upgrade Request

↓

Server

↓

101 Switching Protocols

↓

WebSocket Connection
```

The server returns:

```text
HTTP/1.1 101 Switching Protocols
```

After this point,

HTTP communication ends,

WebSocket communication begins.

---

# 6. QWebSocket

Header

```cpp
#include <QWebSocket>
```

Create socket

```cpp
QWebSocket socket;
```

Open connection

```cpp
socket.open(
QUrl("ws://localhost:8080"));
```

Secure WebSocket

```text
ws://

↓

Plain

wss://

↓

Encrypted (TLS)
```

---

## Important Signals

| Signal                  | Purpose        |
| ----------------------- | -------------- |
| connected()             | Connected      |
| disconnected()          | Closed         |
| textMessageReceived()   | Text message   |
| binaryMessageReceived() | Binary message |
| errorOccurred()         | Error          |

---

# 7. QWebSocketServer

Header

```cpp
#include <QWebSocketServer>
```

Create

```cpp
QWebSocketServer server(
"MyServer",
QWebSocketServer::NonSecureMode);
```

Listen

```cpp
server.listen(
QHostAddress::Any,
8080);
```

Architecture

```text
Server

↓

Accept Client

↓

Create QWebSocket

↓

Communicate
```

---

# 8. Sending & Receiving Messages

Send text

```cpp
socket.sendTextMessage(
"Hello");
```

Receive

```cpp
connect(
&socket,
&QWebSocket::textMessageReceived,
...);
```

---

Send binary

```cpp
socket.sendBinaryMessage(
data);
```

Receive

```cpp
binaryMessageReceived()
```

Workflow

```text
Client

↓

Message

↓

Server

↓

Reply

↓

Client
```

Unlike TCP, WebSocket preserves message boundaries.

---

# 9. Binary vs Text Messages

Text

```text
{
"name":"John"
}
```

Advantages

* Human-readable
* JSON support
* Easy debugging

---

Binary

```text
010110100101...
```

Advantages

* Smaller
* Faster
* Better for images
* Better for telemetry

---

Comparison

| Feature    | Text     | Binary    |
| ---------- | -------- | --------- |
| Readable   | ✔        | ✘         |
| Speed      | Good     | Excellent |
| Debugging  | Easy     | Hard      |
| Large Data | Moderate | Excellent |

---

# 10. Ping/Pong & Heartbeats

Sometimes a connection silently dies.

Heartbeat

```text
Client

↓

Ping

↓

Server

↓

Pong
```

Qt

```cpp
socket.ping();
```

Signals

```cpp
pong()
```

Advantages

* Detect broken connections
* Keep firewalls/NAT mappings alive
* Measure round-trip latency

---

# 11. Reconnection Strategies

If connection fails

```text
Disconnected

↓

Wait

↓

Reconnect

↓

Connected
```

Typical strategy

```text
1 second

↓

2 seconds

↓

4 seconds

↓

8 seconds
```

This is called **exponential backoff**.

Avoid reconnecting continuously in a tight loop.

---

# 12. Authentication

Authentication usually occurs during or immediately after establishing the connection.

Common methods

* JWT
* Bearer Token
* Session Cookie
* API Key

Example

```text
Client

↓

JWT

↓

Server

↓

Connected
```

For `wss://` connections, TLS protects the authentication data in transit.

---

# 13. Enterprise Applications

## Chat

```text
Client

↓

WebSocket

↓

Server

↓

Other Clients
```

---

## Stock Market

```text
Exchange

↓

Server

↓

Thousands of Clients
```

---

## Medical TPS

```text
Treatment Machine

↓

WebSocket

↓

TPS

↓

Live Status
```

---

## Industrial Automation

```text
PLC

↓

WebSocket

↓

Dashboard
```

---

# 14. Qt Internals

```text
Application

↓

QWebSocket

↓

QTcpSocket

↓

TCP

↓

Network
```

Connection establishment

```text
HTTP

↓

Upgrade

↓

WebSocket Frames

↓

Messages
```

Internally, WebSocket uses TCP for reliable transport but adds message framing and control frames (such as Ping and Pong).

---

# 15. Qt 5 vs Qt 6

| Feature          | Qt 5.15 | Qt 6.11 |
| ---------------- | ------- | ------- |
| QWebSocket       | ✔       | ✔       |
| QWebSocketServer | ✔       | ✔       |
| Binary Messages  | ✔       | ✔       |
| Ping/Pong        | ✔       | ✔       |
| TLS (wss://)     | ✔       | ✔       |

The WebSocket API is very similar across Qt 5 and Qt 6.

---

# 16. Best Practices

✅ Use `wss://` for production systems.

✅ Implement heartbeat monitoring.

✅ Reconnect using exponential backoff.

✅ Validate every received message.

✅ Separate networking code from UI code.

---

# 17. Common Mistakes

### ❌ Reconnecting in a busy loop

Use delayed retries with backoff.

---

### ❌ Ignoring Ping/Pong

Silent disconnections can go unnoticed.

---

### ❌ Sending very large messages

Split large payloads when appropriate.

---

### ❌ Trusting client messages

Always validate message structure and authorization.

---

### ❌ Mixing business logic with networking code

Create dedicated communication or protocol classes.

---

# 18. Interview Questions

## Easy

1. What is WebSocket?
2. How is WebSocket different from HTTP?
3. What is `QWebSocket`?

---

## Medium

1. Explain the WebSocket handshake.
2. What is full-duplex communication?
3. Why are Ping and Pong frames important?

---

## Hard

1. Explain the WebSocket protocol architecture.
2. Design a scalable chat server using Qt WebSockets.
3. Compare WebSocket with raw TCP.

---

## Expert

1. Design a real-time monitoring system for a Medical Treatment Planning System where treatment delivery status, machine health, and beam progress are streamed to the desktop application.
2. Explain how to implement automatic reconnection while avoiding server overload.
3. Compare WebSockets, Server-Sent Events (SSE), HTTP polling, HTTP long polling, and raw TCP for desktop applications.

---

# 19. Revision Notes

* WebSocket provides persistent, full-duplex communication.
* It begins with an HTTP Upgrade handshake.
* `QWebSocket` implements the client.
* `QWebSocketServer` implements the server.
* WebSocket supports both text and binary messages.
* Ping/Pong frames detect connection health.
* Exponential backoff is recommended for reconnection.
* Use `wss://` for secure communication.
* Qt networking remains asynchronous.

---

# 💡 Senior Engineer Tips

## HTTP vs TCP vs WebSocket

| Requirement           | HTTP  | TCP   | WebSocket |
| --------------------- | ----- | ----- | --------- |
| REST API              | ⭐⭐⭐⭐⭐ | ⭐     | ⭐         |
| Chat                  | ⭐⭐    | ⭐⭐⭐⭐  | ⭐⭐⭐⭐⭐     |
| Live Notifications    | ⭐⭐    | ⭐⭐⭐   | ⭐⭐⭐⭐⭐     |
| Device Protocol       | ⭐     | ⭐⭐⭐⭐⭐ | ⭐⭐⭐       |
| Browser Communication | ⭐⭐⭐⭐⭐ | ✘     | ⭐⭐⭐⭐⭐     |

---

## Enterprise Qt Architecture

```text
Qt UI
   │
   ▼
Notification Service
   │
   ▼
WebSocket Client
   │
   ▼
Protocol Parser
   │
   ▼
Business Logic
   │
   ▼
UI Update
```

Keep parsing and protocol handling separate from presentation logic.

---

## Medical TPS Example

```text
Treatment Planning System
          │
          ▼
WebSocket Client
          │
     ┌────┼────────────┐
     ▼    ▼            ▼
Machine Status   Beam Progress   Alerts
     │    │            │
     └────┼────────────┘
          ▼
     Live Dashboard
```

A practical architecture is:

* **REST API** for login, configuration, and treatment plan upload.
* **WebSocket** for continuous machine status, treatment progress, and alarms.
* **TCP** for proprietary device protocols where required by the hardware.

---

# 🎯 Chapter 78 Complete

You now understand:

* WebSocket fundamentals
* HTTP Upgrade handshake
* `QWebSocket`
* `QWebSocketServer`
* Full-duplex communication
* Text and binary messaging
* Ping/Pong and heartbeats
* Automatic reconnection
* Enterprise real-time architectures
* Qt 5.15 vs Qt 6.11 compatibility

This chapter completes real-time communication using Qt WebSockets.

---

# 🚀 Next Chapter

## **Chapter 79 — SSL/TLS (Complete Deep Dive)**
