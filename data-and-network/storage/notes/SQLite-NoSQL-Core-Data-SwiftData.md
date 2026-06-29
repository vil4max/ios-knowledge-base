# SQLite vs NoSQL vs Core Data vs SwiftData

Notes for **Storage & Persistence**. Related: [Storage README](../README.md) (**Q49**, **Q51–Q53**).

---

## In 30 seconds

## What is SQLite?

## What is NoSQL?

## SQLite vs NoSQL

## Example: social network

## Where do Core Data and SwiftData fit?

## When to use what?

## Typical iOS architecture

## Copy-paste: 30-second interview answer

SQLite is a lightweight embedded relational database used for local persistent storage. Core Data is not a database—it is Apple's object graph and persistence framework that typically stores data in SQLite. SwiftData is Apple's modern persistence framework introduced in iOS 17. It is built on top of Core Data and provides a cleaner, Swift-native API using @Model while still persisting data in SQLite. NoSQL databases, such as MongoDB or Firestore, are typically backend technologies designed for flexible schemas, horizontal scalability, and distributed systems rather than local on-device storage.

---

## Interview Q&A

### Q1
- **Question:** Are SQLite and NoSQL competitors or different categories?

- **Answer:** Different categories. SQLite is an embedded relational SQL engine for local files; NoSQL is a family of server-side databases optimized for scale and flexible schemas. iOS apps use SQLite locally; NoSQL lives on the backend behind REST/GraphQL.

### Q2
- **Question:** Is Core Data a database? Where does SwiftData fit?

- **Answer:** Core Data is an object-graph persistence framework, not a database. SwiftData is the modern Swift layer (iOS 17+) on Core Data concepts. Both typically persist to SQLite. You use objects and fetch APIs, not raw SQL.

### Q3
- **Question:** When SQLite direct, Core Data, SwiftData, or backend NoSQL?

- **Answer:** Direct SQLite (GRDB/SQLite.swift) for SQL control; Core Data for complex graphs and legacy; SwiftData for new iOS 17+ SwiftUI apps; backend NoSQL for cloud scale and flexible schemas—the app talks over the network.

### Q4
- **Question:** When would you choose SQLite over NoSQL?

- **Answer:** SQLite for local ACID storage and efficient querying on device. Backend NoSQL when you need flexible schemas, horizontal scalability, and document-oriented cloud data. Senior iOS: SwiftData and Core Data use SQLite by default—you work through higher-level APIs.

---

## Official & further reading

- [SQLite documentation](https://www.sqlite.org/docs.html)

- [Using Core Data in your app](https://developer.apple.com/documentation/coredata/using_core_data_in_your_app)

- [SwiftData](https://developer.apple.com/documentation/swiftdata)

- [GRDB.swift](https://github.com/groue/GRDB.swift)

- [SQLite.swift](https://github.com/stephencelis/SQLite.swift)

- [WWDC23 — Meet SwiftData](https://developer.apple.com/videos/play/wwdc2023/10187/)
