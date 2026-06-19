#!/usr/bin/env python3
import re
import shutil
from pathlib import Path

CAREER = Path.home() / "Developer/GitHub/Profile/career"
KB = Path.home() / "Developer/GitHub/ios-knowledge-base"

MIGRATIONS = [
    (
        "II. Swift/08 Swift Concurrency — async-await, actor, isolation",
        "Swift-Concurrency.md",
        "swift/concurrency",
    ),
    (
        "II. Swift/07 Память, ARC, retain cycles, side tables",
        "Memory-ARC-Retain-Cycles.md",
        "swift/memory-arc",
    ),
    (
        "II. Swift/06 Типы, протоколы, дженерики, opaque и existentials",
        "Swift-Types-Protocols-Generics.md",
        "swift/types-generics",
    ),
    (
        "II. Swift/05 Swift — базовый синтаксис и идиоматика",
        "Swift-Syntax-and-Idioms.md",
        "swift/syntax",
    ),
    (
        "IV. Архитектура/16 MVC → MVVM → VIPER → Clean → TCA",
        "Architecture-MVC-MVVM-VIPER-Clean-TCA.md",
        "architecture/patterns",
    ),
    (
        "IV. Архитектура/17 Навигация, координаторы, deep links",
        "Navigation-Coordinators-Deep-Links.md",
        "architecture/navigation",
    ),
    (
        "IV. Архитектура/18 Модуляризация — SPM, Tuist, XcodeGen",
        "Modularization-SPM-Tuist-XcodeGen.md",
        "architecture/modularization",
    ),
    (
        "IV. Архитектура/19 System Design мобильного приложения",
        "Mobile-System-Design.md",
        "system-design/mobile",
    ),
    (
        "V. Данные и сеть/20 Networking — URLSession, REST, WebSocket, GraphQL, gRPC",
        "Networking-URLSession-REST-WebSocket.md",
        "data-and-network/networking",
    ),
    (
        "V. Данные и сеть/21 Хранение данных — UserDefaults, Keychain, CoreData, SwiftData, GRDB",
        "Data-Storage-Persistence.md",
        "data-and-network/storage",
    ),
    (
        "V. Данные и сеть/22 Кэширование и offline-first",
        "Caching-Offline-First.md",
        "data-and-network/caching-offline-first",
    ),
    (
        "III. iOS SDK/11 SwiftUI — декларативный UI и state management",
        "SwiftUI-Declarative-UI-State.md",
        "ios-sdk/swiftui",
    ),
    (
        "III. iOS SDK/10 UIKit — View hierarchy, lifecycle, gestures, transitions",
        "UIKit-Views-Lifecycle-Gestures.md",
        "ios-sdk/uikit",
    ),
    (
        "III. iOS SDK/09 Foundation, App lifecycle, Scene-based архитектура",
        "Foundation-App-Lifecycle-Scenes.md",
        "ios-sdk/foundation",
    ),
    (
        "IX. AI-направление/33 Claude Code, Cursor, Copilot, MCP — настройка и работа",
        "AI-Tools-Claude-Cursor-Copilot-MCP.md",
        "ai/tools",
    ),
    (
        "VIII. Алгоритмы и паттерны/31 Алгоритмы, структуры данных, Big-O в задачах",
        "Algorithms-Data-Structures-Big-O.md",
        "algorithms/structures",
    ),
    (
        "VIII. Алгоритмы и паттерны/32 Паттерны проектирования (GoF + iOS-специфика)",
        "Design-Patterns-GoF-iOS.md",
        "algorithms/design-patterns",
    ),
    (
        "VI. Качество/23 Тестирование — Unit, UI, Snapshot, Test Plans",
        "Testing-Unit-UI-Snapshot.md",
        "quality/testing",
    ),
    (
        "XI. Резюме/Глоссарий",
        "Glossary.md",
        "glossary",
    ),
]

SENSITIVE_PATTERNS = [
    r"SubscriptionSDK",
    r"UmicoPremium",
    r"Umico",
    r"Birmarket",
    r"PASHA",
    r"GlobalLogic",
    r"Kapital Bank",
    r"Competo",
    r"AuthorizationService",
    r"ARCHITECTURE_REFERENCE\.md",
    r"/Users/maks/",
    r"file:///Users/maks",
    r"Max Vilchevskiy",
    r"vil4max@gmail",
]

PLAYGROUND_GLOBS = ["*.playground", "*.playgroundbook", "*.swiftpm"]


def sanitize(text: str) -> str:
    lines = []
    for line in text.splitlines():
        if any(re.search(p, line, re.I) for p in SENSITIVE_PATTERNS):
            continue
        line = line.replace(
            "netsession-lab",
            "https://github.com/vil4max/netsession-lab",
        )
        lines.append(line)
    return "\n".join(lines) + ("\n" if text.endswith("\n") else "")


def copy_playgrounds(src_dir: Path, dest_dir: Path) -> None:
    for pattern in PLAYGROUND_GLOBS:
        for item in src_dir.glob(pattern):
            target = dest_dir / item.name
            if target.exists():
                shutil.rmtree(target)
            if item.is_dir():
                shutil.copytree(item, target)
            else:
                shutil.copy2(item, target)


def migrate() -> None:
    for rel_folder, md_name, dest_rel in MIGRATIONS:
        src_dir = CAREER / rel_folder
        src_md = src_dir / md_name
        if not src_md.exists():
            print(f"SKIP missing: {src_md}")
            continue
        dest_dir = KB / dest_rel
        dest_dir.mkdir(parents=True, exist_ok=True)
        content = sanitize(src_md.read_text(encoding="utf-8"))
        (dest_dir / "README.md").write_text(content, encoding="utf-8")
        copy_playgrounds(src_dir, dest_dir)
        notes = src_dir / "notes"
        if notes.is_dir():
            notes_dest = dest_dir / "notes"
            if notes_dest.exists():
                shutil.rmtree(notes_dest)
            shutil.copytree(notes, notes_dest)
            for note_md in notes_dest.rglob("*.md"):
                note_md.write_text(sanitize(note_md.read_text(encoding="utf-8")), encoding="utf-8")
        print(f"OK {dest_rel}")


if __name__ == "__main__":
    migrate()
