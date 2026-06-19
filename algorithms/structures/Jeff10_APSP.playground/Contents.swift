import Foundation

func floydWarshall(_ dist: inout [[Int]]) {
    let n = dist.count
    for k in 0..<n {
        for i in 0..<n {
            for j in 0..<n {
                if dist[i][k] + dist[k][j] < dist[i][j] {
                    dist[i][j] = dist[i][k] + dist[k][j]
                }
            }
        }
    }
}

let inf = 1_000_000
var matrix = [
    [0, 3, inf],
    [inf, 0, 1],
    [2, inf, 0]
]
floydWarshall(&matrix)
print(matrix)
