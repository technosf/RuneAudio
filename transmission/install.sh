#!/bin/bash

# $1-password

# change version number in RuneAudio_Addons/srv/http/addonslist.php

alias=tran

. /srv/http/addonsfunctions.sh
. /srv/http/addonsedit.sh

installstart $@

getuninstall

mnt=$( mount | grep /dev/sda1 | cut -d' ' -f3 )
path="$mnt/transmission"
if [[ ! -e "$path" ]]; then
	mkdir -p "$path"
	mkdir -p "$path/{incomplete,watch}"
fi
# custom systemd unit
systemctl disable --now transmission

# custom user and env - TRANSMISSION_HOME must be /<path>/transmission-daemon
dir=/etc/systemd/system/transmission.service.d
mkdir -p $dir
echo "[Service]
User=root
Environment=TRANSMISSION_HOME=$path
" > $dir/override.conf
systemctl daemon-reload

file="$path/settings.json"
if [[ ! -e "$file" ]]; then
	# create new settings.json
	systemctl start transmission
	systemctl stop transmission
	
	sed -i -e 's|\("download-dir": "\).*|\1'"$path"'",|
	' -e 's|\("incomplete-dir": "\).*|\1'"$path"'/incomplete",|
	' -e 's|\("incomplete-dir-enabled": \).*|\1true,|
	' -e 's|\("rpc-whitelist-enabled": \).*|\1false,|
	' -e '/[^{},\{, \}]$/ s/$/, /
	' -e '/^}$/ i\
	"watch-dir": "'"$path"'/watch", \
	"watch-dir-enabled": true,
	' $file
	# set password
	if [[ -n $1 && $1 != 0 ]]; then
		sed -i -e 's|\("rpc-authentication-required": \).*|\1true,|
		' -e 's|\("rpc-password": "\).*|\1'"$1"'",|
		' -e 's|\("rpc-username": "\).*|\1root",|
		' $file
	else
		sed -i 's|\("rpc-authentication-required": \).*|\1false,|' $file
	fi
else
	if [[ -n $1 && $1 != 0 ]]; then
		sed -i 's|\("rpc-password": "\).*|\1'"$1"'",|' $file
	else
		sed -i 's|\("rpc-authentication-required": \).*|\1false,|' $file
	fi
fi

# web ui alternative
echo -e "$bar Get WebUI alternative ..."
wgetnc https://github.com/ronggang/transmission-web-control/archive/master.zip

dirweb=/usr/share/transmission/web
mv $dirweb/index{,.original}.html
bsdtar --strip 2 --exclude '.*' --exclude '*.md' -C $dirweb -xf master.zip transmission-web-control-master/src
rm master.zip
chown -R root:root $dirweb

echo -e "$bar Start Transmission ..."
if ! systemctl enable --now transmission &> /dev/null; then
	title -l = "$warn Transmission install failed."
	exit
fi

file=/srv/http/indexbody.php
echo $file

string=$( cat <<'EOF'
$tranenable = exec( '/usr/bin/systemctl is-enabled transmission' ) === 'enabled' ? 1 : 0;
$tranactive = exec( '/usr/bin/systemctl is-active transmission' ) === 'active' ? 1 : 0;
EOF
)
insert '// counts'

string=$( cat <<'EOF'
	<a id="transmission" data-enabled="<?=$tranenable?>" data-active="<?=$tranactive?>">
		<img src="/assets/img/addons/thumbtran.<?=$time?>.png" <?=( $tranactive ? 'class="on"' : '' )?>>Transmission
		<i class="fa fa-gear submenu imgicon settings"></i>
	</a>
EOF
)
insertH 'displaylibrary'

file=/srv/http/assets/js/main.js
echo $file

string=$( cat <<'EOF'
$( '#transmission' ).click( function( e ) {
	menuPackage( e, $( this ), 'http://'+ location.hostname +':9091' );
} );
EOF
)
insert '#displaycolor'

installfinish $@

echo "Download directory: $path"
title -nt "User: root"
