import QtQuick
import ".."

Rectangle {
    implicitWidth: childrenRect.width + main.barModuleSideMargin * 2
    border.width: 1

    anchors.verticalCenter: parent.verticalCenter
    implicitHeight: main.barModuleSize
    color: Theme.colorAccent
    radius: main.roundness
}
