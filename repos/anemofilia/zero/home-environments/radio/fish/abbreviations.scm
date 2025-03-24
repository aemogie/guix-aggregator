(define-module (home-environments radio fish abbreviations)
  #:use-module (radix home services shells)

  #:export (download/upload
            guix
            editing
            misc))

(define download/upload
  (list (abbreviation
          (name 'a)
          (expansion "aria2c -j 10 '%"))
        (abbreviation
          (name 'i)
          (expansion "ipfs get %"))
        (abbreviation
          (name 'm)
          (expansion "yt-dlp -x '%'"))
        (abbreviation
          (name 'u)
          (expansion "curl -F file=@% https://0x0.st | wl-copy"))
        (abbreviation
          (name 'v)
          (expansion "yt-dlp '%'"))))

(define guix
  (list (abbreviation
          (name '!repair)
          (expansion "doas guix build --repair"))
        (abbreviation
          (name '!pull)
          (expansion "guix pull"))
        (abbreviation
          (name '!repl)
          (expansion "guix repl -i ~/.config/guile/guilerc"))
        (abbreviation
          (name '!home)
          (expansion "guix home reconfigure ~/.config/guix/home.scm"))
        (abbreviation
          (name '!system)
          (expansion "doas guix system reconfigure /etc/config.scm"))
        (abbreviation
          (name '!network)
          (expansion "doas herd restart networking \
                      && doas herd restart wpa-supplicant"))))

(define misc
  (list (abbreviation
          (name '!pass)
          (expansion "pass show % | wl-copy"))
        (abbreviation
          (name 'tf)
          (expansion "setsid -f % >/dev/null 2>&1 & disown"))))

(define* (edit #:optional file)
  (format #f "$EDITOR~@[ ~a~]" file))

(define editing
  (list (abbreviation
          (name ':e)
          (expansion (edit)))
        (abbreviation
          (name ':cronogram)
          (expansion (edit "~/areas/masters/current-period/cronogram")))
        (abbreviation
          (name ':system)
          (expansion (edit "/etc/config.scm")))
        (abbreviation
          (name ':home)
          (expansion (edit "~/.config/guix/home.scm")))
        (abbreviation
          (name ':todo)
          (expansion (edit "~/areas/meta/todo")))))
