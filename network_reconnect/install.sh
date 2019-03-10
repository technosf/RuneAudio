#!/bin/bash

. /srv/http/addonstitle.sh

title -l '=' "$bar Upgrade $( tcolor "ifplugd" ) ..."

pacman -Sy --noconfirm ifplugd

title -l '=' "$bar $( tcolor "ifplugd" ) upgraded successfully."
