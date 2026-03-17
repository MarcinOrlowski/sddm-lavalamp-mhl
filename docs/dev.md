# Development

## Requirements

- **SDDM** (0.21+) with Qt 6 greeter (`sddm-greeter-qt6`)
- **Qt 6** runtime: `qml6-module-qt5compat-graphicaleffects`
- **Qt Shader Baker** (for shader compilation): `qt6-shader-baker`
- **Xephyr** (for windowed testing): `xserver-xephyr`

On Debian/Ubuntu:

```bash
sudo apt install sddm qt6-shader-baker xserver-xephyr qml6-module-qt5compat-graphicaleffects
```

## Project structure

```ascii
src/
├── components/          # QML UI components
│   ├── Main.qml         # Main theme entry point, shader setup, login form
│   ├── CustomButton.qml # Themed button with hover/pressed states
│   ├── ComboBox.qml     # Dropdown for session/theme selection
│   ├── TextBox.qml      # Styled text input
│   └── PasswordBox.qml  # Styled password input
├── shaders/             # GLSL sources and compiled .qsb shaders
│   ├── metaballs.vert   # Metaballs vertex shader
│   ├── metaballs.frag   # Metaballs fragment shader (field calculation, glow)
│   ├── background.vert  # Background gradient vertex shader
│   ├── background.frag  # Background gradient fragment shader
│   └── *.qsb            # Pre-compiled Qt 6 shader binaries
├── metadata.desktop     # SDDM theme metadata (name, version)
└── theme.conf           # Theme configuration (color theme selection)
bin/
├── build-shaders.sh     # Compile GLSL → .qsb (must run after shader changes)
├── build-zip.sh         # Build distributable ZIP package
└── build-deb.sh         # Build Debian .deb package
```

## Building shaders

After modifying any `.vert` or `.frag` file, recompile the `.qsb` binaries:

```bash
bin/build-shaders.sh
```

The `.qsb` files must be committed — they are the shaders that Qt 6 loads at runtime.

## Testing

NOTE: To exit you may need to `<ALT>-<TAB>` then just `<CTRL>-C` to kill the running preview.

Test the theme in a windowed virtual display via Xephyr (recommended):

```bash
cd src && ./test-virtual-display.sh [resolution] [display_number]
# Example:
cd src && ./test-virtual-display.sh 1280x720 2
```

Or in SDDM's fullscreen test mode:

```bash
cd src && ./test-theme.sh
```

## Building packages

```bash
# ZIP archive (for KDE Store / manual install)
bin/build-zip.sh

# Debian .deb package
bin/build-deb.sh
```
