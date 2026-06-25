# Scaling Teams

## За 30 секунд


Scaling mobile engineering is about **module ownership**, clear **RFCs** for cross-cutting changes, enforced **coding standards**, and a branching strategy that matches release cadence — often **trunk-based development** with short-lived branches for apps that ship weekly, vs **GitFlow** when release trains are long and hotfix isolation matters. Interview answers connect org design to build times, merge conflicts, and quality gates (CI, feature flags).


<details class="lang-ru">
<summary>По-русски</summary>

Масштабирование mobile-команды: **ownership модулей**, RFC, coding standards, CI gates, onboarding, уменьшение bus factor.

</details>



## Apple docs

- [Apple Platform Deployment](https://developer.apple.com/documentation/xcode-release-notes) — align team standards with SDK cadence (annual iOS release).
- [XCTest](https://developer.apple.com/documentation/xctest) — CI quality gate expectations for mobile modules.
- No Apple doc for GitFlow vs trunk — organizational choice documented in internal RFCs.

## 🎯 Focus vs Defer

### Focus

- **Module ownership:** team owns vertical slice or horizontal platform (Networking, DesignSystem).
- **RFC process:** problem, options, decision, rollout for API breaks and architecture.
- **Coding standards:** Swift style, concurrency rules, logging, analytics naming — lint in CI.
- **Trunk-based vs GitFlow:** merge frequency, release branches, hotfix path.
- **Monorepo vs multirepo:** single Xcode workspace vs published internal SPM modules.
- **Release train:** App Store review, phased rollout, crash gating.
- **On-call & quality:** ownership includes production metrics for owned modules.

### Defer

- Full reorg chart for 200-person eng — use squad/tribe example.
- HR performance review process.
- Detailed legal/compliance unless fintech/health prompt.

## Ключевые понятия

| Model | When it fits mobile |
|-------|---------------------|
| **Trunk-based** | Frequent releases, strong CI, feature flags |
| **GitFlow** | Long stabilization, multiple supported versions |
| **Release train** | Cut branch weekly/biweekly → QA → App Store |
| **RFC** | Written proposal before big migrations |
| **CODEOWNERS** | Auto-review routing per module |
| **Platform team** | Shared infra: CI, design system, networking SDK |

**Trunk-based (typical modern iOS):**

```text
main (always green)
  ← short PRs (< 1 day)
  ← feature flags hide incomplete work
  ← release tag from main for App Store
```

**GitFlow (when needed):**

```text
develop → release/x.y → main + hotfix/*
  longer-lived feature branches
  merge pain if branches live weeks
```

**Module ownership rules:** one DRI per module; breaking changes need RFC + migration guide; deprecations with sunset date.

**Coding standards examples:** SwiftFormat/SwiftLint in CI; no force-unwrap in production; async/await over GCD for new code; Conventional Commits; single-line PR scope.

## 🏋️ Exercises

1. **Split monolith app** — 3 teams, 40 engineers. Propose module map and ownership. *Expected:* Feature modules + Core/Networking/DesignSystem platforms.

2. **RFC draft** — Migrate from callbacks to async/await in Networking module. *Expected:* motivation, migration phases, risks, timeline, rollback.

3. **Branch strategy** — Weekly App Store releases, 2-week features. *Expected:* trunk + flags vs release branch — argue choice.

4. **CODEOWNERS** — Map paths to teams for review SLA. *Expected:* `Features/Payments/` → payments team.

5. **Hotfix process** — P0 crash in production. *Expected:* branch from tag, fix, expedited review, phased rollout, postmortem RFC optional.

## Ссылки

- [Trunk Based Development](https://trunkbaseddevelopment.com/) — canonical reference
- [GitFlow original](https://nvie.com/posts/a-successful-git-branching-model/) — know to compare/contrast
- Related: [feature-flags](../feature-flags/README.md), [architecture/modularization](../../architecture/modularization/README.md)

## Карточки знаний (Q&A)

<!-- knowledge-cards-canonical:start -->

### Q1
- **Question (EN):** Trunk-based vs GitFlow for mobile teams?

- **Answer (EN):** Trunk-based favors frequent merges to main, feature flags, and strong CI — fits frequent mobile releases. GitFlow suits long stabilization and multiple supported versions. Most mobile orgs use trunk plus flags.


<details class="lang-ru">
<summary>По-русски</summary>

- **Question (RU):** Trunk-based vs GitFlow для mobile?

- **Answer (RU):** **Trunk-based** — частые мержи в main, незавершённое за **feature flags**, CI держит main green; подходит частым App Store релизам. **GitFlow** — долгие release/hotfix ветки; оправдан при длинных stabilization и нескольких supported версиях. Mobile industry сдвинулся к trunk + flags.

</details>
### Q2
- **Question (EN):** Why use RFCs on a mobile team?

- **Answer (EN):** Cross-cutting changes need written consensus before code: problem, options, decision, rollout. Reduces rework and documents why — critical during modularization.


<details class="lang-ru">
<summary>По-русски</summary>

- **Question (RU):** Зачем RFC в mobile команде?

- **Answer (RU):** Кросс-модульные решения (новый sync layer, смена DI, breaking API) нуждаются в **письменном consensus** до кода: проблема, альтернативы, decision, plan. Снижает rework и bus factor; особенно важно при modularization.

</details>
### Q3
- **Question (EN):** What does module ownership include?

- **Answer (EN):** A DRI owns roadmap, reviews, production quality in scope, public API docs, and deprecations. Platform modules often have a dedicated team with SLAs for internal consumers.


<details class="lang-ru">
<summary>По-русски</summary>

- **Question (RU):** Module ownership — что входит?

- **Answer (RU):** **DRI** за roadmap модуля, review PR, on-call за crashes в зоне, документация public API, deprecation policy. Platform modules (UI kit, network) — отдельная команда с SLA для internal customers.

</details>
### Q4
- **Question (EN):** How do you enforce coding standards without endless debates?

- **Answer (EN):** Automate with linters, formatters, and required CI. Resolve stylistic debates once in an RFC. Reserve review for design; update standards from postmortems, not ad hoc in every PR.

<!-- knowledge-cards-canonical:end -->


<details class="lang-ru">
<summary>По-русски</summary>

- **Question (RU):** Coding standards — как enforce без споров?

- **Answer (RU):** **Automate:** SwiftLint/SwiftFormat, CI required checks, templates, ARCHITECTURE.md per module. Спорные стилевые вещи — один RFC и freeze. Human review фокус на design, не табы. Обновлять standards после postmortem, не ad hoc в каждом PR.

</details>
