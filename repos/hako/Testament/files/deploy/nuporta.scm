;;; SPDX-FileCopyrightText: 2025 Hilton Chain <hako@ultrarare.space>
;;;
;;; SPDX-License-Identifier: CC0-1.0

(use-modules (gnu machine)
             (gnu machine ssh))

(list
 (machine
   (operating-system (load "../../config/nuporta.scm"))
   (environment managed-host-environment-type)
   (configuration
    (machine-ssh-configuration
      (host-name "nuporta")
      (system "x86_64-linux")
      (host-key "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILdDyVMnEcVsuTZvnKjnQsgmTN+ebX9ub4ek4xwsqu+K")))))
