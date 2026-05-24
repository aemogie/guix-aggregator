import Quickshell.Hyprland
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import "../Components"
import ".."

BarModule {
    id: root
    color: "transparent"
    width: implicitWidth

    Row {
        anchors.centerIn: parent
        spacing: main.barModuleSideMargin

        Repeater {
            model: Hyprland.workspaces.values.filter(w => /^\d+$/.test(w.name))
            BarModule {
                border.width: 1
                border.color: modelData?.focused ? Theme.colorFill : Theme.colorHollow
                RowLayout {
                    anchors.centerIn: parent
                    spacing: 4
                    Layout.alignment: Qt.AlignCenter
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
                                    visible: modelData.activated
                                    width: parent.width * 0.7
                                    height: 2
                                    radius: 4
                                    y: y + 18
                                    color: Theme.colorFill
                                }
                                // StyledText {
                                //     visible: modelData.activated
                                //     text: ""
                                //     color: Theme.colorFill
                                //     anchors.horizontalCenter: parent.horizontalCenter
                                //     y: y + 14
                                //     font.pixelSize: 7
                                // }
                            }
                        }
                    }
                }
            }
        }
    }
}
