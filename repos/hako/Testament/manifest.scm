(use-modules (guix profiles)
             (gnu packages))

(define (specifications->development-manifest specs)
  (let ((specification->development-manifest
         (compose package->development-manifest
                  specification->package)))
    (concatenate-manifests
     (map specification->development-manifest specs))))

(concatenate-manifests
 (list (specifications->manifest
        '("gnupg"
          "maak"
          "sops"
          ;; For Guix System installer.
          "guile-newt"
          "guile-parted"
          "guile-webutils"))
       (specifications->development-manifest
        '("guix"))))
