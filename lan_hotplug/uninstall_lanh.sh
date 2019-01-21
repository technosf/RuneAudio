#!/bin/bash

alias=motd

. /srv/http/addonstitle.sh
. /srv/http/addonsedit.sh

uninstallstart $@

echo -e "$bar Uninstall WiFi hotplug package ..."

pacman -R --noconfirm ifplugd

uninstallfinish $@
