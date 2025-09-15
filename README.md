# Zenixark's Arch Linux Setup

## Usage
> [!WARNING]
> **This is a REALLY *REALLY* opinionated setup that assumes my hardware and philosophy.**  
> **It's not intended to be reused by others, but if you do then I would very much recommend changing almost everything.**

### Installation
[`zarchinstall`](./zarchinstall) will skip doing a full install if it detects that you're not in a live Arch ISO
1. `git clone https://github.com/zenixarkus/zenixarch.git ~/.zenixarch`
2. `cd ~/.zenixarch`
3. `NEXTDNS=<nextdns id> ./zarchinstall`

### Full installation (wipe everything and reinstall)
First ensure that Setup Mode for Secure Boot is on, then from the Arch ISO live environment:
1. `iwctl --passphrase <wifi password> station <wifi interface> connect <wifi name>`
2. `git clone https://github.com/zenixarkus/zenixarch.git`
3. `cd zenixarch`
4. `DISK=<e.g sda or nvme0n> USER_PASS=<a strong password> NEXTDNS=<nextdns id> ./zarchinstall`
5. `reboot now`
