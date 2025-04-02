(define-module (mrh-guix home box config)
  #:use-module (mrh-guix home box bash)
  #:use-module (mrh-guix home box packages)
  #:use-module (gnu)
  #:use-module (gnu services)
  #:use-module (gnu system shadow)
  #:use-module (gnu home)
  #:use-module (gnu home services)
  #:use-module (gnu home services shells)
  #:use-module (gnu home services desktop)
  #:use-module (gnu home services dotfiles)
  #:use-module (gnu home services sound)
  #:use-module (gnu home services syncthing)
  #:use-module (nongnu packages game-development))

(define %dotfiles-dir (format #f "~a/src/dotfiles" (getenv "HOME")))

(define-public %box-home-config
  (home-environment
   (packages %box-home-packages)
   (services
    (list ;; (service home-bash-service-type
     ;;          (box-bash-config %dotfiles-dir))

     (service home-dbus-service-type)
     ;; (service home-dotfiles-service-type
     ;;          (home-dotfiles-configuration
     ;;           (directories
     ;;            (list (format #f "~a/home" %dotfiles-dir)))))

     (simple-service 'environment-variables-service
                     home-environment-variables-service-type
                     '(("BROWSER" . "librewolf")
                       ("EDITOR" . "emacs")
                       ("MACHINE_ROLE" . "box")
                       ("GUILE_EXTENSIONS_PATH" . "/run/current-system/profile/lib:/home/mrh/.guix-home/profile/lib:$GUILE_EXTENSIONS_PATH")
                       ("GNUPGHOME" . "$XDG_DATA_HOME/gnupg")
                       ("PATH" . "$HOME/.local/bin:$PATH")
                       ("XDG_SCREENSHOTS_DIR" . "$HOME/media/pictures/screenshots")
                       ("XDG_DOWNLADS_DIR" . "$HOME/downloads")))
     
     (service home-files-service-type
              `((".Xdefaults" ,%default-xdefaults)))
     
     (service home-pipewire-service-type)
     (service home-syncthing-service-type)
     (service home-xdg-configuration-files-service-type
              `(("gdb/gdbinit" ,%default-gdbinit)))))))

%box-home-config
