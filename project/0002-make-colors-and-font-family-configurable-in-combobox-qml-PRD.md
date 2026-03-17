# Product Requirements Document (PRD)

**Ticket:** [#2: Refactor: Make colors and font family configurable in ComboBox.qml](https://github.com/MarcinOrlowski/sddm-lavalamp-mhl/issues/2)

## 1. Problem Statement

The ComboBox.qml component currently uses hardcoded colors and font family, which limits its reusability and makes it difficult to integrate with different themes. The component has:

- 8 hardcoded color values including magenta backgrounds (#FF00FF)
- Hardcoded "Arial" font family in multiple locations
- Inconsistency with the existing theming system

## 2. Objectives

### Primary Objectives

- Remove hardcoded colors from ComboBox.qml component
- Replace hardcoded "Arial" font with generic `uiFont` from theme system
- Ensure consistency with existing theme architecture
- Maintain visual appearance across all three themes (heat, ocean, forest)

### Success Criteria

- All hardcoded colors replaced with theme properties
- Font family uses `themeConfig.uiFont`
- Component works correctly with all existing themes
- No new theme properties introduced
- Backwards compatibility maintained

## 3. Requirements

### Functional Requirements

- ComboBox must adapt colors based on active theme
- Font family must use the generic UI font from theme configuration
- Component must maintain current functionality (dropdown behavior, keyboard navigation)
- Visual consistency with other UI elements in the login form

### Non-Functional Requirements

- No performance degradation
- No additional memory usage
- Maintains existing keyboard accessibility
- Compatible with existing QML structure

## 4. Scope

### In Scope

- ComboBox.qml component refactoring
- Color mapping to existing theme properties
- Font family standardization
- Testing with all three themes

### Out of Scope

- Creating new theme properties
- Font size modifications
- Component functionality changes
- Other component refactoring

## 5. Constraints

- Must use existing theme properties only
- Cannot introduce new theme attributes
- Must preserve current font sizes
- Must maintain existing component API

## 6. Acceptance Criteria

1. **Color Integration**

   - Background colors use `themeConfig.uiBackgroundColor`
   - Border colors use `themeConfig.uiPrimaryColor` and `themeConfig.uiSecondaryColor`
   - Text colors use `themeConfig.uiTextColor`
   - No hardcoded color values remain

1. **Font Integration**

   - All font family references use `themeConfig.uiFont`
   - Font sizes remain unchanged (14px, 12px, 13px)

1. **Theme Compatibility**

   - Component displays correctly in heat theme
   - Component displays correctly in ocean theme
   - Component displays correctly in forest theme

1. **Functionality**

   - Dropdown behavior unchanged
   - Keyboard navigation preserved
   - Hover states work correctly
