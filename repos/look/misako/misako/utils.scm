;;; Copyright © 2025 Murilo <murilo@disroot.org>
;;; Copyright © 2025 Sergio Pastor Pérez <sergio.pastorperez@outlook.es>

(define-module (misako utils)
  #:use-module (gnu home)
  #:use-module (gnu packages gl)
  #:use-module (gnu packages video)
  #:use-module (gnu services)
  #:use-module (gnu system setuid)
  #:use-module (gnu system)
  #:use-module (guix packages)
  #:use-module (guix utils)
  #:use-module (guix transformations)
  #:use-module (ice-9 format)
  #:use-module (ice-9 match)
  #:use-module (ice-9 textual-ports)
  #:use-module (nongnu packages nvidia)
  #:use-module (nongnu packages video)
  #:use-module (nonguix utils)
  #:use-module (srfi srfi-1)
  #:use-module (srfi srfi-26)
  #:use-module (srfi srfi-43)
  #:export (nvidia-home-environment
            nvidia-beta-home-environment
            nvidia-operating-system
            nvidia-beta-operating-system
            ffmpeg-nvenc-beta
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

(define nv-codec-headers-beta
  (package/inherit nv-codec-headers
    (name "nv-codec-headers-beta")
    (inputs
      (modify-inputs (package-inputs nv-codec-headers)
        (replace "nvidia-driver" nvidia-driver-beta)))))

(define ffmpeg-nvenc-beta
  (package/inherit ffmpeg-nvenc
    (name "ffmpeg-nvenc-beta")
    (inputs
      (modify-inputs (package-inputs ffmpeg-nvenc)
        (replace "nv-codec-headers" nv-codec-headers-beta)))))

(define ffmpeg-nvenc/patched
  (package/inherit ffmpeg-nvenc
    (name "ffnveg")))

(define obs-nvenc
  (package/inherit obs
    (name "obs-nvenc")
    (inputs
      (modify-inputs (package-inputs obs)
        (replace "ffmpeg" ffmpeg-nvenc)))))

(define replace-all-nvidia
  (package-input-grafting
    `((,mesa   . ,nvda)
      (,ffmpeg . ,ffmpeg-nvenc/patched))))

(define replace-all-nvidia-beta
  (package-input-grafting
    `((,mesa   . ,nvdb)
      (,ffmpeg . ,ffmpeg-nvenc-beta))))

(define-syntax-rule (nvidia-operating-system exp ...)
  "Like 'operating-system' but graft Mesa with the proprietary NVIDIA driver."
  (if nvidia?
      (with-transformation-except
        replace-all-nvidia
        (operating-system exp ...))
      (operating-system exp ...)))

(define-syntax-rule (nvidia-beta-operating-system exp ...)
  "Like 'operating-system' but graft Mesa with the proprietary NVIDIA driver."
  (if nvidia?
      (with-transformation-except
        replace-all-nvidia-beta
        (operating-system exp ...))
      (operating-system exp ...)))

(define-syntax-rule (nvidia-home-environment exp ...)
  "Like 'home-environment' but graft Mesa with the proprietary NVIDIA driver."
  (if nvidia?
      (with-transformation-except
        replace-all-nvidia
        (home-environment exp ...))
      (home-environment exp ...)))

(define-syntax-rule (nvidia-beta-home-environment exp ...)
  "Like 'home-environment' but graft Mesa with the proprietary NVIDIA driver."
  (if nvidia?
      (with-transformation-except
        replace-all-nvidia-beta
        (home-environment exp ...))
      (home-environment exp ...)))

;; Sergio's procedure
(define* (with-transformation-except proc obj #:optional (pred package?))
  "Recursing into child elements, apply PROC to every element of OBJ that matches
PRED."
  (match obj
    ((? pred)
     (if (equal? (package-name obj) "btrfs-progs")
         obj
         (proc obj)))
    ((? procedure?)
     (lambda args
       (apply values
              (map (cut with-transformation-except proc <> pred)
                   (call-with-values
                       (lambda ()
                         (apply obj args))
                     list)))))
    ((a . b)
     (cons (with-transformation-except proc a pred)
           (with-transformation-except proc b pred)))
    ((_ ...)
     (map (cut with-transformation-except proc <> pred)
          obj))
    (#(_ ...)
     (vector-map (lambda (vec elt)
                   (with-transformation-except proc elt pred))
                 obj))
    ;; `<service-type>' and `<origin>' record types are expected to not be
    ;; modified. Altering them causes very difficult to debug run-time errors.
    ((or (? service-type?)
         (? origin?))
     obj)
    ((? record?)
     (let* ((record-type (record-type-descriptor obj))
            (record-fields (record-type-fields record-type)))
       (apply (record-constructor record-type)
              (map (lambda (field)
                     (let* ((accessor (record-accessor record-type field))
                            (obj (accessor obj)))
                       (with-transformation-except proc obj pred)))
                   record-fields))))
    (_ obj)))
