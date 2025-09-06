# Zenixark's Arch Linux Dotfiles
**My very minimalist (pretty much stock) dotfiles + some helper scripts and services**

> [NOTE]
> I don't offer an install script for my dotfiles as I (and probably you too) don't consider them interesting enough to justify one.  
> I prefer using this repo as a backup and set them up with my `zarchinstall` script once per installation instead.

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

## Repo Contents
<pre>
[user@zenixark ~]$ tree
~
└── .dotfiles
    ├── bash
    │   ├── bash_profile      # All it does is autostart Hyprland 
    │   └── bashrc            # Various QOL aliases & functions especially for file management
    ├── bin
    │   └── leftovers         # Scans common junk dirs and outputs files not in custom filters
    ├── firefox
    │   ├── chrome            # <a href="https://github.com/rafaelmardojai/firefox-gnome-theme">firefox-gnome-theme</a>
    │   ├── installs.ini
    │   ├── profiles.ini
    │   └── user-overrides.js # Extra hardening & personal touches appended to the <a href="https://github.com/arkenfox/user.js">arkenfox user.js</a>
    ├── git
    │   └── gitconfig
    ├── hypr
    │   ├── hyprland.conf     # Stock minus a few aesthetic changes and binding apps to number keys
    │   ├── hyprpaper.conf
    │   ├── sigiluw.png
    │   └── sigilw.png
    ├── nvim
    │   └── init.lua
    └── systemd
        └── custom.service    # Sets GPU overclocks and static RGB colors (I have to) on startup
[user@zenixark ~]$ doas pacman -Rcns tree
</pre>

## Software Preferences
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
iwd
keepassxc                     # Password Manager
linux
linux-firmware-intel
linux-firmware-realtek
mullvad-vpn-cli
neovim                        # Text Editor
nvidia
opendoas
openrgb                       # See my <a href="./systemd/custom.service">custom.service<a>
pipewire-pulse
sbctl
signal-desktop                # Messenger
[user@zenixark ~]$ doas pacman -Rcns pacm^C
</pre>
