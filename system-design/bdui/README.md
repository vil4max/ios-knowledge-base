# Backend-Driven UI

## За 30 секунд

**BDUI** (backend-driven UI): сервер отдаёт описание экрана или блоков (JSON / protobuf), клиент **рендерит** по контракту. Отличается от «просто API»: меняется не только data, но и **composition** UI. Тесно связан с feature flags, analytics и versioning.

**Статус:** skeleton — полный конспект immh не мигрирован (нет исходного текста). См. [immh-series-index.md](../mobile/notes/immh-series-index.md).

## 🎯 Focus vs Defer

**Focus**

- API contract, schema versioning, backward compatibility
- Client renderer (SwiftUI/UIKit components map)
- Cache, fallback when server schema unknown
- Rollout: flags, A/B, kill switch
- Security: не исполнять произвольный код с сервера

**Defer**

- Полная замена нативной навигации без плана отката
- BDUI для всего приложения с day one

## Ключевые понятия

| Term | Meaning |
|------|---------|
| SDUI | Server-driven UI — общий термин |
| BDUI | Backend owns layout/composition rules |
| Renderer | Client maps server model → native views |
| Schema migration | Old app + new JSON |

## Материалы

| Material | Status |
|----------|--------|
| [immh-bdui.md](notes/immh-bdui.md) | stub only (hub: [mobile/notes/immh-series-index.md](/system-design/mobile/notes/immh-series-index.md)) |
| [immh-series-index.md](../mobile/notes/immh-series-index.md) | full series |

## Ресурсы

### immh — BDUI
- **Type:** article
- **URL:** https://immh.tech/blog/system-design-bdui
- **Author:** immh
- **Why:** BDUI в контексте mobile system design
- **When:** Динамические экраны, server-driven layout на собесе
- **Tags:** `system-design`, `bdui`, `immh`
- **Note:** [notes/immh-bdui.md](notes/immh-bdui.md)
- **Added:** 2026-06-19

## Ссылки

- Umbrella: [Mobile App Design](/system-design/mobile/)
- [Feature Flags](/system-design/feature-flags/)
- [Analytics & Remote Config](/system-design/analytics/)
- [SwiftUI](/ios-sdk/swiftui/)

## Карточки знаний (Q&A)

### Q1. BDUI vs обычный REST API?

**RU:** REST отдаёт данные; BDUI отдаёт **структуру UI** (какие блоки, порядок, actions). Клиент знает ограниченный набор компонентов-рендереров.

**EN:** REST supplies data; BDUI supplies UI structure and actions mapped to native components.

**Доп. информация:** [notes/immh-bdui.md](notes/immh-bdui.md) _(fill after paste)_
