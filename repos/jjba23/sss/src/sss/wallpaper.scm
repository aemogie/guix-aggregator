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

(define-module (sss wallpaper)
  #:declarative? #t
  #:use-module (gnu)
  #:use-module (ice-9 match)
  #:use-module (ice-9 exceptions)
  #:use-module (sss palette))

;; Define diverse wallpapers based on the active color scheme. 
(begin
  (define* (sss-wallpapers #:key clone-dir palette)
    (let* ((wall-path (string-append clone-dir
                       "/submodules/digital-art-dreams/wallpapers/sss"))
           (digital-art-dreams-sss-wallpaper (lambda (w)
                                               (format #f "~a/~a" wall-path w))))
      (match palette
        ('ef-cyprus (map digital-art-dreams-sss-wallpaper
                         '("joshua.jpg" "PXL_20250326_193029385.MP.jpg")))
        ('ef-dream (map digital-art-dreams-sss-wallpaper
                        '("miyabi.jpeg" "1362745.png" "inazuma.jpg"
                          "diluc-tree.jpg")))
        ('heavy-metal (map digital-art-dreams-sss-wallpaper
                           '("heavy-wall3.jpg" "heavy-wall2.jpg"
                             "heavy-wall.jpg")))
        ('solarized-light (map digital-art-dreams-sss-wallpaper
                               '("joshua.jpg" "PXL_20250326_193029385.MP.jpg")))
        ('ef-autumn (map digital-art-dreams-sss-wallpaper
                         '("0mar2ygf59je1.jpeg" "ofcoisp7abfe1.jpeg")))
        ('ef-bio (map digital-art-dreams-sss-wallpaper
                      '("some-forest.jpg" "redwood-forest.jpg")))
        ('everforest-dark (map digital-art-dreams-sss-wallpaper
                               '("some-forest.jpg" "redwood-forest.jpg")))
        ('everforest-light (map digital-art-dreams-sss-wallpaper
                                '("joshua.jpg" "PXL_20250326_193029385.MP.jpg")))
        (_ (raise-exception (make-exception-with-message (format #f
                                                          "exception ocurred! unknown palette selected: ~a"
                                                          palette)))))))
  (export sss-wallpapers))

(define (mk-random-wall-cmd walls)
  (let* ((wall-idx -1))
    (format #f
            (string-append "case $(( $(date +%s) % ~a )) in ~a esac; "
                           "pkill swaybg || true "
                           " && echo \"setting current wallpaper: $WALL\" "
                           "&& WAYLAND_DISPLAY=wayland-1 swaybg -i \"$WALL\"")
            (length walls)
            (string-join (map (lambda (w)
                                (set! wall-idx
                                      (+ 1 wall-idx))
                                (format #f "~a) WALL=\"~a\";;" wall-idx w))
                              walls) " "))))

(begin
  (define* (sss-wallpaper-capability #:key clone-dir palette)
    (let* ((walls (sss-wallpapers #:clone-dir clone-dir
                                  #:palette palette))
           (random-wall-cmd (mk-random-wall-cmd walls)))
      `((".local/bin/sss-wallpaper-random.sh" ,(plain-file
                                                "sss-wallpaper-random.sh"
                                                random-wall-cmd)))))
  (export sss-wallpaper-capability))

