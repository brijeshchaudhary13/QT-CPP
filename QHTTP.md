# Complete Qt Master Course (Qt 5.15 LTS → Qt 6.11)

# PART X — Networking

# Chapter 76 — HTTP (Complete Deep Dive)

## Master HTTP, QNetworkAccessManager, QNetworkRequest, QNetworkReply & Enterprise REST Client Development

> **Level:** Advanced → Expert

---

# Chapter Objectives

After completing this chapter, you will understand:

* What is HTTP?
* HTTP Architecture
* HTTP Request & Response Lifecycle
* HTTP Methods (GET, POST, PUT, PATCH, DELETE, HEAD)
* Status Codes
* Headers
* MIME Types
* `QNetworkAccessManager`
* `QNetworkRequest`
* `QNetworkReply`
* File Upload & Download
* Authentication
* Cookies
* Redirects
* Asynchronous Networking
* Enterprise Networking Architecture
* Qt Internals
* Qt 5.15 vs Qt 6.11
* Best Practices
* Interview Questions

---

# Table of Contents

1. Introduction
2. HTTP Architecture
3. HTTP Request–Response Lifecycle
4. HTTP Methods
5. HTTP Status Codes
6. HTTP Headers
7. MIME Types
8. QNetworkAccessManager
9. QNetworkRequest
10. QNetworkReply
11. GET Requests
12. POST Requests
13. PUT, PATCH & DELETE
14. File Upload & Download
15. Authentication
16. Cookies & Sessions
17. Redirects
18. Error Handling
19. Enterprise Applications
20. Qt Internals
21. Qt 5 vs Qt 6
22. Best Practices
23. Common Mistakes
24. Interview Questions
25. Revision Notes

---

# 1. Introduction

HTTP (**HyperText Transfer Protocol**) is the foundation of communication between clients and web servers.

Examples:

* Web browsers
* REST APIs
* Cloud services
* Software licensing
* Update servers
* Authentication services
* Medical cloud systems

Qt provides a complete HTTP client through the **Qt Network** module.

---

## Architecture

```text
Qt Application

↓

QNetworkAccessManager

↓

HTTP

↓

Web Server

↓

Database
```

Unlike `QTcpSocket`, HTTP is a higher-level protocol built on top of TCP.

---

# 2. HTTP Architecture

```text
+------------------------+
| Qt Application         |
+-----------+------------+
            │
            ▼
+------------------------+
| QNetworkAccessManager  |
+-----------+------------+
            │
            ▼
HTTP Request

↓

Internet

↓

HTTP Server

↓

HTTP Response

↓

Application
```

---

## Client-Server Model

```text
Qt Client

↓

HTTP Request

↓

Server

↓

HTTP Response

↓

Qt Client
```

The client always initiates the communication.

---

# 3. HTTP Request–Response Lifecycle

```text
Client

↓

Create Request

↓

Send Request

↓

Server Processing

↓

Response

↓

Client Processes Reply
```

Qt workflow

```text
QNetworkRequest

↓

QNetworkAccessManager

↓

QNetworkReply
```

---

# 4. HTTP Methods

## GET

Retrieve data.

```http
GET /patients
```

No data modification.

---

## POST

Create new resources.

```http
POST /patients
```

Example

```json
{
    "name":"John"
}
```

---

## PUT

Replace an existing resource.

```http
PUT /patients/10
```

---

## PATCH

Partially update a resource.

```http
PATCH /patients/10
```

---

## DELETE

Remove a resource.

```http
DELETE /patients/10
```

---

## HEAD

Retrieve headers only.

Useful for:

* File size
* Last modified date
* Resource existence

---

# HTTP Methods Summary

| Method | Purpose        |
| ------ | -------------- |
| GET    | Read           |
| POST   | Create         |
| PUT    | Replace        |
| PATCH  | Partial Update |
| DELETE | Remove         |
| HEAD   | Headers Only   |

---

# 5. HTTP Status Codes

## 2xx Success

| Code | Meaning    |
| ---- | ---------- |
| 200  | OK         |
| 201  | Created    |
| 204  | No Content |

---

## 3xx Redirection

| Code | Meaning            |
| ---- | ------------------ |
| 301  | Moved Permanently  |
| 302  | Found              |
| 307  | Temporary Redirect |
| 308  | Permanent Redirect |

---

## 4xx Client Errors

| Code | Meaning           |
| ---- | ----------------- |
| 400  | Bad Request       |
| 401  | Unauthorized      |
| 403  | Forbidden         |
| 404  | Not Found         |
| 429  | Too Many Requests |

---

## 5xx Server Errors

| Code | Meaning               |
| ---- | --------------------- |
| 500  | Internal Server Error |
| 502  | Bad Gateway           |
| 503  | Service Unavailable   |

---

# 6. HTTP Headers

Headers provide metadata about requests and responses.

Example

```http
Content-Type: application/json

Authorization: Bearer token

Accept: application/json
```

Common request headers

| Header        | Purpose                |
| ------------- | ---------------------- |
| Authorization | Authentication         |
| Accept        | Expected response type |
| Content-Type  | Request body format    |
| User-Agent    | Client information     |
| Host          | Target host            |

---

# 7. MIME Types

MIME (Multipurpose Internet Mail Extensions) identifies content types.

| MIME Type           | Content     |
| ------------------- | ----------- |
| application/json    | JSON        |
| application/xml     | XML         |
| text/plain          | Text        |
| text/html           | HTML        |
| image/png           | PNG         |
| application/pdf     | PDF         |
| multipart/form-data | File upload |

---

# 8. QNetworkAccessManager

Header

```cpp
#include <QNetworkAccessManager>
```

Create manager

```cpp
QNetworkAccessManager manager;
```

This is the main entry point for all HTTP operations.

Architecture

```text
Application

↓

QNetworkAccessManager

↓

HTTP
```

---

## Lifetime

In most applications, create **one shared `QNetworkAccessManager`** and reuse it.

Avoid creating one per request.

---

# 9. QNetworkRequest

Header

```cpp
#include <QNetworkRequest>
```

Create request

```cpp
QNetworkRequest request(
    QUrl(
        "https://server/api"));
```

Set header

```cpp
request.setHeader(
    QNetworkRequest::ContentTypeHeader,
    "application/json");
```

Set custom header

```cpp
request.setRawHeader(
    "Authorization",
    "Bearer token");
```

---

# 10. QNetworkReply

Every request returns a reply object.

```cpp
QNetworkReply *reply =
    manager.get(request);
```

Signals

```cpp
finished()

readyRead()

downloadProgress()

uploadProgress()

errorOccurred()
```

Workflow

```text
Request

↓

Reply

↓

Read Data

↓

Delete Reply
```

---

# 11. GET Requests

Example

```cpp
QNetworkReply *reply =
    manager.get(request);
```

Read result

```cpp
connect(
reply,
&QNetworkReply::finished,
...
);
```

Response

```text
Server

↓

JSON

↓

Application
```

Most REST APIs use GET for retrieving data.

---

# 12. POST Requests

Example

```cpp
QByteArray body =
R"(
{
"name":"John"
}
)";
```

Send

```cpp
manager.post(
request,
body);
```

Workflow

```text
JSON

↓

POST

↓

Server

↓

Created
```

---

# 13. PUT, PATCH & DELETE

PUT

```cpp
manager.put(
request,
body);
```

DELETE

```cpp
manager.deleteResource(
request);
```

PATCH

Qt does **not** provide a dedicated `patch()` convenience function.

Use

```cpp
QNetworkAccessManager::sendCustomRequest()
```

with the `"PATCH"` method.

---

# 14. File Upload & Download

Download

```cpp
manager.get(request);
```

Progress

```cpp
downloadProgress(
received,
total);
```

---

Upload

Use

```text
QHttpMultiPart
```

for multipart form uploads.

Workflow

```text
File

↓

HTTP

↓

Server
```

---

# 15. Authentication

Common authentication methods

| Type         | Example             |
| ------------ | ------------------- |
| Basic        | Username + Password |
| Bearer Token | JWT                 |
| API Key      | X-API-Key           |
| OAuth2       | Access Token        |

Bearer example

```http
Authorization:

Bearer eyJhbG...
```

---

# 16. Cookies & Sessions

Qt supports cookies using

```text
QNetworkCookie
```

and

```text
QNetworkCookieJar
```

Workflow

```text
Login

↓

Cookie

↓

Next Request

↓

Authenticated
```

---

# 17. Redirects

Sometimes

```text
Old URL

↓

301

↓

New URL
```

Qt can automatically follow redirects depending on the redirect policy configured for the request.

---

# 18. Error Handling

Always check

```cpp
reply->error()
```

Common errors

| Error              | Meaning            |
| ------------------ | ------------------ |
| Timeout            | Server slow        |
| HostNotFound       | DNS failed         |
| ConnectionRefused  | Server unavailable |
| SSLHandshakeFailed | SSL error          |
| OperationCanceled  | Request cancelled  |

---

Read error

```cpp
reply->errorString();
```

---

# 19. Enterprise Applications

## Cloud Login

```text
Application

↓

POST Login

↓

JWT Token

↓

API Calls
```

---

## Medical TPS

```text
TPS

↓

HTTP

↓

License Server

↓

Token
```

---

## Software Update

```text
Application

↓

GET

↓

Version Info

↓

Download
```

---

## ERP

```text
Desktop Client

↓

REST API

↓

Cloud Database
```

---

# 20. Qt Internals

```text
Application

↓

QNetworkAccessManager

↓

QNetworkReply

↓

QTcpSocket

↓

TCP

↓

Internet
```

Internally, HTTP communication eventually uses TCP sockets.

Qt manages the low-level socket operations automatically.

---

# 21. Qt 5 vs Qt 6

| Feature               | Qt 5.15 | Qt 6.11      |
| --------------------- | ------- | ------------ |
| QNetworkAccessManager | ✔       | ✔            |
| HTTP GET              | ✔       | ✔            |
| HTTP POST             | ✔       | ✔            |
| HTTP PUT              | ✔       | ✔            |
| HTTP DELETE           | ✔       | ✔            |
| HTTP/2 Support        | ✔       | ✔ (Improved) |

Qt 6 includes various improvements and bug fixes for modern HTTP usage, while keeping the API largely compatible.

---

# 22. Best Practices

✅ Reuse a single `QNetworkAccessManager`.

✅ Always connect to `finished()` and `errorOccurred()`.

✅ Delete `QNetworkReply` objects after use (typically with `deleteLater()`).

✅ Validate server responses.

✅ Use HTTPS instead of HTTP for sensitive data.

---

# 23. Common Mistakes

### ❌ Creating a new `QNetworkAccessManager` for every request

Reuse one manager whenever possible.

---

### ❌ Forgetting to delete replies

Call

```cpp
reply->deleteLater();
```

after processing.

---

### ❌ Blocking the UI thread

Use Qt's asynchronous networking.

---

### ❌ Ignoring HTTP status codes

A successful network transfer does not always mean the server accepted the request.

---

### ❌ Sending sensitive information over HTTP

Prefer HTTPS.

---

# 24. Interview Questions

## Easy

1. What is HTTP?
2. What is `QNetworkAccessManager`?
3. Difference between GET and POST?

---

## Medium

1. Explain the HTTP request-response lifecycle.
2. What is `QNetworkReply`?
3. How does file downloading work?

---

## Hard

1. Explain HTTP status codes.
2. Design an HTTP client for a desktop application.
3. Compare HTTP and raw TCP.

---

## Expert

1. Design a cloud synchronization service for a Medical TPS that uploads treatment plans, downloads machine configurations, and authenticates users securely.
2. Explain how you would implement resumable file downloads in Qt.
3. Compare HTTP/1.1, HTTP/2, HTTP/3, and WebSockets for desktop applications.

---

# 25. Revision Notes

* HTTP is a request-response protocol built on TCP.
* `QNetworkAccessManager` is the central HTTP class.
* `QNetworkRequest` represents an outgoing request.
* `QNetworkReply` represents the server response.
* GET retrieves resources.
* POST creates resources.
* PUT replaces resources.
* PATCH partially updates resources.
* DELETE removes resources.
* Always handle HTTP status codes and network errors.
* Reuse `QNetworkAccessManager`.

---

# 💡 Senior Engineer Tips

## Which Protocol Should You Use?

| Requirement                            | Recommended |
| -------------------------------------- | ----------- |
| REST API                               | HTTP        |
| Cloud synchronization                  | HTTP        |
| Software updates                       | HTTP        |
| Continuous bidirectional communication | WebSocket   |
| Device communication                   | TCP         |
| Device discovery                       | UDP         |

---

## Enterprise HTTP Architecture

```text
Qt UI
   │
   ▼
API Service
   │
   ▼
QNetworkAccessManager
   │
   ▼
HTTP/HTTPS
   │
   ▼
REST Server
   │
   ▼
Database
```

Keep all HTTP logic inside a dedicated **API Service** instead of scattering requests throughout UI classes.

---

## Medical TPS Example

```text
Treatment Planning System
          │
          ▼
Cloud Sync Service
          │
     ┌────┴─────┐
     ▼          ▼
Upload Plan   Download Machine Config
     │          │
     └────┬─────┘
          ▼
   QNetworkAccessManager
          │
          ▼
      HTTPS Server
          │
          ▼
Cloud Database
```

A production TPS might use HTTP/HTTPS for:

* User authentication
* License validation
* Software updates
* Machine configuration downloads
* Cloud backup of treatment plans

---


## **Chapter 77 — REST API (Complete Deep Dive)**

