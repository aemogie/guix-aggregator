(define-module (aetheria system file-systems)
  #:use-module ((gnu system file-systems) #:select (file-system-mount-point
                                                    file-system))
  #:export (btrfs-file-system
            persist-bind
            remount-read-only))

(define* (btrfs-file-system #:key device mount-point (ssd? #f) (subvolume #f))
  (define ssd-options (if ssd? '("discard=async" "ssd") '()))
  (define subvol-options (if subvolume (list (string-append "subvol=" subvolume)) '()))
  (file-system
    (device device)
    (mount-point mount-point)
    (type "btrfs")
    (flags '(no-atime))
    (options (string-join (append ssd-options subvol-options) ","))
    ;; yet defaults to false, yet doesnt even give any logs when it fails. just hangs.
    (mount-may-fail? #t)))

;; TODO: this stops user-homes from being generated. for files in home
;; directory, we need (guix home) and a different fuse-based bind
;; mount. nix-impermenance uses bindfs.
(define (persist-bind persist-device path)
  (file-system
    (mount-point path)
    (device (string-append (file-system-mount-point persist-device) path))
    (type "none")
    (flags '(bind-mount no-atime))
    (dependencies (list persist-device))
    (shepherd-requirements '(user-processes))
    (mount-may-fail? #t)))

(define* (remount-read-only path #:key (after '()))
  (file-system
    (mount-point path)
    (device path)
    (type "none")
    (check? #f)
    (flags '(read-only bind-mount no-atime))
    (dependencies after)
    (mount-may-fail? #t)))
