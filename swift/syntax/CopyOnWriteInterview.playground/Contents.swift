import Foundation

// Question:
// What is Copy-on-Write in Swift collections?
//
// Answer:
// In standard Swift value types (Array, Dictionary, Set, String),
// multiple values can share the same storage for read access.
// A real copy is created only when one of the values mutates shared storage.
// This preserves value semantics while reducing unnecessary allocations.
//
// Typical pitfalls:
// 1) Assuming array assignment always performs an expensive deep copy.
// 2) Forgetting that mutating non-unique storage triggers an actual copy.
// 3) Passing large collections across layers and mutating each copy aggressively.
//
// Example 1: Array behavior
var a = [1, 2, 3]
var b = a

print("Before mutation:")
print("a =", a, "b =", b)

b.append(4)

print("After b.append(4):")
print("a =", a, "b =", b)

// Example 2: Conceptual custom CoW box with uniqueness check
final class Storage {
    var values: [Int]

    init(values: [Int]) {
        self.values = values
    }
}

struct CoWArray {
    private var storage: Storage

    init(_ values: [Int]) {
        storage = Storage(values: values)
    }

    mutating func append(_ value: Int) {
        if !isKnownUniquelyReferenced(&storage) {
            storage = Storage(values: storage.values)
        }
        storage.values.append(value)
    }

    var values: [Int] {
        storage.values
    }
}

var first = CoWArray([10, 20, 30])
var second = first

print("Custom CoW before mutation:")
print("first =", first.values, "second =", second.values)

second.append(40)

print("Custom CoW after second.append(40):")
print("first =", first.values, "second =", second.values)

// Conceptual mechanism:
// isKnownUniquelyReferenced checks whether a class instance behind a value wrapper
// has exactly one strong reference.
// If true -> safe to mutate in place.
// If false -> create a new storage copy before mutation to keep value semantics.

// Mini exercise (5 min):
// Implement popLast() for a CoW-backed stack so that it also respects CoW rules.
//
// Task:
// 1) Create CoWStack with shared Storage<[Int]>.
// 2) Implement push(_:) and popLast().
// 3) Ensure both mutating methods perform uniqueness check before mutation.
// 4) Verify that mutating a copied stack does not affect the original.

final class StackStorage {
    var values: [Int]

    init(values: [Int]) {
        self.values = values
    }
}

struct CoWStack {
    private var storage: StackStorage

    init(_ values: [Int] = []) {
        storage = StackStorage(values: values)
    }

    mutating func push(_ value: Int) {
        ensureUniqueStorage()
        storage.values.append(value)
    }

    mutating func popLast() -> Int? {
        ensureUniqueStorage()
        return storage.values.popLast()
    }

    var values: [Int] {
        storage.values
    }

    private mutating func ensureUniqueStorage() {
        if !isKnownUniquelyReferenced(&storage) {
            storage = StackStorage(values: storage.values)
        }
    }
}

// Answer check:
var originalStack = CoWStack([1, 2, 3])
var copiedStack = originalStack

copiedStack.push(4)
_ = copiedStack.popLast()
_ = copiedStack.popLast()

print("Exercise result:")
print("originalStack =", originalStack.values) // [1, 2, 3]
print("copiedStack =", copiedStack.values)     // [1, 2]
