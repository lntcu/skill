import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var context
    @Query private var skills: [Skill]
    @AppStorage("hasSeededExamples") private var hasSeededExamples = false

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
        .tint(.accentTeal)
        .task {
            guard skills.isEmpty else {
                hasSeededExamples = true
                return
            }
            guard !hasSeededExamples else { return }
            Skill.examples.forEach { context.insert($0) }
            hasSeededExamples = true
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(previewContainer())
}
