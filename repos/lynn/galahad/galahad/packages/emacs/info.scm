(define-module (galahad packages emacs info)
  #:use-module(guix gexp)
  #:export(emacs-files)
  #:export(emacs-packages))

(define (emacs-packages)
  (list

;; quality of life stuff
emacs-ivy
emacs-swiper
emacs-counsel
emacs-which-key
emacs-projectile

;; theme
emacs-gruvbox-theme

;; in guix, emacs packages start with emacs-
emacs-org-auto-tangle

;; org-mode specific guix packages
emacs-org-modern
emacs-olivetti
emacs-mixed-pitch

;; LSP
emacs-eglot
emacs-jsonrpc

;; guix manifest.scm files
emacs-buffer-env

;; IDE
emacs-treemacs
emacs-treemacs-extra ;; treemacs-projectile
emacs-imenu-list

;; epilogue
))
