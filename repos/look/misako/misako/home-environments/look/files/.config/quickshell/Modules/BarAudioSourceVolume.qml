import Quickshell.Services.Pipewire
import ".."
import "../Components"

BorderBarModule {
    id: root
    property var _public: SharedVariables.source = root
    property PwNode source: Pipewire.defaultAudioSource;
    property PwNodeAudio audio: Pipewire.defaultAudioSource.audio;

    PwObjectTracker { objects: [ root.source ] }

    icon: audio.muted ? "mic_off" : "mic"

    InteractArea {
        onLeftClick: root.audio.muted = !root.audio.muted
    }
}
