import SwiftUI

struct SkillProgressView: View {
    let progress: Double
    @State private var textWidth: CGFloat = 0

    var body: some View {
        GeometryReader { geometry in
            let value = min(1, max(0, progress))
            let fill = geometry.size.width * value
            let labelIsOnFill = fill >= (geometry.size.width + textWidth) / 2

            ZStack {
                Capsule()
                    .fill(Color.progressTrack)
                    .overlay {
                        Capsule().strokeBorder(Color.ink.opacity(0.05), lineWidth: 1)
                    }
                if fill > 0 {
                    Capsule()
                        .fill(
                            LinearGradient(colors: [.progressStart, .progressEnd],
                                           startPoint: .leading, endPoint: .trailing)
                        )
                        .frame(width: fill)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                Text(value.formatted(.percent.precision(.fractionLength(0))))
                    .font(.system(size: 13, weight: .semibold, design: .rounded).monospacedDigit())
                    .foregroundStyle(labelIsOnFill ? .white : .secondaryInk)
                    .fixedSize()
                    .onGeometryChange(for: CGFloat.self) { $0.size.width } action: { textWidth = $0 }
                    .frame(maxWidth: .infinity)
            }
            .clipShape(Capsule())
        }
        .frame(height: 30)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Progress")
        .accessibilityValue(progress.formatted(.percent.precision(.fractionLength(0))))
    }
}

#Preview {
    VStack(spacing: 20) {
        SkillProgressView(progress: 0)
        SkillProgressView(progress: 0.05)
        SkillProgressView(progress: 0.14)
        SkillProgressView(progress: 0.5)
        SkillProgressView(progress: 1)
    }
    .padding()
}
