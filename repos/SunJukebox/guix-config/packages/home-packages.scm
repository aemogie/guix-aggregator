(define-module (anon packages my-packages)
  #:use-module (gnu)
  #:use-module(guix)
  #:use-module (nongnu packages editors)

  #:use-module (anon packages fonts)
  ;; #:use-module (anon packages neovim)
  #:use-module (anon packages texlab)
  #:use-module (anon packages textutils)

  #:export (%wm-packages
            %tree-sitter-langs
            %lang-servers))

(use-package-modules
 admin
 chromium
 compression
 cups
 ebook
 fcitx5
 fonts
 freedesktop
 glib
 gnome
 gnupg
 image
 image-viewers
 inkscape
 kde-graphics
 kde-multimedia
 librewolf
 linux
 node
 package-management
 password-utils
 pdf
 pulseaudio
 qt
 shells
 shellutils
 sync
 terminals
 tree-sitter
 video
 vim
 web-browsers
 wm
 xdisorg
 xorg)

(define %wm-packages
  (list sway
        swayidle
        swaylock
        foot
        fuzzel
        mako
        grimshot
        slurp
        waybar
        kanshi
        brightnessctl))
;; wofi
;; bemenu))

(define %tree-sitter-langs
  (list tree-sitter-elisp
        tree-sitter-latex
        tree-sitter-lua
        tree-sitter-python
        tree-sitter-scheme))

(define %emacs-metapackage
  (append
   (list emacs-pgtk
         emacs-guix
         emacs-vterm
         tree-sitter
         tree-sitter-cli)
   ;; tree-sitter grammars to install
   %tree-sitter-langs))
