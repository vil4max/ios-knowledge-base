# 07 · Structured Output

## За 30 секунд

**Structured output** forces LLM responses into a **machine-parseable shape** — JSON, Swift structs — instead of free-form prose you regex-parse. Patterns: **JSON Schema** (cloud APIs), Apple **`@Generable`** macro with **`@Guide`** constraints, and post-generation **validation** before side effects. Reduces hallucinated fields and integration bugs in iOS apps. Distinct from [08 · Tool Calling](../tool-calling/README.md) (model invokes app code) but shares schema thinking.

## Apple docs

- [Generable](https://developer.apple.com/documentation/foundationmodels/generable) — guided generation macro.
- [@Guide attribute](https://developer.apple.com/documentation/foundationmodels/guide(description:)) — field constraints for generation.
- [LanguageModelSession.respond(to:generating:)](https://developer.apple.com/documentation/foundationmodels/languagemodelsession) — typed generation API.
- [WWDC25 — Meet the Foundation Models framework](https://developer.apple.com/videos/play/wwdc2025/286/) — guided generation intro.
- [WWDC25 — Deep dive into the Foundation Models framework](https://developer.apple.com/videos/play/wwdc2025/301/) — `@Generable` patterns.

## 🎯 Focus vs Defer

### Focus

- **Why not raw JSON:** models add markdown fences, trailing commas, extra keys — fragile for `JSONDecoder`.
- **JSON Schema:** cloud `response_format: json_schema` — declare types, required fields, enums.
- **@Generable:** Swift struct as schema; compiler + runtime guide model sampling.
- **@Guide:** descriptions, ranges, regex patterns on properties.
- **Validation:** never trust output for payments — validate types, ranges, business rules in app code.
- **Retry/fallback:** parse failure → retry with stricter prompt or lower temperature.

### Defer

- Constrained decoding internals (grammar-guided sampling) unless research role.
- Every cloud vendor JSON mode quirk — know Apple + one cloud pattern.
- XML structured output legacy unless enterprise integration topic.

## Ключевые понятия

| Approach | Platform | Strength |
|----------|----------|----------|
| **Regex / manual parse** | Any | Fragile — avoid in production |
| **JSON mode** | Cloud APIs | Schema in API request |
| **@Generable** | Apple FM | Native Swift types, `@Guide` |
| **Tool arguments** | Apple FM | `@Generable struct Arguments` on `Tool` |
| **Validation layer** | App | Final gate before API/DB |

**Apple guided generation example:**

```swift
import FoundationModels

@Generable
struct BookingIntent {
    @Guide(description: "City name only, no country")
    let destination: String

    @Guide(description: "ISO date yyyy-MM-dd")
    let checkIn: String

    @Guide(.range(1...30))
    let nights: Int
}

let intent = try await session.respond(to: userMessage, generating: BookingIntent.self)
// intent.destination — typed; still validate dates against calendar API
```

**JSON Schema (cloud) interview pattern:**

```json
{
  "type": "object",
  "properties": {
    "sentiment": { "type": "string", "enum": ["positive", "neutral", "negative"] },
    "confidence": { "type": "number", "minimum": 0, "maximum": 1 }
  },
  "required": ["sentiment", "confidence"],
  "additionalProperties": false
}
```

**Validation checklist (iOS):**

1. **Type correctness** — Generable handles most; cloud JSON needs `Codable` + strict decoding.
2. **Business rules** — dates in future, amounts > 0, enum in allowed set.
3. **Partial/null** — `@Guide` + optional fields vs required; explicit "unknown" sentinel.
4. **Side effects** — show preview UI before commit; idempotent server APIs.
5. **Errors** — user-friendly message; log raw transcript for debug.

**Guided generation vs prompt-only JSON:** schema in type system reduces format errors; model can still hallucinate **values** — validation remains mandatory. Combine with RAG for factual fields (price, inventory).

## 🏋️ Exercises

1. **Extract contact** — Name, phone, email from messy paste. *Expected:* `@Generable struct Contact`; validate phone with `PhoneNumberKit`; nil optional fields.

2. **Enum drift** — Model returns `"pos"` instead of `"positive"`. *Expected:* `@Guide` enum or JSON Schema enum; fail closed to retry.

3. **Calendar event** — NL → EventKit entry. *Expected:* structured date + title; never auto-save without confirmation sheet.

4. **Nested struct** — Order with line items array. *Expected:* `@Generable` nested types; cap array length with `@Guide(.range(1...20))`.

5. **Cloud + iOS** — Backend OpenAI JSON schema, app decodes. *Expected:* `additionalProperties: false`; version schema in API contract.

## Ссылки

- [Generable](https://developer.apple.com/documentation/foundationmodels/generable)
- [Guide](https://developer.apple.com/documentation/foundationmodels/guide(description:))
- [Meet Foundation Models (WWDC25)](https://developer.apple.com/videos/play/wwdc2025/286/)
- Related: [tool-calling](../tool-calling/README.md), [foundation-models](../foundation-models/README.md), [evaluations](../evaluations/README.md)

## Карточки знаний (Q&A)

<!-- knowledge-cards-canonical:start -->

### Q1
- **Question (RU):** Зачем structured output вместо «верни JSON»?
- **Question (EN):** Why structured output instead of "return JSON"?
- **Answer (RU):** Free-form JSON **ломается**: markdown fences, trailing commas, extra keys, wrong types. **Schema / @Generable** constrains generation at sampling time — меньше parse errors, type-safe Swift integration. Validation всё равно нужна для **values**.
- **Answer (EN):** Free-form JSON breaks with fences, extra keys, and type errors. Schema or `@Generable` constrains generation for safer parsing. You still validate values before side effects.
- **Follow-up:** @Generable гарантирует valid JSON?
- **Follow-up answer:** Guarantees **shape** much more reliably than prompt-only; not a substitute for business validation (dates, IDs, authorization).

### Q2
- **Question (RU):** @Guide — что даёт?
- **Question (EN):** What does @Guide provide?
- **Answer (RU):** **Field-level constraints**: description для model, `.range`, patterns, enum hints. Улучшает extraction quality и документирует schema в коде. Tool `Arguments` тоже `@Generable`.
- **Answer (EN):** Field-level descriptions and constraints like ranges and patterns. Improves extraction quality and documents the schema in code. Tool arguments use the same pattern.
- **Follow-up:** optional vs required поля?
- **Follow-up answer:** Swift `Optional` + `@Guide(description: "null if missing")`; JSON Schema `required` array; always handle missing data in UI — don't force model to invent.

### Q3
- **Question (RU):** Validation после generation — что проверять?
- **Question (EN):** What to validate after generation?
- **Answer (RU):** **Business rules** beyond schema: date sanity, numeric bounds, cross-field logic, authorization, idempotency keys. **Never** auto-charge or auto-book on raw model output. Show **confirmation** UI on iOS.
- **Answer (EN):** Business rules beyond schema: dates, bounds, cross-field logic, auth. Never auto-commit financial or calendar actions without user confirmation.
- **Follow-up:** generation failed twice — UX?
- **Follow-up answer:** Fallback to manual form; log transcript; lower temperature retry; track in Evaluations framework as regression.

### Q4
- **Question (RU):** JSON Schema (cloud) vs @Generable (Apple)?
- **Question (EN):** JSON Schema vs @Generable?
- **Answer (RU):** **Same idea**, different surface: JSON Schema in API request for OpenAI/etc.; **@Generable** native Swift with compile-time macro. iOS app on Apple FM → prefer @Generable; hybrid app with backend LLM → Codable + JSON Schema contract.
- **Answer (EN):** Same concept — JSON Schema for cloud APIs, `@Generable` for native Swift on Apple FM. Hybrid apps often use Codable with a JSON Schema backend contract.
- **Follow-up:** can Tool output be @Generable?
- **Follow-up answer:** Yes — `Tool` output can be `Generable` types so model reasons over structured tool results in next turn; keeps pipeline typed end-to-end.

<!-- knowledge-cards-canonical:end -->

<!-- ai-engineering-nav:start -->

---

**AI Engineering:** [Track overview](../README.md) · [← 06 · RAG](../rag/) · [08 · Tool Calling →](../tool-calling/)

<!-- ai-engineering-nav:end -->
