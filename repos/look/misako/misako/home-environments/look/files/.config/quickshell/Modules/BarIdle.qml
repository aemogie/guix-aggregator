import QtQuick
import ".."
import "../Components"

BorderBarModule {
    id: root
    property var _public: SharedVariables.idle = root

    icon: SharedVariables.idleEnabled ? "visibility_off" : "visibility"
    icon_extra_y: 1

    InteractArea {
        onLeftClick: SharedVariables.idleEnabled = !SharedVariables.idleEnabled
    }
}
