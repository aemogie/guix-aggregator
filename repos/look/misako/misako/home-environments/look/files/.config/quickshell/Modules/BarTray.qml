import QtQuick
import QtQuick.Layouts
import Quickshell.Widgets
import Quickshell
import Quickshell.Services.SystemTray
import "../Components"

BorderBarModule {
    id: root

    Row {
        Repeater {
            model: SystemTray.items
            IconImage {
                id: item
                required property SystemTrayItem modelData

                property var menu: modelData.menu

                source: modelData.icon
                implicitSize: 18

                QsMenuAnchor {
                    id: menu
                    menu: item.menu
                    anchor {
                        item: item
                        edges: Edges.Bottom
                    }
                }
                InteractArea {
                    onLeftClick: {
                        item.modelData.activate()
                    }
                    onRightClick: {
                        menu.open()
                    }
                }
            }
        }
    }
}
