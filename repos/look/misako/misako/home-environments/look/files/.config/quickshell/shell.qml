//@ pragma IconTheme MoreWaita
import Quickshell
import QtQuick
import "Modules"
import "Components"

ShellRoot {
    id: main

    property int sideSize: 6
    property int barSize: 36
    property int barModuleSize: 28
    property int barModuleSideMargin: 8
    property int roundness: 14

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

    // FloatingWindow {
    //     GridLayout {
    //         Repeater {
    //             model: Hyprland.workspaces.values
    //             GridLayout {
    //                 Repeater {
    //                     model: modelData.toplevels.values
    //                     GridLayout {
    //                         rows: 2
    //                         columns: 1
    //                         Layout.alignment: Qt.AlignCenter
    //                         IconImage {
    //                             width: 50
    //                             height: 50
    //                             source: AppSearch.guessIcon(modelData.wayland.appId)
    //                         }
    //                         Text {
    //                             text: modelData.wayland.appId
    //                         }
    //                     }
    //                 }
    //             }
    //         }
    //     }
        // CenteredStyledText {
        //     text: {
        //         for (let workspace of Hyprland.workspaces.values) {
        //             for (let toplevel of workspace.toplevels.values) {
        //                 print(`WS: ${workspace.name} class: ${toplevel.wayland.appId}`)
        //             }
        //         }
        //         // return Hyprland.toplevels.values
        //     }
        // }
    // }
}
