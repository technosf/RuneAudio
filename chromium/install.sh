#!/bin/bash

# change version number in RuneAudio_Addons/srv/http/addonslist.php

alias=chro

. /srv/http/addonstitle.sh
. /srv/http/addonsedit.sh

installstart $@

rankmirrors

getuninstall

pacman -S --needed --noconfirm chromium nss harfbuzz freetype2 zlib libjpeg-turbo

echo -e "$bar Modify file ..."

# -----------------------------------------------------------------------------
# fix - chromium try to probe ipv6
file=/boot/cmdline.txt
echo $file
sed -i 's/ ipv6.disable=1//' $file
# -----------------------------------------------------------------------------
# remove black border on local screen
file=/boot/config.txt
echo $file

commentS '^disable_overscan'

string=$( cat <<'EOF'
disable_overscan=1
EOF
)
appendS '$'
# -----------------------------------------------------------------------------
# xinit
if grep -q '^midori' /root/.xinitrc; then
	file=/root/.xinitrc
else
	if ! grep -q calibrator /etc/X11/xinit/xinitrc; then
		file=/etc/X11/xinit/xinitrc
	elif [[ ! -e /etc/X11/xinit/start_chromium.sh ]]
		file=/etc/X11/xinit/start_chromium.sh
	else
		file=/root/.xinitrc
	fi
fi
wgetnc https://github.com/rern/RuneAudio/raw/master/chromium/xinitrc -O $file

# fix: Only console users are allowed to run the X server
cat << EOF > /etc/X11/Xwrapper.config
allowed_users=anybody
needs_root_rights=yes
EOF

installfinish $@

reinitsystem
