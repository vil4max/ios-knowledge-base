# Testing

## Apple docs

- [XCTest](https://developer.apple.com/documentation/xctest) — unit / performance, `XCTestCase`, assertions, expectations.
- [Swift Testing](https://developer.apple.com/documentation/testing) — `@Test`, `#expect`, теги, параметризация, Swift Concurrency.
- [Migrating a test from XCTest](https://developer.apple.com/documentation/testing/migratingfromxctest) — миграция сценариев.
- [Adding tests to your Xcode project](https://developer.apple.com/documentation/xcode/adding-tests-to-your-xcode-project) — таргеты, схемы.
- [Running tests and interpreting results](https://developer.apple.com/documentation/xcode/running-tests-and-interpreting-results) — прогон, отчёты.
- [Organizing tests to improve feedback](https://developer.apple.com/documentation/xcode/organizing-tests-to-improve-feedback) — **Test Plans**, подмножества, конфигурации.
- [UI Testing (XCUITest)](https://developer.apple.com/documentation/xcuiautomation) — black-box UI, accessibility tree.

## 🎯 Focus vs Defer

### Focus

- Писать deterministic async-тесты без лишней вложенности.
- Явно проверять порядок событий и фазовые переходы в асинхронных сценариях.

### Defer

- Пиксельные **snapshot** всего экрана при частой смене дизайна — до стабилизации UI или отдельным ночным job.
- Полный **E2E** «как пользователь» без изоляции и стабильных тестовых данных — пока нет инфраструктуры (аккаунты, флаги, сиды).
- Гонка за **coverage %** ради метрики — после базы критических путей.
- Дублирование одних и тех же сценариев в **unit + UI** без явной границы ответственности.

## Карта темы (iOS)

| Слой | Типичный инструмент | Что проверяем |
|------|---------------------|---------------|
| **Unit** | XCTest, Swift Testing | Домен, мапперы, политики, VM при инжекте зависимостей |
| **Integration** | XCTest + фикстуры, локальный stack | Связка слоёв (декодирование, репозиторий + in-memory store) |
| **UI** | XCUITest | Критические потоки, навигация, доступность |
| **Snapshot** | Обычно сторонние библиотеки + CI | Визуальный регресс компонентов при фиксированной среде |
| **Test Plan** | `.xctestplan` в Xcode | Подмножества тестов, конфиги, теги, pre-release vs PR |

**Снапшоты в Apple-стеке:** первоклассного «snapshot testing» для SwiftUI в SDK нет; команды используют сторонние решения и дисциплину эталонов (один simulator/OS, обновление через ревью). Для сравнения структуры данных иногда достаточно `Codable` + фикстуры или эталонный JSON в bundle.

## 📚 Key terms (Q&A)

- **Test pyramid (пирамида тестов):** много быстрых unit → меньше integration → ещё меньше UI/E2E; цель — скорость фидбека и локализация поломки.
- **SUT (system under test, тестируемая система):** один тип / use case; зависимости под контролем.
- **Test double (тестовый двойник):** общее имя для подмены зависимости; дальше по роли — **stub**, **spy**, **fake** (см. [Senior-Unit-Testing-Mastery-RU](notes/Senior-Unit-Testing-Mastery-RU.md)).
- **AAA / Given–When–Then:** Arrange–Act–Assert — структура теста; снижает «простыни» и улучшает чтение при ревью.
- **Deterministic test (детерминированный тест):** одинаковый результат при повторных прогонах; без `sleep`, случайных задержек, зависимости от сети/часов без абстракции.
- **Flaky test (нестабильный тест):** иногда падает без смены кода; типичные причины — гонки, MainActor, общие синглтоны, реальная сеть, недостаточные `await`.
- **Unit test (модульный):** изолированная логика + подставные зависимости; без реального UIKit-дерева и без сети (если не цель теста).
- **Integration test (интеграционный):** несколько реальных слоёв (например декодер + JSON-фикстура, `URLProtocol` stub + сессия); медленнее unit, дороже в поддержке.
- **UI test (UI-тест):** обычно **XCUITest** — сценарии через accessibility; проверяют поток и контракт экрана, не заменяют unit для бизнес-правил.
- **Snapshot test (снапшот-тест):** сравнение эталонного изображения / описания view с текущим рендером; часто сторонние библиотеки + дисциплина обновления эталонов (device/OS).
- **Test Plan (тест-план в Xcode):** `.xctestplan` — какие тесты, какие конфигурации (язык, диагностика, повторы), подмножества для CI vs pre-release; теги Swift Testing / категории XCTest.
- **Swift Testing vs XCTest:** новый фреймворк с `#expect`, параметризацией, тегами; XCTest остаётся стандартом для legacy и части CI-интеграций; в одном бандле могут сосуществовать.
- **TDD / test-after:** TDD — цикл red–green–refactor; test-after — тесты после кода; на собесе важно уметь обосновать выбор под риск и дедлайн.
- **Regression test (регрессионный):** тест на конкретный баг (красный → фикс → зелёный); высокий ROI.
- **Contract test (контрактный):** клиент ↔ API (схема, фикстуры ответов); ловит расхождение до продакшена.

## 🏋️ Exercises

1. **Граница unit:** для одного экрана со SwiftUI перечисли, что тестировать в **ViewModel/Observable** модуле, а что отложить в UI-тест. **Ожидаемо:** список входов/состояний vs тапы по дереву.
2. **Stub vs Spy:** для `PaymentClient` опиши, что вернёт **stub**, что запишет **spy** в сценарии «401 не ретраим». **Ожидаемо:** stub задаёт ответы, spy считает вызовы `execute`.
3. **Async без флейков:** перепиши гипотетический тест с `sleep(1)` на `async` + контролируемый источник событий (см. Q5 / `AsyncStream`). **Ожидаемо:** явный порядок событий, без таймера.
4. **Test Plan:** набросай два плана для одной схемы: `PR` (только unit + быстрые integration) и `Nightly` (+ медленные UI). **Ожидаемо:** ссылка на [Organizing tests to improve feedback](https://developer.apple.com/documentation/xcode/organizing-tests-to-improve-feedback).
5. **Snapshot-дисциплина:** перечисли 3 правила, когда **не** добавлять полноэкранный snapshot. **Ожидаемо:** живой дизайн, динамический контент, разные OS без эталона.

Подробные задачки без готового кода — в [Senior-Unit-Testing-Mastery-RU](notes/Senior-Unit-Testing-Mastery-RU.md) (раздел «Задачки»).

## 🌟 Senior+ (strategic)

- **Риск > coverage:** приоритизировать деньги, данные, главный пользовательский поток и инварианты домена (см. Q37 в карточках ниже).
- **Тестируемая архитектура:** узкие протоколы, инъекция зависимостей, отсутствие «магии» в синглтонах — иначе unit дорогой и флейковый.
- **CI как продукт:** параллелизация, шардирование, стабильные фикстуры, отдельный контейнер для тестов; красный CI = блокер мержа.
- **Диагностика:** Thread Sanitizer / concurrency checks на подходящих таргетах; воспроизводимые баги сначала красным тестом.
- **Контракты API:** фикстуры + опционально схема (OpenAPI); ловит поломки до релиза клиента.
- **Команда:** договорённость по именованию doubles, уровню снапшотов и «что не тестируем в unit» — снижает споры на ревью.

## Артефакты

- Notes: `notes/`
- Exercises: `exercises/`
- Assets: `assets/`
- Playgrounds: `playgrounds/`

### Последние заметки

- [Senior unit testing — вопросы, задачи, чеклист (RU)](notes/Senior-Unit-Testing-Mastery-RU.md)
- `notes/event-stream-sequence-testing-in-swift-testing.md`

---

## TL;DR

- `confirmation` в Swift Testing хорошо работает для простых async-проверок, но быстро уходит во вложенность.
- Для сценариев “важен порядок callback-событий” удобнее представить события как `AsyncStream`.
- Затем собирать события массивом и проверять их декларативно: `#expect(events == [...])`.
- Для поэтапных проверок полезен `collect(until:)`, чтобы снять “срез” событий без полного завершения потока.

## Источник

- `https://www.massicotte.org/blog/testing-event-stream/`

## Проблема при миграции с XCTest

При переходе с `XCTestExpectation` на `confirmation` простые кейсы мигрируются легко, но в сценариях с несколькими callback и требованием строгого порядка возникают две боли:

- сильная вложенность `confirmation`;
- нет удобного способа явно проверить последовательность (`a -> b` vs `b -> a`).

## Идея: тестировать не callback, а поток событий

Вместо набора флагов/expectations:

1. Создаём `AsyncStream<Event>` и `Continuation`.
2. В callback вызываем `continuation.yield(event)`.
3. После действия (`await system.go()`) собираем события и сравниваем с ожидаемым порядком.

## Базовый шаблон

```swift
import Testing

@Test
func testSystemEventOrder() async {
    let (stream, continuation) = AsyncStream<String>.makeStream()

    system.callbackA = { continuation.yield("a") }
    system.callbackB = { continuation.yield("b") }

    await system.go()
    continuation.finish()

    let events = await stream.collect()
    #expect(events == ["a", "b"])
}
```

Ключевой момент: если используете `collect()` до конца потока, нужно вызвать `finish()`, иначе сбор не завершится.

## Удобные extension для AsyncSequence

```swift
extension AsyncSequence {
    func collect() async rethrows -> [Element] {
        try await reduce(into: [Element]()) { result, element in
            result.append(element)
        }
    }
}
```

Для “частичного” чтения потока:

```swift
extension AsyncSequence where Element: Equatable {
    func collect(until match: Element) async rethrows -> [Element] {
        var result: [Element] = []
        for try await element in self {
            result.append(element)
            if element == match { break }
        }
        return result
    }
}
```

## Поэтапная валидация (phase-based)

```swift
@Test
func testSystemInPhases() async {
    let (stream, continuation) = AsyncStream<String>.makeStream()

    system.callbackA = { continuation.yield("a") }
    system.callbackB = { continuation.yield("b") }
    system.callbackC = { continuation.yield("c") }

    await system.startPhase1()
    continuation.yield("phase1.done")

    let phase1 = await stream.collect(until: "phase1.done")
    #expect(phase1 == ["a", "b", "phase1.done"])

    await system.startPhase2()
    continuation.yield("phase2.done")

    let phase2 = await stream.collect(until: "phase2.done")
    #expect(phase2 == ["c", "phase2.done"])

    continuation.finish()
}
```

## Что это даёт

- Тесты читаются как сценарий событий.
- Порядок проверяется явно и стабильно.
- Меньше вложенности и процедурного шума.
- Удобнее масштабировать на сложные async-пайплайны.

## Практические выводы / что брать в работу

- Используйте enum для событий (`enum Event`) вместо строк, чтобы избежать опечаток.
- Завершайте поток (`finish`) только там, где действительно нужен полный сбор.
- Для длинных сценариев делите проверку на фазы через `collect(until:)`.
- Если таких тестов много, вынесите обёртку `EventStream<Event>` и переиспользуйте.

## Мини-чеклист

- Есть ли в тесте явная проверка порядка событий, а не только факта вызова.
- Закрывается ли поток через `finish()`, когда ожидается полный `collect()`.
- Разделены ли большие async-сценарии на фазы через `collect(until:)`.
- Используются ли типобезопасные события (enum), а не “магические” строки.

---

## Карточки знаний (Q&A)

Ниже — Q&A по теме.

<!-- knowledge-cards-canonical:start -->

### Q37
- **Question (RU):** какие тесты приоритетны под deadline (дедлайн)?
- **Question (EN):** Which tests first under a deadline?
- **Answer (RU):** Зацепка: под дедлайн тестируешь **риск**, не процент строк — сначала **деньги/данные/главный поток**, потом **контракт с API**, потом **регресс по фиксу**.

    сначала критический пользовательский поток и доменные инварианты (оплата, создание сущности, синк); затем контракт клиента API (фикстуры ответов); затем регрессионные багфиксы с тестом «красный→зелёный». Полное покрытие edge cases и UI-снимки — когда есть время.

- **Answer (EN):** Under time pressure: business-critical flows and domain rules first, API contract second, regression tests for fixed bugs third—defer vanity coverage and flaky snapshots.

- **Устная заготовка (RU):** сначала то, что убьёт продукт или данные; потом API-контракт; снапшоты всего UI — в конце.

- **Устная заготовка (EN):** Risk-first: critical path → API fixtures → bug regressions; snapshots last.

- **Follow-up:** что точно не тестировать первым?
- **Follow-up answer:** хрупкие snapshot всего экрана при живом дизайне; end-to-end всего приложения без изоляции; покрытие ради процента без риска.

- **Доп. информация:** контрактные тесты против OpenAPI-схемы ловят расхождение до продакшена.

- **Playground:** [open](testing.playground/Contents.swift)
- **Notes:** [VI. Качество/23 Тестирование — Unit, UI, Snapshot, Test Plans/Testing-Unit-UI-Snapshot.md](VI. Качество/23 Тестирование — Unit, UI, Snapshot, Test Plans/Testing-Unit-UI-Snapshot.md)

### Q46
- **Question (RU):** testing baseline (база тестирования): что покрывать первым?
- **Question (EN):** Testing baseline—cover what first?
- **Answer (RU):** Зацепка: **unit первым** — правила без сети/UI и с подставными зависимостями; **integration точечно** — где важна связка слоёв.

    бизнес-правила изолированно (unit), контракт с зависимостями через протоколы/моки; структура AAA. Интеграционные — меньше, на стыке со слоями (реальный декодер + фикстура JSON).

- **Answer (EN):** Fast feedback: unit-test domain/rules with mocks; fewer integration tests for real wiring (decoder + fixtures, URLProtocol stubs)—use AAA.

- **Устная заготовка (RU):** изоляция и моки → unit; несколько настоящих слоёв → integration.

- **Устная заготовка (EN):** Pure logic + injected deps first; glue tests second.

- **Follow-up:** как отличать unit test (модульный) от integration test (интеграционный) в мобильном проекте?
- **Follow-up answer:** unit — один тип, зависимости подделаны; integration — несколько реальных слоёв (например сеть до `URLProtocol` stub + декодер).

- **Доп. информация:** флаки из общего синглтона — изолировать тестовый контейнер.

- **Playground:** [open](testing.playground/Contents.swift)
- **Notes:** [VI. Качество/23 Тестирование — Unit, UI, Snapshot, Test Plans/Testing-Unit-UI-Snapshot.md](VI. Качество/23 Тестирование — Unit, UI, Snapshot, Test Plans/Testing-Unit-UI-Snapshot.md)

---

<!-- knowledge-cards-canonical:end -->
