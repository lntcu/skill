import SwiftUI

struct SkillProgressView: View {
    let progress: Double
    @State private var textWidth: CGFloat = 0

    static func labelOffset(fill: CGFloat, total: CGFloat, text: CGFloat) -> CGFloat {
        min(max(0, text <= fill ? fill - text : fill), max(0, total - text))
    }

    var body: some View {
        GeometryReader { geometry in
            let fill = geometry.size.width * min(1, max(0, progress))
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 25)
                    .fill(.clear)
					.glassEffect(.regular.interactive())
                if fill > 0 {
                    RoundedRectangle(cornerRadius: 25)
                        .fill(.clear)
						.glassEffect(.regular.tint(.black.opacity(0.2)).interactive())
                        .frame(width: fill)
                }
                Text(progress.formatted(.percent.precision(.fractionLength(0))))
					.padding(.horizontal)
                    .fixedSize()
                    .onGeometryChange(for: CGFloat.self) { $0.size.width } action: { textWidth = $0 }
                    .offset(x: Self.labelOffset(fill: fill, total: geometry.size.width, text: textWidth))
            }
        }
        .frame(height: 30)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Progress")
        .accessibilityValue(progress.formatted(.percent.precision(.fractionLength(0))))
    }
}

#Preview {
    VStack(spacing: 20) {
        SkillProgressView(progress: 0.05)
        SkillProgressView(progress: 0.5)
        SkillProgressView(progress: 1)
    }
    .padding()
}
