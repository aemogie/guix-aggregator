(use-modules (common)
             (gnu machine)
             (gnu machine ssh))

(define %os
  (load (in-vicinity testament-path "tangled/ignamma/ignamma.scm")))

(list
 (machine
   (operating-system %os)
   (environment managed-host-environment-type)
   (configuration
    (machine-ssh-configuration
      (host-name "ignamma")
      (system "x86_64-linux")
      (user "deploy")
      (host-key "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAPBlsRI/35fyLNgRHcOUdwQkagHf6mV75cFycHSyJ2B")))))
