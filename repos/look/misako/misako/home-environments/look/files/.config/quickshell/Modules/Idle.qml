import Quickshell.Wayland
import Quickshell.Io
import Quickshell.Hyprland
import QtQuick
import ".."

Item {
    id: root

    readonly property real idleLockscreen: 300
    readonly property real idleNotifyLockscreen: 20
    readonly property real idleCheckLockscreen: 60

    IdleMonitor {
        respectInhibitors: false
        enabled: SharedVariables.idleEnabled
        timeout: root.idleLockscreen - root.idleNotifyLockscreen
        onIsIdleChanged: if (isIdle) notifyLockscreen.running = true
    }

    Process {
        id: notifyLockscreen
        command: ["notify-send", "System", `Locking in ${idleNotifyLockscreen}s`]
    }

    IdleMonitor {
        respectInhibitors: false
        enabled: SharedVariables.idleEnabled
        timeout: root.idleLockscreen
        onIsIdleChanged: {
            if (!isIdle) return
            if (SharedVariables.isLocked) return
            Hyprland.dispatch("exec hyprlock")
        }
    }

    IdleMonitor {
        respectInhibitors: false
        enabled: SharedVariables.idleEnabled
        timeout: root.idleCheckLockscreen
        onIsIdleChanged: {
            if (isIdle) {
                checkLocked.running = true
            } else {
                Hyprland.dispatch("dpms on")
            }
        }
    }

    IdleMonitor {
        respectInhibitors: false
        enabled: SharedVariables.idleEnabled
        timeout: root.idleLockscreen + root.idleCheckLockscreen
        onIsIdleChanged: isIdle ? Hyprland.dispatch("dpms off") : Hyprland.dispatch("dpms on")
    }

    Process {
        id: checkLocked
        command: ["pidof", "hyprlock"]
        onExited: (exitCode, exitStatus) => {
            if (exitCode === 0) {
                Hyprland.dispatch("dpms off")
            }
        }
    }
}
