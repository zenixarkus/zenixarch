SHELL := /bin/bash
.PHONY: *

all: system user

install:
	scripts/install.sh

system: packages etc services

packages:
	pacman -Syu --needed - < packages.txt

etc:
	scripts/etc.sh

services:
	scripts/systemd.sh

user: dotfiles userjs

dotfiles:
	stow -R -t /home/user dotfiles

userjs:
	scripts/userjs.sh
