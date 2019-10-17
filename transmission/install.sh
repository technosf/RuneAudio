#!/bin/bash

# $1-password

# change version number in RuneAudio_Addons/srv/http/addonslist.php

alias=tran

[[ -e /srv/http/addons-functions.sh ]] && . /srv/http/addons-functions.sh || . /srv/http/addonsfunctions.sh

installstart $@

getuninstall

[[ ! -e /usr/bin/transmission-cli ]] && pacman -Sy --noconfirm transmission-cli

mnt=$( mount | grep /dev/sda1 | cut -d' ' -f3 )
path="$mnt/transmission"
if [[ ! -e "$path" ]]; then
	mkdir -p "$path"
	mkdir -p "$path/{incomplete,watch}"
fi
# custom systemd unit
systemctl disable --now transmission

# custom user and env - TRANSMISSION_HOME must be /<path>/transmission-daemon
dir=/etc/systemd/system/transmission.service.d
mkdir -p $dir
echo "[Service]
User=root
Environment=TRANSMISSION_HOME=$path
" > $dir/override.conf
systemctl daemon-reload

file="$path/settings.json"
if [[ ! -e "$file" ]]; then
	# create new settings.json
	systemctl start transmission
	systemctl stop transmission
	
	sed -i -e 's|\("download-dir": "\).*|\1'"$path"'",|
	' -e 's|\("incomplete-dir": "\).*|\1'"$path"'/incomplete",|
	' -e 's|\("incomplete-dir-enabled": \).*|\1true,|
	' -e 's|\("rpc-whitelist-enabled": \).*|\1false,|
	' -e '/[^{},\{, \}]$/ s/$/, /
	' -e '/^}$/ i\
	"watch-dir": "'"$path"'/watch", \
	"watch-dir-enabled": true,
	' $file
	# set password
	if [[ -n $1 && $1 != 0 ]]; then
		sed -i -e 's|\("rpc-authentication-required": \).*|\1true,|
		' -e 's|\("rpc-password": "\).*|\1'"$1"'",|
		' -e 's|\("rpc-username": "\).*|\1root",|
		' $file
	else
		sed -i 's|\("rpc-authentication-required": \).*|\1false,|' $file
	fi
else
	if [[ -n $1 && $1 != 0 ]]; then
		sed -i 's|\("rpc-password": "\).*|\1'"$1"'",|' $file
	else
		sed -i 's|\("rpc-authentication-required": \).*|\1false,|' $file
	fi
fi

# web ui alternative
echo -e "$bar Get WebUI alternative ..."
wgetnc https://github.com/ronggang/transmission-web-control/archive/master.zip

dirweb=/usr/share/transmission/web
mv $dirweb/index{,.original}.html
bsdtar --strip 2 --exclude '.*' --exclude '*.md' -C $dirweb -xf master.zip transmission-web-control-master/src
rm master.zip
chown -R root:root $dirweb

echo -e "$bar Start Transmission ..."
if ! systemctl enable --now transmission &> /dev/null; then
	title -l = "$warn Transmission install failed."
	exit
fi

installfinish $@

echo "Download directory: $path"
title -nt "User: root"
