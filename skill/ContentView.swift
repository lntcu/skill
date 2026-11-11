import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var context
    @Query private var skills: [Skill]

    var body: some View {
        TabView {
            Tab("Skills", systemImage: "list.bullet") {
                NavigationStack {
                    SkillsView()
                }
            }
            Tab("Home", systemImage: "house") {
                NavigationStack {
                    HomeView()
                }
            }
        }
        .task {
            guard skills.isEmpty else { return }
            Skill.examples.forEach { context.insert($0) }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(previewContainer())
}
