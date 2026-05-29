import Quickshell
import QtQuick
import Quickshell.Wayland
import "../Components"

Variants {
    model: Quickshell.screens

    delegate: PanelWindow {
        id: barTop

        required property var modelData
        screen: modelData

        WlrLayershell.layer: WlrLayer.Top
        WlrLayershell.namespace: "quickshell-bartop"

        anchors {
            top: true
            left: true
            right: true
        }

        margins {
            left: main.sideSize * 2
            right: main.sideSize * 2
        }

        color: "transparent"
        implicitHeight: main.barSize

        // --- Core Modules ---
        Row {
            anchors.verticalCenter: parent.verticalCenter
            spacing: main.barModuleSideMargin

            BarLauncher {}
            BarCpuUsage {}
            BarWorkspaces {}
        }
        Row {
            anchors.centerIn: parent
            BarClock {}
        }
        Row {
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            spacing: main.barModuleSideMargin
            BarNotification {}
            BarIdle {}
        }
    }
}
