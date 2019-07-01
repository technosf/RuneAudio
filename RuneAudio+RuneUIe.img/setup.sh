#!/bin/bash

. /srv/http/addonstitle.sh

title -l '=' "$bar Setup SD card for image file ..."

echo -e "$bar Remove special directories ..."
rm -rf /srv/http/assets/img/{bookmarks,coverarts,lyrics,playlists,tmp,webradiopl,webradios}

echo -e "$bar Clear packages cache ..."
rm -f /var/cache/pacman/pkg/*

echo -e "$bar Reset MPD database ..."
rm -f /var/lib/mpd/mpd.db /var/lib/mpd/playlists/*
umount /dev/sda1
mpc update

echo -e "$bar Reset mirrorlist ..."
rm /etc/pacman.d/*
wgetnc https://github.com/archlinuxarm/PKGBUILDs/raw/master/core/pacman-mirrorlist/mirrorlist -P /etc/pacman.d

echo -e "$bar Startup script ..."
wgetnc https://github.com/rern/RuneAudio/raw/master/RuneAudio%2BRuneUIe.img/runonce.sh -P /root
chmod +x /root/runonce.sh
wgetnc https://github.com/rern/RuneAudio/raw/master/RuneAudio%2BRuneUIe.img/runonce.service -P /etc/systemd/system
systemctl enable runonce

title "$bar SD card ready for read to image file."
