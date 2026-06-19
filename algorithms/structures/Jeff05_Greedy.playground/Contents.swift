import Foundation

typealias Interval = (start: Int, end: Int)

func selectMaxNonOverlapping(_ intervals: [Interval]) -> [Interval] {
    let sorted = intervals.sorted { lhs, rhs in
        if lhs.end == rhs.end { return lhs.start < rhs.start }
        return lhs.end < rhs.end
    }
    var result = [Interval]()
    var currentEnd = Int.min
    for interval in sorted where interval.start >= currentEnd {
        result.append(interval)
        currentEnd = interval.end
    }
    return result
}

let intervals: [Interval] = [(1, 3), (2, 4), (3, 5), (0, 7), (5, 8), (8, 9)]
print(selectMaxNonOverlapping(intervals))
