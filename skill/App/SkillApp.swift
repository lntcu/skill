import SwiftUI
import SwiftData

@main
struct SkillApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Skill.self)
    }
}
