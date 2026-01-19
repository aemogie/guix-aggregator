;;; SPDX-License-Identifier: GPL-3.0-or-later
;;; Copyright © 2026 Hilton Chain <hako@ultrarare.space>

(use-modules (guix packages)
             (guix scripts pull)
             (nonguix)
             (rosenthal)
             (gnu system install)
             (gnu system locale)
             (gnu system privilege)
             (gnu packages guile)
             (gnu packages linux)
             (gnu packages package-management)
             (gnu packages texinfo))


;;;
;;; Parameters
;;;

(current-guix-package
 (package
   (inherit (guix-for-channels
             (channel-list '((channel-file . "channels.lock")))))
   (propagated-inputs (package-propagated-inputs guix))))


;;;
;;; Operating system
;;;

(define %os
  (operating-system
    (inherit installation-os)
    (host-name "live-system")
    (label "Rosenthal Live System")
    (kernel linux)
    (firmware
     (cons* linux-firmware
            (operating-system-firmware installation-os)))
    (users
     (cons* (user-account
              (inherit %root-account)
              (shell (file-append (specification->package "fish") "/bin/fish")))
            %base-user-accounts))

    (packages
     (append (specifications->packages
              '(;; CLI utilities.
                "curl"
                "fd"
                "git"
                "gnupg"
                "mosh"
                "ncurses"
                "ripgrep"
                "rsync"
                "unzip"
                ))
             (list %rosenthal-set-keymap)
             (operating-system-packages installation-os)))

    (services
     ;; Modified from `installation-os', with our own examples.
     (cons* (service gc-root-service-type
              (cons* (load "examples/bare-bones.scm")
                     (libc-utf8-locales-for-target)
                     texinfo
                     guile-3.0
                     %default-locale-libcs))

            (simple-service 'configuration-template
                etc-service-type
              `(("configuration" ,(local-file "examples" #:recursive? #t))))

            (modify-services (operating-system-user-services installation-os)
              (delete (@@ (gnu system install) configuration-template-service-type))
              (delete gc-root-service-type))))

    (privileged-programs %default-privileged-programs)))


;;;
;;; Transformations
;;;

((compose (nonguix-transformation-guix)
          (rosenthal-transformation-guix))
 %os)
