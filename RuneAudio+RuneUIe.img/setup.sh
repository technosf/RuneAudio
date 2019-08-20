#!/bin/bash

rm $0

. /srv/http/addonstitle.sh

title -l '=' "$bar Rune0.5+RuneUIe Reset ..."

echo -e "\n$bar Delete unnecessary files ..."
rm -f /etc/netctl/test
rm -f /srv/http/assets/css/*.old
rm -f /srv/http/assets/js/*.orig
rm -rf /srv/http/assets/less

echo -e "\n$bar Reset MPD settings ..."
for opt in repeat random single consume; do
	mpc $opt 0 &> /dev/null
done
mpc volume 50 &> /dev/null
mpc clear
redis-cli del mpddb &> /dev/null

echo -e "\n$bar Reset database ..."
systemctl stop mpd
redis-cli save
cp /srv/http/assets/img/redis/* /var/lib/redis

echo -e "\n$bar Unlink extra directories ..."
rm -rf /srv/http/assets/img/{bookmarks,coverarts,lyrics,mpd,playlists,redis,tmp,webradiopl,webradios}

echo -e "\n$bar Clear packages cache ..."
rm -f /var/cache/pacman/pkg/*
rm -rf /srv/http/.cache/chromium/Default/*

echo -e "\n$bar Clear mountpoints ..."
mountnas=$( ls -d /mnt/MPD/NAS/*/ 2> \dev/null )
mountusb=$( ls -d /mnt/MPD/USB/*/ 2> \dev/null )
readarray -t mountpoints <<<"$mountnas $mountusb"
for mountpoint in "${mountpoints[@]}"; do
	umount -l "$mountpoint"
	rmdir "$mountpoint" &> /dev/null
done

echo -e "\n$bar Reset mirrorlist ..."
rm /etc/pacman.d/*
wgetnc https://github.com/archlinuxarm/PKGBUILDs/raw/master/core/pacman-mirrorlist/mirrorlist -P /etc/pacman.d

echo -e "\n$bar Startup setup script ..."
wgetnc https://github.com/rern/RuneAudio/raw/master/RuneAudio%2BRuneUIe.img/runonce.sh -P /root
chmod +x /root/runonce.sh

cat << 'EOF' > /etc/systemd/system/runonce.service
[Unit]
After=udevil.service

[Service]
Type=idle
ExecStartPre=/bin/sleep 5
ExecStart=/root/runonce.sh

[Install]
WantedBy=multi-user.target
EOF

systemctl enable runonce
systemctl disable enhancestartup

curl --silent -s -X POST 'http://localhost/pub?id=reload' -d 1

title "$bar Rune0.5+RuneUIe Reset successfully."
title -nt "$info Close Addons and reboot for initial setup."
