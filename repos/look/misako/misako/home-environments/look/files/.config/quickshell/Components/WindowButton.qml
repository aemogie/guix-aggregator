import QtQuick
import QtQuick.Layouts
import Quickshell
import "."
import ".."

Rectangle {
    id: root

    property string text: ""

    radius: Theme.vars.roundness
    color: Theme.vars.colorFill
    Layout.fillWidth: true
    implicitHeight: 30

    MonoStyledText {
        text: root.text
        anchors.centerIn: parent
    }
}
