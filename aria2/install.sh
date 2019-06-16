#!/bin/bash

# change version number in RuneAudio_Addons/srv/http/addonslist.php

alias=aria

. /srv/http/addonstitle.sh
. /srv/http/addonsedit.sh

installstart $@

rankmirrors

getuninstall

echo -e "$bar Aria2 package ..."

pacman -S --noconfirm aria2

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

# modify file
file=/etc/nginx/nginx.conf
echo $file

if ! grep -q '^#.*\s*rewrite' $file; then
	commentS '^\s*rewrite'
	string=$( cat <<'EOF'
            rewrite /css/(.*) /assets/css/$1 break;
            rewrite /fonts/(.*) /assets/fonts/$1 break;
            rewrite /img/(.*) /assets/img/$1 break;
            rewrite /js/(.*) /assets/js/$1 break;
            rewrite /less/(.*) /assets/less/$1 break;
EOF
)
	appendS -n +7 'listen 80 '
fi

string=$( cat <<EOF
        location /aria2 {
            root /var/www;
        }
EOF
)
appendS -n +10 'listen 80 '

systemctl reload nginx

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

[[ $1 == 1 ]] || [[ $( redis-cli get ariastartup ) ]] && systemctl enable aria2
redis-cli del ariastartup &> /dev/null

echo -e "$bar Start $title ..."
if ! systemctl start aria2 &> /dev/null; then
	title -l = "$warn $title install failed."
	exit
fi

installfinish $@

echo "Run: systemctl < start / stop > aria2"
echo "Startup: systemctl < enable / disable > aria2"
echo
echo "Download directory: $path"
title -nt "WebUI: < RuneAudio_IP >/aria2"
