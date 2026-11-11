import SwiftData

@Model
final class Skill {
    var name: String
    var stampHue: Double? = nil
    var stampRotation: Double = 0
    var stampOffset: Double = 0
    @Relationship(deleteRule: .cascade) var activities: [Activity]

    init(_ name: String, activities: [Activity] = []) {
        self.name = name
        self.activities = activities
        assignStampStyle()
    }

    func assignStampStyle() {
        guard stampHue == nil else { return }
        stampHue = Double.random(in: 0...1)
        stampRotation = Double.random(in: -14...14)
        stampOffset = Double.random(in: -10...10)
    }

    static var examples: [Skill] {
        [
            Skill("Guitar", activities: [
                Activity("Learn basic chords", isCompleted: true),
                Activity("Practice chord changes"),
                Activity("Play a song")
            ]),
            Skill("Cooking", activities: [
                Activity("Practice knife skills", isCompleted: true),
                Activity("Cook a simple meal")
            ])
        ]
    }
}

@Model
final class Activity {
    var name: String
    var isCompleted: Bool

    init(_ name: String, isCompleted: Bool = false) {
        self.name = name
        self.isCompleted = isCompleted
    }
}

@MainActor
func previewContainer() -> ModelContainer {
    let container = try! ModelContainer(for: Skill.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
    Skill.examples.forEach { container.mainContext.insert($0) }
    return container
}
