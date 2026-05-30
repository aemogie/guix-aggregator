import QtQuick
import Quickshell.Hyprland
import "../Components"

CleanBarModule {
    icon: ""
    fam: "nf"
    onLeftClick: Hyprland.dispatch("exec hyprctl notify 1 5000 0 Left-clicked launcher")
    onRightClick: Hyprland.dispatch("exec hyprctl notify 1 5000 0 Right-clicked launcher")
}
