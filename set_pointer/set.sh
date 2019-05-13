#!/bin/bash

rm $0

. /srv/http/addonstitle.sh

title -l '=' "$bar Pointer of local browser ..."

sed -i "s/\(use_cursor \).*/\1$1 \&/" /root/.xinitrc

echo -e "$bar Restart local browser ..."
killall Xorg &> /dev/null
sleep 3
xinit &> /dev/null &

[[ $1 == yes ]] && enable=enabled || enable=disabled
title -nt "$info Pointer of local browser $( tcolor $enable )."
