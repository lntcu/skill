import SwiftData

@MainActor
func previewContainer() -> ModelContainer {
    let container = try! ModelContainer(for: Skill.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
    Skill.examples.forEach { container.mainContext.insert($0) }
    return container
}

