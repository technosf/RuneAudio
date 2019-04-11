#!/bin/bash

# change version number in RuneAudio_Addons/srv/http/addonslist.php

alias=udac

. /srv/http/addonstitle.sh
. /srv/http/addonsedit.sh

installstart $@

getuninstall

echo -e "$bar Modify files ..."
#----------------------------------------------------------------------------------
file=/srv/http/app/libs/runeaudio.php
echo $file

commentS 'Audio output switched'
#----------------------------------------------------------------------------------
mv /etc/udev/rules.d/rune_usb-audio.rules{,.backup}
# long running script must run with systemd
cat << 'EOF' > /etc/udev/rules.d/usbdac.rules
ACTION=="add", SUBSYSTEM=="sound", TAG+="systemd", ENV{SYSTEMD_WANTS}="usbdacon.service"
ACTION=="remove", SUBSYSTEM=="sound", TAG+="systemd", ENV{SYSTEMD_WANTS}="usbdacoff.service"
EOF
#----------------------------------------------------------------------------------
cat << 'EOF' > /root/usbdac
#!/usr/bin/php

<?php
$redis = new Redis();
$redis->pconnect( '127.0.0.1' );
include '/srv/http/app/libs/runeaudio.php';

wrk_mpdconf( $redis, 'refresh' );

if ( $argc > 1 ) {
	// "exec" gets only last line which is new power-on card
	$ao = exec( '/usr/bin/aplay -lv | grep card | cut -d"]" -f1 | cut -d"[" -f2' );
	$name = $ao;
} else {
	$ao = $redis->get( 'aodefault' );
	$name = $redis->hGet( 'udaclist', $ao );
}

ui_notify( 'Audio Output Switch', $name );
wrk_mpdconf( $redis, 'switchao', $ao );
EOF

chmod +x /root/usbdac
#----------------------------------------------------------------------------------
unitfile() {
    cat << EOF > /etc/systemd/system/$2.service
[Unit]
Description=Hotplug USB DAC
[Service]
Type=oneshot
ExecStart=/root/usbdac $1
[Install]
WantedBy=multi-user.target
EOF
}
unitfile on usbdacon
unitfile '' usbdacoff
#----------------------------------------------------------------------------------
udevadm control --reload-rules
systemctl restart systemd-udevd

redis-cli set aodefault "$1" &> /dev/null

installfinish $@
