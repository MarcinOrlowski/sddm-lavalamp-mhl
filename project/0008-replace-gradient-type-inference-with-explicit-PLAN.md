# Implementation PLAN for Ticket #8

**Goal:** Replace gradient inference with explicit `gradientMode` uniform in both shaders

## Phase 1: Shader Updates

1. **BackgroundGradientShader.qml**

   - Add `uniform int gradientMode` declaration
   - Replace lines 28-50 inference logic with explicit mode checking
   - Update `calculateGradientColor()` function with switch logic

1. **MetaballsFragmentShader.qml**

   - Add `uniform int gradientMode` declaration
   - Update `calculateGradientColor()` function (lines 45-72)
   - Update `calculateBackgroundGradientColor()` function (lines 75-94)
   - Replace both instances of inference logic

## Phase 2: Main.qml Integration

3. **Add mode mapping function**

   - Create `getGradientMode(gradientType)` JavaScript function
   - Map: "vertical"→0, "four_corner"→1, "rainbow"→2

1. **Update themeConfig**

   - Add `gradientModeValue` and `backgroundGradientModeValue` properties
   - Use mapping function to convert theme strings to numeric modes

1. **Update ShaderEffect bindings**

   - Background gradient: Add `gradientMode` property
   - Metaballs shader: Add `gradientMode` property

## Phase 3: Testing & Validation

6. **Visual testing** with all three themes (heat/ocean/forest)
1. **Performance verification** - confirm smoother rendering
1. **Edge case testing** - invalid gradient types

**Expected Result:** Reliable gradient rendering with 85% performance improvement
