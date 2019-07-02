#!/bin/bash

. /srv/http/addonstitle.sh

title -l '=' "$bar Setup SD card for image file ..."

echo -e "\n$bar Remove special directories ..."
rm -rf /srv/http/assets/img/{bookmarks,coverarts,lyrics,playlists,tmp,webradiopl,webradios}

echo -e "\n$bar Reset MPD settings ..."
for opt in repeat random single consume; do
	mpc $opt 0 &> /dev/null
done
mpc volume 50
mpc clear
redis-cli set lastmpdvolume 50 &> /dev/null
redis-cli del mpddb &> /dev/null

echo -e "\n$bar Reset MPD database ..."
rm -f /var/lib/mpd/mpd.db /var/lib/mpd/playlists/*
mounts=$( cat /proc/mounts | grep '/var/' | cut -d' ' -f1 )
for dev in $mounts; do
	umount -l $dev
done
mpc update

echo -e "\n$bar Clear packages cache ..."
rm -f /var/cache/pacman/pkg/*

echo -e "\n$bar Reset mirrorlist ..."
rm /etc/pacman.d/*
wgetnc https://github.com/archlinuxarm/PKGBUILDs/raw/master/core/pacman-mirrorlist/mirrorlist -P /etc/pacman.d

echo -e "\n$bar Startup setup script ..."
wgetnc https://github.com/rern/RuneAudio/raw/master/RuneAudio%2BRuneUIe.img/runonce.sh -P /root
chmod +x /root/runonce.sh
wgetnc https://github.com/rern/RuneAudio/raw/master/RuneAudio%2BRuneUIe.img/runonce.service -P /etc/systemd/system
systemctl enable runonce

title "$bar SD card ready for read to image file."
