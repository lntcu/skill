import SwiftData
import Foundation

@Model
final class Skill {
    var name: String
    var requiredActivities: Int = 7
    var stampX: Double? = nil
    var stampY: Double? = nil
    var stampSymbol: String? = nil
    var stampHue: Double? = nil
    var stampRotation: Double = 0
    var stampOffset: Double = 0
    @Relationship(deleteRule: .cascade) var activities: [Activity]

    init(_ name: String, activities: [Activity] = [], requiredActivities: Int = 7) {
        self.name = name.formattedSkillName
        self.requiredActivities = max(1, requiredActivities)
        self.activities = activities
        assignStampStyle()
    }

    var completedCount: Int { activities.filter(\.isCompleted).count }
    var isMastered: Bool { completedCount >= max(1, requiredActivities) }
    var progress: Double { min(1, Double(completedCount) / Double(max(1, requiredActivities))) }

    func assignStampStyle() {
        if stampHue == nil {
            stampHue = Double.random(in: 0...1)
            stampRotation = Double.random(in: -14...14)
            stampOffset = Double.random(in: -10...10)
        }
        if stampX == nil { stampX = Double.random(in: -1...1) }
        if stampY == nil { stampY = Double.random(in: -1...1) }
        if stampSymbol == nil {
            stampSymbol = ["camera", "location.north", "paintbrush.pointed", "music.note", "leaf", "mountain.2", "sailboat", "book", "flame", "bicycle", "globe", "hammer"].randomElement()
        }
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
    var details: String = ""
    var targets: [String] = []
    var checkedTargets: [Int] = []
    var durationMinutes: Int = 0
    var completedAt: Date? = nil
    @Attribute(.externalStorage) var photo: Data? = nil

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

extension String {
    var formattedSkillName: String {
        trimmingCharacters(in: .whitespacesAndNewlines).capitalized(with: .current)
    }
}
