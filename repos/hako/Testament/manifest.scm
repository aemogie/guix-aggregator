(use-modules (guix packages)
             (guix profiles)
             (bluebox packages blue)
             (gnu packages)
             (gnu packages guile))

(define (specifications->development-manifest specs)
  (let ((specification->development-manifest
         (compose package->development-manifest
                  specification->package)))
    (concatenate-manifests
     (map specification->development-manifest specs))))

(define blue/dolly
  (package
    (inherit blue)
    (inputs
     (modify-inputs inputs
       (replace "guile" guile-3.0-latest)))))

(concatenate-manifests
 (list (packages->manifest
        (list blue/dolly))
       (specifications->manifest
        (list "gnupg"
              "sops"
              ;; For Guix System installer.
              "guile-newt"
              "guile-parted"
              "guile-webutils"))
       (specifications->development-manifest
        (list "guix"))))
