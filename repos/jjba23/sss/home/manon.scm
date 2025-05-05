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

;; Code:

(use-modules (gnu)
             (gnu bootloader)
             (gnu system file-systems))

;; load SSS defaults
(load "../system/sss-defaults.scm")

;; load user preferences per-host
(load "../per-host.scm")

;; show input settings
(load "../system/show-settings.scm")
(sss-show-settings)

(load "../lib/path.scm")

;; Autoload all Scheme modules in lib and subdirectories
;; All modules should have the `.scm' extension
(load-lib-modules)

;; Load Guile modules
(use-modules (gnu home)
             (gnu services)
             (guix gexp)
             (gnu packages admin)
             (gnu home services)
             (gnu home services shells)
             (gnu home services ssh)
             (gnu home services gnupg)
             (gnu home services shepherd)
             (gnu home services sound)
             (gnu home services desktop)
             (json)
             (sxml simple))

;; Load SSS modules
(use-modules (sss process)
             (sss foot)
             (sss git)
             (sss vars)
             (sss mako)
             (sss enchant)
             (sss fontconfig)
             (sss bash)
             (sss gtk)
             (sss nix)
             (sss containers)
             (sss portals)
             (sss qt)
             (sss channels)
             (sss mime)
             (sss openpgp)
             (sss waybar)
             (sss rofi)
             (sss ssh)
             (sss labwc))

(define sss-home-files-service
  (service home-files-service-type
           (append (sss-gtk3-svc #:palette sss-palette)
                   (sss-gtk4-svc #:palette sss-palette)
                   (sss-nix-svc)
                   (sss-rofi-svc #:palette sss-palette)
                   (sss-mime-svc)
                   (sss-waybar-svc #:palette sss-palette
                                   #:with-memory #f
                                   #:labwc-session #t)
                   (sss-portals-svc)
                   (sss-mako-svc #:palette sss-palette)
                   (sss-containers-svc)
                   (sss-labwc-svc #:extra-startups sss-labwc-extra-startups))))

(display "
>>= configuring Manon's home environment...
")
(home-environment
  (services
   (append (list sss-home-files-service
                 (sss-home-vars-service #:clone-dir sss-clone-dir
                                        #:lang sss-lang)
                 (sss-bash-service #:clone-dir sss-clone-dir)
                 sss-openpgp-conf
                 (service home-dbus-service-type)
                 (service home-pipewire-service-type)
                 sss-fontconfig-service-type
                 sss-channels-service) %base-home-services)))

