import Foundation

extension String {
    var formattedSkillName: String {
        trimmingCharacters(in: .whitespacesAndNewlines).capitalized(with: .current)
    }
}
