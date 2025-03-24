#!/bin/sh
qemu-system-x86_64 \
-enable-kvm \
-m 4G \
-smp 4 \
-hda /mnt/LDisk-D/virtual-machines/arch-reverse.qcow2 \
-cdrom "/mnt/LDisk-E/Albert Einstein/THE UNIVERSE/Arch Linux/archlinux-2025.03.01-x86_64.iso"
