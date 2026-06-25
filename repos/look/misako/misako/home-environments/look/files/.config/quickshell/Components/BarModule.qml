import QtQuick
import QtQuick.Layouts
import Quickshell.Widgets
import Quickshell.Widgets
import QtQuick.Controls
import ".."

WrapperRectangle {
    id: root

    default property alias contents: innerLayout.data

    property string icon
    property string fam
    property real usage: -1
    property int h: 18
    property int icon_extra_y: 0
    property int icon_extra_spacing: 0
    property int pixelSize: text.font.pixelSize

    color: Theme.vars.colorAccent
    radius: Theme.vars.roundness
    leftMargin: Theme.vars.barModuleSideMargin
    rightMargin: Theme.vars.barModuleSideMargin
    implicitHeight: Theme.vars.barModuleSize

    RowLayout {
        id: innerLayout
        spacing: 0
        IconText {
            id: text
            fam: root.fam
            text: root.icon
            font.pixelSize: root.pixelSize
            Layout.topMargin: root.icon_extra_y
            Layout.rightMargin: 2 + root.icon_extra_spacing
            // FIXME
            anchors.horizontalCenter: if (root.usage < 0) parent.horizontalCenter
        }
        ClippingRectangle {
            visible: root.usage >= 0
            color: Theme.vars.colorHollow
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
                    color: Theme.vars.colorFill
                }
            }
        }
    }
}
