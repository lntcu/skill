import SwiftUI

struct SkillCelebrationView: View {
    let skill: Skill
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            BloomingFireworkView().ignoresSafeArea()
            Text("Completed \(skill.name)")
                .font(.title2.weight(.medium))
                .multilineTextAlignment(.center)
                .padding(.horizontal)
                .shadow(color: .white, radius: 8)
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
