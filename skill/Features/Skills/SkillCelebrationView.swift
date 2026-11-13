import SwiftUI

struct SkillCelebrationView: View {
    let skill: Skill
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            BloomingFireworkView().ignoresSafeArea()

            VStack(spacing: 16) {
                Text("STAMP EARNED")
                    .font(.caption.weight(.bold))
                    .tracking(3)
                    .foregroundStyle(Color.coral)

                PassportStampView(skill: skill)
                    .frame(width: 190, height: 190)

                VStack(spacing: 6) {
                    Text(skill.name)
                        .font(.title2.bold())
                        .foregroundStyle(Color.ink)
                        .multilineTextAlignment(.center)
                    Text("You reached your goal of \(skill.requiredActivities) activities.")
                        .font(.subheadline)
                        .foregroundStyle(Color.secondaryInk)
                        .multilineTextAlignment(.center)
                }
            }
            .padding(28)
            .frame(maxWidth: 330)
            .background(Color.passportPaper.opacity(0.95),
                        in: RoundedRectangle(cornerRadius: 32, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: 32, style: .continuous)
                    .strokeBorder(Color.ink.opacity(0.08), lineWidth: 1)
            }
            .shadow(color: .black.opacity(0.14), radius: 30, y: 14)
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
