import SwiftUI
import SwiftData

struct SkillView: View {
    let skill: Skill

    private var completed: [Activity] {
        skill.activities.filter(\.isCompleted)
    }

    private var progress: Double {
        skill.activities.isEmpty ? 0 : Double(completed.count) / Double(skill.activities.count)
    }

    var body: some View {
        List {
            Section("Progress") {
				ZStack(alignment: .leading) {
					GeometryReader { geometry in
						ZStack(alignment: .leading) {
							RoundedRectangle(cornerRadius: 25)
								.fill(.clear)
								.glassEffect(.regular)

							RoundedRectangle(cornerRadius: 25)
								.fill(.clear)
								.glassEffect(.regular.tint(.black.opacity(0.2)))
								.frame(width: geometry.size.width * progress)
						}
					}
					.frame(height: 30)
					Text("\(progress.formatted(.percent.precision(.fractionLength(0))))")
						.padding(.horizontal)
				}
            }
            Section("Completed Activities") {
                if completed.isEmpty {
                    Text("No completed activities yet")
                        .foregroundStyle(.secondary)
                }
                ForEach(completed) { activity in
                    Label(activity.name, systemImage: "checkmark.circle.fill")
						.foregroundStyle(.black)
                }
            }
        }
        .navigationTitle(skill.name)
        .safeAreaInset(edge: .bottom) {
            NavigationLink {
                NewActivityView()
			} label: {
				Text("Start New Activity")
					.foregroundStyle(.black)
					.padding()
					.glassEffect(.regular.interactive())
			}
            .frame(maxWidth: .infinity)
        }
    }
}

#Preview {
    NavigationStack {
        SkillView(skill: Skill.examples[0])
    }
    .modelContainer(previewContainer())
}
