(use-modules (gnu machine)
             (gnu machine ssh))

(define %os
  (load "../tangled/worker/worker.scm"))

(define* (build-worker #:key host-name address system (32bit-support? #t) ssh-host-key workers (bios-boot #f))
  (machine
    (operating-system (%os host-name system 32bit-support? workers bios-boot))
    (environment managed-host-environment-type)
    (configuration
     (machine-ssh-configuration
       (host-name address)
       (host-key ssh-host-key)
       (system system)
       (user "deploy")))))

(list #;(build-worker
         #:host-name "..."
         #:ssh-host-key "ssh-ed25519 ..."
         #:address "0.0.0.0"
         #:system "aarch64-linux"
         #:32bit-support? #t
         #:workers 4)
      #;(build-worker
         #:host-name "..."
         #:ssh-host-key "ssh-ed25519 ..."
         #:address "0.0.0.0"
         #:system "x86_64-linux"
         #:32bit-support? #t
         #:workers 4
         #:bios-boot "/dev/sda"))
