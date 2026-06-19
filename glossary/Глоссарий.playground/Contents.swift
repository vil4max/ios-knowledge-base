import Foundation

let glossarySample: [String: String] = [
    "ARC": "compiler-managed retain/release for reference types",
    "Sendable": "marker for values safe across concurrency boundaries",
]

for key in glossarySample.keys.sorted() {
    if let value = glossarySample[key] {
        print("\(key): \(value)")
    }
}
