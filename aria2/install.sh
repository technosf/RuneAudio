#!/bin/bash

# change version number in RuneAudio_Addons/srv/http/addonslist.php

alias=aria

. /srv/http/addonstitle.sh
. /srv/http/addonsedit.sh

installstart $@

rankmirrors

getuninstall

echo -e "$bar Aria2 package ..."

pacman -S --noconfirm --needed aria2

if mount | grep -q '/dev/sda1'; then
	mnt=$( mount | grep '/dev/sda1' | cut -d' ' -f3 )
	path=$mnt/aria2
else
	path=/root/aria2
fi
mkdir -p $path

echo -e "$bar WebUI ..."
wgetnc https://github.com/ziahamza/webui-aria2/archive/master.zip
bsdtar -xf master.zip --strip 2 -C $path ./webui-aria2-master/docs
rm master.zip

ln -s $path /srv/http
# disable UI language feature
sed -i '/determinePreferredLanguage/ s|^|//|' /srv/http/aria2/app.js

mkdir -p /root/.config/aria2

file=/root/.config/aria2/aria2.conf
echo $file

cat << EOF > $file
enable-rpc=true
rpc-listen-all=true
daemon=true
disable-ipv6=true
dir=$path
max-connection-per-server=4
EOF

file=/etc/systemd/system/aria2.service
echo $file

cat << 'EOF' > $file
[Unit]
Description=Aria2
After=network-online.target
[Service]
Type=forking
ExecStart=/usr/bin/aria2c
[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload

echo -e "$bar Start $title ..."
if ! systemctl enable --now aria2 &> /dev/null; then
	title -l = "$warn $title install failed."
	exit
fi

file=/srv/http/indexbody.php
echo $file
string=$( cat <<'EOF'
	<a id="aria2">
		<img src="/assets/img/addons/thumbaria.png" style="filter: brightness(1.3)">Aria2
		<i class="fa fa-gear submenu settings"></i>
	</a>
EOF
)
insertH displaylibrary

installfinish $@

title -nt "Download directory: $path"
