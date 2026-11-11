import SwiftUI

struct IslandMapView: View {
    let skills: [Skill]

    var body: some View {
        if skills.isEmpty {
            ListPlaceholderView(text: "Add a Skill to Discover an Island", symbol: "map")
        } else {
            GeometryReader { geometry in
                let fontSize = geometry.size.width / CGFloat(IslandTerrain.columns) / 0.61
                Text(IslandTerrain.render(skills: skills))
                    .font(.system(size: fontSize, design: .monospaced))
                    .lineSpacing(0)
                    .fixedSize()
            }
            .aspectRatio(CGFloat(IslandTerrain.columns) * 0.61 / (CGFloat(IslandTerrain.rows(for: skills.count)) * 1.2), contentMode: .fit)
            .accessibilityHidden(true)
        }
    }
}

#Preview {
    IslandMapView(skills: Skill.examples).padding()
}
