import QtQuick
import QtQuick.Layouts
import Quickshell.Widgets
import Quickshell.Widgets
import QtQuick.Controls
import ".."

WrapperMouseArea {
    id: root

    default property alias contents: innerLayout.data

    property alias color: rect.color
    property alias radius: rect.radius
    property alias border: rect.border
    property alias leftMargin: rect.leftMargin
    property alias rightMargin: rect.rightMargin

    property string icon
    property string fam
    property real usage: -1
    property int h: 18
    property int icon_extra_y: 0

    signal leftClick()
    signal rightClick()

    hoverEnabled: true
    
    acceptedButtons: Qt.LeftButton | Qt.RightButton
    onClicked: function (mouse) {
        if (mouse.button === Qt.LeftButton) root.leftClick()
        else if (mouse.button === Qt.RightButton) root.rightClick()
    }

    WrapperRectangle {
        id: rect
        color: Theme.colorAccent
        radius: main.roundness
        leftMargin: main.barModuleSideMargin
        rightMargin: main.barModuleSideMargin
        implicitHeight: main.barModuleSize

        RowLayout {
            id: innerLayout
            spacing: root.icon ? 1 : 0
            IconText {
                id: text
                fam: root.fam
                text: root.icon
                Layout.topMargin: root.icon_extra_y
            }
            ClippingRectangle {
                visible: root.usage >= 0
                color: Theme.colorHollow
                Layout.preferredWidth: 4
                Layout.preferredHeight: root.h
                Layout.alignment: Qt.AlignCenter
                radius: 3
                ProgressBar {
                    visible: root.usage >= 0
                    anchors {
                        bottom: parent.bottom
                        left: parent.left
                        right: parent.right
                    }
                    implicitHeight: (root.h + 2) * root.usage
                    contentItem: Rectangle {
                        radius: 3
                        color: Theme.colorFill
                    }
                }
            }
        }
    }
}
