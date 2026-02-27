(use-modules (gnu machine)
             (gnu machine ssh))

(list
 (machine
   (operating-system (load "../tangled/ignamma/ignamma.scm"))
   (environment managed-host-environment-type)
   (configuration
    (machine-ssh-configuration
      (host-name "ignamma")
      (system "x86_64-linux")
      (host-key "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAPBlsRI/35fyLNgRHcOUdwQkagHf6mV75cFycHSyJ2B")))))
