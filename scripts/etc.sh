#!/bin/bash

if ! [ "${EUID:-"$(id -u)"}" -eq 0 ]; then
    echo "This script needs to be run as root"
    exit 1
fi

# Epic hostname
echo zenixark > /etc/hostname

# Make the user a doas-er
printf "permit persist user\n" > /etc/doas.conf
chmod 600 /etc/doas.conf

# Unified Kernel Image (UKI) preset
#     - The UEFI will directly boot the UKI so I do not install a bootloader
#     - UKI's securitywise synergize well with Secure Boot and disk encryption to prevent initramfs tampering
#     - I also disable NVIDIA GSP Firmware in the kernel options thanks to stuttering in games
mkdir -p /{boot/EFI/BOOT,etc/mkinitcpio.d}
cat > /etc/mkinitcpio.d/linux.preset <<UKI
    ALL_config="/etc/mkinitcpio.conf"
    ALL_kver="/usr/lib/modules/vmlinuz"
    PRESETS=('default')
    default_uki="/boot/EFI/BOOT/BOOTX64.EFI"
    default_options="cryptdevice=UUID=$(blkid -s UUID -o value "$(cryptsetup status cryptroot | awk '/device:/ {print $2}')"):cryptroot root=/dev/mapper/cryptroot rw nvidia.NVreg_EnableGpuFirmware=0 nvidia.NVreg_UsePageAttributeTable=1"
UKI

# Allow iwd to connect to the internet
mkdir -p /etc/iwd
cat > /etc/iwd/main.conf <<IWD
    [General]
    EnableNetworkConfiguration=true
IWD

# Set getty to autologin the user for convenience
mkdir -p /etc/systemd/system/getty@tty1.service.d
cat > /etc/systemd/system/getty@tty1.service.d/override.conf <<'GETTY'
    [Service]
    ExecStart=
    ExecStart=-/sbin/agetty -o '-- \\u' --autologin user --noreset --noclear - $TERM
GETTY

# PAM no-password login because there's little security loss for extra convenience
sed -i '/pam_nologin.so/i auth       sufficient   pam_succeed_if.so user = user' /etc/pam.d/login

# Colored pacman output
sed -i 's/^#\(Color\)/\1/' /etc/pacman.conf

# Add encrypt to mkinitcpio hooks
sed -i 's/^HOOKS=.*/HOOKS=(base udev autodetect microcode modconf kms keyboard keymap consolefont block encrypt filesystems fsck)/' /etc/mkinitcpio.conf

# Fix ~/.pulse-cookie bug with Steam
sed -i 's|^; cookie-file =.*|cookie-file = /home/user/.config/pulse/cookie|' /etc/pulse/client.conf

# Disable coredumps as they're HUGE and I don't care about them
sed -i 's/^#Storage=.*/Storage=none/' /etc/systemd/coredump.conf
sed -i 's/^#ProcessSizeMax=.*/ProcessSizeMax=0/' /etc/systemd/coredump.conf

# My NextDNS profile via resolved
sed -i "s|^#DNS=.*|DNS=45.90.28.0#$NEXTDNS.dns.nextdns.io DNS=45.90.30.0#$NEXTDNS.dns.nextdns.io DNS=2a07:a8c0::#$NEXTDNS.dns.nextdns.io DNS=2a07:a8c1::#$NEXTDNS.dns.nextdns.io|" /etc/systemd/resolved.conf
sed -i 's/^#FallbackDNS=.*/FallbackDNS=/' /etc/systemd/resolved.conf
sed -i 's/^#Domains=.*/Domains=~/' /etc/systemd/resolved.conf
sed -i 's/^#DNSOverTLS=.*/DNSOverTLS=yes/' /etc/systemd/resolved.conf
