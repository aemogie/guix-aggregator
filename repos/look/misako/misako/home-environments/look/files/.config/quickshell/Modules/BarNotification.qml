import QtQuick
import Quickshell.Io
import "../Components"

BorderBarModule {
    id: root

    property bool doNotDisturb: false

    icon: doNotDisturb ? "notifications_off" : "notifications"

    onLeftClick: {
        toggleProc.running = true
    }

    Component.onCompleted: {
        checkProc.running = true
    }

    Process {
        id: checkProc
        running: false
        command: ["makoctl", "mode"]
        stdout: StdioCollector {
            onStreamFinished: {
                root.doNotDisturb = text.includes("do-not-disturb")
            }
        }
    }

    Process {
        id: toggleProc
        running: false
        command: root.doNotDisturb
            ? ["makoctl", "mode", "-r", "do-not-disturb"]
            : ["makoctl", "mode", "-a", "do-not-disturb"]
        stdout: StdioCollector {
            onStreamFinished: {
                root.doNotDisturb = text.includes("do-not-disturb")
            }
        }
    }
}
