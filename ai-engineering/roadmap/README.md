# AI Engineer Roadmap

Mobile AI on Apple platforms — stack, levels, 12-month plan, skills matrix. Start here before topic **01 · LLM Basics**.

<div class="ai-roadmap">

<section class="ai-slide">
  <header class="ai-slide__header">
    <span class="ai-slide__num">01</span>
    <span class="ai-slide__label">Карта индустрии</span>
  </header>
  <h2 class="ai-slide__title">Не список технологий, а стек слоёв</h2>
  <p class="ai-slide__subtitle">Каждый слой потребляет нижний и обслуживает верхний. Пойми слои — и любая новая аббревиатура встанет на место сама.</p>
  <p class="ai-stack-dir">↑ продукт</p>
  <div class="ai-stack">
    <div class="ai-layer ai-layer--blue">
      <span class="ai-layer__id">L4</span>
      <span class="ai-layer__name ai-layer__name--blue">Product &amp; UX</span>
      <span class="ai-layer__items">mobile-приложения, AI-first UX — <em>твой дом</em></span>
    </div>
    <div class="ai-layer">
      <span class="ai-layer__id">L3</span>
      <span class="ai-layer__name">Orchestration</span>
      <span class="ai-layer__items">Workflows · Agents · Multi-Agent · A2A</span>
    </div>
    <div class="ai-layer">
      <span class="ai-layer__id">L2</span>
      <span class="ai-layer__name">Tools &amp; Context</span>
      <span class="ai-layer__items">Tool Calling · MCP · RAG · Vector DB · Embeddings</span>
    </div>
    <div class="ai-layer ai-layer--gold">
      <span class="ai-layer__id">L1</span>
      <span class="ai-layer__name ai-layer__name--gold">Foundation Models</span>
      <span class="ai-layer__items">AFM 3 (on-device) · Claude · Gemini · Open Source</span>
    </div>
    <div class="ai-layer">
      <span class="ai-layer__id">L0</span>
      <span class="ai-layer__name">Infrastructure</span>
      <span class="ai-layer__items">Private Cloud Compute · GPU · Neural Engine</span>
    </div>
  </div>
  <p class="ai-stack-dir">↓ железо</p>
  <p class="ai-rule">Правило: <strong>сложность</strong> добавляй снизу вверх и только когда <strong>дешёвый</strong> слой не справляется.</p>
  <p class="ai-flow"><span class="t-white">Промпт</span> → <span class="t-blue">tool calling</span> → <span class="t-gold">RAG</span> → <span class="t-blue">workflow</span> → <span class="t-white">агент</span><span class="t-muted">. Не наоборот.</span></p>
</section>

<section class="ai-slide">
  <header class="ai-slide__header">
    <span class="ai-slide__num">02</span>
    <span class="ai-slide__label">Профиль инженера</span>
  </header>
  <h2 class="ai-slide__title">Четыре уровня и критерий перехода</h2>
  <p class="ai-slide__subtitle">Без явного критерия легко застрять в «вечном Intermediate». Каждый уровень — это то, что ты способен спроектировать, а не то, что прочитал.</p>
  <div class="ai-card-panel">
    <div class="ai-level-row">
      <span class="ai-level-icon ai-level-icon--b">B</span>
      <div>
        <p class="ai-level-title">Beginner — AI User, который понимает, что происходит</p>
        <p class="ai-level-detail">Токены, контекст, промпт, tool calling концептуально. Вызов LLM из Swift.</p>
        <p class="ai-level-transition">Переход: поднимаешь app, который вызывает LLM, ловит ошибки сети и стримит ответ.</p>
      </div>
    </div>
    <div class="ai-level-row">
      <span class="ai-level-icon ai-level-icon--i">I</span>
      <div>
        <p class="ai-level-title">Intermediate — AI Builder начального уровня</p>
        <p class="ai-level-detail">Foundation Models на практике, @Generable, Tool, локальный RAG, on-device vs cloud.</p>
        <p class="ai-level-transition">Переход: сам спроектировал и измерил (eval) офлайн-фичу, осознанно решил, что уходит в облако.</p>
      </div>
    </div>
    <div class="ai-level-row">
      <span class="ai-level-icon ai-level-icon--a">A</span>
      <div>
        <p class="ai-level-title">Advanced — проектирует системы</p>
        <p class="ai-level-detail">Coordinator pattern, multi-provider, агентные циклы, свой MCP-сервер, безопасность.</p>
        <p class="ai-level-transition">Переход: senior другой команды говорит «это правильно спроектировано», а не «это работает».</p>
      </div>
    </div>
    <div class="ai-level-row">
      <span class="ai-level-icon ai-level-icon--e">E</span>
      <div>
        <p class="ai-level-title">Expert — AI Architect и носитель вкуса</p>
        <p class="ai-level-detail">Видит весь стек и экономику, знает когда AI НЕ нужен, формирует мнение индустрии.</p>
        <p class="ai-level-transition">Переход: люди приходят к тебе за тем, как делать AI на mobile.</p>
      </div>
    </div>
  </div>
</section>

<section class="ai-slide">
  <header class="ai-slide__header">
    <span class="ai-slide__num">03</span>
    <span class="ai-slide__label">12 месяцев · по шагам</span>
  </header>
  <h2 class="ai-slide__title">Год, который выводит в крепкий Advanced</h2>
  <p class="ai-slide__subtitle">Ложится прямо на твою последовательность: Playgrounds → LanguageModelSession → availability → @Generable → Tool → streaming → координатор.</p>
  <div class="ai-phase">
    <div class="ai-phase__label">Фаза 1 · Фундамент (M1—M5)</div>
    <div class="ai-months">
      <div class="ai-month">
        <div class="ai-month__id">M01</div>
        <p class="ai-month__text">Промпт + вызов API из Swift, стриминг, ошибки</p>
      </div>
      <div class="ai-month">
        <div class="ai-month__id">M02</div>
        <p class="ai-month__text">AFM on-device: LanguageModelSession, availability</p>
      </div>
      <div class="ai-month">
        <div class="ai-month__id">M03</div>
        <p class="ai-month__text">@Generable, Tool, image input + Vision OCR</p>
      </div>
      <div class="ai-month">
        <div class="ai-month__id">M04</div>
        <p class="ai-month__text">Streaming, сессии и Evaluation — рано!</p>
      </div>
      <div class="ai-month">
        <div class="ai-month__id">M05</div>
        <p class="ai-month__text">Embeddings, локальный RAG по заметкам</p>
      </div>
    </div>
  </div>
  <div class="ai-phase">
    <div class="ai-phase__label">Фаза 2 · Системы (M6—M9)</div>
    <div class="ai-months">
      <div class="ai-month ai-month--flagship">
        <div class="ai-month__id">M06</div>
        <p class="ai-month__text">Coordinator pattern — edge↔cloud роутинг</p>
        <span class="ai-month__badge">★ Флагман</span>
      </div>
      <div class="ai-month">
        <div class="ai-month__id">M07</div>
        <p class="ai-month__text">MCP: подключаю и пишу свой первый сервер</p>
      </div>
      <div class="ai-month">
        <div class="ai-month__id">M08</div>
        <p class="ai-month__text">Агенты: workflow → agentic, один фреймворк глубоко</p>
      </div>
      <div class="ai-month">
        <div class="ai-month__id">M09</div>
        <p class="ai-month__text">Безопасность: injection, tool poisoning, guardrails</p>
      </div>
    </div>
  </div>
</section>

<section class="ai-slide">
  <header class="ai-slide__header">
    <span class="ai-slide__num">04</span>
    <span class="ai-slide__label">3 года · долгая дуга</span>
  </header>
  <h2 class="ai-slide__title">AI User → AI Builder → AI Architect</h2>
  <div class="ai-years">
    <div class="ai-year">
      <div class="ai-year__label">Год 1</div>
      <p class="ai-year__heading">AI User → Builder</p>
      <p class="ai-year__summary">Освоить весь mobile AI-стек на практике, построить координатор, начать публиковаться.</p>
      <ul>
        <li>Foundation Models, structured output, RAG, eval</li>
        <li>Первый MCP-сервер и первый агент</li>
        <li>2–3 портфельных приложения</li>
      </ul>
    </div>
    <div class="ai-year">
      <div class="ai-year__label">Год 2</div>
      <p class="ai-year__heading ai-year__heading--orange">Builder → Architect</p>
      <p class="ai-year__summary">От «делаю фичи» к «проектирую системы и задаю стандарты». Выход на англоязычную аудиторию.</p>
      <ul>
        <li>Multi-agent, A2A, observability, экономика inference</li>
        <li>Open-source библиотека для mobile AI</li>
        <li>Доклад на конференции</li>
      </ul>
    </div>
    <div class="ai-year">
      <div class="ai-year__label">Год 3</div>
      <p class="ai-year__heading ai-year__heading--blue">AI Architect</p>
      <p class="ai-year__summary">Влиять на продуктовую и AI-стратегию, формировать мнение, менторить.</p>
      <ul>
        <li>Референсная архитектура отрасли</li>
        <li>Влияние на стратегию компании</li>
        <li>Устойчивый публичный бренд</li>
      </ul>
    </div>
  </div>
</section>

<section class="ai-slide">
  <header class="ai-slide__header">
    <span class="ai-slide__num">06</span>
    <span class="ai-slide__label">Матрица навыков</span>
  </header>
  <h2 class="ai-slide__title">Что учить и в каком порядке</h2>
  <p class="ai-slide__subtitle">Недооценённый навык — <strong>Evaluation</strong>. Кто измеряет качество AI-фичи — управляет разговором в команде. Самый дешёвый рычаг к влиянию.</p>
  <div class="ai-matrix">
    <div class="ai-matrix-col">
      <p class="ai-matrix-col__title ai-matrix-col__title--now">Сразу</p>
      <p class="ai-matrix-col__period">M1–M5</p>
      <div class="ai-skill"><span class="ai-skill__name">Prompt Engineering</span><span class="ai-roi ai-roi--high">ROI выс</span></div>
      <div class="ai-skill"><span class="ai-skill__name">Claude Code / Cursor</span><span class="ai-roi ai-roi--high">ROI выс</span></div>
      <div class="ai-skill"><span class="ai-skill__name">Foundation Models</span><span class="ai-roi ai-roi--high">ROI выс</span></div>
      <div class="ai-skill"><span class="ai-skill__name">Structured output</span><span class="ai-roi ai-roi--high">ROI выс</span></div>
      <div class="ai-skill"><span class="ai-skill__name">Evaluation</span><span class="ai-roi ai-roi--high">ROI выс</span></div>
      <div class="ai-skill"><span class="ai-skill__name">Anthropic SDK</span><span class="ai-roi ai-roi--high">ROI выс</span></div>
    </div>
    <div class="ai-matrix-col">
      <p class="ai-matrix-col__title ai-matrix-col__title--mid">По ходу</p>
      <p class="ai-matrix-col__period">M5–M9</p>
      <div class="ai-skill"><span class="ai-skill__name">RAG</span><span class="ai-roi ai-roi--high">ROI выс</span></div>
      <div class="ai-skill"><span class="ai-skill__name">MCP</span><span class="ai-roi ai-roi--high">ROI выс</span></div>
      <div class="ai-skill"><span class="ai-skill__name">Agents (концепции)</span><span class="ai-roi ai-roi--high">ROI выс</span></div>
      <div class="ai-skill"><span class="ai-skill__name">Python / TypeScript</span><span class="ai-roi ai-roi--high">ROI выс</span></div>
      <div class="ai-skill"><span class="ai-skill__name">LangGraph (один)</span><span class="ai-roi ai-roi--mid">ROI ср</span></div>
      <div class="ai-skill"><span class="ai-skill__name">Vector DB</span><span class="ai-roi ai-roi--mid">ROI ср</span></div>
    </div>
    <div class="ai-matrix-col">
      <p class="ai-matrix-col__title ai-matrix-col__title--later">Отложить</p>
      <p class="ai-matrix-col__period">Год 2+ / по нужде</p>
      <div class="ai-skill"><span class="ai-skill__name">AI Product Design</span><span class="ai-roi ai-roi--high">ROI выс</span></div>
      <div class="ai-skill"><span class="ai-skill__name">AI UX</span><span class="ai-roi ai-roi--high">ROI выс</span></div>
      <div class="ai-skill"><span class="ai-skill__name">AI Infrastructure</span><span class="ai-roi ai-roi--mid">ROI ср</span></div>
      <div class="ai-skill"><span class="ai-skill__name">OpenAI SDK</span><span class="ai-roi ai-roi--mid">ROI ср</span></div>
      <div class="ai-skill"><span class="ai-skill__name">Fine-tuning</span><span class="ai-roi ai-roi--low">ROI низ</span></div>
    </div>
  </div>
</section>

<section class="ai-slide">
  <header class="ai-slide__header">
    <span class="ai-slide__num">07</span>
    <span class="ai-slide__label">Что не учить</span>
  </header>
  <h2 class="ai-slide__title">Самый важный раздел для скорости</h2>
  <div class="ai-card-panel">
    <div class="ai-skip-row">
      <span class="ai-skip-icon">✕</span>
      <div>
        <p class="ai-skip-title">Fine-tuning / обучение моделей с нуля</p>
        <p class="ai-skip-desc">Дорого, быстро устаревает. Ты потребитель моделей, не их производитель. 99% задач — промпт + RAG + инструменты.</p>
      </div>
    </div>
    <div class="ai-skip-row">
      <span class="ai-skip-icon">✕</span>
      <div>
        <p class="ai-skip-title">«Все 6 агентных фреймворков»</p>
        <p class="ai-skip-desc">Возьми один глубоко (LangGraph или Claude Agent SDK). Остальные — по аналогии за день, когда понадобятся.</p>
      </div>
    </div>
    <div class="ai-skip-row">
      <span class="ai-skip-icon">✕</span>
      <div>
        <p class="ai-skip-title">Погоня за каждой моделью и бенчмарком</p>
        <p class="ai-skip-desc">Модели конвергировали — харнесс и архитектура важнее +2% на лидерборде. Следи за тем, что меняет архитектуру.</p>
      </div>
    </div>
    <div class="ai-skip-row">
      <span class="ai-skip-icon">✕</span>
      <div>
        <p class="ai-skip-title">«Туториал-ад»</p>
        <p class="ai-skip-desc">Один отгруженный проект с eval &gt; десять просмотренных курсов. Build &gt; consume.</p>
      </div>
    </div>
  </div>
</section>

</div>

---

## Topic map · M01–M09 → KB

| Month | Focus | KB topics |
|-------|--------|-----------|
| M01 | Prompting & API | [01 · LLM Basics](llm-basics/) · [02 · Tokens](tokens/) · [03 · Context Window](context-window/) |
| M02 | On-device AFM | [11 · Foundation Models](foundation-models/) |
| M03 | Tools & structure | [07 · Structured Output](structured-output/) · [08 · Tool Calling](tool-calling/) |
| M04 | Sessions & eval idea | [03 · Context Window](context-window/) · [14 · Evaluations](evaluations/) |
| M05 | RAG | [04 · Embeddings](embeddings/) · [05 · Vector Search](vector-search/) · [06 · RAG](rag/) |
| M06 ⭐ | Coordinator | [11 · Foundation Models](foundation-models/) · [Agent Patterns](agent-patterns/) |
| M07 | MCP | [10 · MCP](mcp/) |
| M08 | Agents | [09 · Agents](agents/) |
| M09 | Security | [09 · Agents](agents/) · guardrails in topics |

**Next:** [01 · LLM Basics →](llm-basics/)
