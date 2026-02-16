(define-module (aetheria hosts serena file-systems)
  #:use-module ((gnu system file-systems) #:select (file-system-label
                                                    file-system
                                                    file-system-mount-point
                                                    %base-file-systems))
  #:use-module ((gnu services linux) #:select (vfs-mapping-service-type vfs-mapping))
  #:use-module ((gnu services) #:select (simple-service))
  #:use-module ((aetheria system file-systems) #:select (btrfs-file-system
                                                         persist-bind))
  #:export (serena-file-systems
            serena-persist))

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

(define (make-persist-service path user)
  (vfs-mapping
   (source (string-append (file-system-mount-point persist-part) path))
   (destination path)
   (user user)
   (name (string-append "persist-" path))))

;; TODO: move to (aetheria system persist) or (aetheria services persist)
;; when repopulating comes depending on how i implement it
(define serena-persist
  (simple-service
   'serena-persist
   vfs-mapping-service-type
   (list
    ;; TODO: these arent unique to serena
    ;; TODO: figure out sops-guix
    (make-persist-service "/etc/NetworkManager/system-connections/" "root")
    ;; dont think this is dangerous info tho, maybe generate?
    (make-persist-service "/var/lib/bluetooth/" "root")
    ;; should be migrated to guix home's mounts when i get to it
    ;; guix caches channel checkouts here
    (make-persist-service "/root/.cache/guix/" "root")
    (make-persist-service "/home/aemogie/.cache/guix/" "aemogie")
    (make-persist-service "/home/aemogie/.config/guix/" "aemogie")
    (make-persist-service "/home/aemogie/.librewolf/" "aemogie")
    ;; temporary configs i copied from nivea
    (make-persist-service "/home/aemogie/.gnupg/" "aemogie")
    (make-persist-service "/home/aemogie/.config/hypr/" "aemogie")
    (make-persist-service "/home/aemogie/.config/waybar/" "aemogie")
    (make-persist-service "/home/aemogie/.config/foot/" "aemogie")
    (make-persist-service "/home/aemogie/.config/YouTube Music/" "aemogie")
    (make-persist-service "/home/aemogie/.config/WebCord/" "aemogie")
    (make-persist-service "/home/aemogie/.local/share/direnv/" "aemogie")
    #;(make-persist-service "/home/aemogie/.emacs" "aemogie")
    (make-persist-service "/home/aemogie/dev/" "aemogie"))))

(define serena-file-systems
  (append
   serena-partitions
   (list
    (persist-bind nivea "/nix/store")  ;; TODO: move to btrfs pool
    ;; TODO: think of how to make /@persist read-only while making the mounted
    ;; versions read/write
    ;; (remount-read-only (file-system-mount-point persist-part)
    ;;                    #:after serena-persist)
    )
   %base-file-systems))
