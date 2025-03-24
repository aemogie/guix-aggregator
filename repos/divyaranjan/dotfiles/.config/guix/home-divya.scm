;;; Divya's home profile on Guix system.
;;; This lives in ~/.config/guix/home-divya.scm and initiated through guix home reconfigure

(define-module (guix-home-config)
  #:use-module (gnu home)
  #:use-module (guix gexp)
  #:use-module (gnu home services)
  #:use-module (gnu home services desktop)
  #:use-module (gnu home services gnupg)
  #:use-module (gnu home services shepherd)
  #:use-module (gnu home services sound)
  #:use-module (gnu home services ssh)
  #:use-module (gnu home services syncthing)
  #:use-module (gnu home services shells)

  #:use-module (gnu services)
  #:use-module (gnu services dbus)
  #:use-module (gnu services shepherd)
  #:use-module (gnu packages)
  #:use-module (gnu packages audio)
  #:use-module (gnu packages linux)
  #:use-module (gnu packages pulseaudio)
  #:use-module (gnu packages haskell-apps)
  #:use-module (gnu packages gnupg)
  #:use-module (gnu system shadow))


;;; Services

(home-environment
 (packages (append (map specification->package
			'(
			  ;; Themes
			  "materia-theme"
			  "arc-icon-theme"
			  "papirus-icon-theme"
			  "bibata-cursor-theme"

			  ;; Audio
			  ;;"ardour"
			  "mumble"
			  "pipewire"
			  "wireplumber"
			  "qpwgraph"
			  "pavucontrol"
			  "carla"
			  "jack-mixer"
			  "audacity"

			  ;; Reading
			  "mupdf"
			  "calibre"
			  "sioyek"
			  "djvulibre"
			  "djvu2pdf"

			  ;; Research
			 ;; "anki"

			  ;; Emacs
			  "emacs-pdf-tools"
			  "emacs-saveplace-pdf-view"
			  "emacs-guix"

			  ;; Essential R
			  "r-dplyr"
			  "r-tidyverse"
			  "r-magrittr"
			  "r-ggplot2"

			  ;; YouTube
			  "ytfzf"

			  ;; LaTeX
			  "texlive-biber"

			  ;; Document handling
			  "libreoffice"
			  ;; Browsers
			  ;; "nyxt"

			  ;; Common Lisp
			  "cl-anaphora"
			  "cl-alexandria"
			  "cl-asdf"
			  "sbcl-clx-xembed"

			  ;; Theorem Proving
			  ;; "lean"

			  ;; Spelling
			  "ispell"

			  ;; Messaging
			  "gnunet"
			  ;; "qtox"
			  "jami"
;			  "telegram-desktop"

			  ;; Torrenting
			  "qbittorrent"
			  "rtorrent-xml-rpc"

			  ;; Astrophysics
			  ;; "stellarium"

			  ;; Graphics
			  "blender"
			  "luminance-hdr"
			  "pqiv"

			  ;; Security
			  "gnupg" ; Installed here and not in system.scm because the service is in home
			  "pinentry"
			  "pinentry-emacs"
			  "pinentry-tty"

			  ;; Syncing
			  "syncthing"
			  "syncthing-gtk"

			  ;; Utilities
			  "clipmenu"
			  "qdirstat"
			  "neofetch"

			  ;; Manuals
			  "c-intro-and-ref"

			  ;; Certificates
			  "nss-certs" ;; it’s installed system-wide but apps in profile sometimes need it.
			  ;; Board
			  "xournalpp"

			  ))))

 (services (append
	    (list
	     (service home-gpg-agent-service-type
                      (home-gpg-agent-configuration
                       (pinentry-program
			(file-append pinentry "/bin/pinentry"))
                       (ssh-support? #t)
                       (default-cache-ttl 3000)
                       (max-cache-ttl 6000)
                       (extra-content "\nallow-loopback-pinentry\nallow-emacs-pinentry\n")))

	     (service home-syncthing-service-type)
	     (service home-dbus-service-type)
	     (service home-pipewire-service-type
		      (home-pipewire-configuration
		       (wireplumber wireplumber)
		       (enable-pulseaudio? #t)))))))
