;;; dev.el --- Dev configuration for Emacs -*- lexical-binding: t -*-

;; Copyright © Josep Bigorra <jjbigorra@gmail.com>

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

;; Configures Emacs for Rust development, providing syntax highlighting,
;; indentation, and other language-specific features.
(use-package rust-mode :ensure t)

;; Provides a linter for Emacs Lisp packages, helping to ensure code quality
;; and adherence to best practices.
(use-package package-lint :ensure t)

;; Integrates the Black formatter for Python, automatically formatting Python
;; code on save to maintain consistent style.
(use-package python-black
  :ensure t
  :after python
  :hook (python-mode . python-black-on-save-mode-enable-dwim))

;; Configures Emacs for Haskell development, enabling syntax highlighting
;; and other features for Haskell files.
(use-package haskell-mode :ensure t :mode "\\.hs\\'")

;; Sets up Emacs for Scala development using tree-sitter, providing
;; advanced parsing and features for Scala files.
(use-package scala-ts-mode :ensure t :mode "\\.scala\\'")

;; Configures Emacs for Lua development, offering syntax highlighting
;; and basic support for Lua files.
(use-package lua-mode :ensure t :mode "\\.lua\\'")

;; Sets up Emacs for TypeScript development, providing syntax highlighting
;; and other features for TypeScript files.
(use-package typescript-mode :ensure t :mode "\\.ts\\'")

;; Configures Emacs for Nix development using tree-sitter,
;; enabling advanced parsing and features for Nix files.
(use-package nix-ts-mode
  :ensure t
  :mode "\\.nix\\'")

;; Sets up Emacs for TOML file editing, providing syntax highlighting and
;; basic support for TOML files.
(use-package toml-mode :ensure t :mode "\\.toml\\'")

;; Configures Emacs for YAML file editing, offering syntax highlighting and
;; basic support for YAML files.
(use-package yaml-mode :ensure t :mode "\\.\\(e?ya?\\|ra\\)ml\\'")

;; Enables smart handling of parentheses and other delimiters in programming modes,
;; assisting with balanced expressions.
(use-package smartparens
  :ensure t
  :hook ((prog-mode . smartparens-mode))
  :config
  (require 'smartparens-config))

;; Integrates direnv with Emacs, allowing automatic loading and unloading
;; of environment variables based on directory.
(use-package direnv
  :ensure t
  :bind (("C-c d d" . direnv-mode)
         ("C-c d a" . direnv-allow)))

;; Provides aggressive indentation for Lisp-like languages,
;; automatically formatting code as you type.
(use-package aggressive-indent
  :ensure t
  :hook ((emacs-lisp-mode . aggressive-indent-mode)
         ;; in Scheme I usually just use Guix format
         ;; which auto-formats my files nicely
         ;;
         ;;otherwise feel free to turn this on
         ;; (scheme-mode . aggressive-indent-mode)
         (lisp-mode . aggressive-indent-mode)))

;; Configures Emacs for editing Dockerfile and .dockerignore files using tree-sitter.
(use-package dockerfile-ts-mode
  :ensure nil
  :mode (("\\Dockerfile\\'" . dockerfile-ts-mode)
         ("\\.dockerignore\\'" . dockerfile-ts-mode))
  :config
  (setq dockerfile-mode-command "podman"))

;; Provides an interface for interacting with Docker from within Emacs,
;; allowing management of containers and images.
(use-package docker
  :ensure t
  :bind ("C-c d c" . docker))

;; Provides a good Scheme REPL integration with Emacs and Guile Ares
(use-package arei
  :ensure (:host github :repo "abcdw/emacs-arei" :branch "master")
  :demand t)

;; Provides Geiser for Scheme/Racket development, with an interactive
;; environment and language support.
(use-package geiser
  :ensure t
  :init
  (setq geiser-active-implementations '(guile))
  (setq geiser-mode-auto-p nil)
  (ignore-errors
    (define-key scheme-mode-map (kbd "C-c i f") #'sss-guix-fmt)))

;; Specifically provides Geiser support for the Guile Scheme implementation.
(use-package geiser-guile
  :ensure t)

;; Provdes a REPL session management tool for Emacs and more.
(use-package sesman
  :ensure (:host github :repo "vspinu/sesman" :branch "master")
  :demand t)

;; Enhances the compilation buffer with fancy features, improving the
;; readability and usability of compilation output.
(use-package fancy-compilation
  :ensure t
  :commands (fancy-compilation-mode)
  :config
  (setq fancy-compilation-override-colors nil))

;; Provides visual diff highlighting in the margin,
;; showing changes relative to version control.
(use-package diff-hl
  :ensure t
  :config
  (global-diff-hl-mode)
  (setopt diff-hl-margin-symbols-alist
          '((insert . "+") (delete . "-") (change . "~")
            (unknown . "?") (ignored . "i")))
  (diff-hl-margin-mode)
  (ignore-errors
    (add-hook 'magit-post-refresh-hook 'diff-hl-magit-post-refresh)
    (add-hook 'dired-mode-hook
              (lambda () (diff-hl-dired-mode))))
  (ignore-errors
    (set-face-attribute 'diff-hl-change nil
                        :background 'unspecified)
    (set-face-attribute 'diff-hl-insert nil
                        :background 'unspecified)
    (set-face-attribute 'diff-hl-delete nil
                        :background 'unspecified)))

(with-eval-after-load 'compile
  (fancy-compilation-mode))

;; Configures Emacs for Markdown file editing, enabling specific display
;; modes and custom functions for Markdown files.
(use-package markdown-mode
  :ensure t
  :mode "\\.md\\'"
  :hook ((markdown-mode . sss-markdown-mode))
  :config
  (defun sss-markdown-mode ()
    (variable-pitch-mode 1)
    (auto-fill-mode 0)
    (visual-line-mode 1)
    (ignore-errors (sss-set-base-faces))))

;; Provides a library for making HTTP requests from Emacs Lisp.
(use-package request
  :ensure t)

;; Sets up a collection of Flymake backends for various languages,
;; enabling on-the-fly syntax checking and linting.
(use-package flymake-collection
  :ensure t
  :hook ((after-init . flymake-collection-hook-setup)
         (emacs-lisp-mode . flymake-mode)))

;; Configures Emacs for editing JSON files, providing
;; syntax highlighting and formatting.
(use-package json-mode
  :ensure (:host github :repo "json-emacs/json-mode"))

;; Provides interactive ways for working with
;; OpenAPI/Swagger specifications from Emacs.
(use-package swagg
  :ensure (:host github :repo "isamert/swagg.el"))

(provide 'sss/dev)

;;; dev.el ends here
