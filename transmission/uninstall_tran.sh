#!/bin/bash

alias=tran

. /srv/http/addonstitle.sh
. /srv/http/addonsedit.sh

uninstallstart $@

if mount | grep -q '/dev/sda1'; then
	mnt=$( mount | grep '/dev/sda1' | awk '{ print $3 }' )
	path=$mnt/transmission
else
	path=/root/transmission
fi

# restore file
echo -e "$bar Restore files ..."
restorefile /srv/http/indexbody.php /srv/http/assets/js/main.js

# remove files #######################################
echo -e "$bar Remove files ..."

rm -rv /etc/systemd/system/transmission.service.d
rm -v /lib/systemd/system/tran.service
rm -r $path/web

uninstallfinish $@
