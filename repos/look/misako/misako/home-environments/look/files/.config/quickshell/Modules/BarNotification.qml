import QtQuick
import "../Components"
import ".."

BorderBarModule {
    id: root

    icon: SharedVariables.doNotDisturb ? "notifications_off" : "notifications"
    InteractArea {
        onLeftClick: {
            SharedVariables.doNotDisturb = !SharedVariables.doNotDisturb
        }
    }
}
