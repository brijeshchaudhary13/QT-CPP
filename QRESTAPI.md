# Complete Qt Master Course (Qt 5.15 LTS → Qt 6.11)

# PART X — Networking

# Chapter 77 — REST API (Complete Deep Dive)

## Master REST Architecture, JSON APIs, Authentication, Versioning & Enterprise Qt Client Development

> **Level:** Advanced → Architect

---



# 1. Introduction

REST (**Representational State Transfer**) is an architectural style for designing web APIs.

Today, nearly every modern application communicates using REST APIs.

Examples:

* GitHub API
* Google Maps API
* Cloud Storage
* Banking APIs
* Hospital Systems
* Medical TPS Cloud Services
* AI Services

Qt applications typically consume REST APIs using:

* `QNetworkAccessManager`
* `QNetworkRequest`
* `QNetworkReply`
* `QJsonDocument`

---

## REST Architecture

```text
Qt Application

↓

REST Client

↓

HTTPS

↓

REST Server

↓

Database
```

---

# 2. REST Architecture

REST is based on **resources**.

Everything exposed by the server is treated as a resource.

Examples

```text
Patient

Treatment Plan

Machine

Beam

User

License
```

Each resource has its own URI.

Example

```text
GET

/api/patients

/api/plans

/api/license
```

---

## REST Workflow

```text
Qt Client

↓

HTTP Request

↓

REST Server

↓

Business Logic

↓

Database

↓

JSON Response

↓

Qt Client
```

---

# 3. REST Principles

A good REST API follows several principles.

---

## 1. Client-Server

The client and server are independent.

```text
Qt Client

↓

REST Server
```

The client never accesses the database directly.

---

## 2. Stateless

Every request contains everything required.

Example

```http
GET /patients

Authorization: Bearer TOKEN
```

The server does not rely on previous requests to understand the current one.

---

## 3. Cacheable

Responses may be cached.

```text
Server

↓

Cache

↓

Client
```

This improves performance.

---

## 4. Uniform Interface

Every resource behaves consistently.

Example

```text
GET

POST

PUT

DELETE
```

---

## 5. Layered System

```text
Qt App

↓

API Gateway

↓

REST Service

↓

Database
```

The client does not need to know how many internal layers exist.

---

# 4. Resources & URIs

Bad

```text
/getPatient

/deletePatient

/updatePatient
```

Good

```text
GET /patients

POST /patients

PUT /patients/5

DELETE /patients/5
```

Resources use **nouns**, while HTTP methods describe the action.

---

## Nested Resources

```text
/patients/5/plans

/plans/20/beams
```

---

# 5. REST Request & Response

Request

```http
GET /patients/10
```

Response

```json
{
    "id":10,
    "name":"John",
    "age":45
}
```

Workflow

```text
Request

↓

Server

↓

JSON

↓

Qt
```

---

# 6. HTTP Methods in REST

| Method | Operation      |
| ------ | -------------- |
| GET    | Read           |
| POST   | Create         |
| PUT    | Replace        |
| PATCH  | Partial Update |
| DELETE | Delete         |

---

Example

Create patient

```http
POST

/api/patients
```

Read

```http
GET

/api/patients/5
```

Delete

```http
DELETE

/api/patients/5
```

---

# 7. JSON in REST

REST almost always exchanges JSON.

Example

```json
{
    "patientId":10,
    "name":"John",
    "plans":
    [
        {
            "id":1
        }
    ]
}
```

Qt classes

```text
QJsonDocument

↓

QJsonObject

↓

QJsonArray
```

Workflow

```text
HTTP

↓

QByteArray

↓

QJsonDocument

↓

Objects
```

---

# 8. Authentication

Most APIs require authentication.

---

## API Key

```http
X-API-Key:

abc123
```

---

## Bearer Token

```http
Authorization:

Bearer eyJh...
```

---

## OAuth2

```text
Login

↓

Authorization Server

↓

Access Token

↓

REST API
```

---

## JWT

JSON Web Token

```text
Header

Payload

Signature
```

JWT is commonly used for user authentication in REST services.

---

# 9. Pagination

Large APIs avoid returning thousands of records.

Bad

```text
GET

/patients
```

Returns

```text
500000 rows
```

Better

```text
GET

/patients?page=2&size=50
```

---

Response

```json
{
"page":2,

"size":50,

"total":1500,

"items":[...]
}
```

---

# 10. Filtering & Sorting

Filtering

```text
GET

/patients?age=45
```

Sorting

```text
GET

/patients?sort=name
```

Descending

```text
GET

/patients?sort=-age
```

Combined

```text
GET

/patients?age=45&sort=name
```

---

# 11. API Versioning

APIs evolve over time.

Version 1

```text
/api/v1/patients
```

Version 2

```text
/api/v2/patients
```

Advantages

* Backward compatibility
* Independent evolution
* Safer upgrades

---

# 12. Error Handling

Typical response

```http
404

Not Found
```

JSON

```json
{
    "error":"Patient not found"
}
```

---

Validation error

```http
400

Bad Request
```

```json
{
"message":

"Age must be positive"
}
```

Always parse both the HTTP status code and the response body.

---

# 13. REST Client Architecture

Recommended design

```text
Qt UI

↓

Service Layer

↓

REST Client

↓

QNetworkAccessManager

↓

REST API
```

Responsibilities

| Layer       | Responsibility |
| ----------- | -------------- |
| UI          | Display        |
| Service     | Business logic |
| REST Client | HTTP           |
| Server      | API            |

---

## Repository Example

```text
PatientService

↓

PatientApi

↓

HTTP

↓

Server
```

Keep UI code free of networking details.

---

# 14. Enterprise Applications

## Cloud Login

```text
Desktop

↓

REST

↓

Identity Server
```

---

## Medical TPS

```text
TPS

↓

REST

↓

Cloud

↓

Patient Database
```

---

## Software Updates

```text
Application

↓

REST

↓

Update Server
```

---

## ERP

```text
Desktop

↓

REST

↓

Cloud Backend
```

---

# 15. Qt Internals

```text
QNetworkAccessManager

↓

QNetworkReply

↓

QByteArray

↓

QJsonDocument

↓

Objects
```

Qt handles the networking asynchronously and leaves JSON parsing to the application.

---

# 16. Qt 5 vs Qt 6

| Feature          | Qt 5.15 | Qt 6.11      |
| ---------------- | ------- | ------------ |
| REST Client      | ✔       | ✔            |
| JSON             | ✔       | ✔            |
| HTTPS            | ✔       | ✔            |
| HTTP/2           | ✔       | ✔ (Improved) |
| Async Networking | ✔       | ✔            |

There is no dedicated "REST module" in Qt. REST clients are built using the networking and JSON APIs together.

---

# 17. Best Practices

✅ Design URIs using nouns.

✅ Use the correct HTTP method.

✅ Always use HTTPS for production.

✅ Return meaningful HTTP status codes.

✅ Keep APIs stateless.

✅ Reuse one `QNetworkAccessManager`.

✅ Validate all server responses.

---

# 18. Common Mistakes

### ❌ Using verbs in URIs

Bad

```text
/getPatient
```

Good

```text
/patients/5
```

---

### ❌ Ignoring HTTP status codes

Always check both:

* HTTP status
* JSON error message

---

### ❌ Returning huge datasets

Use pagination.

---

### ❌ Putting authentication tokens in URLs

Use HTTP headers instead.

---

### ❌ Mixing UI and REST code

Create dedicated API classes.

---

# 19. Interview Questions

## Easy

1. What is REST?
2. What is a resource?
3. Why does REST commonly use JSON?

---

## Medium

1. Explain REST principles.
2. Why should REST APIs be stateless?
3. What is pagination?

---

## Hard

1. Design a REST API for a Hospital Management System.
2. Explain JWT authentication.
3. Compare REST and SOAP.

---

## Expert

1. Design a REST API for a Medical Treatment Planning System supporting patients, treatment plans, machine configurations, dose calculations, and audit logs.
2. Explain how you would implement offline synchronization between a Qt desktop application and a cloud REST service.
3. Compare REST, GraphQL, gRPC, WebSockets, and raw TCP for engineering desktop applications.

---

# 20. Revision Notes

* REST is an architectural style, not a protocol.
* Resources are identified by URIs.
* HTTP methods map naturally to CRUD operations.
* JSON is the most common REST data format.
* Authentication is commonly implemented with Bearer tokens or OAuth2.
* Pagination prevents excessively large responses.
* Filtering and sorting should be query parameters.
* Version APIs to maintain backward compatibility.
* Keep REST code separate from UI logic.
* Build REST clients with `QNetworkAccessManager`, `QNetworkRequest`, and `QNetworkReply`.

---

# 💡 Senior Engineer Tips

## REST API Design Checklist

| Question                          | Recommendation |
| --------------------------------- | -------------- |
| Is the URI a noun?                | ✔              |
| Are HTTP methods used correctly?  | ✔              |
| Is HTTPS used?                    | ✔              |
| Are errors returned consistently? | ✔              |
| Is pagination supported?          | ✔              |
| Is versioning planned?            | ✔              |

---

## Enterprise Qt REST Architecture

```text
Qt UI
   │
   ▼
Service Layer
   │
   ▼
REST API Client
   │
   ▼
QNetworkAccessManager
   │
   ▼
HTTPS
   │
   ▼
REST Server
   │
   ▼
Database
```

---

## Medical TPS Cloud Architecture

```text
Treatment Planning System
          │
          ▼
REST Client
          │
   ┌──────┼──────────────┐
   ▼      ▼              ▼
Login   Patient API   Plan API
   │      │              │
   └──────┼──────────────┘
          ▼
     HTTPS Server
          │
          ▼
Cloud Database
```

Possible cloud operations include:

* User authentication
* Downloading machine configurations
* Uploading treatment plans
* Retrieving patient metadata
* Synchronizing audit logs

---

## **Chapter 78 — WebSocket (Complete Deep Dive)**

