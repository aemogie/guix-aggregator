import Quickshell.Hyprland
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import "../Components"
import ".."

CleanBarModule {
    id: root

    Row {
        spacing: Theme.vars.barModuleSideMargin

        Repeater {
            model: Hyprland.workspaces.values.filter(w => /^\d+$/.test(w.name))
            BorderBarModule {
                id: ws
                required property var modelData
                readonly property var model: modelData

                border.color: ws.model?.focused ? Theme.vars.colorFill : Theme.vars.colorHollow
                InteractArea {
                    onLeftClick: Hyprland.dispatch(`hl.dsp.focus({ workspace = ${ws.model?.name} })`)
                }
                Row {
                    spacing: 4
                    StyledText {
                        text: {
                            switch (ws.model?.name) {
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
                            model: ws.model.toplevels.values
                            IconImage {
                                id: ico
                                required property var modelData
                                readonly property var w: modelData

                                source: AppSearch.guessIcon(w?.wayland?.appId)
                                implicitSize: 18

                                Rectangle {
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    anchors.top: parent.bottom
                                    visible: w.activated && ws.model.focused
                                    implicitWidth: parent.width * 0.7
                                    implicitHeight: 2
                                    radius: 4
                                    color: Theme.vars.colorFill
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
