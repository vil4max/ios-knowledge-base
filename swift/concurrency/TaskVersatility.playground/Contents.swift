import Foundation
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

/*
 This playground demonstrates practical Task patterns:
 1) Task as a future-like value contract
 2) Task as a synchronization point (request deduplication)
 3) Task as an async boundary inside sync callbacks
 4) Task cancellation handling
*/

enum Context {
    @TaskLocal static var requestID: String?
}

actor Logger {
    func log(_ message: String) {
        print(message)
    }
}

let logger = Logger()

func expensiveLoad() async -> Int {
    try? await Task.sleep(for: .milliseconds(600))
    return Int.random(in: 1...9) * 10
}

func example1TaskAsFuture() async {
    await logger.log("\n=== Example 1: Task as future-like contract ===")

    let sharedTask = Task<Int, Never> {
        await logger.log("Producer: started expensive work")
        let value = await expensiveLoad()
        await logger.log("Producer: produced \(value)")
        return value
    }

    async let consumerA: Void = {
        let value = await sharedTask.value
        await logger.log("Consumer A received \(value)")
    }()

    async let consumerB: Void = {
        let value = await sharedTask.value
        await logger.log("Consumer B received \(value)")
    }()

    _ = await (consumerA, consumerB)
}

actor UserService {
    private var inFlightTask: Task<String, Error>?

    func userName() async throws -> String {
        if let inFlightTask {
            return try await inFlightTask.value
        }

        let task = Task<String, Error> {
            try await Task.sleep(for: .milliseconds(500))
            return "Taylor"
        }

        inFlightTask = task
        defer { inFlightTask = nil }
        return try await task.value
    }
}

func example2TaskAsSynchronizer() async {
    await logger.log("\n=== Example 2: Task as synchronization point ===")

    let service = UserService()

    async let first: String = {
        do { return try await service.userName() } catch { return "error: \(error)" }
    }()

    async let second: String = {
        do { return try await service.userName() } catch { return "error: \(error)" }
    }()

    let values = await [first, second]
    await logger.log("Two parallel callers received: \(values)")
    await logger.log("Only one in-flight producer task was required.")
}

final class LegacyButton {
    var onTap: (() -> Void)?

    func simulateTap() {
        onTap?()
    }
}

func loadProfile() async -> String {
    try? await Task.sleep(for: .milliseconds(300))
    return "Profile loaded"
}

func example3AsyncBoundaryFromSyncCallback() async {
    await logger.log("\n=== Example 3: Task as async boundary from sync callback ===")

    let button = LegacyButton()

    button.onTap = {
        // We are in synchronous callback API; Task creates async context.
        Task {
            let requestID = Context.requestID ?? "none"
            let result = await loadProfile()
            await logger.log("Callback bridge result: \(result), requestID=\(requestID)")
        }
    }

    await Context.$requestID.withValue("REQ-42") {
        button.simulateTap()
    }

    // Detached task drops Task Local context.
    let detached = Task.detached {
        let detachedID = Context.requestID ?? "nil"
        return detachedID
    }
    await logger.log("Detached task requestID: \(await detached.value)")
}

func cancellableOperation() async throws -> String {
    for step in 1...6 {
        try Task.checkCancellation()
        try await Task.sleep(for: .milliseconds(150))
        await logger.log("Long operation step \(step)")
    }
    return "done"
}

func example4Cancellation() async {
    await logger.log("\n=== Example 4: Task cancellation ===")

    let task = Task {
        do {
            let result = try await cancellableOperation()
            await logger.log("Operation result: \(result)")
        } catch is CancellationError {
            await logger.log("Operation cancelled gracefully")
        } catch {
            await logger.log("Operation failed: \(error)")
        }
    }

    try? await Task.sleep(for: .milliseconds(450))
    task.cancel()
    _ = await task.result
}

Task {
    await example1TaskAsFuture()
    await example2TaskAsSynchronizer()
    await example3AsyncBoundaryFromSyncCallback()
    await example4Cancellation()

    await logger.log("\n=== Task playground complete ===")
    PlaygroundPage.current.finishExecution()
}
