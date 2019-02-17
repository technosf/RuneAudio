#!/bin/bash

alias=bbtn

. /srv/http/addonstitle.sh
. /srv/http/addonsedit.sh

uninstallstart $@

echo -e "$bar Restore files ..."

restorefile /srv/http/app/templates/enhancebody.php

uninstallfinish $@

restartlocalbrowser
