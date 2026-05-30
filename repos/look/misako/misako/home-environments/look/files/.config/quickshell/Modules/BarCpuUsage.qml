import QtQuick
import Quickshell.Io
import Quickshell.Hyprland
import "../Components"

CleanBarModule {
    icon: "󰓅"
    fam: "nf"
    usage: cpuUsage

    onLeftClick: Hyprland.dispatch("exec hyprctl notify 1 5000 0 Left-clicked cpu")
    onRightClick: Hyprland.dispatch("exec hyprctl notify 1 5000 0 Right-clicked cpu")

    property real cpuUsage: 0.0

    property real _prevIdle:  0.0
    property real _prevTotal: 0.0
    property bool _firstRead: true
    id: root

    function _parse(text) {
        const line = text.split("\n")[0]
        const parts = line.trim().split(/\s+/)
        const user      = parseFloat(parts[1])
        const nice      = parseFloat(parts[2])
        const system    = parseFloat(parts[3])
        const idle      = parseFloat(parts[4])
        const iowait    = parseFloat(parts[5])
        const irq       = parseFloat(parts[6])
        const softirq   = parseFloat(parts[7])
        const steal     = parseFloat(parts[8]) || 0

        const totalIdle  = idle + iowait
        const totalBusy  = user + nice + system + irq + softirq + steal
        const total      = totalIdle + totalBusy

        if (_firstRead) {
            _firstRead = false
            _prevIdle  = totalIdle
            _prevTotal = total
            return
        }

        const diffTotal = total - _prevTotal
        const diffIdle  = totalIdle - _prevIdle

        _prevIdle  = totalIdle
        _prevTotal = total

        if (diffTotal > 0)
            cpuUsage = (diffTotal - diffIdle) / diffTotal
        else
            cpuUsage = 0.0
    }

    FileView {
        id: procStat
        path: "/proc/stat"
        onLoaded: root._parse(text())
    }

    Timer {
        interval: 2000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: procStat.reload()
    }
}
