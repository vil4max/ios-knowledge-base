# App Intents

## За 30 секунд


**App Intents** expose an app feature to the system — Siri, Shortcuts, Spotlight, and the Action button can invoke it without opening your UI first. An **`AppIntent`** describes an action; **`@Parameter`** declares inputs; **`AppEntity`** maps your model for the system; **`AppShortcutsProvider`** registers voice phrases.

Customization beyond the defaults: **`requestValueDialog`** for prompt text, explicit yes/no for optional parameters, and **`ShowsSnippetView`** + **`ProvidesDialog`** for a rich result with spoken feedback.

| | |

|---|---|

| **Уровни** | Middle, Senior |

| **Must** | Siri/Shortcuts integration, parameter dialogs, optional-parameter UX |

**Related topics:** [SwiftUI](../swiftui/README.md) (snippet views), [Navigation & Deep Links](/architecture/navigation/) (in-app routing from intents), [Deep Links](/system-design/deep-links/) (URL vs intent entry points).


<details class="lang-ru">
<summary>По-русски</summary>

| **Трек** | iOS SDK |

</details>



## Структура топика

- Sample project: [BooksShelfCustomIntent — starter](https://www.createwithswift.com/content/files/2025/04/BooksShelfCustomIntent-starter.zip) → [final](https://www.createwithswift.com/content/files/2025/04/BooksShelfCustomIntent-final-1.zip)
- Tutorial: [Customizing an App Intent](https://www.createwithswift.com/customizing-an-app-intent/)

Typical project layout:

| File | Role |
|------|------|
| `*Entity.swift` | `AppEntity` wrapper for your model |
| `*Intent.swift` | `AppIntent` types (`AddBookIntent`, `OpenBookIntent`, …) |
| `*ShortcutsProvider.swift` | `AppShortcutsProvider` + Siri phrases |
| `NavigationManager` | Route into the right screen after `perform()` |

---

## 🎯 Top 10 — quick map

| # | Question | One-line answer |
|---|----------|-----------------|
| Q1 | What is an App Intent? | System-callable action; exposes app capability to Siri/Shortcuts |
| Q2 | `AppIntent` vs `AppEntity`? | Intent = action; Entity = typed data for parameters/results |
| Q3 | How to register Siri phrases? | `AppShortcutsProvider` + `AppShortcut(intent:phrases:…)` |
| Q4 | Customize parameter prompts? | `requestValueDialog: IntentDialog("…")` on `@Parameter` |
| Q5 | Why are optional params skipped? | Default Shortcuts/Siri behavior; ask explicitly if needed |
| Q6 | How to ask for optional params? | Yes/no `AppEnum` + `requestDisambiguation(among:dialog:)` |
| Q7 | Custom result UI? | `ShowsSnippetView` + `.result { MyView() }` |
| Q8 | Spoken/displayed result text? | `ProvidesDialog` + `IntentDialog` in `.result(dialog:)` |
| Q9 | Siri not speaking dialogs? | Settings → Siri → **Prefer Spoken Responses** |
| Q10 | Where does data persistence happen? | Inside `perform()` — same stack as the app (SwiftData, etc.) |

---

## Ключевые понятия

### Core types

| Type | Purpose |
|------|---------|
| `AppIntent` | Declares action, parameters, `perform()` |
| `@Parameter` | Input the system collects from user or Shortcuts |
| `AppEntity` | Makes your model selectable/searchable in intents |
| `AppEnum` | Enum exposed to the system (genres, yes/no, …) |
| `AppShortcutsProvider` | Registers shortcuts and Siri phrase templates |
| `IntentDialog` | Localized text for prompts and results |

### Intent lifecycle

```
User phrase / Shortcut run
        ↓
System resolves AppShortcut → AppIntent
        ↓
Collect @Parameter values (requestValueDialog per param)
        ↓
perform() async throws → IntentResult
        ↓
Optional: snippet view + dialog
        ↓
App opens / updates if needed (NavigationManager, etc.)
```

### Optional parameters — default vs custom

| Approach | Behavior |
|----------|----------|
| `@Parameter var type: BookType?` alone | System **skips** optional params by default |
| Yes/no `AppEnum` + conditional `requestDisambiguation` | User **chooses** whether to provide optional data |

---

## Карточки знаний (Q&A)

### Q1 — What is an App Intent?

- **Question (RU):** Что такое App Intent?
- **Question (EN):** What is an App Intent?
- **Answer (RU):** **App Intent** — действие приложения, которое система может вызвать из Siri, Shortcuts или Spotlight без обязательного UI. Вы описываете параметры и `perform()`, система собирает ввод и запускает код.
- **Answer (EN):** An **App Intent** is a system-invokable app action. You declare parameters and `perform()`; the system collects input and runs your code.

```swift
import AppIntents

struct AddBookIntent: AppIntent {
    static var title: LocalizedStringResource = "Add Book"

    func perform() async throws -> some IntentResult {
        .result()
    }
}
```

- **Устная заготовка (RU):** Интент = «экспорт фичи в систему»; пользователь запускает действие голосом или из Shortcuts.

---

### Q2 — AppIntent vs AppEntity

- **Question (RU):** Чем `AppIntent` отличается от `AppEntity`?
- **Question (EN):** How is `AppIntent` different from `AppEntity`?
- **Answer (RU):** **`AppIntent`** — **действие** (добавить книгу, открыть книгу). **`AppEntity`** — **объект данных**, который система показывает в picker/search (книга, задача, контакт). Entity conforming type оборачивает вашу модель.
- **Answer (EN):** **`AppIntent`** = action. **`AppEntity`** = data object the system can display, search, or pass as a parameter.

```swift
struct BookEntity: AppEntity {
    var id: String
    var title: String

    static var typeDisplayRepresentation = TypeDisplayRepresentation(name: "Book")
    static var defaultQuery = BookQuery()

    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(title: "\(title)")
    }
}
```

---

### Q3 — Register Siri shortcuts

- **Question (RU):** Как зарегистрировать фразы для Siri?
- **Question (EN):** How do you register Siri phrases?
- **Answer (RU):** Создайте тип с **`AppShortcutsProvider`**, верните массив **`AppShortcut`**. В `phrases` используйте `\(.applicationName)` — система подставит имя приложения.
- **Answer (EN):** Conform a type to **`AppShortcutsProvider`** and return **`AppShortcut`** entries with phrase templates.

```swift
struct BookShelfShortcutsProvider: AppShortcutsProvider {
    static var appShortcuts: [AppShortcut] {
        AppShortcut(
            intent: AddBookIntent(),
            phrases: [
                "Add a new book in \(.applicationName)",
                "Add a book on my \(.applicationName)",
                "New book on my \(.applicationName)"
            ],
            shortTitle: "Add a book",
            systemImageName: "book"
        )
    }
}
```

---

### Q4 — Customize parameter prompts (`requestValueDialog`)

- **Question (RU):** Как задать свой текст при запросе параметра?
- **Question (EN):** How do you customize text when requesting a parameter?
- **Answer (RU):** В инициализаторе **`@Parameter`** передайте **`requestValueDialog: IntentDialog("…")`**. Текст показывается в Shortcuts и озвучивается Siri (если включены spoken responses).
- **Answer (EN):** Pass **`requestValueDialog: IntentDialog("…")`** to `@Parameter`. Used in Shortcuts UI and Siri prompts.

```swift
struct AddBookIntent: AppIntent {
    @Parameter(title: "Title", requestValueDialog: IntentDialog("What's the title?"))
    var title: String

    @Parameter(title: "Author", requestValueDialog: IntentDialog("Who's the author?"))
    var author: String

    @Parameter(title: "Genre", requestValueDialog: IntentDialog("What is the genre?"))
    var genre: Genre
}
```

- **Follow-up:** Siri silent? → **Settings → Siri → Siri Responses → Prefer Spoken Responses**.

---

### Q5 — Optional parameters are skipped

- **Question (RU):** Почему Siri не спрашивает optional-параметр?
- **Question (EN):** Why does Siri skip optional parameters?
- **Answer (RU):** **Optional `@Parameter` по умолчанию пропускаются** — система считает их необязательными и не прерывает flow. Если нужен явный выбор — добавьте отдельный yes/no параметр.
- **Answer (EN):** Optional `@Parameter` values are **skipped by default** to keep the flow short. Add an explicit choice parameter if you need user input.

```swift
@Parameter(title: "Type of book", requestValueDialog: IntentDialog("Is it an e-book or a physical one?"))
var type: BookContentType?  // skipped unless you add custom logic
```

---

### Q6 — Ask for optional parameters explicitly

- **Question (RU):** Как спросить, хочет ли пользователь указать optional-параметр?
- **Question (EN):** How do you ask whether the user wants to provide an optional parameter?
- **Answer (RU):** 1) Enum **`AppEnum`** с Yes/No. 2) `@Parameter` для выбора. 3) В `perform()` — если yes, вызовите **`$param.requestDisambiguation(among:dialog:)`** на optional property wrapper.
- **Answer (EN):** Add a yes/no `AppEnum` parameter; in `perform()`, call **`requestDisambiguation`** on the optional parameter when the user opts in.

```swift
enum IsTypeIncluded: String, CaseIterable, Codable, Identifiable, AppEnum {
    var id: Self { self }
    case yes = "Yes"
    case no = "No"

    static var typeDisplayRepresentation = TypeDisplayRepresentation(name: "Type Included")
    static var caseDisplayRepresentations: [Self: DisplayRepresentation] = [
        .yes: DisplayRepresentation(title: "Yes"),
        .no: DisplayRepresentation(title: "No")
    ]
}

struct AddBookIntent: AppIntent {
    @Parameter(
        title: "Include Type",
        requestValueDialog: IntentDialog("Do you want to include the type of book?")
    )
    var isTypeIncluded: IsTypeIncluded

    @Parameter(title: "Type of book")
    var type: BookContentType?

    @MainActor
    func perform() async throws -> some IntentResult {
        var chosenType: BookContentType?

        if isTypeIncluded == .yes {
            chosenType = try await $type.requestDisambiguation(
                among: BookContentType.allCases,
                dialog: "Which type?"
            )
        }
        // use chosenType (nil if user said no)
        return .result()
    }
}
```

---

### Q7 — Custom result snippet (`ShowsSnippetView`)

- **Question (RU):** Как показать кастомный UI после выполнения интента?
- **Question (EN):** How do you show a custom UI after the intent completes?
- **Answer (RU):** Верните из `perform()` тип **`IntentResult & ShowsSnippetView`**. Используйте **`.result { MySwiftUIView() }`** — вместо generic «Done» пользователь видит ваш snippet.
- **Answer (EN):** Return **`IntentResult & ShowsSnippetView`** and use **`.result { MySwiftUIView() }`**.

```swift
import AppIntents
import SwiftUI

struct IntentSnippetResultView: View {
    var book: Book

    var body: some View {
        HStack {
            Image(systemName: "books.vertical.fill")
                .foregroundStyle(.tint)
            VStack(alignment: .leading) {
                Text("You have a new book on your shelf!")
                Text("Title: \(book.title)")
            }
        }
        .padding()
    }
}

@MainActor
func perform() async throws -> some IntentResult & ShowsSnippetView {
    let newBook = /* persist book */
    return .result {
        IntentSnippetResultView(book: newBook)
    }
}
```

---

### Q8 — Result dialog (`ProvidesDialog`)

- **Question (RU):** Как вернуть текст/озвучку результата?
- **Question (EN):** How do you provide spoken or displayed result text?
- **Answer (RU):** Добавьте **`ProvidesDialog`** к return type. Передайте **`IntentDialog`** в **`.result(dialog:) { view }`**.
- **Answer (EN):** Add **`ProvidesDialog`**, pass **`IntentDialog`** to **`.result(dialog:)`**.

```swift
@MainActor
func perform() async throws -> some IntentResult & ShowsSnippetView & ProvidesDialog {
    let newBook = /* ... */
    let dialog = IntentDialog("New book added on your shelf.")

    return .result(dialog: dialog) {
        IntentSnippetResultView(book: newBook)
    }
}
```

---

### Q9 — `AppEnum` for custom pickers

- **Question (RU):** Как показать enum в интерфейсе интента?
- **Question (EN):** How do you expose an enum in the intent UI?
- **Answer (RU):** Conform enum к **`AppEnum`**: `typeDisplayRepresentation`, `caseDisplayRepresentations`. Для nested model enums (Genre, BookContentType) — тот же паттерн.
- **Answer (EN):** Conform to **`AppEnum`** with display representations for the type and each case.

```swift
enum Genre: String, AppEnum {
    case fiction, nonFiction, sciFi

    static var typeDisplayRepresentation = TypeDisplayRepresentation(name: "Genre")
    static var caseDisplayRepresentations: [Self: DisplayRepresentation] = [
        .fiction: "Fiction",
        .nonFiction: "Non-Fiction",
        .sciFi: "Sci-Fi"
    ]
}
```

---

### Q10 — Wiring intent to app navigation

- **Question (RU):** Как открыть нужный экран после интента?
- **Question (EN):** How do you navigate to the right screen after an intent?
- **Answer (RU):** В `perform()` обновите shared state: **`NavigationManager`**, `@Observable` router, или deep-link URL. `@MainActor` на `perform()` если трогаете UI/SwiftData. Starter project использует `NavigationManager` + shared `ModelContainer` в `@main`.
- **Answer (EN):** Update shared navigation state or model container inside `@MainActor perform()` — same patterns as deep links.

```swift
@MainActor
func perform() async throws -> some IntentResult {
    let book = /* fetch or create */
    NavigationManager.shared.open(book)
    return .result()
}
```

---

## 🏋️ Exercises

1. **Minimal intent** — `OpenSettingsIntent` with one `@Parameter`; register one Siri phrase.
2. **Custom dialogs** — three `@Parameter` fields, each with unique `requestValueDialog`; test in Shortcuts app.
3. **Optional flow** — yes/no for an optional field; verify skip vs disambiguation paths.
4. **Snippet view** — SwiftUI card showing created entity; add `ProvidesDialog` message.
5. **AppEntity picker** — `OpenBookIntent` with `@Parameter(title: "Book") var book: BookEntity`; open detail in app.
6. **AppEnum** — genre picker with localized `DisplayRepresentation`.
7. **Siri test** — run phrase on device; toggle spoken responses and compare.
8. **Error path** — `throw` from `perform()` when validation fails; observe system error UI.

---

## Ссылки

- [Customizing an App Intent (Create with Swift)](https://www.createwithswift.com/customizing-an-app-intent/)
- [BooksShelfCustomIntent — starter (zip)](https://www.createwithswift.com/content/files/2025/04/BooksShelfCustomIntent-starter.zip)
- [BooksShelfCustomIntent — final (zip)](https://www.createwithswift.com/content/files/2025/04/BooksShelfCustomIntent-final-1.zip)
- [App Intents — Apple Documentation](https://developer.apple.com/documentation/appintents)
- [AppShortcutsProvider](https://developer.apple.com/documentation/appintents/appshortcutsprovider)
- [Making actions and content discoverable (WWDC)](https://developer.apple.com/videos/play/wwdc2024/10176/)
- Related: [SwiftUI](../swiftui/README.md) · [Deep Links](/system-design/deep-links/)

---

> Customize prompts, respect optional parameters, show rich results — that's how you make **App Intents** feel native.
