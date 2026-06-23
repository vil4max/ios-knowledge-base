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
- **Regression safety:** тесты ловят поломки уже работающего при изменениях — не замена ручного «потыкать приложение».
- **FIRST:** Fast, Isolated, Repeatable, Self-validating, Timely — чеклист качества теста (см. [Testing-Fundamentals-RU](notes/Testing-Fundamentals-RU.md)).
- **Test double (тестовый двойник):** общее имя для подмены зависимости; роли — **dummy**, **stub**, **mock**, **spy**, **fake** (см. [Testing-Fundamentals-RU](notes/Testing-Fundamentals-RU.md), [Senior-Unit-Testing-Mastery-RU](notes/Senior-Unit-Testing-Mastery-RU.md)).
- **AAA / Given–When–Then:** Arrange–Act–Assert — структура теста; снижает «простыни» и улучшает чтение при ревью.
- **Deterministic test (детерминированный тест):** одинаковый результат при повторных прогонах; без `sleep`, случайных задержек, зависимости от сети/часов без абстракции.
- **Flaky test (нестабильный тест):** иногда падает без смены кода; типичные причины — гонки, MainActor, общие синглтоны, реальная сеть, недостаточные `await`.
- **Unit test (модульный):** изолированная логика + подставные зависимости; без реального UIKit-дерева и без сети (если не цель теста).
- **Integration test (интеграционный):** несколько реальных слоёв (например декодер + JSON-фикстура, `URLProtocol` stub + сессия); медленнее unit, дороже в поддержке.
- **UI test (UI-тест):** обычно **XCUITest** — сценарии через accessibility; проверяют поток и контракт экрана, не заменяют unit для бизнес-правил.
- **Snapshot test (снапшот-тест):** сравнение эталонного изображения / описания view с текущим рендером; часто сторонние библиотеки + дисциплина обновления эталонов (device/OS).
- **Test Plan (тест-план в Xcode):** `.xctestplan` — какие тесты, какие конфигурации (язык, диагностика, повторы), подмножества для CI vs pre-release; теги Swift Testing / категории XCTest.
- **Swift Testing vs XCTest:** новый фреймворк с `#expect`, параметризацией, тегами; XCTest остаётся стандартом для legacy и части CI-интеграций; в одном бандле могут сосуществовать.
- **TDD / test-after:** TDD — цикл red–green–refactor; test-after — тесты после кода; см. [TDD-Basics-RU](notes/TDD-Basics-RU.md), [Q37](#q37).
- **Testing trophy:** альтернатива пирамиде — больше integration/service tests, меньше fanatic unit-only; на собесе: пирамида = скорость фидбека, trophy = уверенность в стыках (не оправдание для 100% UI).
- **`@testable import`:** доступ к `internal` в тестах — удобно, но частый `internal` только «для тестов» — smell; предпочитай узкие протоколы и DI.
- **AI-assisted TDD:** LLM ускоряет red/green; инженер владеет triangulation, refactor тестов и constraints-файлом; автотесты — детерминированная валидация сгенерированного Swift — см. [AI-assisted TDD](notes/ai-assisted-tdd.md).
- **Regression test (регрессионный):** тест на конкретный баг (красный → фикс → зелёный); высокий ROI.
- **Contract test (контрактный):** клиент ↔ API (схема, фикстуры ответов); ловит расхождение до продакшена — см. [Contract-Tests-OpenAPI-RU](notes/Contract-Tests-OpenAPI-RU.md).

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
- **Контракты API:** фикстуры + OpenAPI — [Contract-Tests-OpenAPI-RU](notes/Contract-Tests-OpenAPI-RU.md).
- **Команда:** договорённость по именованию doubles, уровню снапшотов и «что не тестируем в unit» — снижает споры на ревью.

## Артефакты

- Notes: `notes/`
- Exercises: `exercises/`
- Assets: `assets/`
- Playgrounds: `playgrounds/`

### Последние заметки

| Уровень | Заметки |
|---------|---------|
| Fundamentals | [Testing-Fundamentals-RU](notes/Testing-Fundamentals-RU.md) · [TDD-Basics-RU](notes/TDD-Basics-RU.md) |
| Frameworks | [Swift-Testing-vs-XCTest-RU](notes/Swift-Testing-vs-XCTest-RU.md) |
| Слои | [Testing-Network-Stub-RU](notes/Testing-Network-Stub-RU.md) · [Contract-Tests-OpenAPI-RU](notes/Contract-Tests-OpenAPI-RU.md) · [XCUITest-Essentials-RU](notes/XCUITest-Essentials-RU.md) · [Snapshot-Testing-Discipline-RU](notes/Snapshot-Testing-Discipline-RU.md) |
| Delivery | [Test-Plans-CI-RU](notes/Test-Plans-CI-RU.md) · [CI/CD](../../devops/ci-cd/README.md) |
| Senior + AI | [Senior-Unit-Testing-Mastery-RU](notes/Senior-Unit-Testing-Mastery-RU.md) · [AI-assisted TDD](notes/ai-assisted-tdd.md) |

**Exercises:** [exercises/README.md](exercises/README.md)

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

### Q60
- **Question (RU):** зачем тесты, если можно запустить приложение и проверить руками?
- **Question (EN):** Why write tests if you can run the app manually?
- **Answer (RU):** Ручной прогон не масштабируется и не ловит **регрессии** при каждом изменении. Тесты дают **regression safety** и читаются как **спецификация** поведения для команды.
- **Answer (EN):** Manual checks don't scale or catch regressions on every change. Tests provide regression safety and act as executable specification.
- **Устная заготовка (RU):** не «работает ли сейчас», а «не сломали ли то, что работало» + живая документация.
- **Устная заготовка (EN):** Not "does it work now" but "did we break what worked" plus living docs.
- **Notes:** [Testing-Fundamentals-RU](notes/Testing-Fundamentals-RU.md)

### Q61
- **Question (RU):** пирамида тестирования — уровни и почему не всё UI-тестами?
- **Question (EN):** Testing pyramid—levels and why not all UI tests?
- **Answer (RU):** **Unit** (~70%) — быстро, изоляция; **integration** (~20%) — связка слоёв; **UI/E2E** (~10%) — критические потоки. Всё UI — медленно, дорого в поддержке, сложно найти причину падения.
- **Answer (EN):** Many fast isolated unit tests, fewer integration, minimal UI for critical paths. All UI is slow, brittle, and hard to debug.
- **Устная заготовка (RU):** пирамида — скорость фидбека; UI — страховка, не основа.
- **Устная заготовка (EN):** Pyramid optimizes feedback speed; UI is insurance, not the base.
- **Notes:** [Testing-Fundamentals-RU](notes/Testing-Fundamentals-RU.md)

### Q62
- **Question (RU):** FIRST — что означает каждая буква?
- **Question (EN):** What does FIRST stand for in testing?
- **Answer (RU):** **Fast** (миллисекунды), **Isolated** (без общего состояния), **Repeatable** (без флейков), **Self-validating** (pass/fail без ручных логов), **Timely** (пишутся с кодом).
- **Answer (EN):** Fast, Isolated, Repeatable, Self-validating, Timely—write tests with the code, no shared state, no flaky CI.
- **Follow-up:** почему flaky хуже отсутствия теста?
- **Follow-up answer:** Команда перестаёт доверять красному CI и игнорирует падения.
- **Notes:** [Testing-Fundamentals-RU](notes/Testing-Fundamentals-RU.md)

### Q63
- **Question (RU):** Stub vs Mock (и остальные doubles) — в чём разница?
- **Question (EN):** Stub vs Mock—and other test doubles?
- **Answer (RU):** **Stub** — заготовленные **данные**, не проверяет вызовы. **Mock** — **верификация поведения** (вызов, аргументы, count). **Dummy** — параметр-заглушка. **Spy** — запись вызовов (частый Swift-паттерн). **Fake** — упрощённая рабочая реализация (in-memory store).
- **Answer (EN):** Stub supplies canned data; Mock verifies interactions. Dummy fills a parameter; Spy records calls; Fake is a simplified working implementation.
- **Устная заготовка (RU):** на собесе: stub — данные, mock — поведение.
- **Устная заготовка (EN):** Interview sound bite: stub = data, mock = behavior.
- **Notes:** [Testing-Fundamentals-RU](notes/Testing-Fundamentals-RU.md)

### Q64
- **Question (RU):** Swift Testing vs XCTest — когда что?
- **Question (EN):** Swift Testing vs XCTest—when to use which?
- **Answer (RU):** **Swift Testing** — новые unit/integration, `async`, `#expect`, теги. **XCTest** — UI (`XCUITest`), legacy, `measure`. В одном bundle сосуществуют.
- **Answer (EN):** Swift Testing for new async unit tests; XCTest for UI and legacy; both can live in one target.
- **Notes:** [Swift-Testing-vs-XCTest-RU](notes/Swift-Testing-vs-XCTest-RU.md)

### Q65
- **Question (RU):** как стабилизировать XCUITest?
- **Question (EN):** How do you stabilize UI tests?
- **Answer (RU):** `accessibilityIdentifier`, launch arguments для тестового режима, изоляция данных, `waitForExistence` вместо `sleep`, мало критических flow в отдельном Test Plan.
- **Answer (EN):** Stable identifiers, test launch args, isolated data, explicit waits, few critical flows in a dedicated plan.
- **Notes:** [XCUITest-Essentials-RU](notes/XCUITest-Essentials-RU.md)

### Q66
- **Question (RU):** как unit-тестировать сеть без HTTP?
- **Question (EN):** How do you unit-test networking without HTTP?
- **Answer (RU):** Fake `HTTPClient` или `URLProtocol` в `protocolClasses` + своя `URLSession`; не `URLSession.shared`. Детали — [Networking Q H30](../../data-and-network/networking/README.md).
- **Answer (EN):** Inject a fake client or stub URLProtocol on a dedicated session—never poison URLSession.shared.
- **Notes:** [Testing-Network-Stub-RU](notes/Testing-Network-Stub-RU.md)

### Q67
- **Question (RU):** когда snapshot-тесты уместны?
- **Question (EN):** When are snapshot tests appropriate?
- **Answer (RU):** Стабильные **компоненты** design system при фиксированном device/OS; не full-screen при живом дизайне; альтернатива — unit на state + JSON fixtures.
- **Answer (EN):** Stable components with pinned simulator/OS—not whole screens during active redesign.
- **Notes:** [Snapshot-Testing-Discipline-RU](notes/Snapshot-Testing-Discipline-RU.md)

### Q68
- **Question (RU):** Test Plans в CI — PR vs Nightly?
- **Question (EN):** Test Plans in CI—PR vs Nightly?
- **Answer (RU):** **PR** — unit + быстрый integration (<10 min), parallel. **Nightly** — UI, snapshots, locale smoke. Flaky — quarantine plan, не игнор CI.
- **Answer (EN):** Fast subset on every PR; slow UI/snapshots nightly; quarantine flaky tests explicitly.
- **Notes:** [Test-Plans-CI-RU](notes/Test-Plans-CI-RU.md)

### Q69
- **Question (RU):** TDD vs test-after?
- **Question (EN):** TDD vs test-after?
- **Answer (RU):** TDD — red/green/refactor при неясном контракте. Test-after — hotfix/дедлайн, но **риск-first** (Q37). Triangulation и удаление устаревших тестов — на инженере.
- **Answer (EN):** TDD when designing behavior; test-after under deadline with risk-based prioritization.
- **Notes:** [TDD-Basics-RU](notes/TDD-Basics-RU.md)

### Q70
- **Question (RU):** contract tests и OpenAPI — зачем и как на iOS?
- **Question (EN):** Contract tests and OpenAPI—why and how on iOS?
- **Answer (RU):** Проверяют согласованность **клиент ↔ API**: JSON fixtures из спеки, decode + mapper в integration; **OpenAPI в git** + Swift OpenAPI Generator для типов. PR — fixtures без реального HTTP; staging — Nightly. Домен — unit, не contract.
- **Answer (EN):** Fixture-based decode/mapping tests against spec examples; OpenAPI codegen for large APIs; keep domain rules in unit tests.
- **Устная заготовка (RU):** fixture из спеки → decode падает раньше продакшена; OpenAPI — source of truth для codegen.
- **Устная заготовка (EN):** Spec fixtures catch schema drift before production; OpenAPI drives codegen.
- **Notes:** [Contract-Tests-OpenAPI-RU](notes/Contract-Tests-OpenAPI-RU.md)

### Q52
- **Question (RU):** как валидировать Swift-код, сгенерированный LLM / coding agent?
- **Question (EN):** How do you validate LLM-generated Swift code?
- **Answer (RU):** **Unit/integration** тесты на поведение и регрессии (детерминированные); **ревью** до merge; **constraints-файл** (`CLAUDE.md`, `AGENTS.md`) с правилами TDD и TPP — не wiki. Инженер решает triangulation и удаление устаревших тестов. **On-device LLM-фичи** приложения — отдельно [evaluations](../../ai-engineering/evaluations/README.md), не вместо domain tests.

- **Answer (EN):** Deterministic unit/integration tests plus human review; project constraints encode TDD rules. Engineer owns triangulation and test lifecycle. Product LLM features need eval suites separately.

- **Устная заготовка (RU):** тесты — фильтр для сгенерированного кода; человек — за refactor и «какой тест устарел»; evals — для LLM в продукте.

- **Устная заготовка (EN):** Tests gate generated code; human owns test evolution; evals are for in-app LLM behavior.

- **Follow-up:** чем AI-assisted TDD отличается от Evaluations framework?
- **Follow-up answer:** Unit-тесты проверяют **ваш Swift** (домен, VM, мапперы). Evaluations — **недетерминированные** ответы модели в фиче (golden set, tool trajectory).

- **Notes:** [AI-assisted TDD](notes/ai-assisted-tdd.md)

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

- **Доп. информация:** [Contract-Tests-OpenAPI-RU](notes/Contract-Tests-OpenAPI-RU.md).

- **Playground:** [open](testing.playground/Contents.swift) — `user_ok.json`, `user_401.json` → `ProfileError`
- **Notes:** [Testing-Fundamentals-RU](notes/Testing-Fundamentals-RU.md) · [TDD-Basics-RU](notes/TDD-Basics-RU.md) · [Test-Plans-CI-RU](notes/Test-Plans-CI-RU.md)

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

- **Playground:** [open](testing.playground/Contents.swift) — `user_ok.json`, `user_401.json` → `ProfileError`
- **Notes:** [Testing-Fundamentals-RU](notes/Testing-Fundamentals-RU.md) · [Testing-Network-Stub-RU](notes/Testing-Network-Stub-RU.md)

---

<!-- knowledge-cards-canonical:end -->
