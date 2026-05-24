import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell.Widgets
import Quickshell.Hyprland
import "."
import ".."

BarModule {
    id: root
    property string icon
    property string fam
    signal leftClick()
    signal rightClick()
    property real usage: -1
    property int h: 18

    color: "transparent"
    width: childrenRect.width

    RowLayout {
        anchors.centerIn: parent
        spacing: 2
        IconText {
            id: text
            fam: root.fam
            text: root.icon
        }
        ClippingRectangle {
            clip: true
            visible: root.usage >= 0
            color: Theme.colorHollow
            Layout.preferredWidth: 4
            Layout.preferredHeight: h
            Layout.alignment: Qt.AlignCenter
            radius: 3
            ProgressBar {
                visible: root.usage >= 0
                anchors {
                    bottom: parent.bottom
                    left: parent.left
                    right: parent.right
                }
                height: (h + 2) * root.usage
                contentItem: Rectangle {
                    radius: 3
                    color: Theme.colorFill
                }
            }
        }
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true

        acceptedButtons: Qt.LeftButton | Qt.RightButton

        onClicked: function (mouse) {
            if (mouse.button === Qt.LeftButton) {
                parent.leftClick()
            }
            else if (mouse.button === Qt.RightButton) {
                parent.rightClick()
            }
        }
    }
}
