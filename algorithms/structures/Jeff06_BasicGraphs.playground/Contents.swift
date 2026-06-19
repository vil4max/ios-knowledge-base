import Foundation

struct Graph {
    var adjacency: [Int: [Int]] = [:]

    mutating func addEdge(_ from: Int, _ to: Int) {
        adjacency[from, default: []].append(to)
        adjacency[to, default: []].append(from)
    }
}

func bfsDistances(graph: Graph, source: Int) -> [Int: Int] {
    var distance: [Int: Int] = [source: 0]
    var queue = [source]
    var index = 0
    while index < queue.count {
        let node = queue[index]
        index += 1
        for next in graph.adjacency[node, default: []] where distance[next] == nil {
            distance[next] = distance[node, default: 0] + 1
            queue.append(next)
        }
    }
    return distance
}

var graph = Graph()
graph.addEdge(0, 1)
graph.addEdge(1, 2)
graph.addEdge(0, 3)
print(bfsDistances(graph: graph, source: 0))
