;;; SPDX-License-Identifier: GPL-3.0-or-later
;;; Copyright © 2026 Hilton Chain <hako@ultrarare.space>

(use-modules (ice-9 format)
             (ice-9 match)
             (srfi srfi-1)
             (srfi srfi-19)
             (blue build)
             (blue states)
             (blue subprocess)
             (blue types)
             (blue types blueprint)
             (blue types buildable)
             (blue types command)
             (blue types configuration)
             (blue types variable)
             (guix records)
             (guix utils)
             ((guix build utils) #:select (delete-file-recursively)))


;;;
;;; Helpers.
;;;

(define-syntax %substitute-urls
  (identifier-syntax (guix-substitute-urls #%?URL)))

(define-syntax %build-options
  (identifier-syntax (guix-build-options)))

(define (guix-substitute-urls urls)
  (string-append "--substitute-urls=" urls))

(define (guix-build-options)
  `("--keep-failed"
    "--keep-going"
    "--verbosity=1"
    "--load-path=modules"
    ,%substitute-urls))

(define ($ cmd)
  (match cmd
    ((prog . args)
     (let ((exit-val (popen prog args)))
       (zero? exit-val)))))

(define* ($guix args #:key use-guix-fork? (channels "channels.lock")
                #:allow-other-keys)
  (if (getenv "GUIX")                   ;Using pre-inst-env.
      ($ `("guix" ,@args))
      ($ `("guix" "time-machine" ,%substitute-urls
           "-C" ,@(if use-guix-fork?
                      '("channels-fork.lock" "--disable-authentication")
                      (list channels))
           "--" ,@args))))

(define ($emacs args)
  ($guix `("shell" "--pure" "emacs-minimal" "git-minimal" "--" "emacs" ,@args)))


(define (build-header action target)
  (format #f "~a~/~a" action target))
(define (print-header action target)
  (format (current-output-port) "~/~a~%" (build-header action target)))

(define (config-source name)
  (format #f "config/~a.org" name))
(define (config-output name)
  (format #f "tangled/~a" (basename name)))
(define (config-path name)
  (format #f "tangled/~a/~a.scm" name name))
(define (config-deploy name)
  (format #f "deploy/~a.scm" name))

(define (image-source name)
  (format #f "config/live/~a.scm" name))
(define (image-name variant)
  (format #f "rosenthal-~a-~a.~a.iso"
          variant
          (date->string (current-date) "~Y~m~d")
          (%current-system)))


;;;
;;; Classes.
;;;

(define-blue-class <literate-buildable>
  (inherit <buildable>)
  (constructor literate-buildable)
  (predicate literate-buildable?)
  (fields
   (source
    (getter literate-buildable-source))))

(define-blue-method (clean! (this <literate-buildable>))
  (define (%clean file)
    (when (file-exists? file)
      (print-header "RM" file)
      (unless (dry-build?)
        (delete-file-recursively file))))

  (for-each clean! (ask-inputs this))
  (for-each clean! (ask-requirements this))
  (let ((files (ask-outputs this)))
    (for-each
     (match-lambda
       ((? string? file)
        (%clean file))
       ((name . file)
        (%clean file))
       (_ #f))
     files)))

(define-blue-method (ask-build-manifest (this <literate-buildable>)
                                        (_ <list>)
                                        (output <string>))
  (define source
    (literate-buildable-source this))

  (define library-of-babel
    (map literate-buildable-source
         (filter literate-buildable? (ask-inputs this))))

  (make-build-manifest
   (build-header "TANGLE" output)
   (lambda ()
     ($emacs
      `("--quick" "--batch"
        "--load" "ob-tangle"
        "--load" "ob-lob"
        "--eval" "(setopt org-babel-load-languages '((shell . t)))"
        "--eval" "(setopt org-confirm-babel-evaluate nil)"
        "--eval" "(setopt org-id-track-globally nil)"
        ,@(append-map
           (lambda (dependency)
             (list "--eval" (format #f "(org-babel-lob-ingest ~s)" dependency)))
           library-of-babel)
        "--eval" ,(format #f "(org-babel-tangle-file ~s)" source)))
     ($ `("touch" ,output)))))


;;;
;;; Buildables.
;;;

(define-record-type* <literate-config>
  literate-config
  make-literate-config
  literate-config?
  this-literate-config
  (name           literate-config-name)
  (build?         literate-config-build?
                  (default #t))
  (deploy?        literate-config-deploy?
                  (default #t))
  (use-guix-fork? literate-config-use-guix-fork?
                  (default #f))
  (dependencies   literate-config-dependencies
                  (default '())))

(define literate-config->buildable
  (match-record-lambda <literate-config>
      (name build? deploy? use-guix-fork? dependencies)
    (literate-buildable
     (source (config-source name))
     (inputs dependencies)
     (outputs (config-output name)))))

(define %shared-config-caddy
  (literate-config->buildable
   (literate-config
    (name "shared/caddy"))))
(define %shared-config-emacs
  (literate-config->buildable
   (literate-config
    (name "shared/emacs"))))

(define %systems
  (list (literate-config
         (name "ignamma"))
        (literate-config
         (name "involemi")
         (dependencies
          (list %shared-config-caddy)))
        (literate-config
         (name "worker")
         (build? #f))
        (literate-config
         (name "chapra")
         (use-guix-fork? #t)
         (dependencies
          (list %shared-config-caddy)))
        (literate-config
         (name "dorphine")
         (use-guix-fork? #t)
         (dependencies
          (list %shared-config-emacs)))
        (literate-config
         (name "nuporta")
         (use-guix-fork? #t))
        (literate-config
         (name "mirror")
         (build? #f)
         (dependencies
          (list %shared-config-caddy)))))

(define %images
  '("minimal"
    "niri"))

(define (systems-from-arguments arguments)
  "Select %systems from ARGUMENTS, select all if no argument is provided."
  (if (null? arguments)
      %systems
      (filter (lambda (system)
                (member (literate-config-name system) arguments))
              %systems)))

(define (images-from-arguments arguments)
  "Select %images from ARGUMENTS, select all if no argument is provided."
  (if (null? arguments)
      %images
      (filter (lambda (image)
                (member image arguments))
              %images)))


;;;
;;; Commands.
;;;

(define-command (update-command arguments)
  ((invoke "update")
   (category 'development)
   (synopsis "Update channels.lock to latest channel revisions"))
  ($guix `("repl" "--" "scripts/write-channels.scm")
         #:channels "channels.scm"))

(define-command (build-os-command arguments)
  ((invoke "build-os")
   (category 'deployment)
   (synopsis "Build Guix System")
   (help "[SYSTEMS] ...
Build all Guix Systems in this repository or only those matching SYSTEMS."))
  (every identity
         (map-in-order
          (match-record-lambda <literate-config>
              (name use-guix-fork?)
            (print-header "BUILD OS" name)
            ($guix `("system" "build" ,(config-path name)
                     ,@(if (dry-build?) '("--dry-run") '())
                     ,@%build-options)
                   #:use-guix-fork? use-guix-fork?))
          (filter literate-config-build?
                  (systems-from-arguments arguments)))))

(define-command (deploy-os-command arguments)
  ((invoke "deploy-os")
   (category 'deployment)
   (synopsis "Deploy Guix System")
   (help "[SYSTEMS] ...
Deploy all Guix Systems in this repository or only those matching SYSTEMS."))
  (every identity
         (map-in-order
          (match-record-lambda <literate-config>
              (name use-guix-fork?)
            (print-header "DEPLOY OS" name)
            ($guix `("deploy" ,(config-deploy name)
                     ,@(if (dry-build?) '("--dry-run") '())
                     ,@(if #%?CMD
                           `(,@%build-options "-x" "--" "sh" "--login" "-c" ,#%?CMD)
                           %build-options))
                   #:use-guix-fork? use-guix-fork?))
          (filter literate-config-deploy?
                  (systems-from-arguments arguments)))))

(define-command (build-iso-command arguments)
  ((invoke "build-iso")
   (category 'deployment)
   (synopsis "Build Live ISO")
   (help "[VARIANTS] ...
Build all Guix System Live ISOs in this repository or only those matching \
VARIANTS, saving the results under dist/."))
  (every identity
         (map-in-order
          (lambda (variant)
            (let ((iso (in-vicinity "dist" (image-name variant))))
              (print-header "BUILD ISO" iso)
              ($guix `("repl" "--" "scripts/build-image.scm" ,iso ,(image-source variant)
                       ,@(if (dry-build?) '("--dry-run") '())
                       "--image-type=iso9660"
                       "--load-path=config/live/modules"
                       ,@%build-options)
                     #:channels "config/live/channels.lock")))
          (images-from-arguments arguments))))


;;;
;;; Entry point.
;;;

(blueprint
  (configuration
   (configuration
     (variables
      (list (variable
              (name "CMD")
              (value #f)
              (hint "Deployment command for 'guix deploy'"))
            (variable
              (name "URL")
              (value "https://bordeaux.guix.gnu.org https://ci.guix.gnu.org")
              (hint "Substitute server URLs"))))))
  (buildables
   (map literate-config->buildable %systems))
  (commands
   (list update-command
         build-os-command
         deploy-os-command
         build-iso-command)))
