import SwiftUI
import SwiftData

struct SkillsView: View {
    @Query(sort: \Skill.name) private var skills: [Skill]

    var body: some View {
        List(skills) { skill in
            NavigationLink {
                SkillView(skill: skill)
			} label: {
				Text(skill.name)
			}
        }
        .navigationTitle("Skills")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink {
                    NewSkillView()
                } label: {
                    Label("New Skill", systemImage: "plus")
                }
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
