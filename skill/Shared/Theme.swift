import SwiftUI
import UIKit

private func paletteColor(_ hex: UInt32, alpha: CGFloat = 1) -> UIColor {
    UIColor(red: CGFloat((hex >> 16) & 0xFF) / 255,
            green: CGFloat((hex >> 8) & 0xFF) / 255,
            blue: CGFloat(hex & 0xFF) / 255,
            alpha: alpha)
}

private func adaptiveColor(_ light: UInt32, _ dark: UInt32) -> Color {
    Color(uiColor: UIColor { traits in
        paletteColor(traits.userInterfaceStyle == .dark ? dark : light)
    })
}

extension Color {
    // Page surfaces
    static let appBackgroundTop = adaptiveColor(0xF9F4EA, 0x122022)
    static let appBackgroundBottom = adaptiveColor(0xEFE6D5, 0x0A1517)

    // Text and controls
    static let ink = adaptiveColor(0x19332F, 0xECF5F0)
    static let secondaryInk = adaptiveColor(0x62706A, 0x9DB1AA)
    static let accentTeal = adaptiveColor(0x0E7C79, 0x5AD1C0)
    static let accentDeep = adaptiveColor(0x0A5D5E, 0x2CA79B)
    static let accentSoft = adaptiveColor(0xD9ECE6, 0x123634)
    static let coral = adaptiveColor(0xDA6A50, 0xFF9C84)
    static let gold = adaptiveColor(0xB8891F, 0xE0BE63)

    // Progress capsules
    static let progressTrack = adaptiveColor(0xE5DECD, 0x22312E)
    static let progressStart = adaptiveColor(0x0E7C79, 0x2AA79B)
    static let progressEnd = adaptiveColor(0x4FBDB0, 0x7BE3D2)

    // The archipelago
    static let islandSeaTop = adaptiveColor(0x86D6D0, 0x1F5560)
    static let islandSeaBottom = adaptiveColor(0x2D8A94, 0x092830)
    static let islandSea = adaptiveColor(0x46AEB8, 0x103A43)
    static let islandSand = adaptiveColor(0xF4E2BA, 0xE5D2A1)
    static let islandFoam = adaptiveColor(0xF7FFFC, 0xD8F0EA)
    static let islandMeadow = adaptiveColor(0x7CB069, 0x5E9455)
    static let islandBeach = adaptiveColor(0xE7C87E, 0xD3AE62)
    static let islandAlpine = adaptiveColor(0x98A79E, 0x7F918A)
    static let islandLagoon = adaptiveColor(0x62B79A, 0x4A9C83)
    static let islandLabel = adaptiveColor(0xFFFFFF, 0xF1FBF6)
    static let islandLabelShadow = adaptiveColor(0x06302E, 0x000000)
    static let islandShadow = adaptiveColor(0x0C3A3A, 0x000000)

    // Passport
    static let passportPaper = adaptiveColor(0xF5EBD5, 0x1B2827)
    static let passportPaperDeep = adaptiveColor(0xE7D7B7, 0x111D1D)

    static func stampInk(hue: Double) -> Color {
        Color(uiColor: UIColor { traits in
            UIColor(hue: hue,
                    saturation: traits.userInterfaceStyle == .dark ? 0.55 : 0.62,
                    brightness: traits.userInterfaceStyle == .dark ? 0.82 : 0.38,
                    alpha: 1)
        })
    }
}

struct AppBackground: View {
    var body: some View {
        LinearGradient(colors: [.appBackgroundTop, .appBackgroundBottom],
                       startPoint: .top, endPoint: .bottom)
            .ignoresSafeArea()
    }
}

extension View {
    /// Lets the warm app background show through a List or Form.
    func appScreenBackground() -> some View {
        self
            .scrollContentBackground(.hidden)
            .background { AppBackground() }
    }
}
