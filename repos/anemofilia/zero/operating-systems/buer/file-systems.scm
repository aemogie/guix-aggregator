(define-module (operating-systems buer file-systems)
  #:use-module (gnu system file-systems)

  #:export (partition:guix
            persistent-directories
            persistent-files
            volumes))

;;; reminder: Send a patch to guix to make file-system-options and
;;; privileged-program-capabitilities receive a list-of-strings

(define partition:guix
  (file-system-label "guix"))

(define volumes
  (list #|base|#
        %pseudo-terminal-file-system
        %shared-memory-file-system

        #|boot|#
        (file-system
          (device partition:guix)
          (type "btrfs")
          (mount-point "/boot")
          (check? #f)
          (needed-for-boot? #t)
          (flags '(no-atime))
          (options "subvol=@boot"))

        #|run|#
        (file-system
          (device "none")
          (type "tmpfs")
          (mount-point "/run")
          (check? #f)
          (needed-for-boot? #t)
          (flags '(no-dev strict-atime))
          (options (format #f "mode=0755,~
                               nr_inodes=800k,~
                               size=20%")))

        #|tmp|#
        (file-system
          (device "none")
          (type "tmpfs")
          (mount-point "/tmp")
          (check? #f)
          (needed-for-boot? #f))

        #|root|#
        (file-system
          (device "none")
          (type "tmpfs")
          (mount-point "/")
          (check? #f)
          (needed-for-boot? #t)
          (options "mode=0755"))

        #|gnu|#
        (file-system
          (device partition:guix)
          (type "btrfs")
          (mount-point "/gnu/persist")
          (needed-for-boot? #t)
          (flags '(no-atime))
          (options "subvol=@gnu/persist"))
        (file-system
          (device partition:guix)
          (type "btrfs")
          (mount-point "/gnu/store")
          (needed-for-boot? #t)
          (flags '(read-only no-atime))
          (options (format #f "compress=zstd,~
                               subvol=@gnu/store")))

        #|var|#
        (file-system
          (device partition:guix)
          (type "btrfs")
          (mount-point "/var/guix")
          (needed-for-boot? #t)
          (flags '(no-atime))
          (options (format #f "compress=zstd,~
                               subvol=@var/guix")))
        (file-system
          (device partition:guix)
          (type "btrfs")
          (mount-point "/var/lib")
          (needed-for-boot? #t)
          (flags '(no-atime))
          (options (format #f "compress=zstd,~
                               subvol=@var/lib")))
        (file-system
          (device partition:guix)
          (type "btrfs")
          (mount-point "/var/log")
          (check? #f)
          (needed-for-boot? #t)
          (flags '(no-atime))
          (options (format #f "compress=zstd,~
                               subvol=@var/log")))
        (file-system
          (device "none")
          (type "tmpfs")
          (mount-point "/var/run")
          (check? #f)
          (needed-for-boot? #t)
          (flags '(no-dev strict-atime))
          (options (format #f "mode=0755,~
                               nr_inodes=800k,~
                               size=20%")))

        #|snapshots|#
        (file-system
          (device partition:guix)
          (type "btrfs")
          (mount-point "/snapshots")
          (check? #f)
          (needed-for-boot? #t)
          (flags '(no-atime))
          (options (format #f "compress=zstd,~
                               subvol=@snapshots")))

        #|home|#
        (file-system
          (device partition:guix)
          (type "btrfs")
          (mount-point "/root")
          (flags '(no-atime))
          (options "subvol=@root"))
        (file-system
          (device partition:guix)
          (type "btrfs")
          (mount-point "/home")
          (flags '(no-atime))
          (options "subvol=@home"))))

(define persistent-directories
  (map (lambda (filename)
         (file-system
           (mount-point filename)
           (device (string-append "/gnu/persist" mount-point))
           (type "none")
           (check? #f)
           (flags '(no-atime bind-mount))))
       `("/etc/guix"
         "/etc/ssh")))

(define persistent-files
  (list "/etc/machine-id"
        "/etc/wpa-supplicant.conf"))
