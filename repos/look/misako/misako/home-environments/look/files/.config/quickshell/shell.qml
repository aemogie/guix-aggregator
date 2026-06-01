//@ pragma IconTheme MoreWaita
//@ pragma UseQApplication
import Quickshell
import QtQuick
import "Modules"
import "Components"
import "Services"

ShellRoot {
    id: main

    property var _init: [NotificationService]

    Notification { }
    IdleService { }
    WallpaperService { }
    BezelsMask { }
    BarTop { }
    BarRight { }
    BarLeft { }
    BarBottom { }
}
