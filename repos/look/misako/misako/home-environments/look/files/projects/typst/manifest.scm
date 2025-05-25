(use-modules (guix profiles)
             (saayix packages typst))

(packages->manifest
  (list typst))
