# Technical Requirements Document (TRD)

**Ticket:** [#6: Make login button colors configurable with theme system](https://github.com/MarcinOrlowski/sddm-lavalamp-mhl/issues/6)

## 1. Technical Overview

### Current State Analysis

The CustomButton.qml component contains the following hardcoded values that need refactoring:

**Colors to replace:**

- Line 17: `property string primaryColor: "#8B4513"` (button primary color)
- Line 18: `property string secondaryColor: "#FF6B35"` (button secondary/border color)
- Line 19: `property string textColor: "#FFE4CC"` (button text color)
- Line 73: `font.family: "Arial"` (hardcoded font family)

**Usage locations in Main.qml:**

- Line 787: `CustomButton` (login button)
- Line 831: `CustomButton` (suspend button)
- Line 843: `CustomButton` (hibernate button)
- Line 855: `CustomButton` (shutdown button)
- Line 867: `CustomButton` (reboot button)

## 2. Technical Solution

### 2.1 Theme Integration Approach

The component will receive theme configuration through a `themeConfig` property, following the same pattern established by ComboBox.qml in ticket #2.

### 2.2 Color Mapping Strategy

| Current Hardcoded Value | New Theme Property | Purpose |
| ----------------------- | --------------------------- | ------------------------------------------- |
| `#8B4513` | `themeConfig.uiPrimaryColor` | Primary button color (base for gradients) |
| `#FF6B35` | `themeConfig.uiSecondaryColor` | Secondary color (border, focus indicator) |
| `#FFE4CC` | `themeConfig.uiTextColor` | Text color |

### 2.3 Gradient Color Computation

The current button uses computed gradient variations:

```qml
property color topGradientColor: button.pressed ? Qt.darker(primaryColor, 1.2) :
                                button.hovered ? Qt.lighter(primaryColor, 1.3) : primaryColor
property color bottomGradientColor: button.pressed ? Qt.darker(primaryColor, 1.5) :
                                   button.hovered ? Qt.lighter(Qt.darker(primaryColor, 1.3), 1.2) : Qt.darker(primaryColor, 1.3)
```

This computation pattern will be preserved but using `themeConfig.uiPrimaryColor` as the base.

### 2.4 Font Integration

- Replace `font.family: "Arial"` with `font.family: themeConfig.uiFont`
- Keep existing font size unchanged (14px)

## 3. Implementation Details

### 3.1 Component API Changes

The CustomButton component will require a `themeConfig` property:

```qml
property QtObject themeConfig
```

The existing hardcoded properties will be updated:

```qml
property string primaryColor: themeConfig.uiPrimaryColor
property string secondaryColor: themeConfig.uiSecondaryColor
property string textColor: themeConfig.uiTextColor
```

### 3.2 Main.qml Integration

All 5 CustomButton instances in Main.qml need to receive the themeConfig:

```qml
CustomButton {
    id: loginButton
    themeConfig: root.themeConfig
    // ... rest of properties
}
```

### 3.3 Theme Color Values

Each theme provides these button-relevant colors:

**Heat theme:**

- `uiPrimaryColor: "#8B4513"` (saddle brown)
- `uiSecondaryColor: "#FF6B35"` (orange red)
- `uiTextColor: "#FFE4CC"` (peach)

**Ocean theme:**

- `uiPrimaryColor: "#2060A0"` (deep blue)
- `uiSecondaryColor: "#4080C0"` (sky blue)
- `uiTextColor: "#E0F0FF"` (light blue)

**Forest theme:**

- `uiPrimaryColor: "#408040"` (forest green)
- `uiSecondaryColor: "#60A060"` (light green)
- `uiTextColor: "#E0FFE0"` (pale green)

## 4. Testing Strategy

### 4.1 Visual Testing

- Verify button appearance with all three themes (heat, ocean, forest)
- Test hover states and pressed states
- Verify focus indicators work correctly
- Test smooth transitions between states

### 4.2 Functional Testing

- Ensure button functionality unchanged (click events)
- Verify keyboard navigation works (Tab, Enter, Space)
- Test all 5 button instances (login, suspend, hibernate, shutdown, reboot)

### 4.3 Integration Testing

- Test theme switching maintains button consistency
- Verify buttons integrate visually with other themed components
- Test with different screen resolutions and scaling

## 5. Implementation Considerations

### 5.1 Backwards Compatibility

- Component API changes are additive (themeConfig property)
- Existing button behavior preserved
- No breaking changes to external consumers
- Fallback values could be provided if themeConfig is undefined

### 5.2 Performance Impact

- No additional memory allocation
- Same number of QML bindings
- Color computation remains client-side
- No impact on rendering performance

### 5.3 Maintenance Benefits

- Eliminates hardcoded color maintenance
- Centralizes theming through existing system
- Improves visual consistency across components
- Simplifies future theme additions

## 6. Risk Analysis

### 6.1 Low Risk Items

- Color mapping is straightforward 1:1 replacement
- Theme system already established and working
- Pattern already proven with ComboBox component

### 6.2 Considerations

- Ensure all 5 button instances are updated consistently
- Verify color contrast remains adequate across all themes
- Test button visibility against dynamic background
- Validate smooth transitions with new color values
