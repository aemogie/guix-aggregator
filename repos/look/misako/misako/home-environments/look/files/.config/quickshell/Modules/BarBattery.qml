import QtQuick
import Quickshell.Io
import Quickshell.Hyprland
import "../Components"

CleanBarModule {
    id: root

    visible: hasBattery
    width: visible ? implicitWidth : 0

    icon: _charging ? "󰂄" : _batteryIcon()
    fam: "nf"
    usage: _capacity / 100.0
    icon_extra_spacing: 3

    property bool hasBattery: false
    property int  _capacity: 0
    property bool _charging: false

    function _batteryIcon() {
        if (_capacity > 90) return "󰁹"
        if (_capacity > 80) return "󰂂"
        if (_capacity > 70) return "󰂁"
        if (_capacity > 60) return "󰂀"
        if (_capacity > 50) return "󰁿"
        if (_capacity > 40) return "󰁾"
        if (_capacity > 30) return "󰁽"
        if (_capacity > 20) return "󰁼"
        if (_capacity > 10) return "󰁻"
        return "󰁺"
    }

    InteractArea {
        onLeftClick: Hyprland.dispatch(`hl.dsp.exec_cmd('exec hyprctl notify 1 5000 0 Battery: ${root._capacity}%')`)
        onRightClick: Hyprland.dispatch(`hl.dsp.exec_cmd('exec hyprctl notify 1 5000 0 Status: ${root._charging ? "Charging" : "Discharging"}')`)
    }

    FileView {
        id: capacityFile
        path: "/sys/class/power_supply/BAT0/capacity"
        onLoaded: {
            const val = parseInt(text().trim())
            if (!isNaN(val)) {
                root.hasBattery = true
                root._capacity  = val
            }
        }
        onLoadFailed: root.hasBattery = false
    }

    FileView {
        id: statusFile
        path: "/sys/class/power_supply/BAT0/status"
        onLoaded: {
            const s = text().trim().toLowerCase()
            root._charging = (s === "charging" || s === "full")
        }
    }

    Timer {
        interval: 10000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            capacityFile.reload()
            statusFile.reload()
        }
    }
}
