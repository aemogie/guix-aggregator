(define-module (home-environments radio)
  #|GNU|#
  #|H|# #:use-module (gnu home)

  #|GNU home services|#
  #|•|# #:use-module (gnu home services)
  #|A|# #:use-module (gnu home services admin)
  #|D|# #:use-module (gnu home services desktop)
        #:use-module (gnu home services dotfiles)
  #|F|# #:use-module (gnu home services fontutils)
  #|G|# #:use-module (gnu home services guix)
  #|P|# #:use-module (gnu home services pm)
  #|S|# #:use-module (gnu home services shepherd)
        #:use-module (gnu home services ssh)
        #:use-module (gnu home services sound)

  #|GNU packages|#
  #|F|# #:use-module (gnu packages fonts)
  #|G|# #:use-module (gnu packages gnome)
        #:use-module (gnu packages gnupg)
  #|L|# #:use-module (gnu packages linux)
  #|S|# #:use-module (gnu packages shells)

  #|Guix|#
  #|G|# #:use-module (guix gexp)

  #|Home-environments radio|#
  #|C|# #:use-module ((home-environments radio channels)
                      #:prefix channel:)
  #|F|# #:use-module ((home-environments radio files)
                      #:prefix file:)
        #:use-module ((home-environments radio fish abbreviations)
                      #:prefix fish-abbreviations:)
        #:use-module ((home-environments radio fish configs)
                      #:prefix fish-config:)
  #|P|# #:use-module ((home-environments radio packages)
                      #:prefix packages:)
  #|M|# #:use-module ((home-environments radio mime-types)
                      #:prefix mime-types:)
  #|S|# #:use-module ((home-environments radio secrets)
                      #:prefix sops-secrets:)
  #|T|# #:use-module ((home-environments radio timers)
                      #:prefix timer:)

  #|Radix|#
  #|U|# #:use-module (radix utils)

  #|Radix home services|#
  #|•|# #:use-module (radix home services)
  #|G|# #:use-module (radix home services gnupg)
  #|R|# #:use-module (radix home services repl)
  #|S|# #:use-module (radix home services shells)
        #:use-module (radix home services shepherd)
  #|X|# #:use-module (radix home services xdg)

  #|Radix packages|#
  #|F|# #:use-module (radix packages fish-xyz)
        #:use-module (radix packages fonts)

  #|SOPS home services|#
  #|S|# #:use-module (sops home services sops)

  #:export (radio radio.scm))

(define radio.scm
  (search-path %load-path
               (module-filename (current-module))))

(define radio
  (home-environment
   (packages
     (append #|B|# packages:blogging
             #|C|# packages:calendar
             #|D|# packages:databases packages:desktop packages:development
                   packages:documentation packages:downloads
             #|F|# packages:file-managing
             #|G|# packages:guix-contrib
             #|I|# packages:image
             #|M|# packages:mathematics packages:messaging packages:music
             #|P|# packages:password
             #|R|# packages:reading
             #|S|# packages:scheme packages:sound
             #|T|# packages:typst
             #|V|# packages:video
             #|W|# packages:web))

   (services
    (list #|XDG services|#
          (service home-xdg-user-directories-service-type
                   (home-xdg-user-directories-configuration
                    (desktop "$HOME/areas")
                    (documents "$HOME/areas/documents")
                    (download "$HOME/media/downloads")
                    (music "$HOME/media/music")
                    (pictures "$HOME/media/pictures")
                    (videos "$HOME/media/videos")
                    (publicshare "")
                    (templates "")))

          (service home-xdg-mime-applications-service-type
                   (home-xdg-mime-applications-configuration
                    (default (associate-right
                               ('zen.desktop mime-types:browser)
                               ('kak.desktop mime-types:editor)
                               ('lf.desktop mime-types:file-manager)
                               ('mpv.desktop mime-types:audio+video)
                               ('imv.desktop mime-types:image)
                               ('sioyek.desktop mime-types:document)))))

          (service home-xdg-configuration-files-service-type
                   (let ((adwaita-theme
                          (file-append gnome-themes-extra
                                       "/share/themes/Adwaita-dark/gtk-2.0")))
                     `(("gtk-2.0" ,adwaita-theme))))

          #|Font services|#
          (simple-service 'font-packages
                          home-profile-service-type
                          (list `(,font-adobe-source-han-sans "cn")
                                `(,font-adobe-source-han-sans "jp")
                                `(,font-adobe-source-han-sans "kr")
                                `(,font-adobe-source-han-sans "tw")
                                font-adobe-source-han-sans
                                font-adobe-source-sans-pro
                                font-adobe-source-serif-pro
                                font-openmoji
                                font-juliamono
                                font-meslo-lg-dz
                                font-wqy-zenhei))
          (simple-service 'default-fonts
                          home-fontconfig-service-type
                          `((alias
                              (family "Monospace")
                              (prefer
                                (family "OpenMoji Color")
                                (family "Meslo LG M DZ")
                                (family "JuliaMono Regular")))
                            (alias
                              (family "Serif")
                              (prefer
                                (family "OpenMoji Color")
                                (family "Source Serif Pro")
                                (family "JuliaMono Regular")))
                            (alias
                              (family "SansSerif")
                              (prefer
                                (family "OpenMoji Color")
                                (family "Source Sans CN Pro")
                                (family "Source Sans JP Pro")
                                (family "Source Sans KR Pro")
                                (family "Source Sans TW Pro")
                                (family "Source Sans Pro")
                                (family "JuliaMono Regular")))))

          #|File services|#
          (service home-directories-service-type
                   `(".archives"
                     "areas/code"
                     "areas/finances"
                     "areas/health"
                     "areas/relationships/self"
                     "projects"
                     "resources/artwork"
                     "resources/bookmarks"
                     "resources/causes"
                     "resources/code"
                     "resources/documentation"
                     "resources/formal-sciences"
                     "resources/humanities"
                     "resources/natural-sciences"))
          (service home-repositories-service-type
                   `(#|Artwork|#
                     ("resources/artwork/guix-artwork"
                      ,(savannah-url "guix/guix-artwork"))
                     ("resources/artwork/radix-artwork"
                      ,(codeberg-url "anemofilia" "radix-artwork"))
                     #|Code|#
                     ("areas/code/scm/radix"
                      ,(codeberg-url "anemofilia" "radix"))
                     ("areas/code/scm/zero"
                      ,(codeberg-url "anemofilia" "zero"))
                     ("resources/code/scm/misako"
                      ,(codeberg-url "look" "misako"))
                     ("resources/code/scm/saayix"
                      ,(codeberg-url "look" "saayix"))
                     ("resources/code/scm/guile"
                      ,(savannah-url "guile"))
                     ("resources/code/scm/guix"
                      ,(savannah-url "guix"))
                     ("resources/code/scm/shepherd"
                      ,(savannah-url "shepherd"))))
          (service home-files-service-type
                   `((".config/guix/home.scm" ,(symlink-to radio.scm))))

          #|Dotfiles service|#
          (service home-dotfiles-service-type
                   (home-dotfiles-configuration
                     (layout 'plain)
                     (directories `("radio/files"))))

          #|SOPS service|#
          (service home-sops-secrets-service-type
                   (home-sops-service-configuration
                     (gnupg-home "~/.local/share/gnupg")
                     (config file:sops.yaml)
                     (secrets (append sops-secrets:aerc
                                      sops-secrets:senpai))))

          #|Guix service|#
          (simple-service 'home-extra-channels
                          home-channels-service-type
                          (list channel:guix
                                channel:radix
                                channel:saayix
                                channel:sops-guix))

          #|Log services|#
          (service home-log-rotation-service-type)

          #|Shepherd services|#
          (service home-shepherd-service-type)
          (service home-shepherd-timer-service-type)
          (service home-shepherd-transient-service-type)
          (service radix:home-shepherd-timer-service-type
                   (list timer:alarm))

          #|Shell services|#
          (service home-tty-colorscheme-service-type
                   (home-tty-colorscheme-configuration
                     (regular-black "000000")
                     (regular-red "df6760")
                     (regular-green "8be760")
                     (regular-yellow "ffd17a")
                     (regular-blue "9688d9")
                     (regular-magenta "fc97ff")
                     (regular-cyan "86adff")
                     (regular-white "a1a1a1")
                     (bright-black "888888")
                     (bright-red regular-red)
                     (bright-green regular-green)
                     (bright-yellow regular-yellow)
                     (bright-blue regular-blue)
                     (bright-magenta regular-magenta)
                     (bright-cyan regular-cyan)
                     (bright-white regular-white)))

          (service home-fish-service-type
                   (home-fish-configuration
                    (plugins
                      (list fish-autopair
                            fish-foreign-env
                            fish-puffer))
                    (environment-variables
                     `(#|GNU Privacy Guard|#
                       ("GPG_TTY" . "(tty)")

                       #|Remind|#
                       ("DOTREMINDERS" . "$XDG_DATA_HOME/reminders")

                       #|GTK|#
                       ("GTK_RC_FILES" . "$XDG_CONFIG_HOME/gtk-2.0/gtkrc")

                       #|Ncurses|#
                       ("TERMINFO" . "$XDG_DATA_HOME/terminfo")))
                    (aliases
                     `(#|Common aliases|#
                       ("df" . "df -h")
                       ("du" . "du -h")
                       ("diff" . "diff --color=auto")
                       ("grep" . "grep --color=auto")
                       ("ip" . "ip --color=auto")
                       ("ls" . "ls --color=auto \
                                   --group-directories-first \
                                   --classify \
                                   --human-readable \
                                   -v")
                       ("tree" . "tree -CF --dirsfirst")
                       ("info" . "info --init-file $XDG_CONFIG_HOME/info")

                       #|Clear terminal screen without ncurses|#
                       ("clear" . "printf \\033c")))
                    (abbreviations
                      (append fish-abbreviations:download/upload
                              fish-abbreviations:guix
                              fish-abbreviations:editing
                              fish-abbreviations:misc))))

          (simple-service 'home-fish-colored-man home-fish-service-type
                          (home-fish-extension
                            (plugins
                              (list fish-colored-man))
                            (environment-variables
                              `(("man_bold" . ("-o" "blue"))))))

          (simple-service 'home-fish-done home-fish-service-type
                          (home-fish-extension
                            (plugins
                              (list fish-done))
                            (environment-variables
                              `(("__done_allow_nongraphical" . "1")
                                ("__done_exclude"
                                 . (#|G|# "^git" "'^guix (edit|repl|shell)'"
                                    #|K|# "^kak"
                                    #|L|# "^lf"
                                    #|M|# "^mpv"
                                    #|N|# "^newsraft"))
                                ("__done_notification_command"
                                 . "notify-send '$title' '$message'")))))

          (simple-service 'home-fish-fzf home-fish-service-type
                          (home-fish-extension
                            (plugins
                              (list fish-fzf))
                            (config
                              (list fish-config:fzf))
                            (environment-variables
                              `(("LS_COLORS" . "'di=01;34:ln=01;36:or=01;31'")
                                ("fzf_preview_dir_cmd" . "''")
                                ("FZF_DEFAULT_OPTS"
                                 . ("--color=fg:blue:bold,hl:#cccccc"
                                    "--color=fg+:blue:bold,hl+:#cccccc"
                                    "--color=prompt:blue,pointer:blue"
                                    "--color=info:#ffffff,border:#000000"
                                    "--filepath-word"
                                    "--height=~60%"
                                    "--layout=reverse"
                                    "--preview=''"
                                    "--scheme=path"
                                    "--scroll-off=2"))
                                ("fzf_base_fd_opts" . ("--exclude='\\..*'"
                                                       "--follow"
                                                       "--type directory"))
                                ("fzf_fd_opts" . ("$fzf_base_fd_opts"
                                                  "--base-directory=$HOME"
                                                  "--absolute-path"))
                                ("fzf_directory_opts"
                                 . ("'--bind=ctrl-p:reload(fd $fzf_base_fd_opts)'"
                                    "'--bind=ctrl-alt-p:reload(fd $fzf_fd_opts)'"))))))

          #|Environment variables services|#
          (simple-service 'home-shell-environment-variables
                          home-environment-variables-service-type
                          `(("PATH" . "$HOME/.local/bin:$PATH")
                            ("INPUTRC" . "$XDG_CONFIG_HOME/readline/inputrc")))

          (simple-service 'home-guile-environment-variables
                          home-environment-variables-service-type
                          `(("GUILE_WARN_DEPRECATED" . "detailed")
                            ("GUILE_HISTORY" . "$XDG_CACHE_HOME/guile/history")
                            ("GUILE_LOAD_PATH"
                             . ,(format #f "~@{~?~}"
                                           "~@{$HOME/areas/code/scm/~a:~}"
                                           '(zero)
                                           "~@{~a/share/guile/site/3.0:~}"
                                           '($HOME/.config/guix/current
                                             $HOME/.guix-home/profile
                                             /run/current-system/profile)))
                            ("GUILE_LOAD_COMPILED_PATH"
                             . ,(format #f "~{~a/lib/guile/3.0/site-ccache:~:*~
                                              ~a/share/guile/site/3.0:~}"
                                           '($HOME/.config/guix/current
                                             $HOME/.guix-home/profile
                                             /run/current-system/profile)))))

          (simple-service 'home-wayland-environment-variables
                          home-environment-variables-service-type
                          `(("QT_QPA_PLATFORM" . "wayland;xcb")
                            ("QT_QPA_PLATFORMTHEME" . "flatpak")
                            ("QT_WAYLAND_DISABLE_WINDOWDECORATION" . "1")))

          (simple-service 'home-language-environment-variables
                          home-environment-variables-service-type
                          `(("LANG" . "en_US.UTF-8")
                            ("LANGUAGE" . "en_US.UTF-8")
                            ("LC_COLLATE" . "C")))

          (simple-service 'home-default-applications-environment-variables
                          home-environment-variables-service-type
                          `(("BROWSER" . "zen")
                            ("EDITOR" . "kak")
                            ("PAGER" . "less")
                            ("TERMINAL" . "foot")
                            ("VISUAL" . "$EDITOR")
                            ("WM" . "river")))

          (simple-service 'home-applications-environment-variables
                          home-environment-variables-service-type
                          `(("MINETEST_USER_PATH" . "$XDG_DATA_HOME/minetest")
                            ("PASSWORD_STORE_DIR" . "$XDG_DATA_HOME/pass")))

          #|SSH service|#
          (service home-openssh-service-type
                   (home-openssh-configuration
                    (hosts (list (openssh-host
                                  (name "codeberg.org")
                                  (host-name "codeberg.org")
                                  (user "git")
                                  (identity-file "~/.ssh/codeberg"))
                                 (openssh-host
                                  (name "github.com")
                                  (host-name "github.com")
                                  (user "git")
                                  (identity-file "~/.ssh/github"))
                                 (openssh-host
                                  (name "git.sr.ht")
                                  (host-name "git.sr.ht")
                                  (user "git")
                                  (identity-file "~/.ssh/srht"))))))

          #|GPG agent service|#
          (service home-gpg-agent-service-type
                   (home-gpg-agent-configuration
                    (gnupg-home "~/.local/share/gnupg")
                    (pinentry-program
                     (file-append pinentry "/bin/pinentry-curses"))))

          #|Session services|#
          (service home-dbus-service-type)

          #|Sound services|#
          (service home-pipewire-service-type
                   (home-pipewire-configuration
                    (wireplumber wireplumber-minimal)))

          #|Battery services|#
          (service home-batsignal-service-type
                   (home-batsignal-configuration
                    (poll-delay (* 5 60))
                    (full-level 90)
                    (warning-level 70)
                    (critical-level 20)
                    (danger-level 10)
                    (danger-command "doas zzz")
                    (full-message "Unplug the cable")
                    (warning-message "You may want to plug the cable")
                    (critical-message "Plug the cable")
                    (notifications-expire? #t)))))))
radio
