import SwiftUI
import SwiftData

struct IslandLayout {
    struct Island: Identifiable {
        let skill: Skill
        let center: CGPoint
        let size: CGSize
        let radii: [CGFloat]
        let rotation: Double
        let theme: Int
        let features: [CGPoint]
        var id: PersistentIdentifier { skill.persistentModelID }
        var clearance: CGFloat { hypot(size.width / 2 + 15, size.height / 2 + 45) }
    }
    let islands: [Island]
    let size: CGSize

    init(skills: [Skill]) {
        var placed: [Island] = []
        for (index, skill) in skills.enumerated() {
            let nameSeed = skill.name.utf8.reduce(UInt64(1469598103934665603)) { ($0 ^ UInt64($1)) &* 1099511628211 }
            var random = IslandRandom(seed: nameSeed ^ UInt64((skill.stampHue ?? 0.5) * 1_000_000_000))
            let size = CGSize(width: random.value(180...290), height: random.value(120...230))
            let clearance = hypot(size.width / 2 + 15, size.height / 2 + 45)
            var angle = random.value(0...(.pi * 2))
            var distance = index == 0 ? 0 : sqrt(Double(index)) * 290
            var center = CGPoint.zero
            // Rejection placement keeps the archipelago irregular without overlapping islands or labels.
            for _ in 0..<500 {
                center = CGPoint(x: cos(angle) * distance, y: sin(angle) * distance * 0.85)
                if placed.allSatisfy({ hypot($0.center.x - center.x, $0.center.y - center.y) > $0.clearance + clearance }) { break }
                angle += 0.7
                distance += 12
            }
            let radii = (0..<18).map { _ in CGFloat(random.value(0.6...1)) }
            var features: [CGPoint] = []
            let featureCount = Int(random.value(2...3.99))
            for _ in 0..<150 where features.count < featureCount {
                let direction = random.value(0...(.pi * 2))
                let radius = random.value(0.1...0.5)
                let point = CGPoint(x: 0.5 + cos(direction) * radius / 2, y: 0.5 + sin(direction) * radius / 2)
                if features.allSatisfy({ hypot(($0.x - point.x) * size.width, ($0.y - point.y) * size.height) >= 44 }) {
                    features.append(point)
                }
            }
            placed.append(Island(skill: skill, center: center, size: size, radii: radii,
                                 rotation: random.value(-35...35), theme: Int(random.value(0...3.99)), features: features))
        }
        let minX = placed.map { $0.center.x - $0.clearance }.min() ?? 0
        let minY = placed.map { $0.center.y - $0.clearance }.min() ?? 0
        let maxX = placed.map { $0.center.x + $0.clearance }.max() ?? 600
        let maxY = placed.map { $0.center.y + $0.clearance }.max() ?? 600
        size = CGSize(width: max(650, maxX - minX + 140), height: max(600, maxY - minY + 140))
        let dx = (size.width - (maxX - minX)) / 2 - minX
        let dy = (size.height - (maxY - minY)) / 2 - minY
        islands = placed.map { Island(skill: $0.skill, center: CGPoint(x: $0.center.x + dx, y: $0.center.y + dy), size: $0.size,
                                     radii: $0.radii, rotation: $0.rotation, theme: $0.theme, features: $0.features) }
    }
}

private struct IslandRandom {
    var seed: UInt64
    mutating func value(_ range: ClosedRange<Double>) -> Double {
        seed = seed &* 6364136223846793005 &+ 1442695040888963407
        return range.lowerBound + Double(seed >> 11) / Double(UInt64.max >> 11) * (range.upperBound - range.lowerBound)
    }
}
