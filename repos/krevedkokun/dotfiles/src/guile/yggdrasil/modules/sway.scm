(define-module (yggdrasil modules sway)
  #:use-module (gnu home services)
  #:use-module ((gnu packages admin) #:select (wlgreet))
  #:use-module ((gnu packages wm) #:select (sway swaylock swayidle))
  #:use-module ((gnu packages xdisorg) #:select (wl-clipboard))
  #:use-module ((gnu packages xorg) #:select (xorg-server-xwayland))
  #:use-module (gnu services)
  #:use-module ((gnu services base)
                #:select (greetd-service-type
                          greetd-configuration
                          greetd-terminal-configuration
                          greetd-wlgreet-sway-session))
  #:use-module ((gnu services xorg)
                #:select (screen-locker-service-type
                          screen-locker-configuration))
  #:use-module (guix gexp)
  #:use-module (ice-9 match)
  #:use-module ((rde home services wm)
                #:select (home-sway-service-type
                          home-sway-configuration
                          home-swayidle-service-type
                          home-swayidle-configuration
                          home-swaylock-service-type
                          home-swaylock-configuration))
  #:use-module (srfi srfi-171))

(define (home-services)
  (define number->symbol (compose string->symbol number->string))

  (list
   (simple-service 'sway-packages
     home-profile-service-type
     (list wl-clipboard
           xorg-server-xwayland))
   (service
    home-swaylock-service-type
    (home-swaylock-configuration
     (config `((daemonize . #t)))))
   (service
    home-swayidle-service-type
    (home-swayidle-configuration
     (config
      `((lock ,(file-append swaylock "/bin/swaylock"))
        (before-sleep ,(file-append swaylock "/bin/swaylock"))
        (timeout 1800 ,(file-append swaylock "/bin/swaylock"))
        ( timeout 2400 ,#~(format #f "'~a/bin/swaymsg \"output * dpms off\"'" #$sway)
          resume ,#~(format #f "'~a/bin/swaymsg \"output * dpms on\"'" #$sway))))))
   (service
    home-sway-service-type
    (home-sway-configuration
     (config
      `((set $mod Mod4)
        (set $left b)
        (set $right f)
        (set $up p)
        (set $down n)
        ( bindsym
          (($mod+c kill)
           ($mod+q reload)
           ($mod+$up focus prev)
           ($mod+Shift+q exec ,(file-append sway "/bin/swaymsg") exit)
           ($mod+$down focus next)
           ($mod+Tab layout toggle split tabbed)
           ($mod+Shift+Tab split toggle)
           ($mod+grave floating toggle)
           ($mod+Shift+grave focus mode_toggle)
           ,@(list-transduce
              (compose
               (tenumerate 1)
               (tappend-map
                (match-lambda
                  ((n . ws)
                   (let ((ws-bind (symbol-append '$mod+ (number->symbol n)))
                         (ws-move-bind (symbol-append '$mod+Shift+ (number->symbol n))))
                     `((,ws-bind workspace ,ws)
                       (,ws-move-bind move container to workspace ,ws)))))))
              rcons
              '(TERM WEB EMACS CAD VIDEO MISC))))
        (xwayland enable)
        (workspace_auto_back_and_forth yes)
        (focus_follows_mouse no)
        (smart_borders on)
        (title_align center)
        (output eDP-1 scale 1.5)
        (input type:touchpad events disabled)
        ( input 1390:307:DEFT_Pro_TrackBall
          ((scroll_method on_button_down)
           (scroll_button BTN_BACK)))
        ( input type:keyboard
	  ((xkb_layout us,ru)
           (xkb_variant workman,workman)
           (xkb_options grp:shift_caps_switch,lv3:ralt_switch)))
        ( input 1:1:AT_Translated_Set_2_keyboard
	  ((xkb_layout us,ru)
           (xkb_variant basic,common)
           (xkb_options grp:toggle,ctrl:swapcaps)))
        (for_window "[app_id=\"^.*\"]" inhibit_idle fullscreen)
        (for_window
         "[title=\"^(?:Open|Save) (?:File|Folder|As).*\"]"
         floating enable, resize set width 70 ppt height 70 ppt)
        (font "Iosevka, Light 14")
        (client.focused "#f0f0f0" "#f0f0f0" "#721045" "#721045" "#721045")
        (client.unfocused "#ffffff" "#ffffff" "#595959")
        (default_border normal 0)
        (default_floating_border none)
        (gaps inner 8)
        (bar
         (#;(status_command i3blocks)
          (position bottom)
          (separator_symbol "|")
          (font "Iosevka, Light 18")
          (pango_markup enabled)
          (gaps 8)
          (colors
           ((statusline "#000000")
            (background "#FFFFFF")
            (focused_workspace "#f0f0f0" "#f0f0f0" "#721045")
            (inactive_workspace "#ffffff" "#ffffff" "#595959")))))
        (exec ,(file-append swayidle "/bin/swayidle"))))))))

(define (system-services)
  (define wlgreet-sway-config
    `(( output *
        ((background #{#FFFFFF}# solid_color)
         (scale 1.0)))
      (seat * xcursor_theme Adwaita 24)
      ( input type:keyboard
	((xkb_layout us)
         (xkb_variant workman)))
      ( input 1:1:AT_Translated_Set_2_keyboard
	((xkb_layout us)
         (xkb_variant basic)))))

  (list
   (service
    greetd-service-type
    (greetd-configuration
     (greeter-supplementary-groups '("seat" "video" "input"))
     (terminals
      (list (greetd-terminal-configuration
             (terminal-vt "1"))
            (greetd-terminal-configuration
             (terminal-vt "2"))
            (greetd-terminal-configuration
             (terminal-vt "3")
             (terminal-switch #t)
             (default-session-command
               (greetd-wlgreet-sway-session
                (sway sway)
                (sway-configuration
                 (apply
                  mixed-text-file
                  "wlgreet-sway-config"
                  ((@@ (rde home services wm) serialize-sway-config)
                   wlgreet-sway-config))))))))))
   (service
    screen-locker-service-type
    (screen-locker-configuration
     (name "swaylock")
     (program (file-append swaylock "/bin/swaylock"))
     (using-pam? #t)
     (using-setuid? #f)))))
