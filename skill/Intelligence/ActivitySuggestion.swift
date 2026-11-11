import Foundation
import FoundationModels

@Generable
struct ActivitySuggestion {
    @Guide(description: "A short, specific activity title")
    var title: String
    @Guide(description: "Two short sentences explaining what to practice and how")
    var description: String
    @Guide(description: "Three concrete, achievable checklist targets", .count(3))
    var targets: [String]

    static var example: ActivitySuggestion {
        ActivitySuggestion(title: "Practice chord changes", description: "Alternate between G and C slowly. Aim for smooth, clean transitions.", targets: ["Tune the guitar", "Practice 10 slow changes", "Play 10 clean changes"])
    }
}

@Generable
struct ActivityOptions {
    @Guide(description: "Three distinct activities not previously completed", .count(3))
    var activities: [ActivitySuggestion]
}

