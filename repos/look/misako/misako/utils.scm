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
  #:use-module (nonguix transformations)
  #:use-module (srfi srfi-1)
  #:use-module (srfi srfi-26)
  #:use-module (srfi srfi-43)
  #:export (nvidia-operating-system
            nvidia-home-environment
            obs-nvenc
            glist
            misako-dir
            yumiko-dir
            yuria-dir
            yumiko?*
            yuria?*
            yumiko-sops-dir
            look-sops-dir
            look-files-dir
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

(define yuria-dir
  (string-append misako-dir "/misako/operating-systems/yuria"))

(define yumiko-sops-dir
  (string-append misako-dir "/misako/operating-systems/yumiko/sops"))

(define look-sops-dir
  (string-append misako-dir "/misako/home-environments/look/sops"))

(define look-files-dir
  (string-append misako-dir "/misako/home-environments/look/files"))

(define (yumiko?* . thing)
  (if (equal? (gethostname) "yumiko")
      thing
      #f))

(define (yuria?* . thing)
  (if (equal? (gethostname) "yuria")
      thing
      #f))

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

(define (filter-f lst)
  (filter (lambda (x)
            (if (eq? x #f)
                #f
                x))
          lst))

(define glist
  (compose filter-f flatten-package-list list))

(define obs-nvenc
  (package/inherit obs
    (name "obs-nvenc")
    (arguments
     (substitute-keyword-arguments (package-arguments obs)
       ((#:configure-flags flags)
        #~(cons* "-DENABLE_NVENC=ON"
                 (delete "-DENABLE_NVENC=OFF" #$flags)))))
    (inputs
      (modify-inputs (package-inputs obs)
        (prepend nv-codec-headers)
        (replace "ffmpeg" ffmpeg-nvenc)))))

(define replace-all-nvidia
  (package-input-grafting
    `((,mesa   . ,nvda)
      (,ffmpeg . ,ffmpeg-nvenc))))

(define-syntax-rule (nvidia-home-environment exp ...)
  "Like 'home-environment' but graft Mesa with the proprietary NVIDIA driver."
  (if nvidia?
      (with-transformation
        replace-all-nvidia
        (home-environment exp ...))
      (home-environment exp ...)))

(define-syntax nvidia-operating-system
  (syntax-rules (driver)
    ((nvidia-operating-system #:driver dri exp ...)
     ((nonguix-transformation-nvidia #:driver dri)
      (operating-system exp ...)))
    ((nvidia-operating-system exp ...)
     ((nonguix-transformation-nvidia) (operating-system exp ...)))))
