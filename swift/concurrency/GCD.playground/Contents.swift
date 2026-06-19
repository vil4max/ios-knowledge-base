import Foundation
import PlaygroundSupport

/*
 Apple docs:
 - DispatchQueue:
   https://developer.apple.com/documentation/dispatch/dispatchqueue
 - DispatchGroup:
   https://developer.apple.com/documentation/dispatch/dispatchgroup
 - DispatchSemaphore:
   https://developer.apple.com/documentation/dispatch/dispatchsemaphore
 - DispatchWorkItem:
   https://developer.apple.com/documentation/dispatch/dispatchworkitem
 - QoS:
   https://developer.apple.com/documentation/dispatch/dispatchqos
*/

PlaygroundPage.current.needsIndefiniteExecution = true

// MARK: - Serial vs Concurrent Queues

print("=== Serial vs Concurrent Queues ===\n")

// Serial Queue: Tasks execute one at a time, in order
let serialQueue = DispatchQueue(label: "com.learning.serial")

// Concurrent Queue: Tasks can execute simultaneously
let concurrentQueue = DispatchQueue(label: "com.learning.concurrent", attributes: .concurrent)

// Example: Serial Queue
print("Serial Queue Execution:")
serialQueue.async {
    print("Task 1 started")
    Thread.sleep(forTimeInterval: 0.1)
    print("Task 1 completed")
}

serialQueue.async {
    print("Task 2 started")
    Thread.sleep(forTimeInterval: 0.1)
    print("Task 2 completed")
}

serialQueue.async {
    print("Task 3 started")
    Thread.sleep(forTimeInterval: 0.1)
    print("Task 3 completed")
}

Thread.sleep(forTimeInterval: 0.5)

// Example: Concurrent Queue
print("\nConcurrent Queue Execution:")
concurrentQueue.async {
    print("Task A started")
    Thread.sleep(forTimeInterval: 0.1)
    print("Task A completed")
}

concurrentQueue.async {
    print("Task B started")
    Thread.sleep(forTimeInterval: 0.1)
    print("Task B completed")
}

concurrentQueue.async {
    print("Task C started")
    Thread.sleep(forTimeInterval: 0.1)
    print("Task C completed")
}

Thread.sleep(forTimeInterval: 0.5)

// MARK: - Quality of Service (QoS)

print("\n=== Quality of Service (QoS) ===\n")

let qosLevels: [DispatchQoS.QoSClass] = [
    .userInteractive,  // Highest priority - UI updates
    .userInitiated,    // User-initiated work
    .default,          // Default priority
    .utility,          // Background work
    .background        // Lowest priority - maintenance tasks
]

for qos in qosLevels {
    let queue = DispatchQueue(label: "com.learning.qos.\(qos)", qos: qos)
    queue.async {
        print("Executing on \(qos) queue")
    }
}

Thread.sleep(forTimeInterval: 0.3)

// MARK: - DispatchGroup

print("\n=== DispatchGroup ===\n")

let group = DispatchGroup()
let workQueue = DispatchQueue(label: "com.learning.work", attributes: .concurrent)

for i in 1...5 {
    group.enter()
    workQueue.async {
        print("Task \(i) started")
        Thread.sleep(forTimeInterval: Double.random(in: 0.1...0.3))
        print("Task \(i) completed")
        group.leave()
    }
}

group.notify(queue: .main) {
    print("\nAll tasks completed!")
}

group.wait() // Wait for all tasks to complete

// MARK: - DispatchSemaphore

print("\n=== DispatchSemaphore (Resource Limiting) ===\n")

let semaphore = DispatchSemaphore(value: 2) // Allow max 2 concurrent tasks
let semaphoreQueue = DispatchQueue(label: "com.learning.semaphore", attributes: .concurrent)

for i in 1...5 {
    semaphoreQueue.async {
        semaphore.wait() // Decrement count
        defer { semaphore.signal() } // Increment count when done
        
        print("Resource \(i) acquired")
        Thread.sleep(forTimeInterval: 0.2)
        print("Resource \(i) released")
    }
}

Thread.sleep(forTimeInterval: 1.0)

// MARK: - DispatchWorkItem

print("\n=== DispatchWorkItem (Cancellable Tasks) ===\n")

let workItem = DispatchWorkItem {
    print("This work item should execute")
}

let cancellableWorkItem = DispatchWorkItem {
    print("This work item should NOT execute")
}

let workItemQueue = DispatchQueue(label: "com.learning.workitem")

workItemQueue.async(execute: workItem)
workItemQueue.async(execute: cancellableWorkItem)

cancellableWorkItem.cancel() // Cancel before execution

Thread.sleep(forTimeInterval: 0.2)

// MARK: - Deadlock Prevention

print("\n=== Deadlock Prevention ===\n")

// ❌ DEADLOCK EXAMPLE (commented out to prevent actual deadlock)
/*
let queue1 = DispatchQueue(label: "queue1")
let queue2 = DispatchQueue(label: "queue2")

queue1.sync {
    print("Queue1: Task 1")
    queue2.sync {
        print("Queue2: Task 1")
        queue1.sync { // DEADLOCK! Waiting for queue1 which is blocked
            print("This will never execute")
        }
    }
}
*/

// ✅ SAFE PATTERN: Use async instead of sync
let safeQueue1 = DispatchQueue(label: "safe.queue1")
let safeQueue2 = DispatchQueue(label: "safe.queue2")

safeQueue1.async {
    print("Safe Queue1: Task 1")
    safeQueue2.async {
        print("Safe Queue2: Task 1")
        safeQueue1.async {
            print("Safe Queue1: Task 2 (no deadlock)")
        }
    }
}

Thread.sleep(forTimeInterval: 0.3)

// MARK: - Thread Safety

print("\n=== Thread Safety ===\n")

class UnsafeCounter {
    private var count = 0
    
    func increment() {
        count += 1 // ❌ Not thread-safe
    }
    
    func getCount() -> Int {
        return count
    }
}

class SafeCounter {
    private var count = 0
    private let queue = DispatchQueue(label: "com.learning.counter")
    
    func increment() {
        queue.sync {
            count += 1 // ✅ Thread-safe
        }
    }
    
    func getCount() -> Int {
        return queue.sync { count }
    }
}

let unsafeCounter = UnsafeCounter()
let safeCounter = SafeCounter()

let counterQueue = DispatchQueue(label: "com.learning.counter.test", attributes: .concurrent)

for _ in 1...100 {
    counterQueue.async {
        unsafeCounter.increment()
        safeCounter.increment()
    }
}

Thread.sleep(forTimeInterval: 0.5)

print("Unsafe Counter: \(unsafeCounter.getCount()) (may be incorrect due to race condition)")
print("Safe Counter: \(safeCounter.getCount()) (correct)")

// MARK: - Main Queue vs Background Queue

print("\n=== Main Queue vs Background Queue ===\n")

print("Current thread: \(Thread.isMainThread ? "Main" : "Background")")

DispatchQueue.global(qos: .utility).async {
    print("Background thread: \(Thread.isMainThread ? "Main" : "Background")")
    
    // UI updates must be on main thread
    DispatchQueue.main.async {
        print("Main thread: \(Thread.isMainThread ? "Main" : "Background")")
    }
}

Thread.sleep(forTimeInterval: 0.2)

// MARK: - Advanced: Barrier Tasks

print("\n=== Barrier Tasks (Exclusive Access) ===\n")

let barrierQueue = DispatchQueue(label: "com.learning.barrier", attributes: .concurrent)

// Multiple concurrent reads
for i in 1...5 {
    barrierQueue.async {
        print("Read \(i): Reading data concurrently")
    }
}

// Barrier write - waits for all reads, then executes exclusively
barrierQueue.async(flags: .barrier) {
    print("BARRIER: Writing data (exclusive access)")
    Thread.sleep(forTimeInterval: 0.1)
    print("BARRIER: Write complete")
}

// More reads after barrier
for i in 6...10 {
    barrierQueue.async {
        print("Read \(i): Reading after barrier")
    }
}

Thread.sleep(forTimeInterval: 0.5)

// MARK: - Advanced: Priority Inversion Prevention

print("\n=== Priority Inversion Prevention ===\n")

/*
 Priority Inversion occurs when:
 - High priority task waits for low priority task
 - Medium priority tasks can starve high priority task
 - Solution: Use QoS inheritance or proper queue design
 */

let highPriorityQueue = DispatchQueue(label: "high", qos: .userInteractive)
let mediumPriorityQueue = DispatchQueue(label: "medium", qos: .default)
let lowPriorityQueue = DispatchQueue(label: "low", qos: .utility)

// Simulate priority inversion scenario
lowPriorityQueue.async {
    print("Low priority: Starting work")
    Thread.sleep(forTimeInterval: 0.2)
    print("Low priority: Work complete")
}

highPriorityQueue.async {
    print("High priority: Waiting for low priority...")
    // This demonstrates the problem - high priority blocked by low
    Thread.sleep(forTimeInterval: 0.3)
    print("High priority: Work complete")
}

mediumPriorityQueue.async {
    print("Medium priority: Executing (may starve high priority)")
    Thread.sleep(forTimeInterval: 0.1)
    print("Medium priority: Complete")
}

Thread.sleep(forTimeInterval: 0.6)

// MARK: - Advanced: Concurrent Queue with Synchronization

print("\n=== Concurrent Queue with Synchronization ===\n")

class ThreadSafeDictionary<Key: Hashable, Value> {
    private var dictionary: [Key: Value] = [:]
    private let queue = DispatchQueue(label: "com.learning.dict", attributes: .concurrent)
    
    func get(_ key: Key) -> Value? {
        return queue.sync { dictionary[key] }
    }
    
    func set(_ value: Value, forKey key: Key) {
        queue.async(flags: .barrier) {
            self.dictionary[key] = value
        }
    }
    
    func remove(_ key: Key) {
        queue.async(flags: .barrier) {
            self.dictionary.removeValue(forKey: key)
        }
    }
    
    var count: Int {
        return queue.sync { dictionary.count }
    }
}

let safeDict = ThreadSafeDictionary<String, Int>()

let dictQueue = DispatchQueue(label: "com.learning.dict.test", attributes: .concurrent)

for i in 1...10 {
    dictQueue.async {
        safeDict.set(i, forKey: "key\(i)")
    }
}

Thread.sleep(forTimeInterval: 0.3)
print("Thread-safe dictionary count: \(safeDict.count)")

// MARK: - Advanced: DispatchSource for Monitoring

print("\n=== DispatchSource (File Monitoring) ===\n")

// DispatchSource can monitor files, timers, signals, etc.
let timerSource = DispatchSource.makeTimerSource(queue: DispatchQueue.global())

timerSource.schedule(deadline: .now(), repeating: 1.0)
var count = 0

timerSource.setEventHandler {
    count += 1
    print("Timer tick \(count)")
    
    if count >= 3 {
        timerSource.cancel()
    }
}

timerSource.resume()
Thread.sleep(forTimeInterval: 3.5)

// MARK: - Advanced: Deadlock Scenarios

print("\n=== Deadlock Scenarios ===\n")

// Scenario 1: Main queue sync from main queue
print("Scenario 1: Main queue sync from main queue")
print("❌ This would deadlock:")
print("DispatchQueue.main.sync { /* deadlock */ }")
print("✅ Solution: Use async or different queue\n")

// Scenario 2: Nested sync on same serial queue
print("Scenario 2: Nested sync on same serial queue")
let serialQueue = DispatchQueue(label: "deadlock.test")
print("❌ This would deadlock:")
print("serialQueue.sync { serialQueue.sync { /* deadlock */ } }")
print("✅ Solution: Use async or different queue\n")

// Scenario 3: Circular dependency
print("Scenario 3: Circular dependency")
let queueA = DispatchQueue(label: "queueA")
let queueB = DispatchQueue(label: "queueB")
print("❌ This would deadlock:")
print("queueA.sync { queueB.sync { queueA.sync { /* deadlock */ } } }")
print("✅ Solution: Break the cycle, use async\n")

// Safe pattern demonstration
print("Safe pattern: Async chain")
let safeQueue1 = DispatchQueue(label: "safe1")
let safeQueue2 = DispatchQueue(label: "safe2")

safeQueue1.async {
    print("Safe: Queue1 task 1")
    safeQueue2.async {
        print("Safe: Queue2 task")
        safeQueue1.async {
            print("Safe: Queue1 task 2 (no deadlock)")
        }
    }
}

Thread.sleep(forTimeInterval: 0.3)

// MARK: - Advanced: Work Item Cancellation

print("\n=== Work Item Cancellation ===\n")

let cancellableQueue = DispatchQueue(label: "com.learning.cancellable")

let workItem1 = DispatchWorkItem {
    print("Work item 1: Executing")
}

let workItem2 = DispatchWorkItem {
    print("Work item 2: Executing")
}

let workItem3 = DispatchWorkItem {
    print("Work item 3: Executing")
}

// Cancel before execution
workItem2.cancel()

cancellableQueue.async(execute: workItem1)
cancellableQueue.async(execute: workItem2) // Won't execute
cancellableQueue.async(execute: workItem3)

Thread.sleep(forTimeInterval: 0.2)

// Check cancellation status
print("Work item 1 cancelled: \(workItem1.isCancelled)")
print("Work item 2 cancelled: \(workItem2.isCancelled)")
print("Work item 3 cancelled: \(workItem3.isCancelled)")

// MARK: - Advanced: QoS Inheritance

print("\n=== QoS Inheritance ===\n")

/*
 When you dispatch work to a queue, the QoS can be inherited:
 - If queue has no QoS, inherits from current context
 - If queue has QoS, uses queue's QoS
 - Can override with specific QoS
 */

let inheritedQueue = DispatchQueue(label: "inherited")

inheritedQueue.async(qos: .userInitiated) {
    print("Task with userInitiated QoS")
}

inheritedQueue.async {
    print("Task inheriting QoS from context")
}

Thread.sleep(forTimeInterval: 0.2)

print("\n=== GCD Playground Complete ===")

