# Complete Qt Master Course (Qt 5.15 LTS → Qt 6.11)

# PART X — Networking

# Chapter 79 — SSL/TLS (Complete Deep Dive)

## Master SSL/TLS, HTTPS, QSslSocket, Certificates, Mutual TLS (mTLS) & Secure Qt Networking

> **Level:** Advanced → Architect



---

# 1. Introduction

When data travels over a network, anyone with access to the communication path could potentially observe or modify it if it is sent unencrypted.

**TLS (Transport Layer Security)** protects data by providing:

* Encryption
* Authentication
* Integrity

Applications using TLS include:

* HTTPS
* Secure WebSockets (`wss://`)
* FTPS
* SMTPS
* Medical systems
* Banking
* Cloud APIs

Qt supports TLS through the **Qt Network** module.

---

## Architecture

```text id="tls01"
Qt Application

↓

QSslSocket

↓

TLS

↓

TCP

↓

Internet
```

---

# 2. SSL vs TLS

Originally

```text id="tls02"
SSL

↓

SSL 2

↓

SSL 3

↓

TLS 1.0

↓

TLS 1.1

↓

TLS 1.2

↓

TLS 1.3
```

Today:

* SSL is obsolete.
* Modern applications use **TLS**.
* People still commonly say "SSL certificate," even though the protocol in use is TLS.

---

## Recommendation

Always use:

* TLS 1.2 or newer
* Prefer TLS 1.3 when supported

---

# 3. Why HTTPS?

Normal HTTP

```text id="tls03"
Client

↓

Plain Text

↓

Internet

↓

Server
```

Anyone intercepting traffic could read the data.

---

HTTPS

```text id="tls04"
Client

↓

Encrypted

↓

Internet

↓

Server
```

Data is encrypted before transmission.

---

Benefits

* Privacy
* Authentication
* Integrity

---

# 4. Cryptography Basics

TLS combines multiple cryptographic techniques.

---

## Symmetric Encryption

One shared key.

```text id="tls05"
Client

↓

Shared Secret Key

↓

Server
```

Advantages

* Very fast
* Efficient

Used after the TLS handshake.

---

## Asymmetric Encryption

Uses two keys.

```text id="tls06"
Public Key

↓

Encrypt

↓

Private Key

↓

Decrypt
```

Advantages

* Secure key exchange
* Identity verification

Disadvantages

* Slower than symmetric encryption

---

# 5. Public & Private Keys

Each server owns a key pair.

```text id="tls07"
Public Key

↓

Anyone Can Use

------------------

Private Key

↓

Secret
```

Workflow

```text id="tls08"
Client

↓

Server Public Key

↓

Encrypted Secret

↓

Server Private Key
```

Only the private key holder can recover the secret.

---

# 6. Digital Certificates

A certificate binds a public key to an identity.

Contains

* Public Key
* Domain Name
* Organization
* Validity Period
* Issuer
* Digital Signature

---

Example

```text id="tls09"
www.example.com

↓

Certificate

↓

Public Key
```

Certificates allow clients to verify they are communicating with the expected server.

---

# 7. Certificate Authorities (CA)

Certificates are issued by trusted Certificate Authorities.

```text id="tls10"
Certificate Authority

↓

Signs Certificate

↓

Server

↓

Client Trusts
```

Examples include public commercial CAs or private enterprise CAs.

The operating system or Qt's TLS backend uses a trusted CA store during certificate verification.

---

# 8. TLS Handshake

Before encrypted communication begins:

```text id="tls11"
Client

↓

ClientHello

↓

ServerHello

↓

Certificate

↓

Key Exchange

↓

Secure Channel
```

After the handshake:

```text id="tls12"
Encrypted Communication
```

In TLS 1.3 the handshake is simpler and generally faster than earlier versions.

---

# 9. QSslSocket

Header

```cpp id="tls13"
#include <QSslSocket>
```

Create

```cpp id="tls14"
QSslSocket socket;
```

Connect securely

```cpp id="tls15"
socket.connectToHostEncrypted(
    "example.com",
    443);
```

Architecture

```text id="tls16"
Application

↓

QSslSocket

↓

TLS

↓

TCP
```

---

## Important Signals

| Signal          | Purpose                       |
| --------------- | ----------------------------- |
| encrypted()     | Secure connection established |
| sslErrors()     | Certificate/TLS issues        |
| errorOccurred() | Socket error                  |

---

# 10. QSslConfiguration

`QSslConfiguration` allows customization of TLS settings.

Typical uses

* TLS protocol versions
* Cipher suites
* Certificates
* Private keys

Example

```cpp id="tls17"
QSslConfiguration config =
    QSslConfiguration::defaultConfiguration();
```

Apply

```cpp id="tls18"
socket.setSslConfiguration(config);
```

---

# 11. Certificate Validation

During the handshake the client verifies:

```text id="tls19"
Certificate

↓

Trusted CA?

↓

Valid Date?

↓

Hostname Match?

↓

Accept
```

If validation fails:

```text id="tls20"
Reject Connection
```

Qt provides

```cpp id="tls21"
sslErrors()
```

to report problems.

> Avoid ignoring certificate errors in production systems. Only bypass them temporarily for controlled development or testing environments when you fully understand the risks.

---

# 12. Mutual TLS (mTLS)

Normally

```text id="tls22"
Client

↓

Verifies Server
```

Mutual TLS

```text id="tls23"
Client

↓

Certificate

↓

Server

↓

Certificate

↓

Both Verify Each Other
```

Advantages

* Strong authentication
* Suitable for enterprise systems
* Common in industrial and medical environments

---

# 13. Secure REST APIs

REST over HTTPS

```text id="tls24"
Qt

↓

HTTPS

↓

REST Server

↓

JSON
```

Typical workflow

```text id="tls25"
Login

↓

JWT

↓

HTTPS

↓

REST API
```

Even when using authentication tokens, HTTPS remains essential because it protects the token while it is in transit.

---

# 14. Enterprise Applications

## Banking

```text id="tls26"
Desktop

↓

TLS

↓

Bank Server
```

---

## Medical TPS

```text id="tls27"
TPS

↓

HTTPS

↓

License Server
```

---

## Cloud Backup

```text id="tls28"
Desktop

↓

TLS

↓

Cloud Storage
```

---

## Industrial Automation

```text id="tls29"
HMI

↓

TLS

↓

Gateway
```

---

# 15. Qt Internals

```text id="tls30"
Application

↓

QNetworkAccessManager

↓

QSslSocket

↓

TLS

↓

QTcpSocket

↓

TCP
```

Secure HTTP

```text id="tls31"
HTTPS

↓

TLS

↓

TCP

↓

Network
```

TLS is layered on top of TCP.

---

# 16. Qt 5 vs Qt 6

| Feature           | Qt 5.15            | Qt 6.11            |
| ----------------- | ------------------ | ------------------ |
| QSslSocket        | ✔                  | ✔                  |
| TLS Support       | ✔                  | ✔                  |
| HTTPS             | ✔                  | ✔                  |
| QSslConfiguration | ✔                  | ✔                  |
| TLS 1.3*          | Platform dependent | Platform dependent |

> *TLS version availability depends primarily on the underlying TLS backend (such as OpenSSL or platform-native libraries), not only on the Qt version.

---

# 17. Best Practices

✅ Always use HTTPS instead of HTTP.

✅ Prefer TLS 1.3 when available.

✅ Validate certificates.

✅ Keep CA bundles up to date.

✅ Protect private keys.

✅ Use secure WebSockets (`wss://`) for production.

---

# 18. Common Mistakes

### ❌ Ignoring `sslErrors()`

Never ignore certificate problems in production.

---

### ❌ Hardcoding private keys

Store keys securely outside source code.

---

### ❌ Using expired certificates

Monitor certificate expiration.

---

### ❌ Using outdated TLS versions

Disable obsolete SSL/TLS versions where possible.

---

### ❌ Assuming HTTPS alone solves every security problem

Authentication, authorization, secure coding, and input validation are still required.

---

# 19. Interview Questions

## Easy

1. What is TLS?
2. What is the difference between SSL and TLS?
3. What is `QSslSocket`?

---

## Medium

1. Explain the TLS handshake.
2. What is a digital certificate?
3. What is a Certificate Authority?

---

## Hard

1. Explain symmetric vs asymmetric encryption.
2. What is mutual TLS?
3. How does HTTPS protect REST APIs?

---

## Expert

1. Design the security architecture for a Medical Treatment Planning System communicating with cloud services, hospital servers, and treatment machines.
2. Explain how certificate validation works during a TLS handshake.
3. Compare TLS, VPNs, SSH tunnels, and application-level encryption for enterprise desktop software.

---

# 20. Revision Notes

* TLS secures communication over TCP.
* SSL is obsolete; use modern TLS.
* HTTPS is HTTP over TLS.
* Asymmetric cryptography is used during key exchange.
* Symmetric cryptography encrypts application data.
* Certificates bind identities to public keys.
* Certificate Authorities establish trust.
* `QSslSocket` provides secure socket communication.
* `QSslConfiguration` customizes TLS behavior.
* Always validate certificates and protect private keys.

---

# 💡 Senior Engineer Tips

## Which Secure Protocol Should You Use?

| Requirement                     | Recommended  |
| ------------------------------- | ------------ |
| REST API                        | HTTPS        |
| Real-time browser communication | WSS          |
| Secure TCP application          | TLS over TCP |
| Cloud synchronization           | HTTPS        |
| Device authentication           | mTLS         |

---

## Enterprise Secure Architecture

```text id="tls32"
Qt UI
   │
   ▼
REST Client
   │
   ▼
QNetworkAccessManager
   │
   ▼
QSslSocket
   │
   ▼
TLS
   │
   ▼
REST Server
```

Keep certificate management and authentication separate from business logic.

---

## Medical TPS Security Example

```text id="tls33"
Treatment Planning System
          │
          ├───────────────┐
          ▼               ▼
License Server      Cloud Backup
      HTTPS             HTTPS
          │               │
          └──────┬────────┘
                 ▼
            TLS Encryption
                 │
                 ▼
         Certificate Validation
```

A production medical application should typically include:

* HTTPS for cloud communication
* Certificate validation
* Secure token-based authentication
* Encrypted software updates
* Audit logging for security-sensitive operations

---

## **Chapter 80 — QThread (Complete Deep Dive)**

