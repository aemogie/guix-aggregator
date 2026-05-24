import Quickshell
import QtQuick
import "../Components"

BarModule {
    SystemClock {
        id: clock
        precision: SystemClock.Seconds
    }

    CenteredStyledText {
        text: Qt.formatDateTime(clock.date, "hh:mm ddd, MMM dd")
    }
}
