#version 150
#define FRAGMENT
#define VERSION_1_21_6

#moj_import <minecraft:fog.glsl>
#moj_import <minecraft:dynamictransforms.glsl>
#moj_import <minecraft:globals.glsl>

uniform sampler2D Sampler0;
uniform sampler2D Sampler2;

in vec4 baseColor;
in vec4 vertexColor;
in vec4 textureColor;

in float sphericalVertexDistance;
in float cylindricalVertexDistance;
in vec2 texCoord0;

out vec4 fragColor;

#moj_import <utils.glsl>
#moj_import <letter.glsl>
#moj_import <running_text/main.glsl>
#moj_import <animation.glsl>

bool value_equal(float a, float b) {
    return abs(a - b) < 0.002;
}
bool color_equal(vec3 a, vec3 b) {
    return length(a - b) < 0.002;
}

void main() {
    if (process()) {
        return;
    }
    vec2 uv = texCoord0;
    vec4 color = texture(Sampler0, uv);

    if (value_equal(color.a, 200.0/255.0)) {
        if (color_equal(baseColor.rgb, vec3(63.0/255.0))) color.a = 0.0;
        else color.a = 1.0;
    }

    processRunningLetter(Sampler0, uv, GameTime, color);
    processAnimation(Sampler0, color);
    color = color * vertexColor * ColorModulator;
    if (color.a < 0.1) {
        discard;
    }
    fragColor = apply_fog(color, sphericalVertexDistance, cylindricalVertexDistance, FogEnvironmentalStart, FogEnvironmentalEnd, FogRenderDistanceStart, FogRenderDistanceEnd, FogColor);
}
