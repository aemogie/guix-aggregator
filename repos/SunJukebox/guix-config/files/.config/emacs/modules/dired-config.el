;;; dired-config.el --- Configure dired -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

;; C-x C-j is bound to the (dired-jump) command by default. Put on the more
;; obvious C-x d.
;; We leave the more powerful, but verbose, (dired) command on C-x D
;; It is safe to use keymap-global-set here because these dired commands are set
;; in the global-map.
(use-package dired
  :ensure nil ; built-in
  :commands (dired dired-jump)
  :bind (("C-x d" . dired-jump)
         ("C-x D" . dired))
  :init
  (keymap-global-unset "C-x C-j")
  :custom
  (dired-recursive-copies #'always)
  (dired-recursive-deletes #'always)
  (delete-by-moving-to-trace t)
  (dired-dwim-target t))

(provide 'dired-config)
;;; dired-config.el ends here
