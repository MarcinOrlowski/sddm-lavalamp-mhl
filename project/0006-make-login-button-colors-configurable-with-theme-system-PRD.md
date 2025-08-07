# Product Requirements Document (PRD)

**Ticket:** [#6: Make login button colors configurable with theme system](https://github.com/MarcinOrlowski/sddm-lavalamp-mhl/issues/6)

## 1. Problem Statement

The CustomButton.qml component (used for login and power buttons) currently uses hardcoded colors, which creates visual inconsistency across the three available themes (heat, ocean, forest). While other UI elements like ComboBox successfully adapt to active themes, the login button remains visually unchanged, breaking the cohesive theming experience.

Current issues:

- 3 hardcoded color values: `primaryColor: "#8B4513"`, `secondaryColor: "#FF6B35"`, `textColor: "#FFE4CC"`
- No integration with existing theme system
- Visual inconsistency across heat, ocean, and forest themes
- All 5 button instances (login, suspend, hibernate, shutdown, reboot) affected

## 2. Objectives

### Primary Objectives

- Integrate CustomButton.qml component with existing theme system
- Remove all hardcoded colors from CustomButton component
- Ensure visual consistency with other themed UI elements
- Maintain existing button functionality and interactions

### Success Criteria

- All hardcoded colors replaced with theme properties
- Button appearance adapts correctly to all three themes
- Visual consistency with existing themed components (ComboBox pattern)
- No regression in button functionality or keyboard navigation
- Font integration uses theme font system

## 3. Requirements

### Functional Requirements

- CustomButton must adapt colors based on active theme (heat/ocean/forest)
- Component must maintain current functionality (click, hover, keyboard navigation)
- Buttons must use appropriate theme properties for primary/secondary colors and text
- Font family must use the generic UI font from theme configuration
- All 5 button instances must be updated to use theme integration

### Non-Functional Requirements

- No performance degradation
- No additional memory usage
- Maintains existing keyboard accessibility and tab navigation
- Compatible with existing QML structure and component API
- Smooth color transitions preserved

## 4. Scope

### In Scope

- CustomButton.qml component refactoring for theme integration
- Color mapping to existing theme properties (`uiPrimaryColor`, `uiSecondaryColor`, `uiTextColor`)
- Font family standardization using `themeConfig.uiFont`
- Update all 5 CustomButton usage instances in Main.qml
- Testing with all three themes (heat, ocean, forest)
- Verification of hover states and focus indicators

### Out of Scope

- Creating new theme properties (unless no existing one can achieve the effect)
- Button size or layout modifications
- Component functionality changes beyond theming
- Other component theming (only CustomButton)
- Performance optimizations unrelated to theming

## 5. Constraints

- Must use existing theme properties first (`uiPrimaryColor`, `uiSecondaryColor`, `uiTextColor`, `uiBackgroundColor`, `uiFont`)
- Can introduce new theme attributes only if no existing one can be used to achieve the effect
- Must preserve current component API and behavior
- Must maintain existing button sizes and spacing
- Must preserve smooth transition animations

## 6. Acceptance Criteria

1. **Color Integration**

   - Primary gradient colors use `themeConfig.uiPrimaryColor` and computed variations
   - Secondary/border colors use `themeConfig.uiSecondaryColor`
   - Text colors use `themeConfig.uiTextColor`
   - No hardcoded color values remain in CustomButton.qml

1. **Font Integration**

   - All font family references use `themeConfig.uiFont`
   - Font sizes remain unchanged (14px)

1. **Theme Compatibility**

   - Login button displays correctly in heat theme (warm browns/oranges)
   - Login button displays correctly in ocean theme (blues/cyans)
   - Login button displays correctly in forest theme (greens)
   - Power buttons (suspend/hibernate/shutdown/reboot) themed consistently

1. **Functionality Preservation**

   - Click behavior unchanged
   - Keyboard navigation and focus indicators work correctly
   - Hover states and transitions preserved
   - Pressed states maintain visual feedback

1. **Integration Requirements**

   - CustomButton receives `themeConfig` property like ComboBox
   - All 5 button instances in Main.qml updated with themeConfig
   - Component API remains backward compatible
