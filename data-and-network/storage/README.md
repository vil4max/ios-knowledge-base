# Storage & Persistence

## 🎯 Focus vs Defer

### Focus


### Defer


## 🏋️ Exercises

- Каждое упражнение: **задача** → **ожидаемый результат** → при необходимости **ссылка** на документацию.

## Артефакты

- Notes: `notes/`
- Exercises: `exercises/`
- Assets: `assets/`
- Playgrounds: `playgrounds/`

---

## Карточки знаний (Q&A)

Ниже — Q&A по теме.

<!-- knowledge-cards-canonical:start -->

### Q33
- **Question (RU):** Core Data concurrency basics (база многопоточности Core Data)?
- **Question (EN):** Core Data concurrency basics?
- **Вводные данные:** углубление по стеку и CloudKit — в роадмапе `storage/Data-Storage-Persistence.md` и playground.

- **Answer (RU):** Зацепка на интервью: **`NSManagedObject` не передаём между потоками** — он живёт внутри конкретного **`NSManagedObjectContext`**; контекст сериализует доступ на своей очереди, а объект держит связь с графом и несохранёнными изменениями — это не thread-safe тип для произвольного использования.

    `NSManagedObjectContext` привязан к очереди (`main` или `privateQueueConcurrencyType`): любая работа с объектами этого контекста — только через `perform` / `performAndWait` на его очереди (или с main context с главного потока). Между контекстами и потоками передают **`NSManagedObjectID`**, на целевом контексте — `object(with:)` / `existingObject(with:)` внутри `perform` этого контекста.

    Иерархия контекстов: часто `main` для UI и child `private` для фоновой записи; `save` ребёнка → merge в родителя при правильных политиках (`automaticallyMergesChangesFromParent`). Конфликты при сохранении решает `mergePolicy` (на собесе: назвать и не смешивать неосторожно несколько писателей без стратегии).

    `NSPersistentCloudKitContainer` добавляет синхронизацию и дополнительные точки merge относительно «локального» стека.

- **Answer (EN):** Opening line: never treat `NSManagedObject` as thread-safe—it’s tied to its `NSManagedObjectContext`, which owns pending changes and coordinates faults.

    Treat each context as queue-bound: use `perform`/`performAndWait`. Pass `NSManagedObjectID` across boundaries and materialize with `object(with:)`/`existingObject(with:)` inside the destination context’s `perform`. Use parent/child contexts and merge policies deliberately; CloudKit stacks add sync-specific merging.

- **Устная заготовка (RU):** не таскаем `NSManagedObject` между потоками — только `objectID`; контекст к очереди, всё через `perform`; child context + merge; CloudKit отдельно.

- **Follow-up:** merge conflict strategy (стратегия слияния конфликтов) в offline flow (офлайн-потоке)?
- **Follow-up answer:** заранее политика на сущность: server-wins / client-wins / полевая склейка; для офлайна часто версия записи + показ конфликта пользователю. Технически — merge при сохранении parent, либо отдельный слой «conflict» в модели до следующего push на сервер.

- **Доп. информация:** `perform` не блокирует UI; `performAndWait` на main из фона — классический deadlock риск. Тесты: in-memory store + два контекста.


<!-- knowledge-cards-canonical:end -->
