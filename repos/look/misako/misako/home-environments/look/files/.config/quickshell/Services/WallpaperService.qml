import Quickshell
import Quickshell.Wayland
import QtQuick

Variants {
    model: Quickshell.screens

    PanelWindow {
        id: root
        required property var modelData
        screen: modelData
        anchors {
            top: true
            bottom: true
            left: true
            right: true
        }
        exclusionMode: ExclusionMode.Ignore

        WlrLayershell.namespace: "quickshell-wallpaper"
        WlrLayershell.layer: WlrLayer.Background
        WlrLayershell.keyboardFocus: WlrKeyboardFocus.None
        color: "transparent"

        Image {
            id: wallpaper
            // anchors.fill: bezelBackground
            anchors.fill: parent
            source: "/home/look/images/backgrounds/sebastien-gabriel-232361.jpg"
        }
    }
}
