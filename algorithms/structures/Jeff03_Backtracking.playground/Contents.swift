import Foundation

func subsets(_ nums: [Int]) -> [[Int]] {
    var result = [[Int]]()
    var current = [Int]()

    func dfs(_ index: Int) {
        if index == nums.count {
            result.append(current)
            return
        }
        dfs(index + 1)
        current.append(nums[index])
        dfs(index + 1)
        _ = current.popLast()
    }

    dfs(0)
    return result
}

print(subsets([1, 2, 3]))
