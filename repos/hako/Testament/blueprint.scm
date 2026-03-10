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

(define* ($guix args #:key local? (channels "channels.lock") #:allow-other-keys)
  (if local?
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
  (make-build-manifest
   (string-append "TANGLE\t" (first outputs))
   (lambda ()
     ($emacs
      `("--quick" "--batch"
        "--load" "ob-tangle"
        "--eval" "(setopt org-babel-load-languages '((shell . t)))"
        "--eval" "(setopt org-confirm-babel-evaluate nil)"
        "--eval" ,(format #f "(org-babel-tangle-file ~s)" (first inputs)))))))

(define-method (ask-build-manifest (buildable <system-config>)
                                   (inputs <list>)
                                   (outputs <list>))
  ;; Add <shared-config> dependencies to Library of Babel.
  (define dependencies
    (append-map
     buildable-inputs
     (filter shared-config? (buildable-inputs buildable))))

  (make-build-manifest
   (string-append "TANGLE\t" (first outputs))
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
        "--eval" ,(format #f "(org-babel-tangle-file ~s)" (first inputs)))))))


;;;
;;; Buildables.
;;;

(define %shared-config-emacs
  (shared-config
   (inputs '("config/shared/emacs.org"))
   (outputs '("files/tangled/emacs"))))

(define %systems
  `(("dorphine" #:local? #t #:dependencies (,%shared-config-emacs))
    ("chapra"   #:local? #t)
    ("ignamma")
    ("nuporta"  #:local? #t)
    ("mirror")
    ("worker")))

(define %images
  '("minimal"
    "niri"))

(define* (system-config-for name #:key (dependencies '()) #:allow-other-keys)
  (let ((input (string-append "config/" name ".org"))
        (output (string-append "files/tangled/" name)))
    (system-config
     (inputs (cons input dependencies))
     (outputs (list output)))))

(define (systems-from-arguments arguments)
  "Select %systems from ARGUMENTS, select all if no argument is provided."
  (if (null? arguments)
      %systems
      (filter-map
       (lambda (argument)
         (find (lambda (system)
                 (string=? argument (first system)))
               %systems))
       arguments)))

(define (images-from-arguments arguments)
  "Select %images from ARGUMENTS, select all if no argument is provided."
  (if (null? arguments)
      %images
      (filter (cut member <> %images) arguments)))


;;;
;;; Commands.
;;;

(define-command (authenticate-command arguments)
  ((invoke "authenticate")
   (category 'dispatch))
  ($guix `("git" "authenticate"
           "c5d46fdfdfbc84fe413f1d930049d1f703f9a0ff"
           "F4C2 D1DF 3FDE EA63 D1D3  0776 ACC6 6D09 CA52 8292")))

(define-command (update-channels-command arguments)
  ((invoke "update-channels")
   (category 'dispatch))
  ($guix `("repl" "--" "scripts/describe.scm") #:channels "channels.scm"))

(define-command (pull-command arguments)
  ((invoke "pull")
   (category 'dispatch))
  ($guix `("pull" "--channels=channels.lock" ,%substitute-urls)))

(define-command (ares-command arguments)
  ((invoke "ares")
   (category 'dispatch))
  ($guix `("shell" "guile" "guile-ares-rs" "--"
           "guile" "-c"
           ,(call-with-output-string
              (cut write
                   '(begin
                      (use-modules (ares server)
                                   ;; Load reader extensions.
                                   (guix gexp))
                      (run-nrepl-server))
                   <>)))))

(define-command (build-os-command arguments)
  ((invoke "build-os")
   (category 'deploy))
  (for-each
   (match-lambda
     ((name . args)
      (let ((config (string-append "files/tangled/" name "/" name ".scm")))
        (print-header "BUILD OS" name)
        (apply $guix `("system" "build" ,config ,@%build-options) args))))
   (remove
    (lambda (system)
      (member (first system) '("mirror" "worker")))
    (systems-from-arguments arguments))))

(define-command (deploy-os-command arguments)
  ((invoke "deploy-os")
   (category 'deploy))
  (for-each
   (match-lambda
     ((name . args)
      (let ((config (string-append "files/deploy/" name ".scm")))
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
   (category 'deploy))
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
  (cons* %shared-config-emacs
         (map (cut apply system-config-for <>) %systems)))
 (commands
  (list authenticate-command
        update-channels-command
        pull-command
        ares-command

        build-os-command
        deploy-os-command
        build-iso-command)))
