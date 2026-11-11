import SwiftUI

struct IslandOutline: Shape {
    let radii: [CGFloat]
    var rotation: Double = 0

    func path(in rect: CGRect) -> Path {
        let points = radii.enumerated().map { index, radius in
            let angle = Double(index) / Double(radii.count) * .pi * 2 + rotation * .pi / 180
            return CGPoint(x: rect.midX + cos(angle) * rect.width / 2 * radius,
                           y: rect.midY + sin(angle) * rect.height / 2 * radius)
        }
        var path = Path()
        guard let first = points.first else { return path }
        path.move(to: first)
        for index in points.indices {
            let p0 = points[(index + points.count - 1) % points.count]
            let p1 = points[index]
            let p2 = points[(index + 1) % points.count]
            let p3 = points[(index + 2) % points.count]
            path.addCurve(to: p2,
                          control1: CGPoint(x: p1.x + (p2.x - p0.x) / 6, y: p1.y + (p2.y - p0.y) / 6),
                          control2: CGPoint(x: p2.x - (p3.x - p1.x) / 6, y: p2.y - (p3.y - p1.y) / 6))
        }
        path.closeSubpath()
        return path
    }
}

struct IslandView: View {
    let island: IslandLayout.Island

    private var land: Color {
        [Color(red: 0.52, green: 0.69, blue: 0.43), Color(red: 0.85, green: 0.78, blue: 0.52),
         Color(red: 0.63, green: 0.68, blue: 0.59), Color(red: 0.55, green: 0.74, blue: 0.63)][island.theme]
    }
    private var symbols: [String] {
        [["tree.fill", "tree.fill", "leaf.fill"], ["beach.umbrella.fill", "sun.max.fill", "tree.fill"],
         ["mountain.2.fill", "mountain.2.fill", "tree.fill"], ["tree.fill", "mountain.2.fill", "beach.umbrella.fill"]][island.theme]
    }

    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                let outline = IslandOutline(radii: island.radii, rotation: island.rotation)
                outline.fill(Color(red: 0.94, green: 0.87, blue: 0.66))
                    .shadow(color: .cyan.opacity(0.2), radius: 8)
                outline.fill(land).scaleEffect(island.theme == 1 ? 0.72 : 0.88)
                outline.fill(.black.opacity(0.045)).scaleEffect(0.58)
                ForEach(island.features.indices, id: \.self) { index in
                    Image(systemName: symbols[index % symbols.count])
                        .font(.system(size: 22))
                        .frame(width: 28, height: 28)
                        .clipped()
                        .foregroundStyle(island.theme == 2 ? .white.opacity(0.85) : .black.opacity(0.5))
                        .position(x: island.features[index].x * island.size.width, y: island.features[index].y * island.size.height)
                        .opacity(Double(index) / Double(island.features.count) < island.skill.progress ? 1 : 0.08)
                }
                .clipShape(outline)
                outline.fill(.white.opacity((1 - island.skill.progress) * 0.4))
            }
            .frame(width: island.size.width, height: island.size.height)

            Text(island.skill.name)
                .font(.system(size: 18, weight: .medium))
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .frame(width: island.size.width + 30)
                .shadow(color: .white, radius: 3)
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(island.skill.name)
        .accessibilityValue(island.skill.isMastered ? "Island fully unlocked" : island.skill.progress.formatted(.percent))
    }
}

#Preview {
    IslandView(island: IslandLayout(skills: Skill.examples).islands[0])
        .padding(40).background(.cyan.opacity(0.1))
}
