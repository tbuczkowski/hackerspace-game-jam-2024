#version 460 core
#include <flutter/runtime_effect.glsl>

out vec4 fragColor;

uniform vec2 resolution;
uniform float currentTime;

vec3 palette(float t) {
    return .5+.5*cos(6.28318*(t+(vec3(1.0, 1.0, 0.5) * vec3(0.80, 0.90, 0.30))));
}

float computeUnion(float a, float b, float smoothing) {
    float h = clamp(0.5 + 0.5 * (b-a)/smoothing, 0, 1);
    return mix(b, a, h) - smoothing * h * (1 - h);
}

float computeSubtraction(float a, float b, float smoothing){
    float h = clamp(0.5 - 0.5*(b+a)/smoothing, 0, 1);
    return mix(b, -a, h) + smoothing * h * (1 - h);
}

float computeIntersection(float a, float b, float smoothing) {
    float h = clamp(0.5 - 0.5*(b-a)/smoothing, 0, 1);
    return mix(b, a, h) + smoothing * h * (1 - h);
}

float signedDistanceSphere(vec3 p, float size, vec3 position) {
    return length(p - position) - size;
}

float signedDistanceOctahedron(vec3 p, float size, vec3 position) {
    p = abs(p - position);
    return (p.x+p.y+p.z-size)*0.57735027;
}


float map(vec3 p) {
    vec3 q = p;
    q.xy = p.xy - vec2(0.5 * cos(currentTime/1000), 0.5 * sin(currentTime/1000));
    return computeUnion(signedDistanceSphere(q, 0.5, vec3(0, 0, 0)), signedDistanceOctahedron(p, 0.5, vec3(0, 0, 0)), 0.1);
}

void main() {
    float dx = 15.0 * (1.0/256.0);
    float dy = 10.0 * (1.0/256.0);
    vec2 uv = (FlutterFragCoord().xy * 2 - resolution.xy) / resolution.y;
    uv = vec2(uv.x, -uv.y);
    vec2 pixelFactor = 0.032 * resolution;
    uv = round(uv * pixelFactor) / pixelFactor;
    vec3 rayOrigin = vec3(uv,-1);
    vec3 rayDirection = normalize(vec3(0, 0, 1));
    vec3 color = vec3(0);

    float distanceTraveled = 0;
    for(int i = 0; i < 80; i++) {
        vec3 p = rayOrigin + rayDirection * distanceTraveled;
        float d = map(p);
        distanceTraveled += d;
        if (d < 0.001 || distanceTraveled > 100) {
            break;
        }
    }

    color = vec3(distanceTraveled * 0.75);

    fragColor = vec4(1- color, distanceTraveled > 100 ? 0 : 1);
}