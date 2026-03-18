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

# Runs the theme in a windowed Xephyr display for screenshots and testing

THEME_DIR="$(dirname "${0}")"
RESOLUTION="${1:-1280x720}"
DISPLAY_NUM="${2:-1}"

echo "Lava Lamp MHL - Virtual Display Test"
echo "Theme directory: ${THEME_DIR}"
echo "Resolution: ${RESOLUTION}"
echo "Display: :${DISPLAY_NUM}"
echo ""

# Check if Xephyr is available
if ! command -v Xephyr &> /dev/null; then
    echo "Error: Xephyr not found. Please install it:"
    echo "sudo apt install xserver-xephyr"
    exit 1
fi

# Detect SDDM greeter binary
if command -v sddm-greeter-qt6 &> /dev/null; then
    GREETER_BIN="sddm-greeter-qt6"
elif command -v sddm-greeter &> /dev/null; then
    GREETER_BIN="sddm-greeter"
else
    echo "Error: sddm-greeter not found. Please install SDDM."
    exit 1
fi

# Function to cleanup on exit
cleanup() {
    echo ""
    echo "Cleaning up…"
    # Kill any remaining processes
    if [ -n "${XEPHYR_PID}" ]; then
        kill "${XEPHYR_PID}" 2>/dev/null
    fi
    if [ -n "${GREETER_PID}" ]; then
        kill "${GREETER_PID}" 2>/dev/null
    fi
    echo "Test completed."
}

# Set trap to cleanup on exit
trap cleanup EXIT

echo "Starting Xephyr virtual display…"
Xephyr :"${DISPLAY_NUM}" -screen "${RESOLUTION}" \
    -title "SDDM Lava Lamp MHL Test" & XEPHYR_PID=${!}

# Wait for Xephyr to start
sleep 2

# Check if Xephyr started successfully
if ! kill -0 "${XEPHYR_PID}" 2>/dev/null; then
    echo "Error: Failed to start Xephyr"
    exit 1
fi

echo "Starting SDDM greeter in virtual display…"
echo "The theme should appear in the Xephyr window."
echo "Close the window or press Ctrl+C to exit."
echo ""

# Run SDDM greeter in the virtual display
env DISPLAY=":${DISPLAY_NUM}" QT_QPA_PLATFORM=xcb QT_SCALE_FACTOR=1 \
    QT_AUTO_SCREEN_SCALE_FACTOR=0 QT_ENABLE_HIGHDPI_SCALING=0 \
    "${GREETER_BIN}" --test-mode --theme "${THEME_DIR}" & GREETER_PID=${!}

# Wait for either process to exit
wait "${XEPHYR_PID}"
