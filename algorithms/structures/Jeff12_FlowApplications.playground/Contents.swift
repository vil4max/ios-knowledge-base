import Foundation

func maxBipartiteMatching(_ graph: [[Int]], rightSize: Int) -> Int {
    var matchR = Array(repeating: -1, count: rightSize)

    func tryKuhn(_ left: Int, _ seen: inout [Bool]) -> Bool {
        for right in graph[left] where !seen[right] {
            seen[right] = true
            if matchR[right] == -1 || tryKuhn(matchR[right], &seen) {
                matchR[right] = left
                return true
            }
        }
        return false
    }

    var matches = 0
    for left in 0..<graph.count {
        var seen = Array(repeating: false, count: rightSize)
        if tryKuhn(left, &seen) {
            matches += 1
        }
    }
    return matches
}

let bipartite = [
    [0, 1],
    [1, 2],
    [0]
]
print(maxBipartiteMatching(bipartite, rightSize: 3))
