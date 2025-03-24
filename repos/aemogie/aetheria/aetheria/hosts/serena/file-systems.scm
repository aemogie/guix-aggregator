(define-module (aetheria hosts serena file-systems)
  #:use-module ((gnu system file-systems) #:select (file-system-label
                                                    file-system
                                                    %base-file-systems))
  #:use-module ((aetheria system file-systems) #:select (btrfs-file-system
                                                         persist-bind))
  #:export (serena-file-systems))

;; TOOD: figure out how to change grub.cfg path, then migrate to serena-boot
(define boot
  (file-system
    (device (file-system-label "BOOTTMP"))
    (mount-point "/boot")
    (type "vfat")
    (mount-may-fail? #t)))

(define (serena-part subvol mount-point)
  (file-system
    (inherit (btrfs-file-system
              #:mount-point mount-point
              #:device (file-system-label "serena")
              #:ssd? #t
              #:subvolume subvol))
    (needed-for-boot? #t)))

(define rootfs
  (file-system
    (inherit (serena-part "@" "/"))
    (mount-may-fail? #f)
    ;; TODO: figure out how to wipe+snapshot btrfs on boot
    ;; using tmpfs till then
    (mount-point "/")
    (device "none")
    (type "tmpfs")
    (options #f)))

(define aetheria-store
  (file-system
    (inherit (serena-part "@aetheria-store" "/gnu/store"))
    (mount-may-fail? #f)))

(define aetheria-meta (serena-part "@aetheria-meta" "/var/guix"))

;; figure out a place to put encrypted secrets
;; create way to create the source directory, other than manually doing it
(define persist-part
  (btrfs-file-system
   #:mount-point "/@persist"
   #:device (file-system-label "serena-persist")))

(define nivea
  (file-system
    (mount-point "/mnt/nivea")
    (device (file-system-label "NIXOS"))
    (type "ext4")
    (flags '(read-only))
    (mount-may-fail? #t)))

(define nivea-home ;; migrate to serena-persist btrfs pool
  (file-system
    (mount-point "/mnt/nivea/home")
    (device (file-system-label "NIXHOME"))
    (type "ext4")
    (dependencies (list nivea))
    (mount-may-fail? #t)))

(define serena-partitions
  (list
   ;; == 256gb ssd
   boot           ;; /boot
   rootfs         ;; / (overriden temporarily to tmpfs)
   aetheria-store ;; /gnu/store
   aetheria-meta  ;; /var/guix
   nivea          ;; /mnt/nivea
   ;; == 1tb hdd
   persist-part   ;; /@persist
   nivea-home))   ;; /mnt/nivea/home

;; TODO: move to (aetheria system persist) or (aetheria services persist)
;; when repopulating comes depending on how i implement it
(define serena-persist
  (map (lambda (p) (persist-bind persist-part p))
       ;; TODO: these arent unique to serena
       '("/etc/NetworkManager/system-connections" ;; TODO: figure out sops-guix
         "/var/lib/bluetooth" ;; dont think this is dangerous info tho, maybe generate?
         ;; should be migrated to guix home's mounts when i get to it
         "/root/.cache/guix" ;; guix caches channel checkouts here
         "/home/aemogie/.cache/guix"
         "/home/aemogie/.config/guix"
         "/home/aemogie/.librewolf"
         ;; temporary configs i copied from nivea
         "/home/aemogie/.gnupg"
         "/home/aemogie/.config/hypr/hyprland.conf"
         "/home/aemogie/.config/waybar/config"
         "/home/aemogie/.config/waybar/style.css"
         "/home/aemogie/.config/foot/foot.ini"
         "/home/aemogie/.config/YouTube Music"
         "/home/aemogie/.emacs"
         "/home/aemogie/dev")))

(define serena-file-systems
  (append
   serena-partitions
   serena-persist
   (list
    (persist-bind nivea "/nix/store")  ;; TODO: move to btrfs pool
    ;; TODO: think of how to make /@persist read-only while making the mounted
    ;; versions read/write
    ;; (remount-read-only (file-system-mount-point persist-part)
    ;;                    #:after serena-persist)
    )
   %base-file-systems))
