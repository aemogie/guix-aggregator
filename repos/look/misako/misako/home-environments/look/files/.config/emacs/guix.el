(custom-set-variables
  '(safe-local-variable-directories
     '("/home/look/projects/guile/guix/master/"
       "/home/look/projects/guile/nonguix/")))
(custom-set-faces)

(with-eval-after-load 'yasnippet
  (add-to-list 'yas-snippet-dirs "~/projects/guile/guix/etc/snippets/yas"))

(load-file "~/projects/guile/guix/master/etc/copyright.el")

(setq copyright-names-regexp
  (format "%s <%s>" user-full-name user-mail-address))

(add-hook 'after-save-hook 'copyright-update)

(add-hook 'git-commit-mode-hook 'yas-minor-mode)
