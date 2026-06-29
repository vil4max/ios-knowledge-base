# Testing — exercises

Tasks **without a ready-made solution**. Criteria: AAA, one scenario per test, no `sleep`. Hints: [Senior-Unit-Testing-Mastery](../notes/Senior-Unit-Testing-Mastery.md), [Testing-Fundamentals](../notes/Testing-Fundamentals.md).

---

## Unit + doubles

1. **Email validator** — three cases: valid, missing `@`, empty string. No stub needed.
2. **Cart counter** — `add` increases count; `CartStoreSpy` records `save`.
3. **Retry policy** — max 3 retries only on `networkConnectionLost`; on 401 — single call. Spy on `execute`.

## Async + time

4. **Debouncer** — `Clock` protocol; two events faster than deadline → one callback invocation.
5. **Token refresh** — async `AuthAPI` spy; cancelling `Task` → refresh does not complete a second time.

## Integration

6. **JSON fixture** — `user_ok.json` in bundle → mapper to domain model; missing key → error.
7. **URLProtocol** — stub 200 + body; assert path and decoded model (see [Testing-Network-Stub](../notes/Testing-Network-Stub.md), [playground](../testing.playground/Contents.swift)).
8. **Contract fixture** — `user_ok.json` from OpenAPI example → DTO + mapper; broken field in fixture → failing test (see [Contract-Tests-OpenAPI](../notes/Contract-Tests-OpenAPI.md)).

## UI (optional)

9. **Launch arg** — `-UITesting` opens screen without login; one XCUITest on button `accessibilityIdentifier`.

## Test Plan (configuration)

10. Describe two `.xctestplan` files: **PR** (unit only) and **Nightly** (+ UI). Which Swift Testing tags will you include?

---

After completing — compare against the [review checklist](../notes/Senior-Unit-Testing-Mastery.md#11-test-review-checklist-as-lead).
