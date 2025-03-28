(define-module (aetheria)
  #:use-module ((gnu system) #:select (operating-system?))
  #:use-module ((gnu home) #:select (home-environment?))
  #:export (%project-root
            system-config
            home-config))

(define %project-root
  (if (current-filename) ;; #f in repl, so fallback to cwd
      (dirname (current-filename))
      (getcwd)))
(add-to-load-path %project-root)

(define* (eval-as-type file type-name type-predicate?)
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

(define (system-reconfigure)
  (define %system-module (resolve-module '(guix scripts system)))
  (reload-module %system-module) ;; force load all private symbols

  ;; private bindings
  (define %default-options (module-ref %system-module '%default-options))
  (define process-action (module-ref %system-module 'process-action))

  (define expr `((@ (aetheria) system-config) ,(gethostname)))
  (define expr-str (with-output-to-string (lambda () (write expr))))
  (error 'todo 'time-machine)
  (process-action 'reconfigure '() (acons 'expression expr-str %default-options)))

(system-config)
