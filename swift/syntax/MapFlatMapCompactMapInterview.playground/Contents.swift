import Foundation

/*
 Q&A — map, flatMap, compactMap (Swift collections)

 Swift book — Collection:
 https://docs.swift.org/swift-book/documentation/the-swift-programming-language/collectiontypes/

 Thesis: map transforms 1→1; compactMap maps + drops nil; flatMap maps to a sequence and flattens one level.
*/

print("=== map — same count ===")
let numbers = [1, 2, 3]
let doubled = numbers.map { $0 * 2 }
print(doubled)

print("\n=== map — Optional trap ===")
let strings = ["1", "2", "3"]
let optionalInts = strings.map { Int($0) }
print(optionalInts)

print("\n=== compactMap — drop failed parses ===")
let values = ["1", "x", "3"]
let parsed = values.compactMap { Int($0) }
print(parsed)

print("\n=== map vs compactMap ===")
let mixed = ["1", "x"]
print("map:", mixed.map(Int.init))
print("compactMap:", mixed.compactMap(Int.init))

print("\n=== flatMap — flatten nested arrays ===")
let groups = [[1, 2], [3, 4]]
let flattened = groups.flatMap { $0 }
print(flattened)

print("\n=== map vs flatMap on String characters ===")
let words = ["Hi", "Swift"]
let nestedChars = words.map { Array($0) }
let flatChars = words.flatMap { Array($0) }
print("map (nested):", nestedChars)
print("flatMap (flat):", flatChars)

print("\n=== Optional.map / flatMap ===")
let present: Int? = 10
let absent: Int? = nil
print("map:", present.map { $0 * 2 }, absent.map { $0 * 2 })
print("flatMap bind:", present.flatMap { Optional($0 + 1) })

print("\n=== reduce ===")
let sum = [1, 2, 3, 4].reduce(0, +)
let doubledInto = [1, 2, 3].reduce(into: [Int]()) { $0.append($1 * 2) }
print("sum:", sum)
print("reduce(into:):", doubledInto)

print("\n=== lazy chain (no eager arrays) ===")
let lazyResult = (1...1_000_000).lazy.map { $0 * 2 }.filter { $0 < 10 }
print("first lazy match:", lazyResult.first(where: { _ in true }) ?? -1)
