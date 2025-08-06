# Technical Requirements Document (TRD)

**Ticket:** [#2: Refactor: Make colors and font family configurable in ComboBox.qml](https://github.com/MarcinOrlowski/sddm-lavalamp-mhl/issues/2)

## 1. Technical Overview

### Current State Analysis

The ComboBox.qml component contains the following hardcoded values that need refactoring:

**Colors to replace:**

- Line 22: `color: "#FF00FF"` (background)
- Line 23: `border.color: mouseArea.containsMouse ? "#5A7ABA" : "#3A4A6A"`
- Line 33: `color: "#E8F0FF"` (main text)
- Line 43: `color: "#B8D0FF"` (arrow text)
- Line 62: `color: "#FF00FF"` (dropdown background)
- Line 63: `border.color: "#3A4A6A"` (dropdown border)
- Line 80: `color: delegateMouseArea.containsMouse ? "#2A3A5A" : "transparent"` (hover)
- Line 88: `color: "#E8F0FF"` (delegate text)

**Fonts to replace:**

- Line 35: `font.family: "Arial"`
- Line 90: `font.family: "Arial"`

## 2. Technical Solution

### 2.1 Theme Integration Approach

The component will receive theme configuration through a `themeConfig` property, similar to other components in the system.

### 2.2 Color Mapping Strategy

| Current Hardcoded Value | New Theme Property | Purpose |
|------------------------|-------------------|---------|
| `#FF00FF` | `themeConfig.uiBackgroundColor` | Main and dropdown backgrounds |
| `#3A4A6A` | `themeConfig.uiPrimaryColor` | Default border color |
| `#5A7ABA` | `themeConfig.uiSecondaryColor` | Hover border color |
| `#E8F0FF` | `themeConfig.uiTextColor` | Text color |
| `#B8D0FF` | `themeConfig.uiTextColor` | Arrow color (same as text) |
| `#2A3A5A` | Computed darker `uiPrimaryColor` | Delegate hover background |

### 2.3 Font Integration

- Replace all `font.family: "Arial"` with `font.family: themeConfig.uiFont`
- Keep existing font sizes unchanged

## 3. Implementation Details

### 3.1 Component API Changes

The ComboBox component will require a `themeConfig` property:

```qml
property QtObject themeConfig
```

### 3.2 Color Computation

For delegate hover color, we'll use Qt.darker() to create a darker version of uiPrimaryColor:

```qml
color: delegateMouseArea.containsMouse ? Qt.darker(themeConfig.uiPrimaryColor, 1.3) : "transparent"
```

### 3.3 Integration Points

The component is used in:

- `src/components/Main.qml` (session ComboBox)
- Any future usage will automatically inherit theme configuration

## 4. Testing Strategy

### 4.1 Visual Testing

- Verify appearance with all three themes: heat, ocean, forest
- Test hover states and interactions
- Verify dropdown expansion and collapse

### 4.2 Functional Testing

- Ensure dropdown functionality unchanged
- Verify keyboard navigation works
- Test item selection behavior

### 4.3 Theme Compatibility

Each theme provides these color values:

- **Heat theme:** warm orange/brown palette
- **Ocean theme:** blue/cyan palette
- **Forest theme:** green palette

## 5. Implementation Considerations

### 5.1 Backwards Compatibility

- Component API remains unchanged except for themeConfig dependency
- Existing usage in Main.qml already has themeConfig available
- No breaking changes to external consumers

### 5.2 Performance Impact

- No additional memory allocation
- Same number of QML bindings
- Color lookup through existing theme system

### 5.3 Maintenance

- Reduces maintenance burden by eliminating hardcoded values
- Makes future theming changes easier
- Improves consistency across components
