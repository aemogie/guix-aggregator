import Quickshell
import QtQuick
import "../Components"

BarModule {
    SystemClock {
        id: clock
        precision: SystemClock.Seconds
    }

    StyledText {
        text: Qt.formatDateTime(clock.date, "hh:mm ddd, MMM dd")
    }
}
