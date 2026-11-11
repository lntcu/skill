import SwiftUI

struct SkillCelebrationView: View {
    let skill: Skill
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 24) {
            BloomingFireworkView()
                .frame(maxHeight: 360)
            Text("Completed \(skill.name)")
                .font(.title2.weight(.medium))
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.white)
        .preferredColorScheme(.light)
        .safeAreaInset(edge: .bottom) {
            Button("Done") { dismiss() }.bottomActionStyle()
        }
        .interactiveDismissDisabled()
    }
}

#Preview { SkillCelebrationView(skill: Skill.examples[0]) }
