import SwiftUI
import SwiftData

struct SkillView: View {
    let skill: Skill
    @State private var showingActivity = false
    @State private var showingSettings = false
    @State private var showingCelebration = false
    @State private var previouslyMastered: Bool
    @State private var selectedActivity: Activity?

    init(skill: Skill) {
        self.skill = skill
        _previouslyMastered = State(initialValue: skill.isMastered)
    }

    private func checkCompletion() {
        if !previouslyMastered && skill.isMastered { showingCelebration = true }
        previouslyMastered = skill.isMastered
    }

    private var completed: [Activity] {
        skill.activities
            .filter(\.isCompleted)
            .sorted { ($0.completedAt ?? .distantPast) > ($1.completedAt ?? .distantPast) }
    }

    var body: some View {
        List {
            Section("Progress") {
                SkillProgressView(progress: skill.progress)
                LabeledContent("Activities Completed", value: "\(skill.completedCount) / \(skill.requiredActivities)")
                if skill.isMastered {
                    Label("Stamp Earned", systemImage: "checkmark.seal.fill")
                        .foregroundStyle(Color.gold)
                }
            }
            Section("Completed Activities") {
                if completed.isEmpty {
                    ListPlaceholderView(text: "No Completed Activities Yet", symbol: "checkmark.circle")
                }
                ForEach(completed) { activity in
                    Button { selectedActivity = activity } label: {
                        HStack(spacing: 12) {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundStyle(Color.accentTeal)
                            Text(activity.name)
                                .foregroundStyle(Color.ink)
                        }
                    }
                }
            }
        }
        .appScreenBackground()
        .navigationTitle(skill.name)
        .tint(.accentTeal)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Skill Settings", systemImage: "gearshape") { showingSettings = true }
            }
        }
        .sheet(isPresented: $showingSettings, onDismiss: checkCompletion) {
            NavigationStack { SkillSettingsView(skill: skill) }
        }
        .fullScreenCover(isPresented: $showingCelebration) {
            SkillCelebrationView(skill: skill)
        }
        .sheet(item: $selectedActivity) { activity in
            NavigationStack { CompletedActivityDetailView(activity: activity) }
        }
        .safeAreaInset(edge: .bottom) {
            Button("Start New Activity") { showingActivity = true }
                .bottomActionStyle()
        }
        .sheet(isPresented: $showingActivity, onDismiss: checkCompletion) {
            NavigationStack {
                NewActivityView(skill: skill) { showingActivity = false }
            }
            .interactiveDismissDisabled()
        }
    }
}

#Preview {
    NavigationStack {
        SkillView(skill: Skill.examples[0])
    }
    .modelContainer(previewContainer())
}
