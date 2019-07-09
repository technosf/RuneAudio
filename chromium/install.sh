#!/bin/bash

# change version number in RuneAudio_Addons/srv/http/addonslist.php

alias=chro

. /srv/http/addonstitle.sh
. /srv/http/addonsedit.sh

installstart $@

rankmirrors

packagestatus '^chromium$' # $version, $installed

if [[ $installed ]]; then
	title "$info Chromium already upgraded to latest version: $version"
	exit
fi

# purge for 0.5
[[ -e /usr/bin/chromium && $( chromium -version | cut -d' ' -f2 ) < 75.0.3770.100 ]] && pacman -Rsn --noconfirm chromium 2> /dev/null

pacman -S --needed --noconfirm chromium freetype2 zlib libjpeg # for 0.4: zlib libjpeg

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
cat << 'EOF' > /etc/X11/Xwrapper.config
allowed_users=anybody
needs_root_rights=yes
EOF

# for 0.5
file=/lib/systemd/system/local-browser.service
if [[ -e $file ]]; then
	echo $file
	cat << 'EOF' > $file
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

	file=/srv/http/app/templates/settings.php
	echo $file
	
	commentH 'local_browserBox'
	commentH -n -2 local_browserBox
	commentH -n -1 'local_browserName' 'local_browserName'
	
	string=$( cat <<'EOF'
				<div class="hide" id="local_browserName">
EOF
)
	appendH 'local_browserName'
	
	rm -f /etc/X11/xinit/start_chromium*
fi

cat << 'EOF' > /etc/X11/xinit/xinitrc
#!/bin/bash

export XDG_CACHE_HOME="/tmp/.cache" &
export DISPLAY=":0" &

xset dpms 0 0 0 &
xset s off &
xset -dpms &

matchbox-window-manager -use_cursor no &
chromium --app=http://localhost --kiosk --incognito --disable-gpu --force-device-scale-factor=1

# keyboard shortcuts
#xbindkeys -X ":0" &
EOF

installfinish $@

reinitsystem
