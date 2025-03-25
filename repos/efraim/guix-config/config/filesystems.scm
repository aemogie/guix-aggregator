(define-module (config filesystems)
  #:use-module (gnu system file-systems)
  #:use-module (gnu services mcron)
  #:use-module (gnu packages linux)
  #:use-module (guix gexp)
  #:export (%btrfs-maintenance-jobs
            %btrfs-defrag-var-guix
            %guix-temproots
            %tmp-tmpfs))

(define (%btrfs-maintenance-jobs mount-point)
  (list
    #~(job '(next-hour '(3))
           (string-append #$btrfs-progs "/bin/btrfs "
                          "scrub " "start " "-c " "idle "
                          #$mount-point))
    #~(job '(next-hour '(5))
           (string-append #$btrfs-progs "/bin/btrfs "
                          "balance " "start "
                          "-dusage=50,limit=3 "
                          "-musage=50,limit=1 "
                          #$mount-point))))

(define %btrfs-defrag-var-guix
  (list
    #~(job '(next-hour '(2))
           (string-append #$btrfs-progs "/bin/btrfs "
                          "filesystem "
                          "defragment "
                          "-rczstd "
                          "/var/guix"))))

;; 10MiB should be enough, but 'guix lint -c derivations' needs much more.
(define %guix-temproots
  (file-system
    (device "tmpfs")
    (mount-point "/var/guix/temproots")
    (type "tmpfs")
    (flags '(no-suid no-dev no-exec))
    (check? #f)))

;; Defaults to 50%
(define %tmp-tmpfs
  (file-system
    (device "tmpfs")
    (mount-point "/tmp")
    (type "tmpfs")
    (flags '(no-suid))
    (check? #f)))
