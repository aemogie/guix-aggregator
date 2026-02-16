(define-module (mrh-guix home om config)
  #:use-module (mrh-guix personal)
  #:use-module (gnu)
  #:use-module (gnu home)
  #:use-module (gnu packages package-management)
  #:use-module (gnu packages video)
  #:use-module (gnu home services)
  #:use-module (gnu home services shells))

(define-public %om-home-config
  (home-environment
    (packages (list stow yt-dlp))
    (services
     (list
      (simple-service
       'environment-variables-service
       home-environment-variables-service-type
       '(("EDITOR" . "mg")
         ("GUILE_LOAD_PATH" . "$HOME/.guix-home/profile/share/guile/site/3.0:$HOME/.config/guix/current/share/guile/site/3.0:$GUILE_LOAD_PATH")
         ("GUILE_EXTENSIONS_PATH" . "$HOME/.guix-home/profile/lib:/run/current-system/profile/lib:$GUILE_EXTENSIONS_PATH")
         ("PATH" . "$HOME/.local/bin:$PATH")))
      (simple-service
       'bashrc-service
       home-bash-service-type
       (home-bash-extension
         (bashrc
          (list
           (local-file (format #f "~a/.bashrc" %guix-dots-dir)
                       "bashrc")))))))))

%om-home-config
