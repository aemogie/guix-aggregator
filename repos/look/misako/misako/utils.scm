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
  #:use-module (rosenthal utils nix)
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
            nix->guix))

(define-public misako-user-home
  (let* ((user-home (getenv "HOME"))
         (doas-user (getenv "DOAS_USER")))
    (if doas-user
        (string-append "/home/" doas-user)
        user-home)))

(define misako-dir
  (string-append misako-user-home "/projects/guile/misako"))

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
    (let ((relative-key (string-join key "/"))
          (doas-user (getenv "DOAS_USER")))
      (if (zero? (getuid))
          (if doas-user
              (string-append "/run/user/"
                             (number->string (passwd:uid (getpwnam doas-user)))
                             "/secrets/" relative-key)
              (string-append "/run/secrets/" relative-key))
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

(define-syntax-rule (nvidia-home-environment exp ...)
  "Like 'home-environment' but graft Mesa with the proprietary NVIDIA driver."
  (if nvidia?
      (replace-mesa (home-environment exp ...) #:driver nvda-595)
      (home-environment exp ...)))

(define-syntax-rule (nvidia-operating-system exp ...)
  ((nonguix-transformation-nvidia #:open-source-kernel-module? #t
                                  #:driver nvda-595)
   (operating-system exp ...)))

(define %default-nix-channel "github:NixOS/nixpkgs/nixos-26.05")

(define (spec-ref spec key default)
  (if (pair? spec)
      (let ((kv (memq key (cdr spec))))
        (if kv (cadr kv) default))
      default))

(define* (nix->guix-one spec #:key (channel %default-nix-channel))
  (let* ((name (if (pair? spec) (car spec) spec))
         (name-str (symbol->string name))
         (channel (spec-ref spec #:channel channel))
         (command (spec-ref spec #:command name-str))
         (run-command (spec-ref spec #:run-command name-str)))
    (nix-shell-wrapper command
      (list (string-append channel "#" name-str))
      #:options '("--impure")
      #:run-command (list run-command))))

(define* (nix->guix specs #:key (channel %default-nix-channel))
  (with-nix-profile
    (map (lambda (spec) (nix->guix-one spec #:channel channel))
         specs)))
