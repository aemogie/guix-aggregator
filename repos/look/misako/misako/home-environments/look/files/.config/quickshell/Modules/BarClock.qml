import QtQuick
import "../Components"
import "../Services"
import ".."

BorderBarModule {
    id: root
    property var _public: SharedVariables.clock = root

    StyledText {
        text: Qt.formatDateTime(ClockService.clock.date, "hh:mm ddd, MMM dd")
    }
}
