#!/bin/bash

#==============================================================================
# SDDM Lava Lamp MHL Theme - Debian Package Builder
#==============================================================================
#
# DESCRIPTION:
#   This script builds a .deb package for the SDDM Lava Lamp MHL theme.
#   The package will install the theme to /usr/share/sddm/themes/lavalamp-mhl/
#   and make it available for selection in SDDM configuration.
#
# DEPENDENCIES:
#   - dpkg-deb (part of dpkg package)
#   - fakeroot (for building packages as non-root user)
#   - Standard build tools (coreutils, findutils, etc.)
#
#   Install dependencies on Ubuntu/Debian:
#   sudo apt update
#   sudo apt install dpkg-dev fakeroot build-essential
#
# USAGE:
#   chmod +x build-deb-package.sh
#   ./build-deb-package.sh
#
# OUTPUT:
#   Creates sddm-theme-lavalamp-mhl_1.0.0_all.deb in the current directory
#
# PACKAGE INSTALLATION:
#   sudo dpkg -i sddm-theme-lavalamp-mhl_1.0.0_all.deb
#   sudo apt-get install -f  # Fix any dependency issues
#
# PACKAGE REMOVAL:
#   sudo apt remove sddm-theme-lavalamp-mhl
#
# SDDM CONFIGURATION:
#   After installation, configure SDDM to use the theme:
#   1. Edit /etc/sddm.conf or /etc/sddm.conf.d/kde_settings.conf
#   2. Set: Current=lavalamp-mhl under [Theme] section
#   3. Restart SDDM: sudo systemctl restart sddm
#
#   Or use KDE System Settings:
#   Settings -> System Settings -> Login Screen (SDDM) -> Select theme
#
#==============================================================================

#set -e  # Exit on any error

set -uo pipefail

# NOTE: our root dir means parent folder of where scripts lives
# shellcheck disable=SC2155
readonly SCRIPT_DIR="$(dirname "$(realpath "${0}")")"
readonly ROOT_DIR="$(dirname "${SCRIPT_DIR}")"
pushd "${ROOT_DIR}" > /dev/null

# Package information
PKG_NAME="sddm-theme-lavalamp-mhl"
ARCH="all"

# Read version from metadata.desktop file
METADATA_FILE="${ROOT_DIR}/src/metadata.desktop"
if [ ! -f "$METADATA_FILE" ]; then
    echo "ERROR: Metadata file not found: $METADATA_FILE"
    exit 1
fi

VERSION=$(grep "^Version=" "$METADATA_FILE" | cut -d'=' -f2 | tr -d '\r\n')
if [ -z "$VERSION" ]; then
    echo "ERROR: Version not found in $METADATA_FILE"
    exit 1
fi

echo "Version read from metadata: $VERSION"
MAINTAINER="Marcin Orlowski <mail@marcinorlowski.com>"
DESCRIPTION="Lava Lamp animated SDDM login theme"
HOMEPAGE="https://github.com/MarcinOrlowski/sddm-lavalamp-mhl"

# Directories
SOURCE_DIR="${ROOT_DIR}/src"
BUILD_DIR="${ROOT_DIR}/build"
PACKAGE_DIR="${BUILD_DIR}/${PKG_NAME}_${VERSION}_${ARCH}"
DEBIAN_DIR="${PACKAGE_DIR}/DEBIAN"
THEME_INSTALL_DIR="${PACKAGE_DIR}/usr/share/sddm/themes/lavalamp-mhl"

echo "=== SDDM Lava Lamp MHL Theme - Debian Package Builder ==="
echo "Building package: ${PKG_NAME}_${VERSION}_${ARCH}.deb"
echo

# Validate source directory exists
if [ ! -d "$SOURCE_DIR" ]; then
    echo "ERROR: Source directory not found: $SOURCE_DIR"
    echo "Please ensure you're running this script from the project root."
    exit 1
fi

# Clean and create build directory
echo "Preparing build directory..."
rm -rf "$BUILD_DIR"
mkdir -p "$DEBIAN_DIR"
mkdir -p "$THEME_INSTALL_DIR"

# Copy theme files to package directory
echo "Copying theme files..."
cp -r "$SOURCE_DIR"/* "$THEME_INSTALL_DIR/"

# Remove test scripts from package (not needed in installation)
rm -f "$THEME_INSTALL_DIR"/test-*.sh

# Ensure proper permissions
find "$THEME_INSTALL_DIR" -type f -exec chmod 644 {} \;
find "$THEME_INSTALL_DIR" -type d -exec chmod 755 {} \;

# Create DEBIAN/control file
echo "Creating package control file..."
cat > "$DEBIAN_DIR/control" << EOF
Package: $PKG_NAME
Version: $VERSION
Section: kde
Priority: optional
Architecture: $ARCH
Depends: qml-module-qtquick2, qml-module-qtquick-controls, qml-module-qtquick-controls2, qml-module-qtgraphicaleffects
Recommends: sddm
Provides: sddm-theme
Maintainer: $MAINTAINER
Description: $DESCRIPTION
 Lava Lamp is an animated SDDM dynamic theme stylized after the classic
 lava lamp. It features a mesmerizing animation of colorful blobs that move
 and change shape, creating a relaxing and soothing visual effect.
 .
 The theme comes in three different styles: heat, ocean, and forest.
 It requires SDDM and Qt/QML components to function properly.
 .
 This package provides an SDDM theme that can be selected in display
 manager configuration or through system settings.
Homepage: $HOMEPAGE
EOF

# Create DEBIAN/postinst script (post-installation)
echo "Creating post-installation script..."
cat > "$DEBIAN_DIR/postinst" << 'EOF'
#!/bin/sh
set -e

echo "SDDM Lava Lamp MHL theme installed successfully!"
echo
echo "To activate the theme:"
echo "- KDE System Settings: Login Screen (SDDM) -> Select 'Lava Lamp MHL'"
echo "- Or manually edit /etc/sddm.conf: Current=lavalamp-mhl"
echo "- Then restart SDDM: sudo systemctl restart sddm"
echo
echo "Theme configuration: /usr/share/sddm/themes/lavalamp-mhl/theme.conf"

#DEBHELPER#

exit 0
EOF

chmod 755 "$DEBIAN_DIR/postinst"

# Create DEBIAN/prerm script (pre-removal)
echo "Creating pre-removal script..."
cat > "$DEBIAN_DIR/prerm" << 'EOF'
#!/bin/sh
set -e

if [ "$1" = "remove" ] || [ "$1" = "deconfigure" ]; then
    # Check if this theme is currently active and prevent removal
    THEME_ACTIVE=0
    
    # Check main sddm.conf
    if [ -f /etc/sddm.conf ]; then
        if grep -q "Current=lavalamp-mhl" /etc/sddm.conf 2>/dev/null; then
            THEME_ACTIVE=1
        fi
    fi
    
    # Check sddm.conf.d directory
    if [ -d /etc/sddm.conf.d ]; then
        if grep -q "Current=lavalamp-mhl" /etc/sddm.conf.d/* 2>/dev/null; then
            THEME_ACTIVE=1
        fi
    fi
    
    if [ "$THEME_ACTIVE" = "1" ]; then
        echo "ERROR: Cannot remove sddm-theme-lavalamp-mhl - theme is currently active!"
        echo
        echo "The lavalamp-mhl theme is currently configured in SDDM."
        echo "Removing it would break your login screen."
        echo
        echo "Please change to another theme first:"
        echo "1. Use KDE System Settings: Login Screen (SDDM) -> Select different theme"
        echo "2. Or manually edit /etc/sddm.conf: Current=<other-theme>"
        echo "3. Then retry package removal"
        echo
        echo "To force removal anyway (NOT RECOMMENDED):"
        echo "  sudo dpkg --remove --force-remove-reinstreq sddm-theme-lavalamp-mhl"
        echo
        exit 1
    fi
fi

#DEBHELPER#

exit 0
EOF

chmod 755 "$DEBIAN_DIR/prerm"

# Create copyright file
echo "Creating copyright file..."
mkdir -p "$PACKAGE_DIR/usr/share/doc/$PKG_NAME"
cat > "$PACKAGE_DIR/usr/share/doc/$PKG_NAME/copyright" << EOF
Format: https://www.debian.org/doc/packaging-manuals/copyright-format/1.0/
Upstream-Name: SDDM Lava Lamp MHL Theme
Upstream-Contact: Marcin Orlowski <mail@marcinorlowski.com>
Source: https://github.com/MarcinOrlowski/sddm-lavalamp-mhl

Files: *
Copyright: 2025 Marcin Orlowski
License: MIT

License: MIT
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 .
 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.
 .
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
EOF

# Calculate installed size (in KB)
INSTALLED_SIZE=$(du -sk "$PACKAGE_DIR" | cut -f1)
echo "Installed-Size: $INSTALLED_SIZE" >> "$DEBIAN_DIR/control"

# Build the package using fakeroot
echo
echo "Building .deb package..."
cd "$BUILD_DIR"

if command -v fakeroot >/dev/null 2>&1; then
    fakeroot dpkg-deb --build "${PKG_NAME}_${VERSION}_${ARCH}"
else
    echo "WARNING: fakeroot not found, building without it (may require root privileges)"
    dpkg-deb --build "${PKG_NAME}_${VERSION}_${ARCH}"
fi

# Move package to project root
DEB_DIR="${ROOT_DIR}"
DEB_FILE="${PKG_NAME}_${VERSION}_${ARCH}.deb"
DEB_FULL="${DEB_DIR}/${DEB_FILE}"
mv "$DEB_FILE" "$DEB_DIR/"

echo
echo "=== Package built successfully! ==="
echo "Package: $DEB_FULL"
echo "Size: $(du -h "$DEB_FULL" | cut -f1)"
echo
echo "To install:"
echo "  sudo dpkg -i $DEB_FILE"
echo "  sudo apt-get install -f"
echo
echo "To verify package contents:"
echo "  dpkg -c $DEB_FILE"
echo
echo "To get package info:"
echo "  dpkg -I $DEB_FILE"
echo

# Clean up build directory
rm -rf "$BUILD_DIR"
