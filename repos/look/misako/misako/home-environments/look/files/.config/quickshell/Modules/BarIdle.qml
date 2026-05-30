import QtQuick
import ".."
import "../Components"

BorderBarModule {
    id: root

    icon: SharedVariables.idleEnabled ? "visibility" : "visibility_off"
    icon_extra_y: 1

    onLeftClick: SharedVariables.idleEnabled = !SharedVariables.idleEnabled
}
