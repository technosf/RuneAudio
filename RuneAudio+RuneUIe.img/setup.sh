#!/bin/bash

. /srv/http/addonstitle.sh

title -l '=' "$bar Setup SD card for image file ..."

echo -e "\n$bar Remove special directories ..."
rm -rf /srv/http/assets/img/{bookmarks,coverarts,lyrics,playlists,tmp,webradiopl,webradios}

echo -e "\n$bar Reset MPD playback options ..."
mpc volume 50; mpc repeat 0; mpc random 0; mpc single 0; mpc consume 0

echo -e "\n$bar Reset MPD database ..."
rm -f /var/lib/mpd/mpd.db /var/lib/mpd/playlists/*
umount /dev/sda1
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
