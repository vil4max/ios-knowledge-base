import Foundation
import PlaygroundSupport

/*
 Q&A cards — Theme 4 URLSession / HTTP client basics (Q29, Q30 refresh demo, Q31, Q32, Q34A–H subset, Q45)

 URLSession:
 https://developer.apple.com/documentation/foundation/urlsession

 Background configuration:
 https://developer.apple.com/documentation/foundation/urlsessionconfiguration/backgroundsessionconfiguration(withidentifier:)

 URLCache:
 https://developer.apple.com/documentation/foundation/urlcache
*/

struct HTTPClient {
    let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func get(_ url: URL) async throws -> (data: Data, status: Int) {
        let (data, response) = try await session.data(from: url)
        guard let http = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        return (data, http.statusCode)
    }
}

enum ClientBootstrap {
    static func defaultCacheMegabytes(_ megabytes: Int) -> URLCache {
        let bytes = megabytes * 1024 * 1024
        return URLCache(memoryCapacity: bytes / 4, diskCapacity: bytes, diskPath: "gd_prep_cache")
    }

    static func backgroundSession(identifier: String) -> URLSession {
        let configuration = URLSessionConfiguration.background(withIdentifier: identifier)
        configuration.isDiscretionary = false
        configuration.sessionSendsLaunchEvents = true
        return URLSession(configuration: configuration)
    }
}

/*
 Q30 — refresh token without refresh storm (single-flight).

 Idea:
 - Many concurrent API calls see 401 because access token expired.
 - Only one refresh POST runs; others await the same Task and reuse the new access token.
 - Production: persist tokens in Keychain; here we use an actor as “in-memory Keychain” for clarity.

 Flow:
 1. authorizedGET builds Authorization header from TokenStore.
 2. MockAuthBackend returns 401 if access does not match server expectation.
 3. NeedsRefresh triggers TokenRefreshCoordinator.refreshIfNeeded(): if refresh already running, await it.
 4. After refresh, TokenStore updates access; caller retries once.
*/

private enum AuthHTTPError: Error {
    case unauthorized
    case refreshDenied
}

private struct OAuthTokens: Sendable {
    var access: String
    var refresh: String
}

private actor TokenStore {
    private var tokens: OAuthTokens
    init(tokens: OAuthTokens) {
        self.tokens = tokens
    }
    func snapshot() -> OAuthTokens {
        tokens
    }
    func applyAccess(_ access: String) {
        tokens = OAuthTokens(access: access, refresh: tokens.refresh)
    }
}

private actor MockAuthBackend {
    private var expectedAccess: String
    private(set) var refreshInvocationCount = 0
    init(expectedAccess: String) {
        self.expectedAccess = expectedAccess
    }
    func setExpectedAccess(_ value: String) {
        expectedAccess = value
    }
    func dataAuthorized(withAccess access: String?) -> (status: Int, body: String) {
        guard access == expectedAccess else {
            return (401, "expired_or_wrong_access")
        }
        return (200, "payload")
    }
    func refresh(refreshToken: String) async throws -> OAuthTokens {
        refreshInvocationCount += 1
        try await Task.sleep(nanoseconds: 80_000_000)
        guard refreshToken == "demo_refresh" else {
            throw AuthHTTPError.refreshDenied
        }
        let nextAccess = "access_after_refresh_\(refreshInvocationCount)"
        setExpectedAccess(nextAccess)
        return OAuthTokens(access: nextAccess, refresh: refreshToken)
    }
}

private actor TokenRefreshCoordinator {
    private var inFlight: Task<OAuthTokens, Error>?
    func refreshIfNeeded(
        store: TokenStore,
        backend: MockAuthBackend,
        refreshExecutor: @Sendable @escaping (String) async throws -> OAuthTokens
    ) async throws -> OAuthTokens {
        if let inFlight {
            return try await inFlight.value
        }
        let snapshot = await store.snapshot()
        let task = Task {
            try await refreshExecutor(snapshot.refresh)
        }
        inFlight = task
        defer {
            inFlight = nil
        }
        let fresh = try await task.value
        await store.applyAccess(fresh.access)
        return fresh
    }
}

private struct NeedsRefresh: Error {}

private struct AuthenticatedAPIClient: Sendable {
    let store: TokenStore
    let backend: MockAuthBackend
    let coordinator: TokenRefreshCoordinator
    func authorizedGET() async throws -> String {
        try await sendOnce()
    }
    private func sendOnce() async throws -> String {
        let access = await store.snapshot().access
        let response = await backend.dataAuthorized(withAccess: access)
        guard response.status == 200 else {
            throw NeedsRefresh()
        }
        return response.body
    }
    func authorizedGETWithAutoRefresh() async throws -> String {
        do {
            return try await sendOnce()
        } catch is NeedsRefresh {
            _ = try await coordinator.refreshIfNeeded(store: store, backend: backend) { refresh in
                try await backend.refresh(refreshToken: refresh)
            }
            return try await sendOnce()
        }
    }
}

private func runRefreshStormDemo() async {
    let backend = MockAuthBackend(expectedAccess: "server_expected_access")
    let store = TokenStore(tokens: OAuthTokens(access: "stale_access", refresh: "demo_refresh"))
    let coordinator = TokenRefreshCoordinator()
    let client = AuthenticatedAPIClient(store: store, backend: backend, coordinator: coordinator)
    await withTaskGroup(of: Void.self) { group in
        for index in 0 ..< 8 {
            group.addTask {
                do {
                    let body = try await client.authorizedGETWithAutoRefresh()
                    print("Q30 demo task \(index) OK:", body)
                } catch {
                    print("Q30 demo task \(index) error:", error)
                }
            }
        }
    }
    let count = await backend.refreshInvocationCount
    print("Q30 demo: refresh calls on backend = \(count) (expect 1)")
}

print("URLCache sample:", ClientBootstrap.defaultCacheMegabytes(20))
print("Background session created:", ClientBootstrap.backgroundSession(identifier: "com.example.study.networking.bg"))

PlaygroundPage.current.needsIndefiniteExecution = true

Task {
    await runRefreshStormDemo()
    let client = HTTPClient()
    let url = URL(string: "https://example.com")!
    do {
        let result = try await client.get(url)
        print("GET example.com status:", result.status, "bytes:", result.data.count)
    } catch {
        print("GET failed (offline sandbox is OK):", error.localizedDescription)
    }
    PlaygroundPage.current.finishExecution()
}
