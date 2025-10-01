;;; SPDX-FileCopyrightText: 2025 Hilton Chain <hako@ultrarare.space>
;;;
;;; SPDX-License-Identifier: CC0-1.0

(use-modules (ice-9 match)
             (gnu machine)
             (gnu machine ssh))

(define %os (load "../../config/worker.scm"))

(define* (build-worker #:key address system (32bit-support? #t) ssh-host-key jobs threads-per-job (bios-boot #f))
  (machine
    (operating-system (%os system 32bit-support? jobs threads-per-job bios-boot))
    (environment managed-host-environment-type)
    (configuration
     (machine-ssh-configuration
       (host-name address)
       (system system)
       (host-key ssh-host-key)))))

(define (hetzner-worker system address)
  (build-worker
   #:address address
   #:system system
   #:32bit-support? #t
   #:ssh-host-key "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIED2WXdbkA7slzknPrzc3QL+fmrU2eaPRENdVxKElVXb root@(none)"
   #:jobs 4
   #:threads-per-job 4
   #:bios-boot (and (string=? "x86_64-linux" system) "/dev/sda")))

(list #;(build-worker
         #:address "0.0.0.0"
         #:system "aarch64-linux"
         #:32bit-support? #t
         #:ssh-host-key "ssh-ed25519 ..."
         #:jobs 4
         #:threads-per-job 2)
      #;(build-worker
         #:address "0.0.0.0"
         #:system "x86_64-linux"
         #:32bit-support? #t
         #:ssh-host-key "ssh-ed25519 ..."
         #:jobs 4
         #:threads-per-job 2
         #:bios-boot "/dev/sda"))
