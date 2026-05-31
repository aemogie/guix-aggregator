import QtQuick
import "../Components"
import "../Services"

BorderBarModule {
    StyledText {
        text: Qt.formatDateTime(ClockService.clock.date, "hh:mm ddd, MMM dd")
    }
}
