import Foundation

/*
 Apple docs:
 - The Swift Programming Language (Swift book):
   https://docs.swift.org/swift-book/
 - Structures and Classes (value vs reference semantics basics):
   https://docs.swift.org/swift-book/documentation/the-swift-programming-language/classesandstructures/
 - MemoryLayout:
   https://developer.apple.com/documentation/swift/memorylayout
*/

// MARK: - Reference vs Value Semantics

print("=== Reference vs Value Semantics ===\n")

// Value Type: Struct
struct Point {
    var x: Int
    var y: Int
}

var point1 = Point(x: 10, y: 20)
var point2 = point1 // Copy created

point2.x = 30

print("Point1: (\(point1.x), \(point1.y))") // (10, 20) - unchanged
print("Point2: (\(point2.x), \(point2.y))") // (30, 20) - modified
print("✅ Value types create independent copies\n")

// Reference Type: Class
class Person {
    var name: String
    var age: Int
    
    init(name: String, age: Int) {
        self.name = name
        self.age = age
    }
}

var person1 = Person(name: "Alice", age: 30)
var person2 = person1 // Reference copied, not object

person2.name = "Bob"

print("Person1 name: \(person1.name)") // "Bob" - changed!
print("Person2 name: \(person2.name)") // "Bob" - same reference
print("✅ Reference types share the same instance\n")

// MARK: - When to Use Value vs Reference Types

print("=== When to Use Value vs Reference Types ===\n")

// ✅ Use Value Types (Structs) for:
// - Simple data models
// - Immutable data
// - When you want copy semantics
// - When identity doesn't matter

struct Money {
    var amount: Decimal
    var currency: String
}

var wallet1 = Money(amount: 100, currency: "USD")
var wallet2 = wallet1 // Independent copy

wallet2.amount = 200

print("Wallet1: \(wallet1.amount) \(wallet1.currency)")
print("Wallet2: \(wallet2.amount) \(wallet2.currency)")
print("✅ Each wallet is independent\n")

// ✅ Use Reference Types (Classes) for:
// - When identity matters
// - When you need shared mutable state
// - When you need inheritance
// - When you need deinitializers

class BankAccount {
    var balance: Decimal = 0
    let accountNumber: String
    
    init(accountNumber: String) {
        self.accountNumber = accountNumber
    }
    
    func deposit(_ amount: Decimal) {
        balance += amount
    }
    
    func withdraw(_ amount: Decimal) -> Bool {
        guard balance >= amount else { return false }
        balance -= amount
        return true
    }
}

let account = BankAccount(accountNumber: "12345")
let accountRef1 = account
let accountRef2 = account

accountRef1.deposit(100)
print("Account balance via ref1: \(account.balance)")
accountRef2.deposit(50)
print("Account balance via ref2: \(account.balance)")
print("✅ All references point to same account\n")

// MARK: - Heap vs Stack

print("=== Heap vs Stack ===\n")

/*
 Stack:
 - Fast allocation/deallocation
 - Limited size (~8MB on macOS)
 - LIFO (Last In First Out)
 - Value types stored here (usually)
 - Automatic memory management
 
 Heap:
 - Slower allocation/deallocation
 - Larger size (limited by system memory)
 - Reference types stored here
 - Managed by ARC
 - Can cause fragmentation
 */

// Value types are typically on the stack
struct StackValue {
    var number: Int
    var text: String
}

let stackValue = StackValue(number: 42, text: "Hello")
print("StackValue size: \(MemoryLayout<StackValue>.size) bytes")
print("StackValue stored on stack (typically)\n")

// Reference types are on the heap
class HeapValue {
    var number: Int
    var text: String
    
    init(number: Int, text: String) {
        self.number = number
        self.text = text
    }
}

let heapValue = HeapValue(number: 42, text: "Hello")
print("HeapValue reference size: \(MemoryLayout.size(ofValue: heapValue)) bytes")
print("HeapValue object stored on heap\n")

// MARK: - Stack Overflow

print("=== Stack Overflow Example ===\n")

func recursiveFunction(_ depth: Int) {
    if depth > 0 {
        let localVar = Array(repeating: 0, count: 1000) // Large local variable
        recursiveFunction(depth - 1)
    }
}

// Uncomment to see stack overflow (crashes)
// recursiveFunction(10000)

print("⚠️ Deep recursion with large local variables can cause stack overflow\n")

// MARK: - Memory Layout

print("=== Memory Layout ===\n")

struct SimpleStruct {
    var a: Int8    // 1 byte
    var b: Int16   // 2 bytes
    var c: Int32   // 4 bytes
}

print("SimpleStruct size: \(MemoryLayout<SimpleStruct>.size) bytes")
print("SimpleStruct stride: \(MemoryLayout<SimpleStruct>.stride) bytes")
print("SimpleStruct alignment: \(MemoryLayout<SimpleStruct>.alignment) bytes")

// Alignment: structs are aligned to largest member's alignment
struct AlignedStruct {
    var a: Int8    // 1 byte
    var b: Int64   // 8 bytes (largest)
    var c: Int8    // 1 byte
}

print("\nAlignedStruct size: \(MemoryLayout<AlignedStruct>.size) bytes")
print("AlignedStruct stride: \(MemoryLayout<AlignedStruct>.stride) bytes")
print("AlignedStruct alignment: \(MemoryLayout<AlignedStruct>.alignment) bytes")
print("Note: Padding added for alignment\n")

// MARK: - Copy Performance

print("=== Copy Performance ===\n")

func measureCopyTime<T>(_ value: T, operation: (T) -> Void) -> TimeInterval {
    let start = Date()
    operation(value)
    return Date().timeIntervalSince(start)
}

// Small struct copy
struct SmallStruct {
    var a: Int
    var b: Int
    var c: Int
}

let small = SmallStruct(a: 1, b: 2, c: 3)
let smallCopyTime = measureCopyTime(small) { _ in
    var copy = $0
    copy.a = 10
}

print("Small struct copy time: \(String(format: "%.9f", smallCopyTime))s")

// Large struct copy
struct LargeStruct {
    var data: [Int]
    
    init(size: Int) {
        self.data = Array(1...size)
    }
}

let large = LargeStruct(size: 1000)
let largeCopyTime = measureCopyTime(large) { _ in
    var copy = $0
    copy.data[0] = 10
}

print("Large struct copy time: \(String(format: "%.9f", largeCopyTime))s")
print("⚠️ Large value types can be expensive to copy\n")

// MARK: - Reference Counting

print("=== Reference Counting ===\n")

class ReferenceCounted {
    init() {
        print("ReferenceCounted initialized")
    }
    
    deinit {
        print("ReferenceCounted deallocated")
    }
}

print("Creating reference:")
var ref1: ReferenceCounted? = ReferenceCounted() // Reference count: 1

print("Adding another reference:")
var ref2 = ref1 // Reference count: 2

print("Removing first reference:")
ref1 = nil // Reference count: 1

print("Removing second reference:")
ref2 = nil // Reference count: 0 -> deallocated

// MARK: - Copy-on-Write vs Regular Copy

print("\n=== Copy-on-Write vs Regular Copy ===\n")

// Array uses CoW
var array1 = Array(1...1000)
var array2 = array1 // No copy yet (CoW)

print("Array assignment: O(1) due to CoW")

// Struct always copies
struct DataContainer {
    var items: [Int]
}

var container1 = DataContainer(items: Array(1...1000))
var container2 = container1 // Copy happens immediately

print("Struct assignment: O(n) - full copy")
print("⚠️ Large structs with arrays copy the array immediately\n")

// MARK: - Performance Considerations

print("\n=== Performance Considerations ===\n")

// ✅ Good: Small value types
struct Coordinate {
    var x: Double
    var y: Double
}

// ✅ Good: Use references for large shared data
class LargeData {
    var data: [Int]
    
    init(size: Int) {
        self.data = Array(1...size)
    }
}

// ✅ Good: Use value types for independent copies
struct UserPreferences {
    var theme: String
    var language: String
}

// ❌ Avoid: Large value types that are frequently copied
struct LargeValueType {
    var data1: [Int]
    var data2: [String]
    var data3: [Double]
}

print("✅ Use value types for small, independent data")
print("✅ Use reference types for large, shared data")
print("✅ Consider CoW for large value types\n")

// MARK: - Real-World Decision Making

print("=== Real-World Decision Making ===\n")

// Example: Configuration
struct AppConfig {
    var apiURL: String
    var timeout: TimeInterval
    var retryCount: Int
}
// ✅ Struct: Small, independent, value semantics

// Example: Network Manager
class NetworkManager {
    private var session: URLSession
    private var cache: [String: Data] = [:]
    
    init() {
        self.session = URLSession.shared
    }
}
// ✅ Class: Shared state, identity matters, needs lifecycle

// Example: View Model
@MainActor
class ViewModel: ObservableObject {
    @Published var state: ViewState
    
    init(state: ViewState) {
        self.state = state
    }
}
// ✅ Class: Needs @MainActor, ObservableObject, shared state

struct ViewState {
    var isLoading: Bool
    var data: [String]
    var error: String?
}
// ✅ Struct: Simple state container

print("✅ Choose based on semantics, not just performance")
print("✅ Value types: independence, immutability")
print("✅ Reference types: shared state, identity, lifecycle\n")

print("=== Swift Core Playground Complete ===")




