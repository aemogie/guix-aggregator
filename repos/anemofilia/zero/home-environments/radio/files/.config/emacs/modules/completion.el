;; -*- lexical-binding: t; -*-

(use-package marginalia
  :init (marginalia-mode))

(use-package orderless
  :custom
  (orderless-matching-styles '(orderless-initialism orderless-flex))
  (completion-styles '(orderless basic))
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
  (after-init . vertico-multiform-mode)
  (minibuffer-setup . cursor-intangible-mode)
  :bind (:map vertico-map
              ("C-j" . vertico-next)
              ("C-k" . vertico-previous)
              ("C-f" . vertico-exit))
  :bind (:map minibuffer-local-map
              ("C-<backspace>" . my/minibuffer-backward-kill))

  :init
  (vertico-mode))

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
  :init
  (defun anemofilia/add-cape-completions ()
    "Add cape completion functions to complete-at-point-functions."
    (dolist (function '(cape-file
                        cape-tex
                        cape-dabbrev
                        cape-keyword
                        cape-elisp-block
                        cape-elisp-symbol))
      (add-to-list 'completion-at-point-functions #'function)))
  (dolist (mode '(text-mode-hook
                  prog-mode-hook
                  conf-mode-hook))
    (add-hook mode #'anemofilia/add-cape-completions)))
