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
dirweb=/usr/share/transmission/web
rm -rv $dirweb/tr-web-control $dirweb/{favicon.ico,index.html,index.mobile.html}
mv $dirweb/index{.original,}.html

uninstallfinish $@
