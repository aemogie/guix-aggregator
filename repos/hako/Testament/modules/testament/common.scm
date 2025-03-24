;;; SPDX-FileCopyrightText: 2023, 2024 Hilton Chain <hako@ultrarare.space>
;;;
;;; SPDX-License-Identifier: GPL-3.0-or-later

(define-module (testament common)
  #:use-module ((ice-9 popen) #:select (open-input-pipe close-pipe))
  #:use-module ((rnrs io ports) #:select (get-string-all))
  #:use-module ((srfi srfi-26) #:select (cut))

  #:use-module ((guix diagnostics) #:select (leave))
  #:use-module (guix gexp)
  #:use-module ((guix i18n) #:select (G_))
  #:use-module ((guix packages) #:select (package-name))
  #:use-module (guix store)
  #:use-module ((sops secrets) #:select (sanitize-sops-key))
  #:export (testament-path
            testament-find-file
            testament-file-content
            testament-file-object

            get-sops-secret

            delete-package-from-list))

(define testament-path
  (getenv "testament_path"))

(define (testament-find-file name)
  "Find file NAME under \"files/plain\" directory (fallback to \"files/blobs\")
of Testament repository.  Return file path as a string, or #f when not found."
  (or (search-path
       (map (cut in-vicinity testament-path <>)
            '("files/plain"
              "files/blobs"))
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
