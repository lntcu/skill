import SwiftUI
import SwiftData

struct SkillSettingsView: View {
    let skill: Skill
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    @Query private var skills: [Skill]
    @State private var name: String
    @State private var target: Int
    @State private var error: String?
    @State private var confirmDelete = false

    init(skill: Skill) {
        self.skill = skill
        _name = State(initialValue: skill.name)
        _target = State(initialValue: skill.requiredActivities)
    }

    private var trimmedName: String { name.formattedSkillName }
    private var duplicate: Bool {
        skills.contains { $0 !== skill && $0.name.localizedCaseInsensitiveCompare(trimmedName) == .orderedSame }
    }

    var body: some View {
        Form {
            TextField("Skill Name", text: $name)
            Section {
                Stepper("\(target) activities", value: $target, in: 1...1000)
            } header: {
                Text("Activity Goal")
            } footer: {
                Text("Complete this many activities to earn the skill's passport stamp.")
            }
            if duplicate { Text("You already have this skill.").foregroundStyle(.secondary) }
            if let error { Text(error).foregroundStyle(.red) }
            Section {
                Button("Delete Skill", role: .destructive) { confirmDelete = true }
            }
        }
        .navigationTitle("Skill Settings")
        .navigationBarTitleDisplayMode(.inline)
        .appScreenBackground()
        .tint(.accentTeal)
        .alert("Delete Skill?", isPresented: $confirmDelete) {
            Button("Delete", role: .destructive) {
                context.delete(skill)
                do {
                    try context.save()
                    dismiss()
                } catch {
                    self.error = "Couldn't delete skill. Please try again."
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") { dismiss() }
            }
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") {
                    let oldName = skill.name
                    let oldTarget = skill.requiredActivities
                    skill.name = trimmedName
                    skill.requiredActivities = target
                    do {
                        try context.save()
                        dismiss()
                    } catch {
                        skill.name = oldName
                        skill.requiredActivities = oldTarget
                        self.error = "Couldn't save changes. Please try again."
                    }
                }
                .disabled(trimmedName.isEmpty || duplicate)
            }
        }
    }
}

#Preview {
    NavigationStack { SkillSettingsView(skill: Skill.examples[0]) }
        .modelContainer(previewContainer())
}
