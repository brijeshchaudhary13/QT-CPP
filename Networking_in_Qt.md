
## **1. Qt Network Module**

### **Definition**

The **Qt Network module** provides classes to implement **TCP/IP, UDP, HTTP, HTTPS, and SSL-based communication** in a **platform-independent** way.

Key classes:

* `QTcpSocket`, `QTcpServer`
* `QUdpSocket`
* `QNetworkAccessManager`
* `QSslSocket`

---

### **Why Qt Network is needed**

Without Qt Network:

* OS-specific socket code
* Complex APIs (WinSock / POSIX)
* Hard to integrate with Qt event loop

Qt Network:

* Cross-platform networking
* Event-driven (non-blocking)
* Integrated with signals & slots

---

### **How it works**

```
Application → Qt Network API → OS Network Stack → Network
```

---

### **Enable Qt Network**

* **qmake**

```pro
QT += network
```

* **CMake**

```cmake
find_package(Qt6 REQUIRED COMPONENTS Network)
target_link_libraries(app Qt6::Network)
```

---

## **2. QTcpSocket (TCP Client)**

### **Definition**

`QTcpSocket` is used to implement a **TCP client** that connects to a TCP server.

---

### **Why QTcpSocket**

* Reliable communication
* Ordered data delivery
* Used for chat apps, file transfer, client-server systems

---

### **How QTcpSocket works**

1. Create socket
2. Connect to server
3. Send/receive data
4. Handle signals asynchronously

---

### **Key Signals**

* `connected()`
* `readyRead()`
* `disconnected()`
* `errorOccurred()`

---

### **Example – TCP Client**

```cpp
QTcpSocket *socket = new QTcpSocket(this);

socket->connectToHost("127.0.0.1", 1234);

connect(socket, &QTcpSocket::connected, []() {
    qDebug() << "Connected to server";
});

connect(socket, &QTcpSocket::readyRead, [socket]() {
    QByteArray data = socket->readAll();
    qDebug() << "Received:" << data;
});
```

---

### **Send Data**

```cpp
socket->write("Hello Server");
```

---

## **3. QTcpServer (TCP Server)**

### **Definition**

`QTcpServer` listens for **incoming TCP connections**.

---

### **Why QTcpServer**

* Build server-side applications
* Accept multiple clients
* Centralized communication

---

### **How QTcpServer works**

1. Start listening on a port
2. Accept incoming connections
3. Create `QTcpSocket` for each client

---

### **Example – TCP Server**

```cpp
QTcpServer *server = new QTcpServer(this);

server->listen(QHostAddress::Any, 1234);

connect(server, &QTcpServer::newConnection, [server]() {
    QTcpSocket *client = server->nextPendingConnection();
    qDebug() << "Client connected";

    connect(client, &QTcpSocket::readyRead, [client]() {
        QByteArray data = client->readAll();
        qDebug() << "Client says:" << data;
        client->write("Hello Client");
    });
});
```

---

## **4. QUdpSocket (UDP Communication)**

### **Definition**

`QUdpSocket` implements **UDP-based communication**, which is **connectionless**.

---

### **Why QUdpSocket**

* Faster than TCP
* No connection overhead
* Used for streaming, broadcasting, IoT

---

### **How UDP differs from TCP**

| Feature    | TCP      | UDP          |
| ---------- | -------- | ------------ |
| Reliable   | Yes      | No           |
| Connection | Required | Not required |
| Speed      | Slower   | Faster       |

---

### **Example – UDP Sender**

```cpp
QUdpSocket socket;
socket.writeDatagram("Hello UDP",
                     QHostAddress("127.0.0.1"),
                     45454);
```

---

### **Example – UDP Receiver**

```cpp
QUdpSocket socket;
socket.bind(45454);

connect(&socket, &QUdpSocket::readyRead, [&socket]() {
    while (socket.hasPendingDatagrams()) {
        QByteArray datagram;
        datagram.resize(socket.pendingDatagramSize());
        socket.readDatagram(datagram.data(), datagram.size());
        qDebug() << datagram;
    }
});
```

---

## **5. HTTP Requests (QNetworkAccessManager)**

### **Definition**

`QNetworkAccessManager` is used to send **HTTP/HTTPS requests** (GET, POST, PUT, DELETE).

---

### **Why QNetworkAccessManager**

* REST APIs
* Web services
* Cloud integration

---

### **How it works**

1. Create manager
2. Create request
3. Send request
4. Handle reply asynchronously

---

### **Example – HTTP GET**

```cpp
QNetworkAccessManager *manager = new QNetworkAccessManager(this);

QNetworkRequest request(QUrl("https://api.example.com/data"));

connect(manager, &QNetworkAccessManager::finished,
        [](QNetworkReply *reply) {
            qDebug() << reply->readAll();
            reply->deleteLater();
        });

manager->get(request);
```

---

## **6. REST APIs**

### **Definition**

REST APIs allow applications to **exchange data over HTTP** using JSON or XML.

---

### **Why REST APIs**

* Backend integration
* Microservices
* Cloud platforms

---

### **How REST works in Qt**

* HTTP method (GET, POST, etc.)
* JSON payload
* HTTP headers

---

### **Example – HTTP POST (JSON)**

```cpp
QJsonObject obj;
obj["name"] = "Brijesh";
obj["role"] = "Developer";

QNetworkRequest req(QUrl("https://api.example.com/user"));
req.setHeader(QNetworkRequest::ContentTypeHeader,
              "application/json");

manager->post(req, QJsonDocument(obj).toJson());
```

---

## **7. JSON Handling**

### **Definition**

Qt provides classes to **parse and generate JSON**.

Classes:

* `QJsonObject`
* `QJsonArray`
* `QJsonDocument`

---

### **Why JSON handling**

* REST APIs use JSON
* Lightweight data exchange
* Human-readable

---

### **How JSON works in Qt**

* Parse JSON → Qt objects
* Modify data
* Convert back to JSON

---

### **Example – Parse JSON**

```cpp
QByteArray jsonData = reply->readAll();

QJsonDocument doc = QJsonDocument::fromJson(jsonData);
QJsonObject obj = doc.object();

qDebug() << obj["name"].toString();
```

---

### **Example – Create JSON**

```cpp
QJsonObject obj;
obj["id"] = 1;
obj["status"] = "OK";

QJsonDocument doc(obj);
QByteArray data = doc.toJson();
```

---

## **8. SSL Support**

### **Definition**

Qt supports **SSL/TLS** for secure communication using `QSslSocket`.

---

### **Why SSL is important**

* Data encryption
* Secure authentication
* HTTPS support

---

### **How SSL works in Qt**

* Uses OpenSSL
* Automatically handled for HTTPS
* Certificate validation supported

---

### **Example – Check SSL Support**

```cpp
qDebug() << QSslSocket::supportsSsl();
```

---

### **HTTPS Example**

```cpp
QNetworkRequest request(QUrl("https://secure.example.com"));
manager->get(request);
```

---

## **Common Mistakes (Interview Traps)**

❌ Blocking network calls in GUI thread
❌ Not handling errors in QNetworkReply
❌ Ignoring SSL certificate issues
❌ Using TCP where UDP is required

---

## **Interview Questions (Chapter 18)**

**Q: Difference between TCP and UDP?**
👉 TCP = reliable, UDP = fast but unreliable

**Q: Which class handles HTTP requests?**
👉 QNetworkAccessManager

**Q: How is networking made asynchronous?**
👉 Signals & slots

**Q: Does Qt support HTTPS?**
👉 Yes, via SSL

---

## **Interview Summary (One-liners)**

* Qt Network = cross-platform networking
* QTcpSocket = TCP client
* QTcpServer = TCP server
* QUdpSocket = UDP communication
* QNetworkAccessManager = HTTP/REST
* JSON = QJson*
* SSL = secure networking

---


