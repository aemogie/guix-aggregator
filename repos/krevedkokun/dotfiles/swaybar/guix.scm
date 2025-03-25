(use-modules
 (gnu packages guile)
 (gnu packages guile-xyz)
 (guix profiles)
 (guix packages))

(use-modules )

(packages->manifest
 (list guile-next
       guile-ac-d-bus
       guile-fibers
       guile-srfi-180
       guile-srfi-197
       (@ (rde packages guile-xyz) guile-ares-rs-latest)))
