(define-module (mrh-guix home lap config)
  #:use-module (mrh-guix home lap packages)
  #:use-module (gnu)
  #:use-module (gnu home)
  #:use-module (gnu home services)
  #:use-module (gnu home services desktop)
  #:use-module (gnu home services sound)
  #:use-module (gnu home services syncthing))

(define-public %lap-home-config
  (home-environment
   (packages %lap-home-packages)
   (services
    (list (service home-dbus-service-type)
          (service home-pipewire-service-type)
          (service home-syncthing-service-type)
          (simple-service 'environment-variables-service
                          home-environment-variables-service-type
                          '(("BROWSER" . "librewolf")
                            ("EDITOR" . "emacs")
                            ("MACHINE_ROLE" . "lap")
                            ("GNUPGHOME" . "$XDG_DATA_HOME/gnupg")
                            ("GUILE_EXTENSIONS_PATH" . "/run/current-system/profile/lib:/home/mrh/.guix-home/profile/lib:$GUILE_EXTENSIONS_PATH")
                            ("PATH" . "$HOME/.local/bin:$PATH")
                            ("TERM" . "xterm-color")
                            ("XDG_DOWNLOADS_DIR" . "$HOME/downloads")
                            ("SSH_ASKPASS" . "ksshaskpass")
                            ("SDL_VIDEODRIVER" . "wayland")
                            ;; ("SSH_ASKPASS_REQUIRE" . "prefer")
                            ("XDG_SCREENSHOTS_DIR" . "$HOME/media/pictures/screenshots")))))))

%lap-home-config
