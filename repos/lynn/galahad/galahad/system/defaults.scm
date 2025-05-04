(define-module  (galahad system defaults)
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
(define galahad-hostname "galahad")
(define galahad-dir "$HOME/devel/galahad")
(define galahad-per-host-packages '())
(define galahad-file-systems '())
