#!/bin/bash

rm $0

. /srv/http/addonstitle.sh

title -l '=' "$bar Change zoom level of local browser ..."

if grep -q '^midori' /root/.xinitrc 2> /dev/null; then
	sed -i "s/^\(zoom-level=\).*/\1$1/" /root/.config/midori/config
else
	if ! grep -q calibrator /etc/X11/xinit/xinitrc 2> /dev/null; then
		file=/etc/X11/xinit/xinitrc
	elif [[ ! -e /etc/X11/xinit/start_chromium.sh ]]; then
		file=/etc/X11/xinit/start_chromium.sh
	else
		file=/root/.xinitrc
	fi
	sed -i "s/\(force-device-scale-factor=\).*/\1$1/" $file
fi

echo -e "$bar Restart local browser ..."
restartlocalbrowser

title -nt "$info Zoom level of local browser changed to $1"
