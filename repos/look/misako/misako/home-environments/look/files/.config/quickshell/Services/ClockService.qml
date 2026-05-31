pragma Singleton
import Quickshell

Scope {
    property alias clock: clock

    SystemClock {
        id: clock
        precision: SystemClock.Seconds
    }
}
