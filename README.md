# ✅ ToDo VIPER iOS

A clean and fully functional **ToDo List** application for iOS, built following VIPER architecture principles.

![Swift](https://img.shields.io/badge/Swift-6.2.3-orange?logo=swift)
![Platform](https://img.shields.io/badge/Platform-iOS%2016%2B-blue?logo=apple)
![Architecture](https://img.shields.io/badge/Architecture-VIPER-purple)
![Storage](https://img.shields.io/badge/Storage-CoreData-green)

---

## 📱 Features

- **Task list** — view all tasks on the main screen
- **Create / Edit / Delete** tasks with title, description, creation date and status
- **Search** through tasks in real time
- **Initial data load** from [DummyJSON API](https://dummyjson.com/todos) on first launch
- **Offline-first** — all data is persisted with CoreData and restored between sessions
- **Non-blocking UI** — all data operations run on background threads via GCD

---

## 🏗️ Architecture

The app is built with the **VIPER** pattern. Each module is split into five clear layers:
```
Module/
├── View        — UIViewController, renders UI and forwards user actions
├── Interactor  — Business logic, data fetching and CoreData operations
├── Presenter   — Mediates between View and Interactor, formats data
├── Entity      — Plain data models (structs)
└── Router      — Navigation and module assembly
```

---

## 🛠 Tech Stack

| Area | Solution |
|---|---|
| Language | Swift Swift 6.2.3 |
| UI Framework | UIKit |
| Architecture | VIPER |
| Persistence | CoreData |
| Concurrency | GCD (`DispatchQueue`) |
| Networking | URLSession |
| Testing | XCTest |
| Version Control | Git |

---

## 🗂 Project Structure
```
TodoVIPER/
├── Application/
│   ├── AppDelegate.swift
│   └── SceneDelegate.swift
├── Modules/
│   ├── TaskList/
│   │   ├── View/
│   │   ├── Interactor/
│   │   ├── Presenter/
│   │   ├── Entity/
│   │   └── Router/
│   └── TaskDetail/
│       ├── View/
│       ├── Interactor/
│       ├── Presenter/
│       ├── Entity/
│       └── Router/
├── CoreData/
│   ├── TodoModel.xcdatamodeld
│   └── CoreDataStack.swift
├── Network/
│   ├── NetworkService.swift
│   └── DTOs/
└── Tests/
    └── TodoVIPERTests/
```

---

## 🧪 Tests

Unit tests cover Interactors and Presenters using mock dependencies.

---

## 📡 API
```
GET https://dummyjson.com/todos
```

Data is fetched once on first launch and stored in CoreData — no network required after that.
