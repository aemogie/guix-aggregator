(define-module (aetheria)
  #:use-module ((srfi srfi-1) #:select (every
                                        lset=))
  #:use-module ((ice-9 rdelim) #:select (read-delimited))
  #:use-module ((gnu system) #:select (operating-system?))
  #:use-module ((gnu home) #:select (home-environment?))
  #:use-module ((guix inferior) #:select (cached-channel-instance))
  #:use-module ((guix describe) #:select (current-channels))
  #:use-module ((guix channels) #:select (channel-commit))
  #:use-module ((guix ui) #:select (leave
                                    build-notifier))
  #:use-module ((guix store) #:select (with-store
                                          with-build-handler))
  ;; not sure why i need this, but `leave` complains otherwise
  #:use-module ((guix i18n) #:select (G_))
  #:export (%project-root
            system-config
            home-config
            system-reconfigure))

(define %project-root
  (if (current-filename) ;; #f in repl, so fallback to cwd
      (dirname (current-filename))
      (getcwd)))

(define* (eval-as-type file type-name type-predicate?)
  (add-to-load-path %project-root)
  ;; look into adding inferior as well? or maybe wait for migration of the makefile to guile
  (define loaded (save-module-excursion
                  (lambda () (primitive-load-path file #f))))
  (unless loaded
    (error (format #f "file '~a' doesn't exist, or couldn't be found" file)))
  (unless (type-predicate? loaded)
    (error (format #f "file '~a' doesn't produce a record of type ~a" file type-name)))
  loaded)

(define* (system-config #:optional (host (gethostname)))
  (eval-as-type (string-append "aetheria/hosts/" host ".scm")
                "<operating-system>"
                operating-system?))

(define* (home-config #:optional (user (getlogin)))
  (eval-as-type (string-append "aetheria/users/" user ".scm")
                "<home-environment>"
                home-environment?))

;; guile -L . -c '((@ (aetheria) system-reconfigure))'
;; cant run with sudo currently, for some reason
(define (system-reconfigure)
  ;; maybe try to use some things from
  ;; https://github.com/nicolas-graves/dotfiles/blob/70a97833ca7eea3df441c5d4e2c08910dd8a29cf/make
  (add-to-load-path %project-root)
  (define requested-channels (load-from-path "channels.lock.scm"))

  (unless (every channel-commit requested-channels)
    (leave (G_ "lockfile contains unlocked channels~%")))

  (unless (lset= string=
                 (map channel-commit requested-channels)
                 (map channel-commit (current-channels)))
    (let* ((profile (with-store store
                      (with-build-handler (build-notifier #:verbosity 3)
                        (cached-channel-instance store requested-channels))))
           (guix (string-append profile "/bin/guix"))
           ;; hack, extract the correct guile from the guix's shebang, instead
           ;; of wasting a store connection
           (guile (with-input-from-file guix (lambda () (substring (read-delimited " ") 2))))
           (expr `((@ (aetheria) system-reconfigure)))
           (expr-str (with-output-to-string (lambda () (write expr)))))
      (pk 'locked)
      (execl guile ;; `guile` binary supports `-e`
             guix  ;; (current-channels) uses this arg
             "-L" %project-root
             "-c" expr-str)))

  (define %system-module (resolve-module '(guix scripts system)))
  (reload-module %system-module) ;; force load all private symbols

  ;; private bindings
  (define %default-options (module-ref %system-module '%default-options))
  (define process-action (module-ref %system-module 'process-action))

  (define expr `((@ (aetheria) system-config) ,(gethostname)))
  (define expr-str (with-output-to-string (lambda () (write expr))))

  (pk 'reconfiguring)
  (process-action 'reconfigure '() (append `((expression . ,expr-str)
                                             ;; doesnt make any difference tho, its still silent
                                             (verbosity . 3))
                                           %default-options))
  (pk 'done))

(system-config)
