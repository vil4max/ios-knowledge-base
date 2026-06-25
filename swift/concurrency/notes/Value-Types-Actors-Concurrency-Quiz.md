# Value types, actors, concurrency — quiz breakdown

> **Status:** draft — перенесено из практического опроса; разбор вопросов, follow-up для собеса.

Краткая шпаргалка и углублённый разбор: struct vs class, copy-on-write, actor reentrancy, `@MainActor`, производительность массивов.

Связь: карточки **Q12–Q13** (actor isolation, reentrancy) в [Concurrency README](../README.md).

---

## 1. Мутация через копию массива (class vs struct)

### Вопрос

```swift
class Entity {
    var id: String

    init(_ id: String) {
        self.id = id
    }
}

class EntityContainer {
    var entities = [
        Entity("a"),
        Entity("b"),
        Entity("c"),
    ]
}

let container = EntityContainer()
var entities = container.entities

entities[0].id = "d"
var entity = entities.removeLast()
entity.id = "e"

print(container.entities.map(\.id))
print(entities.map(\.id))
```

Варианты:

- `["a", "b"]` / `["d", "b"]`
- `["a", "b", "c"]` / `["d", "b"]`
- `["d", "b", "e"]` / `["d", "b", "e"]`
- **`["d", "b", "e"]` / `["d", "b"]`** ✅
- `["d", "b", "e"]` / `["d", "b"]` (дубликат правильного варианта в исходном списке)

### Ответ

```
["d", "b", "e"]
["d", "b"]
```

### Ментальная модель

Три уровня копирования:

| Уровень | Тип | Что копируется |
|---------|-----|----------------|
| `container` | `class` | Одна ссылка на `EntityContainer` |
| `container.entities` vs `entities` | `Array` (struct) | Два **разных** массива после `var entities = container.entities` |
| Элементы массива | `Entity` (class) | **Одни и те же** объекты на куче |

`Array` — value type, но массив классов — массив **указателей**. Копия массива = копия указателей, не объектов.

### Пошагово

```
До мутаций:
container.entities → [ptr₀→"a", ptr₁→"b", ptr₂→"c"]
entities           → [ptr₀→"a", ptr₁→"b", ptr₂→"c"]

entities[0].id = "d"
→ объект ptr₀ меняется → оба массива видят "d"

entities.removeLast()
→ entities: [ptr₀→"d", ptr₁→"b"]                    // длина 2
→ container.entities: [ptr₀→"d", ptr₁→"b", ptr₂→"c"]  // длина 3

entity = ptr₂, entity.id = "e"
→ container.entities[2] тоже "e"
```

| Шаг | Что происходит |
|-----|----------------|
| `var entities = container.entities` | Копируется **массив**, элементы — **ссылки** на те же `Entity`. |
| `entities[0].id = "d"` | Общий объект → `container.entities[0]` тоже `"d"`. |
| `entities.removeLast()` | Удаление только из локального `entities`; в контейнере 3 элемента. |
| `entity.id = "e"` | Мутация общего объекта → `container.entities[2]` становится `"e"`. |

**Итог:** два разных массива (разная длина), три общих объекта на куче.

### Типичные ошибки

| Ошибка | Почему неверно |
|--------|----------------|
| `["a","b","c"]` / `["d","b"]` | Забывают, что `entities[0].id = "d"` меняет **общий** объект |
| `["d","b","e"]` / `["d","b","e"]` | Думают, что `removeLast()` затронул контейнер |
| `["a","b"]` / `["d","b"]` | Путают shallow copy массива с deep copy объектов |

### Если бы `Entity` был struct

Копия массива скопировала бы и значения; мутации через `entities` не затронули бы `container.entities` (COW у буфера массива — отдельная тема; элементы-struct независимы после копии массива).

### Follow-up на собесе

- **Shallow vs deep copy** — копия `[Class]` всегда shallow для элементов.
- **`===` vs `==`** — здесь важна идентичность объектов.
- UIKit: `view.subviews` скопировал, мутировал view → superview тоже видит изменения.

**Одна фраза:** копируется контейнер (массив), не содержимое (объекты class).

---

## 2. Actor reentrancy и `async let`

### Вопрос

```swift
actor Counter {
    var value = 0

    func increment() async {
        let current = value
        await Task.yield()
        value = current + 1
    }
}

let counter = Counter()
async let a = counter.increment()
async let b = counter.increment()
_ = await (a, b)
print(await counter.value)
```

Варианты:

1. **Actor reentrancy: оба читают 0 до записи → `value == 1`** ✅
2. Actor сериализует доступ → `value == 2`
3. Ошибка компиляции — `async let` с методами actor
4. Runtime crash — data race

### Ответ

**Печатается `1`.** Правильный вариант — **1**.

### Два утверждения — не смешивать

| Утверждение | Верно? |
|-------------|--------|
| Actor **сериализует** доступ | ✅ Два вызова не мутируют `value` одновременно |
| Actor **не даёт** lost update при `await` между read и write | ❌ Reentrancy |

Actor ≠ mutex до конца метода. На **suspension point** (`await`) текущий вызов **отпускает** actor, другой изолированный вызов может войти.

### Таймлайн

```
Task A: read value=0 → await yield → [suspend]
Task B: read value=0 → await yield → [suspend]
Task A: value = 0+1 = 1
Task B: value = 0+1 = 1   // current устарел
```

`async let a` и `async let b` стартуют параллельно — оба доходят до `await` почти сразу.

Потерянное обновление — ловушка reentrancy, **не data race**: состояние под защитой actor, логика неверна.

### Почему не другие варианты

- **«Сериализует → 2»** — верно только без suspension между read и write (`value += 1` без `await`).
- **Compile error** — `async let` с actor-методами компилируется.
- **Data race** — внутри одного actor storage гонки нет; это **логический баг**.

### Как писать безопасно

```swift
func increment() {
    value += 1
}

func increment() {
    value = value + 1
}

// ❌ read → await → write с устаревшим локалом
func increment() async {
    let current = value
    await something()
    value = current + 1
}
```

После `await` — перепроверять инварианты или работать со снимком.

### Связь с GCD

Serial queue без `await` внутри блока держит очередь на всё тело. Actor с `await` отпускает «замок» на время ожидания → reentrancy.

**Одна фраза:** actor убирает data race, но не защищает от lost update через `await`.

---

## 3. Производительность: 10 000 маленьких моделей — struct vs class в массиве

### Вопрос

Какое утверждение точнее всего для performance-sensitive пути с 10 000 небольших объектов в массиве?

Варианты:

1. struct медленнее — COW копирует весь массив при каждой мутации
2. Одинаковая производительность — ARC делает class-массивы неотличимыми
3. **struct-массив хранит элементы contiguously, cache-friendly, без heap на элемент; class-массив — ссылки, heap на объект + dereference** ✅
4. class быстрее — O(1) dereference; struct копируется при каждом чтении

### Ответ

**Вариант 3.**

### Память

```
[SmallStruct]  →  |s₀|s₁|s₂|...|s₉₉₉₉|   один буфер, плотная упаковка

[SmallClass]   →  |→obj₀|→obj₁|→obj₂|...|   буфер указателей
                    ↓     ↓     ↓
                   heap  heap  heap
```

| | `[SmallModel]` struct | `[SmallModel]` class |
|--|----------------------|----------------------|
| Буфер массива | Плотно упакованные значения | Contiguous массив **указателей** |
| На элемент | В буфере, без отдельного alloc | Отдельная аллокация на куче |
| Итерация 10k | Последовательный доступ в памяти | 10k pointer chase, промахи кэша |
| Мутация массива | COW — копия буфера только при shared + write | ARC retain/release при передаче ссылок |

### Почему не остальные

- **COW** не на **каждую** мутацию — только при shared buffer + write.
- Contiguous storage у class-массива — у **массива ссылок**, не у данных объектов.
- Чтение struct из массива копирует маленькое значение — дешевле разбросанных heap-объектов.

### Оговорки

- Очень **большой** struct — копия при pass-by-value дороже.
- Нужна **идентичность** (`===`) или shared mutation — class.
- Частые shared copies массива + мутации — COW-копии; иногда `ContiguousArray`.

**Одна фраза:** для 10k маленьких value-моделей плотный struct-массив cache-friendly; class-массив — heap + pointer chase.

---

## 4. `@MainActor` и вызов из non-isolated `async`

### Вопрос

```swift
@MainActor
class ViewModel {
    var title = "Hello"

    func updateTitle(_ newTitle: String) {
        title = newTitle
    }
}

class DataService {
    let viewModel = ViewModel()

    func fetchData() async {
        let result = await someAPICall()
        viewModel.updateTitle(result) // ← эта строка
    }
}
```

Варианты:

1. Runtime crash — `MainActorViolation`
2. Компилируется, автоматически hop на main без `await`
3. Выполняется на текущем потоке — `@MainActor` только advisory
4. **Ошибка компиляции — из non-isolated async нельзя без `await`** ✅

### Ответ

**Ошибка компиляции** (Swift 6 strict concurrency; в Swift 5 — warning). Правильный вариант — **4**.

### Isolation crossing

`ViewModel` изолирован на `@MainActor`. `fetchData()` — nonisolated async. Вызов `updateTitle` — **пересечение isolation** → нужен hop:

```swift
await viewModel.updateTitle(result)
```

`await` здесь не «ждём сеть» — **переключаем isolation domain** на main actor.

### Почему не другие варианты

| Вариант | Реальность |
|---------|------------|
| Runtime crash | В первую очередь compile-time; runtime checks в debug — отдельная тема (см. [Swift-6-Runtime-Concurrency-Crashes](Swift-6-Runtime-Concurrency-Crashes.md)) |
| Автоматический hop без `await` | Нет |
| Advisory | Нет — enforcement, не подсказка |

### Типичный fix

```swift
func fetchData() async {
    let result = await someAPICall()
    await viewModel.updateTitle(result)
}
```

### Follow-up

- `@MainActor` на class vs method.
- `nonisolated` на методе ViewModel.
- `Sendable` при передаче между isolation domains.

**Одна фраза:** cross-actor вызов = `await`, иначе compile error в strict concurrency.

---

## 5. Что такое actor и какую проблему решает

### Краткий ответ (1–2 предложения)

**Actor** — reference type, у которого только одна задача в момент времени мутирует состояние; компилятор требует `await` при доступе снаружи — защита от **data race** на общем mutable state. Раньше: **serial queue и locks**; главная оговорка — **reentrancy на `await`**: между read и write может вклиниться другой вызов, логика ломается без data race.

### Развёрнуто

**Что это:** тип с взаимным исключением для mutable state + проверки изоляции на compile time. `@MainActor` — тот же принцип для UI.

**Какую проблему решает:** безопасное **общее изменяемое состояние** при concurrency.

**Что было раньше:**

- Serial `DispatchQueue`
- Locks (`NSLock`, `os_unfair_lock`, …)
- «Только с main thread» для UI
- Иммутабельность / value types где возможно

**Чего actor не даёт:**

| Миф | Реальность |
|-----|------------|
| «Всё приложение thread-safe» | Гонки между акторами, `nonisolated`, non-Sendable |
| «Параллелит CPU внутри» | Внутри одного actor — очередь |
| «Как mutex до конца метода» | `await` отпускает actor |
| «Замена транзакций БД» | Сеть/диск — отдельные контракты |

### Сравнение с предшественниками

| | Serial queue + lock | Actor |
|--|---------------------|-------|
| Data race на одном state | ✅ при дисциплине | ✅ по дизайну |
| Reentrancy на await | N/A (sync block) | ⚠️ да |
| Compile-time | ❌ | ✅ Swift 6 |
| Deadlock | queue A ↔ B | actor A ↔ B через `await` |

### Caveats

| Риск | Суть |
|------|------|
| Reentrancy | `await` внутри метода actor — окно для другого вызова |
| Deadlock | Взаимные `await` между двумя actor |
| Overhead | Cross-actor вызов — suspend + планирование |
| Не ускоряет CPU | Внутри одного actor работа не параллелится |
| `nonisolated` / non-`Sendable` | Можно обойти гарантии |
| Отладка | Порядок приостановок сложнее воспроизвести |

**Одна фраза:** actor = anti data race, не anti logic bugs.

---

## Шпаргалка одной строкой

| Тема | Запомнить |
|------|-----------|
| Class в скопированном массиве | Копируется массив ссылок, объекты общие |
| Actor + `await` внутри | Reentrancy → lost updates возможны |
| 10k small models | Struct array — плотная память, class — heap + dereference |
| `@MainActor` из background | Нужен `await`, иначе compile error |
| Actor | Anti data race, не anti logic bugs |
| Value type vs stack | Value type ≠ stack; семантика копии, не место хранения (§6) |

---

## 6. Value type vs stack vs heap (interview)

### Вопрос

Могут ли **value types** храниться в **heap** (куче)?

### Ответ

**Да.** **Value type** задаёт **семантику копирования** (value semantics), а не место хранения.

| Контекст | Где обычно лежит значение |
|----------|---------------------------|
| Локальная переменная | Часто **stack** (или регистры / inline в кадре вызова) |
| Stored property **`class`** | **Встроено** в аллокацию объекта класса на **куче** |
| Захват **escaping closure** (уходящего замыкания) | Может оказаться в **heap**-контексте замыкания |
| Буфер `Array` / `String` / … | **CoW**-буфер в **куче**, хотя тип — `struct` |

### Главная мысль

**Value type ≠ Stack. Reference type ≠ Heap.**

На собесе сначала говоришь про **семантику** (`struct` / `enum` / **tuple** — независимые копии; `class` — общая **identity**), потом уточняешь **где** лежат байты.

### Follow-up на собесе

- **Tuple** — value type? → **Да** (как `struct` без имени типа).
- **Tuple** может быть в куче? → **Да**, если поле `class` или захват escaping closure — те же правила, что у любого value type.
- **Reference type** всегда в куче? → Практически всегда для `class`/`actor`; важнее не это, а то, что **value/reference** — про **семантику**, не про «только стек / только куча».

### Связь с другими материалами

- [syntax Q45–Q47](../../syntax/README.md) — value vs reference, layout `struct` в `class`
- [memory-arc README](../../memory-arc/README.md) — области памяти, CoW
- **§1** этого файла — копия `[Class]` = shallow по элементам

**Одна фраза:** value type описывает **как копируется**, heap/stack — **где оказались байты** в конкретном контексте.

---

## 7. Быстрые ответы (flashcards)

| Вопрос | Короткий ответ | Подробнее |
|--------|----------------|-----------|
| Value type всегда на stack? | **Нет.** | [§6](#6-value-type-vs-stack-vs-heap-interview) |
| Reference type всегда в heap? | Практически да для `class`, но ось — **семантика**, не адрес. | [§6](#6-value-type-vs-stack-vs-heap-interview), [syntax Q45](../../syntax/README.md) |
| Что делает **`weak`**? | Не удерживает объект; после dealloc → **`nil`** (zeroing). | [memory-arc Q47](../../memory-arc/README.md) |
| **Tuple** — value type? | **Да.** | [syntax Q59](../../syntax/README.md) |
| Tuple может быть в heap? | **Да** — поле `class` или escaping capture. | [§6](#6-value-type-vs-stack-vs-heap-interview), [syntax Q59](../../syntax/README.md) |

---

## TODO (draft)

- [ ] Добавить playground с runnable примерами (Q1 array copy, Q2 counter)
- [ ] Дополнительные вопросы: `Sendable`, `nonisolated`, deadlock двух акторов, bank transfer reentrancy
