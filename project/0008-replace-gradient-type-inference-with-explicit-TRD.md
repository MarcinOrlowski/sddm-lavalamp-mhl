# Technical Requirements Document (TRD)

**Ticket:** [#8: Replace gradient type inference with explicit gradientMode uniform in BackgroundGradientShader](https://github.com/MarcinOrlowski/sddm-lavalamp-mhl/issues/8)

## 1. Technical Overview

### Current State Analysis

Both shader files contain identical problematic inference logic that needs to be replaced:

**BackgroundGradientShader.qml (lines 28-50):**

```glsl
// Determine gradient type based on color differences
float verticalDiff = distance(gradientColor1, gradientColor2);
float cornerDiff = distance(gradientColor1, gradientColor3);

if (verticalDiff > 0.1 && cornerDiff < 0.1) {
    // Pure vertical gradient
} else if (cornerDiff > 0.1 && distance(gradientColor2, gradientColor4) > 0.1) {
    // 4-corner gradient  
} else {
    // Default: rainbow gradient
}
```

**MetaballsFragmentShader.qml (lines 49-71 and 79-93):**

- Duplicate logic in `calculateGradientColor()` function
- Duplicate logic in `calculateBackgroundGradientColor()` function
- Same `0.1` threshold values and identical conditional structure

### Current Theme Integration

Main.qml already defines gradient types in themes but they're ignored by shaders:

```javascript
readonly property string gradientType: "vertical"           // heat theme
readonly property string backgroundGradientType: "vertical"  // heat theme
```

## 2. Technical Solution

### 2.1 Gradient Mode Constants

Define clear numeric constants for GLSL compatibility:

```javascript
// Gradient mode constants
const GRADIENT_MODE_VERTICAL = 0      // Top-to-bottom linear
const GRADIENT_MODE_FOUR_CORNER = 1   // Four-corner bilinear
const GRADIENT_MODE_RAINBOW = 2       // UV-based rainbow
```

### 2.2 Shader Interface Changes

Both shaders will accept new uniform parameter:

```glsl
uniform int gradientMode;  // 0=vertical, 1=four_corner, 2=rainbow
```

### 2.3 Mode Mapping Logic

Main.qml will convert theme strings to numeric modes:

```javascript
function getGradientMode(gradientType) {
    switch(gradientType) {
        case "vertical": return 0
        case "four_corner": return 1
        case "rainbow": return 2
        default: return 2  // fallback to rainbow
    }
}
```

## 3. Implementation Details

### 3.1 BackgroundGradientShader.qml Changes

**Remove lines 28-50 (inference logic)**

**Replace with explicit mode checking:**

```glsl
vec3 calculateGradientColor(float x, float y) {
    float u = x / resolution.x;  // 0.0 to 1.0 horizontal
    float v = y / resolution.y;  // 0.0 to 1.0 vertical

    if (gradientMode == 0) {
        // VERTICAL: Pure vertical gradient
        return mix(gradientColor1, gradientColor2, v);
    }
    else if (gradientMode == 1) {
        // FOUR_CORNER: 4-corner gradient
        vec3 topColor = mix(gradientColor1, gradientColor2, u);
        vec3 bottomColor = mix(gradientColor3, gradientColor4, u);
        return mix(topColor, bottomColor, v);
    }
    else {
        // RAINBOW: Default rainbow gradient
        return vec3(u, v, 1.0) * baseColor;
    }
}
```

### 3.2 MetaballsFragmentShader.qml Changes

**Update calculateGradientColor() function (lines 45-72):**

- Replace inference logic with identical mode-based logic as background shader

**Update calculateBackgroundGradientColor() function (lines 75-94):**

- Replace inference logic with mode-based logic using background colors

**Add uniform declaration:**

```glsl
uniform int gradientMode;
```

### 3.3 Main.qml Integration

**Add gradient mode calculation in themeConfig:**

```javascript
readonly property int gradientModeValue: getGradientMode(activeTheme.gradientType)
readonly property int backgroundGradientModeValue: getGradientMode(activeTheme.backgroundGradientType)
```

**Update background gradient ShaderEffect (line 422):**

```javascript
ShaderEffect {
    // ... existing properties ...
    property int gradientMode: themeConfig.backgroundGradientModeValue
}
```

**Update metaballs ShaderEffect (line 438):**

```javascript
ShaderEffect {
    // ... existing properties ...
    property int gradientMode: themeConfig.gradientModeValue
}
```

## 4. Theme Compatibility Mapping

### 4.1 Existing Theme Analysis

All themes currently use `"vertical"` gradient type:

```javascript
// Heat theme
readonly property string gradientType: "vertical"
readonly property string backgroundGradientType: "vertical"

// Ocean theme  
readonly property string gradientType: "vertical"
readonly property string backgroundGradientType: "vertical"

// Forest theme
readonly property string gradientType: "vertical"
readonly property string backgroundGradientType: "vertical"
```

**Result:** All themes will map to `gradientMode = 0` (VERTICAL)

### 4.2 Color Configuration Compatibility

Current themes define appropriate color pairs for vertical gradients:

- Colors 1&2 are different (vertical gradient indicators)
- Colors 3&4 match colors 1&2 (no four-corner usage)

This mapping preserves existing visual behavior exactly.

## 5. Performance Analysis

### 5.1 Shader Execution Improvements

**Before (per-pixel):**

```glsl
float verticalDiff = distance(gradientColor1, gradientColor2);     // 3 operations
float cornerDiff = distance(gradientColor1, gradientColor3);      // 3 operations  
if (verticalDiff > 0.1 && cornerDiff < 0.1) { ... }              // 2 comparisons
```

Total: 6 operations + 2 comparisons per pixel

**After (per-pixel):**

```glsl
if (gradientMode == 0) { ... }    // 1 comparison
```

Total: 1 comparison per pixel

**Performance gain:** ~85% reduction in gradient selection overhead

### 5.2 Initialization Cost

Mode calculation moves to JavaScript initialization (once per theme change) instead of per-pixel shader execution.

## 6. Testing Strategy

### 6.1 Visual Regression Testing

**Test with all themes:**

- Heat theme: Verify identical orange-to-red vertical gradient
- Ocean theme: Verify identical blue-to-cyan vertical gradient
- Forest theme: Verify identical green vertical gradient

**Test both shader contexts:**

- Background gradient (behind metaballs)
- Metaballs gradient (animated elements)

### 6.2 Performance Testing

**Shader compilation:**

- Verify both shaders compile successfully with new uniform
- Test shader loading time (should be unchanged)

**Runtime performance:**

- Monitor frame rate with complex scenes
- Verify smooth animations maintained

### 6.3 Edge Case Testing

**Invalid gradient type handling:**

- Test undefined gradientType values (should default to rainbow)
- Test empty or null gradientType strings

## 7. Implementation Considerations

### 7.1 Backwards Compatibility

- Theme configuration format unchanged
- Existing theme files work without modification
- New numeric modes internal implementation detail

### 7.2 Future Extensibility

- Adding new gradient modes requires:
  1. New constant definition
  1. Case addition in mapping function
  1. Logic addition in both shader functions
- Framework supports easy gradient type expansion

### 7.3 Debugging Improvements

- Gradient mode visible in shader debuggers as integer value
- Clear correspondence between theme config and rendered output
- Eliminates color-dependent gradient behavior confusion
