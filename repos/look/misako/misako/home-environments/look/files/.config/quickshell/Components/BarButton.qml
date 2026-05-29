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
    property real usage: -1
    property int h: 18

    color: "transparent"
    leftMargin: 0
    rightMargin: 0

    RowLayout {
        spacing: 2
        IconText {
            id: text
            fam: root.fam
            text: root.icon
        }
        ClippingRectangle {
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
                implicitHeight: (h + 2) * root.usage
                contentItem: Rectangle {
                    radius: 3
                    color: Theme.colorFill
                }
            }
        }
    }
}
