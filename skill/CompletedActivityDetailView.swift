import SwiftUI

struct CompletedActivityDetailView: View {
    let activity: Activity
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        List {
            Section {
                Text(activity.name).font(.title2.bold())
                if let photo = activity.photo, let image = UIImage(data: photo) {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .clipShape(.rect(cornerRadius: 16))
						.glassEffect(.regular.interactive(), in: .rect(cornerRadius: 16))
                }
                Text(activity.details.isEmpty ? "No description saved." : activity.details)
                if let date = activity.completedAt {
                    LabeledContent("Completed", value: date.formatted(date: .abbreviated, time: .shortened))
                } else {
                    Text("Completion date unavailable").foregroundStyle(.secondary)
                }
            }
            Section("Targets") {
                if activity.targets.isEmpty {
                    EmptyStateView(title: "No Targets Saved", symbol: "checklist")
                        .frame(minHeight: 140)
                        .listRowInsets(EdgeInsets())
                }
                ForEach(activity.targets.indices, id: \.self) { index in
                    Label(activity.targets[index], systemImage: activity.checkedTargets.contains(index) ? "checkmark.circle.fill" : "circle")
                }
            }
        }
        .navigationTitle("Completed Activity")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Done") { dismiss() }
            }
        }
    }
}

#Preview {
    NavigationStack { CompletedActivityDetailView(activity: Skill.examples[0].activities[0]) }
}
