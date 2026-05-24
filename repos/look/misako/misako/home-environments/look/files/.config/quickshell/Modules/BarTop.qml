import Quickshell
import QtQuick
import Quickshell.Wayland
import "../Components"

Variants {
    model: Quickshell.screens

    delegate: PanelWindow {
        id: barTop

        // --- Screen Mapping ---
        required property var modelData
        screen: modelData

        // --- Layer Shell Configuration ---
        WlrLayershell.layer: WlrLayer.Top
        WlrLayershell.namespace: "quickshell-bartop"

        // --- Geometry & Positioning ---
        anchors {
            top: true
            left: true
            right: true
        }

        margins {
            left: main.sideSize
            right: main.sideSize
        }

        // --- Visual Styling ---
        color: "transparent"
        implicitHeight: main.barSize

        // --- Core Modules ---
        Row {
            anchors.verticalCenter: parent.verticalCenter
            spacing: main.barModuleSideMargin
            padding: main.sideSize

            BarLauncher {}
            BarCpuUsage {}
            BarWorkspaces {}
        }
        Row {
            anchors.centerIn: parent
            BarClock {}
        }
    }
}
