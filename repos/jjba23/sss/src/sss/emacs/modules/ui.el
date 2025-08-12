;;; ui.el --- SSS configuration for Emacs -*- lexical-binding: t -*-

;; Copyright © Josep Bigorra <jjbigorra@gmail.com>

;; sss is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; sss is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with sss.  If not, see <https://www.gnu.org/licenses/>.

;;; Commentary:

;; UI configuration for Emacs

;;; Code:

(use-package pulsar
  :ensure t
  :custom
  (pulsar-pulse t)
  (pulsar-delay 0.055)
  (pulsar-iterations 10)
  (pulsar-highlight-face 'pulsar-yellow)
  :config
  (cond ((equal sss-emacs-theme 'ef-dream) (setq pulsar-face 'pulsar-magenta))
        ((equal sss-emacs-theme 'everforest-hard-dark) (setq pulsar-face 'pulsar-green))
        ((equal sss-emacs-theme 'everforest-hard-light) (setq pulsar-face 'pulsar-green))
        (t (setq pulsar-face 'pulsar-green)))
  (pulsar-global-mode 1)
  (ignore-errors
    (add-hook 'consult-after-jump-hook #'pulsar-recenter-top)
    (add-hook 'consult-after-jump-hook #'pulsar-reveal-entry)))

(use-package olivetti
  :ensure t)

(use-package tekengrootte
  :ensure (:host codeberg :repo "jjba23/tekengrootte.el" :branch "trunk")
  :demand t
  :bind (("C-c f c" . tekengrootte-set-scale-colossal)
         ("C-c f j" . tekengrootte-set-scale-jumbo)
         ("C-c f x" . tekengrootte-set-scale-larger)
         ("C-c f l" . tekengrootte-set-scale-large)
         ("C-c f r" . tekengrootte-set-scale-regular)
         ("C-c f s" . tekengrootte-set-scale-small)
         ("C-c f t" . tekengrootte-set-scale-tiny)
	       ("C-c f n" . tekengrootte-set-scale-nano))
  :hook ((tekengrootte-set-scale . (lambda ()
                                     (sss-set-base-faces))))
  :after (ef-themes solarized-theme gruvbox-theme)
  :config
  (defun sss-set-base-faces ()
    "Adjust the base Emacs faces to my preferences.
According to size, color and font family"
    (interactive)

    (set-face-attribute 'default nil
		                    :height (round (tekengrootte-mk-font-size 114))
		                    :font sss-font-mono)

    (ignore-errors
      (set-face-attribute 'mode-line nil
                          :box `(:line-width 3 :color ,(face-attribute 'mode-line :background))
		                      :height (tekengrootte-mk-font-size 0.7)
		                      :font sss-font-sans))
    (ignore-errors
      (set-face-attribute 'mode-line-active nil
                          :box `(:line-width 3 :color ,(face-attribute 'mode-line :background))
		                      :height (tekengrootte-mk-font-size 0.7)
		                      :font sss-font-sans))
    (ignore-errors
      (set-face-attribute 'mode-line-inactive nil
                          :box `(:line-width 3 :color ,(face-attribute 'mode-line-inactive :background))
		                      :height (tekengrootte-mk-font-size 0.7)
		                      :font sss-font-sans))

    (set-face-attribute 'variable-pitch nil
		                    :font sss-font-sans
                        :height (tekengrootte-mk-font-size 1.05))

    (set-face-attribute 'button nil :background 'unspecified
                        :weight 'bold)

    (set-face-attribute 'font-lock-doc-face nil
                        :foreground (ef-themes-get-color-value 'yellow-faint))

    (ignore-errors
      (set-face-attribute 'markdown-pre-face nil
		                      :font sss-font-mono
                          :height (tekengrootte-mk-font-size 0.95))
      (set-face-attribute 'markdown-code-face nil
		                      :font sss-font-mono
                          :height (tekengrootte-mk-font-size 0.95))
      (set-face-attribute 'markdown-inline-code-face nil
		                      :font sss-font-mono
                          :height (tekengrootte-mk-font-size 0.95))
      (set-face-attribute 'markdown-header-face-1 nil
                          :font sss-font-sans
                          :weight 'bold
		                      :height (tekengrootte-mk-font-size 1.2))
      (set-face-attribute 'markdown-header-face-2 nil
                          :font sss-font-sans
                          :weight 'bold
		                      :height (tekengrootte-mk-font-size 1.2))
      (set-face-attribute 'markdown-header-face-3 nil
                          :font sss-font-sans
                          :weight 'bold
		                      :height (tekengrootte-mk-font-size 1.1))
      (set-face-attribute 'markdown-header-face-4 nil
                          :font sss-font-sans
                          :weight 'bold
		                      :height (tekengrootte-mk-font-size 1.1))
      (set-face-attribute 'markdown-header-face-5 nil
                          :font sss-font-sans
                          :weight 'bold
		                      :height (tekengrootte-mk-font-size 1.0)))

    (ignore-errors
      (set-face-attribute 'org-table nil
		                      :height (tekengrootte-mk-font-size 1.05)
		                      :font sss-font-mono)
      (set-face-attribute 'org-default nil
		                      :height (tekengrootte-mk-font-size 1.05)
		                      :font sss-font-mono)
      (set-face-attribute 'org-block nil
		                      :font sss-font-mono
                          :height (tekengrootte-mk-font-size 0.95))
      (set-face-attribute 'org-code nil
		                      :font sss-font-mono
                          :height (tekengrootte-mk-font-size 0.95))
      (set-face-attribute 'org-verbatim nil
		                      :font sss-font-mono
                          :height (tekengrootte-mk-font-size 1.05))
      (set-face-attribute 'org-document-title nil
		                      :height (tekengrootte-mk-font-size 1.2))
      (set-face-attribute 'org-level-1 nil
                          :font sss-font-sans
                          :weight 'bold
		                      :height (tekengrootte-mk-font-size 1.2))
      (set-face-attribute 'org-level-2 nil
                          :font sss-font-sans
                          :weight 'bold
		                      :height (tekengrootte-mk-font-size 1.2))
      (set-face-attribute 'org-level-3 nil
                          :font sss-font-sans
                          :weight 'bold
		                      :height (tekengrootte-mk-font-size 1.1))
      (set-face-attribute 'org-level-4 nil
                          :font sss-font-sans
                          :weight 'bold
		                      :height (tekengrootte-mk-font-size 1.1))
      (set-face-attribute 'org-level-5 nil
                          :font sss-font-sans
                          :weight 'bold
		                      :height (tekengrootte-mk-font-size 1.0)))
    (ignore-errors
      (set-face-attribute 'keycast-key nil
		                      :font sss-font-mono
                          :background 'unspecified
                          :box nil
                          :height (tekengrootte-mk-font-size 0.8))
      (set-face-attribute 'keycast-command nil
		                      :font sss-font-sans
                          :height (tekengrootte-mk-font-size 0.8)))

    ;;
    ;; ====== Theme specific tweaks ======
    ;;

    ;; ====== Ef theme specific tweaks =============
    (when (string-prefix-p "ef-" (format "%s" sss-emacs-theme))
      (ignore-errors
        (set-face-attribute 'window-divider nil
                            :foreground (ef-themes-get-color-value 'bg-dim)
                            :background (ef-themes-get-color-value 'bg-dim))))

    ;; ======= Gruvbox specific tweaks ===========

    (when (equal sss-emacs-theme 'gruvbox-light-hard)
      (ignore-errors
        (set-face-attribute 'internal-border nil
                            :background "#f9f5d7")))

    (when (equal sss-emacs-theme 'gruvbox-dark-hard)
      (ignore-errors
        (set-face-attribute 'internal-border nil
                            :background "#1d2021")))

    ;; ====== Dracula specific tweaks ======
    (when (equal sss-emacs-theme 'dracula)
      (ignore-errors
        (set-face-attribute 'font-lock-comment-face nil
                            :italic t)
        (set-face-attribute 'font-lock-variable-use-face nil
                            :bold nil)
        (set-face-attribute 'font-lock-variable-name-face nil
                            :bold nil)
        (set-face-attribute 'mode-line nil
                            :box `(:line-width 3 :color "#44475a")
                            :background "#44475a")
        (set-face-attribute 'mode-line-active nil
                            :box `(:line-width 3 :color "#44475a")
                            :background "#44475a")
        (set-face-attribute 'mode-line-inactive nil
                            :box `(:line-width 3 :color "#282a36")
                            :background "#282a36")
        (set-face-attribute 'window-divider nil
                            :background "#6272a4"
                            :foreground "#6272a4")))


    ;; ====== Everforest dark specific tweaks ======
    (ignore-errors
      (cond ((equal sss-emacs-theme 'everforest-hard-dark)
             (progn
               (set-face-attribute 'mode-line nil
                                   :box 'unspecified
                                   :foreground "#2b3339"
                                   :background "#96b070")
               (set-face-attribute 'mode-line-active nil
                                   :box 'unspecified
                                   :foreground "#2b3339"
                                   :background "#96b070")
               (set-face-attribute 'dired-directory nil
                                   :inherit '(font-lock-string-face))))))

    ;; ====== Everforest light specific tweaks ======
    (ignore-errors
      (cond ((equal sss-emacs-theme 'everforest-hard-light)
             (progn
               (set-face-attribute 'mode-line nil
                                   :box 'unspecified
                                   :foreground "#2b3339"
                                   :background "#96b070")
               (set-face-attribute 'mode-line-active nil
                                   :box 'unspecified
                                   :foreground "#2b3339"
                                   :background "#96b070")
               (set-face-attribute 'dired-directory nil
                                   :inherit '(font-lock-string-face))))))
    )

  (setq sss-emacs-is-first-frame t)

  (defun new-frame-setup ()
    (progn
	    (when sss-emacs-is-first-frame
        (progn
          (message "initializing SSS UI scaling for first frame")
          (tekengrootte-set-scale-small)
          (setq sss-emacs-is-first-frame nil)))
      (sss-set-base-faces)))
  
  (add-hook 'server-after-make-frame-hook 'new-frame-setup))

(use-package nerd-icons :ensure t)

(use-package nerd-icons-completion
  :ensure t
  :after (nerd-icons marginalia)
  :hook ((marginalia-mode . nerd-icons-completion-marginalia-setup))
  :config (nerd-icons-completion-mode))

(use-package spacious-padding
  :ensure (:host github :repo "protesilaos/spacious-padding" :branch "main")
  :init
  (setq spacious-padding-widths
        '( :internal-border-width 18
           :header-line-width 2
           :mode-line-width 2
           :tab-width 4
           :right-divider-width 2
           :scroll-bar-width 8
           :left-fringe-width 16
           :right-fringe-width 16))
  (setq spacious-padding-subtle-mode-line nil)
  :config
  (spacious-padding-mode))

(use-package svg-lib
  :ensure (:host github :repo "rougier/svg-lib" :branch "master"))

(use-package kind-icon
  :ensure (:host github :repo "jdtsmith/kind-icon" :branch "main")
  :after corfu
  :config
  (add-to-list 'corfu-margin-formatters #'kind-icon-margin-formatter))

(use-package modusregel
  :ensure (:host codeberg :repo "jjba23/modusregel" :branch "trunk")
  :demand t
  :after (keycast)
  :config
  (add-to-list 'modusregel-format '("" keycast-mode-line) t)
  (setq-default mode-line-format modusregel-format))

(use-package keycast
  :ensure t
  :demand t
  :after (tekengrootte)
  :config
  (define-minor-mode keycast-mode
    "Show current command and its key binding in the mode line."
    :global t
    (if keycast-mode
	(add-hook 'pre-command-hook 'keycast--update t)
      (remove-hook 'pre-command-hook 'keycast--update)))
  (ignore-errors (keycast-mode)))


(use-package vertico
  :ensure t
  :init
  (setq vertico-cycle t
        vertico-resize t)
  :after (compat)
  :config
  (vertico-mode))

(use-package marginalia
  :ensure t
  :after (vertico compat)
  :config (marginalia-mode))


(use-package ultra-scroll
  :ensure (:host github :repo "jdtsmith/ultra-scroll" :branch "main")
  :init
  (setq scroll-conservatively 101 ; important!
        scroll-margin 0)
  :config
  (ultra-scroll-mode 1))

(use-package embark
  :ensure (:host github :repo "oantolin/embark" :branch "master")
  :bind
  (("C-." . embark-act)         ;; pick some comfortable binding
   ("C-;" . embark-dwim)        ;; good alternative: M-.
   ("C-h B" . embark-bindings)) ;; alternative for `describe-bindings'
  :init
  ;; Optionally replace the key help with a completing-read interface
  (setq prefix-help-command #'embark-prefix-help-command)

  ;; Add Embark to the mouse context menu. Also enable `context-menu-mode'.
  (context-menu-mode 1)
  (add-hook 'context-menu-functions #'embark-context-menu 100)
  :config
  ;; Hide the mode line of the Embark live/completions buffers
  (add-to-list 'display-buffer-alist
               '("\\`\\*Embark Collect \\(Live\\|Completions\\)\\*"
                 nil
                 (window-parameters (mode-line-format . none)))))

(use-package embark-consult
  :ensure (:host github :repo "oantolin/embark" :branch "master")
  :hook
  (embark-collect-mode . consult-preview-at-point-mode))

(provide 'sss/ui)

;;; ui.el ends here
