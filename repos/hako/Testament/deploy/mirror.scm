(use-modules (common)
             (gnu machine)
             (gnu machine ssh))

(define %os
  (load (in-vicinity testament-path "tangled/mirror/mirror.scm")))

(define* (mirror #:key mirror-name host-name system ssh-host-key (bios-boot #f))
  (machine
    (operating-system (%os mirror-name bios-boot))
    (environment managed-host-environment-type)
    (configuration
     (machine-ssh-configuration
       (host-name
        (or host-name
            (string-append mirror-name ".guix.moe")))
       (system system)
       (host-key ssh-host-key)))))

(list (mirror
       #:mirror-name "cache-sg"
       #:system "x86_64-linux"
       #:ssh-host-key "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC7LUCU7btbuvWNMvS3WnM6lAZLB8AwH/O9LdYhae9Eo"
       #:bios-boot "/dev/vda")
      (mirror
       #:mirror-name "cache-us-lax"
       #:system "x86_64-linux"
       #:ssh-host-key "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIymKc9HG2Gr+4r2mG3zVdRsCewZ9WuVrOJZipbMWHrl"
       #:bios-boot "/dev/vda"))
