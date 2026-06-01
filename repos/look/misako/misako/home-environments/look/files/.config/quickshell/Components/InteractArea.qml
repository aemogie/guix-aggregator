import QtQuick
import QtQuick.Layouts
import Quickshell.Widgets

WrapperMouseArea {
    id: root

    // Layout.fillWidth: (parent instanceof RowLayout)
    // Layout.fillHeight: (parent instanceof RowLayout)
    anchors.fill: parent
    // anchors.fill: if (!(parent instanceof RowLayout)) parent
    // property var _a: print((parent instanceof Layout))

    signal leftClick()
    signal rightClick()

    // Rectangle {
    //     anchors.fill: parent
    //     color: "red"
    // }
    hoverEnabled: true

    acceptedButtons: Qt.LeftButton | Qt.RightButton
    onClicked: function (mouse) {
        if (mouse.button === Qt.LeftButton) root.leftClick()
        else if (mouse.button === Qt.RightButton) root.rightClick()
    }
}
