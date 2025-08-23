;; Unlike the others, this machine does not run on guix system. It only uses the guix package manager.

(define-module (polterguix systems nineveh))

(use-modules (gnu home)
             (gnu packages)
             (gnu packages emacs)
             (gnu packages emacs-xyz)
             (gnu packages fcitx5)
             (gnu packages fonts)
             (gnu packages gnome)
             (gnu packages gnome-xyz)
             (gnu packages guile)
             (gnu packages ibus)
             (gnu packages image)
             (gnu packages librewolf)
             (gnu packages mail)
             (gnu packages qt)
             (gnu packages shells)
             (gnu packages shellutils)
             (gnu packages terminals)
             (gnu packages vpn)
             (gnu services)
             (gnu home services)
             (gnu home services shells)
             (guix gexp)
             (nongnu packages mozilla)
             (polterguix packages cli))

(home-environment
 (packages (list
             ;; ddcci-driver-linux ;; only if =ddcutil detect= reports no displays found
             emacs-next-pgtk
             emacs-guix
             fcitx5
             fcitx5-configtool
             fcitx5-gtk
             fcitx5-material-color-theme
             fcitx5-qt 
             fcitx5-rime
             firefox ;; Use "guix build firefox --substitute-urls='https://ci.guix.gnu.org https://bordeaux.guix.gnu.org https://substitutes.nonguix.org'" to build from substitute
             ;; mirror available at https://nonguix-proxy.ditigal.xyz
             font-aporetic
             guile-next
             ibus  ;; required for fcitx for some reason
             ;; ibus-libpinyin
             kitty ;; locale errors (tab-completion problem with unicode characters) when kitty isn't installed with guix package manager
             ;; libime
             librewolf
             mu
             network-manager
             network-manager-applet
             papirus-icon-theme
             swappy
             wireguard-tools
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

         (simple-service 'dotfiles
                          home-xdg-configuration-files-service-type
                          `(("waybar/style.css"  ,(local-file "../files/waybar/style-nineveh.css"))
                            ("waybar/theme.css"  ,(local-file "../files/waybar/theme.css"))
                            ("waybar/config"  ,(local-file "../files/waybar/config"))))

         ;; for nineveh only, run "guix build firefox --substitute-urls='https://ci.guix.gnu.org https://bordeaux.guix.gnu.org https://substitutes.nonguix.org'" to guix home reconfigure... not sure if the below does anything
         (simple-service 'guix-substitute-env-vars-service
		home-environment-variables-service-type
		`(("GUIX_AUTHORIZED_KEYS" . "$HOME/.config/guix/nonguix.pub")
                  ("GUIX_SUBSTITUTE_URLS" . "https://substitutes.nonguix.org https://ci.guix.gnu.org"))))))
