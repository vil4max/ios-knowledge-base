import Foundation

struct Edge {
    let u: Int
    let v: Int
    let w: Int
}

struct DSU {
    var parent: [Int]

    init(_ n: Int) {
        parent = Array(0..<n)
    }

    mutating func find(_ x: Int) -> Int {
        if parent[x] == x { return x }
        parent[x] = find(parent[x])
        return parent[x]
    }

    mutating func unite(_ a: Int, _ b: Int) -> Bool {
        let ra = find(a)
        let rb = find(b)
        if ra == rb { return false }
        parent[rb] = ra
        return true
    }
}

func kruskal(n: Int, edges: [Edge]) -> Int {
    var dsu = DSU(n)
    var total = 0
    for edge in edges.sorted(by: { $0.w < $1.w }) where dsu.unite(edge.u, edge.v) {
        total += edge.w
    }
    return total
}

let edges = [Edge(u: 0, v: 1, w: 4), Edge(u: 1, v: 2, w: 2), Edge(u: 0, v: 2, w: 3)]
print(kruskal(n: 3, edges: edges))
