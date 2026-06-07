import QtQuick
import QtQuick.Effects
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Hyprland
import ".."
import "../Components"
import "../Services"

BarPopup {
    id: root
    target: SharedVariables.mullvad

    Row {
        id: i
        // Layout.preferredWidth: 340
        spacing: 8
        IconText {
            text: MullvadService.is_connected ? "verified_user" : "remove_moderator"
            font.pixelSize: 28
        }
        ZeroColumnLayout {
            Layout.fillWidth: true
            CategoryText {
                text: MullvadService.state
            }
            DescriptionText {
                text: {
                    if (MullvadService.is_connected) {
                        `${MullvadService.country} • ${MullvadService.hostname}`
                    }
                    else {
                        MullvadService.locked_down ? "Locked down" : MullvadService.country
                    }
                }
                wrapMode: Text.NoWrap
            }
        }
    }
    WindowButton {
        text: MullvadService.is_connected ? "Disconnect" : "Connect"
        InteractArea {
            onLeftClick: MullvadService.is_connected ? MullvadService.disconnect() : MullvadService.connect()
        }
    }
    WindowSwitch {
        title: "Lockdown Mode"
        description: "Block all internet traffic when VPN is disconnected."
        checked: MullvadService.locked_down
        // aligner: i
        onToggled: {
            if (checked) {
                MullvadService.lockdown()
            } else {
                MullvadService.unlockdown()
            }
        }
    }
    WindowSwitch {
        title: "Auto-connect"
        description: "Connect to the VPN automatically when the daemon starts."
        checked: MullvadService.is_auto_connect
        onToggled: checked ? MullvadService.auto_connect() : MullvadService.unauto_connect()
        // aligner: i
    }
    WindowSwitch {
        title: "LAN Sharing"
        description: "Allow access to local network devices while connected."
        checked: MullvadService.is_lan_allowed
        // aligner: i
        onToggled: checked ? MullvadService.allow_lan() : MullvadService.block_lan()
    }
    CategoryText {
        text: "Brazil"
        Layout.columnSpan: 2
    }
    MullvadServerSelector {
        filterPattern: "br-"
    }
    CategoryText {
        text: "Switzerland"
        Layout.columnSpan: 2
    }
    MullvadServerSelector {
        filterPattern: "ch-"
    }
    component ZeroRowLayout: RowLayout {
        spacing: 0
    }
    component ZeroColumnLayout: ColumnLayout {
        spacing: 0
    }
    component CategoryText: MonoStyledText {
        color: Theme.vars.colorFont
        font.pixelSize: 16
    }
    component DescriptionText: MonoStyledText {
        color: Theme.vars.colorFill
        font.pixelSize: 12
        wrapMode: Text.WordWrap
        Layout.preferredWidth: i.implicitWidth * 0.8
    }
}
