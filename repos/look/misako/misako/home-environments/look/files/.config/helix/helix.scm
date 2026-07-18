(require (prefix-in helix. "helix/commands.scm"))
(require (prefix-in helix.static. "helix/static.scm"))
(require "helix/editor.scm")

(provide open-init-scm)

(define (open-init-scm)
  (helix.open (helix.static.get-init-scm-path)))
