import QtQuick 2.15

/**
 * Lava Lamp MHL: SDDM dynamic login theme
 *
 * @author    Marcin Orlowski <mail (#) marcinOrlowski (.) com>
 * @copyright 2025 Marcin Orlowski
 * @license   http://www.opensource.org/licenses/mit-license.php MIT
 * @link      https://github.com/MarcinOrlowski/sddm-lavalamp-mhl
 */

QtObject {
    readonly property string source: "
        uniform lowp float qt_Opacity;
        uniform highp vec2 resolution;
        uniform highp vec3 baseColor;
        uniform highp vec3 gradientColor1;
        uniform highp vec3 gradientColor2;
        uniform highp vec3 gradientColor3;
        uniform highp vec3 gradientColor4;
        uniform highp int gradientMode;
        varying highp vec2 qt_TexCoord0;

        // Calculate gradient color based on position and gradient mode
        // gradientMode: 0=vertical, 1=four_corner, 2=rainbow
        vec3 calculateGradientColor(float x, float y) {
            float u = x / resolution.x;  // 0.0 to 1.0 horizontal
            float v = y / resolution.y;  // 0.0 to 1.0 vertical

            if (gradientMode == 0) {
                // VERTICAL: Pure vertical gradient
                // color1 = top, color2 = bottom
                return mix(gradientColor1, gradientColor2, v);
            }
            else if (gradientMode == 1) {
                // FOUR_CORNER: 4-corner gradient
                vec3 topColor = mix(gradientColor1, gradientColor2, u);     // top-left to top-right
                vec3 bottomColor = mix(gradientColor3, gradientColor4, u);  // bottom-left to bottom-right
                return mix(topColor, bottomColor, v);                       // top to bottom
            }
            else {
                // RAINBOW: Default rainbow gradient
                return vec3(u, v, 1.0) * baseColor;
            }
        }

        void main() {
            // Convert texture coords to pixel coords
            float x = qt_TexCoord0.x * resolution.x;
            float y = (1.0 - qt_TexCoord0.y) * resolution.y;  // Flip Y

            vec3 color = calculateGradientColor(x, y);
            gl_FragColor = vec4(color, 1.0) * qt_Opacity;
        }
    "
}
