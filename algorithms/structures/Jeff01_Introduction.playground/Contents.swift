import Foundation

func linearContains(_ array: [Int], target: Int) -> Bool {
    for value in array where value == target {
        return true
    }
    return false
}

func binaryContains(_ array: [Int], target: Int) -> Bool {
    var left = 0
    var right = array.count - 1
    while left <= right {
        let mid = (left + right) / 2
        if array[mid] == target { return true }
        if array[mid] < target {
            left = mid + 1
        } else {
            right = mid - 1
        }
    }
    return false
}

let data = Array(1...32)
print(linearContains(data, target: 31))
print(binaryContains(data, target: 31))
