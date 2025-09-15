#!/bin/bash

set -euo pipefail


########### SAFETY CHECKS ##########

: "$DISK:?" "$USER_PASS:?" "$NEXTDNS:?"

read -rp $"\e[31mThis will wipe every little thing on your disk and reformat...\nAlso, you should know EVERYTHING this does before running it because it makes a LOT of assumptions...\nType 'IK' to continue: \e[0m" CONFIRM
if [ "$CONFIRM" != "IK" ]; then
    printf "\e[31mError: You didn't confirm you knew\e[0m"
    exit 1
fi

if mountpoint -q /mnt; then
    umount -R /mnt
    cryptsetup close cryptroot
fi

timedatectl set-timezone America/New_York

SCRIPTDIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)


########### DISK SETUP ##########

# Wipe the disk and create a fresh partition scheme
sgdisk --zap-all "/dev/$DISK"
sgdisk -g "$DISK"
sgdisk -n 1:0:+256M -t 1:ef00 -c 1:"EFI System" "/dev/$DISK"
sgdisk -n 2:0:0 -t 2:8300 -c 2:"Linux filesystem" "/dev/$DISK"

# Format the esp partition with FAT32
mkfs.fat -F 32 "/dev/${DISK}p1"

# Create a hardened LUKS-encrypted container on the root partition
echo "$USER_PASS" | cryptsetup -q luksFormat -h sha512 -i 5000 -s 512 "/dev/${DISK}p2"
echo "$USER_PASS" | cryptsetup open "/dev/${DISK}p2" cryptroot

# Format the container with Btrfs
mkfs.btrfs -f /dev/mapper/cryptroot

# Create subvolumes
mount /dev/mapper/cryptroot /mnt
btrfs su cr /mnt/@
btrfs su cr /mnt/@home
btrfs su cr /mnt/@var_log
btrfs su cr /mnt/@var_cache

# Disable CoW where it can hurt performance
chattr +C /mnt/@var_log
chattr +C /mnt/@var_cache
umount /mnt

# Mount the partitions/subvolumes
mount -o defaults,compress-force=zstd,noatime,subvol=@ /dev/mapper/cryptroot /mnt
mkdir -p /mnt/{boot,home,var/log,var/cache}
mount -o defaults,noatime,nodev,nosuid,noexec,umask=0077 "/dev/${DISK}p1" /mnt/boot
mount -o defaults,compress-force=zstd,noatime,nodev,nosuid,subvol=@home /dev/mapper/cryptroot /mnt/home
mount -o defaults,compress-force=zstd,noatime,nodev,nosuid,noexec,subvol=@var_log /dev/mapper/cryptroot /mnt/var/log
mount -o defaults,compress-force=zstd,noatime,nodev,nosuid,noexec,subvol=@var_cache /dev/mapper/cryptroot /mnt/var/cache


########### BOOTSTRAPPING ##########

reflector -c US -p https -a 12 -l 20 -f 5 --sort rate --save /etc/pacman.d/mirrorlist
sed -i 's/^#\(ParallelDownloads = 5\)/\1/' /etc/pacman.conf

pacman -Sy

pacstrap /mnt base btrfs-progs intel-ucode iwd linux linux-firmware-{intel,realtek} make nvidia opendoas pipewire-pulse sbctl

# Remove pointless images as a UKI will be created later
mv /mnt/boot/vmlinuz-linux /mnt/usr/lib/modules/vmlinuz
rm -rf /mnt/boot/*


########### CONFIGURATION ##########

genfstab -U /mnt >> /mnt/etc/fstab

cp -r "$SCRIPTDIR" /mnt/.zenixarch/

sed -i 's/^#\(en_US.UTF-8 UTF-8\)/\1/' /mnt/etc/locale.gen
echo "LANG=en_US.UTF-8" > /mnt/etc/locale.conf

arch-chroot /mnt /bin/bash -e <<CHROOT
export NEXTDNS="$NEXTDNS"

locale-gen

ln -sf "/usr/share/zoneinfo/America/New_York" /etc/localtime

hwclock --systohc

passwd -l root

useradd -m user
echo "user:$USER_PASS" | chpasswd

# The .local symlink is just an experiment, I might revert it later, but for the time being I have no purpose for this folder
ln -sfn /tmp /home/user/.cache
ln -sfn /tmp /home/user/.local

mv /.zenixarch /home/user
cd /home/user/.zenixarch
rm /home/user/.bash{rc,_profile}
make all

mkinitcpio -p linux

if sbctl status | grep -q "Setup Mode:.*Enabled"; then
    sbctl create-keys
    sbctl enroll-keys --tpm-eventlog
    sbctl sign -s /boot/EFI/BOOT/BOOTX64.EFI
else
    printf "\e[33mSkipping Secure Boot as it is not in Setup Mode\e[0m"
fi
CHROOT

printf "\e[32mDone! Reboot when ready, run make or chroot into /mnt for further configuration.\e[0m"
