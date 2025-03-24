;;; SPDX-FileCopyrightText: 2023, 2024 Hilton Chain <hako@ultrarare.space>
;;;
;;; SPDX-License-Identifier: GPL-3.0-or-later

(define-module (testament counter-stop)
  #:use-module (guix channels)
  #:use-module ((guix gexp) #:select (plain-file))
  #:export (%channel-guix
            %channel-guixcn
            %channel-nonguix
            %channel-rosenthal
            %channel-sops-guix

            %guix-authorized-key-dorphine
            %guix-authorized-key-gokuraku
            %guix-authorized-key-nonguix

            %testament-xdg-base-directory-env-vars)
  #:re-export (%default-channels
               %default-guix-channel))


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
