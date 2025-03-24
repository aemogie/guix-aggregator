# Guix System root on tmpfs

Below are the steps I used to get Guix System running on tmpfs.

Perhaps something could be done better, but I've tried a couple of approaches and this was the best I could come up with.

Remember to backup everything before starting!
Think before doing each command.

## Set your keyboard layout

```bash
loadkeys br-abnt2
```

## Get my system configuration repository

If you are looking for the file-system declarations, search for the [file-systems.scm](https://codeberg.org/look/misako/src/commit/3bba43e31c3f73e174a1f27a7489b08547b1f20a/misako/operating-systems/yumiko/file-systems.scm#L156-L176) file in this repository.

```bash
guix shell git -- git clone https://codeberg.org/look/misako
export GUILE_LOAD_PATH=/root/misako:$GUILE_LOAD_PATH
```

## Prepare channels for guix pulling on live iso

```bash
mkdir /root/.config/guix
cp /root/misako/install/channels.scm /root/.config/guix/channels.scm
guix archive --authorize < /root/misako/install/signing-key.pub
```

## Pull latest channels on live iso and update guix

```bash
guix pull
GUIX_PROFILE="/root/.config/guix/current"
. "$GUIX_PROFILE/etc/profile"
```

## Check your devices

```bash
lsblk
cfdisk /dev/<the disk>

# Fix the partitions
# In my case:
# /dev/sdc1: EFI System (will be mounted on /mnt/boot/efi)
# /dev/sdc2: Linux system partition (will be mounted on /mnt)
```

## Format the partitions

```bash
mkfs.btrfs -L guix /dev/<the partition>
# I label it guix
mkfs.fat -F 32 /dev/<the boot partition>
fatlabel /dev/<the boot partition> guix-boot
# I label it guix-boot
```

## Mount the guix partition

```bash
mount LABEL=guix /mnt
```

## Create directories beforehand for binding later

```bash
mkdir -p /mnt/boot
mkdir -p /mnt/home
mkdir -p /mnt/root
mkdir -p /mnt/gnu/store
mkdir -p /mnt/gnu/persist
mkdir -p /mnt/var/log
mkdir -p /mnt/var/lib
mkdir -p /mnt/var/guix
```

## Create the btrfs subvolumes

```bash
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
```

## Bind the subvolume to its respective mountpoint on a standard fs

```bash
mount --bind /mnt/@home /mnt/home
mount --bind /mnt/@root /mnt/root
mount --bind /mnt/@boot /mnt/boot
mount --bind /mnt/@gnu/store /mnt/gnu/store
mount --bind /mnt/@gnu/persist /mnt/gnu/persist
mount --bind /mnt/@var/log /mnt/var/log
mount --bind /mnt/@var/lib /mnt/var/lib
mount --bind /mnt/@var/guix /mnt/var/guix
```

## Create necessary persist directories

```bash
mkdir -p /mnt/@gnu/persist/etc/guix
mkdir -p /mnt/@gnu/persist/etc/ssh
mkdir -p /mnt/@gnu/persist/etc/wireguard
```

## Mount efi partition

```bash
mkdir -p /mnt/boot/efi
mount LABEL=guix-boot /mnt/boot/efi
```

## Start the store

```bash
herd start cow-store /mnt
```

## Init the Guix System

```bash
guix system init /root/misako/misako/machines/yuria.scm /mnt --substitute-urls='https://ci.guix.gnu.org https://bordeaux.guix.gnu.org https://substitutes.nonguix.org'
```

## Populate /gnu/persist

Almost done, you just need to populate `/gnu/persist` now.

```bash
# You can do these after reboot too
# You might need to guix shell dbus
dbus-uuidgen > /mnt/@gnu/persist/etc/machine-id
cp -r /etc/ssh/* /mnt/@gnu/persist/etc/ssh
cp -r /etc/guix/* /mnt/@gnu/persist/etc/guix
# You might wanna delete /mnt/@gnu/persist/etc/guix/acl too if you don't know what you're doing
```

Mine looks like this:

```txt
/gnu/persist/
└── etc
    ├── guix
    │   ├── acl -> /gnu/store/xi1kig7n86zs212847c9sy5dcmq81ans-acl
    │   ├── signing-key.pub
    │   └── signing-key.sec
    ├── machine-id
    └── ssh
        ├── authorized_keys.d
        ├── ssh_host_ecdsa_key
        ├── ssh_host_ecdsa_key.pub
        ├── ssh_host_ed25519_key
        ├── ssh_host_ed25519_key.pub
        ├── ssh_host_rsa_key
        └── ssh_host_rsa_key.pub
```

You can add this service to your system services for the machine-id, the rest is defined in file-systems.

```scheme
(extra-special-file "/etc/machine-id" "/gnu/persist/etc/machine-id")
```

## Cleanup

Remember to NOT `rm /mnt/boot/efi`!

We only `rm /mnt/boot` here!

```bash
umount /mnt/home
umount /mnt/root
umount /mnt/boot/efi
umount /mnt/boot
umount /mnt/gnu/store
umount /mnt/gnu/persist
umount /mnt/var/log
umount /mnt/var/lib
umount /mnt/var/guix

rm -rf /mnt/home
rm -rf /mnt/root
rm -rf /mnt/boot
rm -rf /mnt/bin
rm -rf /mnt/etc
rm -rf /mnt/gnu
rm -rf /mnt/mnt
rm -rf /mnt/tmp
rm -rf /mnt/var
```

## Fix permissions

```bash
chmod 700 /mnt/@root
chmod 644 /mnt/@gnu/persist/etc/machine-id
chmod 600 /mnt/@gnu/persist/etc/wireguard
chmod 600 /mnt/@gnu/persist/etc/ssh
chmod 600 /mnt/@gnu/persist/etc/guix
```

## Reboot

```bash
reboot
```

## Some tips

- You might wanna fix your `/root` and use it as a btrfs `@root` subvolume, see [guix issues 45295](https://issues.guix.gnu.org/45295).
