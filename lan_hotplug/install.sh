# change version number in RuneAudio_Addons/srv/http/addonslist.php

alias=lanh

. /srv/http/addonstitle.sh
. /srv/http/addonsedit.sh

installstart $@

getuninstall

pacman -Sy --noconfirm ifplugd

installfinish $@
