import SwiftUI

struct NewActivityView: View {
    let skill: Skill
    var onComplete: () -> Void
    @Environment(\.dismiss) private var dismiss
    @State private var energy = "Okay"
    @State private var minutes = 30

    var body: some View {
        Form {
            Picker("Energy Level", selection: $energy) {
                ForEach(["Tired", "Low", "Okay", "Energetic", "Very Energetic"], id: \.self) {
                    Text($0)
                }
            }
            Section("Time Available") {
                Stepper("\(minutes) minutes", value: $minutes, in: 5...240, step: 5)
            }
        }
        .navigationTitle("New Activity")
        .appScreenBackground()
        .tint(.accentTeal)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") { dismiss() }
            }
        }
        .safeAreaInset(edge: .bottom) {
            NavigationLink("Next") {
                ActivitySuggestionsView(skill: skill, energy: energy, minutes: minutes, onComplete: onComplete)
            }
            .bottomActionStyle()
        }
    }
}

#Preview {
    NavigationStack {
        NewActivityView(skill: Skill.examples[0], onComplete: {})
    }
}
