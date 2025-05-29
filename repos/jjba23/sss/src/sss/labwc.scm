
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

(define-module (sss labwc)
  #:declarative? #t
  #:use-module (gnu)
  #:use-module (sxml simple)
  #:use-module (sss palette)
  #:export (labwc-menu labwc-rc labwc-autostart labwc-config labwc-capability))

;; Work-in-progress: converting rc.xml to SXML
(define labwc-config
  `(*TOP* (*PI* xml "version=\"1.0\" encoding=\"UTF-8\"")
          (labwc_config (core (decoration server)
                              (gap 0)
                              (adaptiveSync no)
                              (allowTearing no)
                              (autoEnableOutputs yes)
                              (reuseOutputMode no)
                              (xwaylandPersistence yes))
                        (placement (policy cascade))
                        (theme (name "Numix")
                               (icon "Delft")
                               (titlebar (layout "icon:iconify,max,close")
                                         (showTitle yes))
                               (cornerRadius 8)
                               (keepBorder yes)
                               (dropShadows yes)
                               (font (@ (place ActiveWindow))
                                     (name "Adwaita Sans")
                                     (size 12)
                                     (slant normal)
                                     (weight normal))
                               (font (@ (place InactiveWindow))
                                     (name "Adwaita Sans")
                                     (size 12)
                                     (slant normal)
                                     (weight normal))
                               (font (@ (place MenuHeader))
                                     (name "Adwaita Sans")
                                     (size 12)
                                     (slant normal)
                                     (weight normal))
                               (font (@ (place MenuItem))
                                     (name "Adwaita Sans")
                                     (size 12)
                                     (slant normal)
                                     (weight normal))
                               (font (@ (place OnScreenDisplay))
                                     (name "Adwaita Sans")
                                     (size 12)
                                     (slant normal)
                                     (weight normal)))
                        (windowSwitcher (@ (show yes)
                                           (preview yes)
                                           (outlines yes)
                                           (allWorkspaces no))
                                        (fields (field (@ (content type)
                                                          (width "25%")))
                                                (field (@ (content
                                                           trimmed_identifier)
                                                          (width "25%")))
                                                (field (@ (content title)
                                                          (width "50%")))))
                        (resistance (screenEdgeStrength 20)
                                    (windowEdgeStrength 20)
                                    (unSnapThreshold 20)
                                    (unMaximizeThreshold 150))
                        (resize (popupShow Never)
                                (drawContents yes))
                        (focus (followMouse no)
                               (followMouseRequiresMovement yes)
                               (raiseOnFocus no))
                        (snapping (range 1)
                                  (overlay (@ (enabled yes))
                                           (delay (@ (inner 500)
                                                     (outer 500))))
                                  (topMaximize yes)
                                  (notifyClient always)))))

(define labwc-menu
  `(*TOP* (*PI* xml "version=\"1.0\" encoding=\"UTF-8\"")
          (openbox_menu (menu (@ (id client-menu))
                              (item (@ (label "Minimize"))
                                    (action (@ (name Iconify))))
                              (item (@ (label "Maximize"))
                                    (action (@ (name ToggleMaximize))))
                              (item (@ (label "Fullscreen"))
                                    (action (@ (name ToggleFullscreen))))
                              (item (@ (label "Roll Up/Down"))
                                    (action (@ (name ToggleShade))))
                              (item (@ (label "Decorations"))
                                    (action (@ (name ToggleDecorations))))
                              (item (@ (label "Always on Top"))
                                    (action (@ (name ToggleAlwaysOnTop))))
                              ;; Any menu with the id "workspaces" will be hidden
                              ;; if there is only a single workspace available.
                              (menu (@ (id workspaces)
                                       (label "Workspace"))
                                    (item (@ (label "Move Left"))
                                          (action (@ (name SendToDesktop)
                                                     (to left))))
                                    (item (@ (label "Move Right"))
                                          (action (@ (name SendToDesktop)
                                                     (to right))))
                                    (item (@ (label
                                              "Always on Visible Workspace"))
                                          (action (@ (name ToggleOmnipresent)))))
                              (item (@ (label "Close"))
                                    (action (@ (name Close)))))
                        (menu (@ (id root-menu))
                              (item (@ (label "Web - Chrome"))
                                    (action (@ (name Execute)
                                               (command "google-chrome-beta"))))
                              (item (@ (label "Web - Firefox"))
                                    (action (@ (name Execute)
                                               (command "firefox"))))
                              (item (@ (label "Terminal"))
                                    (action (@ (name Execute)
                                               (command "xfce4-terminal"))))
                              (item (@ (label "File Manager"))
                                    (action (@ (name Execute)
                                               (command "nemo"))))
                              (item (@ (label "Text Editor"))
                                    (action (@ (name Execute)
                                               (command "geany"))))
                              (item (@ (label "Reconfigure"))
                                    (action (@ (name Reconfigure))))
                              (item (@ (label "Exit"))
                                    (action (@ (name Exit))))
                              (item (@ (label "Sleep"))
                                    (action (@ (name Execute)
                                               (command "loginctl suspend"))))
                              (item (@ (label "Power off"))
                                    (action (@ (name Execute)
                                               (command "loginctl poweroff"))))))))

(define labwc-rc
  (local-file "./labwc/rc.xml"))

(define* (labwc-autostart #:key (extra-startups '()))
  (plain-file "autostart"
              (string-join (append extra-startups
                                   '("lxsession >/dev/null 2>&1 &"
                                     "mako >/dev/null 2>&1 &"
                                     "dbus-update-activation-environment --all >/dev/null 2>&1 &"
                                     "transmission-daemon >/dev/null 2>&1 &"
                                     "waybar >/dev/null 2>&1 &"
                                     "herd trigger set-random-wallpaper >/dev/null 2>&1 &"
                                     "transmission-daemon >/dev/null 2>&1 &"
                                     "podman system service --time=0 unix:///tmp/podman.sock >/dev/null 2>&1 &"
                                     "xdg-user-dirs-update 2>&1 &")) "\n")))

(define* (labwc-capability #:key extra-startups)
  `((".config/labwc/rc.xml" ,labwc-rc)
    (".config/labwc/menu.xml" ,(plain-file "menu.xml"
                                           (with-output-to-string (lambda ()
                                                                    (sxml->xml
                                                                     labwc-menu)))))
    (".config/labwc/autostart" ,(labwc-autostart #:extra-startups
                                                 extra-startups))))

