import SwiftUI

// Monochrome launch and blooming burst inspired by Uladzislau Volchyk's article:
// https://uvolchyk.me/blog/blooming-fireworks-with-metal-and-swiftui
struct BloomingFireworkView: View {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.scenePhase) private var scenePhase
    @State private var start = Date.now

    var body: some View {
        TimelineView(.animation(minimumInterval: 1.0 / 30, paused: reduceMotion || scenePhase != .active)) { timeline in
            let time = reduceMotion ? 1.8 : timeline.date.timeIntervalSince(start)
            Color.white
                .visualEffect { content, geometry in
                    content.colorEffect(ShaderLibrary.monochromeFirework(.float(time), .float2(geometry.size)))
                }
        }
        .accessibilityHidden(true)
    }
}

#Preview { BloomingFireworkView().frame(height: 360) }
