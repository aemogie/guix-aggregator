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

(load "./palette.scm")
(load "./process.scm")

(define-module (sss alacritty)
  #:use-module (gnu)
  #:use-module (gnu home services)
  #:use-module (sss palette)
  #:use-module (sss process)
  #:use-module (ice-9 string-fun))

(define sss-alacritty-general
  `((live_config_reload . true) (ipc_socket . true)))

(define sss-alacritty-window
  `((padding . "{ x = 14, y = 14}") (decorations . None)
    (opacity . 0.9)
    (blur . false) ;let WM take care of it
    ))

(define sss-alacritty-scrolling
  `((history . 100000)))

(define sss-alacritty-font
  `((normal . "{ family = \"Adwaita Mono\", style = \"Regular\" }")
    (size . 11)))

(define* (sss-alacritty-colors-primary #:key palette)
  `((foreground unquote
                (sss-get-color palette
                               'text))
    (background unquote
                (sss-get-color palette
                               'background))))

(define sss-alacritty-terminal
  `((shell . fish)))

(define (serialize-alacritty-setting s)
  (let* ((val (cond
                ((or (eq? 'true
                          (cdr s))
                     (eq? 'false
                          (cdr s)))
                 (cdr s))
                ((and (string? (cdr s))
                      (string-prefix? "{"
                                      (cdr s)))
                 (cdr s))
                ((string? (cdr s))
                 (format #f "\"~a\""
                         (cdr s)))
                ((symbol? (cdr s))
                 (format #f "\"~a\""
                         (cdr s)))
                (else (cdr s)))))
    (format #f "~a = ~a"
            (car s) val)))

(define-public (translate-mods mods)
  (let* ((with-p (string-replace-substring mods "-" "|"))
         (with-c (string-replace-substring with-p "C" "Control"))
         (with-m (string-replace-substring with-c "M" "Alt"))
         (with-s (string-replace-substring with-m "S" "Shift"))
         (translated (string-replace-substring with-s "s" "Super")))
    translated))

(begin
  (define* (serialize-alacritty-binding #:key k mods action)
    (format #f "{ key = \"~a\", mods = \"~a\", action = \"~a\"}" k
            (translate-mods mods) action))
  (export serialize-alacritty-binding))

(define sss-alacritty-bindings
  (list (serialize-alacritty-binding #:mods "C"
                                     #:k "Y"
                                     #:action 'Paste)
        (serialize-alacritty-binding #:mods "M"
                                     #:k "W"
                                     #:action 'Copy)
        (serialize-alacritty-binding #:mods "C"
                                     #:k "+"
                                     #:action 'IncreaseFontSize)
        (serialize-alacritty-binding #:mods "C-S"
                                     #:k "+"
                                     #:action 'IncreaseFontSize)
        (serialize-alacritty-binding #:mods "C"
                                     #:k "-"
                                     #:action 'DecreaseFontSize)
        (serialize-alacritty-binding #:mods "C-S"
                                     #:k "-"
                                     #:action 'DecreaseFontSize)
        (serialize-alacritty-binding #:mods "C"
                                     #:k "V"
                                     #:action 'ScrollPageDown)
        (serialize-alacritty-binding #:mods "M"
                                     #:k "V"
                                     #:action 'ScrollPageUp)
        (serialize-alacritty-binding #:mods "M"
                                     #:k "S"
                                     #:action 'SearchForward)
        (serialize-alacritty-binding #:mods "M"
                                     #:k "R"
                                     #:action 'SearchBackward)
        (serialize-alacritty-binding #:mods "M"
                                     #:k "<"
                                     #:action 'ScrollToTop)
        (serialize-alacritty-binding #:mods "M-S"
                                     #:k "<"
                                     #:action 'ScrollToTop)
        (serialize-alacritty-binding #:mods "M"
                                     #:k ">"
                                     #:action 'ScrollToBottom)
        (serialize-alacritty-binding #:mods "M-S"
                                     #:k ">"
                                     #:action 'ScrollToBottom)))

(define* (sss-alacritty-config #:key palette)
  (append (list "" "[general]")
          (map serialize-alacritty-setting sss-alacritty-general)
          (list "" "[window]")
          (map serialize-alacritty-setting sss-alacritty-window)
          (list "" "[scrolling]")
          (map serialize-alacritty-setting sss-alacritty-scrolling)
          (list "" "[font]")
          (map serialize-alacritty-setting sss-alacritty-font)
          (list "" "[terminal]")
          (map serialize-alacritty-setting sss-alacritty-terminal)
          (list "" "[colors.primary]")
          (map serialize-alacritty-setting
               (sss-alacritty-colors-primary #:palette palette))
          (list ""
                "[keyboard]"
                "bindings = ["
                (string-join sss-alacritty-bindings ",\n")
                "]"
                "")))

(begin
  (define* (serialize-alacritty-config #:key config)
    (string-join config "\n"))
  (export serialize-alacritty-config))

(begin
  (define* (sss-alacritty-svc #:key palette
                              (config (sss-alacritty-config #:palette palette)))
    `((".config/alacritty/alacritty.toml" ,(plain-file "alacritty.toml"
                                                       (serialize-alacritty-config
                                                        #:config config)))))
  (export sss-alacritty-svc))
