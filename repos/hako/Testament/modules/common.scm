;;; SPDX-License-Identifier: GPL-3.0-or-later
;;; Copyright © 2023-2026 Hilton Chain <hako@ultrarare.space>

(define-module (common)
  #:use-module (linux)
  ;; Guile builtins
  #:use-module (ice-9 popen)
  #:use-module (ice-9 textual-ports)
  #:use-module (srfi srfi-26)
  ;; Utilities
  #:use-module (guix gexp)
  #:use-module (guix packages)
  #:use-module (guix store)
  #:use-module (guix utils)
  #:use-module (rosenthal utils file)
  ;; Guix origin methods
  #:use-module (guix download)
  #:use-module (guix git-download)
  ;; Guix build systems
  #:use-module (guix build-system trivial)
  ;; Guix packages
  #:use-module (gnu packages admin)
  #:use-module (gnu packages base)
  #:use-module (gnu packages compression)
  #:use-module (gnu packages curl)
  #:use-module (gnu packages file)
  #:use-module (gnu packages file-systems)
  #:use-module (gnu packages gnupg)
  #:use-module (gnu packages linux)
  #:use-module (gnu packages lsof)
  #:use-module (gnu packages ncdu)
  #:use-module (gnu packages ncurses)
  #:use-module (gnu packages password-utils)
  #:use-module (gnu packages rsync)
  #:use-module (gnu packages rust-apps)
  #:use-module (gnu packages ssh)
  #:use-module (gnu packages sync)
  #:use-module (gnu packages version-control)
  #:use-module (gnu packages vim)
  #:use-module (nongnu packages linux)
  #:use-module (rosenthal packages package-management)
  #:export (testament-path
            testament-file

            %sops-chapra
            %sops-dorphine
            %sops-involemi
            %sops-nuporta

            %guix-keys
            %ssh-key-deploy
            %ssh-key-hako
            %ssh-key-jonathan
            %ssh-key-podiki
            %ssh-key-podiki

            %network-manager-ipv6-privacy
            %network-manager-random-mac-address

            %xdg-data-home
            %xdg-base-directory-env-vars

            %testament-cli-packages

            linux-desktop/dolly
            linux-server/dolly))


;;;
;;; Find files within the repository.
;;;

(define testament-path
  (getcwd))

(define (testament-file name)
  (let ((tangled (in-vicinity (string-append testament-path "/tangled") name)))
    (if (file-exists? tangled)
        tangled
        (error "file '~a' not found.~%" name))))


;;;
;;; SOPS secrets.
;;;

(define %sops-chapra
  (local-file (in-vicinity testament-path "secrets/chapra.yaml")))
(define %sops-dorphine
  (local-file (in-vicinity testament-path "secrets/dorphine.yaml")))
(define %sops-involemi
  (local-file (in-vicinity testament-path "secrets/involemi.yaml")))
(define %sops-nuporta
  (local-file (in-vicinity testament-path "secrets/nuporta.yaml")))


;;;
;;; Keys
;;;

(define %guix-keys
  (list (plain-file "dorphine.pub"
          "(public-key (ecc (curve Ed25519)
(q #A279175682D0DAE3E11268E67E1F3FA47C38D7E509F7725567CF891E248E719F#)))")
        (plain-file "nuporta.pub"
          "(public-key (ecc (curve Ed25519)
(q #552F670D5005D7EB6ACF05284A1066E52156B51D75DE3EBD3030CD046675D543#)))")
        (plain-file "ignamma.pub"
          "(public-key (ecc (curve Ed25519)
(q #6FEEB15C4363F9975EB15C908EC911A4362E486DA642431FA2438C0B1C3D55F5#)))")
        (plain-file "workers-hako.pub"
          "(public-key (ecc (curve Ed25519)
(q #7927EA1162184C1FAA62D20C111121A4604F00956E69F0FEB89EEE1721647897#)))")
        (plain-file "workers-poesty.pub"
          "(public-key (ecc (curve Ed25519)
(q #8C4662FA0BC955B33261EEA5AA15F33081A7BEC991E5F990F7382F0988459B37#)))")
        ;; Guix Moe
        (plain-file "guix-moe.pub"
          "(public-key (ecc (curve Ed25519)
(q #552F670D5005D7EB6ACF05284A1066E52156B51D75DE3EBD3030CD046675D543#)))")
        ;; Nonguix
        (plain-file "nonguix.pub"
          "(public-key (ecc (curve Ed25519)
(q #C1FD53E5D4CE971933EC50C9F307AE2171A2D3B52C804642A7A35F84F3A4EA98#)))")))

(define %ssh-key-deploy
  (plain-file "deploy.pub"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMLWIp8y5/JGBaw+yFA5MFB5nlFpEx/tjc0q0Ij9KjTu\n"))
(define %ssh-key-hako
  (plain-file "hako.pub"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFcTj1N3cL/bh2Uvwh5/YubhZplPFnvGk/iVHQs3FWV2\n"))
(define %ssh-key-jonathan
  (plain-file "jonathan.pub"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHgzHvP3BRTIZ960LVglrK8w/C0+6Z5VM8/Q5Uwa0o+Z"))
(define %ssh-key-podiki
  (plain-file "podiki.pub"
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDaSmW/3uq5L6ZP6gWmRw5RiTTg0es1PrbAo/x4vkPzwIKTrMFOCBCmcuH3vOCkEZJtNy3OpXbt/a3tDW+cc6dkeq2H4WpogQvyMTXreFS2phMgDTEXW2gGZIP6fA33CHERmhd9A/m0A+NH5KGAmLDQNK8QgPgIjZuseJYtYHNCnN2TCsWQYnbZtVQF5CS6iBUILpVp6p7QlSUokiCGaPjZfrjSFCm1hUPjJYSkv0NTq8TzyDfU2quqP7TBCj4WBi9HoW9+a8tN2TQ/+GYbGqlFljeNdz3vzItcHjidHOQL/42mpvzgZx7o7dtrqX9stp+mI3oBREYSD0bMyvND/dEBRWIbpFvbyYx/leMKq9yUcFNyI2lztk17ObaQkDLxlq4ClytgEtdbP6X0gua29FYK/YlAi13NptK6uy2xB2gsEIt5P4N3u+gZCNA0U3IVd7iMRSpg6PWiL1JguvhYSD5vGOnOjiXVlBCKn+ErTO9Ey/BZqwVBZMeDwynFnU1mYnkxtA+G54VI77gj24FrHw/ClOdJOdBUGAso9P3sFjdykkAJyKd4jiFzpDTOOJNs8qKhmFFzJBnJjn7nzwjElwOCZXdDKTrKqF/51WEqpNr8Za2QjRirV4m7n6FnyyD38b24InAVa+yze3qDI9yk2vjPdtFGCeLODSEjfV3U1z1hiw=="))


;;;
;;; NetworkManager
;;;

(define %network-manager-ipv6-privacy
  `("ip6-privacy.conf"
    ,(ini-file "ip6-privacy.conf"
       #~'(("connection"
            . (("ipv6.ip6-privacy" . 2)))))))

;; NOTE: When using on cloud machines, refer to the terms of the provider
;; first.
(define %network-manager-random-mac-address
  `("random-mac-address.conf"
    ,(ini-file "random-mac-address.conf"
       #~'(("connection-mac-randomization"
            . (("ethernet.cloned-mac-address" . "stable")
               ("wifi.cloned-mac-address" . "stable")))))))


;;;
;;; XDG
;;;

(define %xdg-data-home
  (or (getenv "XDG_DATA_HOME")
      (in-vicinity (getenv "HOME") ".local/share")))

;; Source: <https://wiki.archlinux.org/title/XDG_Base_Directory>
(define %xdg-base-directory-env-vars
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


;;;
;;; Packages
;;;

(define %testament-cli-packages
  (list binutils
        curl
        fd
        file
        git
        `(,git "send-email")
        gnupg
        htop
        jujutsu
        lsof
        mirror-substitutes
        mosh
        ncdu
        ncurses
        rclone
        ripgrep
        rsync
        sops
        unzip
        xxd))


;;;
;;; Kernel
;;;

(define (%kernel-config path)
  (let* ((commit "959e95c6882daaf7299feb377ae83a879702f6d6")
         (source
          (origin
            (method git-fetch)
            (uri (git-reference
                   (url "https://codeberg.org/hako/kernel-config.git")
                   (commit commit)))
            (file-name (string-append "kernel-config." (string-take commit 7)))
            (sha256
             (base32 "0nbg64ab4drzig1i7ifya7yx0d93l5fzzqvsj53ykv22wrixwpaa")))))
    (file-append source path)))

(define* (make-linux/dolly base version source #:key defconfig modconfig (configs ""))
  (let ((kernel
         (customize-linux
          #:name "linux-dolly"
          #:linux base
          #:source source
          #:defconfig defconfig
          #:modconfig modconfig
          #:configs configs)))
    (package
      (inherit kernel)
      (version version))))

(define linux-server/dolly
  (let ((cachyos-version "6.18.38-1"))
    (make-linux/dolly
     linux-6.18
     cachyos-version
     (origin
       (method url-fetch)
       (uri (string-append
             "https://github.com/CachyOS/linux/releases/download/cachyos-"
             cachyos-version "/cachyos-" cachyos-version ".tar.gz"))
       (sha256
        (base32 "1jadhczbqinkwwqk8gvnbmr95lwhzlwncf89szwvb8d1529kqiq0")))
     #:defconfig (%kernel-config "/defconfig_server")
     #:configs
     (string-join
      (append (cachyos-configs
               #:major-version (version-major cachyos-version)
               #:cachy-config? #f
               #:cpusched 'eevdf
               #:cc-harder? #t
               #:per-gov? #f
               #:tcp-bbr3? #t
               #:HZ-ticks 300
               #:tickrate 'full
               #:preempt 'none
               #:hugepage 'always
               #:processor-opt 'generic)
              (default-initrd-configs))
      "\n"))))

(define linux-desktop/dolly
  (let ((cachyos-version "7.0.12-2"))
    (make-linux/dolly
     linux-7.0
     cachyos-version
     (origin
       (method url-fetch)
       (uri (string-append
             "https://github.com/CachyOS/linux/releases/download/cachyos-"
             cachyos-version "/cachyos-" cachyos-version ".tar.gz"))
       (sha256
        (base32 "1whzwakpcgyvks07ac7lp7yf9vv5aa6h90cpg6jxx0kwaw9n5ibk"))
       (patches (map %kernel-config '("/patches/bore-cachy-7.0.patch"))))
     #:defconfig (%kernel-config "/defconfig_desktop")
     #:configs
     (string-join
      (append (cachyos-configs
               #:major-version (version-major cachyos-version)
               #:cachy-config? #t
               #:cpusched 'bore
               #:cc-harder? #t
               #:per-gov? #f
               #:tcp-bbr3? #t
               #:HZ-ticks 1000
               #:tickrate 'full
               #:preempt 'full
               #:hugepage 'always
               #:processor-opt 'zen4)
              (default-initrd-configs))
      "\n"))))
