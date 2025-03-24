(define-module (aetheria users aemogie)
  #:use-module ((ice-9 match) #:select (match-lambda
                                         match))
  #:use-module ((guix gexp) #:select (plain-file))
  #:use-module ((gnu services) #:select (simple-service))
  #:use-module ((gnu home) #:select (home-environment))
  #:use-module ((gnu home services) #:select (home-xdg-configuration-files-service-type))
  #:use-module ((aetheria services kmonad) #:select (kmonad-keyboard-service))
  #:use-module ((aetheria home services kmonad) #:select (home-kmonad-service-type))
  #:use-module ((aetheria home base) #:select (%aetheria-desktop-home
                                               %aetheria-desktop-home-packages
                                               %aetheria-desktop-home-services))
  #:use-module ((aetheria users aemogie serena) #:select (serena-nivea-emacs-script
                                                          serena-keyboard))
  #:export (make-aemogie-home))

(define (make-kmonad-config hostname)
  (define src
    (match hostname
      ("serena" (serena-keyboard))
      (els (error "keyboard source not defined for host" els))))
  (define input-file
    (match hostname
      ("serena" "/dev/input/by-path/platform-i8042-serio-0-event-kbd")
      (els (error "keyboard input file not defined for host" els))))

  `((defcfg
      input (device-file ,input-file)
      output (uinput-sink "KMonad Remapped Keyboard")
      fallthrough #t)
    (defsrc ,@src)
    ;; kmonad defaults to the first deflayer
    (deflayer initial
      ,@(map (match-lambda
               ('caps '(tap-next esc (layer-toggle navigation)))
               ('ret '(tap-next ret (layer-toggle navigation)))
               ((or 'up 'rght 'down 'lft) 'XX)
               ((or 'home 'end) 'XX)
               ((or 'esc 'lctl) 'XX)
               ('nlck 'XX)
               (els els))
             src))

    ;; this is fake control because this doesnt add lctl to keys not
    ;; specified in defsrc
    (deflayer navigation
      ,@(map (match-lambda
               ('h 'lft)
               ('j 'down)
               ('k 'up)
               ('l 'right)
               ('g 'home)
               (#\; 'end)
               ((? integer? int) (symbol-append 'C- (string->symbol (number->string int))))
               ((? char? char) (symbol-append 'C- (list->symbol (list char))))
               ((? symbol? sym) (symbol-append 'C- sym)))
             src))))

(define git-config-service
  (simple-service
   'aemogie-git-config-service
   home-xdg-configuration-files-service-type
   `(("git/config" ,(plain-file "git-config" "\
[user]
email = \"lexi.callyscoped@gmail.com\"
name = \"lexi.callyscoped\"
signingKey = 1B39BA52B26B3DBB

[commit]
gpgSign = true

[tag]
gpgSign = true")))))

(define* (make-aemogie-home hostname)
  (home-environment
   (inherit %aetheria-desktop-home)
   (packages (append (match hostname
                       ("serena" (list serena-nivea-emacs-script))
                       (_ '()))
                     %aetheria-desktop-home-packages))
   (services (append (match hostname
                       ("serena" (list
                                  (kmonad-keyboard-service
                                   'serena-builtin home-kmonad-service-type
                                   (make-kmonad-config hostname))))
                       (_ '()))
                     (list git-config-service)
                     %aetheria-desktop-home-services))))

(make-aemogie-home (gethostname))
