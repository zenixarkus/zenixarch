#!/bin/bash

if ! [ "${EUID:-"$(id -u)"}" -eq 0 ]; then
    echo "This script needs to be run as root"
    exit 1
fi

NOW="--now"
[ -d /mnt/home/user ] && NOW=""

systemctl link systemd/*

systemctl enable fstrim.timer btrfs-scrub@-.timer

while read -r svc; do
    [[ -n "$svc" ]] || continue
    systemctl enable $NOW "$svc"
done < services.txt

for svc in $(systemctl list-unit-files --type=service --state=enabled --no-legend | awk '{print $1}'); do
    if ! grep -qx "$svc" services.txt; then
        systemctl disable $NOW "$svc"
    fi
done
