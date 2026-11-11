import SwiftUI
import SwiftData

struct HomeView: View {
    @Query(sort: \Skill.name) private var skills: [Skill]
    @State private var showingPassport = false

    var body: some View {
        List {
            Section("Passport") {
                LabeledContent("Stamps Collected", value: "\(skills.filter(\.isMastered).count)")
                Button("View Passport") { showingPassport = true }
            }
            Section {
                IslandMapView(skills: skills)
                ForEach(Array(skills.enumerated()), id: \.element.persistentModelID) { index, skill in
                    NavigationLink {
                        SkillView(skill: skill)
                    } label: {
                        LabeledContent("[\(index + 1)] \(skill.name)", value: skill.isMastered ? "Unlocked" : skill.progress.formatted(.percent.precision(.fractionLength(0))))
                    }
                }
            } header: {
                Text("Your Islands")
            } footer: {
                Text("Each skill is an island. Complete activities to uncover its terrain and reach the goal to fully unlock it.")
            }
        }
        .navigationTitle("Home")
        .sheet(isPresented: $showingPassport) {
            NavigationStack {
                PassportView()
            }
        }
    }
}

#Preview {
    NavigationStack {
        HomeView()
    }
    .modelContainer(previewContainer())
}
