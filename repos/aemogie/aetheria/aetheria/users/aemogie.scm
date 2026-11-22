(define-module (aetheria users aemogie)
  #:use-module ((ice-9 match) #:select (match-lambda
                                         match))
  #:use-module ((guix gexp) #:select (plain-file))
  #:use-module ((gnu system accounts) #:select (user-account
                                                user-account-home-directory))
  #:use-module ((gnu services) #:select (simple-service
                                         service))
  #:use-module ((gnu home) #:select (home-environment
                                     home-environment-packages
                                     home-environment-user-services))
  #:use-module ((gnu home services) #:select (home-xdg-configuration-files-service-type))
  #:use-module ((guix-science packages typst) #:select (typst))
  #:use-module ((aetheria system base) #:select (%aetheria-user-template))
  #:use-module ((aetheria services kmonad) #:select (kmonad-keyboard-service))
  #:use-module ((aetheria home services kmonad) #:select (home-kmonad-service-type))
  #:use-module ((aetheria home services desktop) #:select (%aetheria-desktop-home-services))
  #:use-module ((aetheria home services emacs) #:select (home-emacs-service-type
                                                         %aetheria-home-emacs-configuration
                                                         home-emacs-configuration))
  #:use-module ((aetheria home services emacs-xyz) #:select (aetheria-home-emacs-ui-service-type))
  #:use-module ((aetheria home services persist) #:select (home-persist-service-type
                                                           persist-configuration-defaults))
  #:use-module ((aetheria users aemogie serena) #:select (serena-nivea-emacs
                                                          serena-keyboard))
  #:export (make-aemogie-home
            aemogie-account))

(define aemogie-account
  (user-account
    (inherit %aetheria-user-template)
    (name "aemogie")))

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
               ;; i use this at work with powertoys, since powertoys doesnt have tap behaviour
               ('caps 'esc)
               ('ret 'esc)
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
email = \"theaemogie@gmail.com\"
name = \"aemogie.\"

[commit]
gpgSign = true

[tag]
gpgSign = true"))
     ("git/ignore" ,(plain-file "git-ignore" "\
# emacs
*~
.#*
\\#*#
# gcc
a.out
")))))

(define persist-service
  (simple-service
   'aemogie-persist-service
   home-persist-service-type
   (cons
    (persist-configuration-defaults
     (drive (string-append (user-account-home-directory aemogie-account)
                           "/.local/state/persist"))
     (user aemogie-account))
    (map
     (lambda (s) (string-append (user-account-home-directory aemogie-account) "/" s))
     '(;; things
       "Sync" "Projects" "Music"
       ".password-store"
       ;; state
       ".gnupg" ".config/guix" ".librewolf"
       ".local/share/direnv")))))

;; make into an aemogie-emacs-service-type
(define emacs-services
  (list
   (simple-service 'emacs-ui aetheria-home-emacs-ui-service-type '())))

(define* (make-aemogie-home hostname)
  (home-environment
   (packages (list typst))
   (services (append (if (eq? hostname "serena")
                         (list (kmonad-keyboard-service
                                'serena-builtin home-kmonad-service-type
                                (make-kmonad-config hostname)))
                         '())
                     (if (eq? hostname "serena")
                         (list (service home-emacs-service-type
                                        (home-emacs-configuration
                                         (inherit %aetheria-home-emacs-configuration)
                                         (emacs serena-nivea-emacs))))
                         (list (service home-emacs-service-type)))
                     (list git-config-service persist-service)
                     emacs-services
                     %aetheria-desktop-home-services))))

(make-aemogie-home (gethostname))
