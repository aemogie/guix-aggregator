(define-module (mrh-guix home sleep config)
  #:use-module (mrh-guix home sleep packages)
  #:use-module (gnu)
  #:use-module (gnu home)
  #:use-module (gnu home services)
  #:use-module (gnu home services desktop)
  #:use-module (gnu home services sound)
  #:use-module (gnu home services syncthing))

(define-public %sleep-home-config
  (home-environment
    (packages %sleep-home-packages)
    (services
     (list (service home-dbus-service-type)
           (service home-pipewire-service-type)
           (service home-syncthing-service-type)
           (simple-service
            'environment-variables-service
            home-environment-variables-service-type
            '(("ASPELL_DICT_DIR" . "$HOME/.guix-home/profile/lib/aspell/")
              ("BROWSER" . "librewolf")
              ("EDITOR" . "emacs")
              ("GNUPGHOME" . "$XDG_DATA_HOME/gnupg")
              ("GUILE_LOAD_PATH" . "$HOME/.guix-home/profile/share/guile/site/3.0:$HOME/.config/guix/current/share/guile/site/3.0:$GUILE_LOAD_PATH")
              ("GUILE_EXTENSIONS_PATH" . "$HOME/.guix-home/profile/lib:/run/current-system/profile/lib:$GUILE_EXTENSIONS_PATH")
              ("PATH" . "$HOME/.local/bin:$PATH")
              ("TERM" . "xterm-color")
              ("SSH_ASKPASS" . "ksshaskpass")
              ("SDL_VIDEODRIVER" . "wayland")
              ;; ("SSH_ASKPASS_REQUIRE" . "prefer")
              ))))))

%sleep-home-config
