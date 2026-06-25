pragma Singleton
import QtQuick

QtObject {
    property bool idleEnabled: true
    property bool isLocked: false
    property bool doNotDisturb: false

    property var mullvad
    property var clock
    property var battery
    property var launcher
    property var idle
    property var sink
    property var source
}
