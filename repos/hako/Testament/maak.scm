;;; SPDX-License-Identifier: GPL-3.0-or-later
;;; Copyright © 2026 Hilton Chain <hako@ultrarare.space>

;;; Configuration for maak, use direnv for environment setup.
;;; Example usage: `maak update-channels'.

(define-module (maak)
  #:use-module (srfi srfi-19)
  #:use-module (srfi srfi-26)
  #:use-module (ice-9 textual-ports)
  #:use-module (guix utils)
  #:use-module (guix build utils))


;;;
;;; Variables.
;;;

(define %build-options
  '("--keep-going" "--verbosity=2"))

(define %deploy-command
  (getenv "CMD"))


;;;
;;; Procedures.
;;;

;; XXX: The built-in one doesn't work when using `guix time-machine'.
(define (with-output-to-string thunk)
  (let* ((port (mkstemp "/tmp/rosenthal-XXXXXX"))
         (file (port-filename port))
         (_ (close port)))
    (and (with-output-to-file file thunk)
         (call-with-input-file file get-line))))

(define ($ cmd)
  (let ((exit-code (status:exit-val (apply system* cmd))))
    (or (zero? exit-code)
        (error (format #f "
Non-zero exit code when running!
Command: ~a
Exit code: ~a~%"
                       cmd exit-code)))))

(define* ($guix args #:key local? (channels "channels.lock"))
  (if local?
      ($ `("./pre-inst-env" "guix" ,@args))
      ($ `("guix" "time-machine" ,(string-append "--channels=" channels)
           "--" ,@args))))

(define ($emacs args)
  ($guix `("shell" "emacs-minimal" "--" "emacs" ,@args)))


(define (%.org->%.scm file)
  ($emacs `("-quick" "-batch"
            "--load" "ob-tangle"
            "--eval" "(setopt org-babel-load-languages '((shell . t)))"
            "--eval" "(setopt org-confirm-babel-evaluate nil)"
            "--eval" ,(format #f "(org-babel-tangle-file ~s)"
                              (string-append file ".org"))))
  (string-append file ".scm"))


(define* (build-% system #:key local?)
  ($guix `("system" "build"
           ,(%.org->%.scm (in-vicinity "config" system))
           ,@%build-options)
         #:local? local?))

(define* (deploy-% system #:key local?)
  (let* ((config (%.org->%.scm (in-vicinity "config" system)))
         (deploy (in-vicinity "files/deploy" (basename config))))
    ($guix `("deploy" ,deploy
             ,@(if %deploy-command
                   `(,@%build-options "-x" "--" "sh" "--login" "-c" ,%deploy-command)
                   %build-options))
           #:local? local?)))

(define (live-% variant)
  (let ((src
         (with-output-to-string
           (lambda ()
             ($guix `("system" "image" "--image-type=iso9660"
                      "-L" "modules/installer"
                      ,(format #f "files/plain/live/~a.scm" variant)
                      ,@%build-options)))))
        (dst
         (in-vicinity "dist"
                      (format #f "rosenthal-~a-~a.x86_64-linux.iso"
                              variant
                              (date->string (current-date) "~Y~m~d")))))
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
  ($guix `("pull" "--channels=channels.lock")))

(define (build-dorphine) (build-% "dorphine" #:local? #t))
(define (build-chapra)   (build-% "chapra"   #:local? #t))
(define (build-ignamma)  (build-% "ignamma"))
(define (build-nuporta)  (build-% "nuporta"  #:local? #t))
(define (build)
  (build-dorphine)
  (build-chapra)
  (build-ignamma)
  (build-nuporta))

(define (deploy-dorphine) (deploy-% "dorphine" #:local? #t))
(define (deploy-chapra)   (deploy-% "chapra"   #:local? #t))
(define (deploy-ignamma)  (deploy-% "ignamma"))
(define (deploy-nuporta)  (deploy-% "nuporta"  #:local? #t))
(define (deploy-mirror)   (deploy-% "mirror"))
(define (deploy-worker)   (deploy-% "worker"))
(define (deploy)
  (deploy-dorphine)
  (deploy-chapra)
  (deploy-ignamma)
  (deploy-nuporta)
  (deploy-mirror)
  (deploy-worker))

(define (live-minimal)       (live-% "minimal"))
(define (live-minimal-hidpi) (live-% "minimal-hidpi"))
(define (live-default)       (live-% "default"))
(define (live)
  (live-minimal)
  (live-minimal-hidpi)
  (live-default))
