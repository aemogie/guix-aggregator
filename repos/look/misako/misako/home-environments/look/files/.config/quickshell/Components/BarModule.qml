import QtQuick
import ".."

Rectangle {
    width: implicitWidth + main.barModuleSideMargin * 2
    implicitWidth: childrenRect.width
    // border.width: 1

    anchors.verticalCenter: parent.verticalCenter
    height: main.barModuleSize
    color: Theme.colorAccent
    radius: main.roundness
}
