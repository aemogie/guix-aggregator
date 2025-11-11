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

(define-module (sss niri)
  #:declarative? #t
  #:use-module (gnu)
  #:use-module (sss palette)
  #:use-module (sss prelude)
  #:use-module (srfi srfi-9)
  #:use-module (srfi srfi-13)
  #:export (niri-config niri-capability
                        serialize-kdl
                        serialize-bindings
                        serialize-declaration
                        rule
                        make-rule
                        rule?
                        rule-selector
                        rule-declarations
                        set-rule-selector!
                        declaration
                        make-declaration
                        declaration?
                        declaration-property
                        declaration-value
                        prop
                        make-declaration-prop
                        declaration-prop
                        declaration-prop-props
                        rul
                        dec))

(define-record-type rule
  (make-rule selector declarations) rule?
  (selector rule-selector set-rule-selector!)
  (declarations rule-declarations set-rule-declarations!))

(define* (rul selector . args)
  (make-rule selector
             (flatten-list args)))

(define-record-type declaration
  (make-declaration property value) declaration?
  (property declaration-property)
  (value declaration-value))

(define dec
  make-declaration)

(define-record-type declaration-prop
  (make-declaration-prop props) declaration-prop?
  (props declaration-prop-props))

(define prop
  make-declaration-prop)

(define* (niri-input-config #:key caps-to-ctrl? keyboard-layout)
  (rul 'input
       (rul 'keyboard
            (rul 'xkb
                 (dec 'layout keyboard-layout)
                 (dec 'options
                      (if caps-to-ctrl? "ctrl:nocaps" "")))
            (dec 'numlock #t))
       (rul 'touchpad
            (dec 'tap #t))
       (dec 'warp-mouse-to-focus #t)
       (dec 'focus-follows-mouse
            (prop '((max-scroll-amount "\"0%\""))))
       (dec 'workspace-auto-back-and-forth #t)))

(define* (niri-layout-config #:key palette)
  (rul 'layout
       (dec 'gaps 16)
       (dec 'center-focused-column "never")
       (rul 'preset-column-widths
            (dec 'proportion 0.333333)
            (dec 'proportion 0.5)
            (dec 'proportion 0.666666))
       (rul 'default-column-width
            (dec 'proportion 0.666666))
       (rul 'focus-ring
            (dec 'width 2)
            (dec 'active-color
                 (get-color palette
                            'primary))
            (dec 'inactive-color
                 (get-color palette
                            'background-l)))
       (rul 'shadow
            (dec 'on #t)
            (dec 'draw-behind-window
                 'true)
            (dec 'softness 30)
            (dec 'spread 5)
            (dec 'offset
                 (prop '((x 0)
                         (y 5))))
            (dec 'color "#0007"))
       (rul 'struts
            (dec 'left 5)
            (dec 'right 5)
            (dec 'top 5)
            (dec 'bottom 5))))

(define (niri-intro)
  "// ====== SSS Niri configuration ======
//
// auto-generated file, DO NOT EDIT!")

(define (spawn-sh cmd)
  (format #f "spawn-sh \"~a\"" cmd))

(define (spawn-sh-at-startup cmd)
  (format #f "spawn-sh-at-startup \"~a\"" cmd))

(define (swaylock-cmd)
  (string-join '("swaylock" "--screenshots"
                 "--clock"
                 "--indicator"
                 "--indicator-radius 100"
                 "--indicator-thickness 7"
                 "--effect-blur 7x5"
                 "--effect-vignette 0.5:0.5"
                 "--ring-color bb00cc"
                 "--key-hl-color 880033"
                 "--line-color 00000000"
                 "--inside-color 00000088"
                 "--separator-color 00000000"
                 "--grace 2"
                 "--fade-in 0.2") " "))

(define (niri-bindings)
  (list (bnd #:mod "s"
             #:bind "K"
             #:cmd "close-window")
        (bnd #:mod "s"
             #:bind "O"
             #:cmd "toggle-overview")
        (bnd #:mod "s"
             #:bind "?"
             #:cmd "show-hotkey-overlay")
        (bnd #:mod "XF86AudioRaiseVolume"
             #:cmd (spawn-sh "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+")
             #:allow-when-locked? #t)
        (bnd #:mod "XF86AudioLowerVolume"
             #:cmd (spawn-sh "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-")
             #:allow-when-locked? #t)
        (bnd #:mod "XF86AudioMute"
             #:cmd (spawn-sh "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle")
             #:allow-when-locked? #t)
        (bnd #:mod "XF86AudioPlay"
             #:cmd (spawn-sh "playerctl play-pause")
             #:allow-when-locked? #t)
        (bnd #:mod "XF86AudioStop"
             #:cmd (spawn-sh "playerctl stop")
             #:allow-when-locked? #t)
        (bnd #:mod "XF86AudioPrev"
             #:cmd (spawn-sh "playerctl previous")
             #:allow-when-locked? #t)
        (bnd #:mod "XF86AudioNext"
             #:cmd (spawn-sh "playerctl next")
             #:allow-when-locked? #t)
        (bnd #:mod "XF86MonBrightnessUp"
             #:cmd (spawn-sh "sudo light -A 5")
             #:allow-when-locked? #t)
        (bnd #:mod "XF86MonBrightnessDown"
             #:cmd (spawn-sh "sudo light -U 5")
             #:allow-when-locked? #t)
        ;;
        (bnd #:mod "s-S"
             #:bind "Q"
             #:cmd "quit")
        (bnd #:mod "C-M"
             #:bind "DEL"
             #:cmd "quit")
        (bnd #:mod "s-C"
             #:bind "E"
             #:cmd (spawn-sh
                    "bash ~/.local/bin/user-script-restart-emacs.bash"))
        ;;
        
        ;;
        (bnd #:mod "s"
             #:bind "T"
             #:cmd (spawn-sh "alacritty msg create-window || alacritty"))
        (bnd #:mod "s"
             #:bind "RET"
             #:cmd (spawn-sh "alacritty msg create-window || alacritty"))
        (bnd #:mod "s-S"
             #:bind "B"
             #:cmd (spawn-sh "herd trigger user-timer-set-random-wallpaper"))
        (bnd #:mod "s-S"
             #:bind "T"
             #:cmd (spawn-sh
                    "emacsclient -ce '(eshell \\\"new\\\")(rename-buffer (concat \\\"*eshell: \\\" (float-time) \\\"*\\\"))'"))
        (bnd #:mod "s"
             #:bind "E"
             #:cmd (spawn-sh "emacsclient -c"))
        (bnd #:mod "s-S"
             #:bind "E"
             #:cmd (spawn-sh "alacritty -e emacsclient -t"))
        (bnd #:mod "s"
             #:bind "I"
             #:cmd (spawn-sh "flatpak run com.brave.Browser"))
        (bnd #:mod "s-S"
             #:bind "I"
             #:cmd (spawn-sh "firefox"))
        (bnd #:mod "s"
             #:bind "B"
             #:cmd (spawn-sh "nautilus -w"))
        (bnd #:mod "s"
             #:bind "/"
             #:cmd (spawn-sh "rofi -show drun"))
        (bnd #:mod "s"
             #:bind "space"
             #:cmd "toggle-window-floating")
        ;;
        (bnd #:mod "s"
             #:bind "S"
             #:cmd "screenshot")
        (bnd #:mod "s-S"
             #:bind "S"
             #:cmd "screenshot-screen")
        (bnd #:mod "C-M"
             #:bind "S"
             #:cmd "screenshot-window")
        ;;
        (bnd #:mod "s"
             #:bind "Left"
             #:cmd "focus-column-left")
        (bnd #:mod "s"
             #:bind "Down"
             #:cmd "focus-window-down")
        (bnd #:mod "s"
             #:bind "Up"
             #:cmd "focus-window-up")
        (bnd #:mod "s"
             #:bind "Right"
             #:cmd "focus-column-right")
        (bnd #:mod "s-S"
             #:bind "Left"
             #:cmd "move-column-left")
        (bnd #:mod "s-S"
             #:bind "Down"
             #:cmd "move-window-down")
        (bnd #:mod "s-S"
             #:bind "Up"
             #:cmd "move-window-up")
        (bnd #:mod "s-S"
             #:bind "Right"
             #:cmd "move-column-right")
        ;;
        (bnd #:mod "C-M"
             #:bind "Left"
             #:cmd "focus-monitor-left")
        (bnd #:mod "C-M"
             #:bind "Down"
             #:cmd "focus-monitor-down")
        (bnd #:mod "C-M"
             #:bind "Up"
             #:cmd "focus-monitor-up")
        (bnd #:mod "C-M"
             #:bind "Right"
             #:cmd "focus-monitor-right")
        (bnd #:mod "C-M-S"
             #:bind "Left"
             #:cmd "move-column-to-monitor-left")
        (bnd #:mod "C-M-S"
             #:bind "Down"
             #:cmd "move-column-to-monitor-down")
        (bnd #:mod "C-M-S"
             #:bind "Up"
             #:cmd "move-column-to-monitor-up")
        (bnd #:mod "C-M-S"
             #:bind "Right"
             #:cmd "move-column-to-monitor-right")
        (bnd #:mod "s"
             #:bind "Page_Down"
             #:cmd "focus-workspace-down")
        (bnd #:mod "s"
             #:bind "Page_Up"
             #:cmd "focus-workspace-up")
        (bnd #:mod "s-S"
             #:bind "Page_Down"
             #:cmd "move-column-to-workspace-down")
        (bnd #:mod "s-S"
             #:bind "Page_Up"
             #:cmd "move-column-to-workspace-up")

        ;;
        (bnd #:mod "s"
             #:bind "-"
             #:cmd "set-column-width \"-10%\"")
        (bnd #:mod "s"
             #:bind "="
             #:cmd "set-column-width \"+10%\"")
        (bnd #:mod "s-S"
             #:bind "-"
             #:cmd "set-window-height \"-10%\"")
        (bnd #:mod "s-S"
             #:bind "="
             #:cmd "set-window-height \"+10%\"")
        (bnd #:mod "s"
             #:bind "F"
             #:cmd "maximize-column")
        (bnd #:mod "s-S"
             #:bind "F"
             #:cmd "fullscreen-window")
        (bnd #:mod "s"
             #:bind "C"
             #:cmd "center-column")
        (bnd #:mod "s"
             #:bind "ESC"
             #:cmd "toggle-keyboard-shortcuts-inhibit"
             #:allow-inhibiting? #f)
        ;;
        (bnd #:mod "s"
             #:bind "L"
             #:cmd (spawn-sh (swaylock-cmd)))
        ;;
        (bnd #:mod "s-S"
             #:bind "/"
             #:cmd "show-hotkey-overlay")
        (bnd #:mod "s"
             #:bind "U"
             #:cmd "focus-workspace-up")
        (bnd #:mod "s"
             #:bind "R"
             #:cmd "switch-preset-column-width")
        (bnd #:mod "s"
             #:bind "D"
             #:cmd "focus-workspace-down")
        (bnd #:mod "s"
             #:bind ","
             #:cmd "consume-window-into-column")
        (bnd #:mod "s"
             #:bind "."
             #:cmd "expel-window-from-column")))

(define (niri-translate-mod mod)
  (cond
    ((equal? "s" mod)
     "Mod")
    ((equal? "s-S" mod)
     "Mod+Shift")
    ((equal? "s-C" mod)
     "Mod+Ctrl")
    ((equal? "C-M" mod)
     "Ctrl+Alt")
    ((equal? "M" mod)
     "Alt")
    ((equal? "C-M-S" mod)
     "Ctrl+Alt+Shift")
    (else mod)))

(define (niri-translate-bind bind)
  (cond
    ((equal? "mouse-left" bind)
     "mouse:272")
    ((equal? "mouse-right" bind)
     "mouse:273")
    ((equal? "DEL" bind)
     "Delete")
    ((equal? "RET" bind)
     "Return")
    ((equal? "." bind)
     "Period")
    ((equal? "," bind)
     "Comma")
    ((equal? "?" bind)
     "question")
    ((equal? "-" bind)
     "Minus")
    ((equal? "=" bind)
     "Equal")
    ((equal? "/" bind)
     "slash")
    ((equal? "ESC" bind)
     "Escape")
    (else bind)))

(define (serialize-bindings xs)
  (string-join (map (lambda (b)
                      (format #f
                              "~a~a~a~a{ ~a; }"
                              (niri-translate-mod (assoc-ref b
                                                             'mod))
                              (if (not (assoc-ref b
                                                  'bind)) ""
                                  (format #f "+~a"
                                          (niri-translate-bind (assoc-ref b
                                                                          'bind))))
                              (if (assoc-ref b
                                             'allow-when-locked?)
                                  " allow-when-locked=true " " ")
                              (if (not (assoc-ref b
                                                  'allow-inhibiting?))
                                  " allow-inhibiting=false " " ")
                              (assoc-ref b
                                         'cmd))) xs) "\n  "))

(define* (bnd #:key mod
              bind
              cmd
              (allow-when-locked? #f)
              (allow-inhibiting? #t))
  `((mod unquote mod)
    (bind unquote bind)
    (cmd unquote cmd)
    (allow-when-locked? unquote allow-when-locked?)
    (allow-inhibiting? unquote allow-inhibiting?)))

(define* (niri-startup-programs #:key palette sans-font mono-font
                                (extra-startups '()))
  (let* ((gtk-theme-name (get-gtk-theme palette))
         (icon-theme-name (get-icon-theme palette))
         (cursor-theme-name (get-cursor-theme palette))
         (xs (append extra-startups
                     `("mako" "dbus-update-activation-environment --all"
                       "waybar"
                       "herd trigger user-timer-set-random-wallpaper"
                       "alacritty --daemon"
                       "emacs --daemon"
                       "transmission-daemon"
                       "podman system service --time=0 unix:///tmp/podman.sock"
                       "xdg-user-dirs-update"
                       ,(format #f "fyi \\\"~a\\\" \\\"~a\\\""
                                (G_
                                 "Welcome to the SSS/GNU power user session")
                                (G_
                                 "Enter and explore, for the cosmos of computation is yours to command."))
                       "sh ~/.local/bin/write-gtk-dconf-settings.sh"
                       "sh ~/.local/bin/write-sss-dconf-settings.sh"
                       ,(string-join (list "swayidle -w"
                                      (format #f "timeout 300 '~a'"
                                              (swaylock-cmd))
                                      "timeout 600 'niri msg action power-off-monitors'"
                                      "resume 'niri msg action power-on-monitors'"
                                      (format #f "before-sleep '~a'"
                                              (swaylock-cmd))) " ")))))
    xs))

(define* (serialized-startups #:key palette sans-font mono-font
                              (extra-startups '()))
  (string-join (map spawn-sh-at-startup
                    (niri-startup-programs #:palette palette
                                           #:sans-font sans-font
                                           #:mono-font mono-font
                                           #:extra-startups extra-startups))
               "\n"))

(define* (niri-config #:key palette
                      sans-font
                      mono-font
                      keyboard-layout
                      caps-to-ctrl?
                      (extra-startups '()))
  (list (niri-intro)
        (niri-input-config #:caps-to-ctrl? caps-to-ctrl?
                           #:keyboard-layout keyboard-layout)
        (niri-layout-config #:palette palette)
        (rul 'hotkey-overlay
             (dec 'skip-at-startup #t))
        (dec 'prefer-no-csd #t)
        (dec 'screenshot-path
             "~/pictures/screenshots/screen-%Y-%m-%d-%H-%M-%S.png")
        (rul 'animations
             (dec 'slowdown 1.0))
        (rul 'binds
             (serialize-bindings (niri-bindings)))
        (rul 'window-rule
             (dec 'geometry-corner-radius 10)
             (dec 'clip-to-geometry
                  'true)
             (dec 'draw-border-with-background
                  'false)
             (rul 'default-column-width
                  (dec 'proportion 0.6666666)))
        (serialized-startups #:palette palette
                             #:sans-font sans-font
                             #:mono-font mono-font
                             #:extra-startups extra-startups)))

(define* (niri-capability #:key palette
                          sans-font
                          mono-font
                          keyboard-layout
                          caps-to-ctrl?
                          (extra-startups '()))
  `((".config/niri/config.kdl" ,(plain-file "config.kdl"
                                            (string-join (serialize-kdl (niri-config
                                                                         #:palette
                                                                         palette
                                                                         #:sans-font
                                                                         sans-font
                                                                         #:mono-font
                                                                         mono-font
                                                                         #:keyboard-layout
                                                                         keyboard-layout
                                                                         #:caps-to-ctrl?
                                                                         caps-to-ctrl?
                                                                         #:extra-startups
                                                                         extra-startups))
                                                         "\n")))))

(define* (serialize-kdl xs
                        #:key (indent ""))
  (let* ((new-indent (format #f "~a~a" indent "  ")))
    (cond
      ((list? xs)
       (map (lambda (x)
              (serialize-kdl x
                             #:indent new-indent)) xs))
      ((rule? xs)
       (format #f
               "~a {\n~a~a\n~a}"
               (rule-selector xs)
               indent
               (cond
                 ((rule? (rule-declarations xs))
                  (serialize-kdl (rule-declarations xs)
                                 #:indent new-indent))
                 ((list? (rule-declarations xs))
                  (string-join (map (lambda (xx)
                                      (cond
                                        ((rule? xx)
                                         (serialize-kdl xx
                                                        #:indent new-indent))
                                        ((declaration? xx)
                                         (serialize-declaration xx))
                                        (else (format #f "~a" xx)))

                                      )
                                    (rule-declarations xs))
                               (format #f "\n~a" indent)))
                 (else (begin
                         (serialize-declaration (rule-declarations xs)))))
               (string-drop indent 2)))
      ((declaration? xs)
       (serialize-declaration xs))
      (else (format #f "~a" xs)))))

(define (serialize-declaration xs)
  (format #f "~a ~a"
          (declaration-property xs)
          (cond
            ((eq? #t
                  (declaration-value xs))
             "")
            ((declaration-prop? (declaration-value xs))
             (string-join (map (lambda (p)
                                 (format #f "~a=~a"
                                         (car p)
                                         (cadr p)))
                               (declaration-prop-props (declaration-value xs)))
                          " "))
            ((string? (declaration-value xs))
             (format #f "\"~a\""
                     (declaration-value xs)))
            (else (declaration-value xs)))))

