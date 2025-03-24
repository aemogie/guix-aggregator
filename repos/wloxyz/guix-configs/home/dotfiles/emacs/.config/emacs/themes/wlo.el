;;; -*- lexical-binding:t -*-
;; Copyright © 2024 willow xyz <willow@phantoma.online>

(eval-and-compile
  (require 'ef-themes)

  (deftheme ef-wlo
    "My custom theme based on protesilaos' ef-themes"
    :background-mode 'dark
    :kind 'color-scheme
    :family 'ef)

  (defconst ef-wlo-palette
    '((bg-main "#010105")
      (bg-dim  "#262634")
      (bg-alt  "#060610")
      (fg-main "#ffedff")
      (fg-dim  "#60748a")
      (fg-alt  "#ffceff")

      (bg-active   "#545470")
      (bg-inactive "#32323e")

      (red             "#cc8899")  ; 900
      (red-warmer      "#966472")  ; 800
      (red-cooler      "#f7a3b8")  ; 1000
      (red-faint       "#ffd2dd")  ; 1100
      (green           "#8dc8a1")  ; 1000
      (green-warmer    "#75a686")  ; 900
      (green-cooler    "#a6edbd")  ; 1100
      (green-faint     "#caffda")  ; 1200
      (yellow          "#dce396")  ; 1100
      (yellow-warmer   "#bac07f")  ; 1000
      (yellow-cooler   "#f2f5cf")  ; 1200
      (yellow-faint    "#f8fae7")  ; 1300
      (blue            "#9fbee1")  ; 1000
      (blue-warmer     "#839ebb")  ; 900
      (blue-cooler     "#c4e0ff")  ; 1100
      (blue-faint      "#e9f3ff")  ; 1200
      (magenta         "#c784c8")  ; 900
      (magenta-warmer  "#926194")  ; 800
      (magenta-cooler  "#f09ff1")  ; 1000
      (magenta-faint   "#ffceff")  ; 1100
      (cyan            "#8fc5c3")  ; 1000
      (cyan-warmer     "#77a3a2")  ; 900
      (cyan-cooler     "#a6e9e7")  ; 1100
      (cyan-faint      "#ddfffc")  ; 1200

;;; basic hues for background values
      (bg-red-intense     "#63424c") ; 700
      (bg-green-intense   "#567a64") ; 800
      (bg-yellow-intense  "#9a9f6b") ; 900
      (bg-blue-intense    "#60748a") ; 800
      (bg-magenta-intense "#604062") ; 700
      (bg-cyan-intense    "#577878") ; 800

      (bg-red-subtle      "#34232a") ; 600
      (bg-green-subtle    "#395043") ; 700
      (bg-yellow-subtle   "#71754f") ; 800
      (bg-blue-subtle     "#404c5d") ; 700
      (bg-magenta-subtle  "#332237") ; 600
      (bg-cyan-subtle     "#3a4f51") ; 700

;;; diffs
      (bg-added        "#395043")  ; 700
      (bg-added-faint  "#1e2b26")  ; 600
      (bg-added-refine "#567a64")  ; 800
      (fg-added        "#e4ffed")  ; 1300

      (bg-changed        "#71754f")  ; 800
      (bg-changed-faint  "#4b4d36")  ; 700
      (bg-changed-refine "#9a9f6b")  ; 900
      (fg-changed        "#f2f5cf")  ; 1200

      (bg-removed        "#63424c")  ; 700
      (bg-removed-faint  "#34232a")  ; 600
      (bg-removed-refine "#966472")  ; 800
      (fg-removed        "#ffeef3")  ; 1300

;;; graphs
      (bg-graph-red-0     "#966472") ; 800
      (bg-graph-red-1     "#63424c") ; 700
      (bg-graph-green-0   "#567a64") ; 800
      (bg-graph-green-1   "#395043") ; 700
      (bg-graph-yellow-0  "#bac073") ; 1000
      (bg-graph-yellow-1  "#9a9f6b") ; 900
      (bg-graph-blue-0    "#839ebb") ; 900
      (bg-graph-blue-1    "#60748a") ; 800
      (bg-graph-magenta-0 "#c784c8") ; 900
      (bg-graph-magenta-1 "#926184") ; 800
      (bg-graph-cyan-0    "#a6e9e7") ; 1100
      (bg-graph-cyan-1    "#8fc5c3") ; 1000


;;; special hues

      (bg-mode-line       unspecified)
      (fg-mode-line       fg-main)
      (bg-completion      "#354864")
      (bg-hover           "#8f7a7f")
      (bg-hover-secondary "#415960")
      (bg-hl-line         "#344255")
      (bg-paren           "#706069")
      (bg-err             "#4f231f") ; check with err
      (bg-warning         "#3f3c2f") ; check with warning
      (bg-info            "#104032") ; check with info

      (border        "#4f5f66")
      (cursor        "#afe6ef")
      (fg-intense    "#ffffff")

      (modeline-err     "#ffd2ff")
      (modeline-warning "#e4e947")
      (modeline-info    "#8defff")

      (underline-err     "#df4f2f")
      (underline-warning "#d4c000")
      (underline-info    "#22b022")

      (bg-char-0 "#0050af")
      (bg-char-1 "#7f1f7f")
      (bg-char-2 "#625a00")


;;; Mappings

;;;; General mappings

      (bg-fringe unspecified)
      (fg-fringe unspecified)

      (err red-warmer)
      (warning yellow-warmer)
      (info green)

      (link cyan-warmer)
      (link-alt yellow-cooler)
      (name blue)
      (keybind green-cooler)
      (identifier magenta-faint)
      (prompt blue-cooler)

      (bg-region "#404f66")
      (fg-region unspecified)

;;;; Code mappings

      (builtin blue)
      (comment blue-faint)
      (constant yellow-cooler)
      (fnname green-cooler)
      (keyword cyan-warmer)
      (preprocessor green-warmer)
      (docstring green-faint)
      (string cyan-cooler)
      (type magenta-cooler)
      (variable blue-warmer)
      (rx-escape yellow) ; compare with `string'
      (rx-construct red)

;;;; Accent mappings

      (accent-0 cyan-cooler)
      (accent-1 yellow-cooler)
      (accent-2 red)
      (accent-3 green)

;;;; Date mappings

      (date-common cyan-cooler)
      (date-deadline red)
      (date-event fg-alt)
      (date-holiday red)
      (date-now fg-main)
      (date-range fg-alt)
      (date-scheduled yellow)
      (date-weekday cyan-cooler)
      (date-weekend red-faint)

;;;; Prose mappings

      (prose-code green-warmer)
      (prose-done green)
      (prose-macro green-cooler)
      (prose-metadata fg-dim)
      (prose-metadata-value fg-alt)
      (prose-table fg-alt)
      (prose-table-formula err)
      (prose-tag cyan-faint)
      (prose-todo red-warmer)
      (prose-verbatim blue)

;;;; Mail mappings

      (mail-cite-0 cyan)
      (mail-cite-1 green-cooler)
      (mail-cite-2 blue-warmer)
      (mail-cite-3 yellow-cooler)
      (mail-part magenta)
      (mail-recipient cyan-warmer)
      (mail-subject blue-cooler)
      (mail-other cyan-cooler)

;;;; Search mappings

      (bg-search-match bg-warning)
      (bg-search-current bg-yellow-intense)
      (bg-search-lazy bg-cyan-intense)
      (bg-search-replace bg-red-intense)

      (bg-search-rx-group-0 bg-magenta-intense)
      (bg-search-rx-group-1 bg-green-intense)
      (bg-search-rx-group-2 bg-red-subtle)
      (bg-search-rx-group-3 bg-cyan-subtle)

;;;; Space mappings

      (bg-space unspecified)
      (fg-space border)
      (bg-space-err bg-yellow-intense)

;;;; Tab mappings

      (bg-tab-bar      bg-alt)
      (bg-tab-current  bg-main)
      (bg-tab-other    bg-active)

;;;; Terminal mappings

      (bg-term-black           "black")
      (fg-term-black           "black")
      (bg-term-black-bright    "gray35")
      (fg-term-black-bright    "gray35")

      (bg-term-red             red)
      (fg-term-red             red)
      (bg-term-red-bright      red-warmer)
      (fg-term-red-bright      red-warmer)

      (bg-term-green           green)
      (fg-term-green           green)
      (bg-term-green-bright    green-warmer)
      (fg-term-green-bright    green-warmer)

      (bg-term-yellow          yellow)
      (fg-term-yellow          yellow)
      (bg-term-yellow-bright   yellow-cooler)
      (fg-term-yellow-bright   yellow-cooler)

      (bg-term-blue            blue)
      (fg-term-blue            blue)
      (bg-term-blue-bright     blue-cooler)
      (fg-term-blue-bright     blue-cooler)

      (bg-term-magenta         magenta)
      (fg-term-magenta         magenta)
      (bg-term-magenta-bright  magenta-cooler)
      (fg-term-magenta-bright  magenta-cooler)

      (bg-term-cyan            cyan-warmer)
      (fg-term-cyan            cyan-warmer)
      (bg-term-cyan-bright     cyan-cooler)
      (fg-term-cyan-bright     cyan-cooler)

      (bg-term-white           "gray65")
      (fg-term-white           "gray65")
      (bg-term-white-bright    "white")
      (fg-term-white-bright    "white")

;;;; Rainbow mappings

      (rainbow-0 green-cooler)
      (rainbow-1 blue)
      (rainbow-2 cyan-cooler)
      (rainbow-3 magenta-cooler)
      (rainbow-4 yellow-cooler)
      (rainbow-5 green-warmer)
      (rainbow-6 magenta-warmer)
      (rainbow-7 cyan-warmer)
      (rainbow-8 yellow))
    "the `ef-wlo' palette
Color values have the form (COLOR-NAME HEX-VALUE) with the former
as a symbol and the latter as a string.

Semantic color mappings have the form (MAPPING-NAME COLOR-NAME)
with both as symbols.  The latter is a color that already exists
in the palette and is associated with a HEX-VALUE.")

    (defcustom ef-wlo-palette-overrides nil
      "Overrides for `ef-wlo-palette'.

Mirror the elements of the aforementioned palette, overriding
their value.

For overrides that are shared across all of the Ef themes,
refer to `ef-themes-common-palette-overrides'.

To preview the palette entries, use `ef-themes-preview-colors' or
`ef-themes-preview-colors-current' (read the documentation for
further details)."
      :group 'ef-themes
      :package-version '(ef-themes . "1.0.0")
      :type '(repeat (list symbol (choice symbol string)))
      :link '(info-link "(ef-themes) Palette overrides"))

    (ef-themes-theme ef-wlo ef-wlo-palette ef-wlo-palette-overrides)

    ;; Mark the theme as provided
    (provide-theme 'ef-wlo))







