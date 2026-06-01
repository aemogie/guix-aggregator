import Quickshell
import QtQuick
import Quickshell.Wayland
import ".."

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
            left: Theme.vars.sideSize * 2
            right: Theme.vars.sideSize * 2
        }

        color: "transparent"
        implicitHeight: Theme.vars.barSize

        // --- Core Modules ---
        Row {
            anchors.verticalCenter: parent.verticalCenter
            spacing: Theme.vars.barModuleSideMargin

            BarLauncher {}
            BarCpuUsage {}
            BarWorkspaces {}
            BarWindow {}
        }
        Row {
            anchors.centerIn: parent
            BarClock {}
        }
        Row {
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            spacing: Theme.vars.barModuleSideMargin - 4
            BarTray {}
            BarNotification {}
            BarIdle {}
        }
    }
}
