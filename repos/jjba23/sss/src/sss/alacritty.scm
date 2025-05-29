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

(define-module (sss alacritty)
  #:declarative? #t
  #:use-module (gnu)
  #:use-module (gnu home services)
  #:use-module (sss palette)
  #:use-module (sss prelude)
  #:use-module (ice-9 string-fun)
  #:export (alacritty-general alacritty-window
                              alacritty-scrolling
                              alacritty-font
                              alacritty-colors-primary
                              alacritty-terminal
                              serialize-alacritty-setting
                              translate-alacritty-mods
                              serialize-alacritty-binding
                              alacritty-bindings
                              alacritty-config
                              serialize-alacritty-config
                              alacritty-capability))

(define alacritty-general
  `((live_config_reload . true) (ipc_socket . true)))

(define alacritty-window
  `((padding . "{ x = 14, y = 14}") (decorations . None)
    (opacity . 0.9)
    (blur . false) ;let WM take care of it
    ))

(define alacritty-scrolling
  `((history . 100000)))

(define* (alacritty-font #:key mono-font)
  `((normal unquote
            (format #f "{ family = \"~a\", style = \"Regular\" }" mono-font))
    (size . 11)))

(define* (alacritty-colors-primary #:key palette)
  `((foreground unquote
                (get-color palette
                           'text))
    (background unquote
                (get-color palette
                           'background))))

(define alacritty-terminal
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

(define (translate-alacritty-mods mods)
  (let* ((with-p (string-replace-substring mods "-" "|"))
         (with-c (string-replace-substring with-p "C" "Control"))
         (with-m (string-replace-substring with-c "M" "Alt"))
         (with-s (string-replace-substring with-m "S" "Shift"))
         (translated (string-replace-substring with-s "s" "Super")))
    translated))

(define* (serialize-alacritty-binding #:key k mods action)
  (format #f "{ key = \"~a\", mods = \"~a\", action = \"~a\"}" k
          (translate-alacritty-mods mods) action))

(define alacritty-bindings
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

(define* (alacritty-config #:key palette mono-font)
  (append '("# ====== SSS Alacritty configuration ======" "#"
            "# auto-generated file, DO NOT EDIT!")
          (list "" "[general]")
          (map serialize-alacritty-setting alacritty-general)
          (list "" "[window]")
          (map serialize-alacritty-setting alacritty-window)
          (list "" "[scrolling]")
          (map serialize-alacritty-setting alacritty-scrolling)
          (list "" "[font]")
          (map serialize-alacritty-setting
               (alacritty-font #:mono-font mono-font))
          (list "" "[terminal]")
          (map serialize-alacritty-setting alacritty-terminal)
          (list "" "[colors.primary]")
          (map serialize-alacritty-setting
               (alacritty-colors-primary #:palette palette))
          (list ""
                "[keyboard]"
                "bindings = ["
                (string-join alacritty-bindings ",\n")
                "]"
                "")))

(define* (serialize-alacritty-config #:key config)
  (string-join config "\n"))

(define* (alacritty-capability #:key palette mono-font)
  `((".config/alacritty/alacritty.toml" ,(plain-file "alacritty.toml"
                                                     (serialize-alacritty-config
                                                      #:config (alacritty-config
                                                                #:palette
                                                                palette
                                                                #:mono-font
                                                                mono-font))))))
