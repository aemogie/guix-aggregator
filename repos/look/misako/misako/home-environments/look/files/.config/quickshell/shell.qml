//@ pragma IconTheme MoreWaita
import Quickshell
import QtQuick
import "Modules"
import "Components"

ShellRoot {
    id: main

    readonly property int sideSize: 6
    readonly property int barSize: 36
    readonly property int barModuleSize: 28
    readonly property int barModuleSideMargin: 7
    readonly property int roundness: 14

    /* Font */
    readonly property string fontFamily: "Inter Variable"
    readonly property int fontSize: 14

    Idle { }
    Wallpaper { }
    BezelsMask { }
    BarTop { }
    BarRight { }
    BarLeft { }
    BarBottom { }
}
