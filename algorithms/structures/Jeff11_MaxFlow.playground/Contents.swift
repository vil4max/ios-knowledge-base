import Foundation

func maxFlow(_ capacity: [[Int]], source: Int, sink: Int) -> Int {
    let n = capacity.count
    var flow = Array(repeating: Array(repeating: 0, count: n), count: n)
    var result = 0

    while true {
        var parent = Array(repeating: -1, count: n)
        parent[source] = source
        var queue = [source]
        var index = 0

        while index < queue.count && parent[sink] == -1 {
            let node = queue[index]
            index += 1
            for next in 0..<n where parent[next] == -1 && capacity[node][next] - flow[node][next] > 0 {
                parent[next] = node
                queue.append(next)
            }
        }

        if parent[sink] == -1 { break }
        var pushed = Int.max
        var v = sink
        while v != source {
            let u = parent[v]
            pushed = min(pushed, capacity[u][v] - flow[u][v])
            v = u
        }
        v = sink
        while v != source {
            let u = parent[v]
            flow[u][v] += pushed
            flow[v][u] -= pushed
            v = u
        }
        result += pushed
    }

    return result
}

let capacity = [
    [0, 3, 2, 0],
    [0, 0, 1, 2],
    [0, 0, 0, 3],
    [0, 0, 0, 0]
]
print(maxFlow(capacity, source: 0, sink: 3))
