import SwiftUI

struct ActivitySessionView: View {
    let skill: Skill
    let activity: ActivitySuggestion
    let minutes: Int
    var onComplete: () -> Void
    @State private var deadline: Date?
    @State private var checked: Set<Int> = []
    @State private var ended = false

    var body: some View {
        List {
            Section {
                Text(activity.title).font(.headline)
                if let deadline {
                    Text(timerInterval: min(Date.now, deadline)...deadline, countsDown: true)
                        .font(.largeTitle.monospacedDigit())
                        .accessibilityLabel("Time remaining")
                } else {
                    Text(activity.description)
                }
            }
            Section("Targets") {
                ForEach(activity.targets.indices, id: \.self) { index in
                    Button {
                        if !checked.insert(index).inserted { checked.remove(index) }
                    } label: {
                        Label(activity.targets[index], systemImage: checked.contains(index) ? "checkmark.circle.fill" : "circle")
                    }
                    .buttonStyle(.plain)
                    .accessibilityValue(checked.contains(index) ? "Checked" : "Unchecked")
                }
            }
        }
        .navigationTitle("Activity")
        .navigationBarBackButtonHidden(deadline != nil)
        .safeAreaInset(edge: .bottom) {
            Button(deadline == nil ? "Start Activity" : "End Activity") {
                if deadline == nil {
                    deadline = Date.now.addingTimeInterval(Double(minutes * 60))
                } else {
                    ended = true
                }
            }
            .bottomActionStyle()
        }
        .navigationDestination(isPresented: $ended) {
            CompleteActivityView(skill: skill, activity: activity, minutes: minutes, checked: checked, onComplete: onComplete)
        }
    }
}

#Preview {
    NavigationStack {
        ActivitySessionView(skill: Skill.examples[0], activity: .example, minutes: 30, onComplete: {})
    }
}
