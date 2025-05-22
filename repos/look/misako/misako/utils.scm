;;; Copyright © 2025 Murilo <murilo@disroot.org>

(define-module (misako utils)
  #:use-module (gnu home)
  #:use-module (gnu packages gl)
  #:use-module (gnu packages video)
  #:use-module (gnu packages audio)
  #:use-module (gnu services)
  #:use-module (gnu system setuid)
  #:use-module (gnu system)
  #:use-module (guix packages)
  #:use-module (guix utils)
  #:use-module (guix gexp)
  #:use-module (guix transformations)
  #:use-module (ice-9 format)
  #:use-module (ice-9 match)
  #:use-module (ice-9 textual-ports)
  #:use-module (nongnu packages nvidia)
  #:use-module (nongnu packages linux)
  #:use-module (nongnu packages video)
  #:use-module (nongnu system linux-initrd)
  #:use-module (nonguix utils)
  #:use-module (srfi srfi-1)
  #:use-module (srfi srfi-26)
  #:use-module (srfi srfi-43)
  #:export (nvidia-operating-system
            nvidia-home-environment
            ffmpeg-nvenc/patched
            obs-nvenc
            plist
            misako-dir
            yumiko-dir
            secrets-dir
            dotfiles-dir
            nvidia?
            nvidia?*
            edit
            reconfigure
            secret))

(define misako-dir
  (let* ((relative "/projects/guile/misako")
         (user-home (getenv "HOME"))
         (doas-user (getenv "DOAS_USER")))
    (if doas-user
        (string-append "/home/" doas-user relative)
        (string-append user-home relative))))

(define yumiko-dir
  (string-append misako-dir "/misako/operating-systems/yumiko"))

(define secrets-dir
  (string-append misako-dir "/secrets"))

(define dotfiles-dir
  (string-append misako-dir "/dotfiles"))

(define (secret key)
  (call-with-input-file
    (format #f "/run/~?secrets~{/~a~}"
            "~:[user/~a/~;~]"
            (list (zero? (getuid)) (getuid))
            key)
    get-string-all))

(define nvidia?
  (file-exists? "/proc/driver/nvidia"))

(define (nvidia?* . packages)
  (if nvidia? packages '()))

(define (edit file)
  (string-append "$EDITOR " file))

(define (reconfigure path)
  (cond
    ((string-contains path "home")
     (string-append "guix home reconfigure " path))
    ((string-contains path "system")
     (string-append "doas guix system reconfigure " path))))

(define (flatten-package-list x)
  (match x
         ('() '())
         (((? package?) (? string?)) x)
         ((head . tail)
          (append (flatten-package-list head)
                  (flatten-package-list tail)))
         (else (list x))))

(define plist
  (compose flatten-package-list list))

(define ffmpeg-nvenc/patched
  (package
    (inherit ffmpeg-nvenc)
    (name "ffnveg")))

(define obs-nvenc
  (package/inherit obs
    (name "obs-nvenc")
    (inputs
      (modify-inputs (package-inputs obs)
        (replace "ffmpeg" ffmpeg-nvenc/patched)))))

(define replace-all-nvidia
  (package-input-grafting
    `((,mesa   . ,nvda)
      (,ffmpeg . ,ffmpeg-nvenc/patched))))

(define-syntax-rule (nvidia-home-environment exp ...)
  "Like 'home-environment' but graft Mesa with the proprietary NVIDIA driver."
  (if nvidia?
      (with-transformation
        replace-all-nvidia
        (home-environment exp ...))
      (home-environment exp ...)))

(define-syntax nvidia-operating-system
  (syntax-rules (driver x11-system?)
    ((nvidia-operating-system #:driver dri #:x11-system? x11 exp ...)
     ((nvidia-system-transformation #:driver dri
                                    #:x11-display? x11)
      (operating-system exp ...)))
    ((nvidia-operating-system #:x11-system? x11 #:driver dri exp ...)
     ((nvidia-system-transformation #:driver dri
                                    #:x11-display? x11)
      (operating-system exp ...)))
    ((nvidia-operating-system #:driver dri exp ...)
     ((nvidia-system-transformation #:driver dri)
      (operating-system exp ...)))
    ((nvidia-operating-system #:x11-system? x11 exp ...)
     ((nvidia-system-transformation #:x11-display? x11)
      (operating-system exp ...)))
    ((nvidia-operating-system exp ...)
     ((nvidia-system-transformation) (operating-system exp ...)))))
