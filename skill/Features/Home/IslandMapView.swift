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
            ZoomableMapView(size: layout.size, resetToken: resetToken) {
                ZStack {
                    Color.islandSea
                    ForEach(0..<30) { index in
                        Image(systemName: "water.waves")
                            .foregroundStyle(.teal.opacity(0.12))
                            .position(x: CGFloat((index * 193 + 43) % Int(layout.size.width)),
                                      y: CGFloat((index * 317 + 71) % Int(layout.size.height)))
                    }
                    ForEach(layout.islands) { island in
                        Button { selectedSkill = island.skill } label: { IslandView(island: island) }
                            .buttonStyle(.plain)
                            .position(island.center)
                    }
                }
                .frame(width: layout.size.width, height: layout.size.height)
            }
            .background(Color.islandSea)
            .overlay(alignment: .topTrailing) {
                Button("Recenter Map", systemImage: "location.north") { resetToken += 1 }
                    .labelStyle(.iconOnly)
                    .font(.title)
                    .buttonStyle(.plain)
					.padding()
					.glassEffect(.regular.interactive(), in: .circle)
                    .padding()
            }
            .sheet(item: $selectedSkill) { skill in
                NavigationStack { SkillView(skill: skill) }
            }
        }
    }
}

#Preview { IslandMapView(skills: Skill.examples).frame(height: 460) }
