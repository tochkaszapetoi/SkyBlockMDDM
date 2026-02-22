#version 150
#define VERTEX
#define VERSION_1_21_6

#moj_import <minecraft:fog.glsl>
#moj_import <minecraft:dynamictransforms.glsl>
#moj_import <minecraft:projection.glsl>
#moj_import <minecraft:globals.glsl>

in vec3 Position;
in vec4 Color;
in vec2 UV0;
in ivec2 UV2;

uniform sampler2D Sampler0;
uniform sampler2D Sampler2;

vec2 UV;
vec4 newColor;
vec3 newPosition;

out vec4 baseColor;
out vec4 vertexColor;
out vec4 textureColor;

out float sphericalVertexDistance;
out float cylindricalVertexDistance;
out vec2 texCoord0;

#moj_import <utils.glsl>
#moj_import <interpolation.glsl>
#moj_import <structure.glsl>
#moj_import <structure_small.glsl>
#moj_import <structure_medium.glsl>
#moj_import <letter.glsl>
#moj_import <animation.glsl>
#moj_import <running_text/main.glsl>

const vec4 runningLetterMarkerColor = vec4(float(175), float(54), float(193), float(35)) / float(255);

void main() {
    UV = UV0;
    newColor = Color;
    newPosition = Position;
    processAnimation();
    processStructure();
    processStructureSmall();
    processStructureMedium();
    processRunningLetter(Sampler0, gl_VertexID % 4, UV, newColor, newPosition, runningLetterMarkerColor);

    gl_Position = ProjMat * ModelViewMat * vec4(newPosition, 1.0);

    baseColor = newColor;
    textureColor = texelFetch(Sampler2, UV2 / 16, 0);

    sphericalVertexDistance = fog_spherical_distance(Position);
    cylindricalVertexDistance = fog_cylindrical_distance(Position);
    vertexColor = baseColor * textureColor;
    texCoord0 = UV;

    if (process()) {
        return;
    }
}
