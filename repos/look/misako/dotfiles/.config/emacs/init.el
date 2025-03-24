(setq user-emacs-directory "~/.config/emacs")
(load-file "~/.config/emacs/debbugs.el")
(load-file "~/.config/emacs/guix.el")
(load-file "~/.config/emacs/meow.el")

(setq user-full-name "{{{ aerc.primary.name }}}")
(setq user-mail-address "{{{ aerc.primary.email }}}")

(which-key-mode 1)
(menu-bar-mode 0)
(vertico-mode 1)

(load-theme 'modus-operandi :no-confirm)
;; (load-theme 'modus-vivendi :no-confirm)
