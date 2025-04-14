;;; dev.el --- Dev configuration for Emacs -*- lexical-binding: t -*-

;; Copyright (C) 2025 Josep Bigorra

;; Author: Josep Bigorra <jjbigorra@gmail.com>
;; Maintainer: Josep Bigorra <jjbigorra@gmail.com>
;; URL: https://codeberg.org/jjba23/sss

;; sss is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; sss is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with sss.  If not, see <https://www.gnu.org/licenses/>.

;;; Commentary:

;; Dev configuration for Emacs

;;; Code:

(use-package rust-mode :ensure t)

(use-package package-lint :ensure t)

(use-package python-black
  :ensure t
  :after python
  :hook (python-mode . python-black-on-save-mode-enable-dwim))

(use-package haskell-mode :ensure t :mode "\\.hs\\'")

(use-package scala-ts-mode :ensure t :mode "\\.scala\\'")

(use-package lua-mode :ensure t :mode "\\.lua\\'")

(use-package typescript-mode :ensure t :mode "\\.ts\\'")

(use-package nix-ts-mode 
  :ensure t 
  :mode "\\.nix\\'")

(use-package toml-mode :ensure t :mode "\\.toml\\'")

(use-package yaml-mode :ensure t :mode "\\.\\(e?ya?\\|ra\\)ml\\'")

(use-package smartparens
  :ensure t
  :hook ((prog-mode . smartparens-mode))
  :config
  (require 'smartparens-config))

(use-package direnv
  :ensure t 
  :bind (("C-c d d" . direnv-mode)
         ("C-c d a" . direnv-allow)))

(use-package aggressive-indent
  :ensure t
  :hook ((emacs-lisp-mode . aggressive-indent-mode)
         (scheme-mode . aggressive-indent-mode)
         (lisp-mode . aggressive-indent-mode)))

(use-package dockerfile-ts-mode
  :ensure nil
  :mode (("\\Dockerfile\\'" . dockerfile-ts-mode)
         ("\\.dockerignore\\'" . dockerfile-ts-mode))
  :config
  (setq dockerfile-mode-command "podman"))

(use-package docker
  :ensure t
  :bind ("C-c d c" . docker))

(use-package arei
  :ensure (:host github :repo "abcdw/emacs-arei" :branch "master")
  :demand t)

(use-package geiser
  :ensure t
  :init
  (setq geiser-active-implementations '(guile))
  (setq geiser-mode-auto-p nil)
  (ignore-errors
    (define-key scheme-mode-map (kbd "C-c i f") #'sss-guix-fmt)))

(use-package geiser-guile
  :ensure t)

(use-package sesman
  :ensure (:host github :repo "vspinu/sesman" :branch "master")
  :demand t)

(use-package fancy-compilation
  :ensure t
  :commands (fancy-compilation-mode)
  :config
  (setq fancy-compilation-override-colors nil))

(use-package diff-hl
  :ensure t
  :config
  (global-diff-hl-mode)
  (diff-hl-dired-mode)
  (diff-hl-margin-mode)
  (ignore-errors
    (add-hook 'magit-post-refresh-hook 'diff-hl-magit-post-refresh)))

(with-eval-after-load 'compile
  (fancy-compilation-mode))

(provide 'sss/dev)

;;; dev.el ends here

