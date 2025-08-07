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
        uniform highp float time;
        uniform highp float randomSeed;
        uniform highp vec2 resolution;
        uniform highp int numMetaballs;
        uniform highp float minSize;
        uniform highp float maxSize;
        uniform highp float minSpeed;
        uniform highp float maxSpeed;
        uniform highp float threshold;
        uniform highp vec3 baseColor;
        uniform highp vec3 gradientColor1;
        uniform highp vec3 gradientColor2;
        uniform highp vec3 gradientColor3;
        uniform highp vec3 gradientColor4;
        uniform highp int gradientMode;
        uniform highp float verticalBias;
        uniform highp float horizontalScale;
        uniform highp bool backgroundGradientEnabled;
        uniform highp vec3 backgroundGradientColor1;
        uniform highp vec3 backgroundGradientColor2;
        uniform highp vec3 backgroundGradientColor3;
        uniform highp vec3 backgroundGradientColor4;
        uniform highp bool glowEffectEnabled;
        uniform highp float glowIntensity;
        uniform highp float glowInnerThreshold;
        uniform highp float glowMidThreshold;
        uniform highp float glowOuterThreshold;
        uniform highp float glowMinFieldStrength;
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
                // RAINBOW: Default rainbow gradient (original behavior)
                return vec3(u, v, 1.0) * baseColor;
            }
        }

        // Calculate background gradient color at given position
        // Uses same gradient mode as main gradient
        vec3 calculateBackgroundGradientColor(float x, float y) {
            float u = x / resolution.x;  // 0.0 to 1.0 horizontal
            float v = y / resolution.y;  // 0.0 to 1.0 vertical

            if (gradientMode == 0) {
                // VERTICAL: Background vertical gradient
                return mix(backgroundGradientColor1, backgroundGradientColor2, v);
            }
            else if (gradientMode == 1) {
                // FOUR_CORNER: Background 4-corner gradient
                vec3 topColor = mix(backgroundGradientColor1, backgroundGradientColor2, u);
                vec3 bottomColor = mix(backgroundGradientColor3, backgroundGradientColor4, u);
                return mix(topColor, bottomColor, v);
            }
            else {
                // RAINBOW: Background rainbow gradient
                return vec3(u, v, 1.0) * baseColor;
            }
        }

        vec3 getMetaball(int index) {
            float seed = (float(index) + randomSeed) * 12.9898;
            float randomX = fract(sin(seed) * 43758.5453);
            float randomY = fract(sin(seed * 1.618) * 43758.5453);
            float randomVX = fract(sin(seed * 2.718) * 43758.5453);
            float randomVY = fract(sin(seed * 3.141) * 43758.5453);
            float randomR = fract(sin(seed * 1.414) * 43758.5453);
            float randomSpeed = fract(sin(seed * 2.236) * 43758.5453);  // New random for speed

            // Use configurable size range
            float radius = randomR * (maxSize - minSize) + minSize;

            // Use configurable speed range - each metaball gets its own speed!
            float speed = randomSpeed * (maxSpeed - minSpeed) + minSpeed;
            float vx = (randomVX - 0.5) * 2.0 * speed * horizontalScale;
            float vy = (randomVY - 0.5) * 2.0 * speed * verticalBias;

            // Initial positions
            float startX = randomX * (resolution.x - 2.0 * radius) + radius;
            float startY = randomY * (resolution.y - 2.0 * radius) + radius;

            // Simple linear animation
            float x = startX + vx * time;
            float y = startY + vy * time;

            // Bouncing boundaries: ball bounces when fully off-screen
            // Left/right boundaries: ball bounces at -radius and resolution.x + radius
            float leftBound = -radius;
            float rightBound = resolution.x + radius;
            float topBound = -radius;
            float bottomBound = resolution.y + radius;

            // Calculate total bounce distance for each axis
            float bounceWidth = rightBound - leftBound;  // resolution.x + 2*radius
            float bounceHeight = bottomBound - topBound; // resolution.y + 2*radius

            // Ball bouncing
            // For X axis
            float relativeX = x - leftBound; // Position relative to left bound
            float bounceCount = floor(relativeX / bounceWidth);
            float posInCycle = relativeX - bounceCount * bounceWidth;

            // Even bounces: normal direction, odd: reversed direction
            if (mod(bounceCount, 2.0) == 0.0) {
                x = leftBound + posInCycle;
            } else {
                x = leftBound + bounceWidth - posInCycle;
            }

            // For Y axis
            float relativeY = y - topBound; // Position relative to top bound
            bounceCount = floor(relativeY / bounceHeight);
            posInCycle = relativeY - bounceCount * bounceHeight;

            if (mod(bounceCount, 2.0) == 0.0) {
                y = topBound + posInCycle;
            } else {
                y = topBound + bounceHeight - posInCycle;
            }

            float r = radius;  // Use full configured radius

            return vec3(x, y, r);
        }

        void main() {
            // Convert texture coords to pixel coords like gl_FragCoord
            float x = qt_TexCoord0.x * resolution.x;
            float y = (1.0 - qt_TexCoord0.y) * resolution.y;  // Flip Y

            float sum = 0.0;

            for (int i = 0; i < {{MAX_METABALLS}}; i++) {
                vec3 metaball = getMetaball(i);
                float dx = metaball.x - x;
                float dy = metaball.y - y;
                float radius = metaball.z;

                // Skip off-screen metaballs
                if (metaball.x < -1000.0 || metaball.y < -1000.0) continue;

                float distSq = dx * dx + dy * dy;
                if (distSq > 0.0) {
                    sum += (radius * radius) / distSq;
                }
            }

            if (glowEffectEnabled) {
                // Glow effect mode - render both core (threshold-based) and glow (field-based)
                float fieldStrength = min(1.0, sum * glowIntensity / 10.0);

                if (sum >= threshold) {
                    // Core metaball - same size as non-glow mode
                    vec3 colorBase = calculateGradientColor(x, y);
                    gl_FragColor = vec4(colorBase, 1.0) * qt_Opacity;
                }
                else if (fieldStrength > glowMinFieldStrength) {
                    // Glow area - only visible around the core
                    vec3 colorBase = calculateGradientColor(x, y);
                    vec3 glowColor = vec3(0.0);
                    float alpha = 1.0;

                    // Create glow bands
                    if (fieldStrength >= glowInnerThreshold) {
                        glowColor = colorBase * 0.8;
                        alpha = 0.8;
                    }
                    else if (fieldStrength >= glowMidThreshold) {
                        float fade = (fieldStrength - glowMidThreshold) / (glowInnerThreshold - glowMidThreshold);
                        glowColor = mix(colorBase * 0.4, colorBase * 0.8, fade);
                        alpha = mix(0.4, 0.8, fade);
                    }
                    else if (fieldStrength >= glowOuterThreshold) {
                        float fade = (fieldStrength - glowOuterThreshold) / (glowMidThreshold - glowOuterThreshold);
                        glowColor = mix(colorBase * 0.1, colorBase * 0.4, fade);
                        alpha = mix(0.2, 0.4, fade);
                    }
                    else {
                        float fade = fieldStrength / glowOuterThreshold;
                        glowColor = colorBase * 0.1 * fade;
                        alpha = 0.2 * fade;
                    }

                    gl_FragColor = vec4(glowColor, alpha) * qt_Opacity;
                } else {
                    // Transparent background
                    gl_FragColor = vec4(0.0, 0.0, 0.0, 0.0);
                }
            } else {
                // Simple binary threshold mode
                if (sum >= threshold) {
                    vec3 colorBase = calculateGradientColor(x, y);

                    // Get the correct background color for proper blending
                    vec3 bgColor = backgroundGradientEnabled ?
                        calculateBackgroundGradientColor(x, y) :
                        vec3(0.0, 0.0, 0.0);

                    float fade = max(0.0, 1.0 - (sum - threshold) * 100.0);

                    vec3 finalColor = mix(colorBase, bgColor, fade);
                    gl_FragColor = vec4(finalColor, 1.0) * qt_Opacity;
                } else {
                    // Transparent background to show background gradient
                    gl_FragColor = vec4(0.0, 0.0, 0.0, 0.0);
                }
            }
        }
    "
}
