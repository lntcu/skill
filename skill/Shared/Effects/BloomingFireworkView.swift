import SwiftUI

// Launch-and-bloom visual inspired by Uladzislau Volchyk's fireworks article.
struct BloomingFireworkView: View {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.scenePhase) private var scenePhase
    @State private var start = Date.now
    @State private var fireworks = FireworkConfiguration.volley()
    @State private var finished = false

    var body: some View {
        let values = fireworks.flatMap(\.shaderValues)
        let motion: Float = reduceMotion ? 1 : 0
        TimelineView(.animation(minimumInterval: 1.0 / 30, paused: reduceMotion || scenePhase != .active || finished)) { timeline in
            let time = timeline.date.timeIntervalSince(start)
            Color.white
                .visualEffect { content, geometry in
                    content.colorEffect(ShaderLibrary.celebrationFireworks(.float(time), .float2(geometry.size),
                                                                          .floatArray(values), .float(motion)))
                }
        }
        .task {
            guard !reduceMotion else { return }
            do {
                try await Task.sleep(for: .seconds((fireworks.map(\.finish).max() ?? 7) + 0.2))
                finished = true
            } catch {}
        }
        .accessibilityHidden(true)
    }
}

#Preview { BloomingFireworkView() }
