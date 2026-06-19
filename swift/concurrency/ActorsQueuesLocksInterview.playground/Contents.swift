import Foundation
import PlaygroundSupport
import UIKit

/*
 Shared-state patterns: actor vs serial/concurrent GCD queues vs locks.

 Article (bookmarked): https://livsycode.com/best-practices/actors-vs-queues-vs-locks-in-swift/

 SettingsStore: the article uses queue.async(flags: .barrier) for writes; here writes use
 sync(flags: .barrier) so playground output stays deterministic.

 Run order: synchronous demos first, then actor demo uses Task.
*/

PlaygroundPage.current.needsIndefiniteExecution = true

final class TokenStore {
    private let queue = DispatchQueue(label: "com.example.token-store")
    private var token: String?

    func read() -> String? {
        queue.sync {
            token
        }
    }

    func write(_ newValue: String?) {
        queue.sync {
            token = newValue
        }
    }
}

final class SettingsStore {
    private let queue = DispatchQueue(
        label: "com.example.settings-store",
        attributes: .concurrent
    )
    private var storage: [String: String] = [:]

    func value(for key: String) -> String? {
        queue.sync {
            storage[key]
        }
    }

    func set(_ value: String, for key: String) {
        queue.sync(flags: .barrier) {
            storage[key] = value
        }
    }
}

final class Counter {
    private let lock = NSLock()
    private var value = 0

    func increment() {
        lock.lock()
        defer { lock.unlock() }
        value += 1
    }

    func currentValue() -> Int {
        lock.lock()
        defer { lock.unlock() }
        return value
    }
}

final class NSLockImageCache {
    private let lock = NSLock()
    private var storage: [URL: UIImage] = [:]

    func image(for url: URL) -> UIImage? {
        lock.lock()
        defer { lock.unlock() }
        return storage[url]
    }

    func insert(_ image: UIImage, for url: URL) {
        lock.lock()
        defer { lock.unlock() }
        storage[url] = image
    }
}

#if canImport(Synchronization)
import Synchronization

@available(iOS 18.0, macOS 15.0, *)
final class MutexImageCache {
    private let storage = Mutex<[URL: UIImage]>([:])

    func image(for url: URL) -> UIImage? {
        storage.withLock { dict in
            dict[url]
        }
    }

    func insert(_ image: UIImage, for url: URL) {
        storage.withLock { dict in
            dict[url] = image
        }
    }
}
#endif

actor ActorTokenStore {
    private var token: String?

    func read() -> String? {
        token
    }

    func write(_ newValue: String?) {
        token = newValue
    }
}

print("=== Serial queue (TokenStore) ===")
let tokens = TokenStore()
tokens.write("abc")
print(tokens.read() as Any)

print("\n=== Concurrent queue + barrier (SettingsStore) ===")
let settings = SettingsStore()
settings.set("dark", for: "theme")
print(settings.value(for: "theme") as Any)

print("\n=== NSLock (Counter) ===")
let counter = Counter()
DispatchQueue.concurrentPerform(iterations: 1000) { _ in
    counter.increment()
}
print(counter.currentValue())

print("\n=== NSLock (ImageCache) ===")
let nsLockCache = NSLockImageCache()
let sampleURL = URL(string: "https://example.com/a.png")!
if let img = UIImage(systemName: "photo") {
    nsLockCache.insert(img, for: sampleURL)
    print(nsLockCache.image(for: sampleURL) != nil)

#if canImport(Synchronization)
    if #available(iOS 18.0, macOS 15.0, *) {
        print("\n=== Mutex (Synchronization) ImageCache ===")
        let mutexCache = MutexImageCache()
        mutexCache.insert(img, for: sampleURL)
        print(mutexCache.image(for: sampleURL) != nil)
    }
#endif
}

Task {
    print("\n=== actor (ActorTokenStore) ===")
    let actorStore = ActorTokenStore()
    await actorStore.write("via-actor")
    print(await actorStore.read() as Any)
    PlaygroundPage.current.finishExecution()
}
