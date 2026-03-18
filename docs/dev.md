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
├── shaders/             # GLSL sources and compiled .qsb shaders
├── metadata.desktop     # SDDM theme metadata (name, version)
└── theme.conf           # Theme configuration (color theme selection)
bin/                     # Tools and helper scripts
```

## Building shaders

After modifying any `.vert` or `.frag` file, recompile the `.qsb` binaries:

```bash
bin/build-shaders.sh
```

The `.qsb` files must be committed — they are the shaders that Qt 6 loads at runtime.

## Testing

NOTE: To exit preview regular `<ALT>+<F4>` should work, or may want to `<ALT>+<TAB>` to change
window and then just `<CTRL>-C` to kill the preview.

Test the theme in a windowed virtual display via Xephyr (recommended):

```bash
bin/test-virtual-display.sh [resolution] [display_number]
# Example:
bin/test-virtual-display.sh 1280x720 2
```

Or in SDDM's fullscreen test mode:

```bash
bin/test-theme.sh
```
