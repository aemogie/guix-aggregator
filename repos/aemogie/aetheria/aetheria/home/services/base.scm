(define-module (aetheria home services base)
  #:use-module ((guix gexp) #:select (gexp
                                      plain-file))
  #:use-module ((gnu services) #:select (service-type
                                         service-extension))
  #:use-module ((gnu home services) #:select (home-profile-service-type))
  #:use-module ((gnu services shepherd) #:select (shepherd-service))
  #:use-module ((gnu system shadow) #:select (%default-dotguile
                                              %default-xdefaults
                                              %default-gdbinit
                                              %default-nanorc))
  #:use-module ((gnu home services) #:select (home-files-service-type
                                              home-xdg-configuration-files-service-type))
  #:use-module ((gnu home services shepherd) #:select (home-shepherd-service-type))
  #:use-module ((gnu home services shells) #:select (home-bash-service-type
                                                     home-bash-extension))
  #:use-module ((gnu home services syncthing) #:select (home-syncthing-service-type))
  #:use-module ((gnu packages base) #:select (gnu-make))
  #:use-module ((gnu packages gcc) #:select (gcc))
  #:use-module ((gnu packages version-control) #:select (git))
  #:use-module ((gnu packages vim) #:select (vim))
  #:use-module ((gnu packages shellutils) #:select (direnv))
  #:use-module ((gnu packages password-utils) #:select (password-store))
  #:use-module ((aetheria home services security) #:select (home-security-service-type))
  #:export (home-base-service-type))

(define %base-home-packages
  ;; just tiny/essential cli stuff. shouldnt require any graphics, all things
  ;; you can use over ssh for exmaple. fyi: i dont use vim, but the keybinds
  ;; are definitely better than whatever nano got
  (list direnv git vim password-store))

(define home-base-service-type
  (service-type
   (name 'home-base)
   (description "base services applicable even on a tty-only install")
   (default-value #f)
   (extensions (list
                (service-extension home-security-service-type (const #f))
                (service-extension home-syncthing-service-type (const #f))
                (service-extension home-profile-service-type (const %base-home-packages))
                (service-extension home-bash-service-type (const (home-bash-extension)))
                (service-extension home-shepherd-service-type
                                   (const (list (shepherd-service
                                                 (provision '(repl))
                                                 (modules '((shepherd service repl)))
                                                 (free-form #~(repl-service))))))
                (service-extension home-files-service-type
                                   (const `((".guile" ,%default-dotguile)
                                            (".Xdefaults" ,%default-xdefaults))))
                (service-extension home-xdg-configuration-files-service-type
                                   (const `(("gdb/gdbinit" ,%default-gdbinit)
                                            ("nano/nanorc" ,%default-nanorc))))))))
