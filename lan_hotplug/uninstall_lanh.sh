#!/bin/bash

alias=lanh

. /srv/http/addonstitle.sh
. /srv/http/addonsedit.sh

uninstallstart $@

pacman -R --noconfirm ifplugd

uninstallfinish $@
