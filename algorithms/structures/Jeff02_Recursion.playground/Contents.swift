import Foundation

func factorial(_ n: Int) -> Int {
    if n <= 1 { return 1 }
    return n * factorial(n - 1)
}

func fibonacciMemo(_ n: Int, memo: inout [Int: Int]) -> Int {
    if n <= 1 { return n }
    if let value = memo[n] { return value }
    let value = fibonacciMemo(n - 1, memo: &memo) + fibonacciMemo(n - 2, memo: &memo)
    memo[n] = value
    return value
}

var memo = [Int: Int]()
print(factorial(6))
print(fibonacciMemo(10, memo: &memo))
