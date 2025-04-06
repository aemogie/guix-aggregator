(define-module (aetheria home services security)
  #:use-module ((srfi srfi-1) #:select (concatenate
                                        fold))
  #:use-module ((ice-9 match) #:select (match-lambda))
  #:use-module ((guix gexp) #:select (plain-file
                                      file-append
                                      file-like?))
  #:use-module ((guix records) #:select (define-record-type*))
  #:use-module ((gnu services) #:select (service
                                         service-type
                                         service-extension))
  #:use-module ((gnu home services) #:select (home-profile-service-type
                                              home-files-service-type))
  #:use-module ((gnu home services gnupg)
                #:select (home-gpg-agent-service-type
                          home-gpg-agent-configuration))
  #:use-module ((gnu home services ssh)
                #:select (home-openssh-service-type
                          home-openssh-configuration
                          home-openssh-configuration-authorized-keys
                          home-openssh-configuration-known-hosts
                          home-openssh-configuration-hosts
                          home-openssh-configuration-add-keys-to-agent)
                #:prefix upstream:)
  #:use-module ((gnu home services ssh) #:select (openssh-host))
  #:use-module ((gnu home services shells) #:select (home-bash-service-type
                                                     home-bash-extension))
  #:use-module ((gnu packages gnupg) #:select (gnupg
                                               pinentry
                                               pinentry-tty))
  #:use-module ((gnu packages ssh) #:select (openssh-sans-x))
  #:export (home-openssh-service-type
            home-openssh-configuration
            home-openssh-configuration-authorized-keys
            home-openssh-configuration-known-hosts
            home-openssh-configuration-hosts
            home-openssh-configuration-add-keys-to-agent
            home-openssh-configuration?
            home-security-service-type
            home-security-services))

(define* (flat-map xs proc #:optional (on-empty '()))
  (let ((xs* (concatenate (map proc xs))))
    (if (pair? xs*) xs* on-empty)))

(define-record-type* <home-openssh-configuration>
  home-openssh-configuration make-home-openssh-configuration
  home-openssh-configuration?
  (authorized-keys   home-openssh-configuration-authorized-keys ;list of file-like
                     (default '()))
  (known-hosts       home-openssh-configuration-known-hosts ;list of file-like
                     (default '()))
  (hosts             home-openssh-configuration-hosts ;list of <openssh-host>
                     (default '()))
  (add-keys-to-agent home-openssh-configuration-add-keys-to-agent ;string with limited values
                     (default #f)))

(define home-openssh-service-type
  (service-type
   (inherit upstream:home-openssh-service-type)
   (compose identity)
   (extend (lambda (config extensions)
             (define default (upstream:home-openssh-configuration))
             (upstream:home-openssh-configuration
              (authorized-keys
               (flat-map (cons config extensions)
                         home-openssh-configuration-authorized-keys
                         (upstream:home-openssh-configuration-authorized-keys
                          default)))
              (known-hosts
               (flat-map (cons config extensions)
                         home-openssh-configuration-known-hosts
                         (upstream:home-openssh-configuration-known-hosts
                          default)))
              (hosts
               (flat-map (cons config extensions)
                         home-openssh-configuration-hosts
                         (upstream:home-openssh-configuration-hosts
                          default)))
              (add-keys-to-agent
               (or (fold (lambda (curr saved)
                           (define (conflict)
                             (error 'home-openssh-service-type
                                    "multiple conflicting definitions for add-keys-to-agent"
                                    saved curr))
                           ;; conflict case
                           (or (and curr saved (not (equal? curr saved)) (conflict))
                               ;; else either both are equal or one is false,
                               ;; pick whichever is truthy it doesnt matter
                               curr saved))
                         #f
                         (map home-openssh-configuration-add-keys-to-agent
                              (cons config extensions)))
                   (upstream:home-openssh-configuration-add-keys-to-agent
                    default))))))
   (default-value (home-openssh-configuration))))

(define home-security-service-type
  (service-type
   (name 'home-security)
   (description "Setup and configure GPG/SSH services")
   (extensions (list
                (service-extension home-profile-service-type
                                   (const (list gnupg openssh-sans-x)))

                ;; TOOD home-gpg-agent-service-type extension goes here

                (service-extension
                 home-files-service-type
                 (const `((".gnupg/gpg.conf"
                           ,(plain-file "gpg.conf" "pinentry-mode loopback")))))
                ;; this sets in on bash, but im sure everything else is broken.
                ;; eshell starts a new tty each command.
                ;; i'm not sure how magit works (e.g. magit-clone with ssh repo url).
                ;; workaround for now, just shell out to bash, e.g.:
                ;; bash -c 'GPG_TTY=$(tty) git clone git@github.com:aemogie/nivea.git'
                ;; a graphical pinentry might be easier
                (service-extension
                 home-bash-service-type
                 (const (home-bash-extension
                         (bashrc (list (plain-file "bashrc" "export GPG_TTY=\"$(tty)\""))))))
                (service-extension
                 home-openssh-service-type
                 (const (home-openssh-configuration
                         (hosts (list
                                 (openssh-host
                                  ;; NOTE: $GPG_TTY must be set before this
                                  ;; source: https://unix.stackexchange.com/a/587691
                                  (match-criteria
                                   (let ((command "gpg-connect-agent UPDATESTARTUPTTY /bye"))
                                     (format #f "host * exec \"~a\"" command)))))))))))
   (default-value #f)))

(define home-security-services
  (list
   (service home-security-service-type)
   ;; TODO: move into home-security-service-type
   (service home-gpg-agent-service-type
            (home-gpg-agent-configuration
             (ssh-support? #t)
             ;; default pinentry-curses doesnt work with
             ;; eshell/eat
             (pinentry-program
              (file-append pinentry-tty "/bin/pinentry-tty"))
             (extra-content "allow-loopback-pinentry")))))
