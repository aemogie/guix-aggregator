;;; vterm-config.el --- Configuration for vterm-mode -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

(require 'os-detection)

(use-package vterm
  :ensure nil ;; built-in
  :defer t
  :when (onghaik/is-guix-system))

(provide 'vterm-config)
;;; vterm-config.el ends here
