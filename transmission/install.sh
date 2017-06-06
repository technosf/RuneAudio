#!/bin/bash

rm install.sh

line2='\e[0;36m=========================================================\e[m'
line='\e[0;36m---------------------------------------------------------\e[m'
bar=$( echo -e "$(tput setab 6)   $(tput setab 0)" )
info=$( echo $(tput setab 6; tput setaf 0) i $(tput setab 0; tput setaf 7) )

title2() {
	echo -e "\n$line2\n"
	echo -e "$bar $1"
	echo -e "\n$line2\n"
}
title() {
	echo -e "\n$line"
	echo $1
	echo -e "$line\n"
}
titleend() {
	echo -e "\n$1"
	echo -e "\n$line\n"
}

if ! grep -qs '/mnt/MPD/USB/hdd' /proc/mounts; then
	titleend "$info Hard drive not mount at /mnt/MPD/USB/hdd"
	exit
fi
wget -qN --show-progress https://github.com/rern/RuneAudio/raw/master/transmission/uninstall_tran.sh
chmod +x uninstall_tran.sh
wget -qN --show-progress https://github.com/rern/RuneAudio/raw/master/transmission/_repo/transmission/transmission-cli-2.92-6-armv7h.pkg.tar.xz

if ! pacman -Q transmission-cli &>/dev/null; then
	title2 "Install Transmission ..."
	pacman -U --noconfirm transmission-cli-2.92-6-armv7h.pkg.tar.xz
else
	titleend "$info Transmission already installed."
	exit
fi
rm transmission-cli-2.92-6-armv7h.pkg.tar.xz

if [[ ! -e /mnt/MPD/USB/hdd/transmission ]]; then
	mkdir /mnt/MPD/USB/hdd/transmission
	mkdir /mnt/MPD/USB/hdd/transmission/incomplete
	mkdir /mnt/MPD/USB/hdd/transmission/torrents
	chown -R transmission:transmission /mnt/MPD/USB/hdd/transmission
fi

# change user to 'root'
cp /lib/systemd/system/transmission.service /etc/systemd/system/transmission.service
sed -i 's|User=transmission|User=root|' /etc/systemd/system/transmission.service
# refresh systemd services
systemctl daemon-reload
# create settings.json
transmission-daemon
killall transmission-daemon
sleep 1
file='/root/.config/transmission-daemon/settings.json'
sed -i -e 's|"download-dir": ".*"|"download-dir": "/mnt/MPD/USB/hdd/transmission"|
' -e 's|"incomplete-dir": ".*"|"incomplete-dir": "/mnt/MPD/USB/hdd/transmission/incomplete"|
' -e 's|"incomplete-dir-enabled": false|"incomplete-dir-enabled": true|
' -e 's|"rpc-whitelist-enabled": true|"rpc-whitelist-enabled": false|
' -e '/[^{},]$/ s/$/\,/
' -e '/}/ i\
    "watch-dir": "/mnt/MPD/USB/hdd/transmission/torrents",\
    "watch-dir-enabled": true
' $file

title "$info Set password:"
echo -e '  \e[0;36m0\e[m No'
echo -e '  \e[0;36m1\e[m Yes'
echo
echo -e '\e[0;36m0\e[m / 1 ? '
read -n 1 answer
case $answer in
	1 ) echo
		echo 'Password: '
		read -s pwd
		sed -i -e 's|"rpc-authentication-required": false|"rpc-authentication-required": true|
		' -e "s|\"rpc-password\": \".*\"|\"rpc-password\": \"$pwd\"|
		" -e "s|\"rpc-username\": \".*\"|\"rpc-username\": \"root\"|
		" $file
		;;
	* ) echo;;
esac
# web ui alternative
title "$info Install WebUI alternative (Transmission Web Control):"
echo -e '  \e[0;36m0\e[m No'
echo -e '  \e[0;36m1\e[m Yes'
echo
echo -e '\e[0;36m0\e[m / 1 ? '
read -n 1 answer
case $answer in
	1 ) echo
		wget -qN --show-progress https://github.com/ronggang/transmission-web-control/raw/master/release/transmission-control-full.tar.gz
		mv /usr/share/transmission/web/index.html /usr/share/transmission/web/index.original.html
		bsdtar -xf transmission-control-full.tar.gz -C /usr/share/transmission
		chown -R root:root /usr/share/transmission/web
		;;
	* ) echo;;
esac

title "$info Start Transmission on system startup:"
echo -e '  \e[0;36m0\e[m No'
echo -e '  \e[0;36m1\e[m Yes'
echo
echo -e '\e[0;36m0\e[m / 1 ? '
read -n 1 answer
case $answer in
	1 ) systemctl enable transmission;;
	* ) echo;;
esac

title "$info Start Transmission now:"
echo -e '  \e[0;36m0\e[m No'
echo -e '  \e[0;36m1\e[m Yes'
echo
echo -e '\e[0;36m0\e[m / 1 ? '
read -n 1 answer
case $answer in
	1 ) systemctl start transmission;;
	* ) echo;;
esac

title2 "Transmission installed successfully."
echo 'Uninstall: ./uninstall_tran.sh'
echo 'Start: systemctl start transmission'
echo 'Stop:  systemctl stop transmission'
echo 'Download directory: /mnt/MPD/USB/hdd/transmission'
echo 'WebUI: [RuneAudio_IP]:9091'
titleend "user: root"
