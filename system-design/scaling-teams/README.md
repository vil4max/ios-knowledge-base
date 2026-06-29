# Scaling Teams

## In 30 seconds

Scaling mobile engineering is about **module ownership**, clear **RFCs** for cross-cutting changes, enforced **coding standards**, and a branching strategy that matches release cadence — often **trunk-based development** with short-lived branches for apps that ship weekly, vs **GitFlow** when release trains are long and hotfix isolation matters. Interview answers connect org design to build times, merge conflicts, and quality gates (CI, feature flags).

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

## Key concepts

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

## Links

- [Trunk Based Development](https://trunkbaseddevelopment.com/) — canonical reference
- [GitFlow original](https://nvie.com/posts/a-successful-git-branching-model/) — know to compare/contrast
- Related: [feature-flags](../feature-flags/README.md), [architecture/modularization](../../architecture/modularization/README.md)

## Interview Q&A (Knowledge cards)

<!-- knowledge-cards-canonical:start -->

### Q1
- **Question:** Trunk-based vs GitFlow for mobile teams?

- **Answer:** Trunk-based favors frequent merges to main, feature flags, and strong CI — fits frequent mobile releases. GitFlow suits long stabilization and multiple supported versions. Most mobile orgs use trunk plus flags.

### Q2
- **Question:** Why use RFCs on a mobile team?

- **Answer:** Cross-cutting changes need written consensus before code: problem, options, decision, rollout. Reduces rework and documents why — critical during modularization.

### Q3
- **Question:** What does module ownership include?

- **Answer:** A DRI owns roadmap, reviews, production quality in scope, public API docs, and deprecations. Platform modules often have a dedicated team with SLAs for internal consumers.

### Q4
- **Question:** How do you enforce coding standards without endless debates?

- **Answer:** Automate with linters, formatters, and required CI. Resolve stylistic debates once in an RFC. Reserve review for design; update standards from postmortems, not ad hoc in every PR.

<!-- knowledge-cards-canonical:end -->
