import QtQuick
import Quickshell.Hyprland
import ".."
import "../Components"

BarButton {
    id: root

    icon: SharedVariables.idleEnabled ? "visibility" : "visibility_off"
    y: y + 1

    onLeftClick: SharedVariables.idleEnabled = !SharedVariables.idleEnabled
}
