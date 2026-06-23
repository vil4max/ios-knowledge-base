# Testing — exercises

Задачи **без готового решения**. Критерий: AAA, один сценарий на тест, без `sleep`. Подсказки: [Senior-Unit-Testing-Mastery-RU](../notes/Senior-Unit-Testing-Mastery-RU.md), [Testing-Fundamentals-RU](../notes/Testing-Fundamentals-RU.md).

---

## Unit + doubles

1. **Email validator** — три кейса: valid, без `@`, пустая строка. Stub не нужен.
2. **Cart counter** — `add` увеличивает count; `CartStoreSpy` фиксирует `save`.
3. **Retry policy** — max 3 retry только на `networkConnectionLost`; на 401 — один вызов. Spy на `execute`.

## Async + time

4. **Debouncer** — `Clock` protocol; два события быстрее дедлайна → один вызов callback.
5. **Token refresh** — async `AuthAPI` spy; отмена `Task` → refresh не завершён второй раз.

## Integration

6. **JSON fixture** — `user_ok.json` в bundle → mapper в domain model; отсутствующий ключ → ошибка.
7. **URLProtocol** — stub 200 + body; assert path и decoded model (см. [Testing-Network-Stub-RU](../notes/Testing-Network-Stub-RU.md), [playground](../testing.playground/Contents.swift)).
8. **Contract fixture** — `user_ok.json` из OpenAPI example → DTO + mapper; сломанное поле в fixture → красный тест (см. [Contract-Tests-OpenAPI-RU](../notes/Contract-Tests-OpenAPI-RU.md)).

## UI (опционально)

9. **Launch arg** — `-UITesting` открывает экран без логина; один XCUITest на `accessibilityIdentifier` кнопки.

## Test Plan (конфигурация)

10. Опиши два `.xctestplan`: **PR** (unit only) и **Nightly** (+ UI). Какие теги Swift Testing включишь?

---

После решения — сверь с [чеклистом ревью](../notes/Senior-Unit-Testing-Mastery-RU.md#11-чеклист-ревью-тестов-как-лид).
