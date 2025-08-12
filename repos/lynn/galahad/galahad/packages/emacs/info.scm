(define-module (galahad packages emacs info)
  #:use-module(guix gexp)
  #:use-module(gnu packages emacs)
  #:use-module(gnu packages emacs-xyz)
  #:export(emacs-files)
  #:export(emacs-packages))

(define (emacs-files)
`(
  (".config/emacs/init.el" ,(local-file "init.el"))))

(define (emacs-packages)
  (list emacs-pgtk

;; quality of life stuff
emacs-ivy
emacs-swiper
emacs-counsel
emacs-which-key
emacs-projectile

;; theme
emacs-gruvbox-theme

;; font
emacs-ligature

;; in guix, emacs packages start with emacs-
emacs-org-auto-tangle

;; org-mode specific guix packages
emacs-org-modern
emacs-olivetti
emacs-mixed-pitch

emacs-org-roam

;; guix manifest.scm files
emacs-buffer-env

;; IDE
emacs-treemacs
emacs-treemacs-extra ;; treemacs-projectile
emacs-imenu-list

emacs-zig-mode

;; modal editing
emacs-meow

;; epilogue
))
