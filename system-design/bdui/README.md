# Backend-Driven UI

## In 30 seconds

## 🎯 Focus vs Defer

**Focus**

- API contract, schema versioning, backward compatibility
- Client renderer (SwiftUI/UIKit components map)

## Key concepts

| Term | Meaning |
|------|---------|

| BDUI | Backend owns layout/composition rules |
| Renderer | Client maps server model → native views |
| Schema migration | Old app + new JSON |

## Materials

| Material | Status |
|----------|--------|
| [immh-bdui.md](notes/immh-bdui.md) | stub only (hub: [mobile/notes/immh-series-index.md](/system-design/mobile/notes/immh-series-index.md)) |
| [immh-series-index.md](../mobile/notes/immh-series-index.md) | full series |

## Resources

## Links

- Umbrella: [Mobile App Design](/system-design/mobile/)
- [Feature Flags](/system-design/feature-flags/)
- [Analytics & Remote Config](/system-design/analytics/)
- [SwiftUI](/ios-sdk/swiftui/)

## Interview Q&A (Knowledge cards)

### Q1
- **Question:** BDUI vs a regular REST API?
- **Answer:** REST supplies data; BDUI supplies UI structure (blocks, order, actions) mapped to a finite set of native renderers.
