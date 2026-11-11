import Foundation

// Independent procedural terrain, with ASCII visuals inspired by https://ascii.rest/contour-map/
struct IslandTerrain {
    static let columns = 64
    static func rows(for count: Int) -> Int { max(1, (count + 1) / 2) * 18 }

    static func render(skills: [Skill]) -> String {
        guard !skills.isEmpty else { return "" }
        let rows = rows(for: skills.count)
        var grid = Array(repeating: Array(repeating: Character(" "), count: columns), count: rows)
        let shades = Array(".,:;irsXA253hMHGS#9B&@")
        for (index, skill) in skills.enumerated() {
            let cx = (index % 2) * 32 + 16
            let cy = (index / 2) * 18 + 8
            let seed = (skill.stampHue ?? 0.5) * 20
            for y in -7...7 {
                for x in -14...14 {
                    let u = Double(x) / 13
                    let v = Double(y) / 6
                    let angle = atan2(v, u)
                    let coast = 1 + 0.13 * sin(angle * 3 + seed) + 0.09 * cos(angle * 5 - seed)
                    let radius = sqrt(u * u + v * v) / coast
                    guard radius < 1 else { continue }
                    let revealed = Double(x + 14) / 28 <= skill.progress
                    let ridge = sin(u * 7 + seed) * cos(v * 5 - seed)
                    let elevation = max(0, 1 - radius + ridge * 0.17)
                    let light = min(1, max(0, elevation * 0.75 - u * 0.2 - v * 0.15))
                    let character = radius > 0.88 ? Character(".") : revealed ? shades[min(shades.count - 1, Int(light * Double(shades.count - 1)))] : Character(":")
                    grid[cy + y][cx + x] = character
                }
            }
            let label = Array("[\(index + 1)]")
            for (offset, character) in label.enumerated() {
                grid[cy + 8][cx - label.count / 2 + offset] = character
            }
        }
        // Sparse ocean ripples give the archipelago a common sea.
        for y in 0..<rows {
            for x in 0..<columns where grid[y][x] == " " {
                if (x * 17 + y * 31) % 97 < 2 { grid[y][x] = "~" }
            }
        }
        return grid.map { String($0) }.joined(separator: "\n")
    }
}
