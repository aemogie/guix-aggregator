import QtQuick
import Quickshell.Io
import Quickshell.Hyprland
import "../Components"

CleanBarModule {
    icon: ""
    fam: "nf"
    pixelSize: 14
    usage: tempUsage

    InteractArea {
        onLeftClick: Hyprland.dispatch(`hl.dsp.exec_cmd('exec hyprctl notify 1 5000 0 Left-clicked CPU Temp')`)
        onRightClick: Hyprland.dispatch(`hl.dsp.exec_cmd('exec hyprctl notify 1 5000 0 Right-clicked CPU Temp')`)
    }

    property real tempUsage: 0.0
    property real tempC: 0.0
    property real tempMax: 100.0
    id: root

    function _parse(text) {
        const raw = parseFloat(text.trim())
        if (!isNaN(raw)) {
            tempC    = raw / 1000.0
            tempUsage = Math.min(tempC / tempMax, 1.0)
        }
    }

    FileView {
        id: tempFile
        path: "/sys/class/thermal/thermal_zone0/temp"
        onLoaded: root._parse(text())
    }

    Timer {
        interval: 2000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: tempFile.reload()
    }
}
