pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Effects
import ".."

Variants {
    // id: root
    model: Quickshell.screens

    delegate: PanelWindow {
        id: bezelWindow

        // --- Model Integration ---
        required property var modelData
        screen: modelData

        // --- Window Configuration ---
        color: "transparent"
        visible: true

        WlrLayershell.layer: WlrLayer.Top
        WlrLayershell.namespace: "quickshell-bezels"
        WlrLayershell.exclusiveZone: -1 // Passthrough; do not reserve space

        anchors {
            top: true
            bottom: true
            left: true
            right: true
        }

        // --- Input & Visual Masking ---
        // XOR intersection ensures clicks pass through the center cutout
        mask: Region {
            item: effectContainer
            intersection: Intersection.Xor
        }

        Item {
            id: effectContainer
            anchors.fill: parent

            Item {
                id: bezelLayer
                anchors.fill: parent
                layer.enabled: true

                // Primary Drop Shadow for the bezel edges
                layer.effect: MultiEffect {
                    shadowEnabled: true
                    shadowColor: "#ff000000"
                    shadowVerticalOffset: 0
                    shadowHorizontalOffset: 0
                    blurMax: 20
                    shadowBlur: 1.3
                }

                Rectangle {
                    id: bezelBackground
                    anchors.fill: parent
                    color: Theme.vars.colorMain
                    layer.enabled: true

                    // Subtracts the cutoutShape from the solid surface
                    layer.effect: MultiEffect {
                        maskSource: cutoutShape
                        maskInverted: true
                        maskEnabled: true
                        maskThresholdMin: 0.5
                        maskSpreadAtMin: 1
                    }
                }

                /**
                 * Cutout Definition
                 * Defines the area where the desktop remains visible.
                 */
                Item {
                    id: cutoutShape
                    anchors.fill: parent
                    layer.enabled: true
                    visible: false // Source item only

                    Rectangle {
                        id: clippingRect
                        anchors.fill: parent

                        // Margins
                        anchors {
                            leftMargin: Theme.vars.sideSize
                            rightMargin: Theme.vars.sideSize
                            topMargin: Theme.vars.barSize
                            bottomMargin: Theme.vars.sideSize
                        }

                        radius: Theme.vars.roundness
                    }
                }
            }
        }
    }
}
