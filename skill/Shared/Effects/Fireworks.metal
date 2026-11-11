// Original monochrome shader following the launch/bloom visual in:
// https://uvolchyk.me/blog/blooming-fireworks-with-metal-and-swiftui
#include <metal_stdlib>
using namespace metal;

// Analytic glowing streaks avoid the reference's per-trail sample loop.
float spark(float2 p, float2 a, float2 b, float strength) {
    float2 ab = b - a;
    float h = clamp(dot(p - a, ab) / max(dot(ab, ab), 0.000001), 0.0, 1.0);
    float d = length(p - a - h * ab);
    return strength * (exp(-d * d * 180000.0) + 0.16 * exp(-d * 95.0));
}

[[ stitchable ]] half4 monochromeFirework(float2 position, half4 color, float time, float2 size) {
    float2 p = (position - size * 0.5) / max(size.x, 1.0);
    float t = fmod(max(time, 0.0), 4.5);
    float ink = 0.0;
    float2 origin(0.0, -0.06);
    if (t < 1.2) {
        float q = t / 1.2;
        float2 head = mix(float2(0.13, 0.43), origin, 1.0 - pow(1.0 - q, 2.0));
        ink = spark(p, head + float2(0.008, 0.055), head, sin(q * M_PI_F));
    } else if (t < 3.8) {
        float age = t - 1.2;
        float spread = 1.0 - exp(-age * 1.8);
        float fade = pow(max(0.0, 1.0 - age / 2.6), 1.5);
        for (int i = 0; i < 64; ++i) {
            float seed = fract(sin(float(i) * 127.1) * 43758.5);
            float angle = float(i % 8) * (M_PI_F / 4.0) + (seed - 0.5) * 0.12;
            float radius = (0.10 + 0.28 * seed) * spread;
            float2 direction(cos(angle), sin(angle));
            float2 head = origin + direction * radius + float2(0.0, age * age * 0.045);
            float2 tail = head - direction * (0.02 + 0.10 * seed) * fade;
            ink += spark(p, tail, head, fade * (0.8 + 0.8 * seed));
        }
    }
    return half4(half3(1.0 - clamp(ink, 0.0, 1.0)), 1.0);
}
