(setq user-emacs-directory "~/.config/emacs")
(load-file "~/.config/emacs/debbugs.el")
(load-file "~/.config/emacs/guix.el")
(load-file "~/.config/emacs/meow.el")
; (load-file "~/.config/emacs/eaf.el")

(setq user-full-name "{{{ aerc.primary.name }}}")
(setq user-mail-address "{{{ aerc.primary.email }}}")

;; Disable scroll bars on all frames
(add-to-list 'default-frame-alist
             '(vertical-scroll-bars . nil))
(scroll-bar-mode -1)

(which-key-mode 1)
(menu-bar-mode 0)
(tool-bar-mode -1)
(vertico-mode 1)

(load-theme 'modus-operandi :no-confirm)
;; (load-theme 'modus-vivendi :no-confirm)
