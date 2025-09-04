(define-module (misako operating-systems yuria file-systems)
  #:use-module (gnu system file-systems)
  #:export (%btrfs-ephemeral-file-systems))

(define guix-part
  (uuid "3597c5bc-1a6e-4227-8ba1-2f3e5f3263e2"))

(define efi-part
  (uuid "7C80-2A6D" 'fat))

(define root
  (file-system
    (device "none")
    (type "tmpfs")
    (mount-point "/")
    (check? #f)
    (needed-for-boot? #t)
    (options "mode=0755")))

(define home
  (file-system
    (device guix-part)
    (type "btrfs")
    (mount-point "/home")
    (flags '(no-atime))
    (options "subvol=@home,discard=async,ssd")))

(define snapshots
  (file-system
    (device guix-part)
    (type "btrfs")
    (mount-point "/snapshots")
    (needed-for-boot? #t)
    (flags '(no-atime))
    (options "compress=zstd,subvol=@snapshots")))

(define root-user
  (file-system
    (device guix-part)
    (type "btrfs")
    (mount-point "/root")
    (flags '(no-atime))
    (options "subvol=@root,discard=async,ssd")))

(define boot
  (file-system
    (device guix-part)
    (type "btrfs")
    (mount-point "/boot")
    (check? #f)
    (needed-for-boot? #t)
    (flags '(no-atime))
    (options "subvol=@boot,discard=async,ssd")))

(define boot-efi
  (file-system
    (device efi-part)
    (type "vfat")
    (mount-point "/boot/efi")))

(define tmp
  (file-system
    (device "none")
    (type "tmpfs")
    (mount-point "/tmp")
    (check? #f)
    (needed-for-boot? #f)))

(define run
  (file-system
    (device "none")
    (type "tmpfs")
    (mount-point "/run")
    (check? #f)
    (needed-for-boot? #t)
    (options "mode=0755")))

(define var-run
  (file-system
    (device "none")
    (type "tmpfs")
    (mount-point "/var/run")
    (check? #f)
    (needed-for-boot? #t)
    (options "mode=0755")))

(define var-log
  (file-system
    (device guix-part)
    (type "btrfs")
    (mount-point "/var/log")
    (check? #f)
    (needed-for-boot? #t)
    (flags '(no-atime))
    (options "compress=zstd,subvol=@var/log,ssd")))

(define var-lib
  (file-system
    (device guix-part)
    (type "btrfs")
    (mount-point "/var/lib")
    (needed-for-boot? #t)
    (flags '(no-atime))
    (options "compress=zstd,subvol=@var/lib,ssd")))

(define var-guix
  (file-system
    (device guix-part)
    (type "btrfs")
    (mount-point "/var/guix")
    (needed-for-boot? #t)
    (flags '(no-atime))
    (options "compress=zstd,subvol=@var/guix,ssd")))

(define var-cache
  (file-system
    (device guix-part)
    (type "btrfs")
    (mount-point "/var/cache")
    (needed-for-boot? #t)
    (flags '(no-atime))
    (options "compress=zstd,subvol=@var/cache,ssd")))

(define gnu-store
  (file-system
    (device guix-part)
    (type "btrfs")
    (mount-point "/gnu/store")
    (needed-for-boot? #t)
    (flags '(read-only no-atime))
    (options "compress=zstd,subvol=@gnu/store,ssd")))

(define gnu-persist
  (file-system
    (device guix-part)
    (type "btrfs")
    (mount-point "/gnu/persist")
    (needed-for-boot? #t)
    (flags '(no-atime))
    (options "subvol=@gnu/persist,ssd")))

(define gnu-persist-ssh
  (file-system
    (device "/gnu/persist/etc/ssh")
    (type "none")
    (mount-point "/etc/ssh")
    (flags '(no-atime bind-mount))))

(define gnu-persist-guix
  (file-system
    (device "/gnu/persist/etc/guix")
    (type "none")
    (mount-point "/etc/guix")
    (flags '(no-atime bind-mount))))

(define gnu-persist-wireguard
  (file-system
    (device "/gnu/persist/etc/wireguard")
    (type "none")
    (mount-point "/etc/wireguard")
    (flags '(no-atime bind-mount))))

(define gnu-persist-mullvad-vpn
  (file-system
    (device "/gnu/persist/etc/mullvad-vpn")
    (type "none")
    (mount-point "/etc/mullvad-vpn")
    (flags '(no-atime bind-mount))))

(define %btrfs-ephemeral-file-systems
  (list root
        home
        snapshots
        root-user
        boot
        boot-efi
        tmp
        run
        var-run
        var-log
        var-lib
        var-guix
        var-cache
        gnu-store
        gnu-persist
        gnu-persist-ssh
        gnu-persist-guix
        gnu-persist-wireguard
        gnu-persist-mullvad-vpn
        %pseudo-terminal-file-system
        %shared-memory-file-system
        %efivars-file-system))
