> **Note**
>
> The code and diagrams below are **conceptual**. Qt's actual implementation details can vary between releases, but the architecture and ideas remain the same.

---
# Chapter 10 — Signals & Slots (Advanced Deep Dive)
---

# 1. `connect()` Overloads

Qt provides multiple overloads of `connect()`.

## Modern Member Function Syntax

```cpp
connect(button,
        &QPushButton::clicked,
        this,
        &MainWindow::saveFile);
```

This is the preferred syntax for new code.

Advantages:

* Compile-time type checking.
* Refactoring support.
* Better IDE navigation.
* No string-based lookup.

---

## Lambda Connection

```cpp
connect(button,
        &QPushButton::clicked,
        this,
        [this]()
{
    saveFile();
});
```

Useful when the logic is small and local.

---

## Context-Free Lambda

```cpp
connect(button,
        &QPushButton::clicked,
        []()
{
    qDebug() << "Clicked";
});
```

Since no context object is supplied, the connection is not tied to a receiver `QObject`. Be careful that any captured objects remain valid.

---

## Legacy Macro Syntax

```cpp
connect(button,
        SIGNAL(clicked()),
        this,
        SLOT(saveFile()));
```

Still supported for compatibility.

Not recommended for new projects because:

* No compile-time checking.
* String parsing at runtime.
* Easier to break during refactoring.

---

# 2. `disconnect()`

Disconnecting removes an existing connection.

Example:

```cpp
disconnect(button,
           &QPushButton::clicked,
           this,
           &MainWindow::saveFile);
```

After disconnection:

```text
Button

↓

clicked()

↓

No Receiver
```

The slot is no longer invoked.

---

## Disconnect Everything from an Object

You can disconnect all signal-slot connections involving an object when appropriate.

For example:

```cpp
button->disconnect();
```

This disconnects the object's signal and slot connections. Use this carefully, as it may remove more connections than intended.

---

# 3. Signal Overloading

Signals can be overloaded.

Example:

```cpp
signals:

    void valueChanged(int);

    void valueChanged(double);
```

Connecting requires disambiguation.

Modern C++ provides helpers such as:

```cpp
connect(slider,
        qOverload<int>(&Slider::valueChanged),
        this,
        &MainWindow::updateValue);
```

Without disambiguation, the compiler cannot determine which overload you mean.

---

# 4. Slot Overloading

Slots may also be overloaded.

Example:

```cpp
public slots:

    void process(int);

    void process(QString);
```

Again, specify the correct overload when connecting.

---

# 5. Signal-to-Signal Connections

Signals are not limited to slots.

You can connect one signal directly to another signal.

```cpp
connect(button,
        &Button::clicked,
        dialog,
        &Dialog::accepted);
```

Conceptually:

```text
Button::clicked()

↓

Dialog::accepted()

↓

Receivers of accepted()
```

This technique is useful when forwarding events through different layers of an application.

---

# 6. `QMetaObject::Connection`

`connect()` returns a connection handle.

Example:

```cpp
QMetaObject::Connection connection =
    connect(button,
            &QPushButton::clicked,
            this,
            &MainWindow::saveFile);
```

Later:

```cpp
disconnect(connection);
```

Advantages:

* Disconnect a specific connection.
* Avoid affecting unrelated connections.
* Convenient for temporary connections.

---

# 7. Automatic Disconnection

One of Qt's biggest advantages is automatic connection cleanup.

Suppose:

```cpp
Sender

↓

Receiver
```

If the receiver is destroyed:

```text
Receiver Destroyed

↓

Connection Removed
```

Likewise, if the sender is destroyed, its connections are cleaned up.

This prevents many dangling callback problems common in other frameworks.

---

# Example

```cpp
QPushButton *button = new QPushButton(this);

connect(button,
        &QPushButton::clicked,
        this,
        &MainWindow::saveFile);
```

When either object is destroyed, Qt automatically removes the connection.

No manual cleanup is usually required.

---

# 8. Connection Storage Internals

Conceptually, each `QObject` stores connection information.

```text
QObject

↓

QObjectPrivate

↓

Connection Data

↓

Signal List

↓

Receiver List
```

For each signal, Qt maintains a collection of receivers.

Conceptually:

```text
clicked()

↓

Receiver A

↓

Receiver B

↓

Receiver C
```

When `clicked()` is emitted, Qt iterates through the connected receivers.

---

# 9. Signal Activation Algorithm

When you write:

```cpp
emit clicked();
```

Conceptually, Qt performs:

```text
Emit Signal

↓

QMetaObject::activate()

↓

Lookup Signal Index

↓

Retrieve Connections

↓

For Each Connection

↓

Determine Connection Type

↓

Invoke Slot
```

Pseudo-code:

```text
for each connection
{
    if DirectConnection

        Call Slot Immediately

    else if QueuedConnection

        Post Event

    else if BlockingQueuedConnection

        Post Event

        Wait
}
```

The real implementation is naturally more sophisticated, but this illustrates the core idea.

---

# 10. Queued Connections and Argument Transport

For queued connections, arguments must cross thread boundaries.

Conceptually:

```text
Thread A

↓

Signal

↓

Package Arguments

↓

Event Queue

↓

Thread B

↓

Unpack Arguments

↓

Call Slot
```

This is why queued connections require argument types that Qt knows how to copy.

---

# 11. Custom Types

Suppose you define:

```cpp
struct Patient
{
    QString name;
    int age;
};
```

If `Patient` is sent across a queued connection, Qt must know about the type.

Typical steps include:

```cpp
Q_DECLARE_METATYPE(Patient)
```

and, before queued use if required:

```cpp
qRegisterMetaType<Patient>("Patient");
```

We'll study the meta-type system in detail in later chapters.

---

# 12. Debugging Signals and Slots

## Common Problem

Nothing happens when a signal is emitted.

Checklist:

* Is the signal emitted?
* Did `connect()` succeed?
* Is the receiver alive?
* Is the slot signature compatible?
* Is the receiver in the expected thread?

---

## Verify Connections

Modern `connect()` returns a `QMetaObject::Connection`.

Store it if you need to manage the connection later.

---

## Breakpoints

Useful places to debug:

* Signal emission (`emit` line).
* Slot entry.
* Object construction.
* Object destruction.

---

## Logging

Example:

```cpp
qDebug() << "Button clicked";
```

Place logging before and inside slots to verify execution order.

---

# 13. Performance Considerations

## Direct Function Call

```cpp
saveFile();
```

Fastest.

---

## Signal

```cpp
emit clicked();
```

Additional work includes:

* Meta-object lookup.
* Connection traversal.
* Slot dispatch.

For normal GUI programming, this overhead is negligible.

---

## Avoid

```text
Millions of Signal Emissions

↓

Tiny Slot

↓

Performance Critical Loop
```

In performance-critical inner loops, consider whether a direct function call is more appropriate.

---

# 14. Best Practices

* Prefer the modern function-pointer syntax.
* Prefer lambdas for small local actions.
* Use `Qt::UniqueConnection` where duplicate connections are possible.
* Keep slots short and focused.
* Offload long-running work to worker threads.
* Use `QMetaObject::Connection` when temporary connections need explicit management.
* Avoid relying on the legacy macro syntax in new code.

---

# 15. Interview Questions

## Easy

1. What does `connect()` return?
2. How do you disconnect a signal?
3. Can one signal be connected to multiple slots?

## Medium

1. Explain automatic disconnection.
2. Compare direct and queued connections.
3. How do you connect overloaded signals?

## Hard

1. Describe the conceptual implementation of `QMetaObject::activate()`.
2. Explain how queued connections transport arguments between threads.
3. Why are custom types registered for queued connections?

## Expert

1. Design an event-driven architecture for a medical TPS using signals and slots.
2. Explain the trade-offs between callbacks and Qt's signal-slot mechanism.
3. Discuss how Qt maintains connection safety when `QObject` instances are destroyed.

---

# Revision Notes

* `connect()` supports multiple modern overloads.
* `disconnect()` removes connections explicitly when needed.
* Signals and slots can be overloaded; overloads must be disambiguated.
* Signals can be connected to other signals.
* `QMetaObject::Connection` provides a handle for managing connections.
* Qt automatically disconnects destroyed `QObject` instances.
* `QMetaObject::activate()` is the conceptual core of signal delivery.
* Queued connections use the event system to deliver calls across threads.

---
[⬅️ Object Tree](/QObjectTree.md)      |          [Meta-Object System ➡️](/QMetaObjectSystem.md)
---

## **License**
This project is licensed under the MIT License.

---

Happy Coding!
