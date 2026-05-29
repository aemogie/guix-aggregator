import QtQuick
import QtQuick.Layouts
import Quickshell.Widgets
import ".."

WrapperMouseArea {
    id: root

    default property alias contents: innerLayout.data

    property alias color: rect.color
    property alias radius: rect.radius
    property alias border: rect.border
    property alias leftMargin: rect.leftMargin
    property alias rightMargin: rect.rightMargin

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
        }
    }
}
