import SwiftUI
import SwiftData

struct SkillView: View {
    let skill: Skill
    @State private var showingActivity = false
    @State private var showingSettings = false
    @State private var selectedActivity: Activity?

    private var completed: [Activity] {
        skill.activities.filter(\.isCompleted)
    }

    var body: some View {
        List {
            Section("Progress") {
                SkillProgressView(progress: skill.progress)
                LabeledContent("Activities Completed", value: "\(skill.completedCount) / \(skill.requiredActivities)")
                if skill.isMastered { Label("Stamp Earned", systemImage: "checkmark.seal") }
            }
            Section("Completed Activities") {
                if completed.isEmpty {
                    EmptyStateView(title: "No Completed Activities Yet", symbol: "checkmark.circle")
                        .frame(minHeight: 180)
                        .listRowInsets(EdgeInsets())
                }
                ForEach(completed) { activity in
                    Button { selectedActivity = activity } label: {
                        Label(activity.name, systemImage: "checkmark.circle.fill")
                    }
                    .foregroundStyle(.black)
                }
            }
        }
        .navigationTitle(skill.name)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Skill Settings", systemImage: "gearshape") { showingSettings = true }
            }
        }
        .sheet(isPresented: $showingSettings) {
            NavigationStack { SkillSettingsView(skill: skill) }
        }
        .sheet(item: $selectedActivity) { activity in
            NavigationStack { CompletedActivityDetailView(activity: activity) }
        }
        .safeAreaInset(edge: .bottom) {
            Button("Start New Activity") { showingActivity = true }
                .bottomActionStyle()
        }
        .sheet(isPresented: $showingActivity) {
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
