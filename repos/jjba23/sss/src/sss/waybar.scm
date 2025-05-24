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

(define-module (sss waybar)
  #:declarative? #t
  #:use-module (gnu)
  #:use-module (sss palette)
  #:use-module (sss process)
  #:use-module (sxml simple)
  #:use-module (json))

;; Waybar power menu, encoding XML as Scheme - SXML - s-expressions
(define-public sss-waybar-power-menu
  '(*TOP* (*PI* xml "version=\"1.0\" encoding=\"UTF-8\"")
          (interface (object (@ (class "GtkMenu")
                                (id "menu"))
                             (child (object (@ (class "GtkMenuItem")
                                               (id "suspend"))
                                            (property (@ (name "label"))
                                                      "Suspend")))
                             (child (object (@ (class "GtkMenuItem")
                                               (id "hibernate"))
                                            (property (@ (name "label"))
                                                      "Hibernate")))
                             (child (object (@ (class "GtkSeparatorMenuItem")
                                               (id "delimiter1"))))
                             (child (object (@ (class "GtkMenuItem")
                                               (id "shutdown"))
                                            (property (@ (name "label"))
                                                      "Shutdown")))
                             (child (object (@ (class "GtkMenuItem")
                                               (id "reboot"))
                                            (property (@ (name "label"))
                                                      "Reboot")))))))

(define sss-waybar-power-button
  `(custom/power (format . "sys")
                 (tooltip . #f)
                 (menu . "on-click")
                 (menu-file . "$HOME/.config/waybar/power_menu.xml")
                 (menu-actions (shutdown . "sudo halt")
                               (reboot . "sudo reboot")
                               (suspend . "sudo loginctl suspend")
                               (hibernate . "sudo loginctl hibernate"))))

;;- SSS/GNU
(define* (sss-waybar-start-button #:key (content "λ  SSS/GNU"))
  `(custom/sss-waybar-start-button (format unquote content)
                                   (on-click . "rofi -show drun")))

(define sss-waybar-audio-icon
  `(pulseaudio (format . "{volume}% {icon} {format_source}")
               (format-bluetooth . "{volume}% {icon}\uf294 {format_source}")
               (format-bluetooth-muted . "\uf6a9 {icon}\uf294 {format_source}")
               (format-muted . "\uf6a9 {format_source}")
               (format-source . "{volume}% \uf130")
               (format-source-muted . "\uf131")
               (format-icons (headphone . "\uf025")
                             (hands-free . "\uf590")
                             (headset . "\uf590")
                             (phone . "\uf095")
                             (portable . "\uf095")
                             (car . "\uf1b9")
                             (default . #("\uf026" "\uf027" "\uf028")))
               (on-click . "pavucontrol")))

(define sss-waybar-power-profiles
  `(power-profiles-daemon (format . "{icon}")
                          (tooltip-format . "Power profile: {profile}\nDriver: {driver}")
                          (tooltip . #t)
                          (format-icons (default . "\uf0e7 -")
                                        (performance . "\uf0e7 perf")
                                        (balanced . "\uf24e bal")
                                        (power-saver . "\uf06c eco"))))

(define sss-waybar-battery-2
  `(#{battery#bat2}# (bat . "BAT2")))

(define sss-waybar-battery
  `(battery (states (warning . 30)
                    (critical . 15))
            (format . "{capacity}% {icon}")
            (format-full . "{capacity}% {icon}")
            (format-charging . "{capacity}% \uf0e7")
            (format-plugged . "{capacity}% \uf0e7")
            (format-alt . "{time} {icon}")
            (format-icons . #("\uf244" "\uf243" "\uf242" "\uf241" "\uf240"))))

(define sss-waybar-hyprland-workspaces
  `(hyprland/workspaces (disable-scroll . #t)
                        (all-outputs . #t)
                        (warp-on-scroll . #f)
                        (format . "{icon}")
                        (format-icons ("1" . "1")
                                      ("2" . "2")
                                      ("3" . "3")
                                      ("4" . "4")
                                      ("5" . "5")
                                      ("6" . "6")
                                      ("7" . "7")
                                      ("8" . "8")
                                      ("9" . "9")
                                      ("10" . "10")
                                      ("default" . "\uf111"))))

(define sss-waybar-clock
  `(clock (on-click . "gnome-calendar")
          (format . "{:%H:%M - %a, %d %B %Y}")
          (tooltip-format . "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>")
          (interval . 60)))

(define* (sss-waybar-taskbar #:key palette)
  `(wlr/taskbar (format . "{icon} {title:.28}")
                (icon-size . 16)
                (icon-theme unquote
                            (sss-get-icon-theme palette))
                (tooltip-format . "{title}")
                (on-click . "activate")
                (on-click-middle . "minimize")))

(define sss-waybar-backlight
  `(backlight (format . "{percent}% {icon}")
              (format-icons . #("\ue38d" "\ue3d3" "\ue3d1" "\ue3cf" "\ue3ce" "\ue3cd" "\ue3ca" "\ue3c8" "\ue39b"))))

;; My WayBar configurations, defined in Guile Scheme, a status bar with a detailed, modular setup.
(begin
  (define* (sss-waybar-conf #:key palette
                            (hyprland-session #f)
                            (labwc-session #f)
                            (with-memory #f)
                            (with-numlock #f)
                            (with-capslock #f))
    (let ((modules-left (if labwc-session
                            #(custom/sss-waybar-start-button clock wlr/taskbar)
                            #(custom/sss-waybar-start-button clock hyprland/workspaces custom/media)))
          (modules-right (if labwc-session
                             #(pulseaudio power-profiles-daemon cpu memory backlight keyboard-state battery custom/power tray)
                             #(pulseaudio power-profiles-daemon cpu memory backlight keyboard-state battery custom/power tray))))
      `((position . bottom) (height . 38)
        (modules-left unquote modules-left)
        (modules-center)
        (modules-right unquote modules-right)
        ,(sss-waybar-start-button)
        ,(cond
           (hyprland-session sss-waybar-hyprland-workspaces)
           (else `(hyprland/workspaces . null)))
        (keyboard-state (numlock unquote with-numlock)
                        (capslock unquote with-capslock)
                        (format . "{name} {icon} ")
                        (format-icons (locked . "\uf023")
                                      (unlocked . "\uf09c")))
        (hyprland/mode (format . "<span style=\"italic\">{}</span>"))
        (tray (spacing . 12))
        ,sss-waybar-clock
        (cpu (format . "\uf2db cpu: {usage}%")
             (tooltip . #f)
             (on-click . "gnome-system-monitor"))
        ,(cond
           (with-memory `(memory (format . "\uf0c9 mem: {}%")
                                 (on-click . "gnome-system-monitor")))
           (else `(memory . null)))
        ,sss-waybar-backlight
        ,sss-waybar-battery
        ,sss-waybar-battery-2
        ,sss-waybar-power-profiles
        ,(sss-waybar-taskbar #:palette palette)
        ,sss-waybar-audio-icon
        ,sss-waybar-power-button)))
  (export sss-waybar-conf))

(define* (button-css #:key palette)
  `((background unquote
                (sss-hex-to-rgba (sss-get-color palette
                                                'background)
                                 #:alpha 0.7))
    (border unquote
            (format #f "1px solid ~a"
                    (sss-hex-to-rgba (sss-get-color palette
                                                    'background-l)
                                     #:alpha 0.9)))
    (color unquote
           (sss-hex-to-rgba (sss-get-color palette
                                           'text-l)
                            #:alpha 1))
    (font-weight . 700)
    (margin-top . "4px")
    (margin-bottom . "4px")
    (margin-left . "4px")
    (margin-right . "4px")
    (font-size . "11pt")
    (padding-left . "10px")
    (padding-right . "10px")
    (border-radius . "16px")))

;; Defines a CSS configuration for SSS Waybar using Scheme.
;; This configuration customizes various UI elements, such as background color,
;; padding, font styles, and colors, with dynamic values derived from functions
;; like `sss-get-color` and `sss-hex-to-rgba`.
;;
;; Key Features:
;; - Transparent background for the Waybar module with consistent padding.
;; - Specific styles for workspace buttons, clocks, and tooltips.
;; - Dynamic colors fetched from `sss-get-color` for consistency with theme settings.
;; - Use of transition effects and alpha blending to enhance UI responsiveness.
(begin
  (define* (sss-waybar-css #:key palette sans-font)
    `((module (background . transparent)
              (font-family unquote
                           (format #f "FontAwesome, ~a" sans-font))
              (font-weight . 500)
              (color unquote
                     (sss-get-color palette
                                    'text)))
      ("#workspaces" unquote
       (button-css #:palette palette))
      ("#workspaces button" (font-size . "11pt"))
      ("#power-profiles-daemon" unquote
       (button-css #:palette palette))
      ("#custom-power" unquote
       (button-css #:palette palette))
      ("#battery" unquote
       (button-css #:palette palette))
      ("#backlight" unquote
       (button-css #:palette palette))
      ("#clock" unquote
       (button-css #:palette palette))
      ("window#waybar" (background unquote
                                   (sss-hex-to-rgba (sss-get-color palette
                                                                   'background)
                                                    #:alpha 0.0))
       (padding . "8px")
       (font-family unquote
                    (format #f "FontAwesome, ~a" sans-font))
       (color unquote
              (sss-get-color palette
                             'text)))
      (tooltip (background unquote
                           (sss-get-color palette
                                          'background-l))
               (border-radius . 0))
      ("#custom-sss-waybar-start-button" unquote
       (button-css #:palette palette))
      ("#workspaces" (padding-right . 0))
      ("#workspaces button" (padding . "4px")
       (font-weight . 700)
       (color unquote
              (sss-get-color palette
                             'text)))
      ("#workspaces button.active" (background unquote
                                               (sss-get-color palette
                                                              'primary-l))
       (border-radius . "10px")
       (color unquote
              (sss-get-color palette
                             'background))
       (margin-top . "4px")
       (margin-bottom . "4px")
       (transition . none))
      ("#workspaces button.focused" (color unquote
                                           (sss-get-color palette
                                                          'primary-l)))
      ("#workspaces button.urgent" (color . "#ef6560"))
      ("#workspaces button.hover" (color unquote
                                         (sss-get-color palette
                                                        'text))
       (background unquote
                   (sss-hex-to-rgba (sss-get-color palette
                                                   'background)
                                    #:alpha 0.7)))
      ("window#waybar.empty #window" (padding . 0)
       (margin . 0)
       (opacity . 0))
      ("#tray" unquote
       (append (button-css #:palette palette)
               '((transition . "all .3s ease"))))
      ("#keyboard-state" (font-size . "11pt"))
      ("#pulseaudio" unquote
       (button-css #:palette palette))
      ("#cpu" unquote
       (button-css #:palette palette))
      ("#memory" unquote
       (button-css #:palette palette))))

  (export sss-waybar-css))

(begin
  (define* (sss-waybar-svc #:key palette
                           with-memory
                           labwc-session
                           hyprland-session
                           sans-font)
    `( ;Waybar configuration (for status bar)
       (".config/waybar/config.jsonc" ,(plain-file "config.jsonc"
                                                   (scm->json-string (sss-waybar-conf
                                                                      #:palette
                                                                      palette
                                                                      #:labwc-session
                                                                      labwc-session
                                                                      #:hyprland-session
                                                                      hyprland-session
                                                                      #:with-memory
                                                                      with-memory)
                                                                     #:pretty
                                                                     #t)))

      ;; Waybar styling
      (".config/waybar/style.css" ,(plain-file "waybar.css"
                                               (mk-css-conf-lines (sss-waybar-css
                                                                   #:palette
                                                                   palette
                                                                   #:sans-font
                                                                   sans-font))))
      ;; Waybar Power menu from Scheme to XML format
      (".config/waybar/power_menu.xml" ,(plain-file "power_menu.xml"
                                                    (with-output-to-string (lambda ()
                                                                             
                                                                             (sxml->xml
                                                                              sss-waybar-power-menu)))))))
  (export sss-waybar-svc))
