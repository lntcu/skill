// Independent analytic launch/bloom shader. Visual reference:
// https://uvolchyk.me/blog/blooming-fireworks-with-metal-and-swiftui
#include <metal_stdlib>
using namespace metal;

float spark(float2 p, float2 a, float2 b, float strength) {
    float2 ab = b - a;
    float h = clamp(dot(p - a, ab) / max(dot(ab, ab), 0.000001), 0.0, 1.0);
    float d = length(p - a - h * ab);
    return strength * (0.3 + 0.7 * h) * (exp(-d * d * 200000.0) + 0.12 * exp(-d * 110.0));
}
float2 launchPosition(float2 start, float2 end, float q, float curve) {
    return mix(start, end, q) + float2(curve, -0.12) * sin(q * M_PI_F);
}

[[ stitchable ]] half4 celebrationFireworks(float2 position, half4 color, float time, float2 size,
                                            device const float *data, int count, float reducedMotion) {
    float2 p = position / max(size.x, 1.0);
    float aspect = size.y / max(size.x, 1.0);
    float3 pigment(0.0);
    for (int offset = 0; offset + 15 < count; offset += 16) {
        float2 start(data[offset], data[offset + 1] * aspect);
        float2 end(data[offset + 2], data[offset + 3] * aspect);
        float delay = data[offset + 4], launch = data[offset + 5], duration = data[offset + 6];
        float t = reducedMotion > 0.5 ? launch + duration * 0.3 : time - delay;
        if (t < 0 || t > launch + duration) continue;
        float ink = 0.0;
        if (t < launch) {
            float q = 1.0 - pow(1.0 - t / launch, 1.5);
            float2 head = launchPosition(start, end, q, data[offset + 11]);
            float2 tail = launchPosition(start, end, max(0.0, q - 0.07), data[offset + 11]);
            ink = spark(p, tail, head, 0.9);
        } else {
            float age = t - launch, progress = age / duration;
            float radius = data[offset + 9];
            if (distance(p, end + float2(0, progress * progress * 0.18)) > radius + 0.2) continue;
            float spread = 1.0 - exp(-progress * 5.0);
            float fade = pow(1.0 - progress, 1.4);
            int particles = int(data[offset + 7]), bursts = int(data[offset + 8]);
            for (int cluster = 0; cluster < bursts; ++cluster) {
                float phase = data[offset + 10] + float(cluster) * 2.094;
                float2 center = end + float2(cos(phase), sin(phase)) * float(cluster) * 0.035;
                for (int i = 0; i < particles; ++i) {
                    float seed = fract(sin(float(i + cluster * 67) * 127.1 + phase) * 43758.5);
                    float angle = float(i) * 2.399963 + phase;
                    float2 direction(cos(angle), sin(angle));
                    float2 head = center + direction * radius * (0.4 + seed * 0.6) * spread
                                + float2(0.0, progress * progress * 0.18);
                    float2 tail = head - direction * (0.015 + seed * 0.055) * fade;
                    ink += spark(p, tail, head, fade * (0.6 + seed));
                }
            }
        }
        float3 rgb(data[offset + 12], data[offset + 13], data[offset + 14]);
        pigment += (1.0 - rgb) * ink * 1.6;
    }
    return half4(half3(exp(-pigment)), 1.0);
}
