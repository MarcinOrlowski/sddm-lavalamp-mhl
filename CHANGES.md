# Changelog

## @dev (TBD)
- Ported to Plasam 6 (dropped Plasma 5 completely).
- Added new, better looking project logo.
- Merged background gradient and metaball rendering into a single shader pass.
- Add distance culling to skip far-away metaballs in fragment shader.
- Refactored metaball math, eliminating redundant trig calls and massively speeding all up.
- Made ComboBox component colors and fonts configurable with theme system.
- Made login and power buttons adapt to active theme colors.
- Replaced hardcoded "Arial" font with `themeConfig.uiFont`.
- Improved gradient rendering performance and reliability.
- Added new project's artork and logo.
- Added debug option to always show session selector.
- Replaced gradient inference with explicit gradient mode system.

## v1.0.1 (2025-08-06)
- Code cleanup.
- Improved code docs.
- Added `*.deb` builder.
- Created project logo.

## v1.0.0 (2025-08-04)
- Initial SDDM theme release.
