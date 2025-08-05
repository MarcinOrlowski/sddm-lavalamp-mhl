#!/bin/bash

#==============================================================================
# SDDM Lava Lamp MHL Theme - Zip Package Builder
#==============================================================================
#
# DESCRIPTION:
#   This script builds a .zip package for the SDDM Lava Lamp MHL theme.
#   The package will be shared as release artefact but also uploaded to
#   KDE Store.
#
# USAGE:
#   bin/build-zip-package.sh
#
# OUTPUT:
#   Creates sddm-theme-lavalamp-mhl_1.0.0_all.zip in the current directory
#
#==============================================================================

set -uo pipefail

# NOTE: our root dir means parent folder of where scripts lives
# shellcheck disable=SC2155
readonly SCRIPT_DIR="$(dirname "$(realpath "${0}")")"
readonly ROOT_DIR="$(dirname "${SCRIPT_DIR}")"
pushd "${ROOT_DIR}" > /dev/null

SOURCE_DIR="${ROOT_DIR}/src"
BUILD_DIR="${ROOT_DIR}/build"

# Package information
PKG_NAME="sddm-theme-lavalamp-mhl"
ARCH="all"

# Validate source directory exists
if [ ! -d "$SOURCE_DIR" ]; then
    echo "ERROR: Source directory not found: $SOURCE_DIR"
    echo "Please ensure you're running this script from the project root."
    exit 1
fi

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

# Directories
PACKAGE_DIR="${BUILD_DIR}/${PKG_NAME}_${VERSION}_${ARCH}"
THEME_INSTALL_DIR="${PACKAGE_DIR}/usr/share/sddm/themes/lavalamp-mhl"

echo "=== SDDM Lava Lamp MHL Theme - ZIP Package Builder ==="
echo "Building package: ${PKG_NAME}_${VERSION}_${ARCH}.zip"
echo

# Clean and create build directory
echo "Preparing build directory..."
rm -rf "$BUILD_DIR"

# Copy theme files to package directory
echo "Copying theme files..."
cp -rv "$SOURCE_DIR"/* *.md "$THEME_INSTALL_DIR/"

# Remove test scripts from package (not needed in installation)
rm -f "$THEME_INSTALL_DIR"/test-*.sh

cd "$BUILD_DIR"

ls -ld

# Move package to project root
ZIP_DIR="${ROOT_DIR}"
ZIP_FILE="${PKG_NAME}_${VERSION}_${ARCH}.zip"
ZIP_FULL="${ZIP_DIR}/${ZIP_FILE}"

echo "OK" > "${ZIP_FILE}"
mv "$ZIP_FILE" "$ZIP_DIR/"

echo
echo "=== Package built successfully! ==="
echo "Package: $ZIP_FULL"
echo "Size: $(du -h "$ZIP_FULL" | cut -f1)"
echo

# Clean up build directory
rm -rf "$BUILD_DIR"
