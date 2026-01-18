;;; tex-config.el --- Provides and changes how I want to work with TeX-based docs -*- lexical-binding: t -*-
;;; Commentary:
;;
;; Auctex provides many QoL things for editing TeX/LaTeX documents
;; However, it also defaults to the BibTeX citation database. BibTeX
;; is fairly old, so I prefer to use BibLaTeX instead. To go along
;; with BibLaTeX, I use Biber as the backend citation and
;; cross-referencing manager.
;;
;;; Code:

;; https://karthinks.com/software/latex-input-for-impatient-scholars/#
;; https://speckhofer.github.io/posts/latex-auto-activating-snippets-in-emacs/

;; This elisp code uses use-package, a macro to simplify configuration. It will
;; install it if it's not available, so please edit the following code as
;; appropriate before running it.

;; Note that this file does not define any auto-expanding YaSnippets.

(require 'tex-mode)

(use-package auctex
  :init
  ;; Force auctex (the strictly superior (La)TeX major-mode) to be used by setting
  ;; both the auto-mode-alist and remapping the built-in latex-mode and tex-mode
  ;; major modes to the auctex versions.
  (add-to-list 'auto-mode-alist '("\\.tex\\'" . LaTeX-mode))
  (add-to-list 'major-mode-remap-alist '(latex-mode . LaTeX-mode))
  (add-to-list 'major-mode-remap-alist '(tex-mode . TeX-mode))
  :hook
  (;;(LaTeX-mode . turn-on-auto-fill)
   (LaTeX-mode . LaTeX-math-mode))
  :custom
  (TeX-parse-self t) ;; Parse multifile documents automagically
  (TeX-auto-save t) ;; Enables parsing upon saving the document
  (TeX-show-compilation nil) ;; Always show compilation output
  (TeX-global-PDF-mode t) ;; Make the default TeX mode PDF mode
  (TeX-command-default "pdflatex") ;; Default compile to PDF
  ;; (LaTeX-biblatex-use-Biber t) ;; Make biblatex use Biber automatically
  (TeX-electric-sub-and-superscript t) ;; Inserts {} automaticly on _ and ^
  (TeX-source-correlate-mode t) ;; Correlate output to input so we can easily navigate
  (TeX-source-correlate-method 'synctex)
  (TeX-source-correlate-start-server t))

;; CDLatex settings
(use-package cdlatex
  ;; :ensure t
  :hook (LaTeX-mode . turn-on-cdlatex)
  :bind (:map cdlatex-mode-map
              ("<tab>" . cdlatex-tab))
  :config
  (define-key LaTeX-mode-map "'" nil)
  (define-key cdlatex-mode-map "'" nil)
  :custom
  (cdlatex-math-modify-prefix ?\#)
  (cdlatex-math-symbol-prefix ?\;)
  (cdlatex-sub-super-scripts-outside-math-mode nil))

;; Automatic snippet settings
(use-package aas
  :hook ((LaTeX-mode . aas-activate-for-major-mode)
         (org-mode . aas-activate-for-major-mode))
  :config
  (aas-set-snippets 'text-mode
    ;; expand unconditionally
        "mk" (lambda () (interactive)
         (yas-expand-snippet "\\\\($0\\\\)"))
        "dm" (lambda () (interactive)
         ;; (yas-expand-snippet "\\begin{equation*}\n  $0\n\\end{equation*}"))
         ;; alternative snippet:
         (yas-expand-snippet "\\[\n  $0\n\\]"))
        ;; "alig" (lambda () (interactive)
        ;;   (yas-expand-snippet "\\begin{align*}\n  $0\n\\end{align*}"))
        ;; "eqn" (lambda () (interactive)
        ;;   (yas-expand-snippet "\\begin{equation}\n  $0\n\\end{equation}"))
        ;; "cite" (lambda () (interactive)
        ;;   (yas-expand-snippet "\\cite{$0}"))
        ;; "cref" (lambda () (interactive)
        ;;   (yas-expand-snippet "\\Cref{$0}"))
        ;; "eqref" (lambda () (interactive)
        ;;   (yas-expand-snippet "~\\eqref{$0}"))
        ;; "latex"  "\\LaTeX"
        "TEMPLATE" (lambda () (interactive)
                      (yas-expand-snippet "\\documentclass[12pt,a4paper]{article}\n\n\\usepackage{~/.local/share/tex/onghaik}\n\n\begin{document}\n\n$0\n\n\\end{document}"))))

(use-package laas
  :load-path "plugins/"
  :hook ((LaTeX-mode . laas-mode)
         (org-mode . laas-mode))
  :config
  (aas-set-snippets 'laas-mode
    :cond #'texmathp ; expand only while in math. You can add some snippets here.
    "+dint" (lambda () (interactive)
            (yas-expand-snippet "\\int_{$1}^{$2} $0"))))

;; CDLatex integration with YaSnippet: Allow cdlatex tab to work inside Yas
;; fields
(use-package cdlatex
  :hook ((cdlatex-tab . yas-expand)
         (cdlatex-tab . cdlatex-in-yas-field))
  :config
  (use-package yasnippet
    :bind (:map yas-keymap
           ("<tab>" . yas-next-field-or-cdlatex)
           ("TAB" . yas-next-field-or-cdlatex))
    :config
    (defun cdlatex-in-yas-field ()
      ;; Check if we're at the end of the Yas field
      (when-let* ((_ (overlayp yas--active-field-overlay))
                  (end (overlay-end yas--active-field-overlay)))
        (if (>= (point) end)
            ;; Call yas-next-field if cdlatex can't expand here
            (let ((s (thing-at-point 'sexp)))
              (unless (and s (assoc (substring-no-properties s)
                                    cdlatex-command-alist-comb))
                (yas-next-field-or-maybe-expand)
                t))
          ;; otherwise expand and jump to the correct location
          (let (cdlatex-tab-hook minp)
            (setq minp
                  (min (save-excursion (cdlatex-tab)
                                       (point))
                       (overlay-end yas--active-field-overlay)))
            (goto-char minp) t))))

    (defun yas-next-field-or-cdlatex nil
      (interactive)
      "Jump to the next Yas field correctly with cdlatex active."
      (if
          (or (bound-and-true-p cdlatex-mode)
              (bound-and-true-p org-cdlatex-mode))
          (cdlatex-tab)
        (yas-next-field-or-maybe-expand)))))

;; Make cdlatex play nice inside org tables
(use-package lazytab
  :load-path "plugins/"
  :bind (:map orgtbl-mode-map
              ("<tab>" . lazytab-org-table-next-field-maybe)
              ("TAB" . lazytab-org-table-next-field-maybe))
  :after cdlatex
  :demand t
  :config
  (add-hook 'cdlatex-tab-hook #'lazytab-cdlatex-or-orgtbl-next-field 90)
  (dolist (cmd '(("smat" "Insert smallmatrix env"
                  "\\left( \\begin{smallmatrix} ? \\end{smallmatrix} \\right)"
                  lazytab-position-cursor-and-edit
                  nil nil t)
                 ("bmat" "Insert bmatrix env"
                  "\\begin{bmatrix} ? \\end{bmatrix}"
                  lazytab-position-cursor-and-edit
                  nil nil t)
                 ("pmat" "Insert pmatrix env"
                  "\\begin{pmatrix} ? \\end{pmatrix}"
                  lazytab-position-cursor-and-edit
                  nil nil t)
                 ("tbl" "Insert table"
                  "\\begin{table}\n\\centering ? \\caption{}\n\\end{table}\n"
                  lazytab-position-cursor-and-edit
                  nil t nil)))
    (push cmd cdlatex-command-alist))
  (cdlatex-reset-mode))

(use-package auctex-latexmk
  :defer t
  :after auctex)

(provide 'tex-config)
;;; anon-latex-config.el ends here
