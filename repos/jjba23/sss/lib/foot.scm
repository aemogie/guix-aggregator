;;; SSS - Supreme Sexp System

;; Copyright (C) 2025 - Josep Bigorra, jjba23 <jjbigorra@gmail.com>

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

(define-module (sss foot)
  #:use-module (gnu)
  #:use-module (sss palette)
  #:use-module (sss process))

(begin
  (define* (sss-foot-config #:key palette)
    `((font . "Adwaita Mono:size=11") (dpi-aware . "no")
      (pad . "14x14")
      (bell (urgent . "no")
            (notify . "no")
            (visual . "no"))
      (scrollback (lines . "1000000"))
      (colors (alpha . "0.9")
              (background unquote
                          (string-drop (sss-get-color palette
                                                      'background) 1))
              (foreground unquote
                          (string-drop (sss-get-color palette
                                                      'text) 1)))
      (search-bindings (cancel . "Control+g Control+Shift+c Escape"))
      (url-bindings (cancel . "Control+g Control+Shift+c Escape"))
      (key-bindings (scrollback-up-page . "Mod1+v")
                    (scrollback-down-page . "Control+v")
                    (scrollback-home . "Mod1+less")
                    (scrollback-end . "Mod1+greater")
                    (clipboard-copy . "Mod1+w")
                    (clipboard-paste . "Control+y"))))

  (export sss-foot-config))

(begin
  (define* (sss-foot-svc #:key palette)
    `((".config/foot/foot.ini" ,(plain-file "foot.ini"
                                            (mk-rec-kv-conf-lines (sss-foot-config
                                                                   #:palette
                                                                   palette))))))
  (export sss-foot-svc))
