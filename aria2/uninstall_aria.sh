#!/bin/bash

alias=aria

. /srv/http/addons-functions.sh &> /dev/null

uninstallstart $@

systemctl disable --now aria2
rm -v /etc/systemd/system/aria2.service
systemctl daemon-reload

# remove files #######################################
echo -e "$bar Remove files ..."

rm -r "$( readlink -f /srv/http/aria2 )"
rm -r /root/.config/aria2 /srv/http/aria2

uninstallfinish $@
