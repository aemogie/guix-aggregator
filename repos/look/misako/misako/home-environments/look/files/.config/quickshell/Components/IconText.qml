import QtQuick
import ".."

Text {
    property string fam

    color: Theme.vars.colorFont
    font.family: fam === "nf" ? "Symbols Nerd Font" : "Material Symbols Rounded"
    font.pixelSize: 16
}
