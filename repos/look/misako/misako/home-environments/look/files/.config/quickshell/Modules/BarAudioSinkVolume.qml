import Quickshell.Services.Pipewire
import ".."
import "../Components"

BorderBarModule {
    id: root
    property var _public: SharedVariables.sink = root
    property PwNodeAudio audio: Pipewire.defaultAudioSink.audio;

    icon: audio.muted ? "volume_off" : "volume_up"

    InteractArea {
        onLeftClick: root.audio.muted = !root.audio.muted
    }
}
