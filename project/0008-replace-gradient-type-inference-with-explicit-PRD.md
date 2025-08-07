# Product Requirements Document (PRD)

**Ticket:** [#8: Replace gradient type inference with explicit gradientMode uniform in BackgroundGradientShader](https://github.com/MarcinOrlowski/sddm-lavalamp-mhl/issues/8)

## 1. Problem Statement

The current gradient rendering system in both `BackgroundGradientShader.qml` and `MetaballsFragmentShader.qml` uses fragile inference logic to determine gradient types. This creates several critical issues:

- **Unreliable threshold values**: Uses hardcoded `> 0.1` color distance thresholds that may fail with certain color combinations
- **Unpredictable behavior**: Gradient rendering depends on runtime color analysis rather than explicit configuration
- **Performance overhead**: Runtime color distance calculations executed for every pixel
- **Code duplication**: Same inference logic duplicated across two shader files
- **Maintenance complexity**: Difficult to debug gradient issues or add new gradient types

Current problematic inference logic in both shaders (lines 28-50 in BackgroundGradientShader, lines 49-71 and 79-93 in MetaballsFragmentShader):

- Calculates `distance(gradientColor1, gradientColor2)` and `distance(gradientColor1, gradientColor3)`
- Uses arbitrary `0.1` threshold to determine vertical vs 4-corner vs rainbow gradients
- Theme system defines `gradientType: "vertical"` but shaders ignore this explicit setting

## 2. Objectives

### Primary Objectives

- Replace fragile color-based inference with explicit `gradientMode` uniform parameter
- Utilize existing theme system's `gradientType` configuration values
- Eliminate performance overhead from runtime color distance calculations
- Standardize gradient behavior across both background and metaballs shaders
- Improve code maintainability and debugging capabilities

### Success Criteria

- All gradient types work reliably with any color combination
- Gradient behavior is predictable and configurable via theme system
- Performance improvement from removing runtime calculations
- Code clarity and maintainability enhanced
- No visual regression in existing themes (heat, ocean, forest)

## 3. Requirements

### Functional Requirements

- **Explicit Gradient Modes**: Define clear numeric constants for gradient types:

  - `VERTICAL (0)`: Top-to-bottom linear gradient
  - `FOUR_CORNER (1)`: Four-corner bilinear interpolation
  - `RAINBOW (2)`: UV-based rainbow gradient (current fallback)

- **Uniform Integration**: Add `uniform int gradientMode` to both shader files

- **Theme Mapping**: Map existing string values to numeric modes:

  - `"vertical"` → `0`
  - `"four_corner"` → `1`
  - `"rainbow"` → `2`

- **Consistent Behavior**: Both shaders must use identical gradient calculation logic

- **Backward Compatibility**: Existing themes continue to work without modification

### Non-Functional Requirements

- **Performance**: Eliminate per-pixel color distance calculations
- **Reliability**: Gradient behavior independent of color values
- **Maintainability**: Single source of truth for gradient type determination
- **Debuggability**: Clear correspondence between theme config and rendered output

## 4. Scope

### In Scope

- Modification of `BackgroundGradientShader.qml` to use explicit gradientMode
- Modification of `MetaballsFragmentShader.qml` to use explicit gradientMode (both instances)
- Update `Main.qml` to pass gradientMode uniforms to both shaders
- Mapping logic to convert theme string values to numeric constants
- Testing with all three existing themes to ensure no visual regression

### Out of Scope

- Adding new gradient types or visual effects
- Modifying existing theme configuration structure
- Changes to gradient color definitions or mappings
- Performance optimizations beyond gradient mode inference removal

## 5. Constraints

- Must maintain visual compatibility with existing themes
- Cannot change public theme API or configuration format
- Must preserve existing color gradient calculations (only change type determination)
- GLSL shader limitations (no string uniforms, integer uniforms only)

## 6. Acceptance Criteria

1. **Shader Integration**

   - Both shaders accept `uniform int gradientMode` parameter
   - Inference logic completely removed from both shader files
   - Gradient calculations use explicit mode checking instead of color distance

1. **Mode Definition**

   - Clear numeric constants defined: VERTICAL=0, FOUR_CORNER=1, RAINBOW=2
   - Mode selection logic centralized in Main.qml JavaScript
   - Default fallback to RAINBOW mode for undefined values

1. **Theme Compatibility**

   - All existing themes render identically to current behavior
   - `gradientType: "vertical"` properly maps to vertical gradients
   - Heat, ocean, and forest themes show no visual regression

1. **Performance Improvement**

   - No runtime color distance calculations in shader execution
   - Gradient type determination moved to JavaScript initialization
   - Measurable performance improvement in shader execution

1. **Code Quality**

   - Duplicate inference logic eliminated
   - Clear documentation of gradient mode constants
   - Improved debugging capability through explicit mode values
