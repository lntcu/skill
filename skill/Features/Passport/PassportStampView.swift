import SwiftUI

struct PassportStampView: View {
    let skill: Skill

    private var ink: Color { Color.stampInk(hue: skill.stampHue ?? 0.5) }

    var body: some View {
        GeometryReader { geometry in
            // Each stamp stays inside its own cell, including its rotated bounds.
            let side = min(geometry.size.width, geometry.size.height) * 0.72
            let bound = side * 1.42
            ZStack {
                Circle()
                    .strokeBorder(ink.opacity(0.85), lineWidth: 2.5)
                Circle()
                    .strokeBorder(ink.opacity(0.35), lineWidth: 1)
                    .padding(7)
                VStack(spacing: 6) {
                    Image(systemName: skill.iconName)
                        .font(.system(size: 30))
                    Text(skill.name.uppercased())
                        .font(.system(size: 12, weight: .bold, design: .rounded))
                        .tracking(1.1)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                        .minimumScaleFactor(0.6)
                }
                .padding(20)
            }
            .foregroundStyle(ink)
            .frame(width: side, height: side)
            .rotationEffect(.degrees(skill.stampRotation))
            .position(
                x: geometry.size.width / 2 + (skill.stampX ?? 0) * max(0, (geometry.size.width - bound) / 2),
                y: geometry.size.height / 2 + (skill.stampY ?? 0) * max(0, (geometry.size.height - bound) / 2))
        }
        .accessibilityElement(children: .combine)
    }
}

#Preview {
    PassportStampView(skill: Skill.examples[0])
        .frame(width: 170, height: 200)
        .background(Color.passportPaper)
}
