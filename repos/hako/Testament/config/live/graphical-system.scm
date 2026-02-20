;;; SPDX-License-Identifier: GPL-3.0-or-later
;;; Copyright © 2026 Hilton Chain <hako@ultrarare.space>

(use-modules (guix gexp)
             (guix utils)
             (gnu system)
             (gnu system privilege)
             (gnu system shadow)
             (gnu services)
             (gnu services base)
             (gnu services dbus)
             (gnu services desktop)
             (gnu services networking)
             (gnu services pm)
             (rosenthal services desktop)
             (gnu packages hardware)
             (gnu packages libusb)
             (gnu packages linux)
             (gnu packages nfs)
             (gnu packages shells))

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
            (shell (file-append fish "/bin/fish")))
          (operating-system-users %minimal-os)))
  (skeletons %rosenthal-skeletons-installer)
  (services
   (cons* ;; From `%rosenthal-desktop-services/base'.
          (service bluetooth-service-type
            (bluetooth-configuration
              (auto-enable? #t)))
          (service gvfs-service-type)
          (service power-profiles-daemon-service-type)
          (simple-service 'backlight udev-service-type (list ddcutil light))

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
      (plain-file-content (operating-system-sudoers-file %minimal-os))
      "live ALL = NOPASSWD: ALL\n"))))
