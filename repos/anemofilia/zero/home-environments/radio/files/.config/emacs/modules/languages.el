;; -*- lexical-binding: t; -*-

(use-package haskell
  :hook (haskell-mode . haskell-doc-mode))

(use-package lispy
  :diminish lispy-mode
  :custom
  (lispy-key-theme
   '(operators
     slurp/barf-lispy
     c-w
     additional
     text-objects
     commentary))
  :hook
  ((lisp-mode
    emacs-lisp-mode
    ielm-mode
    scheme-mode
    clojure-mode)
   . lispy-mode))

(use-package geiser
  :hook ((scheme-mode . geiser-mode)
         (scheme-mode . eros-mode)
         (scheme-mode . geiser-eros-mode)))

(use-package rainbow-delimiters
  :hook ((text-mode prog-mode conf-mode) . rainbow-delimiters-mode))

(use-package whitespace
  :diminish whitespace-mode
  :custom ((whitespace-display-mappings
            '((space-mark    ?\   [?⋅])
              ;; fix strange behaviour with hl-fill-column-mode
              (newline-mark  ?\n  [?¬ ?\n])
              (tab-mark      ?\t  [?→ ?\t]))))
  :hook ((text-mode prog-mode conf-mode) . whitespace-mode))
