(use-modules (gnu machine)
             (gnu machine ssh))

(define %os (load "../../config/worker.scm"))

(define* (build-worker #:key host-name address system (32bit-support? #t) ssh-host-key workers threads-per-worker (bios-boot #f))
  (machine
    (operating-system (%os host-name system 32bit-support? workers threads-per-worker bios-boot))
    (environment managed-host-environment-type)
    (configuration
     (machine-ssh-configuration
       (host-name address)
       (system system)
       (host-key ssh-host-key)))))

(list #;(build-worker
         #:host-name "..."
         #:address "0.0.0.0"
         #:system "aarch64-linux"
         #:32bit-support? #t
         #:ssh-host-key "ssh-ed25519 ..."
         #:workers 4
         #:threads-per-worker 2)
      #;(build-worker
         #:host-name "..."
         #:address "0.0.0.0"
         #:system "x86_64-linux"
         #:32bit-support? #t
         #:ssh-host-key "ssh-ed25519 ..."
         #:workers 4
         #:threads-per-worker 2
         #:bios-boot "/dev/sda"))
