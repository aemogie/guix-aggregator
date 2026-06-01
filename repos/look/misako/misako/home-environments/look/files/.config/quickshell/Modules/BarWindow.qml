import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland
import Quickshell.Widgets
import "../Components"
import ".."

BorderBarModule {
    id: root
    implicitWidth: 200
    visible: Hyprland.activeToplevel.wayland.activated

    RowLayout {
        spacing: 4
        Layout.alignment: Qt.AlignCenter
        clip: true

        CleanBarModule {
            id: ico
            icon: {
                var w = Hyprland.activeToplevel.wayland
                var i = "select_window"
                if (w.maximized) {
                    i = "maximize"
                }
                else if (w.fullscreen) {
                    i = "fullscreen"
                }
                else if (w.minimized) {
                    i = "minimize"
                }
                i
            }
        }

        ClippingRectangle {
            color: "transparent"
            radius: Theme.vars.roundness
            clip: true
            Layout.preferredHeight: ico.height
            Layout.fillWidth: true

            StyledText {
                id: scrollingText
                text: Hyprland.activeToplevel?.title ?? ""
                anchors.verticalCenter: parent.verticalCenter

                onTextChanged: {
                    scrollAnim.stop()
                    scrollingText.x = 0

                    var overflow = scrollingText.implicitWidth - scrollingText.parent.width

                    if (overflow > 0) {
                        scrollMove.to = -overflow
                        scrollMove.duration = scrollingText.implicitWidth * 10
                        scrollAnim.start()
                    }
                }

                SequentialAnimation {
                    id: scrollAnim
                    running: false
                    loops: Animation.Infinite

                    PauseAnimation { duration: 1000 }
                    NumberAnimation {
                        id: scrollMove
                        target: scrollingText
                        property: "x"
                        from: 0
                        easing.type: Easing.Linear
                    }
                    PauseAnimation { duration: 1000 }
                    NumberAnimation {
                        target: scrollingText
                        property: "x"
                        to: 0
                        duration: 0
                    }
                }
            }
        }
    }
}
