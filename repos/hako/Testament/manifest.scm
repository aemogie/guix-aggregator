(use-modules (guix profiles))

(define (specifications->development-manifest specs)
  (let ((specification->development-manifest
         (compose package->development-manifest
                  specification->package)))
    (concatenate-manifests
     (map specification->development-manifest specs))))

(concatenate-manifests
 (list (specifications->manifest
        (list "blue"
              "gnupg"
              "sops"
              "guile"
              "guile-ares-rs"
              ;; For Guix System installer.
              "guile-newt"
              "guile-parted"
              "guile-webutils"))
       (specifications->development-manifest
        (list "guix"))))
