;; (load-theme 'modus-operandi :no-confirm)
(setq catppuccin-flavor 'mocha)
(load-theme 'catppuccin :no-confirm)
;; (load-theme 'modus-vivendi :no-confirm)

(set-face-attribute 'default nil :height 130)

;; Disable annoying bars on the sides
(fringe-mode -1)

(menu-bar-mode 0)
(tool-bar-mode -1)

;; Disable blinking cursor
(blink-cursor-mode 0)

;; Disable line width overflow changing color
(custom-set-faces
 '(whitespace-line ((t nil))))

(setq whitespace-display-mappings
      '((space-mark    ?\   [?⋅])
        (newline-mark  ?\n  [?↩ ?\n])
        (tab-mark      ?\t  [?→ ?\t])))

;; Disable scroll bars on all frames
(add-to-list 'default-frame-alist
             '(vertical-scroll-bars . nil))
(scroll-bar-mode -1)

(add-hook 'prog-mode-hook #'whitespace-mode)

(setq tab-bar-close-button-show nil)
(setq tab-bar-new-button-show nil)

