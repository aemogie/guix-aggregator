;;; Copyright © 2025 Murilo <murilo@disroot.org>

(define-module (misako utils)
  #:use-module (gnu home)
  #:use-module (gnu packages audio)
  #:use-module (gnu packages gl)
  #:use-module (gnu packages video)
  #:use-module (gnu services)
  #:use-module (gnu system setuid)
  #:use-module (gnu system)
  #:use-module (guix gexp)
  #:use-module (guix packages)
  #:use-module (guix scripts build)
  #:use-module (guix transformations)
  #:use-module (guix utils)
  #:use-module (ice-9 format)
  #:use-module (ice-9 match)
  #:use-module (ice-9 textual-ports)
  #:use-module (nongnu packages linux)
  #:use-module (nongnu packages nvidia)
  #:use-module (nongnu packages video)
  #:use-module (nongnu system linux-initrd)
  #:use-module (nonguix transformations)
  #:use-module (nonguix utils)
  #:use-module (srfi srfi-1)
  #:use-module (srfi srfi-26)
  #:use-module (srfi srfi-43)
  #:export (nvidia-operating-system
            nvidia-home-environment
            obs-nvenc
            list*
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
            secret
            bin-fix))

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
      '()))

(define (yuria?* . thing)
  (if (equal? (gethostname) "yuria")
      thing
      '()))

(define (secret key)
  (call-with-input-file
    (let ((relative-key (string-join key "/")))
      (if (zero? (getuid))
          (string-append "/run/secrets/" relative-key)
          (string-append "/run/user/"
                         (number->string (getuid))
                         "/secrets/" relative-key)))
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

(define list*
  (compose flatten-package-list list))

(define* (bin-fix pkg drv #:optional (bin-name pkg))
  (let ((store-path (string-trim-right
                      (with-output-to-string
                        (lambda ()
                          (guix-build pkg (string-append "--with-graft=mesa=" drv))))
                      char-whitespace?)))
    (list
      (string-append ".local/bin/" bin-name)
      (computed-file
        (string-append "link-" bin-name)
        #~(symlink #$(string-append store-path "/bin/" bin-name)
                   #$output)))))

(define-syntax-rule (nvidia-home-environment exp ...)
  "Like 'home-environment' but graft Mesa with the proprietary NVIDIA driver."
  (if nvidia?
      (replace-mesa (home-environment exp ...) #:driver nvda-595)
      (home-environment exp ...)))

(define-syntax-rule (nvidia-operating-system exp ...)
  ((nonguix-transformation-nvidia #:open-source-kernel-module? #t
                                  #:driver nvda-595)
   (operating-system exp ...)))
