import SwiftData
import Foundation

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

