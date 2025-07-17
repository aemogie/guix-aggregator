;; -*- lexical-binding: t; -*-

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

(provide 'anemofilia/miscl)
