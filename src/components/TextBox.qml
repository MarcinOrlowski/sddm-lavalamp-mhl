import QtQuick 2.15

/**
 * Lava Lamp MHL: SDDM dynamic login theme
 *
 * @author    Marcin Orlowski <mail (#) marcinOrlowski (.) com>
 * @copyright 2025 Marcin Orlowski
 * @license   http://www.opensource.org/licenses/mit-license.php MIT
 * @link      https://github.com/MarcinOrlowski/sddm-lavalamp-mhl
 */

Rectangle {
    id: textBox

    signal focusChanged()
    signal textChanged()

    property alias text: textInput.text
    property alias font: textInput.font
    property alias activeFocus: textInput.activeFocus
    property alias selectByMouse: textInput.selectByMouse

    // Configurable colors
    property color backgroundColor: "#F0F0F0"
    property color textColor: "#000000"

    width: 200
    height: 35
    radius: 6
    color: backgroundColor
    border.color: textInput.activeFocus ? "#5A7ABA" : "#3A4A6A"
    border.width: 2

    TextInput {
        id: textInput
        anchors.fill: parent
        anchors.margins: 8

        color: textColor
        font.pixelSize: 14
        font.family: "Arial"
        selectByMouse: true

        verticalAlignment: TextInput.AlignVCenter

        onActiveFocusChanged: {
            textBox.focusChanged()
        }

        onTextChanged: {
            textBox.textChanged()
        }
    }

    function forceActiveFocus(reason) {
        textInput.forceActiveFocus(reason)
    }

    // Forward Keys events
    property alias Keys: textInput.Keys
    property alias KeyNavigation: textInput.KeyNavigation
}
