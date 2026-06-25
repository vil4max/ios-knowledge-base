#!/usr/bin/env python3
"""Replace RU placeholder in 30-sec sections with translations."""

from __future__ import annotations

import re
from pathlib import Path

KB = Path(__file__).resolve().parents[1]

PLACEHOLDER = "_(Русский перевод — добавить.)_"

TRANSLATIONS: dict[str, str] = {
    "fundamentals/development-principles/README.md": (
        "Принципы разработки — ориентиры для решений, а не догма. Они помогают держать код читаемым, тестируемым и гибким. На собесе редко проверяют расшифровку аббревиатур — важнее **обосновать trade-off**: когда выносить общую логику (DRY), когда не плодить слои (YAGNI, KISS, Occam), когда проектировать до кода (BDUF), как SOLID снижает связность в Swift (протоколы, SRP), когда оптимизировать только после замеров (APO). Middle+ объясняет **почему** решение достаточно простое, а не только «следую SOLID»."
    ),
    "fundamentals/git/README.md": (
        "Git — ежедневный слой workflow iOS-команды: feature-ветки, rebase, pull request, code review. На собесе важны merge vs rebase, разрешение конфликтов, bisect, cherry-pick и то, как не ломать историю при force-push."
    ),
    "fundamentals/cli/README.md": (
        "Терминал автоматизирует iOS-работу вне Xcode: сборка и тесты через `xcodebuild`, симулятор через `xcrun simctl`, зависимости, скрипты CI. Senior уверенно комбинирует CLI с GUI."
    ),
    "fundamentals/computer-science/README.md": (
        "Фундамент CS объясняет, *почему* Swift и iOS ведут себя так: память, сложность алгоритмов, структуры данных, процессы и потоки. Это база для ARC, concurrency и system design."
    ),
    "fundamentals/os-and-networks/README.md": (
        "ОС и сети объясняют жизнь iOS-приложения в sandbox: процессы, потоки, TCP/UDP, DNS, TLS. Нужно для networking, background modes и отладки «зависаний» и таймаутов."
    ),
    "swift/metaprogramming/README.md": (
        "**Metaprogramming** — код, который анализирует или генерирует другой код. В топике — runtime: `Mirror` и `@dynamicMemberLookup`. Compile-time (макросы, result builders) — отдельная ось. Swift ограничивает рефлексию ради производительности и type safety."
    ),
    "algorithms/structures/README.md": (
        "На мобильных собесах всё ещё спрашивают **массивы, hash map, set, stack, queue, деревья, графы** и **Big-O**. Редко пишут red-black tree, но нужно понимать lookup vs insert и когда уместны `Dictionary`/`Set`/`Array` в Swift."
    ),
    "architecture/modularization/README.md": (
        "**Модульность** делит приложение на **SPM-пакеты** с явными границами `import`: Features, Services, Core. Цель — изоляция, параллельная разработка, тестируемость и контроль зависимостей."
    ),
    "architecture/navigation/README.md": (
        "Навигация — **кто владеет стеком** и **как собираются экраны**. UIKit: `UINavigationController`, coordinators. SwiftUI: `NavigationStack`, `navigationDestination`. Deep links и state restoration — часть senior-ответа."
    ),
    "data-and-network/caching-offline-first/README.md": (
        "**Кэширование** снижает latency и трафик: HTTP cache (`URLCache`), in-memory, disk, image cache. **Offline-first** ставит локальные данные в центр UX с синхронизацией и конфликтами."
    ),
    "data-and-network/storage/README.md": (
        "Персистентность на iOS: **UserDefaults**, **Keychain**, **файлы**, **SQLite** (через GRDB/Core Data/SwiftData). Выбор слоя зависит от чувствительности, объёма, запросов и миграций."
    ),
    "devops/app-store/README.md": (
        "**TestFlight** раздаёт подписанные сборки internal/external тестерам. **App Store Connect** — метаданные, ревью, phased release. Senior знает provisioning, сертификаты и типичные reject reasons."
    ),
    "devops/ci-cd/README.md": (
        "**CI/CD** для iOS: **build + test + archive** на каждое изменение. **Xcode Cloud**, GitHub Actions, Fastlane — выбор по команде. Test Plans, кэш DerivedData, артефакты."
    ),
    "devops/monitoring/README.md": (
        "Мониторинг продакшена: **краши**, **метрики**, **логи**, **ANR/hangs**. Crashlytics, MetricKit, os_log. Связь с воспроизведением и приоритизацией фиксов."
    ),
    "ios-sdk/animations/README.md": (
        "Анимации iOS: **UIKit view animations**, **UIViewPropertyAnimator**, **Core Animation** (layers), **SwiftUI** `withAnimation`. Важны duration, curve, interruptibility и производительность (off main, не анимировать тяжёлый layout)."
    ),
    "ios-sdk/auto-layout/README.md": (
        "**Auto Layout** — constraint-based движок: отношения между view, intrinsic size, priority, ambiguity. `UIStackView`, anchors, SwiftUI layout — разные API, одна идея."
    ),
    "ios-sdk/collection-views/README.md": (
        "**UICollectionView** — сетка или кастомный layout переиспользуемых ячеек. **`UICollectionViewDiffableDataSource`** упрощает обновления. Performance: prefetch, reuse, compositional layout."
    ),
    "ios-sdk/core-bluetooth/README.md": (
        "**BLE** — не «кабель», а **GATT-диалог**: Central сканирует, подключается к Peripheral, читает/пишет характеристики. Background, pairing, throughput — типичные вопросы."
    ),
    "ios-sdk/format-style/README.md": (
        "`FormatStyle` — Swift-способ форматировать Foundation-типы локализованно: даты, числа, `Measurement`. Предпочтительнее `DateFormatter`/`NumberFormatter` в новом коде."
    ),
    "ios-sdk/graphics/README.md": (
        "**Core Graphics** (`CGContext`, paths) — immediate-mode 2D. **Metal** — GPU. SwiftUI рисует поверх обоих. Знать когда CPU draw vs GPU shader."
    ),
    "ios-sdk/swiftui/README.md": (
        "SwiftUI — **декларативный UI**: view как значения, state перерисовывает `body`. `@State`, `@Binding`, `@Observable`, `NavigationStack`, lifecycle и performance (identity, лишние body)."
    ),
    "ios-sdk/uikit/README.md": (
        "UIKit — **императивный** UI: иерархия **UIView**, **UIViewController**, lifecycle, delegates, Auto Layout. Всё ещё основа многих приложений и bridge для SwiftUI."
    ),
    "quality/accessibility/README.md": (
        "**Accessibility**: VoiceOver, Dynamic Type, Reduce Motion, контраст, hit targets. `accessibilityLabel`, traits, группировка. HIG и тестирование с VoiceOver."
    ),
    "quality/debug/README.md": (
        "**Отладка** на iOS — LLDB, breakpoints, View Hierarchy, Memory Graph, Instruments. Symbolication, zombie objects, concurrency breakpoints в Swift 6."
    ),
    "quality/performance/README.md": (
        "**Производительность** начинается с **замеров**: Time Profiler, Hangs, Allocations, SwiftUI body cost. Оптимизация только подтверждённых bottleneck (APO)."
    ),
    "quality/security/README.md": (
        "Безопасность iOS: **Keychain** для секретов, **ATS**, jailbreak detection (осторожно), certificate pinning, privacy manifests, минимизация PII в логах."
    ),
    "system-design/analytics/README.md": (
        "Мобильная **аналитика** — **таксономия событий**: что логировать, sampling, privacy, связь с remote config и A/B. Client schema vs server pipeline."
    ),
    "system-design/bdui/README.md": (
        "**BDUI**: сервер отдаёт описание экрана (JSON/protobuf); клиент рендерит компонентами. Trade-off: гибкость релизов vs сложность кэша, версионирования и fallback."
    ),
    "system-design/deep-links/README.md": (
        "**Deep links** ведут на конкретный экран: **Universal Links**, custom URL schemes, deferred deep links. Cold start, state restoration, attribution."
    ),
    "system-design/feature-flags/README.md": (
        "**Feature flags** и **remote config** отделяют релиз от включения фичи. Kill switch, gradual rollout, type-safe resolver на клиенте."
    ),
    "system-design/mobile/README.md": (
        "Mobile system design на собесе — **сеньорность**: сущности, API, кэш, offline, push, observability, границы модулей. ~45 мин: requirements → graph → read/write → trade-offs."
    ),
    "system-design/offline-first/README.md": (
        "**Offline-first**: локальное хранилище — source of truth; sync в фоне; UX при stale data; conflict resolution."
    ),
    "system-design/push-notifications/README.md": (
        "Push через **APNs**: сервер → Apple → устройство. Payload, silent push, notification service extension, permission, delivery guarantees (нет 100%)."
    ),
    "system-design/scaling-teams/README.md": (
        "Масштабирование mobile-команды: **ownership модулей**, RFC, coding standards, CI gates, onboarding, уменьшение bus factor."
    ),
    "system-design/sync-engine/README.md": (
        "**Sync engine**: версионирование, delta sync, конфликты (last-write-wins, CRDT, merge rules), idempotency, backoff."
    ),
}

AI_EN: dict[str, str] = {
    "ai-engineering/llm-basics/README.md": (
        "**LLM** — нейросети, предсказывающие **следующий token**. Отличаются от классического ML открытым текстовым выходом. Темы: transformer, inference, on-device vs cloud на iOS, снижение hallucination."
    ),
    "ai-engineering/tokens/README.md": (
        "**Tokens** — атомарные единицы для модели (subword, не слова). Влияют на стоимость, latency и размер context window."
    ),
    "ai-engineering/context-window/README.md": (
        "**Context window** — максимум **tokens**, которые модель учитывает за один запрос. Стратегии: сжатие, RAG, summarization."
    ),
    "ai-engineering/embeddings/README.md": (
        "**Embeddings** — плотные векторы смысла текста. Основа semantic search и RAG."
    ),
    "ai-engineering/vector-search/README.md": (
        "**Vector search** — k ближайших соседей к query embedding. On-device: бинарник + SQLite metadata; k=5–10 под budget FM."
    ),
    "ai-engineering/rag/README.md": (
        "**RAG** улучшает ответы LLM **извлечением** релевантных фрагментов перед генерацией. Снижает hallucination при актуальных данных."
    ),
    "ai-engineering/structured-output/README.md": (
        "**Structured output** — ответ в **парсируемой схеме** (JSON, `@Generable`). Валидация и retry при невалидном output."
    ),
    "ai-engineering/tool-calling/README.md": (
        "**Tool calling** — модель **запрашивает выполнение** функций приложения. Паттерн agent loop: plan → tool → observe."
    ),
    "ai-engineering/agents/README.md": (
        "**AI agents** — цикл: план → [tools](../tool-calling/) → наблюдение → повтор. Ограничения: контекст, стоимость, безопасность."
    ),
    "ai-engineering/agent-patterns/README.md": (
        "**Agent patterns** — повторяемые решения в промптах и runtime для надёжных AI-фич: routing, reflection, human-in-the-loop."
    ),
    "ai-engineering/mcp/README.md": (
        "**MCP** стандартизирует discovery **tools**, **resources**, **prompts** для AI-хостов. На iOS чаще consumer паттерна, не свой MCP-сервер в проде."
    ),
    "ai-engineering/foundation-models/README.md": (
        "**Foundation Models** (iOS 26+) — on-device LLM API Apple: `SystemLanguageModel`, `LanguageModelSession`, guided generation."
    ),
    "ai-engineering/apple-intelligence/README.md": (
        "Практический **on-device AI** на iOS: **Vision**, **Speech**, **Natural Language**, **Foundation Models** — выбор framework под задачу."
    ),
    "ai-engineering/dynamic-profiles/README.md": (
        "**Dynamic Profiles** (WWDC26) — один **`LanguageModelSession`** с переключаемыми профилями поведения без пересоздания сессии."
    ),
    "ai-engineering/evaluations/README.md": (
        "**Evaluations** проверяют AI-фичи после смены prompt, модели или данных. Golden sets, regression, human review."
    ),
}


def main() -> None:
    all_trans = {**TRANSLATIONS, **AI_EN}
    filled = 0
    for rel, ru in all_trans.items():
        path = KB / rel
        if not path.exists():
            continue
        text = path.read_text(encoding="utf-8")
        if PLACEHOLDER not in text:
            continue
        text = text.replace(PLACEHOLDER, ru)
        path.write_text(text, encoding="utf-8")
        filled += 1
        print(rel)
    print(f"\nFilled {filled} file(s)")


if __name__ == "__main__":
    main()
