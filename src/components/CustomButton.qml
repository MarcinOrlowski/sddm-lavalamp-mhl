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
    id: button

    property alias text: buttonText.text
    property alias font: buttonText.font
    property string primaryColor: "#8B4513"
    property string secondaryColor: "#FF6B35"
    property string textColor: "#FFE4CC"
    signal clicked

    width: 100
    height: 35
    radius: 8

    // Smooth color properties for transitions
    property color topGradientColor: button.pressed ? Qt.darker(primaryColor, 1.2) :
                                    button.hovered ? Qt.lighter(primaryColor, 1.3) : primaryColor
    property color bottomGradientColor: button.pressed ? Qt.darker(primaryColor, 1.5) :
                                       button.hovered ? Qt.lighter(Qt.darker(primaryColor, 1.3), 1.2) : Qt.darker(primaryColor, 1.3)
    property color borderColor: button.hovered ? secondaryColor : Qt.lighter(primaryColor, 1.2)

    gradient: Gradient {
        GradientStop { position: 0.0; color: topGradientColor }
        GradientStop { position: 1.0; color: bottomGradientColor }
    }

    border.color: borderColor
    border.width: 1

    // Smooth transitions
    Behavior on topGradientColor {
        ColorAnimation { duration: 200; easing.type: Easing.OutQuad }
    }
    Behavior on bottomGradientColor {
        ColorAnimation { duration: 200; easing.type: Easing.OutQuad }
    }
    Behavior on borderColor {
        ColorAnimation { duration: 200; easing.type: Easing.OutQuad }
    }

    property bool hovered: false
    property bool pressed: false

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true

        onEntered: button.hovered = true
        onExited: button.hovered = false
        onPressed: button.pressed = true
        onReleased: button.pressed = false
        onClicked: button.clicked()
    }

    Text {
        id: buttonText
        anchors.centerIn: parent
        color: button.hovered ? Qt.lighter(textColor, 1.2) : textColor
        font.pixelSize: 14
        font.family: "Arial"
    }

    // Focus indicator
    Rectangle {
        anchors.fill: parent
        anchors.margins: -2
        radius: parent.radius + 2
        color: "transparent"
        border.color: secondaryColor
        border.width: 2
        visible: button.activeFocus
    }

    Keys.onPressed: function(event) {
        if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter || event.key === Qt.Key_Space) {
            button.clicked()
            event.accepted = true
        }
    }
}
