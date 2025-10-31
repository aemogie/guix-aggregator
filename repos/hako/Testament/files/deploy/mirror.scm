;;; SPDX-FileCopyrightText: 2025 Hilton Chain <hako@ultrarare.space>
;;;
;;; SPDX-License-Identifier: CC0-1.0

(use-modules (gnu machine)
             (gnu machine ssh))

(define %os (load "../../config/mirror.scm"))

(define* (mirror #:key mirror-name system ssh-host-key (bios-boot #f))
  (machine
    (operating-system (%os mirror-name bios-boot))
    (environment managed-host-environment-type)
    (configuration
     (machine-ssh-configuration
       (host-name (string-append mirror-name ".guix.moe"))
       (system system)
       (host-key ssh-host-key)))))

(list (mirror
       #:mirror-name "cache-hk"
       #:system "x86_64-linux"
       #:ssh-host-key "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPfURzADzVsKpcwBAx0VfcOejhde1amjP9zav/ZFIJ0Y"
       #:bios-boot "/dev/vda")
      (mirror
       #:mirror-name "cache-sg"
       #:system "x86_64-linux"
       #:ssh-host-key "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM9Ad1hMSRW2+mP8UTx6XCK8ioLA+1ZyBmCHChvvBvzk"
       #:bios-boot "/dev/vda")
      (mirror
       #:mirror-name "cache-us-lax"
       #:system "x86_64-linux"
       #:ssh-host-key "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE3MpODvl8Ifk8tShMzMfourJELup+bwJLOYL+cYTWBP"
       #:bios-boot "/dev/vda"))
