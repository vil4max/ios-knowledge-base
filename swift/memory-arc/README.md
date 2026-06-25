# Memory & ARC

## Materials


- Playgrounds: [ARCAdvanced.playground](ARCAdvanced.playground) (retain cycles, `Task`, Combine) · [ARCCompileTimeVsRuntime.playground](ARCCompileTimeVsRuntime.playground) · [HHMemoryLayout.playground](HHMemoryLayout.playground)
<details class="lang-ru">
<summary>По-русски</summary>

- **SwiftUI ownership** (`@State` / `@StateObject`, `.task`, VM в `body`) — Q-card в [SwiftUI README](../../ios-sdk/swiftui/README.md) (*Memory & ownership — ARC in SwiftUI*)

</details>

## Topic structure


- `notes/` — Q&A + links to Apple docs
- `exercises/` — exercises with expected outcome
- `playgrounds/` — runnable examples

---

## Senior notes: autorelease pool and ARC (topic **II·07**)


<details class="lang-ru">
<summary>По-русски</summary>

- **ARC** балансирует `retain`/`release` по владению. **`autorelease`** откладывает `release` до **drain** текущего пула на потоке — это не GC, счётчик ссылок остаётся моделью жизни объекта.
- В Swift вызов **`[obj autorelease]`** обычно **не виден** — он под **Foundation / ObjC / мостом**; **`@autoreleasepool { }`** задаёт **свою** границу drain (типичный кейс — **пик памяти** в tight loop с временными ObjC‑объектами).
- **Кто поднимает пулы:** явный `@autoreleasepool`; на main — контекст, **связанный с итерациями** RunLoop (см. **I·02**); у выполнения **dispatch‑блока** на платформе Apple часто есть своя обёртка (деталь реализации `libdispatch`).

**Связка с темой I·02:** RunLoop, главная очередь, «тик» и потоки без run loop — [`Operating-Systems-and-Networks-for-iOS.md`](<../../I. Фундамент/02 Операционные системы и сети для iOS/Operating-Systems-and-Networks-for-iOS.md>) (раздел **Конспект Senior: RunLoop…**).

**Внешние материалы (Habr):**

- [Habr (hh.ru) — «Память в Swift от 0 до 1»](https://habr.com/en/companies/hh/articles/546856/) — ARC, ссылки, retain cycles, `[weak self]` и смежное.
- [Habr (Avito) — «Как Swift работает с памятью: подробный гайд для разработчиков. Часть 1»](https://habr.com/en/companies/avito/articles/1017162/) — устройство памяти в Swift (серия, часть 1).
- [Habr (Avito) — часть 2](https://habr.com/en/companies/avito/articles/1017248/) — практические задачи и типовые ошибки.

</details>

## Extra notes: Avito pt.1 (theory)


<details class="lang-ru">
<summary>По-русски</summary>

Источник: [Habr (Avito), часть 1](https://habr.com/en/companies/avito/articles/1017162/).

</details>

### Memory regions

<details class="lang-ru">
<summary>По-русски</summary>

- **Стек** — LIFO, быстрый сдвиг указателя; локальные переменные и параметры с lifetime в пределах кадра вызова.
- **Куча** — произвольный доступ, дороже аллокация; объекты с неопределённым или длинным lifetime, reference types, буферы value-контейнеров.
- **Глобальная** — на весь процесс; `static` / глобальные сущности фиксированного размера, известного на compile time. **Non-frozen** value types в глобальной области хранятся **косвенно** (ссылка в глобальной, тело — в куче).

</details>

### Value vs Reference

<details class="lang-ru">
<summary>По-русски</summary>

- **Value** (`struct`, `enum`, tuples, примитивы) — копия независима; чаще стек, но не всегда (см. ниже).
- **Reference** (`class`, `actor`, `indirect enum`, closures) — копируется указатель; изменения видны через все ссылки; обычно куча.
- **Коллекции** (`Array`, `String`, …) — value-семантика, но **буфер в куче** + **CoW**.

</details>

### Copy-on-Write

<details class="lang-ru">
<summary>По-русски</summary>

- До мутации копии и оригинал делят один буфер; при записи в shared storage — копирование данных.
- Неявный CoW: стандартные коллекции; **большой struct (>3 machine words) в existential** — копируется контейнер, данные в куче; мутация через копию контейнера триггерит CoW данных.

</details>

### Existential container

<details class="lang-ru">
<summary>По-русски</summary>

- Базовый `any P`: **5 machine words** (64-bit → 40 байт): 3 под значение или ссылку на кучу, 1 value witness table, 1 protocol witness table.
- **`P & Q`**: **6 words** — два protocol witness table.
- **Class-only / `AnyObject`**: **2 words** — ссылка на `HeapObject` + одна PWT (метаданные класса уже в объекте).
- **`ProtocolA & ProtocolB`** (один class-only): **3 words** — ссылка + две PWT.

</details>

### Reference types (cost / safety)

<details class="lang-ru">
<summary>По-русски</summary>

| Тип | Удерживает объект | После dealloc | Overhead |
|-----|-------------------|---------------|----------|
| **strong** | да | — | минимальный |
| **weak** | нет | `nil` | side table, дороже |
| **unowned (safe)** | нет | crash | счётчик unowned; может задержать тело без side table → «зомби» |
| **unowned (unsafe)** | нет | UB | без счётчика |

**Objective-C `assign`** (атрибут `@property`) — не Swift-ссылка: для примитивов копируется значение; для объектов — только адрес без retain, **dangling pointer** после dealloc. Для делегатов — **`weak`**, не `assign`. Подробнее — **Q47**.

По умолчанию у объекта **2 inline-счётчика** в метаданных: **strong** и **unowned (safe)**. При первой **weak** или переполнении inline — учёт в **side table** (**3** счётчика: strong, unowned safe, weak).

</details>

### Side table

<details class="lang-ru">
<summary>По-русски</summary>

- Отдельная мета-структура: ссылка на объект, счётчики, флаги; обнуление `weak` после освобождения тела.
- Создаётся при первой `weak` или переполнении inline-счётчиков strong / unowned (safe).

</details>

### Object lifecycle

<details class="lang-ru">
<summary>По-русски</summary>

```text
Live → (strong == 0) → Deiniting [deinit]
  → нет weak/unowned → Dead
  → есть unowned (safe) → Deinited → (unowned == 0) → Dead или Freed
  → Freed: тело снято, side table ждёт weak == 0 → Dead
```

- **«Зомби»** — `deinit` уже вызван, память тела ещё не возвращена: **unowned (safe)** без side table удерживает объект в **Deinited**; аналогично сценарий strong+unowned → снять strong при живом unowned.
- **Strong reference cycle** — контур strong-ссылок; лечение: `weak` / `unowned`, capture list, weak delegate.

</details>

### Class vs struct (Apple criteria)

<details class="lang-ru">
<summary>По-русски</summary>

1. **Стоимость аллокации** — куча дороже; class обычно в куче; struct — стек, но: поле class, existential >3 words, escaping capture, `inout` → куча.
2. **ARC при копировании** — struct с двумя **value**-полями дешевле class; struct с двумя **reference**-полями при копии увеличивает **два** refcount vs **один** у class.
3. **Диспетчеризация** — struct статическая; class динамическая (`final` / devirtualization — быстрее).
4. **Нужны ли** наследование, `===`, `AnyObject` / `NSObject` — class.

</details>

### Non-frozen types

<details class="lang-ru">
<summary>По-русски</summary>

- Размер/layout могут измениться в новой версии бинарного модуля без перекомпиляции app.
- Компилятор может не заранее выделить стек под кадр с non-frozen (например `URL`) — отдельная аллокация по фактическому размеру.
- **Frozen** — фиксированный layout → оптимизации (стек, глобальная память).

</details>

### Alignment

<details class="lang-ru">
<summary>По-русски</summary>

- Поля выравниваются под machine word → **padding**; `MemoryLayout.size` ≠ сумма полей; `stride` — шаг в contiguous storage (массив).
- Пример: `Bool` + `UInt64` → size 16 из-за выравнивания `UInt64` на 8 байт.

</details>

### Tools

<details class="lang-ru">
<summary>По-русски</summary>

- Runtime: **Allocations**, malloc stack logging.
- Снимок: **Leaks**, **Memory Graph**, Virtual Memory Tracker.
- CLI по `*.memgraph`: `footprint`, `vmmap`, `leaks`, `heap`, `malloc_history`.
- См. также **quality/debug** и карточки **Q42**–**Q46** ниже.

</details>

### ~60s interview: side table + lifecycle

<details class="lang-ru">
<summary>По-русски</summary>

**Side table:** когда появляется первая **`weak`** или не хватает inline-счётчиков в объекте, рантайм выносит учёт **strong / unowned / weak** в **отдельную структуру** рядом с объектом. Тогда после `deinit` можно **обнулить `weak`** и корректно освободить память; **`weak` дороже `strong`** из-за этой косвенности.

**Цикл:** пока есть strong — объект **Live**; strong упал в ноль — **`deinit`** (фаза **Deiniting**). Дальше без `weak`/`unowned` часто сразу **Dead**. Если был **`unowned`**, тело может задержаться после `deinit`, пока считаются unowned; при **side table** возможна фаза **Freed**, когда тело уже сняли, а таблица ждёт нуля по **weak** — важно: **`deinit` не всегда означает «вся память сразу вернулась ОС»**.

</details>

## Extra notes: Avito pt.2 (practice)


<details class="lang-ru">
<summary>По-русски</summary>

Источник: [Habr (Avito), часть 2](https://habr.com/en/companies/avito/articles/1017248/).

| # | Суть | Вывод для собеса |
|---|------|------------------|
| 1 | `ClassA` ↔ `ClassB` strong | Retain cycle; одна ссылка → `weak` |
| 2 | `weak var array = [MyClass()]` | `weak` только на reference type; обёртка `WeakBox` |
| 3 | Рекурсия `number -= 2` | Stack overflow; guard `>= 0`; tail call vs `@_optimize(none)` |
| 4 | `struct { var next: Self? }` | Value type — бесконечный размер при compile time; `class` / `indirect enum` ок |
| 5 | `Bool` + `UInt64` vs порядок полей | Padding: size/stride 16 vs 9/16; у `class` layout — размер ссылки (8) |
| 6 | `[MyProtocol]` из struct | В массиве existential **40** байт, не размер struct |
| 7 | `ProtocolA` / `ProtocolB: AnyObject` / `A & B` | **40 / 16 / 24** байт — базовый / class-only / композиция PWT |
| 8 | Два больших struct в `any` ссылаются | Утечки нет: value + CoW через existential — копии расходятся при мутации |
| 9 | Closure с/без `[myClass]` | Неявный захват **переменной** (ref-to-ref) vs копия ссылки в capture list |
| 10 | `callback = { async { [weak self] } }` | `[weak self]` во внутреннем closure не спасает — strong `self` во внешнем |
| 11 | `closure = closure ?? foo` | Неявный strong `self` на method reference → cycle; `[weak self]` в default |
| 12 | `[unowned labelView]` после `cleanView` | **Зомби** в Deinited без side table; фикс: `nil` closure / strong ref + cleanup |
| 13 | `var b = ClassB(a: self)` | Циклическая инициализация; `lazy` / optional + `weak` обратная ссылка |
| 14 | `let x = MyClass()` + `shared` | Два разных экземпляра; `static let` — lazy init при первом обращении |
| 15 | `swap(&MyClass.myStruct.a, &MyClass.myStruct.b)` | Overlapping exclusive access (`inout`); локальная копия struct |

</details>

## 🎯 Focus vs Defer


### Focus

<details class="lang-ru">
<summary>По-русски</summary>

<details class="lang-ru">
<summary>По-русски</summary>

- Retain cycles в замыканиях, делегатах, `NotificationCenter`, Combine, `Task`.
  - **Answer:** цикл — это когда цепочка strong‑ссылок делает `refCount` никогда не 0, поэтому `deinit` не вызывается. Чаще всего: `self` удерживает объект/closure, а closure удерживает `self`. Лечение: разорвать strong‑звено (`weak`, `unowned`, отмена подписок, removeObserver, cancel Task).  
    Docs: `https://docs.swift.org/swift-book/documentation/the-swift-programming-language/automaticreferencecounting/`


</details>
<details class="lang-ru">
<summary>По-русски</summary>


</details>
<details class="lang-ru">
<summary>По-русски</summary>

- `weak` vs `unowned` vs `unowned(unsafe)`: когда что использовать и цена.
  - **Answer:**  
    - `weak`: optional, обнуляется при деаллокации объекта; безопаснее, есть overhead (проверка/индиirection через runtime).  
    - `unowned`: non-optional, предполагает что объект жив; если нет — crash. Хорошо когда жизненный цикл гарантирован (owner→child).  
    - `unowned(unsafe)`: без nil‑обнуления, ещё более опасно (dangling pointer). Использовать крайне редко.  
    Docs: `https://docs.swift.org/swift-book/documentation/the-swift-programming-language/automaticreferencecounting/`


</details>
<details class="lang-ru">
<summary>По-русски</summary>


</details>
<details class="lang-ru">
<summary>По-русски</summary>

- Side tables: что хранится отдельно от объекта (strong/unowned/weak counters).
  - **Answer:** слабые ссылки требуют доп. структуры, чтобы корректно обнуляться при деаллокации. Side table хранит данные для weak/unowned bookkeeping (счётчики/списки ссылок), и создаётся только когда нужно (не у каждого объекта “всегда”). Концептуально: weak‑ссылка не держит объект живым, но должна уметь стать `nil`.  
    Docs: `https://docs.swift.org/swift-book/documentation/the-swift-programming-language/automaticreferencecounting/`


</details>
<details class="lang-ru">
<summary>По-русски</summary>


</details>
<details class="lang-ru">
<summary>По-русски</summary>

- `autoreleasepool` в горячих циклах с Obj‑C объектами.
  - **Answer:** `autoreleasepool {}` принудительно дренит autoreleased объекты внутри scope вместо ожидания конца итерации runloop. Полезно в tight loops, когда создаётся много временных Obj‑C объектов (`UIImage`, `NSData`, bridging).  
    Docs: `https://developer.apple.com/documentation/swift/autoreleasepool(_:_:)/`


</details>
<details class="lang-ru">
<summary>По-русски</summary>


</details>
<details class="lang-ru">
<summary>По-русски</summary>

- Memory Graph и Allocations Instrument: ловить утечки и “фантомные” объекты.
  - **Answer:** Memory Graph показывает граф удержаний (кто держит кого), помогает быстро найти retain cycle. Allocations/Leaks показывают динамику аллокаций, удержание памяти и потенциальные утечки. Главное — понимать путь удержания, а не “просто очистить кеш”.  


</details>
<details class="lang-ru">
<summary>По-русски</summary>


</details>
<details class="lang-ru">
<summary>По-русски</summary>

- `MemoryLayout`: `size`, `stride`, `alignment`.
  - **Answer:** `size` — байты под значение; `alignment` — требование выравнивания; `stride` — шаг между элементами в contiguous storage (обычно `>= size` из-за padding).  
    Docs: `https://developer.apple.com/documentation/swift/memorylayout`

    Docs: `https://docs.swift.org/swift-book/documentation/the-swift-programming-language/classesandstructures/`


</details>


</details>

### Defer

<details class="lang-ru">
<summary>По-русски</summary>

<details class="lang-ru">
<summary>По-русски</summary>

- Внутренности `HeapObject` и weak references на C++ уровне.

</details>
<details class="lang-ru">
<summary>По-русски</summary>


</details>
<details class="lang-ru">
<summary>По-русски</summary>

- Подробности `swift_release/swift_retain` и компиляторные оптимизации.

</details>
<details class="lang-ru">
<summary>По-русски</summary>


</details>
<details class="lang-ru">
<summary>По-русски</summary>

- Memory Integrity Enforcement (Swift 6+) — пока концептуально.


</details>


</details>

## 📚 What to learn by level


### JUNIOR

<details class="lang-ru">
<summary>По-русски</summary>

- **Поймать retain cycle** через Memory Graph.
- **`[weak self]`** в closures (`UIView.animate`, `URLSession`, `DispatchQueue`).
- Делегаты как `weak var`.
- База: value (`struct`) vs reference (`class`).

</details>

### MIDDLE

<details class="lang-ru">
<summary>По-русски</summary>

- Side tables: зачем weak‑bookkeeping отдельно, как weak становится `nil`.
- `weak` vs `unowned` vs `unowned(unsafe)` + цена/риски.
- `autoreleasepool` с `UIImage/Data` в горячих циклах.
- Различать “утечку” и “abandoned memory” (память удержана, но больше не нужна).

</details>

### SENIOR

<details class="lang-ru">
<summary>По-русски</summary>

- Концептуально: заголовок объекта, refCount/weakRefCount.
- CoW через `isKnownUniquelyReferenced` (когда реально копируется).
- Осторожность с `@escaping`/обёртками, чтобы не тащить `self`.

</details>

## 🌟 Strategic (Senior+) — team practices


<details class="lang-ru">
<summary>По-русски</summary>

- Memory budget команды.
  - **Answer:** договориться о целевом среднем и пиковом memory footprint (по устройствам/OS). Закрепить измерение в CI через UI-тест + `XCTMemoryMetric` (регрессии ловятся раньше продакшена).  
    Docs: `https://developer.apple.com/documentation/xctest/xctmemorymetric`

- Plan для extensions (widgets/share extensions).
  - **Answer:** у extensions жёсткие лимиты памяти (порядка десятков MB), поэтому нужны стратегии: превью/даунскейл изображений, ограничение кеша, отказ от больших in-memory буферов, “стриминг”/чанки где возможно.  
    Docs (App extensions): `https://developer.apple.com/documentation/foundation/app_extension_support`

- Code review чек-лист по памяти.
  - **Answer:** минимальный набор проверок в каждом PR:
    1) `self` в closures → capture list (`[weak self]` где нужно)
    2) delegates → `weak`
    3) Combine → `store(in:)` + избегать `sink { self... }` без `[weak self]`
    4) Timer/DisplayLink → `invalidate()` (обычно в `deinit`/`viewWillDisappear`)
    5) NotificationCenter → токены/снятие наблюдателей (особенно block-based API)
    Docs: `https://docs.swift.org/swift-book/documentation/the-swift-programming-language/automaticreferencecounting/`

- Менторство: “почему 2 MB картинка ест 80 MB” + abandoned memory.

</details>

## 📚 Key terms (question → answer)


    Docs: `https://docs.swift.org/swift-book/documentation/the-swift-programming-language/automaticreferencecounting/`

<details class="lang-ru">
<summary>По-русски</summary>

- Strong.
  - **Answer:** strong‑ссылка удерживает объект. Когда strong refcount достигает 0, объект деаллоцируется (`deinit`).  
    Docs: `https://docs.swift.org/swift-book/documentation/the-swift-programming-language/automaticreferencecounting/`

- Weak.
  - **Answer:** weak не удерживает объект, всегда `Optional`, автоматически становится `nil` при деаллокации (через runtime bookkeeping). Цена — немного больше overhead, чем у strong.  
    Docs: `https://docs.swift.org/swift-book/documentation/the-swift-programming-language/automaticreferencecounting/`

- Unowned.
  - **Answer:** unowned не удерживает объект и не `Optional`. Предполагает, что объект будет жить дольше ссылки; иначе crash при доступе. Обычно быстрее/проще, чем weak, но опаснее.  
    Docs: `https://docs.swift.org/swift-book/documentation/the-swift-programming-language/automaticreferencecounting/`

- Side table.
  - **Answer:** дополнительная структура для weak/unowned bookkeeping (например список weak‑ссылок, счётчики). Создаётся лениво — только если объект участвует в weak‑сценариях.  

- Heap object header.
  - **Answer:** метаданные reference type в куче (`HeapObject`): inline-счётчики strong / unowned (safe), type metadata; при необходимости — указатель на side table. Для value type `MemoryLayout` класса показывает размер **ссылки**, не всего объекта.

- Capture list.
  - **Answer:** `{ [weak self, unowned vc] in ... }` явно задаёт семантику захвата; без списка reference types захватываются **strong** → риск retain cycle. Явный `[myClass]` копирует **значение** переменной (ссылку на объект), а не «ссылку на переменную».

- Retain cycle.
  - **Answer:** цикл сильных ссылок (2+ объекта или `self` ↔ closure), refcount не падает до 0 → `deinit` не вызывается. Лечится разрывом strong‑звена, capture list, weak delegate, отменой подписок.  
    Docs: `https://docs.swift.org/swift-book/documentation/the-swift-programming-language/automaticreferencecounting/`

- Abandoned memory.
  - **Answer:** память удержана (есть ссылки), но логически уже “никому не нужна”. Это не всегда leak в смысле “невозможно освободить”, но это проблема footprint. Лечится исправлением владения и жизненных циклов (кеши, singletons, глобальные держатели).  
    Docs (профилирование): `https://developer.apple.com/documentation/xcode/instruments`

- Autoreleasepool.
  - **Answer:** scope, в конце которого освобождаются autoreleased Obj‑C объекты. Полезно в горячих циклах при массовом создании Foundation/Obj‑C объектов.  
    Docs: `https://developer.apple.com/documentation/swift/autoreleasepool(_:_:)/`

- MemoryLayout.
  - **Answer:** `size` — размер значения, `alignment` — требование выравнивания, `stride` — шаг в массиве с учётом padding.  
    Docs: `https://developer.apple.com/documentation/swift/memorylayout`

- Copy-on-Write.
  - **Answer:** коллекции делают копию буфера при записи и только если storage не уникален (`!isKnownUniquelyReferenced`). Это объясняет “дёшево копировать, дорого мутировать shared”.  
    Docs: `https://developer.apple.com/documentation/swift/isknownuniquelyreferenced(_:)`

- EXC_BAD_ACCESS.
  - **Answer:** обращение к невалидной памяти (use-after-free, dangling pointer). Частый сценарий в Swift — `unowned` на уже деаллоцированный объект или небезопасная работа с raw pointers/bridging.  
    Docs (debugging): `https://developer.apple.com/documentation/xcode`

</details>

## 🏋️ Exercises (12) — expected outcomes


<details class="lang-ru">
<summary>По-русски</summary>

1) Таймер‑утечка (`Timer.scheduledTimer(target:self,...)`)
  - **Answer:** target‑API удерживает target. Фикс: block‑API + `[weak self]` или отдельный объект‑прокси (weak target). Проверить в Memory Graph, что VC деаллоцируется.  

</details>
    Docs: `https://developer.apple.com/documentation/foundation/timer`

2) `weak` vs `unowned`
<details class="lang-ru">
<summary>По-русски</summary>

  - **Answer:** `unowned` крашится при доступе после деаллокации; `weak` станет `nil`. Измерение через `XCTMetric` покажет, что weak обычно чуть дороже.  

</details>
    Docs: `https://docs.swift.org/swift-book/documentation/the-swift-programming-language/automaticreferencecounting/`

3) NotificationCenter (iOS 9+)
<details class="lang-ru">
<summary>По-русски</summary>

  - **Answer:** селекторные observers не текут (в современных iOS наблюдатели не удерживаются навсегда), но для block‑based `addObserver(forName:queue:using:)` нужно хранить токен и/или снимать наблюдение, иначе утечка через замыкание.  

</details>
    Docs: `https://developer.apple.com/documentation/foundation/notificationcenter`

4) `autoreleasepool` + 1000 `UIImage(contentsOfFile:)`
<details class="lang-ru">
<summary>По-русски</summary>

  - **Answer:** без `autoreleasepool` пик памяти значительно выше (объекты освобождаются позже); с `autoreleasepool` память стабилизируется по итерациям.  

</details>
    Docs: `https://developer.apple.com/documentation/swift/autoreleasepool(_:_:)/`

<details class="lang-ru">
<summary>По-русски</summary>

5) Closure capture list в `Task { ... }`
  - **Answer:** без `[weak self]` Task может удерживать self дольше ожидаемого. Фикс: `[weak self]` + early return, или архитектурно — отмена задач/скоупы. Проверить Memory Graph.  

</details>
    Docs: `https://docs.swift.org/swift-book/documentation/the-swift-programming-language/concurrency/`

<details class="lang-ru">
<summary>По-русски</summary>

6) Side tables: почему `weak` медленнее `strong`
  - **Answer:** weak требует runtime bookkeeping и проверок (обнуление, таблица). Сильная ссылка — прямое удержание без этих шагов.  

</details>
7) Combine cycle
<details class="lang-ru">
<summary>По-русски</summary>

  - **Answer:** `sink { self... }` + хранение `AnyCancellable` в self → цикл. Фикс: `[weak self]`, или разрывать цепочку (cancel/очистка cancellables).  

</details>
    Docs: `https://developer.apple.com/documentation/combine`

8) UIView retain cycle (parent/child)
<details class="lang-ru">
<summary>По-русски</summary>

  - **Answer:** делать `weak` у `superview/subviews` нельзя (UIKit управляет иерархией). Осознанно weak делают только обратные ссылки (например delegate/handler) — иначе ломается lifetime и отрисовка.  

</details>
    Docs: `https://developer.apple.com/documentation/uikit/uiview`

9) Memory Graph CLI
<details class="lang-ru">
<summary>По-русски</summary>

  - **Answer:** снять `.memgraph` и открыть в Xcode, найти путь удержания.  

</details>
    Docs: `https://developer.apple.com/documentation/xcode/instruments`

10) MemoryLayout (Bool/UInt8/Pair)
<details class="lang-ru">
<summary>По-русски</summary>

  - **Answer:** сравнить `size/stride/alignment`, увидеть padding.  

</details>
    Docs: `https://developer.apple.com/documentation/swift/memorylayout`

<details class="lang-ru">
<summary>По-русски</summary>

11) CoW вручную
  - **Answer:** wrapper со storage + `isKnownUniquelyReferenced` в mutating path; убедиться, что чтение не копирует, а мутация shared — копирует.  

</details>
    Docs: `https://developer.apple.com/documentation/swift/isknownuniquelyreferenced(_:)`

<details class="lang-ru">
<summary>По-русски</summary>

12) `weak self` в Task внутри actor/async
  - **Answer:** понять, что lifetime и захват в structured concurrency отличается от GCD: важно где хранится Task и кто его отменяет; `weak` может быть не тем инструментом, который решает архитектурную проблему (иногда нужна отмена/скоуп).  

</details>
    Docs: `https://docs.swift.org/swift-book/documentation/the-swift-programming-language/concurrency/`

---

## TL;DR


<details class="lang-ru">
<summary>По-русски</summary>

- Чем ближе память к CPU, тем она быстрее и меньше по объёму.
- Чем дальше от CPU, тем она медленнее, но дешевле и больше.
- Для iOS это напрямую влияет на лаги, энергопотребление и риск memory pressure.

</details>

## 1) CPU registers


<details class="lang-ru">
<summary>По-русски</summary>

- Самая быстрая память.
- Находится внутри CPU.
- Хранит данные, с которыми процессор работает прямо сейчас.

</details>

## 2) Cache memory (L1 / L2 / L3)


<details class="lang-ru">
<summary>По-русски</summary>

- Очень быстрая память рядом с процессором.
- Держит копии часто используемых данных из более медленных уровней.
- `L1` обычно самый быстрый и самый маленький, далее `L2`, `L3`.

</details>

## 3) RAM


<details class="lang-ru">
<summary>По-русски</summary>

- Основное рабочее хранилище приложения во время выполнения.
- Быстрая, но volatile: данные пропадают при выключении устройства.
- Здесь живут объекты, буферы, стеки потоков и т.д. во время работы программы.

</details>

## 4) Persistent storage (SSD / HDD)


<details class="lang-ru">
<summary>По-русски</summary>

- Долговременное хранение данных.
- Данные сохраняются после выключения питания.
- В современных устройствах в основном SSD, который быстрее классических HDD.

</details>

## 5) Virtual memory


<details class="lang-ru">
<summary>По-русски</summary>

- Механизм ОС, позволяющий использовать дисковое пространство как расширение RAM.
- Когда RAM перегружена, менее активные страницы могут быть перемещены в swap.
- Это полезно для выживаемости системы, но значительно медленнее работы в RAM.

</details>

## Why this matters to iOS developers


<details class="lang-ru">
<summary>По-русски</summary>

- Понимание иерархии памяти помогает объяснять лаги и деградацию перформанса.
- Большие аллокации и лишние копии данных повышают давление на RAM.
- При нехватке памяти система может агрессивно завершать процессы, включая приложение.

</details>

## Practical example (iOS)


<details class="lang-ru">
<summary>По-русски</summary>

- Если экран резко декодирует много больших изображений, вы нагружаете CPU, кэши и RAM одновременно.
- При росте RAM usage система начинает активнее “чистить” память и может завершить фоновые процессы.
- Если данных слишком много и начинается активный paging, появляются фризы и скачки времени отклика.

</details>

## Practical rules


<details class="lang-ru">
<summary>По-русски</summary>

- Держать горячие данные компактными и локальными (меньше cache misses).
- Избегать лишних копий больших структур в горячем пути.
- Делать ленивую загрузку и paged-подход для тяжёлых экранов.

</details>

## Terms often asked in interviews


<details class="lang-ru">
<summary>По-русски</summary>

- `Latency` доступа к памяти — сколько времени нужно, чтобы получить данные.
- `Bandwidth` памяти — сколько данных можно передать за единицу времени.
- `Memory pressure` — состояние, когда системе не хватает доступной RAM.

</details>

---## Interview Q&A (Knowledge cards)


Interview Q&A below.

<!-- knowledge-cards-canonical:start -->

### Q3
- **Question (EN):** Does ARC work at compile time or at runtime?

- **Answer (EN):** Both stages. At **compile time** the compiler inserts and may optimize **retain/release** where lifetimes and scope dictate. At **runtime** those updates change the strong refcount; at zero the object is deallocated.

<details class="lang-ru">
<summary>По-русски</summary>

<details class="lang-ru">
<summary>По-русски</summary>

<details class="lang-ru">
<summary>По-русски</summary>

- **Устная заготовка (EN):**

</details>
</details>
</details>
    2. At compile time the compiler inserts retain/release where lifetimes and scope dictate — assignments, entering/leaving scope, call arguments.
    3. At runtime those updates change the strong reference count; at zero the object is deallocated.

<details class="lang-ru">
<summary>По-русски</summary>

<details class="lang-ru">
<summary>По-русски</summary>

<details class="lang-ru">
<summary>По-русски</summary>

- **Follow-up:** где появляются скрытые **retain** / **release** в **closure capture list** (списке захвата замыкания)?

</details>
</details>
</details>
<details class="lang-ru">
<summary>По-русски</summary>

<details class="lang-ru">
<summary>По-русски</summary>

<details class="lang-ru">
<summary>По-русски</summary>

- **Follow-up answer:** при захвате **reference types** (ссылочных типов) по умолчанию **strong capture** (сильный захват): компилятор генерирует **retain** при формировании замыкания и парный **release** при его освобождении — не пишется руками, но эквивалентно удержанию каждого захваченного объекта. Типично: захват **`self`** или свойств в списке, вложенные замыкания, передача **escaping closure** (замыкания, уходящего из **scope**). Отсюда цикл **`self` → closure → `self`**, если не ослабить захват.

</details>
</details>
</details>

<details class="lang-ru">
<summary>По-русски</summary>

- **Question (RU):** ARC работает на этапе компиляции или выполнения?

- **Answer (RU):** На **обоих**. **Compile-time:** компилятор вставляет и может оптимизировать **retain/release** там, где из времени жизни ссылок и **scope** следуют точки учёта — присваивания, вход/выход из scope, аргументы вызовов, capture list. **Runtime:** эти вызовы меняют **strong reference count**; при **`0`** вызывается **`deinit`** и память освобождается.

<details class="lang-ru">
<summary>По-русски</summary>

<details class="lang-ru">
<summary>По-русски</summary>

<details class="lang-ru">
<summary>По-русски</summary>

- **Устная заготовка (RU):**

</details>
</details>
</details>
</details>
<details class="lang-ru">
<summary>По-русски</summary>

    2. Compile-time: компилятор вставляет и может оптимизировать retain/release в точках, которые следуют из времени жизни ссылок и scope — присваивания, вход/выход из scope, аргументы вызовов.
    3. Runtime: эти вызовы меняют strong reference count; при нуле объект деаллоцируется (`deinit`).

</details>

### Q4
- **Question (EN):** What is the difference between `weak` and `unowned` references?

- **Answer (EN):** `weak` is optional and becomes `nil` after deallocation; it does not keep the referenced object alive like a strong reference. `unowned` is non-optional and assumes the referenced instance **outlives** this reference (lifetime guarantee); breaking that assumption is a dangling reference / crash risk.

<details class="lang-ru">
<summary>По-русски</summary>

<details class="lang-ru">
<summary>По-русски</summary>

<details class="lang-ru">
<summary>По-русски</summary>

- **Устная заготовка (EN):**

</details>
</details>
</details>
    1. `weak` is optional and becomes `nil`; it doesn't extend the object's lifetime.
    2. `unowned` is non-optional and needs a guarantee the referenced object outlives this reference.

<details class="lang-ru">
<summary>По-русски</summary>

<details class="lang-ru">
<summary>По-русски</summary>

<details class="lang-ru">
<summary>По-русски</summary>

- **Follow-up:** **production**-кейс, где **`unowned`** безопасен.

</details>
</details>
</details>
<details class="lang-ru">
<summary>По-русски</summary>

<details class="lang-ru">
<summary>По-русски</summary>

<details class="lang-ru">
<summary>По-русски</summary>

- **Follow-up answer:** когда **lifetime** (время жизни) зависимого однозначно короче владельца ссылки: например child → **unowned** parent и parent гарантированно переживает child; обратная ссылка на delegate/storage, где владелец **всегда** живёт дольше замыкания; иногда `[unowned self]` в **синхронном** коде, где замыкание не может выполниться после деаллокации `self`. Небезопасно при async/отложенных completion без жёсткой модели владения — там по умолчанию `weak`.

</details>
</details>
</details>

<details class="lang-ru">
<summary>По-русски</summary>

- **Question (RU):** `weak` vs `unowned`?

- **Answer (RU):** `weak` — optional, после деаллокации объекта становится `nil`; не продлевает lifetime объекта как strong reference. `unowned` — non-optional; предполагает lifetime guarantee (гарантия времени жизни): объект переживёт эту ссылку; иначе риск dangling / crash.

<details class="lang-ru">
<summary>По-русски</summary>

<details class="lang-ru">
<summary>По-русски</summary>

<details class="lang-ru">
<summary>По-русски</summary>

- **Устная заготовка (RU):**

</details>
</details>
</details>
</details>
<details class="lang-ru">
<summary>По-русски</summary>

    1. `weak` — optional, может стать `nil`; не удерживает объект как strong.
    2. `unowned` — non-optional; нужна гарантия, что объект переживёт использование ссылки.

</details>

### Q5
- **Question (EN):** How do you catch retain cycles in closures?

- **Answer (EN):** Classic pattern is **self → closure → self** (the object holds the closure; the closure strongly captures `self`). Break it with a **capture list** — often `[weak self]` or `[unowned self]` plus optional binding — or avoid a strong `self` capture; alternatively redesign ownership.

<details class="lang-ru">
<summary>По-русски</summary>

<details class="lang-ru">
<summary>По-русски</summary>

<details class="lang-ru">
<summary>По-русски</summary>

- **Устная заготовка (EN):**

</details>
</details>
</details>
    1. Pattern: self → closure → self — strong capture.
    2. Fix: capture list (`[weak self]` / `[unowned self]`) or redesign ownership.

<details class="lang-ru">
<summary>По-русски</summary>

<details class="lang-ru">
<summary>По-русски</summary>

<details class="lang-ru">
<summary>По-русски</summary>

- **Follow-up:** когда **`weak self`** даёт **silent bug** (тихий баг)?

</details>
</details>
</details>
<details class="lang-ru">
<summary>По-русски</summary>

<details class="lang-ru">
<summary>По-русски</summary>

<details class="lang-ru">
<summary>По-русски</summary>

- **Follow-up answer:** когда **`self`** уже **`nil`**, а код после **`guard let self`** или без него **молча не делает нужную работу**: **completion** после **dismiss** экрана, отложенный **UI update**, «пропавший» **side effect** без лога. Ещё: забытый **`guard`** при опционале, или ветка «ничего не делаем» маскирует ошибку состояния. Лечится явным **`guard let self else { … }`** (log / assertion / user-visible fail), осмысленным **fallback** и тестами на отмену / **deallocation**.

</details>
</details>
</details>

<details class="lang-ru">
<summary>По-русски</summary>

- **Question (RU):** как ловишь **retain cycle** (цикл удержания) в **closure** (замыкании)?

- **Answer (RU):** типичный цикл `self -> closure -> self` (object держит closure, closure держит `self` по strong capture). Разрыв: capture list (список захвата) — часто `[weak self]` / `[unowned self]` + `guard`, либо явно не захватывать `self` сильно; иначе перестройка ownership graph (граф владения).

<details class="lang-ru">
<summary>По-русски</summary>

<details class="lang-ru">
<summary>По-русски</summary>

<details class="lang-ru">
<summary>По-русски</summary>

- **Устная заготовка (RU):**

</details>
</details>
</details>
</details>
<details class="lang-ru">
<summary>По-русски</summary>

    1. Цикл: объект держит замыкание, замыкание держит `self`.
    2. Лечение: capture list — чаще `[weak self]`; или перестроить владение.

</details>

### Q42
- **Question (EN):** ARC in brief—roles of `strong`, `weak`, and `unowned`?

- **Answer (EN):** Strong refs keep instances alive; `weak` avoids cycles and zeroes out; `unowned` is non-optional and crashes if the instance dies early.

<details class="lang-ru">
<summary>По-русски</summary>

<details class="lang-ru">
<summary>По-русски</summary>

<details class="lang-ru">
<summary>По-русски</summary>

- **Устная заготовка (EN):** Count strong refs; prefer `weak` in closures unless lifetime is proven.

</details>
</details>
</details>
<details class="lang-ru">
<summary>По-русски</summary>

<details class="lang-ru">
<summary>По-русски</summary>

<details class="lang-ru">
<summary>По-русски</summary>

- **Follow-up:** в чём ключевая разница weak и unowned в runtime behavior (поведении во время выполнения)?

</details>
</details>
</details>
<details class="lang-ru">
<summary>По-русски</summary>

<details class="lang-ru">
<summary>По-русски</summary>

<details class="lang-ru">
<summary>По-русски</summary>

- **Follow-up answer:** `weak` может стать `nil`; `unowned` не проверяет — доступ после деаллокации даёт crash (undefined поведение для unsafe варианта).

</details>
</details>
</details>

<details class="lang-ru">
<summary>По-русски</summary>

- **Question (RU):** как в двух словах устроен ARC и роли `strong` / `weak` / `unowned`?

- **Answer (RU):** Для reference types компилятор вставляет **retain/release**; пока есть **strong**-ссылка — объект живёт; при нуле strong — **`deinit`**. **`weak`** не удерживает, после освобождения — `nil` (через side table). **`unowned`** не удерживает, non-optional; безопасен только при гарантии lifetime, иначе crash / «зомби» в Deinited.

<details class="lang-ru">
<summary>По-русски</summary>

<details class="lang-ru">
<summary>По-русски</summary>

<details class="lang-ru">
<summary>По-русски</summary>

- **Устная заготовка (RU):** strong держит; weak — цикл и Optional; unowned — только если «всегда живёт дольше».

</details>
</details>
</details>
</details>

<details class="lang-ru">
<summary>По-русски</summary>

- **Доп. информация:** цикл обычно замыкание держит `self` сильно — лечение `[weak self]`.

</details>

### Q43
- **Question (EN):** iOS memory management—ARC, retain cycles, and `strong` / `weak` / `unowned`?

- **Answer (EN):** ARC counts strong references to class instances; at zero strong refs, `deinit` runs. A retain cycle is a **cycle of strong references** so refcounts never reach zero. Break cycles with `weak` (optional, zeroes out) or `unowned` (non-optional, needs lifetime guarantees), capture lists, or ownership redesign.

<details class="lang-ru">
<summary>По-русски</summary>

- **Устный канон (опросник п.20 / H20, drill):** «**ARC** — **автоматический подсчёт strong**; **0 strong → deinit**. **Retain cycle** — **цикл strong-ссылок** (часто два объекта друг на друга или `self`↔closure). Лечение — **`weak` / `unowned`**, **capture list**, **слабый delegate**.»

</details>
<details class="lang-ru">
<summary>По-русски</summary>

- **Question (RU):** управление памятью в iOS: **ARC**, **retain cycle**, роль **`strong` / `weak` / `unowned`**?

- **Answer (RU):** Зацепка: для **reference types** (`class`, замыкания с захватом ref) Swift использует **ARC** — компилятор вставляет **retain/release** (или эквивалент) так, чтобы **сильные** ссылки удерживали объект **живым**; когда счётчик **strong** падает в **ноль**, вызывается **`deinit`** и память освобождается (**не** tracing-GC в стиле Java).

    **Strong:** каждая новая **strong**-ссылка на экземпляр **увеличивает** «удержание»; при выходе ссылки из области видимости / присваивании `nil` — **уменьшает**. (Детали ABI — runtime; на собесе достаточно модели **«strong держит объект»**.)

    **Retain cycle (цикл удержания):** в графе владения есть **замкнутый контур** из **strong**-ссылок, поэтому счётчики **никогда не обнуляются** — утечка памяти и отсутствие `deinit`. Частый частный случай — **два** объекта с **mutual strong** (`A` держит `B`, `B` держит `A`), но то же самое — **цепочка** `A→B→C→A` или **`self` → property с closure → strong capture `self`**.

    **Разрыв цикла:** **`weak`** — не участвует в strong-удержании объекта (после деаллокации — `nil`); **`unowned`** — не удерживает, но **non-optional**; безопасен только при **доказуемом** порядке lifetime. Делегаты — **`weak var delegate`**; замыкания — **`[weak self]`** / **`[unowned self]`** (см. **Q4**, **Q5** в этом файле).

<details class="lang-ru">
<summary>По-русски</summary>

<details class="lang-ru">
<summary>По-русски</summary>

<details class="lang-ru">
<summary>По-русски</summary>

- **Follow-up (RU):** `weak` влияет на **side table**?

</details>
</details>
</details>
<details class="lang-ru">
<summary>По-русски</summary>

<details class="lang-ru">
<summary>По-русски</summary>

<details class="lang-ru">
<summary>По-русски</summary>

- **Follow-up answer (RU):** да: **опциональный** `weak` после освобождения объекта обнуляется через механизм **side table** / runtime (детали — углубление; на Middle достаточно «не удерживает + `nil`»).

</details>
</details>
</details>
</details>

<details class="lang-ru">
<summary>По-русски</summary>

- **Доп. информация:** [Habr H20](https://habr.com/en/articles/726388/); [consolidated-interview-questionnaire.md](../../X.%20Карьера%20и%20софт-скилы/38%20Подготовка%20к%20собеседованиям/notes/resources/consolidated-interview-questionnaire.md) п.20; см. **Q42** (база ARC), **Q4**–**Q5** (weak/unowned, closures); [VI/24 Debug, LLDB, Instruments, Memory Graph](../../VI.%20Качество/24%20Debug%2C%20LLDB%2C%20Instruments%2C%20Memory%20Graph/Debug-LLDB-Instruments-Memory-Graph.md).

</details>

### Q44
- **Question (EN):** What is a retain cycle and how do you fix it?

- **Answer (EN):** A cycle of strong references prevents deallocation; break with `weak`/`unowned`, capture lists, weak delegates, cancel tasks/subscriptions.

<details class="lang-ru">
<summary>По-русски</summary>

- **Устный канон (опросник п.41 / J01, drill):** «**Retain cycle** — **strong кольцо**; ломаем **`weak`/`unowned`**, **delegate weak**, **capture list**, отмена подписок.» См. **Q43**, **Q5** в этом файле.

</details>
<details class="lang-ru">
<summary>По-русски</summary>

- **Question (RU):** **п.41 / J01** — **retain cycle**: что это и как **исправить**?

- **Answer (RU):** **Цикл strong-ссылок**: объекты держат друг друга (или `self` держит closure, closure держит `self`) → счётчики **не доходят до нуля** → **утечка**, **`deinit` не зовётся**. **Лечение:** **`weak`** / **`unowned`** в capture list и у **delegate**, разорвать цепочку владения, **`[weak self]`** в completion, отмена **`Task`** / подписок **Combine**, снятие **NotificationCenter** observer. Диагностика: **Memory Graph**, **Instruments Leaks**.

<details class="lang-ru">
<summary>По-русски</summary>

<details class="lang-ru">
<summary>По-русски</summary>

<details class="lang-ru">
<summary>По-русски</summary>

- **Follow-up (RU):** `unowned` когда безопасен?

</details>
</details>
</details>
<details class="lang-ru">
<summary>По-русски</summary>

<details class="lang-ru">
<summary>По-русски</summary>

<details class="lang-ru">
<summary>По-русски</summary>

- **Follow-up answer (RU):** когда **доказуемо** «другой живёт не дольше» (редко); по умолчанию **`weak` + `guard let self`**.

</details>
</details>
</details>
</details>

<details class="lang-ru">
<summary>По-русски</summary>

- **Доп. информация:** [consolidated-interview-questionnaire.md](../../X.%20Карьера%20и%20софт-скилы/38%20Подготовка%20к%20собеседованиям/notes/resources/consolidated-interview-questionnaire.md) п.41; **VI/24** Memory Graph.

</details>

### Q45
- **Question (EN):** ARC vs MRC?

- **Answer (EN):** ARC is compiler-managed retain/release; MRC required manual retain/release in Obj-C.

<details class="lang-ru">
<summary>По-русски</summary>

- **Устный канон (опросник п.42 / J02, drill):** «**ARC** — **авто** retain/release; **MRC** — **ручной** Obj-C прошлого.» См. **Q42**–**Q43**.

</details>
<details class="lang-ru">
<summary>По-русски</summary>

- **Question (RU):** **п.42 / J02** — **ARC** и чем отличается от **MRC**?

- **Answer (RU):** **ARC** (Automatic Reference Counting) — компилятор **автоматически** вставляет учёт **strong**-ссылок; при нуле — **`deinit`**. **MRC** (Manual Retain Release, Objective-C) — разработчик явно вызывал **`retain`/`release`/`autorelease`**; ошибки → утечки или **over-release** / crash. Swift для `class` — **ARC**; Obj-C legacy могли знать MRC.

<details class="lang-ru">
<summary>По-русски</summary>

<details class="lang-ru">
<summary>По-русски</summary>

<details class="lang-ru">
<summary>По-русски</summary>

- **Follow-up (RU):** есть ли GC в Swift для классов?

</details>
</details>
</details>
<details class="lang-ru">
<summary>По-русски</summary>

<details class="lang-ru">
<summary>По-русски</summary>

<details class="lang-ru">
<summary>По-русски</summary>

- **Follow-up answer (RU):** **нет** tracing-GC как в Java для типичных `class`; **ARC** + **CoW** для value-контейнеров.

</details>
</details>
</details>
</details>

<details class="lang-ru">
<summary>По-русски</summary>

- **Доп. информация:** [consolidated-interview-questionnaire.md](../../X.%20Карьера%20и%20софт-скилы/38%20Подготовка%20к%20собеседованиям/notes/resources/consolidated-interview-questionnaire.md) п.42.

</details>

### Q46
- **Question (EN):** Stack vs heap?

- **Answer (EN):** Stack holds per-call frames; heap holds longer-lived reference types and dynamic buffers—ARC manages class lifetime.

<details class="lang-ru">
<summary>По-русски</summary>

- **Устный канон (опросник п.43 / J03, drill):** «**Стек** — **кадр вызова**, быстро и локально; **куча** — **долго и через указатель**; **`class`** — куча; **`struct`** — не «всегда только стек» из-за CoW.»

</details>
<details class="lang-ru">
<summary>По-русски</summary>

- **Question (RU):** **п.43 / J03** — **стек** vs **куча** (stack vs heap)?

- **Answer (RU):** **Стек** — LIFO-область кадров вызовов: локальные переменные небольшого фиксированного размера, адреса «рядом», освобождение при выходе из функции **автоматически**. **Куча** — динамическая область для объектов **дольше** кадра и крупных аллокаций; жизнь управляется **ARC**/аллокатором; доступ через **указатель**. **`class`** и замыкания с захватом ref — в **куче**; **`struct`** значение часто на стеке, но **буферы** (`Array`) могут быть в **куче** (**CoW**).

<details class="lang-ru">
<summary>По-русски</summary>

<details class="lang-ru">
<summary>По-русски</summary>

<details class="lang-ru">
<summary>По-русски</summary>

- **Follow-up (RU):** где переполнить стек?

</details>
</details>
</details>
<details class="lang-ru">
<summary>По-русски</summary>

<details class="lang-ru">
<summary>По-русски</summary>

<details class="lang-ru">
<summary>По-русски</summary>

- **Follow-up answer (RU):** **глубокая рекурсия**, огромные **value** на стеке; для больших данных — **куча** / **indirection**.

</details>
</details>
</details>
</details>

<details class="lang-ru">
<summary>По-русски</summary>

- **Доп. информация:** [consolidated-interview-questionnaire.md](../../X.%20Карьера%20и%20софт-скилы/38%20Подготовка%20к%20собеседованиям/notes/resources/consolidated-interview-questionnaire.md) п.43; **I/01 Type-system** (value vs reference).

</details>

### Q47
- **Question (EN):** Objective-C `weak` vs `assign`—what do they do?

- **Answer (EN):** `weak` does not retain; zeroes to `nil` after deallocation—objects only. `assign` stores the address without ownership—safe for primitives, dangling for objects after dealloc. Use `weak` for delegates.

<details class="lang-ru">
<summary>По-русски</summary>

<details class="lang-ru">
<summary>По-русски</summary>

<details class="lang-ru">
<summary>По-русски</summary>

- **Устная заготовка (EN):**

</details>
</details>
</details>
    1. `weak` — no retain, zeroing to `nil` for objects.
    2. `assign` — raw address; primitives only; objects → dangling.
    3. Delegates use `weak`.


<details class="lang-ru">
<summary>По-русски</summary>

- **Question (RU):** Что делает **`weak`** в Objective-C (`@property`)? Чем отличается от **`assign`**?

- **Answer (RU):** **`weak`** (только для **объектов**): не увеличивает **retain count**; не создаёт **retain cycle**; после dealloc ссылки — **zeroing** (**автоматически `nil`**). **`assign`**: копирует только **адрес**; после удаления объекта остаётся **dangling pointer**; типично для **примитивов** (`int`, `BOOL`, `CGFloat`). Делегаты и обратные ссылки на владельца — **`weak`**, не `assign`.

<details class="lang-ru">
<summary>По-русски</summary>

<details class="lang-ru">
<summary>По-русски</summary>

<details class="lang-ru">
<summary>По-русски</summary>

- **Устная заготовка (RU):**

</details>
</details>
</details>
<details class="lang-ru">
<summary>По-русски</summary>

    1. `weak` — не держит объект, после dealloc → `nil`; только reference types.
    2. `assign` — адрес без retain; для `int`/`BOOL`; для объектов — crash при use-after-free.
    3. Delegate → `weak`, не `assign`.

</details>
<details class="lang-ru">
<summary>По-русски</summary>

<details class="lang-ru">
<summary>По-русски</summary>

<details class="lang-ru">
<summary>По-русски</summary>

- **Follow-up (RU):** почему не `assign` у delegate?

</details>
</details>
</details>
<details class="lang-ru">
<summary>По-русски</summary>

<details class="lang-ru">
<summary>По-русски</summary>

<details class="lang-ru">
<summary>По-русски</summary>

- **Follow-up answer (RU):** после dealloc владельца delegate-указатель указывает в невалидную память → **crash** при обращении; `weak` обнуляется безопасно.

</details>
</details>
</details>
</details>

<details class="lang-ru">
<summary>По-русски</summary>

- **Доп. информация:** Swift `weak` vs `unowned` — **Q4**; [ARC (Swift Book)](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/automaticreferencecounting/); flashcards — [Value-Types-Actors-Concurrency-Quiz §7](../concurrency/notes/Value-Types-Actors-Concurrency-Quiz.md#7-быстрые-ответы-flashcards)

</details>
<!-- knowledge-cards-canonical:end -->
