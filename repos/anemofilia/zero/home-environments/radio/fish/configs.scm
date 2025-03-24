(define-module (home-environments radio fish configs)
  #:use-module (guix gexp)

  #:export (fzf))

(define fzf
  (plain-file "fish-fzf.fish"
    (string-join
      `("fzf_configure_bindings --directory=@@ --history= --processes= "
        "bind -M default / _fzf_search_history")
     "\n")))
