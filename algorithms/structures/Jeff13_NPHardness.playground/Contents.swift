import Foundation

func subsetSumBruteforce(_ nums: [Int], target: Int) -> Bool {
    let n = nums.count
    for mask in 0..<(1 << n) {
        var sum = 0
        for i in 0..<n where (mask & (1 << i)) != 0 {
            sum += nums[i]
        }
        if sum == target { return true }
    }
    return false
}

let nums = [3, 7, 11, 15]
print(subsetSumBruteforce(nums, target: 18))
print(subsetSumBruteforce(nums, target: 14))
