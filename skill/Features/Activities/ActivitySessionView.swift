import SwiftUI

struct ActivitySessionView: View {
    let skill: Skill
    let activity: ActivitySuggestion
    let minutes: Int
    var onComplete: () -> Void
    @State private var timer: ActivityTimer
    @Environment(\.scenePhase) private var scenePhase
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var checked: Set<Int> = []
    @State private var ended = false

    init(skill: Skill, activity: ActivitySuggestion, minutes: Int, onComplete: @escaping () -> Void) {
        self.skill = skill
        self.activity = activity
        self.minutes = minutes
        self.onComplete = onComplete
        _timer = State(initialValue: ActivityTimer(duration: Double(minutes * 60)))
    }

    var body: some View {
        List {
            Section {
                Text(activity.title).font(.headline)
                if timer.hasStarted {
                    HStack {
                        if let deadline = timer.deadline {
                            Text(timerInterval: min(Date.now, deadline)...deadline, countsDown: true)
                                .font(.largeTitle.monospacedDigit())
                                .accessibilityLabel("Time remaining")
                        } else {
                            let seconds = Int(ceil(timer.remaining(at: Date.now)))
                            Text(String(format: "%d:%02d", seconds / 60, seconds % 60))
                                .font(.largeTitle.monospacedDigit())
                                .accessibilityLabel("Time remaining")
                        }
                        Spacer()
						GlassEffectContainer {
							HStack {
								Button("Reset Timer", systemImage: "arrow.counterclockwise") { timer.reset() }
									.padding()
								Button(timer.deadline == nil ? "Continue Timer" : "Pause Timer",
									   systemImage: timer.deadline == nil ? "play.fill" : "pause.fill") { timer.togglePause() }
									.disabled(timer.remaining(at: Date.now) == 0)
									.padding()
							}
						}
						.glassEffect()
                    }
                    .labelStyle(.iconOnly)
                    .buttonStyle(.borderless)
                    TimelineView(.animation(minimumInterval: reduceMotion ? 1 : 1.0 / 30,
                                            paused: timer.deadline == nil || scenePhase != .active)) { timeline in
                        SkillProgressView(progress: timer.progress(at: timeline.date))
                    }
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
        .navigationBarBackButtonHidden(timer.hasStarted)
        .safeAreaInset(edge: .bottom) {
            Button(timer.hasStarted ? "End Activity" : "Start Activity") {
                if !timer.hasStarted {
                    timer.start()
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
