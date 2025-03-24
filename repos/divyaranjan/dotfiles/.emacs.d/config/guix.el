;; guix.el -- Divya's Guix Configurations for Emacs --- -*- lexical-binding:t -*-

;;; Commentary:

;;; Code:

;; (use-package guix
;;   :straight t)
(require 'guix)

(global-set-key (kbd "C-x C-g") 'guix)

;; For copyright signatures in guix checkouts
(load-file "/mnt/code/big-src/guix/etc/copyright.el")

(provide 'guix.el)
;;; guix.el ends here
