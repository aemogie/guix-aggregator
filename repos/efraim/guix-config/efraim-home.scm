(define-module (efraim-home)
  #:use-module (gnu home)
  #:use-module (gnu home services)
  #:use-module (gnu home services desktop)
  #:use-module (gnu home services gnupg)
  #:use-module (gnu home services mail)
  #:use-module (gnu home services shells)
  #:use-module (gnu home services shepherd)
  #:use-module (gnu home services sound)
  #:use-module (gnu home services ssh)
  #:use-module (gnu home services sway)
  #:use-module (gnu home services syncthing)
  #:use-module (gnu system keyboard)
  #:use-module (gnu system shadow)
  #:use-module (gnu services)
  #:use-module (gnu packages)
  #:use-module (guix packages)
  #:use-module (guix transformations)
  #:use-module (guix utils)
  #:use-module (guix gexp)
  #:use-module (ice-9 match))

;;;

;; To create a temporary directory in XDG_RUNTIME_DIR
;; (mkdtemp (string-append (getenv "XDG_RUNTIME_DIR") "/XXXXXX"))
;; from shell $(mktemp --directory --tmpdir=$XDG_RUNTIME_DIR)

(define %logdir
  (string-append
    (or (getenv "XDG_STATE_HOME")
        (string-append (getenv "HOME") "/.local/state"))
    "/log"))

(define headless?
  (eq? #f (getenv "DISPLAY")))

(define %Guix_machines
  (list "bayfront"
        "berlin"
        "guixp9"))

(define %UTenn_machines
  (list "lily"
        "penguin2"
        "tux01"
        "tux02"
        "tux03"
        "octopus01"))

(define guix-system?
  (file-exists? "/run/current-system/provenance"))

(define work-machine?
  (not (eq? #f (member (gethostname)
                       (append %Guix_machines
                               %UTenn_machines)))))

(define %GUI-only
  (list "adwaita-icon-theme"
        "alacritty"
        "font-culmus"
        "font-dejavu"
        "font-ghostscript"
        "font-gnu-freefont"
        "font-gnu-unifont"
        "font-opendyslexic"
        "font-terminus"
        "flatpak"
        "gstreamer"
        "gst-plugins-base"
        "gst-plugins-good"
        "gst-plugins-ugly"
        "i3status"
        "icecat"
        "imv"
        "kdeconnect"
        "keepassxc"
        "lagrange"
        "libnotify"     ; notify-send
        "libreoffice"
        "mpv"
        "mupdf"
        "my-moreutils"
        "nheko"
        "pavucontrol"
        "qtwayland-helper"
        "quasselclient"
        (if (supported-package? (specification->package "qutebrowser-with-adblock"))
          "qutebrowser-with-adblock"
          "qutebrowser")
        "tofi"
        "tuba"
        "wl-clipboard"
        "wl-clipboard-x11"  ; for xclip compat
        "xdg-desktop-portal"
        "xdg-desktop-portal-wlr"
        "zathura"
        "zathura-pdf-poppler"))

(define %work-applications
  (list "diffoscope"
        "mercurial"
        "strace"))

(define %not-for-work
  (list "btrfs-progs"
        "codeberg-cli"
        "ffmpeg@6"  ; Newer version conflicts with mpv
        "git-annex"
        "isync"
        ;"keybase"
        "khal"
        "khard"
        "libhdate"
        "msmtp"
        "mutt"
        "newsboat"
        "shepherd-run"
        "sshfs"
        "syncthing"
        "toot"
        "urlscan"
        "vdirsyncer"
        "yt-dlp"))

(define %headless
  (list "weechat"))

(define %guix-system-apps
  ;; These packages are provided by Guix System.
  (list "guile"
        "guile-colorized"
        "guile-readline"))

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
        "hunspell-dict-en-us"
        "hunspell-dict-he-il"
        "links"
        "myrepos"
        ;; Currently zig only has substitutes for some architectures.
        ;(if (supported-package? (specification->package "ncdu@2"))
        (if (or (target-x86-64?)
                (target-aarch64?))
          "ncdu@2"
          "ncdu@1")
        "nmap"
        "nss-certs"
        "openssh"
        "parallel"
        "python-codespell"
        "qrencode"
        "rsync"
        "sequoia"
        "sequoia-chameleon-gnupg"
        "screen"
        "tig"
        "torsocks"
        "translate-shell"
        "tree"
        "vifm"
        "vim"
        "vim-airline"
        "vim-dispatch"
        "vim-fugitive"
        "vim-gnupg"
        "vim-guix-vim"
        "wcalc"
        "wget"
        "wgetpaste"
        "xdg-utils"))

;;

(define with-transformations
  (options->transformation
    (append
      `()
      (cond
        ((string=? (gethostname) "3900XT")
         `((tune . "znver2")))
        ((string=? (gethostname) "X1")
         `((tune . "cannonlake")))
        ((target-aarch64?)
         `(;; go-1.16 FTBFS on aarch64.
           (with-input . "go@1.16=gccgo@11")))
        (#t `())))))

(define (S pkg)
  (with-transformations (specification->package pkg)))

(define package-list
  (map with-transformations
    (map specification->package+output
       (filter (lambda (pkg)
                 (supported-package?
                   (specification->package+output pkg)))
               (append
                 (if (or headless?
                         (not guix-system?))
                   %headless
                   %GUI-only)
                 (if work-machine?
                   %work-applications
                   %not-for-work)
                 (if guix-system?
                   '()
                   %guix-system-apps)
                 %cli-apps)))))

;;; Helper programs.

;; generate with echo foo | gpg --encrypt --recipient 0xgpgkey | base64

(define %dbxfs-token-base64
  "hQIMA7NiANSDITKgAQ//QPzNZW0oatd2gmt0Zfb7ZMJ1WDmaQMtcfxsFTZlfRgA3n5Fbgxah8x6jR33nOFIeG6jjdOUyXmQuYhRXdaV7feRjCwFBxuVdcE1yXzQ0yhyRoV3he9AKrKE80wAoc8plq+1Sj1j67wOuXy1wo3COU9O1G76QTcqCVjxVUP+NBIUO7FdjMMn77HL5ZTmJkDGgu3vCMB5Eb38kAm10y4Na5+SG5zgBXSDJ1y+i32olQ+wDZ5RukJGZpgnoPrzr3OdRFLEaR0A7VZxulQko26/5utFWsr/qmPDxJk9eQTbSW/iRiUM/tVp5oy7/PAEZOYhg9yYwUEP6Gy7yxoTaR3CQQY7TDdVCZ38+TNSSrHg2ZjQKYcU9oT3PPjbN7owYFktnanlnAozlZNea766p9NNQeGmQmWLjrDRQKfQ1ezDq5Akgsnv7tj9GwNkZXLEZfR1jL4rIJlLg8Q3oLDr3nh654s4V4lrPvmFNXwLMSytD7oSKr6z1IU8RojylA35MHPktBqyRKhHD0co33+2aPZboYywYAUpGbIH1MbT/tzawXjfnP5GhrXEEeMhYB6adP/C5ml4EHzNwyeLGqzo4w+z+NRxSZDsv4/uGRGGKgHGioVFmKGbbB1/9Z+lrhLq4ZURFsceD64p6eMScIi4uCSu4xYmVxaNHNTT4a/vITx/y+NPSdgGiQgWeBIvm7RaLs0em3O7xiMrkcroENSNQhhkfvHpzy9kvZNLLM06Dd9aePTZE7CorfSoQVmdkUymeQ09I9wJYosiznzMmROuYP6xwp48rPmysndj3z9QK6Rv1M52B+BGQxN1sAJLjWWxc9tafr33jJo4VMtA=")

(define %email-password-base64
  "hQIMA7NiANSDITKgAQ//cCXlvhNge4cA2zg/ZQFZhbBMYJJXWi1YdEMWc+8tJVDJHNqJDZOct3igmfILo6bVAQywXn3E7zgiNiPiqIIqMWDSwhIuTzdw3hNZEQmiaikpeLGIphLtPkKAH3maMMVWxQquDvYYuXdbYLiww/0POtbOeqcjfo+GRY5LQpsjOrX7pzwvxh5VQJFEUQ9GvdVwRJP9JOHxLSgrzhg0HzHVdnZQzrMpIykfG3qoUsQzgQxgnH1R0lhj7F4vffyWdPiArVV+33rVtW9+GDPO1VlUG2B6mWsjt/LPX3No/dByilmLapGYhFtJiRKaEWOJE/S4ApsAnAli4wLwe/YM1dLv5WOWFKn9XEQRBwB+QM56xL7FZIA5sWUQXVICPxnDrSGKXXQkQJSBGtGadAMwuGTgb3sSNVGc0s65MKZ2BGgol6BjxFqNBwO2+g5oGzKJTmo6vGHcEn3JpKPop0QX76MfCCyA8vujPD03ejVk/0G+mkGY8x4Vnb5zXG7OwEax6p6U+Tu/127/FJ+BRbxPxtqpGP/6jHeqjl9jNl/tVibNjhsxpeLzFkMzL3WU0nD3cnB8ZYgdC78f+sZ773Uzo87pFi5gKzh7cfULUxkiHeBO1HY+KH6bm/qxEj9Sjt3kbkhXmjnjMDOg9AI+izXupfIs+EVT02p0z6qr1QHGHCWPvSrSUgHmO71SpZcMkBs6X95lNsanMeHXNYg9EAm6zSZqrQQ9z8AcufAOWxoXS5hmaIMtef+zqKn3oQ0qvWtYXvpswlVuQgqxeZS/ndoTjnUUJj/Ngq4=")

(define %newsboat-password-base64
  "hQIMA7NiANSDITKgAQ//RJqPOSSxwnLeabuPpWWcirIZpYM1K4U0qRXwE/BSQCO3ZdIBC2Kbk9xCG8dD+kd9NtEbqItbb+ZOz+JCAM3/r5a3mEkXwaEsKRhs3in+7i/EBsmUGidaf7m37g8VZDXGzBMn0KSKtnT9r7vVE9F8goAkWAyD5VewuPS5YIm80nzHrppC2GTYc3Al+wG6OseloyWgh4nQQaeCcv7e2I1H+fkZHAZRTZiqsoMiA4913kcL1cebExPUa8KpzE+0ZsHUZbRYhaPULKXdplTZRxXHSRQaJI/gzTm9tpCrjE7trZABXmiQAATZvgAp+n0Wvm2kF6QUy684fqETiVibEXBV2gKAibbD+ldTIUk7X1VQJdFfVtXeAmrxQKsxXqNZ1D7bjnbhpRFA81TvwH1Ka0QXB1Ga7TK/RHSB8AzSYFSoSroms+qzs36BniRKJt+jtgrTAwWtbG2iaYzvAxsZfPJTpUt6iavyB20tjNqINiIXEwPf1GGbFOt34l+FCnuLr2PeW1mVwno0zSMc+fE5El0gbMrBJ4wJAZoYFhyw7KpppRm8AS5RvbKHx1wS5pTz3Nn901hOXenJQ2As/NmOqK9QByqOzF4UWx/htVNQlDtJr/nJEapGAqO+xZ2Hg2wv9TV39whrigT9xy7UhM2AsmuiBxxMD7JOexREEg3vuTu5pOjSdAFu1HTG87upUby/J8X64ULbGWWDPQzbALnSf1NAd+n6cW62HN6cUJOuKGM3M3q1T3W4iCQtztgQK3pC4ggHrUdRLbRr2vbgHnqRyIHjeP9Q4S/2uJ806fX2p2ns0jDjh/YTZZm/q/0AeTjUEdyloCjspULH")

(define (decrypt-password encrypted-string)
  (program-file
    "magic-password-file"
    #~(begin
        (use-modules (ice-9 popen)
                     (ice-9 rdelim))
        (display
          (read-line (pipeline
                       '((#$(file-append (S "coreutils-minimal") "/bin/echo")
                          #$encrypted-string)
                         (#$(file-append (S "coreutils-minimal") "/bin/base64")
                          "--decode")
                         (#$(file-append (S "gnupg") "/bin/gpg")
                          "--no-tty"
                          "--for-your-eyes-only"
                          "--quiet"
                          "--decrypt"))))))))

(define %dbxfs-token
  (decrypt-password %dbxfs-token-base64))

(define %email-password
  (decrypt-password %email-password-base64))

(define %newsboat-password
  (decrypt-password %newsboat-password-base64))

;;;

(define %signature
  (plain-file
    "dot-signature"
    (string-join
      ;; It shouldn't be this hard to always display correctly.
      ;; C-V U 0 0 A 0 is a non-breaking space, like below:
      ;; NB: C-V U 2 0 0 F is a right-to-left mark, C-V U 2 0 0 E is a left-to-right mark.
      ;; https://en.wikipedia.org/wiki/Bidirectional_text
      (list
        ;"Efraim Flashner   <efraim@flashner.co.il>   פלשנר אפרים"
        ;"Efraim Flashner   <efraim@flashner.co.il>   רנשלפ םירפא"
        "Efraim Flashner   <efraim@flashner.co.il>   אפרים פלשנר"
        "GPG key = A28B F40C 3E55 1372 662D  14F7 41AA E7DC CA3D 8351"
        "Confidentiality cannot be guaranteed on emails sent or received unencrypted")
      ;; End with a newline.
      "\n" 'suffix)))

;;;

(define %aria2-config
  (plain-file
    "aria2.conf"
    (string-join
      (list "check-integrity=true"
            "max-connection-per-server=5"
            "http-accept-gzip=true")
      ;; End with a newline.
      "\n" 'suffix)))

(define %curlrc
  (plain-file
    "curlrc"
    (string-append
      "compressed\n")))

(define %cvsrc
  (plain-file
    "dot-cvsrc"
    (string-join
      (list "# CVS configuration file from the pkgsrc guide"
            "cvs -q -z2"
            "checkout -P"
            "update -dP"
            "diff -upN"
            "rdiff -u"
            "release -d")
      ;; End with a newline.
      "\n" 'suffix)))

(define %git-config
  (mixed-text-file
    "git-config"
    "[user]\n"
    "    name = Efraim Flashner\n"
    "    email = efraim@flashner.co.il\n"
    "    signingkey = 0xCA3D8351\n"
    "[am]\n"
    "    threeWay = true\n"
    "[commit]\n"
    "    verbose = true\n"
    "[core]\n"
    "    editor = vim\n"
    "[checkout]\n"
    "    workers = 0\n"             ; Faster on SSDs
    (if work-machine?
        ""
        #~(string-append "[commit]\n"
                       "    gpgSign = true\n"))
    "[diff]\n"
    "    algorithm = patience\n"
    "[diff \"scheme\"]\n"
    "    xfuncname = \"^(\\\\(define.*)$\"\n"
    ;"[diff \"sqlite3\"]\n"
    ;"    binary = true\n"
    ;"    textconv = \"echo .dump | " (file-append (S "sqlite") "/bin/sqlite3") "\"\n"
    "[diff \"texinfo\"]\n"
    "    xfuncname = \"^@node[[:space:]]+([^,]+).*$\"\n"
    "[fetch]\n"
    "    prune = true\n"
    "    parallel = 0\n"
    "    writeCommitGraph = true\n"
    "[format]\n"
    "    coverLetter = auto\n"
    "    useAutoBase = whenAble\n"
    "    signatureFile = " %signature "\n"
    "    thread = shallow\n"
    (if work-machine?
        ""
        #~(string-append "[gpg]\n"
                       "    program = " #$(file-append (S "gnupg") "/bin/gpg") "\n"))
    "[imap]\n"
    "    folder = Drafts\n"
    "    tunnel = \"" (S "openssh") "/bin/ssh -o Compression=yes -q flashner.co.il /usr/lib/dovecot/imap ./Maildir 2> /dev/null\"\n"
    ;; This breaks tig
    ;"[log]\n"
    ;"    showSignature = true\n"
    "[pull]\n"
    "    rebase = true\n"
    "[push]\n"
    "   followTags = true\n"
    ;"   gpgSign = if-asked\n"
    "[sendemail]\n"
    "    smtpEncryption = ssl\n"
    (if work-machine?
        #~(string-append "    smtpServer = flashner.co.il\n"
                       ;"    smtpsslcertpath = \"\"\n"
        )
        #~(string-append "    smtpServer = " #$(file-append (S "msmtp") "/bin/msmtp") "\n"))
    "    smtpUser = efraim\n"
    "    smtpPort = 465\n"
    "    supresscc = self\n"
    "    transferEncoding = 8bit\n"
    "    annotate = yes\n"
    "[submodule]\n"
    "    fetchJobs = 0\n"
    "    recurse = true\n"
    "[tag]\n"
    "    gpgSign = true\n"
    "[tig]\n"
    "    mailmap = yes\n"
    "    main-view-id-display = yes\n"
    "[transfer]\n"
    "    fsckObjects = true\n"
    "[url \"git@codeberg.org:\"]\n"
    "    pushInsteadOf = https://codeberg.org/\n"
    ;"    fetch = +refs/pull/*/head:refs/remotes/codeberg/pr/*\n"
    "[url \"git@github.com:\"]\n"
    "    pushInsteadOf = https://github.com/\n"
    ;"    fetch = +refs/pull/*/head:refs/remotes/github/pr/*\n"
    "[url \"git@gitlab.com:\"]\n"
    "    pushInsteadOf = https://gitlab.com/\n"
    ;"    fetch = +refs/pull/*/head:refs/remotes/gitlab/pr/*\n"
    "[url \"ssh://git.savannah.gnu.org:/srv/\"]\n"
    "    pushInsteadOf = https://git.savannah.gnu.org/\n"
    "    pushInsteadOf = https://https.git.savannah.gnu.org/\n"
    "[url \"git@git.sr.ht:\"]\n"
    "    pushInsteadOf = https://git.sr.ht/\n"
    "[web]\n"
    (if (or headless? work-machine?)
        #~(string-append "    browser = " #$(file-append (S "links") "/bin/links") "\n")
        "    browser = \"qutebrowser --target window\"\n")))

(define %git-ignore
  (plain-file
    "git-ignore"
    (string-join
      (list "*~"
            "*sw?"
            ".exrc"
            ".vimrc"
            ".envrc"
            "gtags.files"
            "GPATH"
            "GRTAGS"
            "GTAGS")
      ;; End with a newline.
      "\n" 'suffix)))

(define %gpg.conf
  (mixed-text-file
    "gpg.conf"
    "default-key 0x41AAE7DCCA3D8351\n"
    "display-charset utf-8\n"
    "with-fingerprint\n"
    "keyserver hkp://keys.openpgp.org\n"
    "keyserver-options auto-key-retrieve\n"
    "keyserver-options include-revoked\n"
    ;"photo-viewer \"" #$(file-append (S "imv") "/bin/imv $i\"\n"
    "keyid-format 0xlong\n"
    ;; For use with 'gpg --locate-external-key'
    ;; This is incompatible with sequoia-chameleon-gnupg
    ;"auto-key-locate wkd cert pka dane hkp://pgpkeys.eu hkp://pgp.surf.nl hkp://pgp.net.nz hkp://keyserver.ubuntu.com hkp://the.earth.li hkp://keys.openpgp.org\n"
    ;"default-cache-ttl 900\n"
    "trust-model tofu+pgp\n"))

(define %gpg-agent.conf
  (mixed-text-file
    "gpg-agent.conf"
    (if guix-system?
        (if headless?
            #~(string-append "pinentry-program " #$(file-append (S "pinentry-tty") "/bin/pinentry-tty") "\n")
            #~(string-append "pinentry-program " #$(file-append (S "pinentry-qt") "/bin/pinentry-qt") "\n"))
        "pinentry-program /usr/bin/pinentry\n")
    ;"enable-ssh-support\n"
    ;"allow-emacs-pinentry\n"
    ;; This forces signing each commit individually.
    ;"ignore-cache-for-signing\n"
    ))

(define %hgrc
  (mixed-text-file
    "hgrc"
    "[defaults]\n"
    "log = -v\n"
    "[diff]\n"
    "git = True\n"
    "[email]\n"
    "method = " (file-append (S "msmtp") "/bin/msmtp") "\n"
    "[ui]\n"
    "username = Efraim Flashner <efraim@flashner.co.il\n"
    "verbose = True\n"
    "merge = meld\n"
    "[web]\n"
    "cacerts = " (or (getenv "GIT_SSL_CAINFO") (getenv "SSL_CERT_FILE")) " \n"))

;; This clears the defaults, do not use
(define %lesskey
  (plain-file
    "lesskey"
    (string-append
      "#env\n"
      "LESS = --ignore-case --mouse --use-color --RAW-CONTROL-CHARS\n")))

(define %mailcap
  (mixed-text-file
    "dot-mailcap"
    "text/html; " (S "links") "/bin/links -dump %s; nametemplate=%s.html; copiousoutput\n"))

(define %mpv-conf
  (plain-file
    "mpv.conf"
    (string-join
      (list "no-audio-display"
            ;; Upscaling from 720 causes fewer dropped frames.
            "ytdl-format='bv*[height<=720]+ba/b[height<=720]/bv*[height<=1080]+ba/b[height<1080]/bv+ba/b'"
            "gpu-context=wayland"
            "[youtube]"
            "ytdl-raw-options='ignore-config=,sub-langs=\"^en.*\",write-subs=,write-auto-subs='"
            "[twitch]"
            "profile-cond=get('path', ''):find('^https?://[wm]w?w?.twitch.tv/') ~= nil"
            "profile-restore=copy-equal"
            "sub-font-size=16"
            "sub-align-x=right"
            "sub-align-y=top"
            "slang=rechat")
      ;; End with a newline.
      "\n" 'suffix)))

(define %mutt-pgp-gnupg.rc
  ;; I don't know how long I've had this config snippet for :/
  (plain-file
    "pgp-gnupg.rc"
    (string-join
      (list
        "set pgp_use_gpg_agent = yes"
        "set pgp_default_key=0x41AAE7DCCA3D8351"
        "set pgp_timeout = 600"
        "set crypt_autosign = yes"
        "set crypt_replyencrypt = yes"
        "set crypt_use_gpgme = yes"
        "set pgp_good_sign=\"^gpg: Good signature from\""

        "set pgp_decode_command=\"gpg %?p?--passphrase-fd 0? --no-verbose --batch --output - %f\""
        "set pgp_verify_command=\"gpg --no-verbose --batch --output - --verify %s %f\""
        "set pgp_decrypt_command=\"gpg --passphrase-fd 0 --no-verbose --batch --output - %f\""
        "set pgp_sign_command=\"gpg --no-verbose --batch --output - --passphrase-fd 0 --armor --detach-sign --textmode %?a?-u %a? %f\""
        "set pgp_clearsign_command=\"gpg --no-verbose --batch --output - --passphrase-fd 0 --armor --textmode --clearsign %?a?-u %a? %f\""
        "set pgp_encrypt_only_command=\"pgpewrap gpg --batch --quiet --no-verbose --output - --encrypt --textmode --armor --always-trust --encrypt-to 0xCA3D8351 -- -r %r -- %f\""
        "set pgp_encrypt_sign_command=\"pgpewrap gpg --passphrase-fd 0 --batch --quiet --no-verbose --textmode --output - --encrypt --sign %?a?-u %a? --armor --always-trust --encrypt-to 0xCA3D8351 -- -r %r -- %f\""
        "set pgp_import_command=\"gpg --no-verbose --import -v %f\""
        "set pgp_export_command=\"gpg --no-verbose --export --armor %r\""
        "set pgp_verify_key_command=\"gpg --no-verbose --batch --fingerprint --check-sigs %r\""
        "set pgp_list_pubring_command=\"gpg --no-verbose --batch --with-colons --list-keys %r\""
        "set pgp_list_secring_command=\"gpg --no-verbose --batch --with-colons --list-secret-keys %r\""
        "set pgp_getkeys_command=\"gpg --locate-external-keys %r\"")
      ;; End with a newline.
      "\n" 'suffix)))

(define %mutt-pgp-sq.rc
  ;; Taken from Debian: https://wiki.debian.org/OpenPGP/Sequoia
  (plain-file
    "pgp-sq.rc"
    (string-join
      (list
        "set pgp_default_key=0x41AAE7DCCA3D8351"
        "set crypt_use_gpgme=no"
        "#unset pgp_use_gpg_agent"
        "set pgp_timeout=600"

        "# Encryption and signing"
        "# TODO: This relies on gpg-sq, as upstream does not distinguish between"
        "# verifying cleartext, decrypting messages and analyzing public keys, for"
        "# application/pgp types."
        "set pgp_decode_command=\"gpg-sq --status-fd=2 %?p?--passphrase-fd 0 --pinentry-mode=loopback? --no-verbose --quiet --batch --output - %f\""
        "set pgp_verify_command=\"sq verify --signature-file %s -- %f\""
        "set pgp_sign_command=\"sq sign --batch %?a?--signer %a? --signature-file --mode text -- %f\""
        "set pgp_clearsign_command=\"sq sign --batch %?a?--signer %a? --cleartext -- %f\""
        "set pgp_decrypt_command=\"sq decrypt --batch --signatures 0 -- %f\""
        "# Note: We use pgpewrap because %r is a list, and --for only handles one argument per option."
        "set pgp_encrypt_only_command=\"pgpewrap sq encrypt --batch -- --for %r -- %f\""
        "set pgp_encrypt_sign_command=\"pgpewrap sq encrypt --batch %?a?--signer %a? -- --for %r -- %f\""

        "# Keyring management"
        "set pgp_import_command=\"sq cert import -- %f\""
        "set pgp_export_command=\"sq cert export --cert %r\""
        "# Note: Disabled by default as the search can take some time."
        "set pgp_getkeys_command=\"sq network search --batch --quiet -- %r\""
        "set pgp_verify_key_command=\"sq pki identify --cert %r 2>&1\""
        "# TODO: This relies on gpg-sq, ideally this would use a native interface."
        "# Note: the second --with-fingerprint adds fingerprints to subkeys"
        "set pgp_list_pubring_command=\"gpg-sq --no-verbose --batch --quiet --with-colons --with-fingerprint --with-fingerprint --list-keys %r\""
        "set pgp_list_secring_command=\"gpg-sq --no-verbose --batch --quiet --with-colons --with-fingerprint --with-fingerprint --list-secret-keys %r\""

        "set pgp_good_sign=\"^[[:space:]]*Good signature from \""
        "set pgp_decryption_okay=\"^[[:space:]]*Encrypted using \""
        "# TODO: Does mutt handle non-zero error codes correctly?"
        "set pgp_check_exit=yes"
        "unset pgp_check_gpg_decrypt_status_fd")
      ;; End with a newline.
      "\n" 'suffix)))

(define %newsboat-config
  (mixed-text-file
    "newsboat-config"
    "browser \"qutebrowser --target window %u\"\n"
    "urls-source \"ocnews\"\n"
    "ocnews-url \"https://nx41374.your-storageshare.de/\"\n"
    "ocnews-login \"efraim\"\n"
    "ocnews-passwordeval " %newsboat-password "\n"
    "download-full-page yes\n"
    "article-sort-order date-desc\n"
    "save-path \"~/Downloads\"\n"
    "auto-reload yes\n"
    "reload-threads 3\n"
    "download-retries 5\n"
    ;"max-items 200\n"
    ;"keep-articles-days 180\n"
    "download-path \"~/Downloads/\"\n"
    "max-downloads 2\n"
    ;"bind-key ^R reload-all\n"
    "prepopulate-query-feeds yes\n"
    "suppress-first-reload yes\n"
    ;"proxy localhost:9050\n"
    ;"proxy-type socks5\n"
    ;"use-proxy yes\n"
    "download-timeout 90\n"))

(define %pbuilderrc
  (mixed-text-file
    "dot-pbuilderrc"
    ;; https://wiki.debian.org/PbuilderTricks#How_to_build_for_different_distributions
    "DISTRIBUTION=${DIST:-sid}\n"
    ;; Replace with (%current-system) -> (%debian-system) ?
    "ARCHITECTURE=${ARCH:-$(" (S "dpkg") "/bin/dpkg --print-architecture)}\n"
    "BASETGZ=/var/cache/pbuilder/base-$DISTRIBUTION-$ARCHITECTURE.tgz\n"
    "DEBOOTSTRAPOPTS=( '--arch' $ARCHITECTURE ${DEBOOTSTRAPOPTS[@]} )\n"

    "if [ $ARCHITECTURE == powerpc -o $ARCHITECTURE == riscv64 ]; then\n"
    ;; These are only needed when it's a ports architecture.
    "    MIRRORSITE=http://deb.debian.org/debian-ports\n"
    ;; These two courtesy of John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
    ;; deb http://incoming.ports.debian.org/buildd/ unstable main|deb http://deb.debian.org/debian-ports unreleased main
    ;; contrib and non-free arch:all packages (i.e. firmware)
    ;; deb [arch=all] http://deb.debian.org/debian/ sid contrib non-free
    ;; This one caused `pbuilder create` failures on real ppc hardware.
    ;"    OTHERMIRROR=\"deb http://incoming.ports.debian.org/buildd/ unstable main|deb http://deb.debian.org/debian-ports unreleased main\"\n"
    "    DEBOOTSTRAPOPTS=( '--keyring' '" (S "debian-ports-archive-keyring") "/share/keyrings/debian-ports-archive-keyring.gpg' '--arch' $ARCHITECTURE ${DEBOOTSTRAPOPTS[@]} )\n"
    "    EXTRAPACKAGES=\"debian-ports-archive-keyring\"\n"
    "fi\n"

    "APTCACHE=/var/cache/apt/archives\n"    ; Same as apt itself.
    "HOOKDIR=" (or (getenv "XDG_CONFIG_HOME")
                   (string-append (getenv "HOME") "/.config")) "/pbuilder/hooks\n"
    "CCACHEDIR=/var/cache/pbuilder/ccache\n"
    "BINNMU_MAINTAINER=\"Efraim Flashner <efraim@flashner.co.il>\"\n"))

(define %qutebrowser-config-py
  (mixed-text-file
    "qutebrowser-config-py"
    ;; "autoconfig.yml is ignored unless it's explicitly loaded\n"
    "config.load_autoconfig(True)\n"
    "config.bind('<Ctrl-Shift-u>', 'spawn --userscript qute-keepassxc --key 0xCA3D8351', mode='insert')\n"
    "config.bind('pw', 'spawn --userscript qute-keepassxc --key 0xCA3D8351', mode='normal')\n"
    "config.bind('pt', 'spawn --userscript qute-keepassxc --key 0xCA3D8351 --totp', mode='normal')\n"
    "config.bind(',m', 'spawn mpv {url}')\n"
    "config.bind(',M', 'hint links spawn mpv {hint-url}')\n"
    "config.bind(',j', 'jseval (function() {    location.href = \"https://12ft.io/\" + location.href;})();')\n"
    "c.auto_save.session = True\n"
    "c.colors.webpage.darkmode.enabled = True\n"
    "c.content.cookies.accept = 'no-3rdparty'\n"
    "c.content.default_encoding = 'utf-8'\n"
    "c.content.pdfjs = True\n"
    ;"c.content.proxy = 'socks://localhost:9050/'\n"
    ;"c.editor.command = ['alacritty', '--command', 'vim', '-f', '{file}', '-c', 'normal +{line}G+{column0}l']\n"
    "c.editor.command = ['alacritty', '--command', 'vim', '-f', '{file}']\n"
    ;"c.fileselect.folder.command = ['xterm', '--exec', 'ranger', '--choosedir={}']\n"
    ;"c.fileselect.multiple_files.command = ['xterm', '--exec', 'ranger', '--choosefiles={}']\n"
    ;"c.fileselect.single_file.command = ['xterm', '--exec', 'ranger', '--choosefile={}']\n"
    "c.fileselect.folder.command = ['alacritty', '--command', 'vifm', '{}']\n"
    "c.fileselect.multiple_files.command = ['alacritty', '--command', 'vifm', '{}']\n"
    "c.fileselect.single_file.command = ['alacritty', '--command', 'vifm', '{}']\n"
    "c.spellcheck.languages = [\"en-US\", \"he-IL\"]\n"))

(define %screenrc
  (plain-file
    "dot-screenrc"
    (string-join
      (list "startup_message off"
            "term screen-256color"
            "defscrollback 50000"
            "altscreen on"
            "termcapinfo xterm* ti@:te@"
            "hardstatus alwayslastline '%{= 2}[ %{= 2}%H %{= 2}][ %{= 7}%?%-Lw%?%{= 1}%n%f %t%?%{= 1}(%u)%?%{= 7}%+Lw%= %{= 2}][ %{= 4}%Y-%m-%d %{= 7}%c %{= 2}]'")
      ;; End with a newline.
      "\n" 'suffix)))

(define %streamlink-config
  (mixed-text-file
    "streamlink-config"
    "verbose\n"
    "default-stream 720p,720p60,1080p,best\n"
    "player=mpv\n"))

(define %tig-config
  (plain-file
    "tig-config"
    (string-join
      (list "set main-view-id-display = yes")
      ;; End with a newline.
      "\n" 'suffix)))

(define %wcalcrc
  (plain-file
    "dot-wcalcrc"
    (string-append
      "color=yes\n")))

(define %wgetrc
  (plain-file
    "dot-wgetrc"
    (string-append
      "continue=yes\n")))

(define %wgetpaste.conf
  (plain-file
    "dot-wgetpaste-conf"
    (string-append
      "DEFAULT_NICK=efraim\n"
      "DEFAULT_EXPIRATION=1month\n")))

(define %xdg-user-dirs
  (plain-file
    "user-dirs-dirs"
    (string-join
      (list "XDG_DESKTOP_DIR=\"$HOME/Desktop\""
            "XDG_DOCUMENTS_DIR=\"$HOME/Documents\""
            "XDG_DOWNLOAD_DIR=\"$HOME/Downloads\""
            "XDG_MUSIC_DIR=\"$HOME/Music\""
            "XDG_PICTURES_DIR=\"$HOME/Pictures\""
            "XDG_PUBLICSHARE_DIR=\"$HOME/Public\""
            "XDG_TEMPLATES_DIR=\"$HOME/Templates\""
            "XDG_VIDEOS_DIR=\"$HOME/Videos\"")
      ;; End with a newline.
      "\n" 'suffix)))

(define %ytdl-config
  (plain-file
    "youtube-dl-config"
    (string-join
      (list "--prefer-free-formats"
            "--sub-lang 'en,he'"
            "--sub-format \"srt/best\""
            "--convert-subtitles srt"
            "--restrict-filenames")
      ;; End with a newline.
      "\n" 'suffix)))

;;;

(define %dbxfs-config-json
  (mixed-text-file
    "config-json"
    ;; We would use guile-json but I don't want to pull in the dependency.
    "{\"access_token_command\": \"" %dbxfs-token "\", \"asked_send_error_reports\": true}"))

(define %mbsyncrc
  (mixed-text-file
    "mbsyncrc"
    "# Global values\n"
    "Expunge Both\n"
    "Create Near\n"
    "\n"
    "MaildirStore local\n"
    "Path ~/Maildir/\n"
    "Inbox ~/Maildir/INBOX\n"
    ;"MapInbox INBOX\n"
    ;"Trash Trash\n"
    "Flatten .\n"
    ;"SubFolders Verbatim\n"
    "\n"
    "IMAPStore flashner\n"
    "Host flashner.co.il\n"
    ;; Use the tunnel instead.
    ;"PassCmd \"" (S "gnupg") "/bin/gpg --quiet --for-your-eyes-only --decrypt $HOME/.msmtp.password.gpg\"\n"
    ;"PassCmd " %email-password "\n"
    ;"SSLType IMAPS\n"
    ;"CertificateFile /etc/ssl/certs/ca-certificates.crt\n"
    "Timeout 120\n" ; 25 MB * 8 (bytes to bits) / 2 Mb/s = 100 s, add 20% for safety.
    "Tunnel \"" (S "openssh") "/bin/ssh -o Compression=yes -q do1.unicorn-typhon.ts.net 'MAIL=maildir:~/Maildir exec /usr/lib/dovecot/imap'\"\n"
    "\n"
    "Channel flashner\n"
    "Far :flashner:\n"
    "Near :local:\n"
    "Patterns * !work\n"))

(define %home-inputrc-configuration
  (home-inputrc-configuration
  (key-bindings
    `(("Control-l" . "clear-display")))  ; would I rather have clear-screen?
  (variables
    `(("bell-style" . "visible")
      ("colored-completion-prefix" . #t)
      ("colored-stats" . #t)
      ("enable-bracketed-paste" . #t)
      ("editing-mode" . "vi")
      ("show-mode-in-prompt" . #t)))))

(define %home-msmtp-configuration-accounts
  (list
    (msmtp-account
      (name "flashner.co.il")
      (configuration
        (msmtp-configuration
          (host "flashner.co.il")
          (port 465)
          (user "efraim")
          (from "efraim@flashner.co.il")
          (password-eval "gpg --no-tty --for-your-eyes-only --quiet --decrypt $HOME/.msmtp.password.gpg")
          ;(password-eval %email-password)
          (tls-starttls? #f)
          (extra-content "tls_fingerprint 49:08:49:DF:A5:E9:73:8F:72:DA:BD:2D:2C:C4:C0:24:34:2B:66:D6"))))
    (msmtp-account
      (name "gmail-efraim")
      (configuration
        (msmtp-configuration
          (host "smtp.gmail.com")
          (port 587)
          (user "efraim.flashner")
          (from "efraim.flashner@gmail.com")
          (password-eval "gpg --no-tty --for-your-eyes-only --quiet --decrypt $HOME/.msmtp.password.efraimflashnergmail.gpg")
          (tls-trust-file "/etc/ssl/certs/ca-certificates.crt"))))
    (msmtp-account
      (name "gmail-themillak")
      (configuration
        (msmtp-configuration
          (host "smtp.gmail.com")
          (port 587)
          (user "themillak")
          (from "themillak@gmail.com")
          (password-eval "gpg --no-tty --for-your-eyes-only --quiet --decrypt $HOME/.msmtp.password.themillakgmail.gpg")
          (tls-trust-file "/etc/ssl/certs/ca-certificates.crt"))))))

(define %home-openssh-configuration-hosts
  ;; RemoteForward is "remote/there" to "local/here".
  ;; LocalForward is "local/here" to "remote/there".
  (list
    (openssh-host (name "*")
                  ;; Need to put something for HOST or MATCH before I can put the Include.
                  (extra-content "Include config-uthsc\n"))
    (openssh-host (name "do1-tor")
                  (host-name "ohpdsn5yv7g4gqm3rsz6a323q4ta5vgzptwaje6vkwhobhfwhknd2had.onion"))
    #;(openssh-host (name "do1")
                  (host-name "flashner.co.il")
                  (extra-content "  LocalForward localhost:3000 flashner.co.il:3000\n"))
    (openssh-host (name "g4-tor")
                  (host-name "km2merla7rtcgknbxk7oiavzh3w6jwmonfgxnruj57tocj3evy4vapad.onion")
                  (extra-content "  RemoteForward /run/user/1000/gnupg/S.gpg-agent /run/user/$i/gnupg/S.gpg-agent.extra\n"))
    (openssh-host (name "ct-tor")
                  (host-name "teiefezsytzpsennj3ramwqaroh6thqyzdvbu3fxktonvxguqt3rxsid.onion")
                  (identity-file "~/.ssh/id_ed25519"))
    (openssh-host (name "E5400-tor")
                  (host-name "k27pjetdse4otw2l6qkn5qdqzv3ucuky7jsn4fmibnkxqeleec3yelad.onion")
                  (extra-content "  RemoteForward /run/user/1000/gnupg/S.gpg-agent /run/user/$i/gnupg/S.gpg-agent.extra\n"))
    (openssh-host (name "3900xt-tor")
                  (host-name "edvqnpr5a2jjuswveoy63k3jxthqpgqatwzk53up5k6ve2rjwgd4jgqd.onion")
                  (extra-content "  RemoteForward /run/user/1000/gnupg/S.gpg-agent /run/user/$i/gnupg/S.gpg-agent.extra\n"))
    (openssh-host (name "git.sv.gnu.org git.savannah.gnu.org")
                  (identity-file "~/.ssh/id_ed25519_savannah"))
    (openssh-host (name "gitlab.com gitlab.inria.fr codeberg.org")
                  (identity-file "~/.ssh/id_ed25519_gitlab"))
    (openssh-host (name "salsa.debian.org")
                  (identity-file "~/.ssh/id_ed25519_debian"))
    (openssh-host (name "gitlab.gnome.org")
                  (identity-file " ~/.ssh/id_ed25519_gnome"))
    (openssh-host (name "berlin")
                  (host-name "berlin.guix.gnu.org")
                  (identity-file "~/.ssh/id_ed25519_overdrive"))
    #;(openssh-host (name "bayfront")
                  (host-name "bayfront.guix.gnu.org")
                  (identity-file "~/.ssh/id_ed25519_overdrive"))
    (openssh-host (name "guixp9")
                  (host-name "p9.tobias.gr")
                  (identity-file "~/.ssh/id_ed25519_overdrive"))
    (openssh-host (name "*.onion *-tor")
                  (compression? #t)
                  (proxy
                    ;; Either this or we always need to prefix with torsocks.
                    ;; TODO: Replace the custom ~/bin/openbsd-netcat with the line below:
                    ;(proxy-command (string-append (S "netcat-openbsd") "/bin/nc -X 5 -x localhost:9050 %h %p")))
                    (proxy-command (string-append (getenv "HOME") "/bin/openbsd-netcat -X 5 -x localhost:9050 %h %p")))
                  (extra-content "  ControlPath ${XDG_RUNTIME_DIR}/%r@%k-%p\n"))
    (openssh-host (name "*")
                  (user "efraim")
                  (extra-content
                    (string-append "  ControlMaster auto\n"
                                   "  ControlPath ${XDG_RUNTIME_DIR}/%r@%h-%p\n"
                                   "  ControlPersist 600\n")))))

(define %home-sway-configuration
  (sway-configuration
    (variables
      `(;,@((@ (srfi srfi-1) fold) delete %sway-default-variables
        ;      '("term" "menu"))
        (mod   . "Mod4")
        (left  . "h")
        (down  . "j")
        (up    . "k")
        (right . "l")
        (term . ,(file-append (S "alacritty") "/bin/alacritty"))
        (menu . ,#~(string-join
                     (list #$(file-append (S "tofi") "/bin/tofi-drun")
                           "|"
                           #$(file-append (S "findutils") "/bin/xargs")
                           #$(file-append (S "sway") "/bin/swaymsg")
                           "exec" "--")
                     " "))
        (swaylock . ,#~(string-join
                         (list
                           ;; Use swaylock from the screen-locker-service-type
                           "'/run/current-system/profile/bin/swaylock"
                           "--daemonize"
                           "--indicator-radius" "85"
                           "--ring-color" "1a1a1a"
                           "--key-hl-color" "ffb638"
                           "--image"
                           #$(file-append (S "guix-backgrounds")
                                          "/share/backgrounds/guix/guix-checkered-16-9.svg'"))
                         " "))))
    (keybindings
     `(,@%sway-default-keybindings
       ($mod+Shift+x . "exec $swaylock")
       ($mod+Alt+$left . "workspace prev")
       ($mod+Alt+$right . "workspace next")
       ($mod+Alt+Left . "workspace prev")
       ($mod+Alt+Right . "workspace next")))
    (gestures `())
    (inputs
     (list (sway-input
             (identifier "type:keyboard")
             (layout
               (keyboard-layout "us,il" "altgr-intl,"
                                #:options
                                (list "grp:lalt_lshift_toggle"  ; Lalt + Lshift to switch languages
                                      "compose:caps"            ; capslock->compose
                                      "lv3:ralt_switch"         ; Ralt for lvl 3
                                      "eurosign:e"))))))        ; euro on e
    (outputs
     (append
      (cond
        ((string=? (gethostname) "3900XT")
         (list (sway-output
                 (identifier "DVI-I-1")
                 (resolution "1920x1080")
                 (position (point (x 0)
                                  (y 0))))
               (sway-output
                 (identifier "HDMI-A-1")
                 (resolution "1920x1080")
                 (position (point (x 1920)
                                  (y 0))))))
        ((string=? (gethostname) "X1")
         (list (sway-output
                 (identifier "eDP-1")
                 (resolution "3840x2400")
                 (position (point (x 0)
                                  (y 0))))))
        ((string=? (gethostname) "pbp")
         (list (sway-output
                 (identifier "eDP-1")
                 (resolution "1920x1080")
                 (position (point (x 0)
                                  (y 0))))))
        (#t '()))
      (list (sway-output
              (identifier '*)
              (background
                (file-append (S "guix-backgrounds")
                             "/share/backgrounds/guix/guix-checkered-16-9.svg"))))))
    (bar
      (sway-bar
        (identifier 'bar0)
        (position 'top)
        (colors (sway-color
                  (background "#323232")
                  (statusline "#ffffff")
                  (inactive-workspace
                    (sway-border-color (border "#32323200")
                                       (background "#32323200")
                                       (text "#5c5c5c")))))
        (status-command (file-append (S "i3status") "/bin/i3status"))))
    (startup-programs
      (list
        #~(string-append #$(S "swayidle") "/bin/swayidle -w \\\n    "
                         "timeout 300 $swaylock \\\n    "
                         "timeout 600 '" #$(S "sway") "/bin/swaymsg \"output * dpms off\"' \\\n    "
                         "resume '" #$(S "sway") "/bin/swaymsg \"output * dpms on\"'\n")
        #~(string-join
            (list #$(file-append (S "dbus") "/bin/dbus-update-activation-environment")
                  "DISPLAY"
                  "I3SOCK"
                  "SWAYSOCK"
                  "WAYLAND_DISPLAY"
                  "XDG_CURRENT_DESKTOP=sway")
            " ")))
    (extra-content
      (list
        "floating_modifier $mod normal"
        "for_window [app_id=\"imv\"] floating enable"
        "for_window [app_id=\"mpv\"] floating enable"
        "for_window [title = \"KeePassXC -  Access Request\"] floating enable"
        "for_window [title = \"IceCat — Sharing Indicator\"] floating enable"
        "for_window [title = \"Join Channel\"] floating enable"
        "include /run/current-system/profile/etc/sway/config.d/*"
        "include /etc/sway/config.d/*"))))

;;; Executables for the $HOME/bin folder.

(define %connect-to-UTHSC-VPN
  (program-file
    "GN_vpn_connect"
    #~(system*
        #$(file-append (S "dbus") "/bin/dbus-launch")
        #$(file-append (S "openconnect-sso") "/bin/openconnect-sso")
        "--server" "uthscvpn1.uthsc.edu" "--authgroup" "UTHSC"
        "--" "--script"
        ;; This needs to be one string but I can't get it to work correctly.
        ;#$(string-append "'"
        ;                 (file-append (S "vpn-slice") "/bin/vpn-slice")
                         #$(file-append (S "vpn-slice") "/bin/vpn-slice")
                         "128.169.0.0/16"
        ;                 "'")
        )))

(define %update-guix-gpg-keyring
  (program-file
    "update-guix-members-gpg-keys"
    #~(let ((gpg-keyring (tmpnam))
            (keyring-file "https://savannah.gnu.org/project/memberlist-gpgkeys.php?group=guix&download=1"))
        ((@ (guix build download) url-fetch) keyring-file gpg-keyring)
        (system* "gpg" "--import" gpg-keyring)
        ;; Clean up after ourselves.
        (delete-file gpg-keyring))))

(define %update-gnu-gpg-keyring
  (program-file
    "update-gnu-members-gpg-keys"
    #~(let ((gpg-keyring (tmpnam))
            (keyring-file "https://ftp.gnu.org/gnu/gnu-keyring.gpg"))
        ((@ (guix build download) url-fetch) keyring-file gpg-keyring)
        (system* "gpg" "--import" gpg-keyring)
        ;; Clean up after ourselves.
        (delete-file gpg-keyring))))

;;; Extra services.

(define %dropbox-user-service
  (shepherd-service
    (documentation "Provide access to Dropbox™")
    (provision '(dropbox dbxfs))
    (start #~(make-forkexec-constructor
               (list #$(file-append (S "dbxfs") "/bin/dbxfs")
                     "--foreground"
                     "--verbose"
                     "--config-file" #$%dbxfs-config-json
                     (string-append (getenv "HOME") "/Dropbox"))
               #:log-file (string-append #$%logdir "/dbxfs.log")))
    (stop #~(make-system-destructor
              (string-append "fusermount -u " (getenv "HOME") "/Dropbox")))
    ;; Needs gpg key to unlock.
    (auto-start? #f)
    (respawn? #f)))

(define %onedrive-user-service
  (shepherd-service
    (documentation "Provide access to Onedrive™")
    (provision '(onedrive))
    (start #~(make-forkexec-constructor
               (list #$(file-append (S "onedrive") "/bin/onedrive")
                     "--monitor"
                     "--verbose"
                     (string-append (getenv "HOME") "/Onedrive"))
               #:log-file (string-append #$%logdir "/onedrive.log")))
    (stop #~(make-system-destructor
              (string-append "fusermount -u " (getenv "HOME") "/Onedrive")))
    (auto-start? #f)        ; Needs network.
    (respawn? #f)))

;; This needs more work with user shepherd services.
(define %vdirsyncer-user-service
 ;; Doesn't get imported into the gexp.
 ;(with-imported-modules '((ice-9 match))
  (shepherd-service
    (documentation "Run vdirsyncer hourly")
    (provision '(vdirsyncer))
    (start
      #~(lambda args
          ;; Doesn't go in the background.
          (use-modules (ice-9 match))
          (match (primitive-fork)
                 (0 (begin
                      (while #t
                             (system* #$(file-append (S "vdirsyncer")
                                                     "/bin/vdirsyncer")
                                      "sync")
                             ;; Random time between 30 and 45 minutes.
                             (sleep (+ (* 30 60)
                                       (random
                                         (* 15 60)))))))
                 (pid pid))))
    (stop #~(make-kill-destructor))
    (respawn? #t)));)

(define %mbsync-user-service
  (shepherd-service
    (documentation "Sync mail to the local system")
    (provision '(mbsync))
    (start
      #~(lambda args
          (match (primitive-fork)
                 (0 (begin
                      (while #t
                             (system* #$(file-append (S "isync")
                                                     "/bin/mbsync")
                                      "--config" #$%mbsyncrc
                                      "--all")
                             ;; Random time between 45 and 60 seconds
                             (sleep (+ 45 (random 15))))))
                 (pid pid))))
    (stop #~(make-kill-destructor))
    (respawn? #t)))

;; https://github.com/keybase/client/blob/master/packaging/linux/systemd/keybase.service
(define %keybase-user-service
  (shepherd-service
    (documentation "Provide access to Keybase™")
    (provision '(keybase))
    (start #~(make-forkexec-constructor
               (list #$(file-append (S "keybase") "/bin/keybase")
                     "service")
               #:log-file (string-append #$%logdir "/keybase.log")))
    (stop #~(make-system-destructor
              (string-append #$(file-append (S "keybase")
                                            "/bin/keybase")
                             " ctl stop")))
    ;; Starts too fast at login.
    (auto-start? #f)
    (respawn? #t)))

;; https://github.com/keybase/client/blob/master/packaging/linux/systemd/kbfs.service
(define %keybase-fuse-user-service
  (shepherd-service
    (documentation "Provide access to Keybase™ fuse store")
    (requirement '(keybase))
    (provision '(kbfs))
    (start #~(make-forkexec-constructor
               (list #$(file-append (S "keybase") "/bin/kbfsfuse")
                     "-log-to-file")
               #:log-file (string-append #$%logdir "/kbfs.log")))
    (stop #~(make-kill-destructor))
    ;; Depends on keybase.
    (auto-start? #f)
    (respawn? #t)))

;; kdeconnect-indicator must not be running when it it started
(define %kdeconnect-user-service
  (shepherd-service
    (documentation "Run the KDEconnect daemon")
    (provision '(kdeconnect))
    (start #~(make-forkexec-constructor
               (list #$(file-append (S "dbus") "/bin/dbus-launch")
                     #$(file-append (S "kdeconnect") "/libexec/kdeconnectd")
                     ;; KDE Connect was built without "offscreen" support
                     ;; without this it fails to create wl_display
                     ;; Is the second part still true?
                     "-platform" "offscreen"
                     )
               #:log-file (string-append #$%logdir "/kdeconnect.log")))
    ;; TODO: Enable autostart
    (auto-start? #f)
    (stop #~(make-kill-destructor))))

;;;

(define guix-system-home-environment
  (home-environment
    (packages package-list)
    (services
      (list
        (service home-bash-service-type
                 (home-bash-configuration
                   (guix-defaults? #t)
                   (environment-variables
                    `(("QT_QPA_PLATFORM" . "wayland")
                      ("ECORE_EVAS_ENGINE" . "wayland_egl")
                      ("ELM_ENGINE" . "wayland_egl")
                      ;; Still necessary for sdl2@2.0.14
                      ("SDL_VIDEODRIVER" . "wayland")
                      ("GDK_BACKEND" . "wayland")
                      ;; This is necessary on the pbp
                      ,@(if (target-aarch64?)
                          `(("GSK_RENDERER" . "cairo"))
                          `())
                      ("MOZ_ENABLE_WAYLAND" . "1")

                      ;("GUIX_GPGV_COMMAND" . "gpgv-sq")
                      ;("GUIX_GPG_COMMAND" . "gpg-sq")
                      ("CVS_RSH" . "ssh")
                      ("EDITOR" . "vim")
                      ("GPG_TTY" . "$(tty)")
                      ("XZ_DEFAULTS" . "--threads=0 --memlimit=50%")
                      ("ZSTD_NBTHREADS" . "0")
                      ("HISTSIZE" . "3000")
                      ("HISTFILESIZE" . "10000")
                      ("HISTCONTROL" . "ignoreboth")
                      ("HISTIGNORE" . "pwd:exit:fg:bg:top:clear:history:ls:uptime:df")
                      ("PROMPT_COMMAND" . "history -a; $PROMPT_COMMAND")))
                   (aliases
                    `(("cp" . "cp --reflink=auto")

                      ;; I seem to have lost these
                      ("ls" . "ls -p --color=auto")
                      ("grep" . "grep --color=auto")
                      ("ip" . "ip -color")

                      ("exitexit" . "exit")
                      ("clear" . "printf '\\E[H\\E[J\\E[0m'")
                      ;("clear" . ,(file-append (S "ncurses") "/bin/clear"))
                      ("ime" . "time")
                      ("guix-home-build" .
                       ,(if (and (not work-machine?)
                                 (file-exists? (string-append
                                                 (getenv "HOME")
                                                 "/workspace/guix/pre-inst-env"))
                                 (target-x86-64?))
                          `(string-append
                             "~/workspace/guix/pre-inst-env guix home "
                             "build --no-grafts --fallback "
                             "-L ~/workspace/my-guix/ "
                             "~/workspace/guix-config/efraim-home.scm")
                          `(string-append
                             "guix home "
                             "build --no-grafts --fallback "
                             "-L ~/workspace/my-guix/ "
                             "~/workspace/guix-config/efraim-home.scm")))
                      ("guix-home-reconfigure" .
                       ,(if (and (not work-machine?)
                                 (file-exists? (string-append
                                                 (getenv "HOME")
                                                 "/workspace/guix/pre-inst-env"))
                                 (target-x86-64?))
                          `(string-append
                             "~/workspace/guix/pre-inst-env guix home "
                             "reconfigure --fallback "
                             "-L ~/workspace/my-guix/ "
                             "~/workspace/guix-config/efraim-home.scm")
                          `(string-append
                             "guix home "
                             "reconfigure --fallback "
                             "-L ~/workspace/my-guix/ "
                             "~/workspace/guix-config/efraim-home.scm")))))
                   (bashrc
                     (list
                       (mixed-text-file "bashrc" "\n
# Run the given command via 'guix shell'
function guix-run
{
    pkg_ver=\"$(set -o pipefail; guix locate \"$1\" | grep /bin/ | head -n1 | cut -f1)\"
    pkg=\"$(echo $pkg_ver | cut -d@ -f1)\"
    test -n \"$pkg\" && guix shell \"$pkg\" -- \"$@\"
}\n")))
                   (bash-logout
                     (list
                       (mixed-text-file "bash-logout" "\
screen -wipe
rm ${XDG_CACHE_HOME:-~/.cache}/tofi-drun\n")))
                   (bash-profile
                     (list
                       (mixed-text-file "bash-profile" "\
unset SSH_AGENT_PID
if [ \"${gnupg_SSH_AUTH_SOCK_by:-0}\" -ne $$ ]; then
    export SSH_AUTH_SOCK=\"$(" (S "gnupg") "/bin/gpgconf --list-dirs agent-ssh-socket)\"
fi
if [ -d ${XDG_DATA_HOME}/flatpak/exports/share ]; then
    export XDG_DATA_DIRS=$XDG_DATA_DIRS:${XDG_DATA_HOME}/flatpak/exports/share
fi
# clean-up some bits
" (S "screen") "/bin/screen -wipe
rm ${XDG_CACHE_HOME:-~/.cache}/tofi-drun\n")))))

        (service home-shepherd-service-type
                 (home-shepherd-configuration
                   (services
                     (list
                       %dropbox-user-service
                       ;%vdirsyncer-user-service    ; error with 'match'
                       ;%mbsync-user-service        ; error with 'match'

                       ;%keybase-user-service
                       ;%keybase-fuse-user-service

                       %kdeconnect-user-service))))

        (service home-dbus-service-type)

        ;; Can't seem to get (if headless?) to work
        #;(service home-gpg-agent-service-type
                 (home-gpg-agent-configuration
                   (pinentry-program
                     (if headless?
                       (file-append (S "pinentry-tty") "/bin/pinentry-tty")
                       (file-append (S "pinentry-qt") "/bin/pinentry-qt")))))

        (service home-inputrc-service-type
                   %home-inputrc-configuration)

        (service home-msmtp-service-type
                 (home-msmtp-configuration
                   (default-account "gmail-efraim")
                   (defaults
                     (msmtp-configuration
                       ;; For tor proxy.
                       #;(extra-content
                         (string-append "proxy_host 127.0.0.1\n"
                                        "proxy_port 9050"))
                       (auth? #t)
                       (tls? #t)))
                   (accounts %home-msmtp-configuration-accounts)))

        (service home-openssh-service-type
                 (home-openssh-configuration
                   (hosts %home-openssh-configuration-hosts)))

        (service home-parcimonie-service-type
          (home-parcimonie-configuration
            (refresh-guix-keyrings? #t)))

        (service home-pipewire-service-type)

        (service home-sway-service-type
                 %home-sway-configuration)

        (service home-syncthing-service-type)

        (service home-files-service-type
         `((".cvsrc" ,%cvsrc)
           (".gnupg/gpg.conf" ,%gpg.conf)
           (".gnupg/gpg-agent.conf" ,%gpg-agent.conf)
           (".guile" ,%default-dotguile)
           ;; Not sure about using this one.
           ; (".mailcap" ,%mailcap)
           ;; https://salsa.debian.org/med-team/parallel/-/blob/2f4412d851ea9f9c41667b5f6821cd1102bb107a/debian/patches/remove-overreaching-citation-request.patch
           (".parallel/will-cite" ,(plain-file "will-cite" ""))
           (".pbuilderrc" ,%pbuilderrc)
           (".screenrc" ,%screenrc)
           (".signature" ,%signature)
           (".wcalcrc" ,%wcalcrc)
           (".wgetrc" ,%wgetrc)
           (".wgetpaste.conf" ,%wgetpaste.conf)
           (".Xdefaults" ,%default-xdefaults)

           (".local/share/qutebrowser/pdfjs"
            ,(file-append (S "pdfjs") "/share/pdfjs"))
           ;; Also files into the bin directory.
           ;("bin/GN_vpn_connect" ,%connect-to-UTHSC-VPN)
           ("bin/update-guix-keyring" ,%update-guix-gpg-keyring)
           ("bin/openbsd-netcat"
            ,(file-append (S "netcat-openbsd") "/bin/nc"))))

        (service home-xdg-configuration-files-service-type
         `(("aria2/aria2.conf" ,%aria2-config)
           #;("chromium/WidevineCdm/latest-component-updated-widevine-cdm"
            ,(file-append (S "widevine")
                          "/share/chromium/latest-component-updated-widevine-cdm"))
           ("curlrc" ,%curlrc)
           ("gdb/gdbinit" ,%default-gdbinit)
           ("git/config" ,%git-config)
           ("git/ignore" ,%git-ignore)
           ("hg/hgrc" ,%hgrc)
           ("isyncrc" ,%mbsyncrc)
           ;("lagrange/fonts" "../../.guix-home/profile/share/fonts")
           ;; This clears the defaults, do not use.
           ; ("lesskey" ,%lesskey)
           ("mpv/scripts/mpris.so"
            ,(file-append (S "mpv-mpris")
                          "/lib/mpris.so"))
           ("mpv/scripts/sponsorblock_minimal/main.lua"
            ,(file-append (S "mpv-sponsorblock-minimal")
                          "/lib/sponsorblock_minimal.lua"))
           ("mpv/scripts/twitch-chat/main.lua"
            ,(file-append (S "mpv-twitch-chat")
                          "/lib/main.lua"))
           ("mpv/mpv.conf" ,%mpv-conf)
           ("mutt/pgp-gnupg.rc" ,%mutt-pgp-gnupg.rc)
           ("mutt/pgp-sq.rc" ,%mutt-pgp-sq.rc)
           ("newsboat/config" ,%newsboat-config)
           ("nano/nanorc" ,%default-nanorc)
           ("qutebrowser/config.py" ,%qutebrowser-config-py)
           ("streamlink/config" ,%streamlink-config)
           ;("tig/config" ,%tig-config)
           ("user-dirs.dirs" ,%xdg-user-dirs)
           ("youtube-dl/config" ,%ytdl-config)
           ("yt-dlp/config" ,%ytdl-config)))))))

(define foreign-home-environment
  (home-environment
    (packages package-list)
    (services
      (list

        (service home-inputrc-service-type
                   %home-inputrc-configuration)

        (service home-msmtp-service-type
                 (home-msmtp-configuration
                   (default-account "gmail-efraim")
                   (defaults
                     (msmtp-configuration
                       ;; For tor proxy.
                       #;(extra-content
                         (string-append "proxy_host 127.0.0.1\n"
                                        "proxy_port 9050"))
                       (auth? #t)
                       (tls? #t)))
                   (accounts %home-msmtp-configuration-accounts)))

        (service home-files-service-type
         `((".cvsrc" ,%cvsrc)
           ;(".gnupg/gpg.conf" ,%gpg.conf)
           ;(".gnupg/gpg-agent.conf" ,%gpg-agent.conf)
           (".guile" ,%default-dotguile)
           ;; Not sure about using this one.
           ; (".mailcap" ,%mailcap)
           (".parallel/will-cite" ,(plain-file "will-cite" ""))
           ;(".pbuilderrc" ,%pbuilderrc)
           (".screenrc" ,%screenrc)
           (".signature" ,%signature)
           (".wcalcrc" ,%wcalcrc)
           (".wgetrc" ,%wgetrc)
           (".wgetpaste.conf" ,%wgetpaste.conf)
           ;(".Xdefaults" ,%default-xdefaults)

           (".local/share/qutebrowser/pdfjs"
            ,(file-append (S "pdfjs") "/share/pdfjs"))
           ;; Also files into the bin directory.
           ;("bin/GN_vpn_connect" ,%connect-to-UTHSC-VPN)
           ("bin/openbsd-netcat"
            ,(file-append (S "netcat-openbsd") "/bin/nc"))))

        (service home-xdg-configuration-files-service-type
         `(("aria2/aria2.conf" ,%aria2-config)
           ("curlrc" ,%curlrc)
           ("gdb/gdbinit" ,%default-gdbinit)
           ("git/config" ,%git-config)
           ("git/ignore" ,%git-ignore)
           ("hg/hgrc" ,%hgrc)
           ("isyncrc" ,%mbsyncrc)
           ;; This clears the defaults, do not use.
           ; ("lesskey" ,%lesskey)
           ("mpv/scripts/mpris.so"
            ,(file-append (S "mpv-mpris")
                          "/lib/mpris.so"))
           ("mpv/scripts/sponsorblock_minimal/main.lua"
            ,(file-append (S "mpv-sponsorblock-minimal")
                          "/lib/sponsorblock_minimal.lua"))
           ("mpv/scripts/twitch-chat/main.lua"
            ,(file-append (S "mpv-twitch-chat")
                          "/lib/main.lua"))
           ("mpv/mpv.conf" ,%mpv-conf)
           ("newsboat/config" ,%newsboat-config)
           ;; Specific to Guix System
           ;("nano/nanorc" ,%default-nanorc)
           ;("qutebrowser/config.py" ,%qutebrowser-config-py)
           ("streamlink/config" ,%streamlink-config)
           ("user-dirs.dirs" ,%xdg-user-dirs)
           ("youtube-dl/config" ,%ytdl-config)
           ("yt-dlp/config" ,%ytdl-config)))))))

(if guix-system?
  guix-system-home-environment
  foreign-home-environment)
