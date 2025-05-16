;;; SPDX-FileCopyrightText: 2023, 2024, 2025 Hilton Chain <hako@ultrarare.space>
;;;
;;; SPDX-License-Identifier: GPL-3.0-or-later

(use-modules (srfi srfi-26)
             (ice-9 popen)
             (ice-9 textual-ports)
             (sops secrets)
             (guix diagnostics)
             (guix gexp)
             (guix i18n)
             ((guix licenses) #:prefix license:)
             (guix packages)
             (guix store)
             (guix utils)
             (gnu packages))
;;;
;;; Common
;;;

(define (testament-find-file name)
  "Find file NAME under \"files/plain\" directory (fallback to \"files/blobs\")
of Testament repository.  Return file path as a string, or #f when not found."
  (define testament-path (getcwd))

  (or (search-path
       (map (cut in-vicinity testament-path <>)
            '("files/plain" "files/blobs"))
       name)
      (leave (G_ "file '~a' not found.~%") name)))

(define (testament-file-content name)
  "Return a string, the content of file NAME to be found by
'testament-find-file'."
  (call-with-input-file (testament-find-file name)
    get-string-all))

(define (testament-file-object name)
  "Similar to 'testament-file-content' but return a file-like object."
  (local-file (testament-find-file name)))

(define* (get-sops-secret key #:key file (number? #f))
  "Return a string (or number if NUMBER? is set to #t) of SOPS secret for KEY
stored in FILE.  The result will be publicly available in '/gnu/store', YOU ARE
WARNED."
  (let* ((file-path
          (with-store store
            (run-with-store store
              (lower-object file))))
         (cmd
          (format #f "sops --decrypt --extract '~a' '~a'"
                  (sanitize-sops-key key)
                  file-path))
         (port (open-input-pipe cmd))
         (secret (get-string-all port)))
    (close-pipe port)
    (if number?
        (string->number secret)
        secret)))

(define (delete-package-from-list name lst)
  "Return a copy of package list LST, removing packages named NAME."
  (filter (lambda (pkg)
            (not (string=? name (package-name pkg))))
          lst))

(define (pkg spec)
  (specification->package spec))

(define (pkg+out spec)
  (specification->package+output spec))

(define (pkgs . specs)
  (map specification->package specs))

(define (pkgs+out . specs)
  (specifications->packages specs))



;;;
;;; Keys
;;;


(define %guix-authorized-key-dorphine
  (plain-file "dorphine.pub" "
(public-key
 (ecc
  (curve Ed25519)
  (q #A279175682D0DAE3E11268E67E1F3FA47C38D7E509F7725567CF891E248E719F#)))"))

;; https://substitute.boiledscript.com/signing-key.pub
(define %guix-authorized-key-gokuraku
  (plain-file "gokuraku.pub" "
(public-key
 (ecc
  (curve Ed25519)
  (q #374EC58F5F2EC0412431723AF2D527AD626B049D657B5633AAAEBC694F3E33F9#)))"))

;; https://substitutes.nonguix.org/signing-key.pub
(define %guix-authorized-key-nonguix
  (plain-file "nonguix.pub" "
(public-key
 (ecc
  (curve Ed25519)
  (q #C1FD53E5D4CE971933EC50C9F307AE2171A2D3B52C804642A7A35F84F3A4EA98#)))"))


;;;
;;; Variables
;;;


;; Source: <https://wiki.archlinux.org/title/XDG_Base_Directory>
(define %testament-xdg-base-directory-env-vars
  '(;; bash
    ("HISTFILE" . "$XDG_STATE_HOME/bash/history")
    ;; gdb
    ("GDBHISTFILE" . "$XDG_STATE_HOME/gdb/history")
    ;; go
    ("GOMODCACHE" . "$XDG_CACHE_HOME/go/mod")
    ("GOPATH" . "$XDG_DATA_HOME/go")
    ;; guile
    ("GUILE_HISTORY" . "$XDG_STATE_HOME/guile/history")
    ;; node
    ("NPM_CONFIG_USERCONFIG" . "$XDG_CONFIG_HOME/npm/npmrc")
    ;; nvidia-driver
    ("CUDA_CACHE_PATH" . "$XDG_CACHE_HOME/nv")
    ;; password-store
    ("PASSWORD_STORE_DIR" . "$XDG_DATA_HOME/pass")
    ;; python
    ;; TODO: Python 3.13.
    ("PYTHON_HISTORY" . "$XDG_STATE_HOME/python/history")
    ;; rust
    ("CARGO_HOME" . "$XDG_DATA_HOME/cargo")
    ;; sqlite
    ("SQLITE_HISTORY" . "$XDG_STATE_HOME/sqlite_history")
    ;; wget
    ("WGETRC" . "$XDG_CONFIG_HOME/wgetrc")))
