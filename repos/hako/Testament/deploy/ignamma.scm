(use-modules (gnu machine)
             (gnu machine ssh))

(define %os
  (load "../tangled/ignamma/ignamma.scm"))

(list
 (machine
   (operating-system %os)
   (environment managed-host-environment-type)
   (configuration
    (machine-ssh-configuration
      (host-name "ignamma")
      (host-key "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAPBlsRI/35fyLNgRHcOUdwQkagHf6mV75cFycHSyJ2B")
      (system "x86_64-linux")
      (user "deploy")))))
