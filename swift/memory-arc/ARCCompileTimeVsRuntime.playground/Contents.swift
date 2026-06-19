import Foundation

/*
 Q&A cards — Q3 (ARC compile-time vs runtime)

 Swift book — Automatic Reference Counting:
 https://docs.swift.org/swift-book/documentation/the-swift-programming-language/automaticreferencecounting/

 Compile-time: the compiler inserts retain/release (and related lifetime ops) where Swift rules require.
 Runtime: those operations update the strong refcount; at zero the instance is deallocated (`deinit`).
*/

final class Probe {
    let label: String

    init(label: String) {
        self.label = label
        print("init", label)
    }

    deinit {
        print("deinit", label)
    }
}

func scopedSharing() {
    let first = Probe(label: "shared")
    let second = first
    print("inside scope refs:", first.label, second.label)
}

scopedSharing()
print("after scopedSharing")
