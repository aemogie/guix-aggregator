pragma Singleton
import QtQuick
import Quickshell

/* idk1 */
Scope {
    property alias vars: limao

    QtObject {
        id: limao
        readonly property int sideSize: 6
        readonly property int barSize: 36
        readonly property int barModuleSize: 28
        readonly property int barModuleSideMargin: 7
        readonly property int roundness: 14
        readonly property int hyprlandGapsOut: 10

        /* Font */
        readonly property string fontFamily: "Inter Variable"
        readonly property int fontSize: 14

        readonly property color colorMain: "#f0fbf7f0"
        readonly property color colorAccent: "#e0d4ce"
        readonly property color colorHollow: "#d6c5c4"
        readonly property color colorFill: "#ad6030"
        readonly property color colorFont: "#000000"
        readonly property color colorDeselected: "#000000"
        readonly property color colorSelected: Qt.lighter(colorAccent, 1.5)

        readonly property int shadowMarg: 6
        readonly property int notificationDur: 700
        readonly property int notificationMakeSpaceDur: 520
        readonly property int notificationAndEmailHeight: 56
        readonly property int notificationHighlightDur: 900
        readonly property int notificationMarg: 12
        readonly property int contentSpacing: 10
        readonly property int notificationIconSize: 28
        readonly property var notificationEasing: Easing.OutCubic
        readonly property var notificationMakeSpaceEasing: Easing.OutQuart

    }
}

/* Modus */
// QtObject {
//     readonly property color colorMain: "#f0fbf7f0"
//     readonly property color colorAccent: "#f0c9b9b0"
//     readonly property color colorFont: Qt.darker(colorAccent, 3.0)
//     readonly property color colorDeselected: Qt.darker(colorAccent, 3.0)
//     readonly property color colorSelected: Qt.lighter(colorAccent, 1.5)
// }
