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

(define-module (sss hyprland hyprlock)
  #:declarative? #t
  #:use-module (gnu)
  #:use-module (sss palette)
  #:use-module (sss hyprland hyprlang)
  #:export (sss-hyprlock-config sss-hyprlock-capability))

;; hyprlock: Hyprland's simple, yet multi-threaded and GPU-accelerated screen locking utility.
;;
;; https://github.com/hyprwm/hyprlock
(define* (sss-hyprlock-config #:key clone-dir)
  (let* ((serialized-img (serialize-hypr-section #:section 'image
                                                 #:settings `((monitor . "") (path
                                                                              unquote

                                                                              
                                                                              (format
                                                                               #f
                                                                               "~a/resources/img/sss.png"
                                                                               clone-dir))
                                                              (position . "0, 230")
                                                              (rounding . "-1")
                                                              (size . "200")
                                                              (border_size . 2)
                                                              (border_color . "rgba(160, 160, 160, 0.5)")
                                                              (halign . center)
                                                              (valign . center))))
         (serialized-clock (serialize-hypr-section #:section 'label
                                                   #:settings `((monitor . "")
                                                                (text . "cmd[update:1000] echo \"<span foreground='##ffffff'>$(date)</span>\"")
                                                                (color . "rgba(200, 200, 200, 1.0)")
                                                                (font_size . 26)
                                                                (font_family . "Adwaita Sans")
                                                                (position . "0, 380")
                                                                (halign . center)
                                                                (valign . center))))
         (serialized-greeting (serialize-hypr-section #:section 'label
                                                      #:settings `((monitor . "")
                                                                   (text . "<b>$USER @ SSS/GNU</b>")
                                                                   (color . "rgba(200, 200, 200, 1.0)")
                                                                   (font_size . 20)
                                                                   (font_family . "Adwaita Sans")
                                                                   (position . "0, 80")
                                                                   (halign . center)
                                                                   (valign . center))))
         (serialized-greeting2 (serialize-hypr-section #:section 'label
                                                       #:settings `((monitor . "")
                                                                    (text . "<i>Supreme Sexp System</i>")
                                                                    (color . "rgba(180, 180, 180, 1.0)")
                                                                    (font_size . 14)
                                                                    (font_family . "Adwaita Sans")
                                                                    (position . "0, 40")
                                                                    (halign . center)
                                                                    (valign . center))))
         (serialized-animations (serialize-hypr-section #:section 'animations
                                                        #:settings `((enabled . true)
                                                                     (bezier . "linear, 1, 1, 0, 0")
                                                                     (animation . "fadeIn, 1, 5, linear")
                                                                     (animation . "fadeOut, 1, 5, linear"))))
         (serialized-input-field (serialize-hypr-section #:section 'input-field
                                                         #:settings `((monitor . "")
                                                                      (position . "0, -100")
                                                                      (fade_on_empty . false)
                                                                      (size . "360, 70")
                                                                      (dots_size . "0.2")
                                                                      (placeholder_text . "enter your password...")
                                                                      (inner_color . "rgba(200, 200, 200, 0.5)")
                                                                      (outer_color . "rgba(160, 160, 160, 0.5)")
                                                                      (font_color . "rgba(20, 20, 20, 0.5)")
                                                                      (font_family . "Adwaita Sans"))))
         (serialized-general-field (serialize-hypr-section #:section 'general
                                                           #:settings `((hide_cursor . false)
                                                                        (grace . 0)
                                                                        (fractional_scaling . 2))))
         (serialized-background (serialize-hypr-section #:section 'background
                                                        #:settings `((path . screenshot)
                                                                     (blur_passes . 2)
                                                                     (color . "rgb(10, 10, 10)"))))
         (config-lines (append `("# ====== SSS Hyprlock configuration ======"
                                 "#" "# auto-generated file, DO NOT EDIT!" "")
                               `("# ====== UI elements ======" ""
                                 ,serialized-img
                                 ,serialized-clock
                                 ,serialized-greeting
                                 ,serialized-greeting2)
                               `("# ====== Animations configuration ======" "")
                               (list serialized-animations)
                               `("# ====== InputField configuration ======" "")
                               (list serialized-input-field)
                               `("# ====== General configuration ======" "")
                               (list serialized-general-field)
                               `("# ====== Background configuration ======" "")
                               (list serialized-background))))
    
    (string-join config-lines "\n")))

(define* (sss-hyprlock-capability #:key clone-dir)
  `((".config/hypr/hyprlock.conf" ,(plain-file "hyprlock.conf"
                                               (sss-hyprlock-config
                                                                    #:clone-dir
                                                                    clone-dir)))))

