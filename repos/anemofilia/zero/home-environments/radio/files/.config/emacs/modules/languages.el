;; -*- lexical-binding: t; -*-

;; haskell
(use-package haskell
  :hook (haskell-mode . haskell-doc-mode))

;; lispyville
(use-package lispyville
  :diminish lispyville-mode
  :custom (lispyville-key-theme
           '(operators
             slurp/barf-lispy
             c-w
             additional
             text-objects
             commentary))
  :hook ((lisp-mode
          emacs-lisp-mode
          ielm-mode
          scheme-mode
          clojure-mode)
         . lispyville-mode))

;; scheme
(use-package geiser
  :hook ((scheme-mode . geiser-mode)
         (geiser-mode . geiser)))
