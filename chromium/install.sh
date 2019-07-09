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
# fix: Only console users are allowed to run the X server
cat << EOF > /etc/X11/Xwrapper.config
allowed_users=anybody
needs_root_rights=yes
EOF

if [[ -e /etc/X11/xinit/xinitrc ]]; then
	file=/etc/X11/xinit/xinitrc
	rm -f /etc/X11/xinit/start_chromium*
else
	file=/root/.xinitrc
fi

cat << EOF > $file
#!/bin/bash

export XDG_CACHE_HOME="/tmp/.cache" &
export DISPLAY=":0" &

xset dpms 0 0 0 &
xset s off &
xset -dpms &

matchbox-window-manager -use_cursor no &
chromium --app=http://localhost --start-fullscreen --disable-gpu --force-device-scale-factor=1

# keyboard shortcuts
#xbindkeys -X ":0" &
EOF

cp $file /srv/http/app/config/_os/etc/X11/xinit/xinitrc

installfinish $@

reinitsystem
