#!/bin/bash

. /srv/http/addonstitle.sh

title -l '=' "$bar Setup SD card for image file ..."

# remove special directories
rm -rf /srv/http/assets/img/{bookmarks,coverarts,lyrics,playlists,tmp,webradiopl,webradios}

# clear packages cache
rm -f /var/cache/pacman/pkg/*

# mpd database reset
rm -f /var/lib/mpd/mpd.db /var/lib/mpd/playlists/*
umount /dev/sda1
mpc update

# mirrorlist reset
rm /etc/pacman.d/*
wget https://github.com/archlinuxarm/PKGBUILDs/raw/master/core/pacman-mirrorlist/mirrorlist -P /etc/pacman.d

# run once script
wget https://github.com/rern/RuneAudio/raw/master/RuneAudio%2BRuneUIe.img/runonce.sh -P /root
chmod +x /root/runonce.sh

# systemd unit file
wget https://github.com/rern/RuneAudio/raw/master/RuneAudio%2BRuneUIe.img/runonce.service -P /etc/systemd/system
systemctl enable runonce

echo -e "$bar SD card ready for read to image file."
