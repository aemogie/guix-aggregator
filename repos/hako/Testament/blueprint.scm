;;; SPDX-License-Identifier: GPL-3.0-or-later
;;; Copyright © 2026 Hilton Chain <hako@ultrarare.space>

(use-modules (ice-9 match)
             (oop goops)
             (srfi srfi-1)
             (srfi srfi-19)
             (srfi srfi-26)
             (blue build)
             (blue computation)
             (blue oop)
             (blue subprocess)
             (blue types blueprint)
             (blue types buildable)
             (blue types command)
             (blue types configuration)
             (blue types variable)
             (guix utils)
             (guix build utils))


;;;
;;; Helper procedures.
;;;

(define-syntax %substitute-urls
  (identifier-syntax (substitute-urls #%?URL)))

(define-syntax %build-options
  (identifier-syntax (build-options)))

(define (substitute-urls urls)
  (string-append "--substitute-urls=" urls))

(define (build-options)
  `("--keep-going"
    "--verbosity=1"
    "--load-path=modules/config"
    ,%substitute-urls))

(define (print-header header target)
  (format (current-output-port) "\t~a\t~a\n" header target))

(define ($ cmd)
  "Run command from CMD list, raise an error for non-zero return value."
  (match cmd
    ((prog . args)
     (let ((exit-val (popen prog args)))
       (or (zero? exit-val)
           (error (format #f "Command ~s exited with non-zero exit status: ~s"
                          (string-join cmd) exit-val)))))))

(define* ($guix args #:key fork? (channels "channels.lock") #:allow-other-keys)
  (if fork?
      ($ `("./pre-inst-env" "guix" ,@args))
      ($ `("guix" "time-machine" "-C" ,channels ,%substitute-urls "--" ,@args))))

(define ($emacs args)
  ($guix `("shell" "emacs-minimal" "--" "emacs" ,@args)))


;;;
;;; Classes.
;;;

(define-blue-class <shared-config> (<buildable>))
(define-blue-class <system-config> (<shared-config>))

(define-method (clean! (this <shared-config>))
  (let ((file (first (buildable-outputs this))))
    (when (file-exists? file)
      (print-header "RM" file)
      (false-if-exception (delete-file-recursively file)))))

(define-method (ask-build-manifest (buildable <shared-config>)
                                   (inputs <list>)
                                   (outputs <list>))
  (define input
    (first inputs))

  (define output
    (first outputs))

  (make-build-manifest
   (string-append "TANGLE\t" output)
   (lambda ()
     ($emacs
      `("--quick" "--batch"
        "--load" "ob-tangle"
        "--eval" "(setopt org-babel-load-languages '((shell . t)))"
        "--eval" "(setopt org-confirm-babel-evaluate nil)"
        "--eval" ,(format #f "(org-babel-tangle-file ~s)" input)))
     ($ `("touch" ,output)))))

(define-method (ask-build-manifest (buildable <system-config>)
                                   (inputs <list>)
                                   (outputs <list>))
  ;; Add <shared-config> dependencies to Library of Babel.
  (define dependencies
    (append-map
     buildable-inputs
     (filter shared-config? (buildable-inputs buildable))))

  (define input
    (first inputs))

  (define output
    (first outputs))

  (make-build-manifest
   (string-append "TANGLE\t" output)
   (lambda ()
     ($emacs
      `("--quick" "--batch"
        "--load" "ob-tangle"
        "--load" "ob-lob"
        "--eval" "(setopt org-babel-load-languages '((shell . t)))"
        "--eval" "(setopt org-confirm-babel-evaluate nil)"
        ,@(append-map
           (lambda (file)
             (list "--eval" (format #f "(org-babel-lob-ingest ~s)" file)))
           dependencies)
        "--eval" ,(format #f "(org-babel-tangle-file ~s)" input)))
     ($ `("touch" ,output)))))


;;;
;;; Buildables.
;;;

(define %shared-config-alloy
  (shared-config
   (inputs '("config/shared/alloy.org"))
   (outputs '("tangled/alloy"))))

(define %shared-config-caddy
  (shared-config
   (inputs '("config/shared/caddy.org"))
   (outputs '("tangled/caddy"))))

(define %shared-config-emacs
  (shared-config
   (inputs '("config/shared/emacs.org"))
   (outputs '("tangled/emacs"))))

(define %systems
  `(("dorphine" #:fork? #t #:dependencies ,(list %shared-config-alloy
                                                 %shared-config-emacs))
    ("chapra"   #:fork? #t #:dependencies ,(list %shared-config-alloy))
    ("ignamma"             #:dependencies ,(list %shared-config-alloy))
    ("nuporta"  #:fork? #t #:dependencies ,(list %shared-config-alloy
                                                 %shared-config-caddy))
    ("mirror"              #:dependencies ,(list %shared-config-alloy
                                                 %shared-config-caddy))
    ("worker")))

(define %images
  '("minimal"
    "niri"))

(define* (system-config-for name #:key (dependencies '()) #:allow-other-keys)
  (let ((input (string-append "config/" name ".org"))
        (output (string-append "tangled/" name)))
    (system-config
     (inputs (cons input dependencies))
     (outputs (list output)))))

(define (systems-from-arguments arguments)
  "Select %systems from ARGUMENTS, select all if no argument is provided."
  (if (null? arguments)
      %systems
      (filter (lambda (system)
                (member (first system) arguments))
              %systems)))

(define (images-from-arguments arguments)
  "Select %images from ARGUMENTS, select all if no argument is provided."
  (if (null? arguments)
      %images
      (filter (cut member <> arguments) %images)))


;;;
;;; Commands.
;;;

(define-command (update-command arguments)
  ((invoke "update")
   (category 'development)
   (synopsis "Update channels.lock to latest channel revisions"))
  ($guix `("repl" "--" "scripts/describe.scm") #:channels "channels.scm"))

(define-command (serve-command arguments)
  ((invoke "serve")
   (category 'development)
   (synopsis "Start nREPL server for emacs-arei")
   (help "
Start nREPL server for emacs-arei, also compile Guix when its git submodule is \
checked out."))
  ;; Update Citre tags.
  (let ((citre-tags-file "/home/hako/.cache/tags/!home!hako!Testament!.tags"))
    (when (file-exists? citre-tags-file)
      ($emacs `("--quick" "--batch"
                "--load" "citre-ctags"
                "--eval"
                ,(format #f "(citre-update-tags-file ~s)" citre-tags-file)))))
  (let ((pre-inst-env? (file-exists? "channels/guix/bootstrap")))
    ;; Compile Guix.
    (when pre-inst-env?
      (with-directory-excursion "channels/guix"
        ($ '("./bootstrap"))
        ($ '("./configure"))
        ($ '("make" "-j8"))))
    ;; Start nREPL server.
    ($guix `("shell" "guile" "guile-ares-rs" "--"
             ,@(if pre-inst-env?
                   '("./pre-inst-env")
                   '())
             "guile" "-c"
             ,(call-with-output-string
                (cut write
                     '(begin
                        (use-modules (ares server)
                                     ;; Load reader extensions.
                                     (guix gexp))
                        (run-nrepl-server))
                     <>))))))

(define-command (build-os-command arguments)
  ((invoke "build-os")
   (category 'deployment)
   (synopsis "Build Guix System")
   (help "[SYSTEMS] ...
Build all Guix Systems in this repository or only those matching SYSTEMS."))
  (for-each
   (match-lambda
     ((name . args)
      (let ((config (string-append "tangled/" name "/" name ".scm")))
        (print-header "BUILD OS" name)
        (apply $guix `("system" "build" ,config ,@%build-options) args))))
   (remove
    (lambda (system)
      (member (first system) '("mirror" "worker")))
    (systems-from-arguments arguments))))

(define-command (deploy-os-command arguments)
  ((invoke "deploy-os")
   (category 'deployment)
   (synopsis "Deploy Guix System")
   (help "[SYSTEMS] ...
Deploy all Guix Systems in this repository or only those matching SYSTEMS."))
  (for-each
   (match-lambda
     ((name . args)
      (let ((config (string-append "deploy/" name ".scm")))
        (print-header "DEPLOY OS" name)
        (apply $guix
               `("deploy" ,config
                 ,@(if #%?CMD
                       `(,@%build-options "-x" "--" "sh" "--login" "-c" ,#%?CMD)
                       %build-options))
               args))))
   (systems-from-arguments arguments)))

(define-command (build-iso-command arguments)
  ((invoke "build-iso")
   (category 'deployment)
   (synopsis "Build LiveCD")
   (help "[VARIANTS] ...
Build all Guix System LiveCDs in this repository or only those matching \
VARIANTS, saving the results under dist/."))
  (for-each
   (lambda (variant)
     (let ((config (string-append "config/live/" variant ".scm"))
           (iso (format #f "rosenthal-~a-~a.~a.iso"
                        variant
                        (date->string (current-date) "~Y~m~d")
                        (%current-system))))
       (print-header "BUILD ISO" iso)
       ($guix `("repl" "--" "scripts/build-image.scm" ,(in-vicinity "dist" iso)
                ,config
                "--image-type=iso9660"
                "--load-path=modules/installer"
                ,@%build-options)
              #:channels "config/live/channels.lock")))
   (images-from-arguments arguments)))


;;;
;;; Entry point.
;;;

(blueprint
 (configuration
  (configuration
   (variables
    (list (variable
           (name "CMD")
           (value (delay #f))
           (hint "Deployment command for 'guix deploy'"))
          (variable
           (name "URL")
           (value (delay
                    (string-join
                     '("https://cache-cdn.guix.moe"
                       "https://mirror.sjtu.edu.cn/guix"
                       "https://mirror.sjtu.edu.cn/guix-bordeaux"))))
           (hint "Substitute URLs"))))))
 (buildables
  (map (cut apply system-config-for <>) %systems))
 (commands
  (list update-command
        serve-command
        build-os-command
        deploy-os-command
        build-iso-command)))
