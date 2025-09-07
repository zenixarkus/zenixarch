# Zenixark's Arch Linux Setup
**My very personalized and hardened Arch Linux dotfiles + an automated install script that sets up Btrfs, FDE, direct-boot UKI + Secure Boot, DNS, VPN, autologin, dots and more**

## Using [`zarchinstall`](./zarchinstall)
> [WARNING]
> **This is a REALLY *REALLY* opinionated script that assumes my hardware and philosophy.**  
> **It's not intended to be reused by others, but if you do then I would very much recommend changing almost everything.**

This script essentially rolls out my entire setup in a one liner, it does a lot so I recommend reading my comments in the script as I explain many of my choices there. I don't offer a dedicated install script for my dotfiles as I (and probably you too) don't consider them interesting enough to justify one.

First ensure that Setup Mode for Secure Boot is on, then from the Arch ISO live environment:
1. `iwctl --passphrase <wifi password> station <wifi interface> connect <wifi name>`
2. `git clone https://zenixark.com/zenixark/zarchsetup.git`
3. `cd zarchsetup`
4. `./zarchinstall -d <disk, like nvme0np1> -p <a strong password> -n <nextdns id>`

## Dotfiles
- **bash**
  - [`bash_profile`](./bash/bash_profile) -- All it does is autostart hyprland
  - [`bashrc`](./bash/bashrc) -- Various QOL aliases & functions especially for file management
- **bin**
  - [`leftovers`](./bin/leftovers) -- Scans common junk dirs and outputs files not in my custom filters
- **firefox**
  - [`chrome`](./firefox/chrome) -- [firefox-gnome-theme](https://github.com/rafaelmardojai/firefox-gnome-theme)
  - [`installs.ini`](./firefox/installs.ini)
  - [`profiles.ini`](./firefox/profiles.ini)
  - [`user-overrides.js`](./firefox/user-overrides.js) -- Extra hardening & personal touches appended to [arkenfox user.js](https://github.com/arkenfox/user.js)
- **git**
  - [`gitconfig`](./git/gitconfig)
- **hypr**
  - [`hyprland.conf`](./hypr/hyprland.conf) -- Stock minus a few aesthetic changes and binding apps to number keys
  - [`hyprpaper.conf`](./hypr/hyprpaper.conf)
  - [`sigiluw.png`](./hypr/sigiluw.png)
  - [`sigilw.png`](./hypr/sigilw.png)
- **nvim**
  - [`init.lua`](./nvim/init.lua)
- **systemd**
  - [`custom.service`](./systemd/custom.service) -- Sets GPU overclocks and static RGB colors (I have to) on startup


## Software and Hardware
<pre>
[user@zenixark ~]$ fastfetch
                  -`                     user@zenixark
                 .o+`                    -------------
                `ooo/                    OS: Arch Linux x86_64
               `+oooo:                   Host: Z790 AORUS ELITE AX DDR4
              `+oooooo:                  Kernel: Linux 6.16.4-arch1-1
              -+oooooo+:                 Uptime: 24 seconds
            `/:-:++oooo+:                Packages: 438 (pacman)
           `/++++/+++++++:               Shell: bash 5.3.3
          `/++++++++++++++:              Display (M34WQ): 3440x1440 @ 144 Hz in 34"
         `/+++ooooooooooooo/`            Display (LG ULTRAGEAR): 1920x1080 @ 144 Hz in 24"
        ./ooosssso++osssssso+`           WM: Hyprland 0.50.1 (Wayland)
       .oossssso-````/ossssss+`          Cursor: Adwaita
      -osssssso.      :ssssssso.         Terminal: foot 1.23.1
     :osssssss/        osssso+++.        Terminal Font: monospace (8pt)
    /ossssssss/        +ssssooo/-        CPU: 13th Gen Intel(R) Core(TM) i7-13700K (24) @ 5.80 GHz
  `/ossssso+/:-        -:/+osssso+-      GPU 1: NVIDIA GeForce RTX 4070
 `+sso+:-`                 `.-/+oso:     GPU 2: Intel UHD Graphics 770 @ 1.60 GHz
`++:.                           `-/+/    Memory: 1.45 GiB / 31.11 GiB (5%)
.`                                 `/    Disk (/): 2.29 GiB / 930.50 GiB (0%) - btrfs
[user@zenixark ~]$ doas pacman -Rcns fastfetch
</pre>
I generally prefer to avoid proprietary and GUI nonsense whenever possible in favor of FOSS and CLI stuff respectively.
<pre>
[user@zenixark ~]$ pacman -Qqe
base
btrfs-progs
firefox                       # Browser
foot                          # Terminal
git
hyprland                      # Window Manager
hyprpaper                     # Wallpaper
hyprshot                      # Screenshots
intel-ucode
iwd                           # Wi-Fi
keepassxc                     # Password Manager
linux
linux-firmware-intel
linux-firmware-realtek
mullvad-vpn-cli
neovim                        # Text Editor
nvidia
opendoas                      # Instead of sudo
openrgb                       # See my <a href="./systemd/custom.service">custom.service<a>
pipewire-pulse
sbctl
signal-desktop                # Messenger
[user@zenixark ~]$ doas pacman -Rcns pacm^C
</pre>
