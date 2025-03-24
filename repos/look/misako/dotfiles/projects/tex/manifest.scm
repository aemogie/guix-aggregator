(use-modules (guix profiles)
             (gnu packages texlive)
             (saayix packages tex))

(packages->manifest
  (list texlive
        texlab))
