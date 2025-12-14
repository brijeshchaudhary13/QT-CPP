

## **1. Debug vs Release Builds**

### **Definition**

* **Debug build**: Built with debug symbols, no/low optimization.
* **Release build**: Built with compiler optimizations, minimal symbols.

---

### **Why this distinction matters**

* Debug builds are for **development and debugging**
* Release builds are for **end users** (performance, size)

---

### **How they differ**

| Aspect       | Debug   | Release      |
| ------------ | ------- | ------------ |
| Symbols      | Yes     | Minimal/None |
| Optimization | Off/Low | High         |
| Performance  | Slower  | Faster       |
| Binary size  | Larger  | Smaller      |

---

### **Example**

* **CMake**

```cmake
set(CMAKE_BUILD_TYPE Debug)   # or Release
```

* **qmake**

```pro
CONFIG += debug   # or release
```

---

### **Interview Tip**

> Never ship Debug builds to customers.

---

## **2. Cross Compilation**

### **Definition**

**Cross compilation** means building an application on one platform (host) to run on another (target).

---

### **Why cross compilation**

* Embedded devices (ARM)
* Automotive/medical hardware
* No compiler on target device

---

### **How it works**

1. Install cross-compiler toolchain
2. Build Qt for the target
3. Configure Kit in Qt Creator
4. Build application for target

---

### **Example**

* Host: Linux x86_64
* Target: ARM Embedded Linux

```bash
arm-linux-gnueabihf-g++
```

---

### **Qt Creator**

* Configure **Kit** with:

  * Cross compiler
  * Target Qt libraries
  * Device (SSH)

---

## **3. Deploying Qt Applications (General)**

### **Definition**

Deployment is the process of **shipping your executable with all required dependencies**.

---

### **Why deployment is tricky**

* Qt apps depend on:

  * Qt libraries
  * Platform plugins
  * Image formats
* Missing one file → app won’t start

---

### **How Qt deployment works**

* Identify dependencies
* Copy required libraries
* Include plugins (platforms, imageformats)
* Test on clean machine

---

### **Common Qt Plugins Needed**

* `platforms/` (very important)
* `imageformats/`
* `styles/`
* `sqldrivers/`

---

## **4. Windows Deployment**

### **Definition**

Windows deployment bundles `.exe` with Qt `.dll` files and plugins.

---

### **Why Windows needs care**

* No system Qt libraries
* DLL search path issues

---

### **How to deploy on Windows**

Use **windeployqt** tool.

---

### **Example**

```bash
windeployqt MyApp.exe
```

This copies:

* Qt DLLs
* Platform plugins
* Required dependencies

---

### **Folder Structure**

```text
MyApp/
 ├── MyApp.exe
 ├── Qt6Core.dll
 ├── Qt6Widgets.dll
 └── platforms/qwindows.dll
```

---

### **Common Error**

```
This application failed to start because no Qt platform plugin could be initialized.
```

👉 Missing `platforms/qwindows.dll`

---

## **5. Linux Deployment**

### **Definition**

Linux deployment typically uses **shared libraries** or **AppImage/DEB/RPM**.

---

### **Why Linux is different**

* Many Qt versions installed system-wide
* Dependency conflicts possible

---

### **How to deploy**

Options:

1. Bundle libraries locally
2. Use **AppImage**
3. Create DEB/RPM packages

---

### **Example – AppImage**

* Portable
* Single file
* No installation needed

```bash
linuxdeployqt MyApp.AppDir/usr/bin/MyApp -appimage
```

---

### **Check Dependencies**

```bash
ldd MyApp
```

---

## **6. macOS Deployment**

### **Definition**

macOS deployment packages the app as a **.app bundle**.

---

### **Why macOS uses bundles**

* Standard macOS app format
* Contains executable + resources + libraries

---

### **How it works**

Use **macdeployqt**.

---

### **Example**

```bash
macdeployqt MyApp.app
```

---

### **App Bundle Structure**

```text
MyApp.app/
 └── Contents/
     ├── MacOS/MyApp
     ├── Frameworks/
     └── Resources/
```

---

### **Code Signing (Important)**

* Required for distribution
* Prevents Gatekeeper warnings

---

## **7. Creating Installers**

### **Definition**

An installer packages your app into an **installable format**.

---

### **Why installers**

* Professional delivery
* Easy installation/uninstallation
* Version management

---

### **Installer Options**

* **Qt Installer Framework**
* NSIS (Windows)
* DMG (macOS)
* DEB/RPM (Linux)

---

### **Qt Installer Framework**

* Cross-platform
* Official Qt tool

---

### **Example**

* Create `config.xml`
* Create packages
* Build installer

```bash
binarycreator -c config.xml -p packages installer.exe
```

---

## **8. Static vs Dynamic Linking**

---

### **Dynamic Linking**

#### **Definition**

Qt libraries are loaded at runtime (`.dll`, `.so`, `.dylib`).

---

#### **Why dynamic linking**

* Smaller executable
* Faster build
* Easier updates

---

#### **Drawbacks**

* Must ship libraries
* Dependency issues

---

### **Static Linking**

#### **Definition**

Qt libraries are compiled **into the executable**.

---

#### **Why static linking**

* Single executable
* Easier deployment
* Better for embedded systems

---

#### **Drawbacks**

* Large binary
* Qt commercial license often required
* Longer build times

---

### **Comparison**

| Feature     | Dynamic    | Static            |
| ----------- | ---------- | ----------------- |
| Binary Size | Small      | Large             |
| Deployment  | Needs libs | Single file       |
| License     | LGPL OK    | Commercial needed |
| Updates     | Easy       | Rebuild           |

---

## **Common Deployment Mistakes (Interview Traps)**

❌ Forgetting platform plugins
❌ Deploying Debug build
❌ Not testing on clean system
❌ Mixing Qt versions
❌ Ignoring licenses

---

## **Interview Questions (Chapter 21)**

**Q: How do you deploy Qt apps on Windows?**
👉 `windeployqt`

**Q: Why app fails with platform plugin error?**
👉 Missing platform plugin

**Q: Static vs dynamic linking?**
👉 Trade-off between size, license, and deployment ease

---

## **Interview Summary (One-liners)**

* Debug = dev, Release = ship
* Cross compile for embedded
* Deploy all Qt dependencies
* windeployqt / macdeployqt
* Installers improve UX
* Static linking simplifies deployment but increases size

---


