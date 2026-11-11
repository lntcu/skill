import SwiftUI

struct FireworkConfiguration {
    let start: CGPoint
    let end: CGPoint
    let delay: Float
    let launch: Float
    let duration: Float
    let particles: Float
    let bursts: Float
    let radius: Float
    let seed: Float
    let curve: Float
    let hue: Double

    var finish: Double { Double(delay + launch + duration) }
    var shaderValues: [Float] {
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        UIColor(hue: hue, saturation: 0.8, brightness: 0.9, alpha: 1).getRed(&r, green: &g, blue: &b, alpha: &a)
        return [Float(start.x), Float(start.y), Float(end.x), Float(end.y), delay, launch, duration,
                particles, bursts, radius, seed, curve, Float(r), Float(g), Float(b), 0]
    }

    static func volley() -> [FireworkConfiguration] {
        let count = Int.random(in: 2...5)
        let baseHue = Double.random(in: 0...1)
        return (0..<count).map { index in
            let start: CGPoint
            switch Int.random(in: 0...4) {
            case 0: start = CGPoint(x: 0, y: Double.random(in: 0.55...0.95))
            case 1: start = CGPoint(x: 1, y: Double.random(in: 0.55...0.95))
            case 2: start = CGPoint(x: 0, y: 1)
            case 3: start = CGPoint(x: 1, y: 1)
            default: start = CGPoint(x: Double.random(in: 0.05...0.95), y: 1)
            }
            return FireworkConfiguration(start: start, end: CGPoint(x: Double.random(in: 0.18...0.82), y: Double.random(in: 0.18...0.58)),
                                         delay: index == 0 ? Float.random(in: 0.05...0.3) : Float.random(in: 0.4...3), launch: Float.random(in: 0.7...1.6),
                                         duration: Float.random(in: 1.5...3.3), particles: Float(Int.random(in: 20...52)),
                                         bursts: Float(Int.random(in: 1...3)), radius: Float.random(in: 0.13...0.27),
                                         seed: Float.random(in: 1...100), curve: Float.random(in: -0.18...0.18),
                                         hue: (baseHue + Double(index) / Double(count) + Double.random(in: 0...0.06)).truncatingRemainder(dividingBy: 1))
        }
    }
}
