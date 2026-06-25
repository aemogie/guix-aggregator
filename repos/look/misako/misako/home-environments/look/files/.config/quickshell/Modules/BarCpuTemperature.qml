import QtQuick
import Quickshell.Io
import Quickshell.Hyprland
import "../Components"

CleanBarModule {
    icon: ""
    fam: "nf"
    pixelSize: 14
    usage: tempUsage
    icon_extra_spacing: 1

    InteractArea {
        onLeftClick: Hyprland.dispatch(`hl.dsp.exec_cmd('exec hyprctl notify 1 5000 0 Left-clicked CPU Temp')`)
        onRightClick: Hyprland.dispatch(`hl.dsp.exec_cmd('exec hyprctl notify 1 5000 0 Right-clicked CPU Temp')`)
    }

    property real tempUsage: 0.0
    property real tempC: 0.0
    property real tempMax: 100.0
    id: root

    readonly property var candidatePaths: [
        "/sys/class/thermal/thermal_zone0/temp",
        "/sys/class/thermal/thermal_zone1/temp",
        "/sys/class/thermal/thermal_zone2/temp",
        "/sys/class/hwmon/hwmon1/temp1_input",
    ]
    property int candidateIndex: 0
    property string tempPath: candidatePaths[0]

    function _tryNextPath() {
        candidateIndex++
        if (candidateIndex < candidatePaths.length) {
            tempPath = candidatePaths[candidateIndex]
            tempFile.reload()
        } else {
            console.warn("CpuTemp: no valid thermal zone found in candidate list")
        }
    }

    function _parse(text) {
        const raw = parseFloat(text.trim())
        if (!isNaN(raw)) {
            tempC     = raw / 1000.0
            tempUsage = Math.min(tempC / tempMax, 1.0)
        }
    }

    FileView {
        id: tempFile
        path: root.tempPath
        onLoaded: root._parse(text())
        onLoadFailed: root._tryNextPath()
    }

    Timer {
        interval: 2000
        running: root.candidateIndex < root.candidatePaths.length
        repeat: true
        triggeredOnStart: true
        onTriggered: tempFile.reload()
    }
}
