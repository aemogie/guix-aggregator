import QtQuick
import Quickshell.Io
import Quickshell.Hyprland
import "../Components"

CleanBarModule {
    id: root

    property real memUsage: 0.0

    icon: "memory_alt"
    icon_extra_y: 1
    usage: memUsage

    InteractArea {
        onLeftClick: Hyprland.dispatch(`hl.dsp.exec_cmd('exec hyprctl notify 1 5000 0 Left-clicked Memory')`)
        onRightClick: Hyprland.dispatch(`hl.dsp.exec_cmd('exec hyprctl notify 1 5000 0 Right-clicked Memory')`)
    }

    function _parse(text) {
        const lines = text.split("\n")
        let memTotal = 0, memAvailable = 0

        for (const line of lines) {
            const parts = line.trim().split(/\s+/)
            if (parts[0] === "MemTotal:")     memTotal     = parseFloat(parts[1])
            if (parts[0] === "MemAvailable:") memAvailable = parseFloat(parts[1])
            if (memTotal && memAvailable) break
        }

        if (memTotal > 0)
            memUsage = (memTotal - memAvailable) / memTotal
        else
            memUsage = 0.0
    }

    FileView {
        id: procMeminfo
        path: "/proc/meminfo"
        onLoaded: root._parse(text())
    }

    Timer {
        interval: 2000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: procMeminfo.reload()
    }
}
