;;; treesit-config.el --- Configuration for Treesitter  -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:

(require 'os-detection)

;; Fetch and use the treesit package (which is built INTO Emacs) when Emacs is
;; built with tree-sitter support, which requires Emacs to be >29 AND be
;; configured with:
;; ./configure --with-tree-sitter.
;; We first check the version of Emacs before going on and potentially loading
;; treesit & its changing the major-mode-remap-alist.
(use-package treesit
  :ensure nil ;; built-in
  :when (and (>= emacs-major-version 29)
             (treesit-available-p)
             (getenv "TREE_SITTER_GRAMMAR_PATH"))
  :init
  ;; I use Guix Home to install tree-sitter grammars for programming which, by the
  ;; nature of its functional package-management system, will install these shared
  ;; objects into a particular location within the Guix store, which is then
  ;; exposed with an environment variable.
  ;; When I am on a Guix-based system, assume I am using Guix Home and add the
  ;; store path to Emacs' understanding of the tree-sitter module load path.
  (when (onghaik/is-guix-system)
    (setq treesit-extra-load-path
          (append (split-string (getenv "TREE_SITTER_GRAMMAR_PATH") ":")
                  treesit-extra-load-path)))

  (setq major-mode-remap-alist
        '(;; (yaml-mode . yaml-ts-mode)
          ;; (conf-toml-mode . toml-ts-mode)
          ;; TODO: Add mermaid-tree-sitter to Guix and add to my home env!
          ;; (mermaid-mode . mermaid-ts-mode)
          ;; (bash-mode . bash-ts-mode)
          ;; (c-mode . c-ts-mode)
          ;; (c++-mode . c++-ts-mode)
          ;; (c-or-c++-mode . c-or-c++-ts-mode)
          ;; (go-mode . go-ts-mode)
          ;; (js2-mode . js-ts-mode)
          ;; (typescript-mode . typescript-ts-mode)
          ;; (json-mode . json-ts-mode)
          ;; (css-mode . css-ts-mode)
          (python-mode . python-ts-mode))))
          ;; (verilog-mode . verilog-ts-mode)
          ;; (vhdl-mode . vhdl-ts-mode)
          ;; (rust-mode . rust-ts-mode)
          ;; (scala-mode . scala-ts-mode)
          ;; (ada-mode . ada-ts-mode)
          ;; (gpr-mode . gpr-ts-mode))))

;; Bring paredit-like functionality to every programming language!
(use-package tree-edit
  :ensure t
  :defer t)

(provide 'treesit-config)
;;; treesit-config.el ends here

(provide 'treesit-config)
;;; treesit-config.el ends here
