# Design Patterns

## Creational patterns — digest

### Brief: pattern → description

<a id="ios-design-patterns-problem-first"></a>## iOS design patterns — problem-first map

### Mindset

### Quick reference

### Delegate

### DataSource

### Observer

### Singleton

### Factory

### Builder

### Coordinator

### Adapter

### Strategy

### Facade

### Dependency Injection

### When to skip a pattern

<a id="swift-patterns-under-the-hood"></a>## Swift under the hood — language-level patterns

### Quick reference (language)

### Nuances (interview)

## Apple docs

## 🎯 Focus vs Defer

### Focus

### Defer

## 📚 Key terms (Q&A)

## 🏋️ Exercises

## 🌟 Senior+ (strategic)

## Artifacts

- Notes: `notes/`
- Exercises: `exercises/`
- Assets: `assets/`
- Playgrounds: `playgrounds/`

---

## Interview Q&A (Knowledge cards)

### Q6
- **Question:** Are design patterns about clean code? Why do they matter on iOS?

- **Answer:** Patterns name recurring solutions to recurring problems—not a clean-code badge. iOS APIs embody many of them; interview value is stating the problem solved and trade-offs.

- **Playground:** [open](design_patterns.playground/Contents.swift)

### Q7
- **Question:** Delegate vs DataSource vs Observer?

- **Answer:** Delegate answers behavior questions one-to-one; DataSource supplies data for lists; Observer broadcasts or streams changes to subscribers.

- **Playground:** [open](design_patterns.playground/Contents.swift)

### Q8
- **Question:** When is Singleton appropriate vs harmful?

- **Answer:** Use system singletons knowingly; avoid sprinkling custom `.shared`—inject dependencies instead for testability and explicit boundaries.

- **Playground:** [open](design_patterns.playground/Contents.swift)

### Q9
- **Question:** Adapter vs Facade?

- **Answer:** Adapter translates one foreign interface; Facade offers a narrow API over many internal collaborators.

- **Playground:** [open](design_patterns.playground/Contents.swift)

### Q10
- **Question:** Why Coordinator if you already use MVVM?

- **Answer:** MVVM handles screen state; Coordinator owns routing and module assembly so view models stay navigation-agnostic.

- **Playground:** [open](design_patterns.playground/Contents.swift)

### Q11
- **Question:** Which design patterns are built into Swift itself—not only the iOS SDK?

- **Answer:** Swift embeds Iterator (`Sequence`), Decorator (`@propertyWrapper`), Observer, Builder (`@resultBuilder`), Prototype (CoW), Strategy (protocols/generics), Facade (stdlib), and Command (closures/async work items). Recognize them to use the language intentionally.

<!-- knowledge-cards-canonical:end -->
