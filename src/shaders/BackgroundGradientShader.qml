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
        varying highp vec2 qt_TexCoord0;

        // Calculate gradient color based on position and gradient type
        vec3 calculateGradientColor(float x, float y) {
            float u = x / resolution.x;  // 0.0 to 1.0 horizontal
            float v = y / resolution.y;  // 0.0 to 1.0 vertical

            // Determine gradient type based on color differences

            // Check if colors 1 and 2 are different (vertical gradient indicator)
            float verticalDiff = distance(gradientColor1, gradientColor2);
            // Check if colors 1 and 3 are different (4-corner gradient indicator)
            float cornerDiff = distance(gradientColor1, gradientColor3);

            if (verticalDiff > 0.1 && cornerDiff < 0.1) {
                // Pure vertical gradient: only Y changes, X stays constant
                // color1 = top, color2 = bottom
                return mix(gradientColor1, gradientColor2, v);
            }
            else if (cornerDiff > 0.1 && distance(gradientColor2, gradientColor4) > 0.1) {
                // 4-corner gradient: all four corners different
                vec3 topColor = mix(gradientColor1, gradientColor2, u);     // top-left to top-right
                vec3 bottomColor = mix(gradientColor3, gradientColor4, u);  // bottom-left to bottom-right
                return mix(topColor, bottomColor, v);                       // top to bottom
            }
            else {
                // Default: rainbow gradient
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
