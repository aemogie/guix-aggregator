import QtQuick
import Quickshell.Hyprland
import "../Components"

CleanBarModule {
    icon: ""
    fam: "nf"
    InteractArea {
        onLeftClick: Hyprland.dispatch(`hl.dsp.exec_cmd('exec hyprctl notify 1 5000 0 Left-clicked Launcher')`)
        onRightClick: Hyprland.dispatch(`hl.dsp.exec_cmd('exec hyprctl notify 1 5000 0 Right-clicked Launcher')`)
    }
}
