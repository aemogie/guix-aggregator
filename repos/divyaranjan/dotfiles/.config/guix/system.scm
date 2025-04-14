;; Divya's GNU Guix System Configuration files.
;; It lives at ~/.config/guix/system.scm
;; This should be reconfigured with `guix system reconfigure system.scm`.

;; Indicate which modules to import to access the variables
;; used in this configuration.
(use-modules (gnu))
(use-modules (gnu services base)
 	     (gnu services sound)
	     (gnu services cups)
	     (gnu services mcron)
	     (gnu services shepherd)
	     (gnu services xorg)
	     (gnu packages haskell-apps)
	     (gnu packages cups)
	     (gnu packages linux)
	     (gnu packages bash)
	     (nongnu packages linux) ;; For mainline linux, since AMD Ryzen 7 APU doesn't work with linux-libre
	     (nongnu system linux-initrd)
	     (nongnu packages printers) ;; For non-free hp drivers
	     (divya-lambda emacs)
	     (divya-lambda fonts)
	     (gnu packages version-control))

(use-modules (guix))
(use-service-modules cups desktop networking ssh xorg sddm)
(use-package-modules ssh)

;;; MCron Services for Scheduled Jobs

;; (define essential-backup-job
;;   ;; Hourly run a backup script in ~/.dotfiles that backs up notes, dotfiles,
;;   ;; and anything else into another disk and encrypts whatever is private.
;;   (job "0 */4 * * *"
;; 	 "./~/.dotfiles/scripts/backup"))

;; (define garbage-collector-job
;;   ;; Collect garbage 5 minutes after 09:00 AM UTC every day
;;   #~(job "5 0 * * *"
;; 	 "guix gc -F 1G"))

;;; Kmonad
(define kmonad-service
  (simple-service
   'kmonad-service
   shepherd-root-service-type
   (list (shepherd-service
	  (documentation "Run the kmonad daemon (kmonad-daemon)." )
	  (provision '(kmonad-daemon))
	  (requirement '(udev user-processes))
	  (start #~(make-forkexec-constructor
		    (list #$(file-append kmonad "/bin/kmonad")
			  (string-append
			   "/home/divya/.config/kmonad/divya.kbd"))
                    #:log-file "/var/log/kmonad.log"))
          (stop #~(make-kill-destructor))))))

;;; Mounting

(define mount-ntfs-service
  (simple-service
   'mount-ntfs-service
   shepherd-root-service-type
   (list (shepherd-service
	  (documentation "Run script to mount NTFS filesystems.")
	  (provision '(mount-ntfs))
	  (requirement '(udev user-processes))
	  ;; (start #~(lambda _
	  ;; 	     (system* "/home/divya/.dotfiles/scripts/mount-ntfs-devices")))
	  ;; (stop #~(lambda _
	  ;; 	    (format #t "Stopping mount service~%")
	  ;; 	    #t))
	  (start #~(make-forkexec-constructor
		    (list #$(file-append bash "/bin/bash")
			  (string-append "/home/divya/.dotfiles/scripts/mount-ntfs-devices"))))
	  (stop #~(make-kill-destructor))
	  (respawn? #f)
	  ))))
(operating-system
 (locale "en_US.utf8")
 (timezone "UTC")
 (keyboard-layout (keyboard-layout "us"))
 (host-name "lambda")

;;; Kernel level modifications
 (kernel linux)
 ;; (initrd microcode-initrd)
 (firmware (list linux-firmware))
 ;; To enable module for USB Wifi/BT Adapter: Swiztek BT+WIFI
 ;; (kernel-arguments '("modprobe.blacklist=rtw88_8821cu"))
 ;; (kernel-loadable-modules (list rtl8821cu-linux-module))

;;; User Groups
 (groups (cons*
	  (user-group
	   (name "realtime")
	   (system? #t))
	  %base-groups))

 ;; The list of user accounts ('root' is implicit).
 (users (cons* (user-account
                (name "divya")
                (comment "Divya")
                (group "users")
                (home-directory "/home/divya")
                (supplementary-groups '("lp" "lpadmin" "wheel" "realtime" "netdev" "audio" "video")))
	       %base-user-accounts))

 ;; Packages installed system-wide.  Users can also install packages
 ;; under their own account: use 'guix search KEYWORD' to search
 ;; for packages and 'guix install PACKAGE' to install a package.
 (packages
  (append (map (compose list specification->package+output)
	       `(
;;; Window Managers
		 "stumpwm"

;;; Text Editors
		 ;; "emacs-next"
		 ;; "emacs-master-xwidgets"
		 ;; "emacs-master-lucid"
		 "emacs-master-igc"
		 ;;"emacs-master-no-x-toolkit"
		 "vim"

;;; Audio/Video/Streaming
		 "alsa-utils"
		 "alsa-lib"
		 "bluez"
		 "bluez-alsa"
		 "mpd"
		 "mpv"
		 "vlc"
		 "simplescreenrecorder"
		 ;; "carla"

;;; Connectivity
		 "blueman"
		 "v4l2loopback-linux-module" ; Webcam

;;; Browser
		 "librewolf"
		 "ungoogled-chromium"
		 "icecat"

;;; Email
		 ;; "mu"
		 "isync"
		 "msmtp"

;;; Graphics/Image
		 "imagemagick"
		 "gimp"
		 ;; "krita"
		 "imlib2"
		 "feh"

;;; Fonts
		 "fontmanager"
		 "font-iosevka"
		 "font-google-noto-emoji"
		 "font-lohit"
		 "font-spline-sans-mono"
		 "font-inconsolata"
		 "font-ibm-plex"
		 "font-victor-mono"
		 "font-juliamono"
		 "font-anonymous-pro"

;;; Mathematics/Computational Software
		 ;; "sage"
		 "octave"
		 "gnuplot"

;;; LaTeX
		 "texlive"
		 "texlive-xetex"
		 "texmacs"

;;; Programming Languages
		 "chez-scheme"
		 "mit-scheme"
		 "racket"
		 "gcc-toolchain"
		 "clang"
		 "gdb"
		 "ghc"
		 "cabal-install"
		 "hlint"
		 "gforth"
		 ;; "java"
		 "python"
		 "python-pip"
		 "r"
		 "sbcl"
		 ;;"rust-next" ;; from (btv rust)
		 ;; "rust-next:tools"
		 ;; "rust-next:cargo"
		 "rust"
		 "rust:tools"
		 "rust-cargo"
		 "rust-analyzer"
		 "rust-clippy"
		 "clojure"
		 "clojure-tools"
		 "go"
		 "gopls"
		 "gprolog"
		 ;; "swi-prolog"
		 ;; "smlnj"
		 ;; "polyml"
		 "opam"
		 "ocaml"
		 "sqlite"

		 ;;; Reverse Engineering
		 "cutter"
		 "binutils"
		 "binwalk"
		 "imhex"

		 ;;; Virtualization
		 "qemu"

;;; Terminals
		 "alacritty"
		 "xst"
		 ;; "foot"

;;; Launchers
		 "dmenu"

;;; Notifications
		 "dunst"

;;; Theme
		 "lxappearance"

;;; File Manager
		 "thunar"
		 "thunar-volman"
		 "gvfs"		     ; For trash and remote management
		 "lf"

		 ;; Clipboard
		 "xclip"

;;; Search
		 "fd"
		 "fzf"
		 "ripgrep"

;;; Screenshot
		 "maim"

		 ;; Pritning
		 "hplip"
		 ;; "hplip-plugin"
		 "hplip-minimal"
		 "system-config-printer"

;;; Syncing
		 ;; "syncthing"
		 ;; "syncthing-gtk"
		 "rsync"

;;; Version Control/Package Management
		 "git"
		 "git:send-email"
		 "stow"
		 "flatpak"
;;; Shell
		 "bash"
		 "zsh"
		 "scsh"

;;; Keyboard Management
		 "kmonad"

;;; Password/Security
		 "keepassxc"
		 "password-store"

;;; Utilities
		 "curl"
		 "ntfs-3g" ;; for mounting ntfs file systems
		 "zip"
		 "tree"
		 "ncurses"
		 "unzip"
		 "unrar-free"
		 "radeontop"
		 "xsensors"
		 "bashtop"
		 "patchelf"
		 "gnutls"
		 "tmsu"
		 "direnv"

		 ;; Xorg
		 "xset"
		 "xdotool"
		 "picom"
		 "xwininfo"
		 "xprop"

		 ;; Kernel/Drivers
		 ;;		 "rtl8821cu-linux-module" ;; The driver module for the BT/WIFI adapter needs to be installed (from nongnu)
		 ))
	  %base-packages))

 ;; Below is the list of system services.  To search for available
 ;; services, run 'guix system search KEYWORD' in a terminal.
 (services
  (append (list
           (service openssh-service-type)
           (service tor-service-type)

	   ;; Printers
           (service cups-service-type
		    (cups-configuration
		     (web-interface? #t)
		     (extensions
		      (list cups-filters hplip-minimal))))

	   ;; Bluetooth
	   (service bluetooth-service-type
		    (bluetooth-configuration
		     (always-pairable? #t)
		     (fast-connectable? #t)
		     (auto-enable? #t)))

	   ;; Display Manager
	   (service sddm-service-type
		    (sddm-configuration
		     (display-server "x11")))
	   ;; Audio
	   (service pam-limits-service-type
		    (list
		     (pam-limits-entry "@realtime" 'both 'rtprio 99)
		     (pam-limits-entry "@realtime" 'both 'memlock 'unlimited)))

	   kmonad-service
	   mount-ntfs-service)
	  ;; Delete GDM
	  (modify-services %desktop-services
			   (delete gdm-service-type))))

 (bootloader (bootloader-configuration
              (bootloader grub-efi-bootloader)
              (targets (list "/boot/efi"))
              (keyboard-layout keyboard-layout)))
 (swap-devices (list (swap-space
                      (target (uuid
                               "87bbb66e-4980-4c9b-8fda-8b53d40efaca")))))

 ;; The list of file systems that get "mounted".  The unique
 ;; file system identifiers there ("UUIDs") can be obtained
 ;; by running 'blkid' in a terminal.

 (file-systems (cons* (file-system
                       (mount-point "/")
                       (device (uuid
                                "5e43b290-16f4-40e2-aa33-1229bf6de18a"
                                'btrfs))
                       (type "btrfs"))
		      (file-system
		       (mount-point "/mnt/code")
		       (device (uuid
				"5a7f9085-5224-4930-946a-9fd91f502d17"
				'ext4))
		       (type "ext4"))
                      (file-system
                       (mount-point "/boot/efi")
                       (device (uuid "1EC0-78B1"
                                     'fat32))
                       (type "vfat")) %base-file-systems)))
