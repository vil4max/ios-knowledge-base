import Foundation
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

/*
 Structured vs unstructured concurrency — runnable demos.
 Source: https://macguru.dev/whats-that-structured-in-structured-concurrency/
 Note: notes/Structured-Concurrency-What-Structured-Means.md

 1) Nested Task — inner task is NOT cancelled with parent
 2) async let — structured subtasks ARE cancelled
 3) withTaskGroup — group children ARE cancelled
 4) Manual cancellation forwarding for unstructured Task
 5) async let with discarded result — still structured
 6) async closure vs Task — caller owns lifetime
*/

actor Logger {
    func log(_ message: String) {
        print(message)
    }
}

let logger = Logger()

func load(name: String) async -> String {
    for _ in 0 ..< 30 {
        if Task.isCancelled {
            await logger.log("  \(name): cancelled")
            return "\(name): cancelled"
        }
        try? await Task.sleep(for: .milliseconds(80))
    }
    await logger.log("  \(name): finished")
    return "\(name): finished"
}

func example1NestedTaskUnstructured() async {
    await logger.log("\n=== 1: nested Task (unstructured) ===")

    let parent = Task {
        let child = Task {
            _ = await load(name: "child")
        }
        _ = await load(name: "parent-body")
        _ = await child.value
    }

    try? await Task.sleep(for: .milliseconds(120))
    parent.cancel()
    try? await Task.sleep(for: .milliseconds(800))
    await logger.log("  expect: parent-body cancelled, child may still run")
}

func example2AsyncLetStructured() async {
    await logger.log("\n=== 2: async let (structured) ===")

    let parent = Task {
        async let first = load(name: "async-let-b")
        async let second = load(name: "async-let-c")
        _ = await (first, second)
    }

    try? await Task.sleep(for: .milliseconds(120))
    parent.cancel()
    try? await Task.sleep(for: .milliseconds(800))
    await logger.log("  expect: async-let-b and async-let-c cancelled")
}

func example3TaskGroupStructured() async {
    await logger.log("\n=== 3: withTaskGroup (structured) ===")

    let parent = Task {
        await withTaskGroup(of: String.self) { group in
            group.addTask { await load(name: "group-b") }
            group.addTask { await load(name: "group-c") }
            for await result in group {
                await logger.log("  group received: \(result)")
            }
        }
    }

    try? await Task.sleep(for: .milliseconds(120))
    parent.cancel()
    try? await Task.sleep(for: .milliseconds(800))
    await logger.log("  expect: group-b and group-c cancelled")
}

func example4ManualCancellationForwarding() async {
    await logger.log("\n=== 4: manual cancellation forwarding ===")

    let parent = Task {
        let child = Task {
            _ = await load(name: "manual-child")
        }

        await withTaskCancellationHandler {
            _ = await child.value
        } onCancel: {
            child.cancel()
        }
    }

    try? await Task.sleep(for: .milliseconds(120))
    parent.cancel()
    try? await Task.sleep(for: .milliseconds(800))
    await logger.log("  expect: manual-child cancelled via onCancel")
}

func example5AsyncLetDiscardedResult() async {
    await logger.log("\n=== 5: async let with discarded result ===")

    let parent = Task {
        async let _ = load(name: "discarded")
        try? await Task.sleep(for: .milliseconds(200))
    }

    try? await Task.sleep(for: .milliseconds(120))
    parent.cancel()
    try? await Task.sleep(for: .milliseconds(800))
    await logger.log("  expect: discarded subtask cancelled on parent exit")
}

func example6ClosureVersusTask() async {
    await logger.log("\n=== 6: closure vs Task ===")

    let work: () async -> Void = {
        _ = await load(name: "closure-work")
    }

    let parent = Task {
        await work()
        if !Task.isCancelled {
            await logger.log("  closure finished inside parent context")
        }
    }

    try? await Task.sleep(for: .milliseconds(120))
    parent.cancel()
    try? await Task.sleep(for: .milliseconds(800))
    await logger.log("  expect: closure-work cancelled with parent (no manual wiring)")
}

Task {
    await example1NestedTaskUnstructured()
    await example2AsyncLetStructured()
    await example3TaskGroupStructured()
    await example4ManualCancellationForwarding()
    await example5AsyncLetDiscardedResult()
    await example6ClosureVersusTask()
    await logger.log("\nDone.")
    PlaygroundPage.current.finishExecution()
}
