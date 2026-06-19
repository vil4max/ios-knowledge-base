import Foundation

struct MobileSystemDesignOutline {
    let product: String
    let constraints: [String]
    let entities: [String]
    let readPath: [String]
    let writePath: [String]
    let secondary: [String]
}

let outline = MobileSystemDesignOutline(
    product: "_(e.g. social feed, chat, checkout)_",
    constraints: [
        "Platforms: iOS / Android",
        "Offline: yes / no",
        "Scale: DAU, payload size",
        "Background: push, sync",
    ],
    entities: [
        "User",
        "Post / Message / Order",
        "Session",
        "Local cache",
    ],
    readPath: [
        "1. UI requests page",
        "2. Repository: memory → disk → network",
        "3. Map DTO → domain → UI model",
    ],
    writePath: [
        "1. User action",
        "2. Validate + optimistic UI (optional)",
        "3. API + queue if offline",
        "4. Reconcile / error surface",
    ],
    secondary: [
        "Logging (no PII)",
        "Analytics events",
        "Feature flags",
        "Deep links",
    ]
)

func starAnswer(situation: String, task: String, action: String, result: String) -> String {
    """
    Situation: \(situation)
    Task: \(task)
    Action: \(action)
    Result: \(result)
    """
}

print("=== Mobile System Design — interview outline ===")
print("Product:", outline.product)
print("\nConstraints:")
outline.constraints.forEach { print("  -", $0) }
print("\nEntities:")
outline.entities.forEach { print("  -", $0) }
print("\nRead path:")
outline.readPath.forEach { print("  -", $0) }
print("\nWrite path:")
outline.writePath.forEach { print("  -", $0) }
print("\nSecondary:")
outline.secondary.forEach { print("  -", $0) }

print("\n=== STAR example (customize) ===")
print(starAnswer(
    situation: "Senior mobile SD interview, 45 min",
    task: "Design feed with offline read",
    action: "Clarified constraints → entity graph → read/write → cache policy",
    result: "Trade-offs documented; secondary: logs + analytics"
))
