(define-module (galahad user lynn)
  #:use-module (gnu packages video)
  #:use-module (gnu packages pulseaudio)
  #:use-module (gnu packages gnupg)
  #:use-module (gnu packages messaging)
  #:use-module (nongnu packages messaging)
  #:use-module (nongnu packages mozilla)
  #:use-module (gnu packages freedesktop)
  #:use-module (gnu packages pdf)
  #:use-module (gnu packages fonts)
  #:use-module (gnu packages fcitx5)
  #:use-module (gnu packages emacs)
  #:use-module (gnu packages bqn)
  #:use-module (gnu packages apl)
  #:use-module (gnu packages emacs-xyz)
  #:use-module (gnu packages shells)
  #:use-module (gnu packages llvm)
  #:use-module (gnu services) ;simple service
  #:use-module (guix gexp) ;plain-file
  #:use-module (gnu home)
  #:use-module (gnu home services)
  #:use-module (gnu home services guix)
  #:use-module (gnu home services dotfiles)
  #:use-module (gnu home services xdg)
  #:use-module (gnu home services desktop)
  #:use-module (gnu home services shells)
  #:use-module (galahad system channels))

(define lynn-font-packages
  (list font-awesome
		font-iosevka-etoile
		font-iosevka-term
		font-google-noto
		font-google-noto-emoji
		font-sarasa-gothic))

(define lynn-emacs-packages
  (list emacs-aggressive-indent
		emacs-autothemer
		emacs-gruvbox-theme
		emacs-buffer-env
		emacs-clang-format
		emacs-consult
		emacs-company
		emacs-counsel
		emacs-doom-modeline
		emacs-dired-hacks		; dired-subtree
		emacs-eglot
		emacs-flycheck
		emacs-geiser-guile
		emacs-htmlize
		emacs-ivy
		emacs-jsonrpc
		emacs-ligature
		emacs-magit
		emacs-meow
		emacs-mixed-pitch
		emacs-nerd-icons
		emacs-no-littering
		emacs-olivetti
		emacs-org-auto-tangle
		emacs-org-modern
		emacs-org-roam
		emacs-paredit
		emacs-php-mode
		emacs-rainbow-delimiters
		emacs-rainbow-mode
		emacs-simple-httpd
		emacs-swiper
		emacs-typescript-mode
		emacs-outline-indent
		emacs-yaml-mode
		emacs-pinentry
		emacs-which-key
		emacs-bqn-mode
		emacs-zig-mode
		))

(define %zshrc
  (plain-file
   "zshrc"
   "
autoload -Uz vcs_info
setopt prompt_subst

HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000

zstyle ':vcs_info:git*' formats \" %F{blue}%b%f %m%u%c %a \"
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' stagedstr ' %F{green}✚%f'
zstyle ':vcs_info:*' unstagedstr ' %F{red}●%f'

precmd() {
    vcs_info
    print -P '%B%~%b ${vcs_info_msg_0_}'
}

PROMPT='%B%(!.#.>)%b '

source $HOME/.guix-profile/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source $HOME/.guix-profile/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
"))

(home-environment
 (packages
  (append lynn-font-packages
		  lynn-emacs-packages))
 (services
  (list
   (service home-channels-service-type
			(list %channels-guix
				  %channels-guix-gaming
				  %channels-nonguix
				  %channels-emacs
				  %channels-artoria))
   (service home-dotfiles-service-type
            (home-dotfiles-configuration
             (layout 'stow)
             (directories '("../../dotfiles")))))))
