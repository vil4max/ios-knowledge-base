import Foundation

func minCostClimbingStairs(_ cost: [Int]) -> Int {
    if cost.count <= 2 {
        return min(cost[0], cost[1])
    }
    var dp = cost
    for i in 2..<cost.count {
        dp[i] += min(dp[i - 1], dp[i - 2])
    }
    return min(dp[cost.count - 1], dp[cost.count - 2])
}

print(minCostClimbingStairs([10, 15, 20]))
print(minCostClimbingStairs([1, 100, 1, 1, 1, 100, 1, 1, 100, 1]))
