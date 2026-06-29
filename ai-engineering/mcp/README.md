# 10 · MCP

## In 30 seconds

**Model Context Protocol (MCP)** standardizes how AI hosts (Cursor, agents, IDEs) discover **tools**, **resources**, and **prompts** from servers. On iOS you rarely ship an MCP server in production; you **consume** the pattern when building with agents and when wiring app capabilities as typed tools. Pair with [Tool Calling](../tool-calling/) for the model side and [Agents](../agents/) for multi-step loops.

## 🎯 Focus vs Defer

### Focus

### Defer

- Vendor-specific **MCP server zoo** before one stable read-only workflow (docs search, issue lookup) works in CI.
- **Fully autonomous** agents on production branches without human review gates.
- Replacing **unit tests** with “agent said it works” sign-off.
- Maintaining 50-page **AGENTS.md** instead of small skills + hooks for repeated mistakes.

## 🏋️ Exercises

## Artifacts

- Notes: `notes/`
- Exercises: `exercises/`
- Assets: `assets/`
- Playgrounds: `playgrounds/`

### Recent notes

- `notes/11-lessons-from-using-ai-agents-full-time.md`
- `notes/12-swiftui-agent-skill-build-better-views-with-ai.md`
- `notes/13-swift-testing-agent-skill-write-high-quality-tests-with-ai.md`
- `notes/14-core-data-agent-skill-open-source.md`
- `notes/15-coding-agents-for-production-ios-2x-output.md`

---

## What the article covers

## 11 lessons from the article

### 1) Not using plan mode — mistake

### 2) Treating prompts as one-shot — mistake

### 3) Ignoring skills — mistake

### 4) Fully automatic model choice — risk

### 5) One giant prompt for everything — mistake

### 6) Shallow review — fast path to tech debt

### 7) Not learning tools deeply — lost leverage

### 8) Working without hooks/rules/guardrails — mistake

### 9) Not evolving AGENTS/rules from mistakes — mistake

### 10) Skipping tests/CI in PR — fast regressions

### 11) Avoiding discomfort with new tools — limits growth

## Actionable takeaways

---## TL;DR

## Problem the skill solves

## Why a skill beats one large AGENTS.md

## Rules especially valuable for SwiftUI

## What changes in day-to-day development

## What to adopt

## Mini checklist before generating a SwiftUI screen

---## TL;DR

## Source

## What to read first in the repo

## Problem with “ordinary” AI-generated tests

## What Testing Skill changes

## Especially important practices

## What it gives in daily development

## What to adopt

## Mini checklist for AI-generated tests

---## TL;DR

## Source

- [Core Data Agent Skill now available open source](https://www.avanderlee.com/ai-development/core-data-agent-skill-now-available-open-source/)

## Why the topic is still relevant

## Problems the skill helps close

## How it helps in daily work

## Practical takeaways

## Mini checklist

---## TL;DR

## Source

- [Coding agents for production iOS: a senior engineer's setup for 2x the output](https://ignatovv.me/blog/coding-agents-for-production-ios/)

## Central idea of the article

## What a working pipeline looks like

## What actually improves results

## Honest part: why “from scratch” fails at first

## What it means for the team

## Practical takeaways

## Mini checklist

---## Interview Q&A (Knowledge cards)

### Q1
- **Question:** What is MCP in one sentence?
- **Answer:** Model Context Protocol standardizes how AI hosts discover tools, resources, and prompts from servers—relevant when wiring agent workflows, not typically an in-app production server on iOS.

<!-- ai-engineering-nav:start -->

---

**AI Engineering:** [Track overview](../README.md) · [← 09 · Agents](../agents/) · [11 · Foundation Models →](../foundation-models/)

<!-- ai-engineering-nav:end -->
