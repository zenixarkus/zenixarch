# ⚙️ Zenixark's Arch Linux Setup
**My entire minimalist Arch system reproducible featuring Btrfs/LUKS, UKI + Secure Boot, firewall rules, DNS, WireGuard, firefox user.js, dotfiles, overclocks, and MUCH more**

> This project's home is [**zenixark.com**](https://zenixark.com/zenixark/zenixarch), but mirror(s) can be found on [**GitHub**](https://github.com/zenixarkus/zenixarch)

This repo contains every tweak I have made to Arch Linux, mostly focused on privacy, security, and minimalism. I liked the idea of declarative/idempotent systems such as NixOS and Ansible, so I thought to myself: why not make my Arch installation reproducible too?

## 🛠️ Usage
> [!WARNING]
> This is a REALLY ***REALLY*** opinionated setup that assumes my hardware and philosophy.  
> It's *not* intended to be reused by others, but if you do then I would very much recommend changing almost everything.

A full installation is *technically* optional as [**`zarchinstall`**](./zarchinstall) will skip one if it doesn't detect a live Arch ISO environment, but `configuration()` **heavily** assumes one was done, such as `/home/user` and `/etc/kernel/cmdline`. Otherwise, this repo can just be cloned to `~/.zenixarch`.

First turn on Setup Mode for Secure Boot in the UEFI, then from the live environment:
```sh
## 1. Connect to the internet
iwctl --passphrase <wifi password> station <wifi interface> connect <wifi name>

## 2. Install git
pacman -Sy git

## 3. Clone the repo
git clone https://github.com/zenixarkus/zenixarch.git
# or alternatively
git clone https://zenixark.com/zenixark/zenixarch.git

## 4. Run the installer
cd zenixarch
DISK=<e.g sda or nvme0n1> PASS=<a strong password> NEXTDNS=<nextdns id> ./zarchinstall

## 5. After rebooting, this can be run repeatedly to apply new changes idempotently
doas env NEXTDNS=<nextdns id> ./zarchinstall
```
