import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell.Widgets
import ".."
import "."

RowLayout {
    id: root

    property alias title: ttle.text
    property alias description: desc.text
    property alias checked: sw.checked
    signal toggled(bool isOn)
    property var aligner

    spacing: 0

    ColumnLayout {
        Layout.fillWidth: true
        MonoStyledText {
            id: ttle
            color: Theme.vars.colorFont
            font.pixelSize: 16
            Layout.fillWidth: true
        }
        MonoStyledText {
            id: desc
            color: Theme.vars.colorFill
            font.pixelSize: 12
            wrapMode: Text.WordWrap
            Layout.fillWidth: true
            Layout.preferredWidth: root.width - swBg.implicitWidth - 10
            // Layout.maximumWidth: root.aligner.width * 0.8
            // width: root.aligner.width * 0.8
        }
    }
    Switch {
        id: sw
        onToggled: parent.toggled(checked)
        implicitWidth: swBg.width

        indicator: Rectangle {
            id: swBg
            anchors.verticalCenter: parent.verticalCenter
            // anchors.right: parent.right
            implicitWidth: 50
            implicitHeight: 27
            radius: 15
            color: sw.checked ? Theme.vars.colorFill : Theme.vars.colorHollow

            Behavior on color {
                ColorAnimation { duration: 200 }
            }

            Rectangle {
                x: sw.checked ? parent.width - width - 2 : 2
                anchors.verticalCenter: swBg.verticalCenter
                implicitWidth: swBg.implicitHeight - 4
                implicitHeight: swBg.implicitHeight - 4
                radius: 13
                color: "white"

                layer.enabled: true
                layer.effect: null

                border.color: "#00000022"
                border.width: 0.5

                Behavior on x {
                    NumberAnimation {
                        duration: 200
                        easing.type: Easing.InOutQuad
                    }
                }
            }
        }
    }
}
