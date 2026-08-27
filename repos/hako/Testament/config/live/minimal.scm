;;; SPDX-License-Identifier: GPL-3.0-or-later
;;; Copyright © 2026 Hilton Chain <hako@ultrarare.space>

(use-modules (srfi srfi-19)
             (guix channels)
             (guix gexp)
             (guix packages)
             (guix scripts pull)
             (nonguix transformations)
             (rosenthal utils transformations)
             (gnu system)
             (gnu system install)
             (gnu system locale)
             (gnu system privilege)
             (gnu services base)
             (rosenthal services file-systems)
             (gnu packages)
             (gnu packages base)
             (gnu packages guile)
             (gnu packages linux)
             (gnu packages package-management)
             (gnu packages shells)
             (gnu packages texinfo)
             (nongnu packages linux))


;;;
;;; Parameters
;;;

(current-guix-package
 (package
   (inherit (guix-for-channels
             (channel-list '((channel-file . "config/live/channels.lock")))))
   (propagated-inputs (package-propagated-inputs guix))))


;;;
;;; Operating system
;;;

(define channels-with-nonguix
  (list (channel
          (inherit %default-guix-channel)
          (name 'guix)
          (url "https://git.guix.gnu.org/guix.git"))
        (channel
          (name 'nonguix)
          (url "https://gitlab.com/nonguix/nonguix")
          (introduction
           (make-channel-introduction
            "897c1a470da759236cc11798f4e0a5f7d4d59fbc"
            (openpgp-fingerprint
             "2A39 3FFF 68F4 EF7A 3D29  12AF 6F51 20A0 22FB B2D5"))))))

(define nonguix-signing-key
  (plain-file "nonguix.pub" "(public-key (ecc (curve Ed25519)
 (q #C1FD53E5D4CE971933EC50C9F307AE2171A2D3B52C804642A7A35F84F3A4EA98#)))"))

(define %installation-os
  (make-installation-os
   #:efi-only? (string=? (%current-system) "aarch64-linux")))

(operating-system
  (inherit %installation-os)
  (host-name "live-system")
  (label (format #f "Guix System installation (~a build)"
                 (date->string (current-date) "~Y-~m-~d")))
  (kernel linux)
  (firmware
   (cons* linux-firmware
          (operating-system-firmware %installation-os)))
  (kernel-arguments %default-kernel-arguments)
  (users
   (cons* (user-account
            (inherit %root-account)
            (shell (file-append fish "/bin/fish")))
          %base-user-accounts))

  (packages
   (append (specifications->packages
            '(;; CLI utilities.
              "curl"
              "file"
              "git"
              "gnupg"
              "mosh"
              "ncurses"
              "rsync"
              "unzip"))
           (load "scripts.scm")
           (operating-system-packages %installation-os)))

  (services
   (cons* (service zfs-service-type
            (zfs-configuration
             (auto-mount? #f)))

          ;; Use substitutes from guix.moe.
          (simple-service 'substitute-servers guix-service-type
            (guix-extension
              (substitute-urls
               (list "https://cache-cdn.guix.moe"))
              (authorized-keys
               (list nonguix-signing-key))))

          ;; Modified from `installation-os', with our own examples.
          (service gc-root-service-type
            (cons* (load "examples/bare-bones.scm")
                   (libc-utf8-locales-for-target)
                   texinfo
                   guile-3.0
                   %default-locale-libcs))

          (simple-service 'configuration-template etc-service-type
            `(("configuration" ,(local-file "examples" #:recursive? #t))))

          (modify-services (operating-system-user-services %installation-os)
            (delete (@@ (gnu system install) configuration-template-service-type))
            (delete gc-root-service-type)
            ;; Set up Nonguix channel in /etc/guix/channels.scm.
            (guix-service-type
             config => (guix-configuration
                         (inherit config)
                         (channels channels-with-nonguix))))))

  (privileged-programs %default-privileged-programs))
