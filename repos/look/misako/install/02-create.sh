mkdir -p /mnt/boot
mkdir -p /mnt/home
mkdir -p /mnt/root
mkdir -p /mnt/gnu/store
mkdir -p /mnt/gnu/persist
mkdir -p /mnt/var/log
mkdir -p /mnt/var/lib
mkdir -p /mnt/var/guix

btrfs subvolume create /mnt/@home
btrfs subvolume create /mnt/@root
btrfs subvolume create /mnt/@boot
btrfs subvolume create /mnt/@gnu
btrfs subvolume create /mnt/@gnu/store
btrfs subvolume create /mnt/@gnu/persist
btrfs subvolume create /mnt/@var
btrfs subvolume create /mnt/@var/log
btrfs subvolume create /mnt/@var/lib
btrfs subvolume create /mnt/@var/guix

mount --bind /mnt/@home /mnt/home
mount --bind /mnt/@root /mnt/root
mount --bind /mnt/@boot /mnt/boot
mount --bind /mnt/@gnu/store /mnt/gnu/store
mount --bind /mnt/@gnu/persist /mnt/gnu/persist
mount --bind /mnt/@var/log /mnt/var/log
mount --bind /mnt/@var/lib /mnt/var/lib
mount --bind /mnt/@var/guix /mnt/var/guix

mkdir -p /mnt/@gnu/persist/etc/guix
mkdir -p /mnt/@gnu/persist/etc/ssh
mkdir -p /mnt/@gnu/persist/etc/wireguard

