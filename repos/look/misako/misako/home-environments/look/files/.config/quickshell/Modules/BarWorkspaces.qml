import Quickshell.Hyprland
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import "../Components"
import ".."

CleanBarModule {
    id: root

    Row {
        spacing: main.barModuleSideMargin

        Repeater {
            model: Hyprland.workspaces.values.filter(w => /^\d+$/.test(w.name))
            BorderBarModule {
                id: ws
                required property var modelData
                readonly property var data: modelData

                border.color: ws.data?.focused ? Theme.colorFill : Theme.colorHollow
                onLeftClick: Hyprland.dispatch("workspace " + ws.data?.name)
                Row {
                    spacing: 4
                    StyledText {
                        text: {
                            switch (ws.data?.name) {
                                case "1":
                                    return "α"
                                case "2":
                                    return "β"
                                case "3":
                                    return "γ"
                                case "4":
                                    return "δ"
                                case "5":
                                    return "ε"
                                case "6":
                                    return "ζ"
                                case "7":
                                    return "η"
                                case "8":
                                    return "θ"
                                case "9":
                                    return "ι"
                                case "10":
                                    return "κ"
                                default:
                                    return "?"
                            }
                        }
                    }
                    Row {
                        Repeater {
                            model: ws.data.toplevels.values
                            IconImage {
                                id: ico
                                required property var modelData
                                readonly property var w: modelData

                                source: AppSearch.guessIcon(w?.wayland?.appId)
                                implicitSize: 18
                                Rectangle {
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    anchors.top: parent.bottom
                                    visible: w.activated && ws.data.focused
                                    implicitWidth: parent.width * 0.7
                                    implicitHeight: 2
                                    radius: 4
                                    color: Theme.colorFill
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
