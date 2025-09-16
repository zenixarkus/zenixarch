# Zenixark's Arch Linux Setup
**My entire minimalist Arch system reproducible featuring Btrfs/LUKS, UKI + Secure Boot, firewall rules, DNS, WireGuard, firefox user.js, dotfiles, overclocks, and MUCH more**

> [!WARNING]
> This is a REALLY ***REALLY*** opinionated setup that assumes my hardware and philosophy.  
> It's *not* intended to be reused by others, but if you do then I would very much recommend changing almost everything.

This repo contains every tweak I have made to Arch Linux, mostly focused on privacy, security, and minimalism.

I liked the idea of declarative/idempotent systems such as NixOS and Ansible, so I thought to myself: why not make my Arch installation reproducible too?

## Installation
[**`zarchinstall`**](./zarchinstall) will skip a full install if it doesn't detect the live Arch ISO environment, but boot related /etc files assumes things configured in the full installation.
1. `git clone https://github.com/zenixarkus/zenixarch.git ~/.zenixarch`
2. `cd ~/.zenixarch`
3. `NEXTDNS=<nextdns id> ./zarchinstall`

## Full installation
First ensure that Setup Mode for Secure Boot is on, then from the Arch ISO live environment:
1. `iwctl --passphrase <wifi password> station <wifi interface> connect <wifi name>`
2. `git clone https://github.com/zenixarkus/zenixarch.git`
3. `cd zenixarch`
4. `DISK=<e.g sda or nvme0n> USER_PASS=<a strong password> NEXTDNS=<nextdns id> ./zarchinstall`
5. `reboot now`
