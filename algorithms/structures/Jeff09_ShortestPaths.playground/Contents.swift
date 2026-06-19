import Foundation

struct WeightedEdge {
    let to: Int
    let w: Int
}

func dijkstra(_ graph: [[WeightedEdge]], source: Int) -> [Int] {
    let n = graph.count
    var dist = Array(repeating: Int.max / 4, count: n)
    var used = Array(repeating: false, count: n)
    dist[source] = 0
    for _ in 0..<n {
        var v = -1
        for i in 0..<n where !used[i] && (v == -1 || dist[i] < dist[v]) {
            v = i
        }
        if v == -1 { break }
        used[v] = true
        for edge in graph[v] where dist[v] + edge.w < dist[edge.to] {
            dist[edge.to] = dist[v] + edge.w
        }
    }
    return dist
}

let graph: [[WeightedEdge]] = [
    [WeightedEdge(to: 1, w: 1), WeightedEdge(to: 2, w: 4)],
    [WeightedEdge(to: 2, w: 2)],
    []
]
print(dijkstra(graph, source: 0))
