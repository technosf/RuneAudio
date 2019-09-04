#!/bin/bash

rm $0

. /srv/http/addonstitle.sh

name='RuneAudio+R e1'

title -l '=' "$bar $name Reset ..."

#--------------------------------------------------------
if journalctl -b | grep -q '(mmcblk0p1): Volume was not properly unmounted'; then
	echo -e "\n$bar Fix mmcblk0 dirty bit from unproperly unmount..."
	fsck.fat -trawl /dev/mmcblk0p1 | grep -i 'dirty bit'
fi
#--------------------------------------------------------
echo -e "\n$bar Clear I2S module ..."

sed -i -e '/^dtoverlay/ d
' -e '/^dtparam=i2s=on/ s/^/#/
' /boot/config.txt
redis-cli set audiooutput 'bcm2835 ALSA_1'
#--------------------------------------------------------
echo -e "\n$bar Reset MPD settings ..."

mpc -q volume 50; mpc -q repeat 0; mpc -q random 0; mpc -q single 0; mpc -q consume 0
mpc clear
redis-cli del mpddb &> /dev/null
#--------------------------------------------------------
echo -e "\n$bar Reset Database ..."

sed -i -e '\|^dir /srv/http/assets/img/redis/| s|^|#|' -e '\|^#dir /var/lib/redis/| s|^#||' /etc/redis.conf
#--------------------------------------------------------
echo -e "\n$bar Clear Chromium and pacman cache ..."

rm -f /var/cache/pacman/pkg/*
rm -rf /srv/http/.cache/chromium/Default/*
#--------------------------------------------------------
echo -e "\n$bar Clear mountpoints ..."

mounts=( $( ls -d /mnt/MPD/NAS/*/ 2> /dev/null ) )
if (( ${#mounts[@]} > 0 )); then
	for mount in "${mounts[@]}"; do
		umount -l "$mount"
		rmdir "$mount"
		sed -i "|$mount| d" /etc/fstab
	done
fi
mounts=( $( ls -d /mnt/MPD/USB/*/ 2> /dev/null ) )
if (( ${#mounts[@]} > 0 )); then
	for mount in "${mounts[@]}"; do
		udevil umount -l "$mount"
	done
fi
#--------------------------------------------------------
echo -e "\n$bar Remove extra directories ..."

find /srv/http/assets/img/ -xtype l -delete
#--------------------------------------------------------
echo -e "\n$bar Reset mirrorlist ..."

rm /etc/pacman.d/*
wget -q https://github.com/archlinuxarm/PKGBUILDs/raw/master/core/pacman-mirrorlist/mirrorlist -P /etc/pacman.d
#--------------------------------------------------------
echo -e "\n$bar Startup setup script ..."

wget -q https://github.com/rern/RuneAudio/raw/master/RuneAudio%2BR_e1.img/runonce.sh -P /srv/http
chmod +x /srv/http/runonce.sh
#--------------------------------------------------------

title "$bar $name Reset successfully."
