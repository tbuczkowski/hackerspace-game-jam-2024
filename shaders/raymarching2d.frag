#version 460 core
#include <flutter/runtime_effect.glsl>

out vec4 fragColor;

uniform vec2 resolution;

uniform sampler2D spheres;

const int spheresCount = 256;

float radius = 30 / resolution.x;

void main() {
    vec2 uv = FlutterFragCoord().xy/resolution.x;
    vec4 color = vec4(1);
    for(int i = 0; i < spheresCount; i++) {
        vec4 sphere = texture(spheres, vec2(float(i)/float(spheresCount), 0.0));
        if (sphere.a == 0.0) {
            continue;
        }
        // b to x
        // g to y
        vec2 pos = vec2(sphere.b, sphere.g);
        vec2 distance = abs(pos - uv);
        if(length(distance) < radius) {
            color = vec4(1, 0, 0, 1);
        }
    }
    fragColor = color;
}