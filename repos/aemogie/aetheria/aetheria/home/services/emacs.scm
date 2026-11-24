(define-module (aetheria home services emacs)
  #:use-module ((ice-9 match) #:select (match-lambda))
  #:use-module ((srfi srfi-1) #:select (concatenate))
  #:use-module ((guix records) #:select (match-record-lambda))
  #:use-module ((guix gexp) #:select (gexp
                                      file-append
                                      with-imported-modules
                                      program-file
                                      computed-file))
  #:use-module ((guix packages) #:select (package))
  #:use-module ((guix modules) #:select (source-module-closure))
  #:use-module ((guix profiles) #:select (packages->manifest
                                          manifest
                                          manifest-search-paths
                                          profile))
  #:use-module ((guix search-paths) #:select (search-path-specification->sexp))
  #:use-module ((guix licenses) #:select (gpl3) #:prefix license:)
  #:use-module ((guix build-system trivial) #:select (trivial-build-system))
  #:use-module ((guix build-system emacs) #:select (emacs-build-system))
  #:use-module ((gnu home services) #:select (service-type
                                              service-extension
                                              home-profile-service-type))
  #:use-module ((gnu home services shepherd) #:select (home-shepherd-service-type
                                                       shepherd-service))
  #:use-module ((gnu packages emacs) #:select (emacs-pgtk))
  #:use-module ((gnu packages aspell) #:select (aspell aspell-dict-en))
  #:use-module ((gnu packages bash) #:select (bash-minimal))
  #:use-module ((aetheria records) #:select (define-record-type2
                                              conflict-strategy
                                              append-strategy
                                              lines-strategy))
  #:use-module ((aetheria build-system file-like) #:select (program-file-build-system
                                                            single-file-source))
  #:export (home-emacs-service-type
            %aetheria-home-emacs-configuration
            home-emacs-configuration))

(define-record-type2 home-emacs-configuration #:fold
  (emacs          (merge conflict-strategy))
  (extra-packages (merge   append-strategy))
  (extra-code     (merge   append-strategy))
  (use-server?    (merge conflict-strategy)))

(define %aetheria-home-emacs-configuration
  (home-emacs-configuration
   (emacs emacs-pgtk)
   (extra-packages (list aspell aspell-dict-en))
   (use-server? #t)))

(define (serialise-elisp code)
  #~(with-output-to-file #$output
      (lambda ()
        (define serialise
          ((@ (ice-9 match) match-lambda)
           (#t "t")
           (#f "nil")
           ((? char? ch) (string-append "?" ch))
           ((? symbol? sym) (symbol->string sym))
           ((? number? num) (number->string num))
           ((? keyword? key) (string-append ":" (symbol->string (keyword->symbol key))))
           ((? string? str) (string-append "\"" str "\""))
           (('gexp g) (primitive-eval g))
           ((? list? (lst ...)) (string-append "(" (string-join (map serialise lst) " ") ")"))
           ((? pair? pair) (string-append "(" (serialise (car pair)) " . " (serialise (cdr pair)) ")"))
           (invalid (throw 'elisp-serialization invalid))))
        (map (compose display serialise) '#$code))))

(define (make-emacs-default.el-package extra-code extra-packages)
  (package
    (name "emacs-default")
    (version "0.1.0")
    (source (computed-file "default.el" (serialise-elisp extra-code)))
    (build-system emacs-build-system)
    (propagated-inputs extra-packages)
    (synopsis "default.el")
    (description "The default.el package will get automatically loaded
by emacs on initialisation. This allow us to declare our emacs configuration
as just another guix package.")
    (license license:gpl3)
    (home-page "n/a")))

(define make-emacs-wrapper
  (match-record-lambda <home-emacs-configuration> (emacs extra-packages extra-code)    
    (let* ((default.el (make-emacs-default.el-package extra-code extra-packages))
          (manifest (packages->manifest (cons* emacs default.el extra-packages)))
          (search-paths (map search-path-specification->sexp (manifest-search-paths manifest)))
          (builder (with-imported-modules (source-module-closure '((guix build utils) (guix search-paths)))
                     #~(begin
                         (use-modules (ice-9 match) (guix build utils) (guix search-paths))
                         (copy-recursively #$emacs:out #$output:out #:copy-file symlink #:log #f
                                           #:select? (lambda (f s) (not (wrapped-program? f))))
                         (copy-recursively #$emacs:src #$output:src #:copy-file symlink #:log #f)
                         (apply wrap-program (in-vicinity #$output "bin/emacs")
                                #:sh (search-input-file %build-inputs "/bin/bash")
                                (map
                                 (match-lambda
                                   ((($ <search-path-specification> variable files seperator) . value)
                                    (if seperator
                                        (list variable seperator 'prefix (list value))
                                        (list variable '= (list value)))))
                                 (evaluate-search-paths (map sexp->search-path-specification '#$search-paths)
                                                        (list #$(profile
                                                                  (name "emacs-extra-packages")
                                                                  (content manifest))))))))))
      (package
        (inherit emacs)
        (name "emacs-with-packages")
        (inputs (list bash-minimal))
        (build-system trivial-build-system)
        (source #f)
        (native-inputs '())
        (arguments (list #:builder builder))))))

(define home-emacs-shepherd-service
  (match-lambda
    ((and config ($ <home-emacs-configuration>
                    emacs extra-packages extra-code (and use-server? #t)))
     (list (shepherd-service
             (documentation "Emacs daemon service")
             (provision (list 'emacs 'emacs-daemon))
             (start #~(make-forkexec-constructor
                         (list #$(file-append (make-emacs-wrapper config) "/bin/emacs") "--fg-daemon")))
             (stop #~(make-kill-destructor)))))
    (($ <home-emacs-configuration>) '())
    (_ (error "invalid argument provided to home-emacs-shepherd-service"))))

(define (home-emacs-profile-service config)
  (define emacs (make-emacs-wrapper config))
  (define cmd
    (if (home-emacs-configuration-use-server? config)
        (list (file-append emacs "/bin/emacsclient") "-r")
        (list (file-append emacs "/bin/emacs"))))
  (list emacs
        (package
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
   (compose concatenate)
   (extend (lambda (config extensions)
             (fold-home-emacs-configuration (cons config extensions))))))
