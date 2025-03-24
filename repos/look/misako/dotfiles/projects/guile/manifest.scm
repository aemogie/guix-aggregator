(use-modules (guix profiles)
             (guix packages)
             (saayix packages lsp))

(packages->manifest
  (list guile-lsp-server)) 
