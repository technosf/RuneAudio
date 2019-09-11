#!/bin/bash

alias=aria

. /srv/http/addonstitle.sh
. /srv/http/addonsedit.sh

uninstallstart $@

systemctl disable aria2

if mount | grep -q '/dev/sda1'; then
	mnt=$( mount | grep '/dev/sda1' | awk '{ print $3 }' )
else
	mnt=/root
fi

systemctl disable aria2
systemctl stop aria2
rm -v /etc/systemd/system/aria2.service
systemctl daemon-reload

# restore file
echo -e "$bar Restore files ..."
restorefile /srv/http/indexbody.php /srv/http/assets/js/main.js

# remove files #######################################
echo -e "$bar Remove files ..."

rm -r "$( readlink -f /srv/http/aria2 )/web"
rm -rv /root/.config/aria2 /srv/http/aria2

uninstallfinish $@
