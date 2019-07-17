#!/bin/bash

alias=shai

. /srv/http/addonstitle.sh
. /srv/http/addonsedit.sh

installstart $@

Title -l '=' "$bar Upgrade Shairport Sync ..."

active=$( systemctl is-active shairport-sync )

systemctl stop shairport-sync

rm /etc/shairport-sync.conf \
	/usr/bin/shairport-sync \
	/usr/lib/systemd/system/shairport-sync.service

# install with compiled packaged --with-metadata
wget -qN https://github.com/rern/RuneAudio/raw/master/shairport-sync/shairportmeta.php -P /srv/http
wget -qN https://github.com/rern/RuneAudio/raw/master/shairport-sync/shairportstartstop.sh -P /srv/http
chown http:http /srv/http/shairport*
chmod 755 /srv/http/shairport*
file=shairport-sync-3.3.1-1-armv7h.pkg.tar.xz
wget -qN https://github.com/rern/RuneAudio/raw/master/shairport-sync/$file
pacman -U $file
rm $file

sed -i 's/\(^User=\).*/\1http/; s/\(^Group=\).*/\1http/' /usr/lib/systemd/system/shairport-sync.service

# metadata unit file
cat << 'EOF' > /etc/systemd/system/shairport-meta.service
[Unit]
Description=Shairport Sync Metadata 
After=network.target redis.target shairport-sync.service

[Service]
ExecStart=/srv/http/shairportmeta.php
User=http
Group=http

[Install]
WantedBy=multi-user.target
EOF

# config ( output_device = "hw:N" - aplay -l | grep "^card" )
file=/etc/shairport-sync.conf
mv $file{,.backup}
cat << 'EOF' > $file
sessioncontrol = {
	run_this_before_play_begins = "/srv/http/shairportstartstop.sh";
	run_this_after_play_ends = "/srv/http/shairportstartstop.sh stop";
}
alsa = {
	output_device = "hw:0";
}
EOF

systemctl daemon-reload
[[ $active ]] && systemctl restart shairport-sync shairport-meta

title "$bar Shairport Sync upgraded successfully."
