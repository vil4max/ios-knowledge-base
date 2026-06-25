#!/usr/bin/env python3
"""Full knowledge base tree. Every topic gets a folder; sidebar lists all."""

TOPIC_TREE = {
    "fundamentals": {
        "title": "Fundamentals",
        "topics": {
            "computer-science": "Computer Science",
            "os-and-networks": "OS & Networks",
            "git": "Git & Code Review",
            "cli": "CLI & Terminal",
            "development-principles": "Development Principles",
        },
    },
    "swift": {
        "title": "Swift",
        "topics": {
            "syntax": "Syntax & Idioms",
            "protocols": "Protocols",
            "types-generics": "Types & Generics",
            "memory-arc": "Memory & ARC",
            "concurrency": "Concurrency",
            "metaprogramming": "Metaprogramming",
        },
    },
    "ios-sdk": {
        "title": "iOS SDK",
        "topics": {
            "foundation": "Foundation & Lifecycle",
            "format-style": "FormatStyle & Parsing",
            "uikit": "UIKit",
            "swiftui": "SwiftUI",
            "app-intents": "App Intents",
            "auto-layout": "Auto Layout",
            "collection-views": "Collection Views",
            "animations": "Animations",
            "graphics": "Graphics & Metal",
            "core-bluetooth": "Core Bluetooth & BLE",
        },
    },
    "architecture": {
        "title": "Architecture",
        "topics": {
            "patterns": "MVVM → TCA",
            "navigation": "Navigation & Deep Links",
            "modularization": "Modularization",
        },
    },
    "system-design": {
        "title": "System Design",
        "topics": {
            "mobile": "Mobile App Design",
            "bdui": "Backend-Driven UI",
            "offline-first": "Offline First",
            "sync-engine": "Sync Engine",
            "push-notifications": "Push Notifications",
            "deep-links": "Deep Links",
            "feature-flags": "Feature Flags",
            "analytics": "Analytics & Remote Config",
            "scaling-teams": "Scaling Teams",
        },
    },
    "data-and-network": {
        "title": "Data & Network",
        "topics": {
            "networking": "Networking",
            "storage": "Storage & Persistence",
            "caching-offline-first": "Caching & Offline-First",
        },
    },
    "quality": {
        "title": "Quality",
        "topics": {
            "testing": "Testing",
            "debug": "Debug & Instruments",
            "performance": "Performance",
            "security": "Security",
            "accessibility": "Accessibility & Localization",
        },
    },
    "devops": {
        "title": "DevOps",
        "topics": {
            "ci-cd": "CI/CD",
            "app-store": "App Store & TestFlight",
            "monitoring": "Crash Analytics & Monitoring",
        },
    },
    "algorithms": {
        "title": "Algorithms",
        "topics": {
            "structures": "Data Structures & Big-O",
            "design-patterns": "Design Patterns",
        },
    },
    "ai-engineering": {
        "title": "AI Engineering",
        "topics": {
            "roadmap": "Roadmap",
            "llm-basics": "01 · LLM Basics",
            "tokens": "02 · Tokens",
            "context-window": "03 · Context Window",
            "embeddings": "04 · Embeddings",
            "vector-search": "05 · Vector Search",
            "rag": "06 · RAG",
            "structured-output": "07 · Structured Output",
            "tool-calling": "08 · Tool Calling",
            "agents": "09 · Agents",
            "agent-patterns": "Agent Patterns",
            "mcp": "10 · MCP",
            "foundation-models": "11 · Foundation Models",
            "apple-intelligence": "12 · Apple Intelligence",
            "dynamic-profiles": "13 · Dynamic Profiles",
            "evaluations": "14 · Evaluations",
        },
    },
    "reference": {
        "title": "Curated",
        "topics": {
            "curated": "External Links",
        },
    },
    "glossary": {
        "title": "Reference",
        "topics": {
            ".": "Glossary",
        },
    },
}

STUB_TEMPLATE = """# {title}

> **Status:** draft — content pending

## In 30 seconds

_(English summary — to be added)_

<details class="lang-ru">
<summary>По-русски</summary>

_(Русский абзац — добавить.)_

</details>

## Key concepts

_(to be added)_

## How to answer in interviews

_(to be added)_

## Code & examples

_(to be added)_

## Links

_(to be added)_
"""

DRAFT_MARKER = "> **Status:** draft"
