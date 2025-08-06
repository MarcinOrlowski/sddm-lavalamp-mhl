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
    id: comboBox

    property QtObject themeConfig
    property alias model: listView.model
    property alias index: listView.currentIndex
    property alias currentText: currentLabel.text

    width: 200
    height: 35
    radius: 6
    color: themeConfig.uiBackgroundColor
    border.color: mouseArea.containsMouse ? themeConfig.uiSecondaryColor : themeConfig.uiPrimaryColor
    border.width: 2

    property bool expanded: false

    Text {
        id: currentLabel
        anchors.left: parent.left
        anchors.leftMargin: 10
        anchors.verticalCenter: parent.verticalCenter
        color: themeConfig.uiTextColor
        font.pixelSize: 14
        font.family: themeConfig.uiFont
        text: listView.currentItem ? listView.currentItem.itemText : ""
    }

    Text {
        anchors.right: parent.right
        anchors.rightMargin: 10
        anchors.verticalCenter: parent.verticalCenter
        color: themeConfig.uiTextColor
        font.pixelSize: 12
        text: expanded ? "▲" : "▼"
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        onClicked: comboBox.expanded = !comboBox.expanded
    }

    Rectangle {
        id: dropdown
        anchors.top: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        height: expanded ? Math.min(200, listView.contentHeight) : 0
        radius: 6
        color: themeConfig.uiBackgroundColor
        border.color: themeConfig.uiPrimaryColor
        border.width: 2
        clip: true
        visible: height > 0

        Behavior on height {
            NumberAnimation { duration: 150; easing.type: Easing.OutCubic }
        }

        ListView {
            id: listView
            anchors.fill: parent
            anchors.margins: 2

            delegate: Rectangle {
                width: listView.width
                height: 30
                color: delegateMouseArea.containsMouse ? Qt.darker(themeConfig.uiPrimaryColor, 1.3) : "transparent"

                property string itemText: model.name || model.modelData || model

                Text {
                    anchors.left: parent.left
                    anchors.leftMargin: 10
                    anchors.verticalCenter: parent.verticalCenter
                    color: themeConfig.uiTextColor
                    font.pixelSize: 13
                    font.family: themeConfig.uiFont
                    text: parent.itemText
                }

                MouseArea {
                    id: delegateMouseArea
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: {
                        listView.currentIndex = index
                        comboBox.expanded = false
                    }
                }
            }
        }
    }

    Keys.onPressed: function(event) {
        if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter || event.key === Qt.Key_Space) {
            expanded = !expanded
            event.accepted = true
        } else if (event.key === Qt.Key_Up && listView.currentIndex > 0) {
            listView.currentIndex--
            event.accepted = true
        } else if (event.key === Qt.Key_Down && listView.currentIndex < listView.count - 1) {
            listView.currentIndex++
            event.accepted = true
        }
    }
}
