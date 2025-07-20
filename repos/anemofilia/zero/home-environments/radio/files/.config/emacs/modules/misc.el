;; -*- lexical-binding: t; -*-

(use-package eat
  :hook (eat-mode . meow-insert-mode))

(use-package circe
  :custom
  (circe-nick "anemofilia")
  (circe-channels '("#emacs" "#gnu" "#guile" "#guix" "#spritely"))
  :hook (circe-mode . circe-server-mode))

(use-package mastodon
  :custom
  (mastodon-instance-url "https://mathstodon.xyz")
  (mastodon-active-user  "anemofilia")
  :hook (mastodon-mode . mastodon-async-mode))

(use-package pdf-tools
  :custom
  (pdf-outline-imenu-use-flat-menus t)
  (pdf-view-display-size 1.5)
  :bind (:map pdf-view-mode-map
              ("r" . pdf-view-rotate)
              ("R" . pdf-view-themed-minor-mode)
              ("J" . pdf-view-next-page)
              ("K" . pdf-view-previous-page)
              ("<tab>" . imenu))
  :hook
  (doc-view-mode . pdf-view-mode)
  (pdf-view-mode . pdf-outline-imenu-enable))

(provide 'anemofilia/miscl)
