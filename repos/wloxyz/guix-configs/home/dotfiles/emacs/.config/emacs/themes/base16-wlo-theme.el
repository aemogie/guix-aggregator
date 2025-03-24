;; base16-wlo-theme.el -- A base16 colorscheme

;;; Commentary:
;; Base16: (https://github.com/tinted-theming/home)

;;; Authors:
;; Scheme: wlo xyz (https://willow.phantoma.online)
;; Template: Kaleb Elwert <belak@coded.io>

;;; Code:

(require 'base16-theme)

(defvar base16-wlo-theme-colors
  '(:base00 "#010105"
    :base01 "#04040e"
    :base02 "#32323e"
    :base03 "#545470"
    :base04 "#c8c0c8"
    :base05 "#dcd4dc"
    :base06 "#717197"
    :base07 "#22222e"
    :base08 "#bd7d8c"
    :base09 "#d4a897"
    :base0A "#d4cba8"
    :base0B "#8bbfbd"
    :base0C "#b3fffc"
    :base0D "#91aecd"
    :base0E "#bd7dae"
    :base0F "#c1b4ff")
  "All colors for base16-wlo are defined here.")

;; Define the theme
(deftheme base16-wlo)

;; Add all the faces to the theme
(base16-theme-define 'base16-wlo base16-wlo-theme-colors)

(set-face-background 'mode-line nil)
(set-face-background 'line-number nil)
(set-face-background 'fringe nil)
;; Mark the theme as provided
(provide-theme 'base16-wlo)

(provide 'base16-wlo-theme)

;;; base16-wlok-theme.el ends here
