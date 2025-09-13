# Zenixark's Arch Linux Setup
**My very personalized and hardened Arch Linux dotfiles + an automated install script that sets up Btrfs, FDE, direct-boot UKI + Secure Boot, DNS, VPN, autologin, dots and more**

## Using [`zarchinstall`](./zarchinstall)
> [!WARNING]
> **This is a REALLY *REALLY* opinionated script that assumes my hardware and philosophy.**  
> **It's not intended to be reused by others, but if you do then I would very much recommend changing almost everything.**

This script essentially rolls out my entire setup in a one liner, it does a lot so I recommend reading my comments in the script as I explain many of my choices there. I don't offer a dedicated install script for my dotfiles as I (and probably you too) don't consider them interesting enough to justify one.

First ensure that Setup Mode for Secure Boot is on, then from the Arch ISO live environment:
1. `iwctl --passphrase <wifi password> station <wifi interface> connect <wifi name>`
2. `git clone https://github.com/zenixarkus/zenixarch.git`
3. `cd zenixarch`
4. `./zarchinstall -d <disk, like nvme0n1> -p <a strong password> -n <nextdns id>`
