pragma Singleton
import Quickshell
import Quickshell.Services.Notifications
import QtQuick
import ".."

Scope {
    id: root

    property ListModel notifications: ListModel {}
    property list<string> blockNotificationsFrom: ["spotify"]

    function remove(index) {
        if (index >= 0 && index < notifications.count)
            notifications.remove(index)
    }

    function clear() {
        notifications.clear()
        _cancelGhosts()
        _cursor = -1
    }

    function showLastTriggered() {
        if (_history.length === 0) return
        if (_cursor + 1 >= _history.length)
            _cursor = 0
        else
            _cursor = _cursor + 1
        var entry = _history[_cursor]
        notifications.insert(0, {
            "summary":   entry.summary,
            "body":      entry.body,
            "appName":   entry.appName,
            "appIcon":   entry.appIcon,
            "timestamp": entry.timestamp,
            "isGhost":   true
        })
        _ghostActive = true
        _cycleTimer.restart()
    }

    property var _history: []
    property int _cursor: -1
    property bool _ghostActive: false

    function _cancelGhosts() {
        if (!_ghostActive) return

        for (var i = notifications.count - 1; i >= 0; i--) {
            if (notifications.get(i).isGhost)
                notifications.remove(i)
        }
        _ghostActive = false
        _cycleTimer.stop()
    }

    Timer {
        id: _cycleTimer
        interval: 7000
        repeat: false
        onTriggered: {
            root._cancelGhosts()
            root._cursor = -1
        }
    }

    NotificationServer {
        id: server
        actionsSupported: true
        actionIconsSupported: true
        imageSupported: true
        persistenceSupported: true
        bodySupported: true
        keepOnReload: false
        onNotification: (notif) => {
            notif.tracked = true
            if (blockNotificationsFrom.includes(notif.appName.toLowerCase())) return
            var entry = {
                "summary":   notif.summary  ?? "",
                "body":      notif.body     ?? "",
                "appName":   notif.appName  ?? "",
                "appIcon":   _resolveIcon(notif.image !== "" ? notif.image : (notif.appIcon ?? "")),
                "timestamp": Date.now(),
                "isGhost":   false
            }
            root._cancelGhosts()
            root._cursor = -1
            root._history.unshift(entry)
            notifications.insert(0, entry)
        }
    }

    function _resolveIcon(ic) {
        if (ic === "") return ""
        if (ic.startsWith("image://icon/"))
            ic = ic.slice("image://icon".length)
        if (ic.startsWith("/")) return "file://" + ic
        return ic
    }
}
