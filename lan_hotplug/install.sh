# change version number in RuneAudio_Addons/srv/http/addonslist.php

alias=lanh

. /srv/http/addonstitle.sh
. /srv/http/addonsedit.sh

installstart $@

pacman -Sy --needed --noconfirm ifplugd

redis-cli hset addons lanh 1 &> /dev/null # mark as upgraded - disable button

installfinish $@
