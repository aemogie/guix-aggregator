;;; math.el --- Configuration File for Math in Emacs --- -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

;;; Proof General (Coq, et.al)
(use-package proof-general
  :straight t
  :defer t)

;;; Lean4

;; (use-package lsp-mode
;;   :straight t
;;   :defer t)

;; (use-package lean4-mode
;;   :defer t
;;   :commands lean4-mode
;;   :straight (lean4-mode :type git :host github
;;                         :repo "leanprover/lean4-mode"
;;                         :files ("*.el" "data")))

(add-to-list 'exec-path "/home/divya/.elan/bin/")

(provide 'math)
;;; math.el ends here
