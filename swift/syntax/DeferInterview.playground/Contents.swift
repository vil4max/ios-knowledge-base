import Foundation

/*
 Q&A cards — Q9 (defer)

 Swift book — defer:
 https://docs.swift.org/swift-book/documentation/the-swift-programming-language/deferstatement/

 Thesis: defer schedules cleanup at scope exit (return, throw), LIFO if stacked.
*/

print("=== LIFO order ===")
func demoLIFO() {
    defer { print("defer A") }
    defer { print("defer B") }
    print("body")
}
demoLIFO()

print("\n=== Early return still runs defer ===")
func earlyReturn(fail: Bool) -> String {
    let lock = NSLock()
    lock.lock()
    defer { lock.unlock(); print("released lock") }
    if fail {
        return "fail"
    }
    return "ok"
}
print(earlyReturn(fail: true))
print(earlyReturn(fail: false))
