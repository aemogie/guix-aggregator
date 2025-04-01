;; Unlike the others, this machine does not run on guix system. It only uses the guix package manager.

(define-module (polterguix systems nineveh))

(use-modules (gnu home)
             (gnu packages)
             (gnu packages emacs)
             (gnu packages emacs-xyz)
             (gnu packages fcitx5)
             (gnu packages fonts)
             (gnu packages gnome-xyz)
             (gnu packages guile)
             (gnu packages librewolf)
             (gnu packages shells)
             (gnu packages shellutils)
             (gnu packages terminals)
             (gnu services)
             (gnu home services)
             (gnu home services shells)
             (guix gexp)
             (nongnu packages mozilla)
             (polterguix packages cli)
             ;; (polterguix packages emacs)
             )

(home-environment
 (packages (list
             emacs-next-pgtk
             emacs-guix
             fcitx5
             fcitx5-configtool
             fcitx5-gtk
             fcitx5-material-color-theme
             fcitx5-qt
             fcitx5-rime
             firefox
             font-aporetic
             guile-next
             kitty ;; locale errors (tab-completion problem with unicode characters) when kitty isn't installed with guix package manager
             libime
             librewolf
             papirus-icon-theme
             zsh
             zsh-completions
             zsh-autosuggestions
             zsh-syntax-highlighting
             ;; for a future new install, add starship-bin from polterguix/packages/cli
             sh-z))

  ;; Below is the list of Home services.  To search for available
  ;; services, run 'guix home search KEYWORD' in a terminal.
  (services
   (list (service home-zsh-service-type
                  (home-zsh-configuration
                   (zshrc (list
                                (mixed-text-file "zsh-autosuggestions"
                                                 "source $HOME/.guix-home/profile/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh")
                                (mixed-text-file "zsh-syntax-highlighting"
                                                 "source $HOME/.guix-home/profile/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh")
                                (mixed-text-file "zsh-completions"
                                                 "fpath=($HOME/.guix-home/share/zsh/site-functions $fpath)")
                                (mixed-text-file "nix-daemon"
                                                 "if [ -e /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]; then\n  . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh\nfi")
                                (local-file
                                 "../files/.zshrc" "zshrc")))
                   (zprofile (list (local-file
                                    "../files/.zprofile"
                                    "zprofile")))))


         (simple-service 'dotfiles
                          home-xdg-configuration-files-service-type
                          `(("hypr/hyprland.conf"  ,(local-file "../files/hypr/hyprland-nineveh.conf"))
                            ("hypr/hyprland-base.conf"  ,(local-file "../files/hypr/hyprland-base.conf"))))

         (simple-service 'guix-substitute-env-vars-service
		home-environment-variables-service-type
		`(("GUIX_AUTHORIZED_KEYS" . "$HOME/.config/guix/nonguix.pub")
                  ("GUIX_SUBSTITUTE_URLS" . "https://substitutes.nonguix.org https://ci.guix.gnu.org")))
         
         )))
