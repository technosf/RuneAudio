# change version number in RuneAudio_Addons/srv/http/addonslist.php

alias=lanh

. /srv/http/addonstitle.sh
. /srv/http/addonsedit.sh

installstart $@

getuninstall

echo -e "$bar Install WiFi hotplug package ..."

pacman -Sy --noconfirm ifplugd

installfinish $@
