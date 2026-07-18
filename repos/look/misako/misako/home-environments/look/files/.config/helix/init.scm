(require "helix/configuration.scm")

(require "cogs/splash.scm")
(require "config.scm")
(require "keybinds.scm")

(when (equal? (command-line) '("hx"))
  (show-splash))
