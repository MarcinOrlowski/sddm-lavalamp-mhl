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
    id: passwordBox

    signal focusChanged()
    signal textChanged()

    property alias text: textInput.text
    property alias font: textInput.font
    property alias activeFocus: textInput.activeFocus
    property alias selectByMouse: textInput.selectByMouse
    property string placeholderText: "Password"

    // Override color to control text color, not background
    property alias textColor: textInput.color

    width: 200
    height: 35
    radius: 6
    color: "#00FF00"  // Bright green background
    border.color: textInput.activeFocus ? "#5A7ABA" : "#3A4A6A"
    border.width: 2

    TextInput {
        id: textInput
        anchors.fill: parent
        anchors.margins: 8

        color: "#000000"  // Black text
        font.pixelSize: 14
        font.family: "Arial"
        selectByMouse: true
        echoMode: TextInput.Password

        verticalAlignment: TextInput.AlignVCenter

        onActiveFocusChanged: {
            passwordBox.focusChanged()
        }

        onTextChanged: {
            passwordBox.textChanged()
        }
    }

    function forceActiveFocus(reason) {
        textInput.forceActiveFocus(reason)
    }

    // Forward Keys events
    property alias Keys: textInput.Keys
    property alias KeyNavigation: textInput.KeyNavigation
}
