;; -*- lexical-binding: t; -*-
  (defun persp-switcher (n)
    `(lambda ()
       (interactive)
       (persp-switch-by-number ,n)))
  (dotimes (n 7)
    (bind-key (format "<tab> %d" (1+ n))
              (persp-switcher (1+ n))))
    (which-key-add-key-based-replacements
    "<tab> n" "Switch perspective"
    "<tab> d" "Delete perspective")
;; hl-fill-column
;(use-package hl-fill-column
;  :config
;  (set-face-attribute
;   'hl-fill-column-face nil
;   :background (face-attribute 'fill-column-indicator :background)
;   :inverse-video nil)
;  (defun hl-fill-column ()
;    "Highlight all spaces in fill-column."
;    (interactive)
;    (save-excursion
;      (goto-char (point-min))
;      (while (not (eobp))
;        (let ((line-end (line-end-position)))
;          (when (>= line-end)
;            (goto-char (+ (line-beginning-position)
;                          (- fill-column 1)))
;            (overlay-put (make-overlay (- (point) 1) (point))
;                         'font-lock-face
;                         '(face :backgound "blue"))))
;        (forward-line 1)))
;    (font-lock-fontify-buffer))
;  :hook
;  ;;((text-mode prog-mode conf-mode) . hl-fill-column-mode)
;  ((text-mode prog-mode conf-mode) . hl-fill-column)
;  ((text-mode prog-mode conf-mode) . display-fill-column-indicator-mode))

;; (use-package kakoune
;;   ;; Having a non-chord way to escape is important, since key-chords don't work in macros
;;   :bind ("C-z" . ryo-modal-mode)
;;   :hook (after-init . my/kakoune-setup)
;;   :config
;;   (defun ryo-enter () "Enter normal mode" (interactive) (ryo-modal-mode 1))
;;   (defun my/kakoune-setup ()
;;     "Call kakoune-setup-keybinds and then add some personal config."
;;     (kakoune-setup-keybinds)
;;     (setq ryo-modal-cursor-type 'box)
;;     (add-hook 'prog-mode-hook #'ryo-enter)
;;     (define-key ryo-modal-mode-map (kbd "SPC h") 'help-command)
;;     ;; Access all C-x bindings easily
;;     (define-key ryo-modal-mode-map (kbd "z") ctl-x-map)
;;     (ryo-modal-keys
;;      ("," save-buffer)
;;      ("P" counsel-yank-pop)
;;      ("m" mc/mark-next-like-this)
;;      ("M" mc/skip-to-next-like-this)
;;      ("n" mc/mark-previous-like-this)
;;      ("N" mc/skip-to-previous-like-this)
;;      ("M-m" mc/edit-lines)
;;      ("*" mc/mark-all-like-this)
;;      ("v" er/expand-region)
;;      ("C-v" set-rectangular-region-anchor)
;;      ("M-s" mc/split-region)
;;      (";" (("q" delete-window)
;;            ("v" split-window-horizontally)
;;            ("s" split-window-vertically)))
;;      ("C-h" windmove-left)
;;      ("C-j" windmove-down)
;;      ("C-k" windmove-up)
;;      ("C-l" windmove-right)
;;      ("C-u" scroll-down-command :first '(deactivate-mark))
;;      ("C-d" scroll-up-command :first '(deactivate-mark)))))

;;(use-package ryo-modal
;;  :custom (ryo-modal-cursor-color "#9688d9"))

;; This overrides the default mark-in-region with a prettier-looking one,
;; and provides a couple extra commands
;;(use-package visual-regexp
;;  :ryo (("s" vr/mc-mark)
;;        ("?" vr/replace)
;;        ("M-/" vr/query-replace)))
;;
;; Emacs incremental search doesn't work with multiple cursors, but this fixes that
;;(use-package phi-search
;;  :bind (("C-s" . phi-search)
;;         ("C-r" . phi-search-backward)))

;; Probably the first thing you'd miss is undo and redo, which requires an extra package
;; to work like it does in kakoune (and almost every other editor).
;;(use-package undo-tree
;;  :config
;;  (global-undo-tree-mode)
;;  :ryo (("u" undo-tree-undo)
;;        ("U" undo-tree-redo)
;;        ("SPC u" undo-tree-visualize))
;;  :bind (:map undo-tree-visualizer-mode-map
;;              ("h" . undo-tree-visualize-switch-branch-left)
;;              ("j" . undo-tree-visualize-redo)
;;              ("k" . undo-tree-visualize-undo)
;;              ("l" . undo-tree-visualize-switch-branch-right)))
