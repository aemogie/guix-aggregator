(define-module (aetheria home services emacs)
  #:use-module ((ice-9 match) #:select (match-lambda))
  #:use-module ((guix gexp) #:select (gexp
                                      file-append
                                      with-imported-modules
                                      program-file))
  #:use-module ((guix modules) #:select (source-module-closure))
  #:use-module ((guix profiles) #:select (packages->manifest
                                          manifest
                                          profile
                                          profile-derivation))
  #:use-module ((guix packages) #:select (package))
  #:use-module ((gnu home services) #:select (service-type
                                              service-extension
                                              home-profile-service-type))
  #:use-module ((gnu home services shepherd) #:select (home-shepherd-service-type
                                                       shepherd-service))
  #:use-module ((gnu packages emacs) #:select (emacs-pgtk-xwidgets))
  #:use-module ((gnu packages aspell) #:select (aspell aspell-dict-en))
  #:use-module ((aetheria records) #:select (define-record-type2
                                              conflict-strategy
                                              append-strategy))
  #:use-module ((aetheria build-system file-like) #:select (program-file-build-system))
  #:use-module ((guix licenses) #:select (gpl3) #:prefix license:)
  #:export (home-emacs-service-type
            %aetheria-home-emacs-configuration
            home-emacs-configuration))

(define-record-type2 home-emacs-configuration #:fold
  (package        (merge conflict-strategy))
  (extra-packages (merge   append-strategy))
  (use-server?    (merge conflict-strategy)))

(define %aetheria-home-emacs-configuration
  (home-emacs-configuration
   (package emacs-pgtk-xwidgets)
   (extra-packages (list aspell aspell-dict-en))
   (use-server? #t)))

(define home-emacs-shepherd-service
  (match-lambda
    (($ <home-emacs-configuration>
        package extra-packages (and use-server? #t))
     (list (shepherd-service
            (documentation "Emacs daemon service")
            (provision (list 'emacs 'emacs-daemon))
            (start (with-imported-modules (source-module-closure '((guix profiles)))
                     #~(begin
                         (use-modules (guix profiles))
                         (lambda args
                           (define pid (primitive-fork))
                           (if (zero? pid) 
                               (begin
                                 ;; todo modify (default-environment-variables) instead
                                 ;; then we can just call make-forkexec-constructor
                                 (load-profile
                                  #$(profile
                                     (name "emacs-extra-packages")
				     (content (packages->manifest extra-packages))))
                                 (exec-command (list #$(file-append package "/bin/emacs") "--fg-daemon")
                                               #:environment-variables (environ)))
                               ;; "running value" conmsumed by kill-destructor
                               (begin
                                 ((@@ (shepherd service) monitor-service-process) (current-service) pid)
                                 pid))))))
            (stop #~(make-kill-destructor)))))
    (($ <home-emacs-configuration>) '())
    (_ (error "invalid argument provided to home-emacs-shepherd-service"))))

(define (home-emacs-profile-service config)
  (define cmd
    (if (home-emacs-configuration-use-server? config)
        (list (file-append (home-emacs-configuration-package config) "/bin/emacsclient") "-c")
        (list (file-append (home-emacs-configuration-package config) "/bin/emacs"))))
  (list (package
          (name "emacs-alias")
          (version "0")
          (source (program-file "e" #~(apply execl #$@cmd (cdr (program-arguments)))))
          (build-system program-file-build-system)
          (synopsis "alias for the editor")
          (description "a one-letter script to launch emacs")
          (license license:gpl3)
          (home-page "https://github.com/aemogie/aetheria"))))

(define home-emacs-service-type
  (service-type
   (name 'home-emacs)
   (description "emacs service with aetheria defaults")
   (default-value %aetheria-home-emacs-configuration)
   (extensions
    (list
     (service-extension home-shepherd-service-type home-emacs-shepherd-service)
     (service-extension home-profile-service-type home-emacs-profile-service)))
   (compose identity)
   (extend (lambda (config extensions)
             (fold-home-emacs-configuration (cons config extensions))))))
