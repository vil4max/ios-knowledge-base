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
        },
    },
    "swift": {
        "title": "Swift",
        "topics": {
            "syntax": "Syntax & Idioms",
            "types-generics": "Types & Generics",
            "memory-arc": "Memory & ARC",
            "concurrency": "Concurrency",
        },
    },
    "ios-sdk": {
        "title": "iOS SDK",
        "topics": {
            "foundation": "Foundation & Lifecycle",
            "uikit": "UIKit",
            "swiftui": "SwiftUI",
            "auto-layout": "Auto Layout",
            "collection-views": "Collection Views",
            "animations": "Animations",
            "graphics": "Graphics & Metal",
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
            "llm-basics": "01 · LLM Basics",
            "tokens": "02 · Tokens",
            "context-window": "03 · Context Window",
            "embeddings": "04 · Embeddings",
            "vector-search": "05 · Vector Search",
            "rag": "06 · RAG",
            "structured-output": "07 · Structured Output",
            "tool-calling": "08 · Tool Calling",
            "agents": "09 · Agents",
            "mcp": "10 · MCP",
            "foundation-models": "11 · Foundation Models",
            "apple-intelligence": "12 · Apple Intelligence",
            "dynamic-profiles": "13 · Dynamic Profiles",
            "evaluations": "14 · Evaluations",
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

## За 30 секунд

_(to be added)_

## Ключевые понятия

_(to be added)_

## Как отвечать на интервью

_(to be added)_

## Код и примеры

_(to be added)_

## Ссылки

_(to be added)_
"""

DRAFT_MARKER = "> **Status:** draft"
