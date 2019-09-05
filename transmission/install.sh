#!/bin/bash

# $1-password; $2-webui alternative; $3-startup

# change version number in RuneAudio_Addons/srv/http/addonslist.php

alias=tran

. /srv/http/addonstitle.sh
. /srv/http/addonsedit.sh

installstart $@

rankmirrors

getuninstall

pacman -S --needed --noconfirm libevent transmission-cli

# remove conf for non-exist user 'transmission'
rm /usr/lib/tmpfiles.d/transmission.conf

if mount | grep -q '/dev/sda1'; then
	mnt=$( mount | grep '/dev/sda1' | cut -d' ' -f3 )
	mkdir -p $mnt/transmission
	path=$mnt/transmission
else
	mkdir -p /root/transmission
	path=/root/transmission
fi
mkdir -p $path/{incomplete,watch}

# custom systemd unit
systemctl disable --now transmission

# custom user and env - TRANSMISSION_HOME must be /<path>/transmission-daemon
dir=/etc/systemd/system/transmission.service.d
mkdir -p $dir
echo "[Service]
User=root
Environment=TRANSMISSION_HOME=$path
Environment=TRANSMISSION_WEB_HOME=$path/web
" > $dir/override.conf
systemctl daemon-reload

file=$path/settings.json
rm -f $file
# create settings.json
systemctl start transmission
systemctl stop transmission

sed -i -e 's|"download-dir": ".*"|"download-dir": "'"$path"'"|
' -e 's|"incomplete-dir": ".*"|"incomplete-dir": "'"$path"'/incomplete"|
' -e 's|"incomplete-dir-enabled": false|"incomplete-dir-enabled": true|
' -e 's|"rpc-whitelist-enabled": true|"rpc-whitelist-enabled": false|
' -e '/[^{},\{, \}]$/ s/$/, /
' -e '/^}$/ i\
"watch-dir": "'"$path"'/watch", \
"watch-dir-enabled": true
' $file
# set password
if [[ -n $1 && $1 != 0 ]]; then
	sed -i -e 's|"rpc-authentication-required": false|"rpc-authentication-required": true|
	' -e 's|"rpc-password": ".*"|"rpc-password": "'"$1"'"|
	' -e 's|"rpc-username": ".*"|"rpc-username": "root"|
	' $file
else
	sed -i 's|"rpc-authentication-required": true|"rpc-authentication-required": false|
	' $file
fi

# web ui alternative
echo -e "$bar Get WebUI alternative ..."
wgetnc https://github.com/ronggang/transmission-web-control/archive/master.zip
rm -rf $path/web
mv /usr/share/transmission/web $path
mv $path/web/index{,.original}.html
bsdtar --strip 2 --exclude '.*' --exclude '*.md' -C $path/web -xf master.zip transmission-web-control-master/src
rm master.zip
chown -R root:root $path/web

echo -e "$bar Start Transmission ..."
if ! systemctl enable --now transmission &> /dev/null; then
	title -l = "$warn Transmission install failed."
	exit
fi

file=/srv/http/indexbody.php
echo $file
string=$( cat <<'EOF'
	<a id="transmission">
		<img src="/assets/img/addons/thumbtran.png">Transmission
		<i class="fa fa-gear submenu settings"></i>
	</a>
EOF
)
insertH displaylibrary

installfinish $@

echo "Download directory: $path"
title -nt "User: root"
