# Implementation Plan

**Ticket:** [#2: Refactor: Make colors and font family configurable in ComboBox.qml](https://github.com/MarcinOrlowski/sddm-lavalamp-mhl/issues/2)

## Implementation Steps

### Step 1: Add themeConfig property

- Add `property QtObject themeConfig` to ComboBox.qml

### Step 2: Replace hardcoded colors

- Replace `#FF00FF` backgrounds → `themeConfig.uiBackgroundColor`
- Replace border colors → `themeConfig.uiPrimaryColor` / `themeConfig.uiSecondaryColor`
- Replace text colors → `themeConfig.uiTextColor`
- Replace delegate hover color → `Qt.darker(themeConfig.uiPrimaryColor, 1.3)`

### Step 3: Replace hardcoded fonts

- Replace all `font.family: "Arial"` → `font.family: themeConfig.uiFont`

### Step 4: Update Main.qml usage

- Pass `themeConfig: themeConfig` to session ComboBox instance

### Step 5: Test with all themes

- Verify heat, ocean, forest themes work correctly
- Test dropdown functionality and hover states
