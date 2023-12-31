#version 460 core
#include <flutter/runtime_effect.glsl>

out vec4 fragColor;

uniform vec2 resolution;

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


float map(vec3 p) {
    vec3 q = p;
    q = fract(p) - 0.5;
    float sphere1 = signedDistanceSphere(q, 0.6, vec3(0, 0, 1));
    float sphere2 = signedDistanceSphere(p, 0.7, vec3(-0.35, 0, 0));
    return computeUnion(sphere1, sphere2, 0.2);
return sphere1;
}

void main() {
    vec2 uv = (FlutterFragCoord().xy * 2 - resolution.xy) / resolution.y;
    uv = vec2(uv.x, -uv.y);
    vec3 rayOrigin = vec3(0,0,-3);
    vec3 rayDirection = normalize(vec3(uv, 1));
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

    color = vec3(distanceTraveled*0.2);

    fragColor = vec4(color, 1);
}