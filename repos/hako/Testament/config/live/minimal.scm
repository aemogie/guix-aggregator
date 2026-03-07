;;; SPDX-License-Identifier: GPL-3.0-or-later
;;; Copyright © 2026 Hilton Chain <hako@ultrarare.space>

(use-modules (srfi srfi-19)
             (guix gexp)
             (guix packages)
             (guix scripts pull)
             (nonguix transformations)
             (rosenthal utils transformations)
             (gnu system)
             (gnu system install)
             (gnu system locale)
             (gnu system privilege)
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

(define %installation-os
  (make-installation-os
   #:efi-only?
   (string=? (or (getenv "SYSTEM")
                 (%current-system))
             "aarch64-linux")))

(define %os
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
              (delete gc-root-service-type))))

    (privileged-programs %default-privileged-programs)))


;;;
;;; Transformations
;;;

((compose (nonguix-transformation-guix)
          (rosenthal-transformation-guix))
 %os)
