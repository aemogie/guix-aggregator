(define-module (galahad host)
  #:export (galahad-language
	    galahad-timezone
	    galahad-keyboard-layout
	    galahad-keyboard-caps-to-ctrl
	    galahad-hostname
	    galahad-dir
	    galahad-file-systems
	    galahad-per-host-packages
	    ))
(define galahad-language "en_US")
(define galahad-timezone "Europe/Berlin")
(define galahad-keyboard-layout "us")
(define galahad-keyboard-caps-to-ctrl #t)
(define galahad-hostname "arc")
(define galahad-dir "$HOME/dev/galahad")
(define galahad-per-host-packages '())
(define galahad-file-systems
  '((file-systems (cons* (file-system
			  (mount-point "/boot/efi")
			  (device (uuid "6332-F4BA"
					'fat32))
			  (type "vfat"))
			 (file-system
			  (mount-point "/")
			  (device (uuid
				   "UUID"
				   'ext4))
			  (type "ext4"))
			 (file-system
			  (mount-point "/home")
			  (device (uuid
				   "UUID"
				   'ext4))
			  (type "ext4"))))))
