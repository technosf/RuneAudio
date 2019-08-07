#!/bin/bash

rm $0

. /srv/http/addonstitle.sh

rankmirrors

packagestatus mpd # $version, $installed

if [[ $installed ]]; then
	title "$info MPD already upgraded to latest version: $version"
	exit
fi

title -l '=' "$bar Upgrade MPD ..."
timestart

if [[ ! $( pacman -Qs mpd-rune ) ]]; then
	chown mpd:audio /var/log/runeaudio/mpd.log
	pacman -S --needed --noconfirm mpd
	if systemctl restart mpd &> /dev/null; then
		[[ -e /etc/systemd/system/enhanceidle ]] && systemctl restart enhanceidle
		timestop
		title -l '=' "$bar MPD upgraded successfully to $version"
	else
		title -l = "$warn MPD upgrade failed."
	fi
	exit
fi

cp /etc/mpd.conf{,.backup}

# NO: pacman -S openssl > libcrypto.so.1.0, libssl.so.1.0 error - some packages still need existing version
if [[ ! -e /usr/lib/libicudata.so.64.2 ]]; then
	echo -e "$bar Get supporting files ..."
	# pacman -S icu - breaks MPD; pacman -S readline - breaks ssh
	wgetnc https://github.com/rern/_assets/raw/master/libiculibreadline.tar.xz
	bsdtar xvf libiculibreadline.tar.xz -C /usr/lib
	rm libiculibreadline.tar.xz
	ln -sf /usr/lib/libreadline.so.8{.0,}
	ln -sf /usr/lib/libicudata.so.64{.2,}
	ln -sf /usr/lib/libicui18n.so.64{.2,}
	ln -sf /usr/lib/libicuio.so.64{.2,}
	ln -sf /usr/lib/libicuuc.so.64{.2,}
fi

echo -e "$bar Remove conflict packages ..."
sed -i 's/ashuffle \|ffmpeg \|mpd //g' /etc/pacman.conf
# pre-remove to avoid conflict messages (/usr/local/bin/ashuffle is used directly, not by installed)
pacman -Rdd --noconfirm ashuffle-rune ffmpeg-rune mpd-rune libsystemd

echo -e "$bar Install MPD ..."

pacman -S --needed --noconfirm libnfs libwebp gcc wavpack ffmpeg pacman mpd mpc libmpdclient libgcrypt libgpg-error

cp /etc/mpd.conf{.backup,}

# fix permission (default - mpd run by user 'mpd')
chmod -f 777 /var/log/runeaudio/mpd.log

# fix systemd unknown lvalue (not exist in current systemd version) 
echo -e "$bar Modify files ..."
sed -i -e 's/User=mpd/User=root/
' -e '/^ProtectKernel/ s/^/#/
' -e '/^ProtectControl/ s/^/#/
' -e '/^Restrict/ s/^/#/
' /usr/lib/systemd/system/mpd.service

# fix missing directory
mkdir -p /var/lib/mpd/playlists
chown mpd:audio /var/lib/mpd/playlists /var/log/runeaudio/mpd.log 

systemctl daemon-reload

echo -e "$bar Start MPD ..."
if ! systemctl restart mpd &> /dev/null; then
	[[ -e /etc/systemd/system/enhanceidle ]] && systemctl restart enhanceidle
	title -l = "$warn MPD upgrade failed."
	exit
fi

systemctl restart rune_PL_wrk

timestop

version=$( mpd -V | head -n1 | cut -d'(' -f2 | cut -d')' -f1 )

title -l '=' "$bar MPD upgraded successfully to $version"

{ mpc rescan; curl -s -X POST 'http://localhost/pub?id=reload' -d 1; } &
