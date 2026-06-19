import Combine
import Dispatch
import Foundation
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

func banner(_ title: String) {
    let line = String(repeating: "=", count: 56)
    print("\n\(line)\n\(title)\n\(line)")
}

// -----------------------------------------------------------------------------
// 1) Thread — you own a long-lived OS thread; you coordinate back to main.
// -----------------------------------------------------------------------------
func example1Thread() {
    banner("1) Thread")
    print("caller is main thread:", Thread.isMainThread)
    let done = DispatchSemaphore(value: 0)
    let worker = Thread {
        print("inside Thread block, is main:", Thread.isMainThread)
        let result = "payload".uppercased()
        Thread.sleep(forTimeInterval: 0.05)
        DispatchQueue.main.async {
            print("hop to main with result:", result, "is main:", Thread.isMainThread)
            done.signal()
        }
    }
    worker.name = "evolution-demo-thread"
    worker.start()
    _ = done.wait(timeout: .now() + 5)
}

// -----------------------------------------------------------------------------
// 2) RunLoop — timers and sources need the run loop spun on that thread.
// -----------------------------------------------------------------------------
func example2RunLoop() {
    banner("2) RunLoop + Thread")
    let done = DispatchSemaphore(value: 0)
    Thread {
        print("timer thread, is main:", Thread.isMainThread)
        _ = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false) { _ in
            print("timer fired (RunLoop was running)")
            done.signal()
        }
        RunLoop.current.run(until: Date(timeIntervalSinceNow: 0.35))
    }.start()
    _ = done.wait(timeout: .now() + 5)
}

// -----------------------------------------------------------------------------
// 3) GCD — submit blocks to serial/concurrent queues; system maps to threads.
// -----------------------------------------------------------------------------
func example3GCD() {
    banner("3) GCD (DispatchQueue)")
    let done = DispatchSemaphore(value: 0)
    DispatchQueue.global(qos: .userInitiated).async {
        print("global queue, is main:", Thread.isMainThread)
        let result = "gcd".uppercased()
        Thread.sleep(forTimeInterval: 0.05)
        DispatchQueue.main.async {
            print("main queue callback, result:", result, "is main:", Thread.isMainThread)
            done.signal()
        }
    }
    _ = done.wait(timeout: .now() + 5)
}

// -----------------------------------------------------------------------------
// 4) OperationQueue — object-oriented units, dependencies, cancellation hooks.
// -----------------------------------------------------------------------------
func example4Operation() {
    banner("4) Operation / OperationQueue")
    let queue = OperationQueue()
    queue.maxConcurrentOperationCount = 2
    let fetch = BlockOperation {
        print("fetch op, is main:", Thread.isMainThread)
        Thread.sleep(forTimeInterval: 0.05)
    }
    let parse = BlockOperation {
        print("parse op (runs after fetch), is main:", Thread.isMainThread)
    }
    parse.addDependency(fetch)
    queue.addOperations([fetch, parse], waitUntilFinished: true)
    print("all operations finished")
}

// -----------------------------------------------------------------------------
// 5) Callback style — inversion of control; thread of completion is manual.
// -----------------------------------------------------------------------------
func example5Callback() {
    banner("5) Callback completion handler")
    func loadUppercased(_ completion: @escaping (String) -> Void) {
        DispatchQueue.global(qos: .utility).async {
            let value = "callback".uppercased()
            Thread.sleep(forTimeInterval: 0.05)
            DispatchQueue.main.async {
                completion(value)
            }
        }
    }
    let done = DispatchSemaphore(value: 0)
    loadUppercased { result in
        print("completion on main:", Thread.isMainThread, "value:", result)
        done.signal()
    }
    _ = done.wait(timeout: .now() + 5)
}

// -----------------------------------------------------------------------------
// 6) Combine — stream operators; scheduling still uses DispatchQueue / RunLoop.
// -----------------------------------------------------------------------------
func example6Combine() {
    banner("6) Combine")
    var cancellables = Set<AnyCancellable>()
    let done = DispatchSemaphore(value: 0)
    Just("combine")
        .subscribe(on: DispatchQueue.global(qos: .userInitiated))
        .map { $0.uppercased() }
        .delay(for: .milliseconds(30), scheduler: DispatchQueue.global(qos: .utility))
        .receive(on: DispatchQueue.main)
        .sink { result in
            print("sink on main:", Thread.isMainThread, "value:", result)
            done.signal()
        }
        .store(in: &cancellables)
    _ = done.wait(timeout: .now() + 5)
}

// -----------------------------------------------------------------------------
// 7) Swift Concurrency — async/await, actors, MainActor; compiler tracks hops.
// -----------------------------------------------------------------------------
actor UppercasingBox {
    func upper(_ text: String) async -> String {
        try? await Task.sleep(for: .milliseconds(40))
        return text.uppercased()
    }
}

@MainActor
func printOnMain(_ message: String) {
    print("MainActor log, is main:", Thread.isMainThread, "→", message)
}

func example7SwiftConcurrency() async {
    banner("7) Swift Concurrency (async / actor / MainActor)")
    print("top of async demo, is main:", Thread.isMainThread)
    let box = UppercasingBox()
    let value = await box.upper("swift")
    await printOnMain(value)
}

func runSequentialLegacyExamples() {
    example1Thread()
    example2RunLoop()
    example3GCD()
    example4Operation()
    example5Callback()
    example6Combine()
}

runSequentialLegacyExamples()

Task {
    await example7SwiftConcurrency()
    print("\nDone. Close timeline or stop playground when finished.")
    PlaygroundPage.current.finishExecution()
}
