#!/bin/bash

alias=tran

. /srv/http/addonsfunctions.sh
. /srv/http/addonsedit.sh

uninstallstart $@

systemctl disable --now transmission

# restore file
echo -e "$bar Restore files ..."
restorefile /srv/http/indexbody.php /srv/http/assets/js/main.js

# remove files #######################################
echo -e "$bar Remove files ..."

rm -rv /etc/systemd/system/transmission.service.d
dirweb=/usr/share/transmission/web
rm -r $dirweb/tr-web-control
rm -v $dirweb/{favicon.ico,index.html,index.mobile.html}
mv $dirweb/index{.original,}.html

uninstallfinish $@
