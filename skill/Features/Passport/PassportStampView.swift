import SwiftUI

struct PassportStampView: View {
    let skill: Skill

    var body: some View {
        GeometryReader { geometry in
            // Each stamp stays inside its own cell, including its rotated bounds.
            let side = min(geometry.size.width, geometry.size.height) * 0.6
            let bound = side * 1.42
            VStack(spacing: 8) {
                Image(systemName: skill.iconName)
                    .font(.largeTitle)
                Text(skill.name)
                    .font(.headline)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .minimumScaleFactor(0.6)
            }
            .frame(width: side, height: side)
            .clipped()
            .foregroundStyle(Color(hue: skill.stampHue ?? 0.5, saturation: 0.65, brightness: 0.7))
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
}
