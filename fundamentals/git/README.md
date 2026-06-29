# Git & Code Review

## In 30 seconds

Git is the daily workflow layer for iOS teams: feature branches, rebases, pull requests, and readable history that survives App Store release trains. Interviewers and lead engineers check whether you can explain merge vs rebase without losing work, write Conventional Commits, review Swift/SwiftUI diffs for concurrency and API safety, and bisect a regression to a single commit. Strong git hygiene reduces release risk when multiple developers touch `.xcodeproj`, SPM packages, and generated assets. Code review is part of the same skill: you prove you can ship small, reviewable changes—not only that you know `git status`.

## Apple docs

- [Source control management in Xcode](https://developer.apple.com/documentation/xcode/source-control-management-in-xcode) — branches, comparisons, integration with git.
- [Xcode source control preferences](https://developer.apple.com/documentation/xcode/customizing-your-workflow-in-xcode) — workflow settings in the IDE.
- [About version control in Xcode](https://developer.apple.com/library/archive/documentation/ToolsLanguages/Conceptual/Xcode_Overview/ManagingVersions.html) — overview of VCS integration.
- [Building from the command line with xcodebuild](https://developer.apple.com/documentation/xcode/building-from-the-command-line-with-xcodebuild) — CI hooks tied to git events.
- [Continuous integration and delivery with Xcode Cloud](https://developer.apple.com/documentation/xcode/xcode-cloud) — builds triggered from repository changes.
- [Swift Package Manager documentation](https://developer.apple.com/documentation/xcode/swift-packages) — versioning and dependency pins in git.
- [Configuring your project for continuous integration](https://developer.apple.com/documentation/xcode/configuring-your-project-for-continuous-integration) — schemes, tests, and branch policies.
- [Documentation markup in Swift](https://developer.apple.com/documentation/xcode/writing-documentation) — doc comments reviewers expect on public API.

## 🎯 Focus vs Defer

### Focus

- **Branching models for mobile** — trunk/main, short-lived feature branches, release/hotfix branches.
  - **Answer:** Feature branch from `main`, PR, squash or merge after CI green. Release branch only if store submissions need parallel hotfixes. Keep branches small (< ~400 lines diff) so review is meaningful. Tag App Store builds (`1.4.0(42)`).

- **Merge vs rebase** — linear history vs preserving merge commits; team policy.
  - **Answer:** **Merge** preserves exact branch topology; safe for shared branches. **Rebase** replays commits on new base → linear history; never rebase commits already pushed/shared without coordination. Many teams: rebase locally before PR, squash-merge on GitHub/GitLab.

- **Conventional Commits** — `type(scope): description` for changelog and release notes automation.
  - **Answer:** Types: feat, fix, refactor, perf, docs, test, chore. Scope optional (`ios`, `auth`). One logical change per commit; present tense. Enables semantic release and readable `git log` during bisect.

- **PR review checklist for iOS** — threading, memory, API surface, tests, localization, accessibility.
  - **Answer:** Ask: MainActor/UI updates? Retain cycles in closures? Public API breaking change? Missing tests for bugfix? Strings localized? Snapshot/UI test updates? SPM pin changes intentional? `.pbxproj` noise minimized?

- **git bisect** — binary search for regression between good and bad revision.
  - **Answer:** `git bisect start`, mark bad/good, run test script (`xcodebuild test` or unit subset) until culprit commit; `git bisect reset` when done. Saves hours vs manual checkout.

- **Stash and WIP hygiene** — context switch without junk commits.
  - **Answer:** `git stash push -m "message"` before urgent fix; pop or apply selectively. Do not stash binary build artifacts; clean build folder separately.

### Defer

- Complex git internals (packfiles, reflog archaeology) until debugging repository corruption.
- `git filter-repo` / history rewriting on shared main—requires team process and force-push policy.
- Submodule-heavy workflows when SPM covers dependencies for greenfield iOS work.
- Arguing rebase vs merge ideology—state team policy and trade-offs, then move on.

## Key concepts

- **Repository:** DAG of commits; branches are movable pointers; `HEAD` is current checkout.
- **Commit:** Snapshot + metadata (author, message, parent SHA); immutable once published.
- **Branch:** Named pointer to a commit line; enables parallel work (`feature/login`).
- **Merge:** Combines histories with a merge commit (or fast-forward if linear).
- **Rebase:** Replays commits onto another base; rewrites SHAs of rebased commits.
- **Pull request (PR):** Proposed integration with review, CI, and discussion before merge.
- **Conventional Commits:** Standardized commit message format for automation and clarity.
- **Interactive staging:** `git add -p` to split hunks; keeps commits atomic.
- **git stash:** Temporary stack of uncommitted changes for context switching.
- **git bisect:** Binary search across history to find regression-introducing commit.
- **Cherry-pick:** Apply specific commit(s) to another branch (hotfix backport).
- **Code review:** Human gate for correctness, design, security, and knowledge sharing—not style nitpicks only.

## 🏋️ Exercises

1. **Merge vs rebase scenario:** Feature branch diverged 10 commits from `main`. Describe two integration strategies and when each is appropriate. **Expected:** rebase+FF for clean log locally; merge commit if branch was public and team forbids rewrite.
2. **Conventional Commits:** Rewrite three vague messages (`fix stuff`, `WIP`, `updates`) into valid conventional commits for an iOS auth fix. **Expected:** e.g. `fix(auth): refresh token on 401`, `test(auth): add session expiry case`.
3. **Review checklist:** Given a diff adding `@escaping` completion handler storing `self` strongly, list review comments. **Expected:** `[weak self]`, cancellation, MainActor for UI callback, test for deinit.
4. **Bisect drill:** `main` broken after Friday; last known good tag `v2.1.0`. Write bisect commands and a one-line test script idea. **Expected:** `git bisect start`, `bad`/`good`, `./scripts/test-auth.sh`, `reset`.
5. **Stash workflow:** Mid-feature, production bug on `main`. Steps to fix without losing WIP. **Expected:** stash → checkout main → branch hotfix → commit → PR → return and stash pop.

Doc link: [Source control management in Xcode](https://developer.apple.com/documentation/xcode/source-control-management-in-xcode)

## Links

- WWDC 2021 — [Customize your Xcode Cloud workflow](https://developer.apple.com/videos/play/wwdc2021/10268/) — git-triggered CI
- [Xcode Cloud Workflows](https://developer.apple.com/documentation/xcode/xcode-cloud-workflow-reference)
- [Conventional Commits specification](https://www.conventionalcommits.org/)
- External: [GitHub Flow](https://docs.github.com/en/get-started/using-github/github-flow) — branch/PR model used by many iOS teams
- External: [Atlassian Git tutorials — merging vs rebasing](https://www.atlassian.com/git/tutorials/merging-vs-rebasing)

---

## Interview Q&A (Knowledge cards)

<!-- knowledge-cards-canonical:start -->

### Q1
- **Question:** Merge vs rebase—difference and interview-ready answer?

- **Answer:** Merge preserves branch topology; rebase replays commits for a linear history and rewrites SHAs. Rebase locally before opening a PR; avoid rebasing shared remote commits. Squash merge is a common team compromise.

### Q2
- **Question:** Why use Conventional Commits on an iOS project?

- **Answer:** Standardized messages improve review readability, changelog automation, and bisect/debugging. One logical change per commit with optional scope (`ios`, `auth`).

### Q3
- **Question:** Code review checklist for a Swift/iOS pull request?

- **Answer:** Review correctness, concurrency/MainActor usage, memory, API stability, tests, localization/a11y, dependency changes, and secrets. Separate blockers from nits; suggest alternatives.

### Q4
- **Question:** How do git bisect and stash work?

- **Answer:** Bisect binary-searches history with a test script to find the regressing commit. Stash temporarily shelves WIP changes so you can switch branches cleanly.

<!-- knowledge-cards-canonical:end -->
