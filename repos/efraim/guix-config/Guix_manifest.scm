(define-module (Guix_manifest))
(use-modules (guix profiles)
             (guix transformations)
             (guix packages)
             (guix utils)
             (gnu packages)
             (ice-9 match)
             (srfi srfi-1))

(define headless?
  (eq? #f (getenv "DISPLAY")))

(define UTenn_machines
  (list "lily"
        "octopus01"
        "penguin2"
        "space"
        "tux01"
        "tux02"
        "tux03"))

(define guix-system
  (file-exists? "/run/current-system/provenance"))

(define work-machine?
  (not (eq? #f (member (gethostname)
                       (cons "bayfront"
                             UTenn_machines)))))

(define %GUI-only
  (list "adwaita-icon-theme"
        "ephoto"
        "evisum"
        "font-culmus"
        "font-dejavu"
        "font-ghostscript"
        "font-gnu-freefont"
        "font-gnu-unifont"
        "font-opendyslexic"
        "font-terminus"
        "flatpak"
        "gst-plugins-good"
        "gst-plugins-ugly"
        "icecat"
        "kdeconnect"
        "keepassxc"
        "lagrange"
        "libnotify"     ; notify-send
        "libreoffice"
        "mpv"
        "mpv-mpris"
        "mupdf"
        "my-moreutils"
        "netsurf"
        "nheko"
        "pavucontrol"
        "pinentry-efl"
        "qtwayland"
        "quasselclient"
        "qutebrowser"
        "terminology"
        "viewnior"
        "wl-clipboard-x11"
        "zathura"
        "zathura-pdf-poppler"))

(define %work-applications
  (list ;"diffoscope"
        "mercurial"
        "strace"))

(define %not-for-work
  (list "btrfs-progs"
        "catimg"
        "ffmpeg"
        "git-annex"
        "isync"
        "keybase"
        "khal"
        "khard"
        "libhdate"
        "msmtp"
        "mutt"
        "newsboat"
        "parcimonie"
        "sshfs"
        "syncthing"
        "toot"
        "vdirsyncer"
        "weechat"
        "yt-dlp"))

(define %headless
  (list "pinentry-tty"))

(define %guix-system-apps
  ;; These packages are provided by Guix System.
  (list "guile"
        "guile-colorized"
        "guile-readline"
        "mcron"
        "shepherd"))

(define %cli-apps
  (list "aria2"
        "aspell"
        "aspell-dict-en"
        "aspell-dict-he"
        "bidiv"
        "bash-completion"
        "file"
        "git"
        "git:send-email"
        "glibc-locales"
        "global"
        "gnupg"
        "hunspell-dict-en"
        "links"
        "myrepos"
        "ncdu"
        "nmap"
        "nss-certs"
        "openssh"
        "parallel"
        "qrencode"
        "rsync"
        "screen"
        "stow"
        "tig"
        "torsocks"
        "translate-shell"
        "tree"
        "urlscan"
        "vifm"
        "vim"
        "vim-airline"
        "vim-dispatch"
        "vim-fugitive"
        "vim-gnupg"
        "vim-guix-vim"
        "editorconfig-vim"
        "wcalc"
        "wget"
        "wgetpaste"))


;; https://guix.gnu.org/manual/devel/en/html_node/Defining-Package-Variants.html

(define S specification->package)

;(define package-transformations
;  (options->transformation
;   (if (false-if-exception (S "ssl-ntv"))
;     `((with-graft . "openssl=ssl-ntv")
;       (with-branch . "vim-guix-vim=master"))
;     '((with-branch . "vim-guix-vim=master")))))

;; https://guix.gnu.org/manual/devel/en/html_node/Defining-Package-Variants.html#index-input-rewriting
;; Both of these are equivalent to '--with-input'
;; package-input-rewriting => takes an 'identity'
;; package-input-rewriting/spec => takes a name

;(define modified-packages
;  (package-input-rewriting/spec
;   ;; We leave the conditional here too to prevent searching for (dfsg main sdl).
;   `(("sdl2" . ,(if work-machine?
;                  (const (S "sdl2"))
;                  (const (@ (dfsg main sdl) sdl2-2.0.14)))))))

(packages->manifest
  (map (compose list specification->package+output)
       (filter (lambda (pkg)
                 (member (or (%current-system)
                             (%current-target-system))
                         (package-transitive-supported-systems
                           (specification->package+output pkg))))
              (append
                (if (or headless?
                        (not guix-system))
                  %headless
                  %GUI-only)
                (if work-machine?
                  %work-applications
                  %not-for-work)
                (if guix-system
                  '()
                  %guix-system-apps)
                %cli-apps))))
