(define-module (unmatched-deploy))
(use-modules (unmatched)
             (gnu machine)
             (gnu machine ssh))

(list (machine
        (operating-system %unmatched-system)
        (environment managed-host-environment-type)
        (configuration (machine-ssh-configuration
                         (host-name "unmatched.unicorn-typhon.ts.net")
                         ;(host-name "192.168.68.54")
                         (system "riscv64-linux")
                         (port 22)
                         (user "efraim")
                         (identity "/home/efraim/.ssh/id_ecdsa")
                         (host-key "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKEiKUe+U6TENWhAhU8cIq9/y/SLdt3XMbrrIJvp3Ix6")))))

;; For /etc/passwd
;; efraim ALL = NOPASSWD: ALL
;; time guix deploy -L ~/workspace/my-guix -L ~/workspace/guix-config ~/workspace/guix-config/unmatched-deploy.scm
