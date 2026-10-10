(use-modules (gnu machine)
             (gnu machine ssh))

(define %os
  (load "../tangled/nuporta/nuporta.scm"))

(list
 (machine
   (operating-system %os)
   (environment managed-host-environment-type)
   (configuration
    (machine-ssh-configuration
      (host-name "nuporta")
      (host-key "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILdDyVMnEcVsuTZvnKjnQsgmTN+ebX9ub4ek4xwsqu+K")
      (system "x86_64-linux")
      (user "deploy")
      (allow-downgrades? #t)))))
