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

(define-module (sss packages wm)
  #:declarative? #t
  #:use-module (gnu packages glib)
  #:use-module (gnu packages freedesktop)
  #:use-module (gnu packages polkit)
  #:use-module (gnu packages wm)
  #:use-module (gnu packages xorg)
  #:use-module (gnu packages audio)
  #:use-module (gnu packages linux)
  #:use-module (gnu packages xdisorg)
  #:use-module (gnu packages terminals)
  #:use-module (gnu packages image)
  #:export (wm-packages))

(define wm-packages
  (make-parameter (list rofi-wayland
                        fzf
                        slurp
                        waybar-experimental
                        wmenu
                        swaybg
                        mako
                        wev
                        grimshot
                        wl-color-picker
                        qpwgraph
                        wireplumber
                        pipewire

                        wl-clipboard

                        ;; Wayland portals
                        xdg-desktop-portal
                        xdg-desktop-portal-hyprland
                        xdg-desktop-portal-gtk

                        ;; Compatibility for older Xorg applications
                        xorg-server-xwayland

                        polkit-gnome

                        ;; Flatpak and XDG utilities
                        flatpak-xdg-utils
                        xdg-utils
                        xdg-dbus-proxy
                        shared-mime-info
                        glib)))
