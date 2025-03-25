(use-modules (gnu packages)
             (gnu packages gimp)

             (guix packages)
             (guix download))

(packages->manifest
 (list gimp)) ; TODO: add the necessary fonts'n'stuff later
