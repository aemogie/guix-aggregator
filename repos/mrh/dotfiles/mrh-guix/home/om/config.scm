(define-module (mrh-guix home om config)
  #:use-module (gnu)
  #:use-module (gnu home)
  #:use-module (gnu packages package-management)
  #:use-module (gnu packages video)
  #:use-module (gnu home services))

(define-public %om-home-config
  (home-environment
    (packages (list stow yt-dlp))
    (services
     (list
      (simple-service
       'environment-variables-service
       home-environment-variables-service-type
       '(("EDITOR" . "emacs")
         ("GNUPGHOME" . "$XDG_DATA_HOME/gnupg")
         ("GUILE_LOAD_PATH" . "$HOME/.guix-home/profile/share/guile/site/3.0:$HOME/.config/guix/current/share/guile/site/3.0:$GUILE_LOAD_PATH")
         ("GUILE_EXTENSIONS_PATH" . "$HOME/.guix-home/profile/lib:/run/current-system/profile/lib:$GUILE_EXTENSIONS_PATH")
         ("PATH" . "$HOME/.local/bin:$PATH")))))))

%om-home-config
