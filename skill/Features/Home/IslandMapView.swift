import SwiftUI

struct IslandMapView: View {
    let skills: [Skill]
    @State private var resetToken = 0
    @State private var selectedSkill: Skill?

    var body: some View {
        if skills.isEmpty {
            ListPlaceholderView(text: "Add a Skill to Discover an Island", symbol: "map")
        } else {
            let layout = IslandLayout(skills: skills)
            ZStack {
                SeaBackground()
                ZoomableMapView(size: layout.size, resetToken: resetToken) {
                    ZStack {
                        ForEach(0..<28) { index in
                            SeaWave(index: index, size: layout.size)
                        }
                        IslandRoute(points: layout.islands.sorted { $0.center.x < $1.center.x }.map(\.center))
                            .stroke(Color.islandFoam.opacity(0.35),
                                    style: StrokeStyle(lineWidth: 2.5, lineCap: .round, lineJoin: .round, dash: [2, 10]))
                            .allowsHitTesting(false)
                        ForEach(layout.islands) { island in
                            Button { selectedSkill = island.skill } label: { IslandView(island: island) }
                                .buttonStyle(.plain)
                                .position(island.center)
                        }
                    }
                    .frame(width: layout.size.width, height: layout.size.height)
                }
            }
            .overlay(alignment: .topTrailing) {
                Button("Recenter Map", systemImage: "location.north") { resetToken += 1 }
                    .labelStyle(.iconOnly)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(Color.ink)
                    .padding(12)
                    .buttonStyle(.plain)
                    .glassEffect(.regular.interactive(), in: .circle)
                    .padding(12)
                    .accessibilityLabel("Recenter map")
            }
            .sheet(item: $selectedSkill) { skill in
                NavigationStack { SkillView(skill: skill) }
            }
        }
    }
}

private struct IslandRoute: Shape {
    let points: [CGPoint]

    func path(in rect: CGRect) -> Path {
        var path = Path()
        guard let first = points.first else { return path }
        path.move(to: first)
        var previous = first
        for point in points.dropFirst() {
            let mid = CGPoint(x: (previous.x + point.x) / 2, y: (previous.y + point.y) / 2)
            let bow = min(60, abs(point.x - previous.x) * 0.12)
            path.addQuadCurve(to: point, control: CGPoint(x: mid.x, y: mid.y - bow))
            previous = point
        }
        return path
    }
}

private struct SeaWave: View {
    let index: Int
    let size: CGSize

    private var isLarge: Bool { index.isMultiple(of: 3) }
    private var angle: Double { index.isMultiple(of: 2) ? -8 : 10 }

    var body: some View {
        Image(systemName: "water.waves")
            .font(.system(size: isLarge ? 26 : 16))
            .foregroundStyle(Color.islandFoam.opacity(isLarge ? 0.16 : 0.22))
            .rotationEffect(.degrees(angle))
            .position(x: CGFloat((index * 193 + 43) % Int(size.width)),
                      y: CGFloat((index * 317 + 71) % Int(size.height)))
    }
}

private struct SeaBackground: View {
    var body: some View {
        ZStack {
            LinearGradient(colors: [.islandSeaTop, .islandSeaBottom],
                           startPoint: .topLeading, endPoint: .bottomTrailing)
            RadialGradient(colors: [.white.opacity(0.34), .clear],
                           center: .topLeading, startRadius: 20, endRadius: 540)
            RadialGradient(colors: [.islandSeaBottom.opacity(0.45), .clear],
                           center: .bottomTrailing, startRadius: 60, endRadius: 660)
        }
    }
}

#Preview { IslandMapView(skills: Skill.examples).frame(height: 460) }
