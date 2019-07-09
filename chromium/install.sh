#!/bin/bash

# change version number in RuneAudio_Addons/srv/http/addonslist.php

alias=chro

. /srv/http/addonstitle.sh
. /srv/http/addonsedit.sh

installstart $@

rankmirrors

getuninstall

# purge for 0.5
[[ $( chromium -version | cut -d' ' -f2 ) < 75.0.3770.100 ]] && pacman -Rsn --noconfirm chromium 2> /dev/null

pacman -S --needed --noconfirm chromium freetype2

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

# for 0.5
file=/lib/systemd/system/local-browser.service
if [[ -e $file ]]; then
	cat << EOF > $file
[Unit]
Description=Local Chromium Browser
After=network.target

[Service]
Type=simple
User=http
ExecStart=/usr/bin/startx
ExecStop=/usr/bin/killall Xorg
Restart=always

[Install]
WantedBy=multi-user.target
EOF
fi

file=/etc/X11/xinit/xinitrc
if [[ -e $file ]]; then
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
chromium --app=http://localhost --kiosk --disable-gpu --force-device-scale-factor=1

# keyboard shortcuts
#xbindkeys -X ":0" &
EOF

installfinish $@

reinitsystem
