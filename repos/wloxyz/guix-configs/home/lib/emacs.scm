(define-module (lib emacs)
  #:use-module (gnu packages emacs)
  #:use-module (nongnu packages emacs)
  #:use-module (gnu packages emacs-xyz)
  #:use-module (gnu packages guile-xyz)
  #:use-module (wlo packages emacs-xyz)
  ;; #:use-module (nebula packages emacs)
  #:export (wlo-emacs-packages))

(define wlo-emacs-packages
  (list
   emacs-pgtk-xwidgets                 ; the big emacs package
   
   emacs-no-littering
   emacs-pdf-tools
   emacs-meow
   emacs-beacon
   emacs-avy
   emacs-eat
   emacs-rainbow-delimiters
   emacs-prism ; currently not really using this but i want to in the future
   emacs-smartparens
   emacs-app-launcher
   emacs-vertico
   emacs-marginalia
   emacs-company
   emacs-company-lsp
   emacs-embark
   emacs-orderless
   emacs-mood-line
   emacs-org-roam
   emacs-org-roam-ui                   ; requires nonguix
   emacs-magit
   emacs-ef-themes
   emacs-elcord                        ; from my repo, useless garbage
   emacs-pass
   emacs-password-store
   emacs-password-store-otp
   emacs-guix
   emacs-debbugs                       ; tracking for guix bugs
   emacs-envrc                         ; direnv integration
   emacs-geiser
   emacs-geiser-guile
   emacs-flycheck-guile
   ;; allegedly this offers a better guile ide experience
   ;; emacs-arei
   ;; guile-ares-rs
   emacs-yasnippet
   emacs-yasnippet-snippets
   ;; emacs-yasnippet-capf
   emacs-nerd-icons
   ;; emacs-nerd-icons-completion         ; from nebula
   emacs-expand-region
   ;; emacs-cape
   emacs-sly
   emacs-sly-asdf
   emacs-sly-macrostep
   ;; emacs-sly-package-inferred ; breaks when loading a repl
   ;; emacs-tree-sitter-langs ; broken 2024-10-06
   emacs-php-mode
   emacs-composer
   emacs-elfeed
   emacs-elfeed-org
   emacs-elfeed-tube                   ; from my repo
   emacs-elfeed-tube-mpv               ; ditto
   emacs-gptel
   emacs-base16-theme
   emacs-rainbow-mode
   emacs-vundo
   emacs-yaml-mode
   emacs-gcmh
   emacs-ligature
   emacs-olivetti
   emacs-org-modern
   emacs-nftables-mode
   emacs-markdown-mode
   emacs-dashboard
   emacs-0x0                           ; pastebin (shoutouts mia)
   emacs-dirvish
   emacs-circe
   emacs-ultra-scroll
   ))
 
