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
file=shairport-sync-3.3.1-1-armv7h.pkg.tar.xz
wget -qN https://github.com/rern/RuneAudio/raw/master/shairport-sync/$file
pacman -U $file
rm $file

# systemd unit file
cat << 'EOF' > /lib/systemd/system/shairport-meta.service
[Unit]
Description=Shairport Sync Metadata 
After=network.target redis.target shairport-sync.service

[Service]
ExecStart=/srv/http/shairportmeta.php

[Install]
WantedBy=multi-user.target

echo 'shairport-sync ALL=NOPASSWD: ALL' > /etc/sudoers.d/shairport-sync

file=/srv/http/assets/img/airplaycoverart
touch $file
chown shairport-sync:shairport-sync $file

# config ( output_device = "hw:N" - aplay -l | grep "^card" )
file=/etc/shairport-sync.conf
mv $file{,.backup}
cat << 'EOF' > $file
sessioncontrol = {
	run_this_before_play_begins = "/srv/http/shairportstartstop.sh &";
	run_this_after_play_ends = "/srv/http/shairportstartstop.sh stop &";
}
alsa = {
	output_device = "hw:0";
}
EOF
#---------------------------------------------------------------
$file=/srv/http/command/rune_SY_wrk
echo $file

comment 'systemctl start rune_SSM_wrk' -n +1 'systemctl stop rune_SSM_wrk'

string=$( cat <<'EOF'
						sysCmd('systemctl start shairport-meta');
					} else if ($job->action == 'stop') {
						sysCmd('systemctl stop shairport-meta');
					}
EOF
)
insert 'systemctl start rune_SSM_wrk'

systemctl daemon-reload
[[ $active ]] && systemctl restart shairport-sync

title "$bar Shairport Sync upgraded successfully."
