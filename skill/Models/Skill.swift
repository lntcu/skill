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
        stampSymbol = iconName
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

