import "../Components"
import "../Windows"
import Quickshell
import ".."
import "../Services"

BarModule {
    id: root
    property var _public: SharedVariables.mullvad = root

    icon: MullvadService.is_connected ? "verified_user" : "remove_moderator"

    LazyLoader {
        id: mullvadLoader
        loading: false
        component: MullvadWindow { loader: mullvadLoader }
    }

    InteractArea {
        onRightClick: mullvadLoader.active = !mullvadLoader.active
        onLeftClick: MullvadService.toggle_connection()
    }
}
