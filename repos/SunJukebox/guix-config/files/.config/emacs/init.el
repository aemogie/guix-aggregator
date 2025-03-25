(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(when (and custom-file
           (file-exists-p custom-file))
  (load custom-file nil :nomessage))
(load "~/anon/crafted-emacs/modules/crafted-init-config")

;;
;; Packages phase
;;

(require 'crafted-completion-packages)
;; (require 'crafted-ide-packages)
;; (require 'crafted-evil-packages)
;; (require 'crafted-workspaces-packages)
(require 'crafted-lisp-packages)



;; install the packages
(package-install-selected-packages :noconfirm)

;;
;; Configuration phase
;;

(require 'crafted-defaults-config)
;; (require 'crafted-startup-config)

(require 'crafted-completion-config)
;; (require 'crafted-ide-config)
;; (require 'crafted-evil-config)
;; (require 'crafted-workspaces-config)
(require 'crafted-lisp-config)

;; My own settings

(with-eval-after-load 'geiser-guile
  (add-to-list 'geiser-guile-load-path "~/src/guix"))

;; doom-themes
;; Global settings (defaults)
(customize-set-variable 'doom-themes-enable-bold t)    ; if nil, bold is universally disabled
(customize-set-variable 'doom-themes-enable-italic t) ; if nil, italics is universally disabled
(load-theme 'doom-one t)

;; Enable flashing mode-line on errors
(doom-themes-visual-bell-config)
;; Enable custom neotree theme (all-the-icons must be installed!)
(doom-themes-neotree-config)
;; or for treemacs users
(customize-set-variable 'doom-themes-treemacs-theme "doom-atom") ; use "doom-colors" for less minimal icon theme
(doom-themes-treemacs-config)
;; Corrects (and improves) org-mode's native fontification.
(doom-themes-org-config)
