;;; yasnippet-config.el --- Provides and configure yasnippet -*- lexical-binding: t -*-
;;; Commentary:
;;
;; This provides the yasnippet package, which allows me to auto-generate a certain control flow.
;; It can be a loop, a conditional, whatever.  It allows me to quickly and easily insert snippets of text
;; Snippets are expanded by typing enough of it in, and them pressing "<tab>" to enter it.
;; It is important to note that this IS NOT the little dropdown that I get while typing.
;; That's provided by company.  Snippets are predefined in their respective file(s).
;;
;;; Code:

(use-package yasnippet
  :ensure nil
  :defer t
  :bind (:map yas-minor-mode-map
         ;; If there was a menu for selecting snippets, provide an escape route
         ("<escape>" . #'yas-exit-snippet))
  :config
  (yas-reload-all)
  (yas-global-mode 1)
  (defvar yas-snippet-dirs
    (list (concat user-emacs-directory "snippets") yasnippet-snippets-dir)
    "List of directories to find snippets for the yasnippet package.")
  :custom
  (tab-always-indent 'complete) ;; Tabs indent
  (yas-prompt-functions
   '(yas-completing-prompt ;; List of prompts that yasnippet can go through
     yas-ido-prompt
     yas-dropdown-prompt)))

;;; yasnippet-snippets provides a large amount of snippets for yasnippet to work with.
;;; There are an innumerable amount of snippets for many, many languages.
;;; This provides a good starting set of yasnippet snippets to use for most major modes.

;; (use-package yasnippet-snippets
;;   :after (yasnippet)
;;   :ensure t
;;   :config (yasnippet-snippets-initialize))

(provide 'yasnippet-config)
;;; yasnippet-config.el ends here
