import QtQuick
import "../Components"
import ".."

Window {
    id: root
    function middle(alpha, omega) {
        var toHalf = alpha.width/2 + Theme.vars.barModuleSideMargin - omega.width/2
        var value = alpha.mapToGlobal(toHalf, 0).x
        if (value + omega.width > screen.width) {
            return screen.width - omega.width - Theme.vars.barModuleSideMargin - Theme.vars.hyprlandGapsOut
        }
        else if (value < 0) {
            return 0 + Theme.vars.barModuleSideMargin
        }
        return alpha.mapToGlobal(toHalf, 0).x
    }

    property var target

    anchors {
        top: target.bottom
        left: true
    }

    margins.left: middle(target, root)
    margins.top: Theme.vars.hyprlandGapsOut - root.b*root.s/2
}
