;;; SPDX-License-Identifier: GPL-3.0-or-later
;;; Copyright © 2026 Hilton Chain <hako@ultrarare.space>

;;; Configuration for maak, use direnv for environment setup.
;;; Example usage: `maak update-channels'.

(define-module (maak)
  #:use-module (srfi srfi-1)
  #:use-module (srfi srfi-19)
  #:use-module (srfi srfi-26)
  #:use-module (ice-9 textual-ports)
  #:use-module (guix utils)
  #:use-module (guix build utils))


;;;
;;; Variables.
;;;

(define %substitute-urls
  (string-append
   "--substitute-urls="
   ;; NOTE: Sort by download speed and substitutes availablity
   ;; Adding too many URLs will affect performance.
   (string-join
    '("https://cache-cdn.guix.moe"
      "https://mirror.sjtu.edu.cn/guix"
      "https://mirror.sjtu.edu.cn/guix-bordeaux"))))

(define %build-options
  `("--keep-going"
    "--verbosity=1"
    "--load-path=modules/config"
    ,%substitute-urls))

(define %deploy-command
  (getenv "CMD"))

(define %livecd-system
  (or (getenv "SYSTEM")
      (%current-system)))


;;;
;;; Procedures.
;;;

;; XXX: The built-in ‘with-output-to-string’ doesn't work with ‘spawn’.
(define (with-output-to-string* thunk)
  (let* ((port (mkstemp "/tmp/testament-XXXXXX"))
         (file (port-filename port))
         (output
          (and (with-output-to-file file thunk)
               (call-with-input-file file get-string-all))))
    (close port)
    (delete-file file)
    (string-trim-both output)))

(define ($ cmd)
  (let* ((pid (spawn (car cmd) cmd))
         (exit-val (cdr (waitpid pid))))
    (or (zero? exit-val)
        (error (format #f "Command ~s exited with non-zero exit status: ~s"
                       (string-join cmd) exit-val)))))

(define* ($guix args #:key local? (channels "channels.lock"))
  (if local?
      ($ `("./pre-inst-env" "guix" ,@args))
      ($ `("guix" "time-machine" "-C" ,channels ,%substitute-urls "--" ,@args))))

(define ($emacs args)
  ($guix `("shell" "emacs-minimal" "--" "emacs" ,@args)))


(define* (%.org->%.scm name #:optional dependencies)
  (let ((file.org (string-append "config/" name ".org"))
        (tangled-file (string-append "files/tangled/" name))
        (dependencies.org
         (map (cut string-append "config/shared/" <> ".org")
              (or dependencies '())))
        (tangled-dependencies
         (map (cut string-append "files/tangled/" <>)
              (or dependencies '()))))
    (for-each (lambda (file)
                (when (file-exists? file)
                  (delete-file-recursively file)))
              (cons tangled-file
                    tangled-dependencies))
    ($emacs `("-quick" "-batch"
              "--load" "ob-tangle"
              "--load" "ob-lob"
              "--eval" "(setopt org-babel-load-languages '((shell . t)))"
              "--eval" "(setopt org-confirm-babel-evaluate nil)"
              ,@(append-map
                 (lambda (file)
                   (list "--eval" (format #f "(org-babel-lob-ingest ~s)" file)))
                 dependencies.org)
              ,@(append-map
                 (lambda (file)
                   (list "--eval" (format #f "(org-babel-tangle-file ~s)" file)))
                 (cons file.org
                       dependencies.org))))
    (string-append tangled-file "/" name ".scm")))


(define* (build-% system #:key deps local?)
  (let ((config (%.org->%.scm system deps)))
    ($guix `("system" "build" ,config ,@%build-options)
           #:local? local?)))

(define* (deploy-% system #:key deps local?)
  (let* ((config (%.org->%.scm system deps))
         (deploy (in-vicinity "files/deploy" (basename config))))
    ($guix `("deploy" ,deploy
             ,@(if %deploy-command
                   `(,@%build-options "-x" "--" "sh" "--login" "-c" ,%deploy-command)
                   %build-options))
           #:local? local?)))

(define (live-% variant)
  (let ((src
         (with-output-to-string*
          (lambda ()
            ($guix `("system" "image"
                     ,(format #f "config/live/~a.scm" variant)
                     "--image-type=iso9660"
                     "--load-path=modules/installer"
                     "-s" ,%livecd-system
                     ,@%build-options)))))
        (dst
         (in-vicinity "dist"
                      (format #f "rosenthal-~a-~a.~a.iso"
                              variant
                              (date->string (current-date) "~Y~m~d")
                              %livecd-system))))
    (and (copy-file src dst)
         (make-file-writable dst))))


;;;
;;; Targets.
;;;

(define (authenticate)
  ($guix `("git" "authenticate"
           "c5d46fdfdfbc84fe413f1d930049d1f703f9a0ff"
           "F4C2 D1DF 3FDE EA63 D1D3  0776 ACC6 6D09 CA52 8292")))

(define (update-channels)
  (with-atomic-file-output "channels.lock"
    (cut with-output-to-port <>
         (lambda ()
           ($guix `("describe" "--format=channels")
                  #:channels "channels.scm")))))

(define (pull)
  ($guix `("pull" "--channels=channels.lock" ,%substitute-urls)))

(define (build-dorphine) (build-% "dorphine" #:local? #t #:deps '("emacs")))
(define (build-chapra)   (build-% "chapra"   #:local? #t))
(define (build-ignamma)  (build-% "ignamma"))
(define (build-nuporta)  (build-% "nuporta"  #:local? #t))
(define (build)
  (build-dorphine)
  (build-chapra)
  (build-ignamma)
  (build-nuporta))

(define (deploy-dorphine) (deploy-% "dorphine" #:local? #t #:deps '("emacs")))
(define (deploy-chapra)   (deploy-% "chapra"   #:local? #t))
(define (deploy-ignamma)  (deploy-% "ignamma"))
(define (deploy-nuporta)  (deploy-% "nuporta"  #:local? #t))
(define (deploy-mirror)   (deploy-% "mirror"))
(define (deploy-worker)   (deploy-% "worker"))
(define (deploy)
  (deploy-dorphine)
  (deploy-chapra)
  (deploy-ignamma)
  (deploy-nuporta))

(define (live-minimal) (live-% "minimal"))
(define (live-niri)    (live-% "niri"))
(define (live)
  (live-minimal)
  (live-niri))
