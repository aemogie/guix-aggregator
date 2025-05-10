;;; SSS - Supreme Sexp System

;; Copyright © Josep Bigorra <jjbigorra@gmail.com>

;; sss is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; sss is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with sss.  If not, see <https://www.gnu.org/licenses/>.

(load "../palette.scm")
(load "./hyprlang.scm")
(load "./hyprpaper.scm")

(define-module (sss hyprland hyprland)
  #:use-module (gnu)
  #:use-module (sss palette)
  #:use-module (sss hyprland hyprlang)
  #:use-module (sss hyprland hyprpaper))

(define* (notify-cmd #:key title subtitle)
  (format #f
          (string-append "fyi -i"
           " /run/current-system/profile/share/icons/Yaru/32x32/actions/dialog-yes.png"
           " \"~a\" \"~a\"" " >/dev/null 2>&1") title subtitle))

(define* (hypr-startup-programs #:key palette
                                (extra-startups '()))
  (let* ((gtk-theme-name (sss-get-gtk-theme palette))
         (icon-theme-name (sss-get-icon-theme palette))
         (cursor-theme-name (sss-get-cursor-theme palette))
         (xs (append extra-startups
                     `("lxsession" "mako"
                       "dbus-update-activation-environment --all"
                       "waybar"
                       "hyprpaper"
                       "alacritty --daemon"
                       "emacs --daemon"
                       "transmission-daemon"
                       "podman system service --time=0 unix:///tmp/podman.sock"
                       "gsettings set org.gnome.desktop.interface gtk-key-theme \"Emacs\""
                       ,(format #f
                         "gsettings set org.gnome.desktop.interface gtk-theme '~a'"
                         gtk-theme-name)
                       ,(format #f
                         "gsettings set org.gnome.desktop.interface icon-theme '~a'"
                         icon-theme-name)
                       ,(format #f
                         "gsettings set org.gnome.desktop.interface cursor-theme '~a'"
                         cursor-theme-name)
                       "gsettings set org.gnome.desktop.interface cursor-size 24"
                       "gsettings set org.gnome.desktop.interface font-name 'Adwaita Sans'"
                       "xdg-user-dirs-update"))))
    xs))

(define* (hypr-input #:key keyboard-layout caps-to-ctrl)
  `((follow_mouse . 1) (kb_layout unquote keyboard-layout)
    ,(if caps-to-ctrl
         `(kb_options . "caps:ctrl_modifier")
         `(kb_options . ""))
    (touchpad (disable_while_typing . true)
              (natural_scroll . false)
              (scroll_factor . "1.0")
              (tap-to-click . true))))

(define* (hypr-general #:key palette)
  `((border_size . 2) (no_border_on_floating . false)
    (gaps_in . 8)
    (gaps_out . 16)
    (layout . dwindle)
    (resize_on_border . true)
    ("col.active_border" unquote
     (format #f "0xff~a"
             (string-drop (sss-get-color palette
                                         'primary) 1)))))

(define hypr-gestures
  `((workspace_swipe . true)))

(define* (hypr-decoration #:key (with-blur #f)
                          (with-shadow #f))
  `((rounding . 8) (active_opacity . "1.0")
    (inactive_opacity . "0.9")
    (dim_inactive . true)
    (dim_strength . "0.1")
    (blur (enabled unquote
                   (if with-blur
                       'true
                       'false))
          (size . 8))
    (shadow (enabled unquote
                     (if with-shadow
                         'true
                         'false))
            (range . 4))))

(define hypr-animations
  `((enabled . true) (first_launch_animation . true)))

(define hypr-misc
  `((disable_hypr_logo . true) (disable_splash_rendering . true)
    (font_family . "Adwaita Sans")))

;;

(define hypr-media-binds
  (map (lambda (kb)
         (serialize-hypr-setting (car kb)
                                 (cdr kb)))
       `((bindel unquote
                 (hypr-bind #:dispatch 'exec
                            #:bind "XF86AudioRaiseVolume"
                            #:cmd "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"))
         (bindel . ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-")
         (bindl . ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle")
         (bindel . ", XF86MonBrightnessDown, exec, sudo light -U 5")
         (bindel . ", XF86MonBrightnessUp, exec, sudo light -A 5")
         (bindl . ", XF86AudioPlay, exec, playerctl play-pause")
         (bindl . ", XF86AudioNext, exec, playerctl next")
         (bindl . ", XF86AudioPrev, exec, playerctl previous"))))

(define hypr-workspace-binds
  (map (lambda (wn)
         (serialize-hypr-setting 'bind
                                 (hypr-bind #:mod "s"
                                            #:bind (format #f "~a" wn)
                                            #:dispatch 'workspace
                                            #:cmd (format #f "~a" wn))))
       '(1 2
         3
         4
         5
         6
         7
         8
         9)))

(define hypr-movetoworkspace-binds
  (map (lambda (wn)
         (serialize-hypr-setting 'bind
                                 (hypr-bind #:mod "s-S"
                                            #:bind (format #f "~a" wn)
                                            #:dispatch 'movetoworkspacesilent
                                            #:cmd (format #f "~a" wn))))
       '(1 2
         3
         4
         5
         6
         7
         8
         9)))

(define* hypr-mouse-binds
  (map (lambda (kb)
         (serialize-hypr-setting 'bindm kb))
       (list (special-bind #:mod "s"
                           #:bind "mouse-left"
                           #:dispatch 'movewindow))))

(define* hypr-swap-binds
  (map (lambda (kb)
         (serialize-hypr-setting 'bind kb))
       (list (hypr-bind #:mod "s-S"
                        #:bind "Left"
                        #:cmd 'l
                        #:dispatch 'swapwindow)
             (hypr-bind #:mod "s-S"
                        #:bind "Right"
                        #:cmd 'r
                        #:dispatch 'swapwindow)
             (hypr-bind #:mod "s-S"
                        #:bind "Down"
                        #:cmd 'd
                        #:dispatch 'swapwindow)
             (hypr-bind #:mod "s-S"
                        #:bind "Up"
                        #:cmd 'u
                        #:dispatch 'swapwindow))))

(define* hypr-focus-binds
  (map (lambda (kb)
         (serialize-hypr-setting 'bind kb))
       (list (hypr-bind #:mod "s"
                        #:bind "Left"
                        #:cmd 'l
                        #:dispatch 'movefocus)
             (hypr-bind #:mod "s"
                        #:bind "Right"
                        #:cmd 'r
                        #:dispatch 'movefocus)
             (hypr-bind #:mod "s"
                        #:bind "Down"
                        #:cmd 'd
                        #:dispatch 'movefocus)
             (hypr-bind #:mod "s"
                        #:bind "Up"
                        #:cmd 'u
                        #:dispatch 'movefocus))))

(define* (hypr-common-exec-binds #:key clone-dir palette)
  (map (lambda (kb)
         (serialize-hypr-setting 'bind kb))
       (list (special-bind #:mod "s"
                           #:bind "K"
                           #:dispatch 'killactive)
             (special-bind #:mod "s"
                           #:bind "F"
                           #:dispatch 'fullscreen)
             (special-bind #:mod "s-S"
                           #:bind "Q"
                           #:dispatch 'exit)
             (special-bind #:mod "s-S"
                           #:bind "L"
                           #:dispatch 'forcerendererreload)
             (exec-bind #:mod "s"
                        #:bind "L"
                        #:cmd "hyprlock")
             (exec-bind #:mod "s-S"
                        #:bind "B"
                        #:cmd (format #f "hyprctl hyprpaper reload ,~a"
                                      (sss-hypr-wallpaper #:clone-dir
                                                          clone-dir
                                                          #:palette palette)))
             (exec-bind #:mod "s"
                        #:bind "T"
                        #:cmd "alacritty msg create-window || alacritty")
             (exec-bind #:mod "s"
                        #:bind "return"
                        #:cmd "alacritty msg create-window || alacritty")
             (exec-bind #:mod "s-S"
              #:bind "T"
              #:cmd
              "emacsclient -ce '(eshell \"new\")(rename-buffer (concat \"*eshell: \" (float-time) \"*\"))'")
             (exec-bind #:mod "s-S"
              #:bind "return"
              #:cmd
              "emacsclient -ce '(eshell \"new\")(rename-buffer (concat \"*eshell: \" (float-time) \"*\"))'")
             (exec-bind #:mod "s"
                        #:bind "slash"
                        #:cmd "rofi -show drun -icon-theme \"Papirus\"")
             (exec-bind #:mod "s"
                        #:bind "E"
                        #:cmd "emacsclient -c")
             (exec-bind #:mod "s-S"
                        #:bind "E"
                        #:cmd "emacsclient -t")

             (exec-bind #:mod "s"
                        #:bind "period"
                        #:cmd (format #f
                                      "grimshot save screen && sleep 1 && ~a"
                                      (notify-cmd #:title "Screenshot saved"
                                       #:subtitle
                                       "Saved screenshot of whole screen to file!")))

             (exec-bind #:mod "s-S"
                        #:bind "period"
                        #:cmd (format #f
                                      "grimshot copy screen && sleep 1 && ~a"
                                      (notify-cmd #:title "Screenshot copied"
                                       #:subtitle
                                       "Copied screenshot of whole screen!")))
             (exec-bind #:mod "s"
                        #:bind "comma"
                        #:cmd (format #f "grimshot save area && sleep 1 && ~a"
                                      (notify-cmd #:title
                                       "Screenshot area saved"
                                       #:subtitle
                                       "Saved screenshot of area to file!")))
             (exec-bind #:mod "s-S"
                        #:bind "comma"
                        #:cmd (format #f "grimshot copy area && sleep 1 && ~a"
                                      (notify-cmd #:title "Screenshot copied"
                                       #:subtitle "Copied screenshot of area!")))
             (exec-bind #:mod "s"
                        #:bind "I"
                        #:cmd "firefox")
             (exec-bind #:mod "s-S"
                        #:bind "I"
                        #:cmd "google-chrome-beta")
             (exec-bind #:mod "s"
                        #:bind "B"
                        #:cmd "nemo")

             (hypr-bind #:mod "s-S"
                        #:bind "space"
                        #:dispatch "togglefloating"
                        #:cmd "active")
             (hypr-bind #:mod "s-S"
                        #:bind "C"
                        #:dispatch "centerwindow"
                        #:cmd "")
             (hypr-bind #:mod "s"
                        #:bind "tab"
                        #:dispatch "cyclenext"
                        #:cmd ""))))

(define* (hypr-binds #:key clone-dir palette)
  (append hypr-media-binds
          hypr-workspace-binds
          hypr-movetoworkspace-binds
          hypr-swap-binds
          hypr-focus-binds
          (hypr-common-exec-binds #:clone-dir clone-dir
                                  #:palette palette)
          hypr-mouse-binds))

;; hyprland: Hyprland is a 100% independent, dynamic tiling Wayland compositor that doesn't sacrifice on its looks.
;; It provides the latest Wayland features, is highly customizable, has all the eyecandy, the most powerful plugins,
;; easy IPC, much more QoL stuff than other compositors and more... 
;;
;; https://github.com/hyprwm/Hyprland
(begin
  (define* (sss-hyprland-config #:key clone-dir
                                keyboard-layout
                                caps-to-ctrl
                                palette
                                monitors
                                (extra-startups '())
                                (with-blur #f)
                                (with-shadow #f)
                                (startup-programs (hypr-startup-programs
                                                   #:palette palette
                                                   #:extra-startups
                                                   extra-startups))
                                (window-rules (list (hypr-window-rule #:action 'float
                                                     #:class "pavucontrol"))))
    (let* ((serialized-startup-programs (map (lambda (startup-item)
                                               (serialize-hypr-setting 'exec-once
                                                startup-item))
                                             startup-programs))
           (serialized-input (serialize-hypr-section #:section 'input
                                                     #:settings (hypr-input
                                                                 #:keyboard-layout
                                                                 keyboard-layout
                                                                 #:caps-to-ctrl
                                                                 caps-to-ctrl)))
           (serialized-general (serialize-hypr-section #:section 'general
                                                       #:settings (hypr-general
                                                                   #:palette
                                                                   palette)))
           (serialized-decoration (serialize-hypr-section #:section 'decoration
                                                          #:settings (hypr-decoration
                                                                      #:with-blur
                                                                      with-blur
                                                                      #:with-shadow
                                                                      with-shadow)))
           (serialized-animations (serialize-hypr-section #:section 'animations
                                                          #:settings
                                                          hypr-animations))
           (serialized-key-bindings (string-join (hypr-binds #:clone-dir
                                                             clone-dir
                                                             #:palette palette)
                                                 "\n"))
           (serialized-window-rules (string-join (map (lambda (r)
                                                        (serialize-hypr-setting 'windowrulev2
                                                         r)) window-rules)
                                                 "\n"))
           (config-lines (append `("# ====== SSS Hyprland configuration ======"
                                   "#"
                                   "# auto-generated file, DO NOT EDIT!"
                                   ""
                                   "# ====== Monitors ======"
                                   ,(string-join monitors "\n")
                                   ""
                                   "# ====== Startup programs ======")
                                 serialized-startup-programs
                                 `("" "# ====== General configuration ======"
                                   ,serialized-general)
                                 `("" "# ====== Input configuration ======"
                                   ,serialized-input)
                                 `(""
                                   "# ====== Decoration configuration ======"
                                   ,serialized-decoration)
                                 `(""
                                   "# ====== Animations configuration ======"
                                   ,serialized-animations)
                                 `("" "# ====== Key bindings ======"
                                   ,serialized-key-bindings)
                                 `("" "# ====== Window rules ======"
                                   ,serialized-window-rules)
                                 `(""
                                   "# ====== End of SSS Hyprland configuration ======"
                                   ""))))
      
      (string-join config-lines "\n")))
  (export sss-hyprland-config))

(begin
  (define* (sss-hyprland-svc #:key palette
                             clone-dir
                             keyboard-layout
                             caps-to-ctrl
                             monitors
                             extra-startups
                             with-blur
                             with-shadow)
    `((".config/hypr/hyprland.conf" ,(plain-file "hyprland.conf"
                                                 (sss-hyprland-config
                                                  #:clone-dir clone-dir
                                                  #:keyboard-layout
                                                  keyboard-layout
                                                  #:caps-to-ctrl caps-to-ctrl
                                                  #:palette palette
                                                  #:monitors monitors
                                                  #:extra-startups
                                                  extra-startups
                                                  #:with-blur with-blur
                                                  #:with-shadow with-shadow)))))
  (export sss-hyprland-svc))
