(define-module (anon packages my-packages)
  #:use-module (gnu)
  #:use-module (guix)
  #:use-module (nongnu packages editors)

  #:use-module (anon packages fonts)
  #:use-module (anon packages texlab)
  #:use-module (anon packages textutils)

  #:export (%wm-packages %tree-sitter-langs %lang-servers %emacs-metapackage))

(use-package-modules admin
                     chromium
                     compression
                     cups
                     ebook
                     emacs
                     emacs-xyz
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
                     python-xyz
                     qt
                     shells
                     shellutils
                     sync
                     terminals
					 tex
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

(define %lang-servers
  (list python-lsp-server))

(define %emacs-metapackage
  (append (list emacs-pgtk emacs-guix emacs-vterm tree-sitter tree-sitter-cli)
          ;; tree-sitter grammars to install
          %tree-sitter-langs
          ;; language servers to install
          %lang-servers))

(define %flatpak-xdg-packages
  (list flatpak
		xdg-utils
		xdg-desktop-portal
		xdg-desktop-portal-wlr
		flatpak-xdg-utils
		xdg-dbus-proxy
		shared-mime-info
		(list glib "bin")))

(define %tex-metapackage
    (list texlive-scheme-basic
        texlive-collection-latexrecommended
        texlive-collection-fontsrecommended

        texlive-algorithmicx
        texlive-algorithms
        texlive-bbm
        texlive-bbm-macros
        texlive-cancel
        texlive-cleveref
        texlive-emptypage
        texlive-enumitem
        texlive-environ
        texlive-ifmtarg
        texlive-import
        texlive-latexindent
        texlive-latexmk
        texlive-manfnt
        texlive-mdframed
        texlive-multirow
        texlive-needspace
        texlive-pdfcol
        texlive-pgfplots
        texlive-silence
        texlive-siunitx
        texlive-stmaryrd
        texlive-systeme
        texlive-tcolorbox
        texlive-thmtools
        texlive-tikz-cd
        texlive-titlesec
        texlive-todonotes
        texlive-transparent
        texlive-ulem
        texlive-xifthen
        texlive-xstring
        texlive-zref))

(define %desktop-home-packages)

(define %system-packages)
