;;; SPDX-FileCopyrightText: 2023, 2024, 2025 Hilton Chain <hako@ultrarare.space>
;;;
;;; SPDX-License-Identifier: GPL-3.0-or-later

(use-modules (srfi srfi-1)
             (srfi srfi-26)
             (ice-9 match)
             (ice-9 popen)
             (ice-9 textual-ports)
             (guix diagnostics)
             (guix gexp)
             (guix i18n)
             (guix store)
             (nonguix transformations)
             (rosenthal utils file)
             (rosenthal utils packages)
             (rosenthal utils transformations)
             (sops secrets)

             (gnu)
             (gnu services guix)
             (gnu services shepherd)
             (gnu home)
             (gnu home services)
             (gnu home services shepherd))

;;;
;;; Common
;;;

(define testament-path
  (getcwd))

(define (testament-blobs . name)
  (let ((blobs (in-vicinity testament-path "files/blobs")))
    (match name
      (()
       (local-file blobs #:recursive? #t))
      ((file)
       (or (search-path (list blobs) file)
           (leave (G_ "file '~a' not found.~%") file))))))

(define (testament-plain . name)
  (let ((plain (in-vicinity testament-path "files/plain")))
    (match name
      (()
       (local-file plain #:recursive? #t))
      ((file)
       (or (search-path (list plain) file)
           (leave (G_ "file '~a' not found.~%") file))))))

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


;;;
;;; Keys
;;;

(define %guix-authorized-key-dorphine
  (plain-file "dorphine.pub" "
(public-key
 (ecc
  (curve Ed25519)
  (q #A279175682D0DAE3E11268E67E1F3FA47C38D7E509F7725567CF891E248E719F#)))"))

(define %guix-authorized-key-gokuraku
  (plain-file "gokuraku.pub" "
(public-key
 (ecc
  (curve Ed25519)
  (q #374EC58F5F2EC0412431723AF2D527AD626B049D657B5633AAAEBC694F3E33F9#)))"))


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
