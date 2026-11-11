import SwiftUI
import SwiftData

struct SkillsView: View {
    @Query(sort: \Skill.name) private var skills: [Skill]

    @State private var showingNewSkill = false

    var body: some View {
        List {
            if skills.isEmpty {
                ListPlaceholderView(text: "No Skills Yet", symbol: "list.bullet")
            }
            ForEach(skills) { skill in
                NavigationLink {
                    SkillView(skill: skill)
                } label: {
                    VStack(alignment: .leading, spacing: 12) {
                        Text(skill.name).font(.headline)
                        SkillProgressView(progress: skill.progress)
                    }
                    .padding(.vertical, 4)
                }
            }
        }
        .navigationTitle("Skills")
        .sheet(isPresented: $showingNewSkill) {
            NavigationStack { NewSkillView() }
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("New Skill", systemImage: "plus") { showingNewSkill = true }
            }
        }
    }
}

#Preview {
    NavigationStack {
        SkillsView()
    }
    .modelContainer(previewContainer())
}
