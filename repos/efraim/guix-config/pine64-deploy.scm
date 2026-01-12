(define-module (pine64-deploy))
(use-modules (pine64)
             (gnu machine)
             (gnu machine ssh))

(list (machine
        (operating-system %pine64-system)
        (environment managed-host-environment-type)
        (configuration (machine-ssh-configuration
                         (host-name "pine64.unicorn-typhon.ts.net")
                         ;(host-name "192.168.68.54")
                         (system "aarch64-linux")
                         (port 22)
                         (user "efraim")
                         (identity "/home/efraim/.ssh/id_ed25519")
                         (host-key "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICJCga76AhIpOHWxIs01aC5fDdnFGf9tF6NLUFe0+4w4")))))

;; For /etc/passwd
;; efraim ALL = NOPASSWD: ALL
;; time guix deploy -L ~/workspace/my-guix -L ~/workspace/guix-config ~/workspace/guix-config/pine64-deploy.scm
