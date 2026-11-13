import SwiftUI
import SwiftData
import FoundationModels

struct NewSkillView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    @Query(sort: \Skill.name) private var skills: [Skill]
    @State private var customSkill = ""
    @State private var similar: [SuggestedSkill] = []
    @State private var different: [SuggestedSkill] = []
    @State private var loading = false
    @State private var saving = false
    @State private var activityGoal = 7
    @State private var goalEdited = false
    @State private var estimatingName: String?
    @State private var generationError: String?
    @State private var saveError: String?
    @State private var attempt = 0

    private var estimatingGoal: Bool { estimatingName == name }
    private var name: String { customSkill.formattedSkillName }
    private var exists: Bool { skills.contains { $0.name.trimmingCharacters(in: .whitespacesAndNewlines).localizedCaseInsensitiveCompare(name) == .orderedSame } }
    private var selected: SuggestedSkill? { (similar + different).first { $0.name == name } }

    var body: some View {
        Form {
            if !similar.isEmpty {
                Section("Similar Skills") {
                    ForEach(similar, id: \.name) { skill in
                        Button(skill.name) {
                            customSkill = skill.name
                            activityGoal = skill.requiredActivities
                            goalEdited = false
                        }
                    }
                }
            }
            if !different.isEmpty {
                Section("Different Skills") {
                    ForEach(different, id: \.name) { skill in
                        Button(skill.name) {
                            customSkill = skill.name
                            activityGoal = skill.requiredActivities
                            goalEdited = false
                        }
                    }
                }
            }
            if loading {
                Section {
                    LoadingView(text: "Finding skills…")
                }
            }
            if let generationError {
                Section {
                    Text(generationError).foregroundStyle(.secondary)
                    if SystemLanguageModel.default.unavailabilityMessage == nil {
                        Button("Try Again") { attempt += 1 }
                    }
                }
            }
            Section {
                TextField("Skill name", text: $customSkill)
                    .textInputAutocapitalization(.words)
                Stepper("Activity Goal: \(activityGoal)", value: Binding(
                    get: { activityGoal },
                    set: { activityGoal = $0; goalEdited = true }
                ), in: 1...1000)
                if estimatingGoal { LoadingView(text: "Estimating activity goal…") }
                if exists { Text("You already have this skill.").foregroundStyle(.secondary) }
                if saving { LoadingView(text: "Saving skill…") }
                if let saveError { Text(saveError).foregroundStyle(.red) }
            } header: {
                Text("Your Own Skill")
            } footer: {
                Text("Seven activities is the average goal. Adjust it for your own learning pace.")
            }
        }
        .disabled(saving)
        .navigationTitle("New Skill")
        .navigationBarBackButtonHidden(saving)
        .tint(.accentTeal)
        .appScreenBackground()
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") { dismiss() }.disabled(saving)
            }
        }
        .safeAreaInset(edge: .bottom) {
            Button("Add New Skill", action: addSkill)
                .bottomActionStyle()
                .disabled(name.isEmpty || exists || saving || (estimatingGoal && !goalEdited))
        }
        .onChange(of: name) { _, _ in
            activityGoal = selected?.requiredActivities ?? 7
            goalEdited = false
        }
        .task(id: name) {
            guard !name.isEmpty, !exists, selected == nil,
                  SystemLanguageModel.default.unavailabilityMessage == nil else { return }
            let requestedName = name
            estimatingName = requestedName
            defer { if estimatingName == requestedName { estimatingName = nil } }
            do {
                try await Task.sleep(for: .milliseconds(600))
                guard !goalEdited else { return }
                let response = try await SkillRecommendations.session().respond(
                    to: "Suggest an initial activity goal for this discipline: \(requestedName). Use 7 as the average benchmark.",
                    generating: SuggestedSkill.self, contextOptions: ContextOptions(includeSchemaInPrompt: true))
                try Task.checkCancellation()
                if !goalEdited, name == requestedName { activityGoal = response.content.requiredActivities }
            } catch { /* Keep the editable default if estimation is unavailable. */ }
        }
        .task(id: attempt) {
            guard similar.count + different.count < 6 else { return }
            await generate()
        }
    }

    @MainActor
    private func generate() async {
        generationError = SystemLanguageModel.default.unavailabilityMessage
        guard generationError == nil else { return }
        loading = true
        similar = []
        different = []
        defer { loading = false }
        do {
            let stream = SkillRecommendations.session().streamResponse(to: """
                Reference disciplines: \(SkillRecommendations.referenceNames(for: skills).joined(separator: ", "))
                Existing disciplines to exclude: \(skills.map(\.name).joined(separator: ", "))
                """, generating: SkillRecommendations.self, contextOptions: ContextOptions(includeSchemaInPrompt: true))
            var seen = Set(skills.map { $0.name.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() })
            var processed = [0, 0]
            for try await snapshot in stream {
                try Task.checkCancellation()
                for (group, property) in ["similar", "different"].enumerated() {
                    let items = (try? snapshot.rawContent.value([GeneratedContent].self, forProperty: property)) ?? []
                    while processed[group] < items.count, items[processed[group]].isComplete {
                        var option = try SuggestedSkill(items[processed[group]])
                        processed[group] += 1
                        option.name = option.name.formattedSkillName
                        let key = option.name.lowercased()
                        guard !key.isEmpty, !["appreciation", "practice", "harmony", "creativity", "confidence"].contains(key),
                              (1...21).contains(option.requiredActivities), seen.insert(key).inserted else { continue }
                        if group == 0 { similar.append(option) } else { different.append(option) }
                    }
                }
            }
            if similar.count != 3 || different.count != 3 {
                generationError = "Couldn't find six distinct skills. Please try again."
            }
        } catch {
            if !Task.isCancelled { generationError = "Couldn't generate recommendations. Please try again." }
        }
    }

    @MainActor
    private func addSkill() {
        guard !name.isEmpty, !exists, !saving else { return }
        saving = true
        saveError = nil
        defer { saving = false }
        let skill = Skill(name, requiredActivities: activityGoal)
        context.insert(skill)
        do {
            try context.save()
            dismiss()
        } catch {
            context.delete(skill)
            saveError = "Couldn't add the skill. Please try again."
        }
    }
}

#Preview {
    NavigationStack { NewSkillView() }
        .modelContainer(previewContainer())
}
