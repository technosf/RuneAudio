#!/bin/bash

alias=tran

. /srv/http/addonstitle.sh
. /srv/http/addonsedit.sh

uninstallstart $@

systemctl disable transmission

# restore file
echo -e "$bar Restore files ..."
restorefile /srv/http/indexbody.php /srv/http/assets/js/main.js

# remove files #######################################
echo -e "$bar Remove files ..."

rm -rv /etc/systemd/system/transmission.service.d
rm -v /lib/systemd/system/tran.service
rm -r $path/web

uninstallfinish $@
