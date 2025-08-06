# Implementation Plan for Ticket #6

**Ticket:** [#6: Make login button colors configurable with theme system](https://github.com/MarcinOrlowski/sddm-lavalamp-mhl/issues/6)

## Overview

Make login button colors configurable by integrating CustomButton.qml with the existing theme system, following the successful pattern from ComboBox.qml (#2).

## Implementation Steps

### Step 1: Update CustomButton.qml Component

- Add `property QtObject themeConfig` to component API
- Replace hardcoded colors with theme bindings:
  - `primaryColor: themeConfig.uiPrimaryColor`
  - `secondaryColor: themeConfig.uiSecondaryColor`
  - `textColor: themeConfig.uiTextColor`
- Replace hardcoded font: `font.family: themeConfig.uiFont`
- Preserve existing gradient computations using new theme colors
- Keep all transitions and interactions unchanged

### Step 2: Update All Button Instances in Main.qml

- Add `themeConfig: container.themeConfig` to all 5 CustomButton instances:
  - Login button (line 787)
  - Suspend button (line 831)
  - Hibernate button (line 843)
  - Shutdown button (line 855)
  - Reboot button (line 867)

### Step 3: Testing & Verification

- Test visual appearance across all 3 themes (heat, ocean, forest)
- Verify button functionality (clicks, keyboard nav, focus)
- Test hover/pressed states and smooth transitions
- Confirm consistency with other themed components

No new theme properties needed - existing `uiPrimaryColor`, `uiSecondaryColor`, `uiTextColor`, and `uiFont` are sufficient.
