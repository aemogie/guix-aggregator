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

(define-module (sss hyprland hypridle)
  #:declarative? #t
  #:use-module (gnu)
  #:use-module (sss palette)
  #:use-module (sss hyprland hyprlang)
  #:export (hypridle-config hypridle-capability))

(define* (hypridle-config #:key brightness-timeout-seconds lock-screen-seconds
                          monitor-power-seconds)
  (let* ((serialized-general (serialize-hypr-section #:section 'general
                                                     #:settings `((lock_cmd . "pidof hyprlock || hyprlock")
                                                                  (before_sleep_cmd . "loginctl lock-session")
                                                                  (after_sleep_cmd . "hyprctl dispatch dpms on"))))
         (serialized-brightness (serialize-hypr-section #:section 'listener
                                                        #:settings `((timeout
                                                                      unquote
                                                                      brightness-timeout-seconds)
                                                                     (on-timeout . "sudo light -S 10")
                                                                     (on-resume . "sudo light -S 90"))))
         (serialized-monitor-power (serialize-hypr-section #:section 'listener
                                                           #:settings `((timeout
                                                                         unquote
                                                                         monitor-power-seconds)
                                                                        (on-timeout . "hyprctl dispatch dpms off")
                                                                        (on-resume . "hyprctl dispatch dpms on && sudo light -I"))))
         (serialized-lock-screen (serialize-hypr-section #:section 'listener
                                                         #:settings `((timeout
                                                                       unquote
                                                                       lock-screen-seconds)
                                                                      (on-timeout . "hyprlock"))))
         (config-lines (append `("# ====== SSS Hypridle configuration ======"
                                 "#" "# auto-generated file, DO NOT EDIT!" "")
                               `("# ====== General ======" "")
                               (list serialized-general)
                               `("" "# ====== Brightness ======" "")
                               (list serialized-brightness)
                               `("" "# ====== Lock screen ======" "")
                               (list serialized-lock-screen)
                               `("" "# ====== Monitor Power ======" "")
                               (list serialized-monitor-power))))
    (string-join config-lines "\n")))

(define* (hypridle-capability #:key brightness-timeout-seconds
                              lock-screen-seconds monitor-power-seconds)
  `((".config/hypr/hypridle.conf" ,(plain-file "hypridle.conf"
                                               (hypridle-config
                                                #:brightness-timeout-seconds
                                                brightness-timeout-seconds
                                                #:lock-screen-seconds
                                                lock-screen-seconds
                                                #:monitor-power-seconds
                                                monitor-power-seconds)))))

