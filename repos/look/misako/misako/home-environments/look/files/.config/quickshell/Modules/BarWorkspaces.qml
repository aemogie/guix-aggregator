import Quickshell.Hyprland
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import "../Components"
import ".."

BarModule {
    id: root
    color: "transparent"
    leftMargin: 0
    rightMargin: 0

    Row {
        spacing: main.barModuleSideMargin

        Repeater {
            model: Hyprland.workspaces.values.filter(w => /^\d+$/.test(w.name))
            BarModule {
                border.width: 1
                border.color: modelData?.focused ? Theme.colorFill : Theme.colorHollow
                onLeftClick: Hyprland.dispatch("workspace " + modelData?.name)
                Row {
                    spacing: 4
                    StyledText {
                        text: {
                            switch (modelData?.name) {
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
                            model: modelData.toplevels.values
                            IconImage {
                                id: ico
                                source: AppSearch.guessIcon(modelData.wayland.appId)
                                implicitSize: 18
                                Rectangle {
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    anchors.top: parent.bottom
                                    visible: modelData.activated
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
