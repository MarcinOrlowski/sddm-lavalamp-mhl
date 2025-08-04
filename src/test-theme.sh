#!/bin/bash

#####################################################################
#
# Lava Lamp MHL: SDDM dynamic login theme
#
# @author    Marcin Orlowski <mail (#) marcinOrlowski (.) com>
# @copyright 2025 Marcin Orlowski
# @license   http://www.opensource.org/licenses/mit-license.php MIT
# @link      https://github.com/MarcinOrlowski/sddm-lavalamp-mhl
#
#####################################################################

THEME_DIR="$(dirname "$0")"
THEME_NAME="lavalamp-mhl"

echo "Testing Lavalamp MHL SDDM Theme..."
echo "Theme directory: ${THEME_DIR}"
echo ""

# Check if sddm-greeter is available
if ! command -v sddm-greeter &> /dev/null; then
    echo "Error: sddm-greeter not found. Please install SDDM."
    exit 1
fi

# Test with default resolution
echo "Starting SDDM theme test..."
echo "Press Ctrl+C to exit the test."
echo ""

# Run the test
sddm-greeter --test-mode --theme .

echo ""
echo "Theme test completed."
echo ""
echo "To install this theme system-wide:"
echo "1. copy ${THEME_NAME} theme folder to /usr/share/sddm/themes/"
echo "2. Edit /etc/sddm.conf and set Current=${THEME_NAME} in [Theme] section"
echo ""
echo "Note: sddm-greeter test mode ignores geometry settings and runs fullscreen."
echo "For smaller window testing, consider:"
echo "1. Use a virtual display: xvfb-run -s '-screen 0 800x600x24' sddm-greeter --test-mode --theme ${THEME_DIR}"
echo "2. Take screenshots in test mode: Press Print Screen key after launch"
echo "3. Test on a secondary smaller monitor if available or use ./test-virtual-display.sh"
