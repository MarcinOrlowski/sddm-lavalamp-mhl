#!/bin/bash

#####################################################################
#
# Lava Lamp MHL: SDDM dynamic login theme
#
# @author    Marcin Orlowski <mail (#) marcinOrlowski (.) com>
# @copyright 2025-2026 Marcin Orlowski
# @license   http://www.opensource.org/licenses/mit-license.php MIT
# @link      https://github.com/MarcinOrlowski/sddm-lavalamp-mhl
#
#####################################################################

# Compiles GLSL shaders into Qt 6 .qsb format using the Qt Shader Baker.
# Requires: qt6-shader-baker (provides /usr/lib/qt6/bin/qsb)

SCRIPT_DIR="$(cd "$(dirname "${0}")" && pwd)"
SHADER_DIR="${SCRIPT_DIR}/../src/shaders"

# Find qsb binary
if command -v qsb &> /dev/null; then
    QSB="qsb"
elif [ -x "/usr/lib/qt6/bin/qsb" ]; then
    QSB="/usr/lib/qt6/bin/qsb"
else
    echo "Error: qsb (Qt Shader Baker) not found."
    echo "Install it with: sudo apt install qt6-shader-baker"
    exit 1
fi

echo "Using Qt Shader Baker: ${QSB}"
echo "Shader directory: ${SHADER_DIR}"
echo ""

FAILED=0

# Compile vertex shaders (with -b for batching support)
for vert in "${SHADER_DIR}"/*.vert; do
    [ -f "${vert}" ] || continue
    out="${vert}.qsb"
    echo "Compiling $(basename "${vert}")…"
    if ${QSB} --qt6 -b -o "${out}" "${vert}"; then
        echo "  -> $(basename "${out}")"
    else
        echo "  FAILED: $(basename "${vert}")"
        FAILED=1
    fi
done

# Compile fragment shaders
for frag in "${SHADER_DIR}"/*.frag; do
    [ -f "${frag}" ] || continue
    out="${frag}.qsb"
    echo "Compiling $(basename "${frag}")…"
    if ${QSB} --qt6 -o "${out}" "${frag}"; then
        echo "  -> $(basename "${out}")"
    else
        echo "  FAILED: $(basename "${frag}")"
        FAILED=1
    fi
done

echo ""
if [ "${FAILED}" -eq 0 ]; then
    echo "All shaders compiled successfully."
else
    echo "Some shaders failed to compile."
    exit 1
fi
