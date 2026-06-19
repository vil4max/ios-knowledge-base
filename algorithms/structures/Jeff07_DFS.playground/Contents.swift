import Foundation

func hasCycleDirected(_ graph: [Int: [Int]]) -> Bool {
    enum Color {
        case white, gray, black
    }
    var color = [Int: Color]()
    for node in graph.keys {
        color[node] = .white
    }

    func dfs(_ node: Int) -> Bool {
        color[node] = .gray
        for next in graph[node, default: []] {
            let state = color[next, default: .white]
            if state == .gray { return true }
            if state == .white && dfs(next) { return true }
        }
        color[node] = .black
        return false
    }

    for node in graph.keys where color[node] == .white {
        if dfs(node) { return true }
    }
    return false
}

let graph = [0: [1], 1: [2], 2: [0]]
print(hasCycleDirected(graph))
