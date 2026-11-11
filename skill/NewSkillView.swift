import SwiftUI

struct NewSkillView: View {
    @State private var customSkill = ""
    @State private var recommendation: String?
    private let recommendations = ["Guitar", "Cooking", "Drawing", "Photography", "Running"]

    var body: some View {
        Form {
            Section("Recommended Skills") {
				ForEach(recommendations, id: \.self) { skill in
					Button {
						recommendation = skill
					} label: {
						Text(skill)
					}
				}
            }
            Section("Your Own Skill") {
                TextField("Skill name", text: $customSkill)
                    .textInputAutocapitalization(.words)
            }
        }
        .navigationTitle("New Skill")
        .safeAreaInset(edge: .bottom) {
            Button("Add New Skill", action: {})
				.foregroundStyle(.black)
				.padding()
				.glassEffect(.regular.interactive())
                .disabled(customSkill.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                .frame(maxWidth: .infinity)
        }
    }
}

#Preview {
    NavigationStack {
        NewSkillView()
    }
}
