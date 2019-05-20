#!/bin/bash

alias=bbtn

. /srv/http/addonstitle.sh
. /srv/http/addonsedit.sh

uninstallstart $@

echo -e "$bar Restore files ..."

files="
/srv/http/app/templates/enhancebody.php
/srv/http/assets/js/enhance.js
/srv/http/assets/js/enhancefunction.js
"
restorefile $files

uninstallfinish $@

restartlocalbrowser
