# SQLite vs NoSQL vs Core Data vs SwiftData

Конспект для темы **Storage & Persistence**. Связь: [Storage README](../README.md) (**Q49**, **Q51–Q53**).

---

## За 30 секунд





_English summary — expand «По-русски» for the full Russian text._


<details class="lang-ru">
<summary>По-русски</summary>

**SQLite** и **NoSQL** — **разные категории**, а не два конкурирующих продукта на одной оси. **SQLite** — встроенная реляционная SQL-база в одном файле на устройстве. **NoSQL** — семейство backend-технологий (Document, Key-Value, Graph, Column) для масштаба и гибкой схемы.

**Core Data** — не база данных, а **Object Graph and Persistence Framework** (фреймворк объектного графа и персистентности). **SwiftData** — современный Swift-native слой (iOS 17+), построенный на концепциях Core Data. Оба обычно сохраняют данные в **SQLite** → файл `.sqlite`. SQL в приложении вы почти не пишете — работаете с Swift-объектами.

---

</details>



## Что такое SQLite?

_English summary — expand «По-русски» for full text (Что такое SQLite?)._

<details class="lang-ru">
<summary>По-русски</summary>

**SQLite** — лёгкая встраиваемая **relational database** (реляционная БД). Всё хранится в одном файле `.sqlite` на устройстве.

### Характеристики

- Relational database (реляционная модель)
- Uses **SQL** (язык запросов)
- **ACID transactions** (транзакции с гарантиями целостности)
- **JOINs** и relationships (связи между таблицами)
- No server required (сервер не нужен)
- Excellent for **offline storage** (офлайн-хранение)

### Пример

**Users**

| id | name | age |
|----|------|-----|
| 1 | Max | 46 |
| 2 | John | 30 |

```sql
SELECT * FROM Users WHERE age > 40;
```

### Типичные iOS use cases

- Offline storage (офлайн-данные)
- Local cache (локальный кэш)
- Notes apps (заметки)
- Finance apps (финансы)
- Inventory (инвентарь)
- Любая персистентная локальная data

### Библиотеки поверх SQLite

- **GRDB** — migrations, concurrency, observation, async
- **SQLite.swift** — type-safe query builder
- **FMDB** — legacy ObjC/Swift wrapper

На iOS также: **SwiftData → SQLite**, **Core Data → SQLite** (default), **GRDB → SQLite**.

### Плюсы и минусы

| Плюсы | Минусы |
|-------|--------|
| Zero configuration | Not designed for many concurrent writers |
| Very fast locally | Not distributed |
| Transactions | Not a backend for millions of users |
| JOINs, relationships | |
| Reliable, ACID | |

---

</details>

## Что такое NoSQL?

_English summary — expand «По-русски» for full text (Что такое NoSQL?)._

<details class="lang-ru">
<summary>По-русски</summary>

**NoSQL** — не одна база данных. Это **категория** (семейство) БД, оптимизированных под масштаб и гибкие модели данных.

### Типы NoSQL

| Тип | Примеры | Суть |
|-----|---------|------|
| **Document** (документная) | MongoDB, Firebase Firestore | JSON-подобные документы; поля могут отличаться |
| **Key-Value** (ключ–значение) | Redis | `"user:123" → {...}`; cache, sessions, fast lookup |
| **Graph** (графовая) | Neo4j | Узлы и рёбра: social, recommendations, fraud |
| **Column** (колоночная) | Apache Cassandra | Огромные распределённые датасеты, high write throughput |

### Пример document

```json
{
    "name": "Max",
    "age": 46,
    "skills": [
        "Swift",
        "SwiftUI"
    ]
}
```

Каждый document может иметь разные поля — **flexible / schema-less** (гибкая или без жёсткой схемы).

### Характеристики

- Flexible data model
- Usually **server-based** (обычно на сервере)
- **Horizontal scaling** (горизонтальное масштабирование)
- Optimized for **distributed systems**

### Типичные use cases

- Backend services
- Cloud applications
- Social networks
- Analytics
- Large-scale systems

---

</details>

## SQLite vs NoSQL

_English summary — expand «По-русски» for full text (SQLite vs NoSQL)._

<details class="lang-ru">
<summary>По-русски</summary>

Это **разные категории**, а не «SQLite или MongoDB на устройстве».

| | SQLite | NoSQL |
|---|--------|-------|
| Модель | Relational (реляционная) | Document / Key-Value / Graph / Column |
| Запросы | SQL | Обычно свой язык / API |
| Схема | Fixed, can evolve (фиксированная, эволюционирует) | Flexible / schema-less |
| Размещение | Single local file | Usually server |
| Транзакции | ACID | Depends on implementation |
| Сильная сторона | Local storage | Cloud scalability |

### Что быстрее?

**Зависит от задачи.**

| SQLite быстрее для | NoSQL быстрее для |
|--------------------|-------------------|
| Local apps | Massive scale |
| Complex queries, JOINs | Horizontal scaling |
| Transactions | Simple key lookups |
| | Flexible data models |

---

</details>

## Пример: social network

_English summary — expand «По-русски» for full text (Пример: social network)._

<details class="lang-ru">
<summary>По-русски</summary>

**SQLite (relational)** — естественные таблицы и JOIN:

```
Users ── Posts ── Comments ── Likes
```

```sql
SELECT *
FROM Posts
JOIN Users ON Posts.userId = Users.id;
```

**MongoDB (document)** — связанные данные часто в одном документе, JOIN не нужен:

```json
{
    "user": "Max",
    "posts": [
        {
            "text": "...",
            "comments": [...]
        }
    ]
}
```

---

</details>

## Где Core Data и SwiftData?

_English summary — expand «По-русски» for full text (Где Core Data и SwiftData?)._

<details class="lang-ru">
<summary>По-русски</summary>

Многие думают, что **Core Data — это база данных**. Это не так.

- **Core Data** — **Object Graph and Persistence Framework** (управление объектным графом в памяти + персистентность на диск)
- **SwiftData** — современный persistence framework Apple (iOS 17+), построенный на концепциях Core Data
- Фактическое хранилище — обычно **SQLite**

```
SwiftUI / UIKit App
        │
        ▼
SwiftData / Core Data
        │
        ▼
SQLite
        │
        ▼
.sqlite file
```

Вы редко пишете SQL напрямую — работаете с Swift-объектами; фреймворки конвертируют операции в SQLite.

### SwiftData example

```swift
@Model
final class User {
    var name: String
    var age: Int

    init(name: String, age: Int) {
        self.name = name
        self.age = age
    }
}
```

```swift
let users = try context.fetch(FetchDescriptor<User>())
```

### Core Data example

```swift
let request = User.fetchRequest()
let users = try context.fetch(request)
```

### Core Data — плюсы и минусы

| Плюсы | Минусы |
|-------|--------|
| Mature framework | More boilerplate |
| Object graph management | Steeper learning curve |
| Relationships, faulting (lazy load) | |
| Undo/Redo | |
| Migrations | |
| Background contexts | |

### SwiftData — плюсы и минусы

| Плюсы | Минусы |
|-------|--------|
| Modern Swift API | Requires iOS 17+ |
| `@Model` macros | Some advanced Core Data features still missing |
| Less boilerplate | |
| Great SwiftUI integration | |
| Built on Core Data concepts | |
| SQLite under the hood | |

---

</details>

## Когда что использовать?

_English summary — expand «По-русски» for full text (Когда что использовать?)._

<details class="lang-ru">
<summary>По-русски</summary>

| Слой | Когда |
|------|-------|
| **SQLite (direct)** | Нужен прямой SQL; **GRDB** / **SQLite.swift**; максимальный контроль над запросами |
| **Core Data** | Сложный object graph; зрелые приложения; legacy; iOS до 17; сложные migrations |
| **SwiftData** | Новые iOS 17+ приложения; SwiftUI-first; меньше boilerplate |
| **NoSQL (backend)** | Cloud; MongoDB, Firestore, Couchbase, DynamoDB; гибкая схема; horizontal scale |

---

</details>

## Типичная iOS-архитектура

_English summary — expand «По-русски» for full text (Типичная iOS-архитектура)._

<details class="lang-ru">
<summary>По-русски</summary>

**Локальный путь:**

```
SwiftUI → ViewModel → Repository → SwiftData / Core Data → SQLite
```

**Удалённый путь:**

```
SwiftUI → REST / GraphQL API → Backend → MongoDB / Firestore / PostgreSQL / Redis
```

iOS-приложение обычно **не** подключается к NoSQL напрямую — общается с backend через API.

### Для iOS-разработчика

- **SQLite** встретите чаще: SwiftData, Core Data, GRDB, FMDB
- **NoSQL** — чаще backend-технологии; на клиенте — через сеть

---

</details>

## Copy-paste: 30-second interview answer



SQLite is a lightweight embedded relational database used for local persistent storage. Core Data is not a database—it is Apple's object graph and persistence framework that typically stores data in SQLite. SwiftData is Apple's modern persistence framework introduced in iOS 17. It is built on top of Core Data and provides a cleaner, Swift-native API using @Model while still persisting data in SQLite. NoSQL databases, such as MongoDB or Firestore, are typically backend technologies designed for flexible schemas, horizontal scalability, and distributed systems rather than local on-device storage.


<details class="lang-ru">
<summary>По-русски</summary>

**SQLite** — лёгкая встраиваемая реляционная БД для локального персистентного хранения. **Core Data** — не база данных, а фреймворк объектного графа и персистентности Apple, который обычно сохраняет данные в SQLite. **SwiftData** — современный persistence framework (iOS 17+), построенный на Core Data: API на `@Model`, тесная интеграция со SwiftUI, под капотом — тот же SQLite. **NoSQL** (MongoDB, Firestore и др.) — как правило backend-технологии для гибкой схемы, горизонтального масштабирования и распределённых систем, а не для on-device storage.

</details>


---

## Interview Q&A



### Q1
- **Question (EN):** Are SQLite and NoSQL competitors or different categories?

- **Answer (EN):** Different categories. SQLite is an embedded relational SQL engine for local files; NoSQL is a family of server-side databases optimized for scale and flexible schemas. iOS apps use SQLite locally; NoSQL lives on the backend behind REST/GraphQL.


<details class="lang-ru">
<summary>По-русски</summary>

- **Question (RU):** SQLite и NoSQL — это конкуренты или разные категории?

- **Answer (RU):** **Разные категории.** SQLite — встраиваемая реляционная SQL-БД в одном файле на устройстве (ACID, JOINs, offline). NoSQL — семейство backend-БД (Document, Key-Value, Graph, Column) для масштаба и гибкой схемы. На iOS SQLite — локальный слой; NoSQL — обычно за API на сервере.

</details>
### Q2
- **Question (EN):** Is Core Data a database? Where does SwiftData fit?

- **Answer (EN):** Core Data is an object-graph persistence framework, not a database. SwiftData is the modern Swift layer (iOS 17+) on Core Data concepts. Both typically persist to SQLite. You use objects and fetch APIs, not raw SQL.


<details class="lang-ru">
<summary>По-русски</summary>

- **Question (RU):** Core Data — это база данных? Где SwiftData?

- **Answer (RU):** **Core Data — не БД**, а object graph + persistence framework. **SwiftData** — современный Swift-native слой (iOS 17+) на тех же идеях. Оба обычно пишут в **SQLite** (`.sqlite` file). Вы работаете с объектами и fetch requests / `@Query`, не с SQL.

</details>
### Q3
- **Question (EN):** When SQLite direct, Core Data, SwiftData, or backend NoSQL?

- **Answer (EN):** Direct SQLite (GRDB/SQLite.swift) for SQL control; Core Data for complex graphs and legacy; SwiftData for new iOS 17+ SwiftUI apps; backend NoSQL for cloud scale and flexible schemas—the app talks over the network.


<details class="lang-ru">
<summary>По-русски</summary>

- **Question (RU):** Когда SQLite напрямую, Core Data, SwiftData или backend NoSQL?

- **Answer (RU):** **SQLite direct** (GRDB, SQLite.swift) — полный контроль SQL, очереди, FTS. **Core Data** — сложный граф, legacy, migrations, до iOS 17. **SwiftData** — greenfield iOS 17+ SwiftUI. **NoSQL** — cloud/backend (Firestore, MongoDB), гибкая схема, scale; клиент — через API.

- **Follow-up (RU):** SwiftData vs Core Data на собесе — одной фразой?

- **Follow-up answer (RU):** SwiftData — меньше boilerplate, `@Model`, SwiftUI; Core Data — зрелость, сложные migrations, legacy. Оба → SQLite; threading и migrations понимать в любом случае. См. **Q49** в [README](../README.md).

</details>
### Q4
- **Question (EN):** When would you choose SQLite over NoSQL?

- **Answer (EN):** SQLite for local ACID storage and efficient querying on device. Backend NoSQL when you need flexible schemas, horizontal scalability, and document-oriented cloud data. Senior iOS: SwiftData and Core Data use SQLite by default—you work through higher-level APIs.

---

## Official & further reading



- [SQLite documentation](https://www.sqlite.org/docs.html)

- [Using Core Data in your app](https://developer.apple.com/documentation/coredata/using_core_data_in_your_app)

- [SwiftData](https://developer.apple.com/documentation/swiftdata)

- [GRDB.swift](https://github.com/groue/GRDB.swift)

- [SQLite.swift](https://github.com/stephencelis/SQLite.swift)

- [WWDC23 — Meet SwiftData](https://developer.apple.com/videos/play/wwdc2023/10187/)


<details class="lang-ru">
<summary>По-русски</summary>

- **Question (RU):** Когда выбрать SQLite вместо NoSQL? (interview hook)

- **Answer (RU):** **SQLite** — локальное персистентное хранение в iOS: ACID, эффективные SQL-запросы, надёжный offline. **NoSQL на backend** — когда нужна гибкая схема, horizontal scale, document model (UGC, большие cloud-приложения). Senior iOS: знать, что SwiftData и Core Data по умолчанию используют SQLite, хотя вы пишете high-level API.

</details>
