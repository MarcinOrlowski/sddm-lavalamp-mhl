#!/bin/bash

#==============================================================================
#
# Lava Lamp MHL: SDDM dynamic login theme
#
# @author    Marcin Orlowski <mail (#) marcinOrlowski (.) com>
# @copyright 2025-2026 Marcin Orlowski
# @license   http://www.opensource.org/licenses/mit-license.php MIT
# @link      https://github.com/MarcinOrlowski/sddm-lavalamp-mhl
#
#==============================================================================
# SDDM Lava Lamp MHL Theme - PPA Source Package Builder
#==============================================================================
#
# DESCRIPTION:
#   Builds a signed Debian source package suitable for uploading to a
#   Launchpad PPA. Generates the .orig.tar.gz, debian/ directory, and
#   runs debuild -S to produce .dsc + .debian.tar.xz + _source.changes.
#
# DEPENDENCIES:
#   sudo apt install dpkg-dev debhelper devscripts gnupg
#
# USAGE:
#   ./build-ppa.sh --gpg-key ID                     # build for default series
#   ./build-ppa.sh --gpg-key ID --series noble      # build for specific series
#   ./build-ppa.sh --gpg-key ID --upload             # build and dput upload
#   ./build-ppa.sh --gpg-key ID --ppa user/ppa-name  # custom PPA target
#
# OUTPUT:
#   Creates source package files in build/ppa/:
#     - sddm-theme-lavalamp-mhl_VERSION.orig.tar.gz
#     - sddm-theme-lavalamp-mhl_VERSION-1.dsc
#     - sddm-theme-lavalamp-mhl_VERSION-1.debian.tar.xz
#     - sddm-theme-lavalamp-mhl_VERSION-1_source.changes
#
#==============================================================================

set -euo pipefail

# Parse command-line arguments
GPG_KEY=""
SERIES="questing"
DEB_REVISION="1"
UPLOAD=false
PPA=""

while [[ $# -gt 0 ]]; do
    case "$1" in
        --gpg-key)
            if [ -z "${2:-}" ]; then
                echo "ERROR: --gpg-key requires a key ID argument"
                exit 1
            fi
            GPG_KEY="$2"
            shift 2
            ;;
        --series)
            if [ -z "${2:-}" ]; then
                echo "ERROR: --series requires a series name (e.g. questing, plucky)"
                exit 1
            fi
            SERIES="$2"
            shift 2
            ;;
        --revision)
            if [ -z "${2:-}" ]; then
                echo "ERROR: --revision requires a number"
                exit 1
            fi
            DEB_REVISION="$2"
            shift 2
            ;;
        --upload)
            UPLOAD=true
            shift
            ;;
        --ppa)
            if [ -z "${2:-}" ]; then
                echo "ERROR: --ppa requires a PPA name (e.g. user/ppa-name)"
                exit 1
            fi
            PPA="$2"
            shift 2
            ;;
        -h|--help)
            echo "Usage: $(basename "$0") [OPTIONS]"
            echo
            echo "Options:"
            echo "  --gpg-key ID       GPG key ID for signing (required)"
            echo "  --series NAME      Ubuntu series codename (default: questing)"
            echo "  --revision N       Debian revision number (default: 1)"
            echo "  --upload           Upload to PPA after building via dput"
            echo "  --ppa USER/NAME    PPA target (default: from ~/.dput.cf)"
            echo "  -h, --help         Show this help message"
            exit 0
            ;;
        *)
            echo "ERROR: Unknown option: $1"
            echo "Run with --help for usage information."
            exit 1
            ;;
    esac
done

if [ -z "${GPG_KEY}" ]; then
    echo "ERROR: --gpg-key is required for PPA source packages."
    echo "Run with --help for usage information."
    exit 1
fi

# shellcheck disable=SC2155
readonly SCRIPT_DIR="$(dirname "$(realpath "${0}")")"
ROOT_DIR="$(dirname "${SCRIPT_DIR}")"
readonly ROOT_DIR

# Validate dependencies
for CMD in dpkg-buildpackage debuild dput gpg; do
    if ! command -v "${CMD}" >/dev/null 2>&1; then
        echo "ERROR: ${CMD} is required but not found."
        echo "Install with: sudo apt install dpkg-dev debhelper devscripts gnupg"
        exit 1
    fi
done

# Package information
PKG_NAME="sddm-theme-lavalamp-mhl"
MAINTAINER="Marcin Orlowski <mail@marcinorlowski.com>"
HOMEPAGE="https://github.com/MarcinOrlowski/sddm-lavalamp-mhl"

# Read version from metadata.desktop
METADATA_FILE="${ROOT_DIR}/src/metadata.desktop"
if [ ! -f "${METADATA_FILE}" ]; then
    echo "ERROR: Metadata file not found: ${METADATA_FILE}"
    exit 1
fi

VERSION=$(grep "^Version=" "${METADATA_FILE}" | cut -d'=' -f2 | tr -d '\r\n')
if [ -z "${VERSION}" ]; then
    echo "ERROR: Version not found in ${METADATA_FILE}"
    exit 1
fi

CHANGES_MD="${ROOT_DIR}/CHANGES.md"
if [ ! -f "${CHANGES_MD}" ]; then
    echo "ERROR: CHANGES.md not found: ${CHANGES_MD}"
    exit 1
fi

DEB_VERSION="${VERSION}-${DEB_REVISION}"
ORIG_TARBALL="${PKG_NAME}_${VERSION}.orig.tar.gz"
BUILD_DIR="${ROOT_DIR}/build/ppa"
SOURCE_DIR="${BUILD_DIR}/${PKG_NAME}-${VERSION}"

echo "=== SDDM Lava Lamp MHL Theme - PPA Source Package Builder ==="
echo "Version: ${VERSION}"
echo "Series:  ${SERIES}"
echo "GPG Key: ${GPG_KEY}"
echo

# Clean and create build directory
echo "Preparing build directory…"
rm -rf "${BUILD_DIR}"
mkdir -p "${SOURCE_DIR}"

# Copy theme source files (excluding test scripts)
echo "Copying theme sources…"
cp -r "${ROOT_DIR}/src"/* "${SOURCE_DIR}/"
rm -f "${SOURCE_DIR}"/test-*.sh

# Create reproducible orig tarball (must be created BEFORE debian/ directory exists)
echo "Creating orig tarball…"
tar --sort=name --owner=root:0 --group=root:0 \
    -czf "${BUILD_DIR}/${ORIG_TARBALL}" -C "${BUILD_DIR}" "${PKG_NAME}-${VERSION}"

# Create debian/ directory
echo "Creating debian/ packaging…"
DEBIAN_DIR="${SOURCE_DIR}/debian"
mkdir -p "${DEBIAN_DIR}/source"

# debian/source/format
echo "3.0 (quilt)" > "${DEBIAN_DIR}/source/format"

# debian/control
cat > "${DEBIAN_DIR}/control" << EOF
Source: ${PKG_NAME}
Section: kde
Priority: optional
Maintainer: ${MAINTAINER}
Build-Depends: debhelper-compat (= 13)
Standards-Version: 4.6.2
Homepage: ${HOMEPAGE}
Rules-Requires-Root: no

Package: ${PKG_NAME}
Architecture: all
Depends: \${misc:Depends}, sddm, qml6-module-qt5compat-graphicaleffects, qml6-module-qtquick-virtualkeyboard
Recommends: desktop-base (>= 9.0.0~)
Provides: sddm-theme
Description: Lava Lamp animated SDDM login theme
 Lava Lamp is an animated SDDM dynamic theme stylized after the classic
 lava lamp. It features a mesmerizing animation of colorful blobs that move
 and change shape, creating a relaxing and soothing visual effect.
 .
 The theme comes in three different styles: heat, ocean, and forest.
 It requires SDDM and Qt/QML components to function properly.
 .
 This package provides an SDDM theme that can be selected in display
 manager configuration or through system settings.
EOF

# debian/rules
cat > "${DEBIAN_DIR}/rules" << 'RULES'
#!/usr/bin/make -f

%:
	dh $@

override_dh_auto_install:
	install -d $(CURDIR)/debian/sddm-theme-lavalamp-mhl/usr/share/sddm/themes/lavalamp-mhl
	cp -r $(CURDIR)/assets $(CURDIR)/debian/sddm-theme-lavalamp-mhl/usr/share/sddm/themes/lavalamp-mhl/
	cp -r $(CURDIR)/components $(CURDIR)/debian/sddm-theme-lavalamp-mhl/usr/share/sddm/themes/lavalamp-mhl/
	cp -r $(CURDIR)/shaders $(CURDIR)/debian/sddm-theme-lavalamp-mhl/usr/share/sddm/themes/lavalamp-mhl/
	cp $(CURDIR)/metadata.desktop $(CURDIR)/debian/sddm-theme-lavalamp-mhl/usr/share/sddm/themes/lavalamp-mhl/
	cp $(CURDIR)/theme.conf $(CURDIR)/debian/sddm-theme-lavalamp-mhl/usr/share/sddm/themes/lavalamp-mhl/
	cp $(CURDIR)/preview.webp $(CURDIR)/debian/sddm-theme-lavalamp-mhl/usr/share/sddm/themes/lavalamp-mhl/

override_dh_auto_build:
	# Nothing to build — theme is pure QML/GLSL

override_dh_auto_test:
	# No automated tests
RULES
chmod 755 "${DEBIAN_DIR}/rules"

# debian/copyright
cat > "${DEBIAN_DIR}/copyright" << EOF
Format: https://www.debian.org/doc/packaging-manuals/copyright-format/1.0/
Upstream-Name: SDDM Lava Lamp MHL Theme
Upstream-Contact: Marcin Orlowski <mail@marcinorlowski.com>
Source: https://github.com/MarcinOrlowski/sddm-lavalamp-mhl

Files: *
Copyright: 2025-2026 Marcin Orlowski
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

# debian/prerm
cat > "${DEBIAN_DIR}/prerm" << 'EOF'
#!/bin/sh
set -e

if [ "$1" = "remove" ] || [ "$1" = "deconfigure" ]; then
    THEME_ACTIVE=0

    if [ -f /etc/sddm.conf ]; then
        if grep -q "Current=lavalamp-mhl" /etc/sddm.conf 2>/dev/null; then
            THEME_ACTIVE=1
        fi
    fi

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

# debian/changelog — parse from CHANGES.md
echo "Generating debian/changelog…"
"${SCRIPT_DIR}/gen-deb-changelog.sh" "${CHANGES_MD}" "${DEBIAN_DIR}/changelog" "${PKG_NAME}" "${MAINTAINER}" "${SERIES}" "-${DEB_REVISION}"

# Build signed source package
echo
echo "Building source package…"
cd "${SOURCE_DIR}"
debuild -S -sa -k"${GPG_KEY}"

echo
echo "=== Source package built successfully! ==="
echo "Output directory: ${BUILD_DIR}"
echo
ls -1 "${BUILD_DIR}"/${PKG_NAME}_${DEB_VERSION}*
echo

# Upload if requested
if [ "${UPLOAD}" = true ]; then
    CHANGES_FILE="${BUILD_DIR}/${PKG_NAME}_${DEB_VERSION}_source.changes"
    if [ ! -f "${CHANGES_FILE}" ]; then
        echo "ERROR: Changes file not found: ${CHANGES_FILE}"
        exit 1
    fi

    echo "Uploading to PPA…"
    DPUT_CF="${ROOT_DIR}/.dput.cf"
    if [ -n "${PPA}" ]; then
        dput "ppa:${PPA}" "${CHANGES_FILE}"
    elif [ -f "${DPUT_CF}" ]; then
        dput -c "${DPUT_CF}" sddm-lavalamp-mhl "${CHANGES_FILE}"
    else
        echo "ERROR: No --ppa specified and dput.cf not found at ${DPUT_CF}"
        exit 1
    fi
fi
