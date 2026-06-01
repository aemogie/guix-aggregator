import Quickshell
import Quickshell.Wayland
import QtQuick
import ".."

/**
 * A transparent shell container positioned at the bottom of every connected screen.
 */
Variants {
    // id: root
    model: Quickshell.screens

    delegate: PanelWindow {
        id: bottomBarWindow

        // --- Screen Mapping ---
        required property var modelData
        screen: modelData

        // --- Layer Shell Configuration ---
        WlrLayershell.layer: WlrLayer.Top

        // --- Geometry & Positioning ---
        anchors {
            left: true
            right: true
            bottom: true
        }

        // --- Visual Styling ---
        implicitHeight: Theme.vars.sideSize
        color: "transparent"
    }
}
