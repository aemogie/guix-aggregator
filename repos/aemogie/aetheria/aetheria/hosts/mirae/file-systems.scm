(define-module (aetheria hosts mirae file-systems)
  #:use-module ((gnu system file-systems) #:select (file-system-label
                                                    file-system
                                                    file-system-mount-point
                                                    %base-file-systems))
  #:use-module ((gnu services linux) #:select (vfs-mapping-service-type vfs-mapping))
  #:use-module ((gnu services) #:select (simple-service))
  #:use-module ((aetheria services persist) #:select (persist-service-type
                                                      persist-configuration-defaults))
  #:export (mirae-file-systems
            mirae-persist))

(define (mirae-part subvol mount-point)
  (file-system
    (device (file-system-label "mirae-main"))
    (mount-point mount-point)
    (type "btrfs")
    (flags '(no-atime))
    (options (string-join (list "discard=async" "ssd" (string-append "subvol=" subvol)) ","))
    ;; yet defaults to false, yet doesnt even give any logs when it fails. just hangs.
    (mount-may-fail? #t)))

(define mirae-partitions
  (list
    (file-system
      (device (file-system-label "mirae-boot"))
      (mount-point "/boot")
      (type "vfat")
      (mount-may-fail? #t))
    (file-system
      (inherit (mirae-part "@aetheria-root" "/"))
      (mount-may-fail? #f)
      (needed-for-boot? #t))
    (file-system
      (inherit (mirae-part "@aetheria-store" "/gnu/store"))
      (mount-may-fail? #f)
      (needed-for-boot? #t))
     (mirae-part "@aetheria-meta" "/var/guix")
    (file-system
      (inherit (mirae-part "@nivea-store" "/nix/store"))
      ;; this is needed to avoid collisions with nix-service-type immutable store remount
      (needed-for-boot? #t))
     (mirae-part "@nivea-meta" "/nix/var/nix")))


;; TODO: move to (aetheria system persist) or (aetheria services persist)
;; when repopulating comes depending on how i implement it
(define mirae-persist
  (simple-service
   'mirae-persist
   persist-service-type
   ;; figure out a place to put encrypted secrets
   (list (persist-configuration-defaults
          (drive (mirae-part "@persist" "/var/persist")))
         ;; TODO: figure out sops-guix
         "/etc/NetworkManager/system-connections/"
         ;; dont think this is dangerous info tho, maybe generate?
         "/var/lib/bluetooth/")))

(define mirae-file-systems
  (append
   mirae-partitions
   %base-file-systems))
