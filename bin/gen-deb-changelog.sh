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
# Generates a Debian-format changelog from CHANGES.md.
# Shared by build-deb.sh and build-ppa.sh.
#
# USAGE:
#   gen-deb-changelog.sh <changes_md> <output_file> <pkg_name> <maintainer> [series] [version_suffix]
#
# ARGUMENTS:
#   changes_md      Path to CHANGES.md
#   output_file     Path to write the changelog (not gzipped)
#   pkg_name        Debian package name
#   maintainer      Maintainer string ("Name <email>")
#   series          Distribution series (default: unstable)
#   version_suffix  Appended to each version, e.g. "-1" → "2.1.0-1" (default: none)
#==============================================================================

set -euo pipefail

if [ $# -lt 4 ]; then
    echo "Usage: $(basename "$0") <changes_md> <output_file> <pkg_name> <maintainer> [series]" >&2
    exit 1
fi

CHANGES_MD="$1"
OUTPUT_FILE="$2"
PKG_NAME="$3"
MAINTAINER="$4"
SERIES="${5:-unstable}"
VERSION_SUFFIX="${6:-}"

if [ ! -f "${CHANGES_MD}" ]; then
    echo "ERROR: CHANGES.md not found: ${CHANGES_MD}" >&2
    exit 1
fi

# Ensure output file starts clean
: > "${OUTPUT_FILE}"

CURRENT_VERSION=""
CURRENT_DATE=""
while IFS= read -r LINE; do
    # Match version headers: ## v2.1.0 (2026-03-18)
    if [[ "${LINE}" =~ ^##\ v([0-9]+\.[0-9]+\.[0-9]+)\ \(([0-9]{4}-[0-9]{2}-[0-9]{2})\) ]]; then
        # Close previous entry if any
        if [ -n "${CURRENT_VERSION}" ]; then
            echo "" >> "${OUTPUT_FILE}"
            echo " -- ${MAINTAINER}  ${CURRENT_DATE}" >> "${OUTPUT_FILE}"
            echo "" >> "${OUTPUT_FILE}"
        fi
        CURRENT_VERSION="${BASH_REMATCH[1]}"
        # Convert YYYY-MM-DD to RFC 2822 date (required by Debian changelog)
        CURRENT_DATE=$(date -d "${BASH_REMATCH[2]}" -R)
        echo "${PKG_NAME} (${CURRENT_VERSION}${VERSION_SUFFIX}) ${SERIES}; urgency=low" >> "${OUTPUT_FILE}"
        echo "" >> "${OUTPUT_FILE}"
    elif [[ "${LINE}" =~ ^-\ (.+) ]] && [ -n "${CURRENT_VERSION}" ]; then
        echo "  * ${BASH_REMATCH[1]}" >> "${OUTPUT_FILE}"
    fi
done < "${CHANGES_MD}"

# Close last entry
if [ -n "${CURRENT_VERSION}" ]; then
    echo "" >> "${OUTPUT_FILE}"
    echo " -- ${MAINTAINER}  ${CURRENT_DATE}" >> "${OUTPUT_FILE}"
    echo "" >> "${OUTPUT_FILE}"
fi
