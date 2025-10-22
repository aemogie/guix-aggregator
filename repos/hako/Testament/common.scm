;;; SPDX-FileCopyrightText: 2023, 2024, 2025 Hilton Chain <hako@ultrarare.space>
;;;
;;; SPDX-License-Identifier: GPL-3.0-or-later

(use-modules (srfi srfi-1)
             (srfi srfi-26)
             (ice-9 match)
             (ice-9 popen)
             (ice-9 textual-ports)
             (guix diagnostics)
             (guix i18n)
             (guix store)
             (nonguix transformations)
             (rosenthal)
             (sops secrets))

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

(define %guix-authorized-key-bocis
  (plain-file "bocis.pub" "
(public-key
 (ecc
  (curve Ed25519)
  (q #4048CC570B57B6399A8F561B1EC624C3BE5E1465175AD568AADC3F3DFB1B5A8A#)))"))

(define %guix-authorized-key-ignamma
  (plain-file "ignamma.pub" "
(public-key
 (ecc
  (curve Ed25519)
  (q #6FEEB15C4363F9975EB15C908EC911A4362E486DA642431FA2438C0B1C3D55F5#)))"))

(define %guix-authorized-key-workers-hako
  (plain-file "workers-hako.pub" "
(public-key
 (ecc
  (curve Ed25519)
  (q #7927EA1162184C1FAA62D20C111121A4604F00956E69F0FEB89EEE1721647897#)))"))

(define %guix-authorized-key-workers-poesty
  (plain-file "workers-poesty.pub" "
(public-key
 (ecc
  (curve Ed25519)
  (q #8C4662FA0BC955B33261EEA5AA15F33081A7BEC991E5F990F7382F0988459B37#)))"))

(define %hako-guix-authorized-keys-lan
  (list %guix-authorized-key-dorphine
        %guix-authorized-key-gokuraku

        %guix-authorized-key-bocis
        %guix-authorized-key-ignamma))

(define %hako-guix-authorized-keys-head
  (list %guix-authorized-key-dorphine
        %guix-authorized-key-gokuraku

        %guix-authorized-key-bocis
        %guix-authorized-key-ignamma

        %guix-authorized-key-workers-hako
        %guix-authorized-key-workers-poesty))


(define %ssh-key-deploy
  (plain-file "deploy.pub"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMLWIp8y5/JGBaw+yFA5MFB5nlFpEx/tjc0q0Ij9KjTu\n"))

(define %ssh-key-hako
  (plain-file "hako.pub"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFcTj1N3cL/bh2Uvwh5/YubhZplPFnvGk/iVHQs3FWV2\n"))


;; Source: <https://wiki.archlinux.org/title/XDG_Base_Directory>
(define %testament-xdg-base-directory-env-vars
  '(;; bash
    ("HISTFILE" . "$XDG_STATE_HOME/bash/history")
    ;; docker
    ("DOCKER_CONFIG" . "$XDG_CONFIG_HOME/docker")
    ;; gdb
    ("GDBHISTFILE" . "$XDG_STATE_HOME/gdb/history")
    ;; go
    ("GOMODCACHE" . "$XDG_CACHE_HOME/go/mod")
    ("GOPATH" . "$XDG_DATA_HOME/go")
    ;; gradle
    ("GRADLE_USER_HOME" . "$XDG_DATA_HOME/gradle")
    ;; guile
    ("GUILE_HISTORY" . "$XDG_STATE_HOME/guile/history")
    ;; java
    ("_JAVA_OPTIONS" . "-Djava.util.prefs.userRoot=$XDG_CONFIG_HOME/java")
    ;; luanti
    ("MINETEST_USER_PATH" . "$XDG_DATA_HOME/luanti")
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

(define %xdg-data-home
  (or (getenv "XDG_DATA_HOME")
      (in-vicinity (getenv "HOME") ".local/share")))


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


(define %network-manager-ipv6-privacy
  `("ip6-privacy.conf"
    ,(plain-file "ip6-privacy.conf" "\
# Use IPv6 Privacy Extensions.
[connection]
ipv6.ip6-privacy=2\n")))

;; NOTE: When using on cloud machines, refer to the terms of the provider
;; first.
(define %network-manager-random-mac-address
  `("rand_mac.conf"
   ,(plain-file "rand_mac.conf" "\
# Generate a random MAC for each network connection and associate the two
# permanently.
[connection-mac-randomization]
ethernet.cloned-mac-address=stable
wifi.cloned-mac-address=stable\n")))


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

(define (sops-str file key)
  (get-sops-secret key #:file file))

(define (sops-num file key)
  (get-sops-secret key #:file file #:number? #t))

(define chapra.yaml
  (local-file (testament-plain "chapra.yaml")))
(define dorphine.yaml
  (local-file (testament-plain "dorphine.yaml")))
(define gokuraku.yaml
  (local-file (testament-plain "gokuraku.yaml")))
(define rakuen.yaml
  (local-file (testament-plain "rakuen.yaml")))
