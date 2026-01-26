(define-module (rock64-deploy))
(use-modules (rock64)
             (gnu machine)
             (gnu machine ssh))

(list (machine
        (operating-system %rock64-system)
        (environment managed-host-environment-type)
        (configuration (machine-ssh-configuration
                         (host-name "rock64.unicorn-typhon.ts.net")
                         ;(host-name "192.168.68.60")
                         (system "aarch64-linux")
                         (port 22)
                         (user "efraim")
                         (identity "/home/efraim/.ssh/id_ecdsa")
                         (host-key "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL68NjEeODS0Q+O2YVEr4uFqKsPmNFztljn8VbG77cNE")))))

;; For /etc/passwd
;; efraim ALL = NOPASSWD: ALL
;; time guix deploy -L ~/workspace/my-guix -L ~/workspace/guix-config ~/workspace/guix-config/rock64-deploy.scm
