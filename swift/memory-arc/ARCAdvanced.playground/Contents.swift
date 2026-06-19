import Foundation
import PlaygroundSupport

/*
 Apple docs:
 - Automatic Reference Counting:
   https://docs.swift.org/swift-book/documentation/the-swift-programming-language/automaticreferencecounting/
 - weak:
   https://developer.apple.com/documentation/swift/weak
 - unowned:
   https://developer.apple.com/documentation/swift/unowned
 - autoreleasepool:
   https://developer.apple.com/documentation/swift/autoreleasepool(_:_:)
*/

PlaygroundPage.current.needsIndefiniteExecution = true

// MARK: - Side Table Deep Dive

print("=== Side Table Deep Dive ===\n")

/*
 Side Table:
 - Created automatically when an object has weak/unowned references
 - Stores weak reference count separately from strong reference count
 - Allows weak references without affecting object lifetime
 - Object's reference count is stored in the object header
 - Weak references point to Side Table, which points to the object
 */

class Person {
    let name: String
    
    init(name: String) {
        self.name = name
        print("\(name) initialized")
    }
    
    deinit {
        print("\(name) deallocated")
    }
}

// Strong reference - no Side Table needed
var person1: Person? = Person(name: "Alice")
print("Strong reference count: 1")

var person2 = person1
print("Strong reference count: 2")

person1 = nil
print("Strong reference count: 1")

person2 = nil
print("Strong reference count: 0 (deallocated)")

Thread.sleep(forTimeInterval: 0.1)

// Weak reference - Side Table created automatically
print("\n--- Weak Reference (Side Table) ---")
var strongPerson: Person? = Person(name: "Bob")
weak var weakPerson = strongPerson

print("Strong reference exists: \(strongPerson != nil)")
print("Weak reference exists: \(weakPerson != nil)")

strongPerson = nil
print("After strong reference removed:")
print("Strong reference exists: \(strongPerson != nil)")
print("Weak reference exists: \(weakPerson != nil)") // Automatically nil

Thread.sleep(forTimeInterval: 0.1)

// MARK: - Autorelease Pool

print("\n=== Autorelease Pool ===\n")

/*
 Autorelease Pool:
 - Temporarily retains objects before releasing them
 - Objects are added to pool when created with convenience initializers
 - Pool drains at end of run loop iteration
 - Can create custom pools for tight loops to control memory
 */

// Without autorelease pool (objects released at end of run loop)
print("Without explicit autorelease pool:")
for i in 1...5 {
    let temp = Person(name: "Temp\(i)")
    // temp will be autoreleased, not immediately deallocated
}

Thread.sleep(forTimeInterval: 0.2)

// With explicit autorelease pool (objects released immediately)
print("\nWith explicit autorelease pool:")
autoreleasepool {
    for i in 1...5 {
        let temp = Person(name: "Pooled\(i)")
        // temp will be released when pool drains
    }
    print("Pool draining...")
}
print("Pool drained - objects released")

Thread.sleep(forTimeInterval: 0.2)

// Performance optimization: Use autoreleasepool in tight loops
print("\nPerformance optimization example:")
let startTime = Date()
autoreleasepool {
    for i in 1...1000 {
        let _ = String(format: "Number: %d", i)
    }
}
let duration = Date().timeIntervalSince(startTime)
print("Time with autoreleasepool: \(String(format: "%.4f", duration))s")

// MARK: - Complex Retain Cycles

print("\n=== Complex Retain Cycles ===\n")

// Retain Cycle in Closures
class NetworkManager {
    var completionHandler: (() -> Void)?
    
    func fetchData(completion: @escaping () -> Void) {
        // ❌ RETAIN CYCLE: self -> completionHandler -> self
        self.completionHandler = completion
        
        // Simulate async work
        DispatchQueue.global().asyncAfter(deadline: .now() + 0.1) {
            self.completionHandler?()
        }
    }
    
    deinit {
        print("NetworkManager deallocated")
    }
}

var manager: NetworkManager? = NetworkManager()
manager?.fetchData {
    print("Data fetched")
    // This closure captures manager, creating retain cycle
}
manager = nil // ❌ Won't deallocate due to retain cycle

Thread.sleep(forTimeInterval: 0.3)

// ✅ FIX: Use weak self
class SafeNetworkManager {
    var completionHandler: (() -> Void)?
    
    func fetchData(completion: @escaping () -> Void) {
        self.completionHandler = completion
        
        DispatchQueue.global().asyncAfter(deadline: .now() + 0.1) { [weak self] in
            guard let self = self else { return }
            self.completionHandler?()
        }
    }
    
    deinit {
        print("SafeNetworkManager deallocated")
    }
}

var safeManager: SafeNetworkManager? = SafeNetworkManager()
safeManager?.fetchData {
    print("Data fetched safely")
}
safeManager = nil // ✅ Will deallocate properly

Thread.sleep(forTimeInterval: 0.3)

// Retain Cycle with Delegate Pattern
protocol Delegate: AnyObject {
    func didComplete()
}

class Parent {
    weak var delegate: Delegate? // ✅ Use weak to break cycle
    
    func doWork() {
        delegate?.didComplete()
    }
    
    deinit {
        print("Parent deallocated")
    }
}

class Child: Delegate {
    var parent: Parent?
    
    func didComplete() {
        print("Work completed")
    }
    
    deinit {
        print("Child deallocated")
    }
}

var parent: Parent? = Parent()
var child: Child? = Child()
parent?.delegate = child
child?.parent = parent

parent = nil
child = nil // ✅ Both deallocate properly

Thread.sleep(forTimeInterval: 0.2)

// MARK: - Retain Cycles in Async/Await

print("\n=== Retain Cycles in Async/Await ===\n")

@MainActor
class AsyncViewModel {
    var data: String = ""
    
    func loadData() async {
        // ❌ RETAIN CYCLE: self captured strongly in Task
        Task {
            await Task.sleep(nanoseconds: 100_000_000)
            self.data = "Loaded"
        }
    }
    
    deinit {
        print("AsyncViewModel deallocated")
    }
}

var asyncVM: AsyncViewModel? = AsyncViewModel()
Task {
    await asyncVM?.loadData()
}
asyncVM = nil // ❌ May not deallocate immediately

Thread.sleep(forTimeInterval: 0.3)

// ✅ FIX: Use weak self
@MainActor
class SafeAsyncViewModel {
    var data: String = ""
    
    func loadData() async {
        Task { [weak self] in
            guard let self = self else { return }
            await Task.sleep(nanoseconds: 100_000_000)
            self.data = "Loaded"
        }
    }
    
    deinit {
        print("SafeAsyncViewModel deallocated")
    }
}

var safeAsyncVM: SafeAsyncViewModel? = SafeAsyncViewModel()
Task {
    await safeAsyncVM?.loadData()
}
safeAsyncVM = nil // ✅ Will deallocate properly

Thread.sleep(forTimeInterval: 0.3)

// MARK: - Retain Cycles in Combine

print("\n=== Retain Cycles in Combine ===\n")

import Combine

class CombineViewModel: ObservableObject {
    @Published var count = 0
    private var cancellables = Set<AnyCancellable>()
    
    func startTimer() {
        // ❌ RETAIN CYCLE: self captured strongly
        Timer.publish(every: 0.1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.count += 1
            }
            .store(in: &cancellables)
    }
    
    deinit {
        print("CombineViewModel deallocated")
    }
}

var combineVM: CombineViewModel? = CombineViewModel()
combineVM?.startTimer()
combineVM = nil // ✅ Will deallocate (cancellables cleared in deinit)

Thread.sleep(forTimeInterval: 0.3)

// MARK: - Unowned vs Weak

print("\n=== Unowned vs Weak ===\n")

/*
 Weak:
 - Optional reference
 - Automatically becomes nil when object deallocates
 - Use when reference can be nil
 
 Unowned:
 - Non-optional reference
 - Assumes object will outlive the reference
 - Crashes if object deallocates
 - Use when you're certain about lifetime
 */

class Owner {
    var pet: Pet?
    
    deinit {
        print("Owner deallocated")
    }
}

class Pet {
    // ✅ Use unowned when owner always outlives pet
    unowned let owner: Owner
    
    init(owner: Owner) {
        self.owner = owner
    }
    
    deinit {
        print("Pet deallocated")
    }
}

var owner: Owner? = Owner()
var pet: Pet? = Pet(owner: owner!)
owner?.pet = pet

owner = nil
pet = nil // ✅ Both deallocate properly

Thread.sleep(forTimeInterval: 0.2)

print("\n=== ARC Advanced Playground Complete ===")

