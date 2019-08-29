#!/bin/bash

rm $0

. /srv/http/addonstitle.sh

title -l '=' "$bar Rune0.5+RuneUIe Reset ..."
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

redis-cli save
redis-cli bgsave
cp /srv/http/assets/img/redis/* /var/lib/redis
sed -i -e '\|^dir /srv/http/assets/img/redis/| s|^|#|' -e '\|^#dir /var/lib/redis/| s|^#||' /etc/redis.conf
#--------------------------------------------------------
echo -e "\n$bar Clear packages cache ..."

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
wgetnc https://github.com/archlinuxarm/PKGBUILDs/raw/master/core/pacman-mirrorlist/mirrorlist -P /etc/pacman.d
#--------------------------------------------------------
echo -e "\n$bar Startup setup script ..."

wgetnc https://github.com/rern/RuneAudio/raw/master/RuneAudio%2BRuneUIe.img/runonce.sh -P /root
chmod +x /root/runonce.sh

cat << 'EOF' > /etc/systemd/system/runonce.service
[Unit]
After=udevil.service

[Service]
Type=idle
ExecStart=/root/runonce.sh

[Install]
WantedBy=multi-user.target
EOF

systemctl enable runonce

curl --silent -s -X POST 'http://localhost/pub?id=reload' -d 1
#--------------------------------------------------------
title "$bar Rune0.5+RuneUIe Reset successfully."
title -nt "$info Close Addons and reboot for initial setup."
