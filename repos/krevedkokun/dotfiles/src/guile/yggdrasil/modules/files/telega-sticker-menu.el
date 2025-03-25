(require 'transient)
(require 'telega-sticker)
(require 'seq)
(require 'map)
(eval-when-compile (require 'subr-x))

(defun kreved--telega-setup-transient-stickers (_)
  (seq-map (lambda (sticker)
             (transient-parse-suffix
              transient--prefix
              (list "a"
                    "sss"
                    (lambda ()
                      (interactive)
                      1))))
           (map-elt (telega-stickerset-get "292297482547757058") :stickers)))

(transient-define-prefix kreved--telega-choose-stickers ()
  ["stickers"
   :setup-children kreved--telega-setup-transient-stickers])
