pragma Singleton

import Quickshell.Io
import QtQuick
import Quickshell
import ".."

Scope {
    id: root

    function capitalize(str) {
        if (!str) return null
        return str.charAt(0).toUpperCase() + str.slice(1)
    }
    function set_relay(relay) {
        setRelayProc.command = ["mullvad", "relay", "set", "location", relay]
        setRelayProc.running = true
        delayedReload.start()
    }
    function disconnect() {
        disconnectProc.running = true
    }
    function connect() {
        connectProc.running = true
    }
    function toggle_connection() {
        is_connected ? disconnect() : connect()
        delayedReload.start()
    }
    function lockdown() {
        lockdownProc.running = true
    }
    function unlockdown() {
        unlockdownProc.running = true
    }
    function auto_connect() {
        auto_connectProc.running = true
    }
    function unauto_connect() {
        unauto_connectProc.running = true
    }
    function allow_lan() {
        allowLanProc.running = true
    }
    function block_lan() {
        blockLanProc.running = true
    }
    function reload() {
        statusProc.running = true
        statusLockdown.running = true
        statusAutoConnect.running = true
        statusLan.running = true
    }

    property var jsonStatus: null
    property var relayList: null

    readonly property string state: capitalize(jsonStatus?.state) ?? "Unknown"
    readonly property bool is_connected: state === "Connected"
    property bool locked_down
    property bool is_auto_connect
    property bool is_lan_allowed
    readonly property string country: capitalize(jsonStatus?.details?.location?.country) ?? "Unknown country"
    readonly property string hostname: jsonStatus?.details?.location?.hostname ?? "Unknown hostname"

    ReloadProcess {
        id: setRelayProc
        running: false
    }
    Process {
        id: relayListProc
        command: ["mullvad", "relay", "list"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: root.relayList = this.text
        }
    }
    Process {
        id: statusProc
        command: ["mullvad", "status", "--json"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: root.jsonStatus = JSON.parse(this.text)
        }
    }
    Process {
        id: statusLockdown
        command: ["mullvad", "lockdown-mode", "get"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: root.locked_down = this.text?.includes(": on") ?? false
        }
    }
    Process {
        id: statusAutoConnect
        command: ["mullvad", "auto-connect", "get"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: root.is_auto_connect = this.text?.includes(": on") ?? false
        }
    }
    Process {
        id: statusLan
        command: ["mullvad", "lan", "get"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: root.is_lan_allowed = this.text?.includes(": allow") ?? false
        }
    }
    ReloadProcess {
        id: disconnectProc
        command: ["mullvad", "disconnect"]
        running: false
    }
    ReloadProcess {
        id: connectProc
        command: ["mullvad", "connect"]
        running: false
    }
    ReloadProcess {
        id: lockdownProc
        command: ["mullvad", "lockdown-mode", "set", "on"]
        running: false
    }
    ReloadProcess {
        id: unlockdownProc
        command: ["mullvad", "lockdown-mode", "set", "off"]
        running: false
    }
    ReloadProcess {
        id: auto_connectProc
        command: ["mullvad", "auto-connect", "set", "on"]
        running: false
    }
    ReloadProcess {
        id: unauto_connectProc
        command: ["mullvad", "auto-connect", "set", "off"]
        running: false
    }
    ReloadProcess {
        id: allowLanProc
        command: ["mullvad", "lan", "set", "allow"]
        running: false
    }
    ReloadProcess {
        id: blockLanProc
        command: ["mullvad", "lan", "set", "block"]
        running: false
    }
    Timer {
        id: delayedReload
        property int count: 0

        interval: 1000
        running: false
        repeat: true
        onTriggered: {
            count++;
            root.reload()
            if (count >= 3) {
                delayedReload.stop()
                count = 0
            }
        }
    }
    Timer {
        id: constantReload
        interval: 60 * 1000
        running: true
        repeat: true
        onTriggered: root.reload()
    }
    component ReloadProcess: Process {
        onExited: (exitCode, exitStatus) => {
            exitCode === 0 ? root.reload() : print("Mullvad Error")
        }
    }
}
