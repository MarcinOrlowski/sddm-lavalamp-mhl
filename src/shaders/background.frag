#version 440

layout(location = 0) in vec2 qt_TexCoord0;
layout(location = 0) out vec4 fragColor;

layout(std140, binding = 0) uniform buf {
    mat4 qt_Matrix;
    float qt_Opacity;

    vec2 resolution;
    vec3 baseColor;
    vec3 gradientColor1;
    vec3 gradientColor2;
    vec3 gradientColor3;
    vec3 gradientColor4;
    int gradientMode;
};

vec3 calculateGradientColor(float x, float y) {
    float u = x / resolution.x;
    float v = y / resolution.y;

    if (gradientMode == 0) {
        return mix(gradientColor1, gradientColor2, v);
    }
    else if (gradientMode == 1) {
        vec3 topColor = mix(gradientColor1, gradientColor2, u);
        vec3 bottomColor = mix(gradientColor3, gradientColor4, u);
        return mix(topColor, bottomColor, v);
    }
    else {
        return vec3(u, v, 1.0) * baseColor;
    }
}

void main() {
    float x = qt_TexCoord0.x * resolution.x;
    float y = (1.0 - qt_TexCoord0.y) * resolution.y;

    vec3 color = calculateGradientColor(x, y);
    fragColor = vec4(color, 1.0) * qt_Opacity;
}
