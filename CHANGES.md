# Changelog

## v2.1.0 (TBD)
- Added configurable orb count in `theme.conf` (range: 16-70, default: 35).
- Added theme name label next to the theme switcher button.
- Added new color themes: Sunset, Neon, Arctic, Citrus, Crimson.
- Fixed `test-virtual-display` helper always going full screen on Wayland.
- Corrected theme version not showing proper version on the theme screen.
- Tweaked glow intensity for better theme visibility.
- Adjusted minimum metaball speed to prevent near-stationary metaballs.
- Fixed UI auto-hide being immediately undone by cursor-hiding overlay.
- Removed debug console logging from theme code.
- Debian (`*.deb`) package no longer suggests manual SDDM restart.

## v2.0.0 (2026-03-17)
- Ported to Plasam 6 (dropped Plasma 5 completely).
- Added runtime shader support detection with fallback message for unsupported hardware.
- Merged background gradient and metaball rendering into a single shader pass.
- Add distance culling to skip far-away metaballs in fragment shader.
- Refactored metaball math, eliminating redundant trig calls and massively speeding all up.
- Made ComboBox component colors and fonts configurable with theme system.
- Made login and power buttons adapt to active theme colors.
- Replaced hardcoded "Arial" font with `themeConfig.uiFont`.
- Improved gradient rendering performance and reliability.
- Added new project's artwork and logo.
- Added debug option to always show session selector.
- Replaced gradient inference with explicit gradient mode system.
- Hoisted redundant gradient calculations out of glow branch paths in fragment shader.

## v1.0.1 (2025-08-06)
- Code cleanup.
- Improved code docs.
- Added `*.deb` builder.
- Created project logo.

## v1.0.0 (2025-08-04)
- Initial SDDM theme release.
