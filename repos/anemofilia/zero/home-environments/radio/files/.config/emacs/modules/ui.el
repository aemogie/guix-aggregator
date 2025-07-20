;; -*- lexical-binding: t; -*-

(use-package marginalia
  :hook (on-first-input . marginalia-mode))

(use-package orderless
  :custom
  (orderless-matching-styles
   '(orderless-initialism orderless-flex))
  (completion-styles
   '(orderless basic))
  :config
  (defun orderless-fast-dispatch (word index total)
    (and (= index 0) (= total 1) (length< word 4)
         (cons 'orderless-literal-prefix word)))

  (orderless-define-completion-style orderless-fast
    (orderless-style-dispatchers '())
    (orderless-matching-styles '(orderless-flexg orderless-regexp))))

(use-package vertico
  :custom
  (vertico-multiform-commands
   '((imenu buffer)))
  (vertico-buffer-display-action
   '(display-buffer-in-direction
     (direction . left)
     (window-width . 0.3)))
  (vertico-buffer-hide-prompt t)
  (vertico-cycle nil)
  (vertico-scroll-margin 1)
  (minibuffer-prompt-properties
   (apply #'append '((read-only t)
                     (cursor-intangible t)
                     (face minibuffer-prompt))))
  :preface
  (defun anemofilia/minibuffer-backward-kill (arg)
    "When minibuffer is completing a file name delete up to parent
    folder, otherwise delete a word"
    (interactive "p")
    (if minibuffer-completing-file-name
        (if (string-match-p "/." (minibuffer-contents))
            (zap-up-to-char (- arg) ?/)
          (delete-minibuffer-contents))
      (kill-word (- arg))))
  :hook
  (on-first-input . vertico-multiform-mode)
  (minibuffer-setup . cursor-intangible-mode)
  :bind (:map vertico-map
              ("C-j" . vertico-next)
              ("C-k" . vertico-previous)
              ("C-f" . vertico-exit))
  :bind (:map minibuffer-local-map
              ("C-<backspace>" . my/minibuffer-backward-kill))
  :init (vertico-mode))

(use-package corfu
  :preface
  (defun corfu-enable-in-minibuffer ()
    "Enable Corfu in the minibuffer if `completion-at-point' is bound."
    (when (where-is-internal #'completion-at-point
                             (list (current-local-map)))
      (corfu-mode 1)))
  :hook (((conf-mode text-mode prog-mode eshell-mode) . corfu-mode)
         (corfu-mode . corfu-popupinfo-mode)
         (minibuffer-setup . corfu-enable-in-minibuffer))
  :custom
  (corfu-cycle nil)
  (corfu-auto t)
  (corfu-popupinfo-delay '(1.0 . 0.5))
  (corfu-auto-delay 0.2)
  (corfu-auto-prefix 2)
  (corfu-quit-no-match 'separator)
  (corfu-preselect 'valid)
  (corfu-preview-current 'insert)
  :bind (:map corfu-map
              ("C-s" . corfu-quit)
              ("<tab>" . corfu-next)
              ("<backtab>" . corfu-previous)))

(use-package cape
  :custom
  ((abbrev/math-text-lang 'pt)
   (abbrev/math-text-abbrevs-pt
    '(("pa" "podemos assumir")
      ("pd" "por definição")
      ("sse" "se, e somente se,")
      ("ie" "i.e.")
      ("tq" "tal que")
      ("spg" "sem perda de generalidade")
      ("cjto" "conjunto")))
   (abbrev/math-text-abbrevs-en
    '(("wca" "we can assume")
      ("bd" "by definition")
      ("iff" "if, and only if,")
      ("ie" "i.e.")
      ("wlog" "without loss of generality")
      ("st" "such that")
      ("wrt" "with respect to")))
   (abbrev/var-abbrevs
    '(a b c d e f g h j k l m n p q r s t u v w x y z))
   (abbrev/tables
    `((abbrev/math-text-pt-table
       ,(append abbrev/math-text-abbrevs
                (abbrev/compile-var-abbrevs
                 abbrev/var-abbrevs-pt))
       abbrev/math-text-pt-p)
      (abbrev/math-text-en-table
       ,(append abbrev/math-text-abbrevs
                (abbrev/compile-var-abbrevs
                 abbrev/var-abbrevs-en))))))
  :preface
  (defun abbrev/set-math-text-lang ()
    (interactive)
    (when-let* ((key (car (org-collect-keywords '("language")))))
      (setq abbrev/math-text-lang (make-symbol (cadr key)))))

  (defun abbrev/math-text-pt-p ()
    (and (not (texmathp))
         (string= abbrev/math-text-lang 'pt)))

  (defun abbrev/math-text-en-p ()
    (and (not (texmathp))
         (string= abbrev/math-text-lang 'en)))

  (defun abbrev/setup ()
    (require 'abbrev)
    (setq-local local-abbrev-table nil)
    (pcase-dolist (`(,name ,defs ,cond) abbrev/tables)
      (define-abbrev-table name defs :enable-function cond)
      (push (symbol-value name) local-abbrev-table))
    (abbrev-mode +1))

  (defun abbrev/compile-var-abbrevs (abbrevs)
    (mapcar (lambda (s)
              (list (symbol-name s)
                    (format "\\(%s\\)" s)
                    nil
                    :system t))
            abbrevs))

  (defun anemofilia/add-cape-completions ()
    "Add cape completion functions to complete-at-point-functions."
    (dolist (function '(cape-file
                        cape-tex
                        cape-dabbrev
                        cape-keyword
                        cape-elisp-block
                        cape-elisp-symbol))
      (add-to-list 'completion-at-point-functions #'function)))
  :hook ((text-mode prog-mode conf-mode) . anemofilia/add-cape-completions))

(use-package anzu
  :diminish anzu-mode
  :bind
  (([remap query-replace] . anzu-query-replace)
   ([remap query-replace-regexp] . anzu-query-replace-regexp)
   :map isearch-mode-map
   ([remap isearch-query-replace] . anzu-isearch-query-replace)
   ([remap isearch-query-replace-regexp] . anzu-isearch-query-replace-regexp))
  :hook (on-first-input . global-anzu-mode))

(use-package helpful
  :custom
  (help-select-window t)
  :bind
  (("C-h f" . helpful-callable)
   ("C-h v" . helpful-variable)
   ("C-h k" . helpful-key)
   ("C-h C-." . helpful-at-point)))

(provide 'anemofilia/ui)
