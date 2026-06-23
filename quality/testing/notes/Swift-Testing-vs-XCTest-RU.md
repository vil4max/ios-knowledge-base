# Swift Testing vs XCTest

**Назначение:** когда какой фреймворк, миграция async-тестов, теги и Test Plans. Связь: [event-stream pattern](../README.md#идея-тестировать-не-callback-а-поток-событий), [Senior-Unit-Testing-Mastery-RU](Senior-Unit-Testing-Mastery-RU.md).

**Topic README:** [Testing](../README.md)

---

## TL;DR

**XCTest** — дефолт legacy и UI (`XCUITest`). **Swift Testing** (`import Testing`) — `@Test`, `#expect`, нативный `async`/`await`, теги, параметризация. В одном test bundle могут сосуществовать. Новые unit-тесты на поддерживаемых OS — предпочитать Swift Testing; UI и часть CI-интеграций — XCTest.

---

## Сравнение

| | **XCTest** | **Swift Testing** |
|---|------------|-------------------|
| Тест | `func test_*()` в `XCTestCase` | `@Test func …()` |
| Assert | `XCTAssertEqual`, … | `#expect`, `#require` |
| Async | `async throws` методы или `XCTestExpectation` + `wait` | `async` тест «из коробки» |
| Параметризация | `XCTAssert` в цикле или отдельные методы | `@Test(arguments:)` |
| Фильтр в CI | categories, Test Plan | **tags** (`@Test(.tags(.unit))`) |
| UI | `XCUIApplication` | только через XCTest UI target |

---

## Когда Swift Testing

- Новый **unit** / **integration** таргет, iOS 17+ / macOS 14+ (проверь deployment target проекта).
- **Async** сценарии без цепочек expectations.
- Порядок событий через `AsyncStream` + `#expect(events == [...])` — см. [README TL;DR](../README.md).
- Теги для Test Plan: `.unit`, `.integration`, `.slow`.

```swift
import Testing

@Suite(.tags(.unit))
struct DiscountTests {
    @Test(arguments: [
        (100, 0, 100),
        (100, 15, 85),
        (100, 100, 0),
    ])
    func priceAfterDiscount(base: Decimal, percent: Decimal, expected: Decimal) {
        let actual = base * (1 - percent / 100)
        #expect(actual == expected)
    }
}
```

---

## Когда оставить XCTest

- **XCUITest** (UI automation) — только XCTest.
- Legacy таргет, миграция не в приоритете.
- `XCTestExpectation` + delegate-колбэки, если миграция на stream ещё не сделана.
- Performance tests (`measure { }`) — пока в XCTest.

---

## Миграция с XCTestExpectation

| XCTest | Swift Testing |
|--------|---------------|
| `XCTAssertEqual(a, b)` | `#expect(a == b)` |
| `XCTUnwrap(x)` | `#require(x)` |
| `let e = expectation…; wait(for: [e])` | `await` + контролируемый источник или `confirmation` для простых кейсов |
| Несколько callback + порядок | `AsyncStream` + `collect()` / `collect(until:)` |

**Боль миграции:** `confirmation` вложенный при нескольких callback — см. [README](../README.md): перейти на поток событий.

---

## `@Suite` и изоляция

- `@Suite(.serialized)` — тесты suite по очереди (общий ресурс, Keychain, файл).
- Отдельные suite по модулю: `AuthServiceTests`, `CartViewModelTests`.
- Не смешивать unit и UI в одном suite.

---

## Тестирование ViewModel / `@Observable`

Граница: **VM в unit**, **тапы в UI**.

```swift
import Testing

@MainActor
@Test
func addItem_incrementsCount() {
    let cart = CartSpy()
    let sut = CartViewModel(cart: cart)
    sut.add(Item(id: "1"))

    #expect(sut.itemCount == 1)
    #expect(cart.savedItems.count == 1)
}
```

- `@MainActor` на тесте или SUT — иначе data race (Swift 6).
- Проверять **состояние** и **вызовы** use case (Spy), не `UILabel.text`.
- `@Observable` — тест на публичные свойства / методы, не на внутренности observation.

---

## Сосуществование в проекте

1. Один test target может содержать и `XCTestCase`, и `@Test`.
2. Test Plan выбирает **targets** и **configurations**, не фреймворк.
3. CI: один `xcodebuild test` гоняет оба.

---

## Вопросы–ответы (собес)

**Q. Почему Swift Testing для async?**  
**A.** Нет обязательного `wait(for:timeout:)`; меньше флейков от коротких таймаутов; `#expect` с лучшими сообщениями об ошибке.

**Q. Заменяет ли Swift Testing XCTest полностью?**  
**A.** Нет. UI tests и часть performance — XCTest.

**Q. Как фильтровать в CI?**  
**A.** Test Plan + теги Swift Testing или categories XCTest.

---

## Официально

- [Swift Testing](https://developer.apple.com/documentation/testing)
- [Migrating a test from XCTest](https://developer.apple.com/documentation/testing/migratingfromxctest)
- [XCTest](https://developer.apple.com/documentation/xctest)

---

**Версия:** 1.0 · **Язык:** RU
