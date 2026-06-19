import Foundation
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

// MARK: - Goal
// This playground demonstrates offline-first sync basics:
// 1) Idempotency-Key on retries (no duplicate creates).
// 2) What goes wrong if retry uses a new key (duplicate create).
// 3) Version conflict (clientVersion vs serverVersion) and resolution.

// MARK: - Domain
struct CreateOrderPayload: Codable, Hashable {
    let productID: String
    let quantity: Int
}

struct Order: Codable, CustomStringConvertible {
    let id: Int
    let payload: CreateOrderPayload

    var description: String {
        "Order(id: \(id), productID: \(payload.productID), qty: \(payload.quantity))"
    }
}

enum NetworkError: Error, CustomStringConvertible {
    case timeoutAfterCommit
    case versionConflict(serverVersion: Int, serverValue: String)

    var description: String {
        switch self {
        case .timeoutAfterCommit:
            return "timeoutAfterCommit"
        case .versionConflict(let serverVersion, let serverValue):
            return "versionConflict(serverVersion: \(serverVersion), serverValue: \"\(serverValue)\")"
        }
    }
}

// MARK: - Pending queue model
struct PendingOperation {
    let id: UUID
    let idempotencyKey: String
    let payload: CreateOrderPayload
    var attemptCount: Int
}

// MARK: - In-memory queue (replace with SQLite/Core Data/SwiftData in app)
final class PendingQueueStore {
    private var operations: [PendingOperation] = []

    func enqueue(_ op: PendingOperation) {
        operations.append(op)
    }

    func dequeueFirst() -> PendingOperation? {
        guard !operations.isEmpty else { return nil }
        return operations.removeFirst()
    }

    var isEmpty: Bool { operations.isEmpty }
}

// MARK: - Mock backend with idempotency support
actor MockOrderServer {
    private var nextOrderID = 1
    private var resultByKey: [String: Order] = [:]
    private var keysThatShouldTimeoutAfterCommit: Set<String> = []

    func markFirstResponseAsLost(for key: String) {
        keysThatShouldTimeoutAfterCommit.insert(key)
    }

    func createOrder(payload: CreateOrderPayload, idempotencyKey: String) async throws -> Order {
        // If key is known, server returns previously committed result.
        if let existing = resultByKey[idempotencyKey] {
            return existing
        }

        // Commit once.
        let order = Order(id: nextOrderID, payload: payload)
        nextOrderID += 1
        resultByKey[idempotencyKey] = order

        // Simulate "request timed out after commit".
        if keysThatShouldTimeoutAfterCommit.contains(idempotencyKey) {
            keysThatShouldTimeoutAfterCommit.remove(idempotencyKey)
            throw NetworkError.timeoutAfterCommit
        }

        return order
    }

    func allCommittedOrders() -> [Order] {
        resultByKey.values.sorted { $0.id < $1.id }
    }
}

// MARK: - Sync worker with retry/backoff
final class SyncWorker {
    private let server: MockOrderServer

    init(server: MockOrderServer) {
        self.server = server
    }

    func process(_ operation: PendingOperation, maxRetries: Int = 3) async {
        var op = operation

        while op.attemptCount < maxRetries {
            op.attemptCount += 1

            do {
                let order = try await server.createOrder(
                    payload: op.payload,
                    idempotencyKey: op.idempotencyKey
                )
                print("✅ Success on attempt \(op.attemptCount): \(order)")
                return
            } catch {
                print("⚠️ Attempt \(op.attemptCount) failed with \(error)")
                if op.attemptCount >= maxRetries {
                    print("❌ Operation failed permanently")
                    return
                }

                // Exponential backoff (simple demo: 0.2s, 0.4s, 0.8s)
                let delayNanos = UInt64(200_000_000 * (1 << (op.attemptCount - 1)))
                try? await Task.sleep(nanoseconds: delayNanos)
            }
        }
    }
}

// MARK: - Demo 1: Correct behavior (same key on retry)
func demoCorrectIdempotencyFlow() async {
    print("=== Demo 1: SAME idempotency key on retries ===")

    let server = MockOrderServer()
    let worker = SyncWorker(server: server)
    let queue = PendingQueueStore()

    // Key generated ONCE when operation is created.
    let stableKey = UUID().uuidString
    await server.markFirstResponseAsLost(for: stableKey)

    queue.enqueue(
        PendingOperation(
            id: UUID(),
            idempotencyKey: stableKey,
            payload: CreateOrderPayload(productID: "book-1", quantity: 1),
            attemptCount: 0
        )
    )

    if let op = queue.dequeueFirst() {
        await worker.process(op)
    }

    let committed = await server.allCommittedOrders()
    print("📦 Committed orders count: \(committed.count)")
    print("📦 Orders: \(committed)")
    print("")
}

// MARK: - Demo 2: Wrong behavior (new key on retry)
func demoWrongRetryFlow() async {
    print("=== Demo 2: NEW idempotency key on retry (wrong) ===")

    let server = MockOrderServer()

    let payload = CreateOrderPayload(productID: "book-2", quantity: 1)
    let firstKey = UUID().uuidString
    await server.markFirstResponseAsLost(for: firstKey)

    do {
        _ = try await server.createOrder(payload: payload, idempotencyKey: firstKey)
    } catch {
        print("⚠️ First request failed with \(error)")
    }

    // Bug: retry uses a new key => server treats it as a brand new operation.
    let wrongRetryKey = UUID().uuidString
    _ = try? await server.createOrder(payload: payload, idempotencyKey: wrongRetryKey)

    let committed = await server.allCommittedOrders()
    print("📦 Committed orders count: \(committed.count)")
    print("📦 Orders: \(committed)")
    print("")
}

// MARK: - Version conflict demo (clientVersion vs serverVersion)
struct ProfileState: CustomStringConvertible {
    let bio: String
    let version: Int

    var description: String {
        "ProfileState(version: \(version), bio: \"\(bio)\")"
    }
}

actor MockProfileServer {
    private var state = ProfileState(bio: "Initial bio", version: 1)

    func fetchProfile() -> ProfileState {
        state
    }

    func externalUpdate(newBio: String) {
        state = ProfileState(bio: newBio, version: state.version + 1)
    }

    func updateProfile(newBio: String, expectedVersion: Int) throws -> ProfileState {
        guard expectedVersion == state.version else {
            throw NetworkError.versionConflict(
                serverVersion: state.version,
                serverValue: state.bio
            )
        }

        state = ProfileState(bio: newBio, version: state.version + 1)
        return state
    }
}

func demoVersionConflictFlow() async {
    print("=== Demo 3: Version conflict + resolve ===")

    let server = MockProfileServer()

    // 1) Client reads profile and remembers version.
    let localSnapshot = await server.fetchProfile()
    print("📥 Client fetched: \(localSnapshot)")

    // 2) Another device updates server state before our save.
    await server.externalUpdate(newBio: "Changed from another device")

    // 3) Client tries to save stale version -> conflict.
    do {
        _ = try await server.updateProfile(
            newBio: "My offline edit",
            expectedVersion: localSnapshot.version
        )
    } catch {
        print("⚠️ Save failed: \(error)")
    }

    // 4) Resolution strategy: refetch latest, decide merge policy, retry.
    // Here we use a simple "client overwrites after refetch" policy for demo.
    let fresh = await server.fetchProfile()
    print("📥 Refetched latest: \(fresh)")

    do {
        let updated = try await server.updateProfile(
            newBio: "My offline edit (resolved)",
            expectedVersion: fresh.version
        )
        print("✅ Resolved and saved: \(updated)")
    } catch {
        print("❌ Unexpected failure on resolve: \(error)")
    }

    let final = await server.fetchProfile()
    print("📦 Final server state: \(final)")
    print("")
}

Task {
    await demoCorrectIdempotencyFlow()
    await demoWrongRetryFlow()
    await demoVersionConflictFlow()
    PlaygroundPage.current.finishExecution()
}
