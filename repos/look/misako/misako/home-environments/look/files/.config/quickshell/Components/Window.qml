import QtQuick
import QtQuick.Effects
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import Quickshell.Hyprland
import ".."

PanelWindow {
    id: root
    default property alias contents: innerLayout.data
    property var loader
    property int spacing: 10
    property int b: 4
    property int s: 2

    color: "transparent"
    implicitHeight: content.implicitHeight + b*s
    implicitWidth: content.implicitWidth + b*s
    exclusiveZone: 0

    HyprlandFocusGrab {
        id: grab
        windows: [ root ]
        active: true
        onCleared: {
            root.loader.active = !root.loader.active
        }
    }

    Item {
        focus: true
        Keys.onPressed: (event) => {
            if (event.key === Qt.Key_Escape) {
                event.accepted = true
                root.loader.active = !root.loader.active
            }
        }
    }
    Item {
        anchors.fill: parent

        RectangularShadow {
            anchors.fill: content
            radius: content.radius
            blur: root.b
            spread: root.s
            color: Theme.vars.colorFont
        }

        WrapperRectangle {
            id: content
            color: Theme.vars.colorMain
            anchors.centerIn: parent
            radius: Theme.vars.roundness

            margin: 14

            ColumnLayout {
                id: innerLayout
                spacing: root.spacing
            }
        }
    }
}
