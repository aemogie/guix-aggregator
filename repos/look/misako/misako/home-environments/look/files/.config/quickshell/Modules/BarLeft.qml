import Quickshell
import Quickshell.Wayland
import QtQuick

Variants {
    // id: root
    model: Quickshell.screens

    delegate: PanelWindow {
        id: sideBarWindow

        // --- Screen Mapping ---
        required property var modelData
        screen: modelData

        // --- Layer Shell Configuration ---
        WlrLayershell.layer: WlrLayer.Top

        // --- Geometry & Positioning ---
        anchors {
            top: true
            left: true
            bottom: true
        }

        // --- Visual Styling ---
        implicitWidth: main.sideSize
        color: "transparent"
    }
}
