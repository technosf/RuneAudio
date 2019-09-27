#!/bin/bash

alias=aria

. /srv/http/addonsfunctions.sh
. /srv/http/addonsedit.sh

uninstallstart $@

systemctl disable --now aria2
rm -v /etc/systemd/system/aria2.service
systemctl daemon-reload

# restore file
echo -e "$bar Restore files ..."
restorefile /srv/http/indexbody.php /srv/http/assets/js/main.js

# remove files #######################################
echo -e "$bar Remove files ..."

rm -r "$( readlink -f /srv/http/aria2 )/web"
rm -r /root/.config/aria2 /srv/http/aria2

uninstallfinish $@
