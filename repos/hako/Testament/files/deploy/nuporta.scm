(use-modules (gnu machine)
             (gnu machine ssh))

(list
 (machine
   (operating-system (load "../tangled/nuporta.scm"))
   (environment managed-host-environment-type)
   (configuration
    (machine-ssh-configuration
      (host-name "nuporta")
      (system "x86_64-linux")
      (host-key "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILdDyVMnEcVsuTZvnKjnQsgmTN+ebX9ub4ek4xwsqu+K")))))
