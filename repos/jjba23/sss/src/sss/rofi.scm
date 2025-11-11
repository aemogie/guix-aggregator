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

(define-module (sss rofi)
  #:declarative? #t
  #:use-module (gnu)
  #:use-module (sss palette)
  #:use-module (sss prelude)
  #:export (rofi-capability rofi-theme rofi-icon-theme rofi-configuration))

(define rofi-icon-theme
  (make-parameter "Adwaita"))

(define* (rofi-configuration #:key sans-font)
  (format #f "configuration {
    font: \"~a 14\";
    show-icons: true;
    icon-theme:	\"~a\";
    display-drun: \"\";
    disable-history: false;
    fullscreen: false;
    hide-scrollbar: false;
    sidebar-mode: false;
}

@theme \"./sss-theme.rasi\"" sans-font
          (rofi-icon-theme)))

(define* (rofi-theme #:key palette sans-font)
  `(("*" (foreground unquote
                     (get-color palette
                                'text))
     (backlight unquote
                (hex-to-rgba (get-color palette
                                        'background)
                             #:alpha 0.7))
     (background-color . "transparent")
     (highlight . "underline bold #ffffff")
     (font unquote
           (format #f "\"~a 14\"" sans-font)))
    ("window" (location . "center")
     (anchor . "center")
     (transparency . "\"real\"")
     (padding . "10px")
     (border . "0px")
     (border-radius . "12px")
     (spacing . "0")
     (background-color . "transparent")
     (orientation . "horizontal")
     (children . "[ mainbox ]"))
    ("message" (font unquote
                     (format #f "\"~a 14\"" sans-font))
     (border . "0px 2px 2px 2px")
     (color unquote
            (get-color palette
                       'text))
     (padding . "5px"))
    ("mainbox" (spacing . "0")
     (children . "[ inputbar, message, listview ]"))
    ("entry,prompt,case-indicator" (text-font . "inherit")
     (text-color . "inherit"))
    ("prompt" (margin . "0px 0.3em 0em 0em"))
    ("element" (padding . "3px")
     (vertical-align . "0.5")
     (border-radius . "2px")
     (background-color . "transparent")
     (text-color unquote
                 (get-color palette
                            'text))
     (font . "inherit"))
    ("listview" (padding . "8px")
     (border-radius . "16px")
     (background-color unquote
                       (hex-to-rgba (get-color palette
                                               'background)
                                    #:alpha 0.7))
     (dynamic . "false")
     (lines . "20"))
    ("element-text" (text-color unquote
                                (get-color palette
                                           'text)))
    ("element selected" (highlight . none)
     (text-color unquote
                 (get-color palette
                            'background))
     (background-color unquote
                       (hex-to-rgba (get-color palette
                                               'primary)
                                    #:alpha 0.7))
     (border-radius . "4px"))
    ("element-icon" (size . "1.1em"))
    ("inputbar" (color unquote
                       (get-color palette
                                  'text))
     (padding . "11px")
     (margin-bottom . "6px")
     (border-radius . "16px")
     (background-color unquote
                       (hex-to-rgba (get-color palette
                                               'background-l)
                                    #:alpha 0.7)))))

(define* (rofi-capability #:key palette sans-font)
  `((".config/rofi/config.rasi" ,(plain-file "config.rasi"
                                             (rofi-configuration #:sans-font
                                                                 sans-font)))
    
    (".config/rofi/sss-theme.rasi" ,(plain-file "sss-theme.rasi"
                                                (mk-css-conf-lines (rofi-theme
                                                                    #:palette
                                                                    palette
                                                                    #:sans-font
                                                                    sans-font))))))

