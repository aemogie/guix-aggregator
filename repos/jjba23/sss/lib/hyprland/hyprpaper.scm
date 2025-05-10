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

(define-module (sss hyprland hyprpaper)
  #:use-module (gnu)
  #:use-module (sss palette)
  #:use-module (sss hyprland hyprlang))

;; Define diverse wallpapers based on the active color scheme. 
(begin
  (define* (sss-hypr-wallpaper #:key clone-dir palette)
    (cond
      ((eq? 'sss-palette-ef-cyprus palette)
       (format #f "~a/resources/wallpapers/some-forest.jpg" clone-dir))
      ((eq? 'sss-palette-ef-dream palette)
       (format #f "~a/resources/wallpapers/1362745.png" clone-dir))
      ((eq? 'sss-palette-heavy-metal palette)
       (format #f "~a/resources/wallpapers/heavy-wall3.jpg" clone-dir))
      ((eq? 'sss-palette-solarized-light palette)
       (format #f "~a/resources/wallpapers/PXL_20250326_193029385.MP.jpg"
               clone-dir))
      ((eq? 'sss-palette-ef-autumn palette)
       (format #f "~a/resources/wallpapers/0mar2ygf59je1.jpeg" clone-dir))
      ((eq? 'sss-palette-everforest-dark palette)
       (format #f "~a/resources/wallpapers/redwood-forest.jpg" clone-dir))
      ((eq? 'sss-palette-everforest-light palette)
       (format #f "~a/resources/wallpapers/joshua.jpg" clone-dir))
      (else (format #f "~a/resources/wallpapers/some-forest.jpg" clone-dir))))
  (export sss-hypr-wallpaper))

;; hyprpaper: Hyprpaper is a blazing fast wallpaper utility for Hyprland
;; with the ability to dynamically change wallpapers through sockets.
;; It will work on all wlroots-based compositors, though.
;;
;; https://github.com/hyprwm/hyprpaper
(begin
  (define* (sss-hyprpaper-config #:key img)
    (let* ((config-lines (map (lambda (l)
                                (serialize-hypr-setting (car l)
                                                        (cdr l)))
                              `((preload unquote img)
                                (splash . false)
                                (wallpaper unquote
                                           (format #f ",~a" img))))))
      (string-join (append `("# ====== SSS Hyprpaper configuration ======" "#"
                             "# auto-generated file, DO NOT EDIT!" "")
                           config-lines) "\n")))
  (export sss-hyprpaper-config))

(begin
  (define* (sss-hyprpaper-svc #:key clone-dir palette)
    `((".config/hypr/hyprpaper.conf" ,(plain-file "hyprpaper.conf"
                                                  (sss-hyprpaper-config #:img (sss-hypr-wallpaper
                                                                               #:clone-dir
                                                                               clone-dir
                                                                               #:palette
                                                                               palette))))))
  (export sss-hyprpaper-svc))
