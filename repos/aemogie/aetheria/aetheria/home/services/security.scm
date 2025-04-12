(define-module (aetheria home services security)
  #:use-module ((srfi srfi-1) #:select (concatenate
                                        fold))
  #:use-module ((guix gexp) #:select (plain-file
                                      file-append
                                      file-like?))
  #:use-module ((guix records) #:select (define-record-type*
                                          match-record-lambda))
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
  #:use-module ((aetheria records) #:select (fold-strategy-default
                                             conflict-strategy
                                             append-strategy
                                             lines-strategy
                                             define-foldable-record-type))
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
            home-gpg-agent-configuration-default-cache-ttl-ssh
            home-gpg-agent-configuration-max-cache-ttl-ssh
            home-gpg-agent-configuration-extra-content

            home-gpg-agent-service-type

            home-security-service-type))

;; not exported
(define upstream:home-gpg-agent-configuration-default-cache-ttl-ssh
  (module-ref (resolve-module '(gnu home services gnupg))
              'home-gpg-agent-configuration-default-cache-ttl-ssh))

(define-macro (unwrap name value . fields)
  (define upstream (symbol-append 'upstream: name))
  (define (upstream:field field-name)
    `(,(symbol-append upstream '- field-name) %upstream-default))
  (define (downstream:field field-name)
    `(,(symbol-append name '- field-name) ,value))
  `(begin
     (define %upstream-default (,upstream))
     (,upstream
      ,@(map (lambda (field)
               `(,(car field) (if (equal? (fold-strategy-default ,(cadr field))
                                          ,(downstream:field (car field)))
                                  ,(upstream:field (car field))
                                  ,(downstream:field (car field)))))
             fields))))

(define-foldable-record-type <home-openssh-configuration>
  home-openssh-configuration make-home-openssh-configuration
  home-openssh-configuration?
  merge-home-openssh-configuration fold-home-openssh-configuration
  (authorized-keys   home-openssh-configuration-authorized-keys
                     (fold append-strategy)) ;list of file-like
  (known-hosts       home-openssh-configuration-known-hosts
                     (fold append-strategy)) ;list of file-like
  (hosts             home-openssh-configuration-hosts
                     (fold append-strategy)) ;list of <openssh-host>
  (add-keys-to-agent home-openssh-configuration-add-keys-to-agent
                     (fold conflict-strategy))) ;string with limited values

(define (unwrap-home-openssh-configuration config)
  (unwrap home-openssh-configuration config
          (authorized-keys append-strategy)
          (known-hosts append-strategy)
          (hosts append-strategy)
          (add-keys-to-agent conflict-strategy)))

(define home-openssh-service-type
  (service-type
   (inherit upstream:home-openssh-service-type)
   (compose identity)
   (extend (lambda (config extensions)
             (unwrap-home-openssh-configuration
              (fold-home-openssh-configuration (cons config extensions)))))
   (default-value (home-openssh-configuration))))

(define-foldable-record-type <home-gpg-agent-configuration>
  home-gpg-agent-configuration make-home-gpg-agent-configuration
  home-gpg-agent-configuration?
  merge-home-gpg-agent-configuration fold-home-gpg-agent-configuration
  (gnupg                 home-gpg-agent-configuration-gnupg
                         (fold conflict-strategy)) ; file-like
  (pinentry-program      home-gpg-agent-configuration-pinentry-program
                         (fold conflict-strategy)) ; file-like
  (ssh-support?          home-gpg-agent-configuration-ssh-support?
                         (fold conflict-strategy)) ; boolean
  (default-cache-ttl     home-gpg-agent-configuration-default-cache-ttl
    (fold conflict-strategy))           ; integer
  (max-cache-ttl         home-gpg-agent-configuration-max-cache-ttl
                         (fold conflict-strategy)) ; integer
  (default-cache-ttl-ssh home-gpg-agent-configuration-default-cache-ttl-ssh
    (fold conflict-strategy))           ; integer
  (max-cache-ttl-ssh     home-gpg-agent-configuration-max-cache-ttl-ssh
                         (fold conflict-strategy)) ; integer
  (extra-content         home-gpg-agent-configuration-extra-content
                         (fold lines-strategy))) ; raw-configuration-string

(define (unwrap-home-gpg-agent-configuration config)
  (unwrap home-gpg-agent-configuration config
          (gnupg                 conflict-strategy)
          (pinentry-program      conflict-strategy)
          (ssh-support?          conflict-strategy)
          (default-cache-ttl     conflict-strategy)
          (max-cache-ttl         conflict-strategy)
          (default-cache-ttl-ssh conflict-strategy)
          (max-cache-ttl-ssh     conflict-strategy)
          (extra-content         lines-strategy)))

(define home-gpg-agent-service-type
  (service-type
   (inherit upstream:home-gpg-agent-service-type)
   (compose identity)
   (extend (lambda (config extensions)
             (unwrap-home-gpg-agent-configuration
              (fold-home-gpg-agent-configuration (cons config extensions)))))
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
