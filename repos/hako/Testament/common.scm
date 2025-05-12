;;; SPDX-FileCopyrightText: 2023, 2024, 2025 Hilton Chain <hako@ultrarare.space>
;;;
;;; SPDX-License-Identifier: GPL-3.0-or-later

(use-modules (srfi srfi-26)
             (ice-9 popen)
             (ice-9 textual-ports)
             (guix channels)
             (guix diagnostics)
             (guix gexp)
             (guix i18n)
             ((guix licenses) #:prefix license:)
             (guix packages)
             (guix store)
             (guix utils)
             (sops secrets)
             (guix download)
             (guix git-download)
             (guix build-system emacs)
             (gnu packages emacs-xyz)
             (gnu packages video)
             (nongnu packages video)
             (rosenthal packages rust-apps))
;;;
;;; Common
;;;

(define testament-path
  (getcwd))

(define (testament-find-file name)
  "Find file NAME under \"files/plain\" directory (fallback to \"files/blobs\")
of Testament repository.  Return file path as a string, or #f when not found."
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


;;;
;;; Channels
;;;

(define %channel-guix
  (channel
   (inherit %default-guix-channel)
   (url "https://git.boiledscript.com/mirror/guix.git")))

(define %channel-guixcn
  (channel
   (name 'guixcn)
   (url "https://github.com/guixcn/guix-channel.git")
   (introduction
    (make-channel-introduction
     "993d200265630e9c408028a022f32f34acacdf29"
     (openpgp-fingerprint
      "7EBE A494 60CE 5E2C 0875  7FDB 3B5A A993 E1A2 DFF0")))))

(define %channel-nonguix
  (channel
   (name 'nonguix)
   (url "https://git.boiledscript.com/mirror/nonguix.git")
   (introduction
    (make-channel-introduction
     "897c1a470da759236cc11798f4e0a5f7d4d59fbc"
     (openpgp-fingerprint
      "2A39 3FFF 68F4 EF7A 3D29  12AF 6F51 20A0 22FB B2D5")))))

(define %channel-rosenthal
  (channel
   (name 'rosenthal)
   (url "https://git.boiledscript.com/hako/Rosenthal.git")
   (branch "trunk")
   (introduction
    (make-channel-introduction
     "7677db76330121a901604dfbad19077893865f35"
     (openpgp-fingerprint
      "13E7 6CD6 E649 C28C 3385  4DF5 5E5A A665 6149 17F7")))))

(define %channel-sops-guix
  (channel
   (name 'sops-guix)
   (url "https://github.com/fishinthecalculator/sops-guix")
   (branch "main")
   (introduction
    (make-channel-introduction
     "0bbaf1fdd25266c7df790f65640aaa01e6d2dbc9"
     (openpgp-fingerprint
      "8D10 60B9 6BB8 292E 829B  7249 AED4 1CC1 93B7 01E2")))))


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


;;;
;;; Packages
;;;

(define emacs-nftables-mode
  (package
    (name "emacs-nftables-mode")
    (version "1.1")
    (source
     (origin
       (method url-fetch)
       (uri (string-append "https://elpa.gnu.org/packages/nftables-mode-"
                           version ".tar"))
       (sha256
        (base32 "1wjw6n60kj84j8gj62mr6s97xd0aqvr4v7npyxwmhckw9z13xcqv"))))
    (build-system emacs-build-system)
    (home-page "https://elpa.gnu.org/packages/nftables-mode.html")
    (synopsis "Major mode for editing nftables scripts")
    (description
     "@code{nftables-mode} is an Emacs major mode for editing nftables scripts.
It currently only offers basic highlighting and primitive indentation.")
    (license license:gpl3+)))

(define emacs-treesit-auto
  (package
    (name "emacs-treesit-auto")
    ;; NOTE: Not tagged, also change commit when updating.
    (version "1.0.7")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/renzmann/treesit-auto")
             (commit "016bd286a1ba4628f833a626f8b9d497882ecdf3")))
       (file-name (git-file-name name version))
       (sha256
        (base32 "03bvam7cpxqp4idhd235n76qdqhsbgw7m2lphy8qqwslbmcq23m4"))))
    (build-system emacs-build-system)
    (home-page "https://github.com/renzmann/treesit-auto")
    (synopsis "Automatically use tree-sitter major modes")
    (description
     "@code{treesit-auto} is an Emacs package for automatically using tree-sitter
major modes and falling back to the original major mode when its tree-sitter
counterpart is unavailable.")
    (license license:gpl3+)))

(define mpv/dolly
  (package
    (inherit mpv)
    (propagated-inputs '())
    (inputs
     (modify-inputs
         (append (package-propagated-inputs mpv)
                 (package-inputs mpv))
       (prepend nv-codec-headers)))))
