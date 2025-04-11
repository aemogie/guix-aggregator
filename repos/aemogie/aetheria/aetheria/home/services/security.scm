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
                #:select (home-gpg-agent-configuration
                          home-gpg-agent-configuration?
                          home-gpg-agent-configuration-gnupg
                          home-gpg-agent-configuration-pinentry-program
                          home-gpg-agent-configuration-ssh-support?
                          home-gpg-agent-configuration-default-cache-ttl
                          home-gpg-agent-configuration-max-cache-ttl
                          home-gpg-agent-configuration-max-cache-ttl-ssh
                          home-gpg-agent-configuration-extra-content

                          home-gpg-agent-service-type)
                #:prefix upstream:)
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
  #:use-module ((aetheria records) #:select (define-foldable-wrapper-type))
  #:export (home-openssh-configuration
            home-openssh-configuration-authorized-keys
            home-openssh-configuration-known-hosts
            home-openssh-configuration-hosts
            home-openssh-configuration-add-keys-to-agent
            home-openssh-configuration?

            home-openssh-service-type

            home-gpg-agent-configuration
            home-gpg-agent-configuration?
            home-gpg-agent-configuration-gnupg
            home-gpg-agent-configuration-pinentry-program
            home-gpg-agent-configuration-ssh-support?
            home-gpg-agent-configuration-default-cache-ttl
            home-gpg-agent-configuration-max-cache-ttl
            home-gpg-agent-configuration-max-cache-ttl-ssh
            home-gpg-agent-configuration-extra-content

            home-gpg-agent-service-type

            home-security-service-type))

(define upstream:home-gpg-agent-configuration-default-cache-ttl-ssh
  (module-ref (resolve-module '(gnu home services gnupg))
              'home-gpg-agent-configuration-default-cache-ttl-ssh))

(define-foldable-wrapper-type home-openssh-configuration
  #:wraps upstream:home-openssh-configuration
  #:wrapped-default (upstream:home-openssh-configuration)
  (authorized-keys list)                ;list of file-like
  (known-hosts list)                    ;list of file-like
  (hosts list)                          ;list of <openssh-host>
  (add-keys-to-agent conflict)) ;string with limited values

(define home-openssh-service-type
  (service-type
   (inherit upstream:home-openssh-service-type)
   (compose identity)
   (extend (lambda (config extensions)
             (unwrap-home-openssh-configuration
              (fold-home-openssh-configuration extensions config))))
   (default-value (home-openssh-configuration))))

(define-foldable-wrapper-type home-gpg-agent-configuration
  #:wraps upstream:home-gpg-agent-configuration
  #:wrapped-default (upstream:home-gpg-agent-configuration)
  (gnupg conflict)                      ; file-like
  (pinentry-program conflict)           ; file-like
  (ssh-support? conflict)               ; boolean
  (default-cache-ttl conflict)          ; integer
  (max-cache-ttl conflict)              ; integer
  (default-cache-ttl-ssh conflict)      ; integer
  (max-cache-ttl-ssh conflict)          ; integer
  (extra-content lines)) ; raw-configuration-string

(define home-gpg-agent-service-type
  (service-type
   (inherit upstream:home-gpg-agent-service-type)
   (compose identity)
   (extend (lambda (config extensions)
             (unwrap-home-gpg-agent-configuration
              (fold-home-gpg-agent-configuration extensions config))))
   (default-value (home-gpg-agent-configuration))))

(define home-security-service-type
  (service-type
   (name 'home-security)
   (description "Setup and configure GPG/SSH services")
   (extensions (list
                (service-extension home-profile-service-type
                                   (const (list gnupg openssh-sans-x)))

                (service-extension home-gpg-agent-service-type
                                   (const (home-gpg-agent-configuration
                                           (ssh-support? #t)
                                           ;; default pinentry-curses doesnt work with
                                           ;; eshell/eat
                                           (pinentry-program
                                            (file-append pinentry-tty "/bin/pinentry-tty"))
                                           (extra-content "allow-loopback-pinentry"))))

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
