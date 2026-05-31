import Quickshell
import QtQuick
import Quickshell.Widgets
import QtQuick.Layouts
import Quickshell.Wayland
import Quickshell.Hyprland
import "../Services"
import ".."

LazyLoader {
    id: lazy
    active: false

    property int notifications: NotificationService.notifications.count
    onNotificationsChanged: lazy.active = true

    PanelWindow {
        id: root

        // ── Layout ────────────────────────────────────────────────────────────
        anchors { top: true; right: true }

        // ── Layer / shell ─────────────────────────────────────────────────────
        WlrLayershell.layer: WlrLayer.Overlay
        WlrLayershell.keyboardFocus: WlrKeyboardFocus.None
        WlrLayershell.namespace: "notification-panel"
        exclusionMode: ExclusionMode.Ignore
        focusable: false
        color: "transparent"
        visible: !SharedVariables.doNotDisturb

        // ── Sizing ────────────────────────────────────────────────────────────
        readonly property int notificationW: 300
        readonly property int notificationH: Theme.notificationAndEmailHeight
        readonly property int maxNotifications: 5
        readonly property int notificationTimeout: 7000

        implicitWidth: notificationW + 12
        implicitHeight: maxNotifications * (notificationH + notifList.spacing) - notifList.spacing + Theme.shadowMarg * 2

        // ── Mask ──────────────────────────────────────────────────────────────
        readonly property int maskHeight: {
            var count = Math.min(visibleNotifications.count + animatingCount, maxNotifications)
            return count > 0
                ? count * (notificationH + notifList.spacing) - notifList.spacing + Theme.shadowMarg * 2
                : 0
        }

        mask: Region {
            intersection: Intersection.Combine
            width: implicitWidth
            height: root.maskHeight
        }

        HyprlandWindow.visibleMask: mask

        // ── State ─────────────────────────────────────────────────────────────
        property ListModel visibleNotifications: ListModel {}
        property int animatingCount: 0
        property int lastNotificationCount: 0

        // ── Helpers ───────────────────────────────────────────────────────────
        function appendNotification(item) {
            if (visibleNotifications.count >= maxNotifications) {
                animatingCount++
                visibleNotifications.remove(0)
                removeAnimTimer.createObject(root)
            }
            visibleNotifications.append(item)
        }

        function removeNotification(index) {
            if (index < 0 || index >= visibleNotifications.count) return
            animatingCount++
            visibleNotifications.remove(index)
            removeAnimTimer.createObject(root)
        }

        function clearAll() {
            visibleNotifications.clear()
            animatingCount = 0
            lazy.active = false
        }

        function decAnimating() {
            if (animatingCount > 0) animatingCount--
            if (visibleNotifications.count === 0 && animatingCount === 0)
                clearAll()
        }

        // ── Wiring ────────────────────────────────────────────────────────────
        Component.onCompleted: {
            var all = NotificationService.notifications
            lastNotificationCount = all.count
            if (all.count > 0) appendNotification(all.get(0))
        }

        Connections {
            target: NotificationService.notifications
            function onCountChanged() {
                var all = NotificationService.notifications
                if (all.count <= lastNotificationCount) {
                    lastNotificationCount = all.count
                    return
                }
                lastNotificationCount = all.count
                appendNotification(all.get(0))
            }
        }

        // ── Remove-animation timer factory ────────────────────────────────────
        Component {
            id: removeAnimTimer
            Timer {
                interval: Theme.notificationDur
                running: true
                repeat: false
                onTriggered: { root.decAnimating(); destroy() }
            }
        }

        // ── List ──────────────────────────────────────────────────────────────
        ListView {
            id: notifList
            anchors { fill: parent; margins: Theme.shadowMarg }
            spacing: 8
            model: visibleNotifications

            remove: Transition {
                NumberAnimation { property: "opacity"; from: 1; to: 0; duration: Theme.notificationDur; easing.type: Theme.notificationEasing }
                NumberAnimation { property: "scale"; from: 1; to: 0.85; duration: Theme.notificationDur; easing.type: Theme.notificationEasing }
            }
            displaced: Transition {
                NumberAnimation { properties: "x,y"; duration: Theme.notificationMakeSpaceDur; easing.type: Theme.notificationMakeSpaceEasing }
            }

            delegate: Rectangle {
                id: notifDelegate

                width: ListView.view.width
                height: Theme.notificationAndEmailHeight
                radius: Theme.roundness
                color: notificationArea.containsMouse ? Qt.lighter(Theme.colorMain, 1.3) : Theme.colorMain
                opacity: 0
                scale: 0.85

                // RectShadow { small: true }

                Component.onCompleted: { opacity = 1; scale = 1 }

                Behavior on opacity { NumberAnimation { duration: Theme.notificationDur; easing.type: Theme.notificationEasing } }
                Behavior on scale { NumberAnimation { duration: Theme.notificationDur; easing.type: Theme.notificationEasing } }

                ColorAnimation on color {
                    from: "transparent"; to: Theme.colorMain
                    duration: Theme.notificationHighlightDur
                    running: true
                }

                // ── Content ───────────────────────────────────────────────────
                Row {
                    anchors {
                        left: parent.left; right: parent.right
                        verticalCenter: parent.verticalCenter
                        margins: Theme.notificationMarg
                    }
                    spacing: Theme.contentSpacing

                    ClippingRectangle {
                        anchors.verticalCenter: parent.verticalCenter
                        width: Theme.notificationIconSize
                        height: Theme.notificationIconSize
                        radius: Theme.roundness
                        color: "transparent"
                        visible: appIcon !== ""

                        IconImage {
                            id: icon
                            anchors.fill: parent
                            source: appIcon
                        }
                    }

                    Column {
                        width: parent.width - (icon.visible ? icon.width + Theme.notificationMarg : 0)
                        spacing: 4

                        RowLayout {
                            width: parent.width

                            StyledText {
                                text: summary
                                wrapMode: Text.WordWrap
                                elide: Text.ElideRight
                                maximumLineCount: 1
                                Layout.fillWidth: true
                            }

                            Item { Layout.fillWidth: true }

                            StyledText {
                                visible: isGhost
                                text: {
                                    var s = Math.floor((ClockService.clock.date - timestamp) / 1000)
                                    var h = Math.floor(s / 3600)
                                    var min = Math.floor((s % 3600) / 60)
                                    var sec = s % 60
                                    var parts = []
                                    if (h   > 0) parts.push(h   + "h")
                                    if (min > 0) parts.push(min + "min")
                                    parts.push(sec + "s")
                                    return parts.join(" ") + " ago"
                                }
                            }
                        }

                        StyledText {
                            visible: text !== ""
                            text: body
                            wrapMode: Text.WordWrap
                            width: parent.width
                            maximumLineCount: 1
                            elide: Text.ElideRight
                        }
                    }
                }

                // ── Interactions ──────────────────────────────────────────────
                MouseArea {
                    id: notificationArea
                    anchors.fill: parent
                    hoverEnabled: true
                    acceptedButtons: Qt.LeftButton | Qt.RightButton

                    onClicked: (mouse) => {
                        if (mouse.button === Qt.RightButton) {
                            root.visibleNotifications.clear()
                            root.animatingCount = 0
                            Qt.callLater(() => lazy.active = false)
                        } else {
                            root.removeNotification(index)
                        }
                    }
                }

                Timer {
                    interval: root.notificationTimeout
                    running: true
                    repeat: false
                    onTriggered: root.removeNotification(index)
                }
            }
        }
    }
}
