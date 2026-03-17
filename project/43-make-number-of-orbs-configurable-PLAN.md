# Plan: Make number of orbs configurable

[#43: Make number of orbs configurable](https://github.com/MarcinOrlowski/sddm-lavalamp-mhl/issues/43)

## Context

The metaball (orb) count is hardcoded to 35 in both `simulationConfig` (QML)
and the fragment shader loop. Users should be able to configure this via
`theme.conf` without rebuilding shaders. Range: 16-70, default: 35.

## Changes

### 1. `src/theme.conf`

Add `orbs=35` configuration option below the `theme=` line.

### 2. `src/shaders/metaballs.frag`

- Add `int metaballCount` uniform to the uniform buffer
- Expand from 9 to 18 mat4 uniforms (`metaballData0`-`metaballData17`) to
  support up to 70 orbs (ceil(70/4) = 18)
- Expand `getMetaball()` with if/else branches for all 18 mat4s
- Change loop from `for (int i = 0; i < 35; i++)` to
  `for (int i = 0; i < metaballCount; i++)`

### 3. Rebuild shader `.qsb` files

Run `bin/build-shaders.sh` to recompile the `.frag` to `.frag.qsb`.

### 4. `src/components/Main.qml`

- **`simulationConfig`**: Read `orbs` from config with clamping to 16-70
- **ShaderEffect uniforms**: Add `metaballCount` property and
  `metaballData9`-`metaballData17` mat4 properties
- **`onTimeChanged`**: Expand matrix assignment to handle indices 9-17

## Verification

- Test with default `orbs=35` - should behave identically to current
- Test with `orbs=70` - more orbs visible
- Test with `orbs=` (empty) - should fall back to 35
- Test with `orbs=0` - should clamp to 16 (min)
- Test with `orbs=200` - should clamp to 70 (max)
- Test with non-numeric values (`orbs=abc`) - should fall back to 35 (default)
