;;; -*- lexical-binding:t; eval: (rainbow-mode 1) -*-

;; Copyright © 2026 willow xyz <willow@phantoma.online>

(require 'autothemer)
(autothemer-deftheme
 wlo "willow's custom colors"
 ((((class color) (min-colors #xFFFFFF)))
  (accent-primary   "#d6aaea")
  (accent-secondary "#b085c3")
  (accent-tertiary  "#825d92")
  (tone0          "#010105")
  (tone1          "#14131f")
  (tone2          "#332f3e")
  (tone3          "#544e60")
  (tone4          "#786f84")
  (tone5          "#9f92a9")
  (tone6          "#c6b7d0")
  (tone7          "#f0ddf9")
  (fg             "#c6b7d0")
  (bg             "#010105")  
  (red-dark       "#99566b")
  (red            "#cb7e96")
  (red-bright     "#f3a3bb")
  (orange-dark    "#995a3e")
  (orange         "#cb8362")
  (orange-bright  "#f3a886")
  (yellow-dark    "#7f6821")
  (yellow         "#ad9247")
  (yellow-bright  "#d3b86c")
  (green-dark     "#50743c")
  (green          "#77a060")
  (green-bright   "#9bc684")
  (cyan-dark      "#007768")
  (cyan           "#3aa593")
  (cyan-bright    "#64cbb8")
  (blue-dark      "#157390")
  (blue           "#419fc0")
  (blue-bright    "#69c5e7")
  (violet-dark    "#5769a1")
  (violet         "#7e93d4")
  (violet-bright  "#a2b8fc")
  (magenta-dark	  "#825d92")
  (magenta        "#b085c3")
  (magenta-bright "#d6aaea"))

 (;; THE THEME
  ;; basics
  (default                    (:foreground fg :background bg))
  (error                      (:foreground red))
  (highlight                  (:foreground bg :background accent-primary :slant 'italic))
  (menu                       (:foreground fg :background bg))
  (match                      (:foreground tone4))
  (minibuffer-prompt          (:foreground accent-primary :slant 'italic))
  (read-multiple-choice       (:foreground fg :slant 'italic))
  (region                     (:foreground bg :background tone5))
  (secondary-selection        (:foreground accent-secondary))
  (success                    (:foreground green))
  (warning                    (:foreground yellow))
  (shadow                     (:foreground tone3))

  ;; search
  (isearch                    (:foreground bg :background accent-primary))
  (isearch-fail               (:foreground red))
  (lazy-highlight             (:foreground bg :background accent-tertiary))

  ;; mode line
  (mode-line                  (:foreground fg :background bg))
  (mode-line-buffer-id        (:foreground accent-primary :background bg))
  (mode-line-emphasis         (:foreground accent-primary :background bg))
  (mode-line-highlight        (:foreground accent-primary :background bg))
  (mode-line-inactive         (:foreground tone3 :background bg))

  ;; frame
  (border                     (:foreground fg :background bg))
  (internal-border            (:foreground fg :background bg))
  (fringe                     (:foreground fg :background bg))
  (tool-bar                   (:foreground fg :background tone1))

  ;; misc ui elements
  (button                     (:foreground fg :background bg :box t))
  (cursor                     (:foreground bg :background fg))
  (link                       (:foreground accent-primary :background bg :underline t))
  (link                       (:foreground accent-tertiary :background bg :underline t))
  (mouse                      (:foreground fg :background fg))
  (mouse-drag-and-drop-region (:foreground fg :background accent-tertiary))
  (help-key-binding           (:foreground accent-primary :box t))
  
  ;; font lock
  (font-lock-builtin-face       (:foreground fg))
  (font-lock-comment-face       (:foreground tone4 :slant 'italic))
  (font-lock-constant-face      (:foreground fg))
  (font-lock-doc-face           (:foreground tone5 :slant 'italic))
  (font-lock-string-face        (:foreground accent-primary))
  (font-lock-function-name-face (:foreground fg))
  (font-lock-keyword-face       (:foreground fg))
  (font-lock-variable-name-face (:foreground fg))
  (font-lock-type-face          (:foreground fg))
  (font-lock-warning-face       (:foreground red))
  (font-lock-negation-char-face (:foreground tone5))

  ;; parens
  (show-paren-match             (:underline t))
  (show-paren-match             (:underline t))
  (show-paren-mismatch          (:foreground bg :background red :underline t))
  
  ;; delimiters
  (rainbow-delimiters-base-face (:foreground fg))
  (rainbow-delimiters-depth-1-face (:foreground magenta-bright))
  (rainbow-delimiters-depth-2-face (:foreground magenta))
  (rainbow-delimiters-depth-3-face (:foreground magenta-dark))
  (rainbow-delimiters-depth-4-face (:foreground red-dark))
  (rainbow-delimiters-depth-5-face (:foreground red))
  (rainbow-delimiters-depth-6-face (:foreground red-bright))
  (rainbow-delimiters-depth-7-face (:foreground violet-bright))
  (rainbow-delimiters-depth-8-face (:foreground violet))
  (rainbow-delimiters-depth-9-face (:foreground violet-dark))
  (rainbow-delimiters-unmatched-face (:foreground bg :background red))
  (rainbow-delimiters-mismatched-face (:foreground bg :background red))
  (rainbow-delimiters-base-errors-face (:foreground bg :background red))
  

  ;; company
  (company-tooltip-selection  (:foreground fg :background bg))
  (company-tooltip-common     (:foreground fg))
  (company-tooltip            (:foreground fg :background tone1))
  (company-scrollbar-bg       (:background bg))
  (company-scrollbar-fg       (:background tone7))

  ;; vertico, orderless
  (vertico-current            (:foreground bg :background accent-primary))
  (orderless-match-face-0     (:foreground bg :background accent-primary))
  (orderless-match-face-1     (:foreground bg :background accent-primary))
  (orderless-match-face-2     (:foreground bg :background accent-primary))
  (orderless-match-face-3     (:foreground bg :background accent-primary))
  ;; TODO magit

  ;; elfeed
  (elfeed-search-date-face    (:foreground tone5))
  (elfeed-search-tag-face     (:foreground tone5))
  (elfeed-search-feed-face    (:foreground accent-primary))
  (elfeed-search-title-face   (:foreground fg))
 
  ;; email
  (mu4e-header-key-face       (:foreground accent-primary))
  (mu4e-header-title-face     (:foreground fg))
  (mu4e-title-face            (:foreground fg)))
 (custom-theme-set-variables 'wlo
                             `(ansi-color-names-vector
                               [,tone1]
                               [,red]
                               [,green]
                               [,yellow]
                               [,blue]
                               [,magenta]
                               [,cyan]
                               [,tone6])))
(disable-theme 'wlo)
(provide-theme 'wlo)
(enable-theme 'wlo)
