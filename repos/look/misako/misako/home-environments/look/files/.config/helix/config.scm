(require "helix/commands.scm")
(require "helix/static.scm")
(require "helix/configuration.scm")

;;
;; Theme
;;
(theme "modus_operandi_tinted")

;;
;; Editor
;;
(line-number "relative")
(continue-comments #f)
(completion-trigger-len 1)
(completion-replace #t)
(bufferline "always")
(indent-heuristic "hybrid")
(set-option! 'end-of-line-diagnostics "hint")
(set-option! 'clipboard-provider "wayland")
(rainbow-brackets #t)

(statusline #:right '(file-encoding diagnostics selections register file-type
                      total-line-numbers position-percentage position)
            #:separator "│"
            #:mode-normal "NORMAL"
            #:mode-insert "INSERT"
            #:mode-select "SELECT")

(lsp (hash 'display-messages #f))

(file-picker-kw #:hidden #f)

(whitespace (ws-visible #t)
            (ws-chars   (hash 'space   #\·
                              'nbsp    #\⍽
                              'nnbsp   #\␣
                              'tab     #\→
                              'newline #\⏎
                              'tabpad  #\·))
            (ws-render  (hash 'space   #t
                              'tab     #t
                              'nbsp    #t
                              'nnbsp   #t
                              'newline #t)))

(soft-wrap-kw #:enable #t
              #:max-wrap 20
              #:max-indent-retain 40
              #:wrap-indicator "↪"
              #:wrap-at-text-width #f)

;; (gutters (hash 'layout '(diagnostics spacer line-numbers spacer diff)
;;                'line-numbers (hash 'min-width 1)))

;; (define-language "scheme"
;;                  (formatter (command "raco")
;;                             (args '("fmt" "--config" "/home/look/.config/fmt/config.rkt" "-i")))
;;                  (auto-format #t))
                 ;; (language-servers '("steel-language-server")))
