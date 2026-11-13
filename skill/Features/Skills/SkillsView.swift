import SwiftUI
import SwiftData

struct SkillsView: View {
    @Environment(\.modelContext) private var context
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
                    SkillRow(skill: skill)
                }
            }
            .onDelete(perform: delete)
        }
        .appScreenBackground()
        .navigationTitle("Skills")
        .tint(.accentTeal)
        .sheet(isPresented: $showingNewSkill) {
            NavigationStack { NewSkillView() }
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("New Skill", systemImage: "plus") { showingNewSkill = true }
            }
        }
    }

    private func delete(_ offsets: IndexSet) {
        for index in offsets {
            context.delete(skills[index])
        }
        do {
            try context.save()
        } catch {
            context.rollback()
        }
    }
}

private struct SkillRow: View {
    let skill: Skill

    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(Color.accentSoft)
                Image(systemName: skill.iconName)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(Color.accentTeal)
            }
            .frame(width: 42, height: 42)

            VStack(alignment: .leading, spacing: 8) {
                HStack(alignment: .firstTextBaseline, spacing: 6) {
                    Text(skill.name)
                        .font(.headline)
                    if skill.isMastered {
                        Image(systemName: "checkmark.seal.fill")
                            .font(.caption)
                            .foregroundStyle(Color.gold)
                            .accessibilityLabel("Stamp earned")
                    }
                    Spacer(minLength: 8)
                    Text("\(skill.completedCount)/\(skill.requiredActivities)")
                        .font(.caption.monospacedDigit())
                        .foregroundStyle(.secondary)
                }
                SkillProgressView(progress: skill.progress)
            }
        }
        .padding(.vertical, 6)
    }
}

#Preview {
    NavigationStack {
        SkillsView()
    }
    .modelContainer(previewContainer())
}
