(define-module (mrh-guix home sleep config)
  #:use-module (mrh-guix personal)
  #:use-module (mrh-guix home sleep packages)
  #:use-module (gnu)
  #:use-module (gnu packages gnupg)
  #:use-module (gnu home)
  #:use-module (gnu home services)
  #:use-module (gnu home services desktop)
  #:use-module (gnu home services gnupg)
  #:use-module (gnu home services shells)
  #:use-module (gnu home services sound)
  #:use-module (gnu home services ssh))

(define-public %sleep-home-config
  (home-environment
    (packages %sleep-home-packages)
    (services
     (list (service home-dbus-service-type)
           (service home-pipewire-service-type)
           (service home-gpg-agent-service-type
                    (home-gpg-agent-configuration
                      (pinentry-program (file-append pinentry-tty "/bin/pinentry"))
                      (default-cache-ttl 86400)
                      (max-cache-ttl 86400)
                      (extra-content "allow-emacs-pinentry\n")))
           (service home-ssh-agent-service-type
                    (home-ssh-agent-configuration
                      (extra-options '("-t" "1d"))))
           (simple-service
            'extra-env-vars
            home-environment-variables-service-type
            '(("ASPELL_DICT_DIR" . "$HOME/.guix-home/profile/lib/aspell")
              ("BROWSER" . "librewolf")
              ("EDITOR" . "emacsclient -c")
              ("GUILE_LOAD_PATH" . "$HOME/.guix-home/profile/share/guile/site/3.0:$HOME/.config/guix/current/share/guile/site/3.0:$GUILE_LOAD_PATH")
              ("GUILE_EXTENSIONS_PATH" . "$HOME/.guix-home/profile/lib:/run/current-system/profile/lib:$GUILE_EXTENSIONS_PATH")
              ("PATH" . "$HOME/.local/bin:$PATH")
              ("TERM" . "xterm-color")
              ("SDL_VIDEODRIVER" . "wayland")))
           (simple-service
            'bashrc-service
            home-bash-service-type
            (home-bash-extension
              (bashrc
               (list
                (local-file (format #f "~a/.bashrc" %guix-dots-dir)
                            "bashrc")))))))))

%sleep-home-config
