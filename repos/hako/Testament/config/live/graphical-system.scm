;;; SPDX-License-Identifier: GPL-3.0-or-later
;;; Copyright © 2026 Hilton Chain <hako@ultrarare.space>

(use-modules (guix gexp)
             (guix utils)
             (gnu system)
             (gnu system install)
             (gnu system privilege)
             (gnu system shadow)
             (gnu services)
             (gnu services base)
             (gnu services dbus)
             (gnu services desktop)
             (gnu services networking)
             (gnu services pm)
             (rosenthal services desktop)
             (gnu packages)
             (gnu packages libusb)
             (gnu packages linux)
             (gnu packages nfs)
             (gnu packages shells))

(define %installation-os
  (make-installation-os
   #:efi-only?
   (string=? (or (getenv "SYSTEM")
                 (%current-system))
             "aarch64-linux")))

(define %minimal-os
  (load "minimal.scm"))


;;;
;;; Operating system
;;;

(operating-system
  (inherit %minimal-os)
  (users
   (cons* (user-account
            (name "live")
            (password (crypt "live" "$6$abc"))
            (group "users")
            (supplementary-groups '("audio" "video" "wheel"))
            ;; See also `home-fish-service-type'.
            (shell (file-append fish "/bin/fish")))
          (operating-system-users %minimal-os)))

  (skeletons %rosenthal-skeletons)

  (packages
   (append (specifications->packages
            '(;; CLI utilities.
              "curl"
              "fd"
              "fish"
              "git"
              "gnupg"
              "mosh"
              "ncurses"
              "ripgrep"
              "rsync"
              "unzip"

              ;; Desktop, see also `%rosenthal-skeletons'.
              "niri"
              "wl-clipboard"
              "xdg-desktop-portal-gnome"
              "xdg-desktop-portal-gtk"
              "xdg-utils"
              "imv"                ;image viewer
              "light"              ;backlight control
              "pavucontrol"        ;sound control
              "playerctl"          ;media control
              "wezterm"            ;terminal emulator
              "xwayland-satellite" ;rootless XWayland support

              ;; File manager.
              "exo"
              "file-roller"
              "thunar"
              "thunar-archive-plugin"
              "thunar-media-tags-plugin"
              "thunar-volman"
              "tumbler"

              ;; Web browser.
              "librewolf"
              "ublock-origin-icecat"

              ;; Text editors, see also `%rosenthal-skeletons'.
              "emacs-pgtk"
              "neovim"

              "emacs-corfu"
              "emacs-daemons"
              "emacs-doom-modeline"
              "emacs-envrc"
              "emacs-flycheck"
              "emacs-flycheck-guile"
              "emacs-forge"
              "emacs-gcmh"
              "emacs-geiser"
              "emacs-geiser-guile"
              "emacs-helpful"
              "emacs-hl-todo"
              "emacs-macrostep"
              "emacs-macrostep-geiser"
              "emacs-magit"
              "emacs-mwim"
              "emacs-no-littering"
              "emacs-orderless"
              "emacs-puni"
              "emacs-rainbow-delimiters"
              "emacs-vertico"

              ;; Fonts, see also `home-fontconfig-service-type'.
              "font-adobe-source-serif"
              "font-google-noto"
              "font-google-noto-emoji"
              "font-nerd-symbols"
              "font-sarasa-gothic"
              "font-victor-mono"
              ))
           (load "scripts.scm")
           (operating-system-packages %installation-os)))

  (services
   (cons* ;; From `%rosenthal-desktop-services/base'.
          (service bluetooth-service-type
            (bluetooth-configuration
              (auto-enable? #t)))
          (service gvfs-service-type)
          (service power-profiles-daemon-service-type)
          (simple-service 'backlight udev-service-type (list light))

          ;; From `%desktop-services'.
          (simple-service 'mtp udev-service-type (list libmtp))
          polkit-wheel-service
          (simple-service 'mount-setuid-helpers privileged-program-service-type
            (map file-like->setuid-program
                 (list (file-append nfs-utils "/sbin/mount.nfs")
                       (file-append ntfs-3g "/sbin/mount.ntfs-3g"))))
          (service udisks-service-type)
          (service polkit-service-type)
          (service elogind-service-type)
          (service ntp-service-type)
          (service x11-socket-directory-service-type)

          (modify-services (operating-system-user-services %minimal-os)
            (delete kmscon-service-type))))

  (sudoers-file
   (plain-file "sudoers"
     (string-append
      (plain-file-content (operating-system-sudoers-file %installation-os))
      "live ALL = NOPASSWD: ALL\n"))))
