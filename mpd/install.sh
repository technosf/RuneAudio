#!/bin/bash

. /srv/http/addonstitle.sh

pkg=$( pacman -Ss '^mpd$' | head -n1 )
version=$( echo $pkg | cut -d' ' -f2 )
installed=$( echo $pkg | cut -d' ' -f3 )

if [[ $installed == '[installed]' ]]; then
	title "$info MPD already upgraded to latest version: $version"
	exit
fi

title -l '=' "$bar Upgrade MPD ..."
timestart l

echo -e "$bar Prefetch packages ..."
pacman -Syw --noconfirm libnfs icu libwebp gcc-libs wavpack ffmpeg pacman python2-pip mpd mpc libmpdclient libgcrypt libgpg-error readline

echo -e "$bar Get files ..."
# pacman -S openssl > libcrypto.so.1.0, libssl.so.1.0 error - some packages still need existing version
wgetnc https://github.com/rern/RuneAudio/raw/master/mpd/usr/lib/libcrypto.so.1.1 -P /usr/lib
wgetnc https://github.com/rern/RuneAudio/raw/master/mpd/usr/lib/libssl.so.1.1 -P /usr/lib
chown root:root /usr/lib/{libcrypto.so.1.1,libssl.so.1.1}
chmod 755 /usr/lib/{libcrypto.so.1.1,libssl.so.1.1}

# fix python3 issue by swith to python2
ln -sf /usr/bin/python{2.7,}

cp /etc/mpd.conf{,.backup}

echo -e "$bar Remove conflict packages ..."
# pre-remove to avoid conflict messages (/usr/local/bin/ashuffle is used directly, not by installed)
pacman -Q mpd-rune &> /dev/null && pacman -Rdd --noconfirm ashuffle-rune ffmpeg-rune mpd-rune libsystemd

echo -e "$bar Install packages ..."
pacman -S --noconfirm libnfs icu libwebp gcc-libs wavpack ffmpeg libgcrypt libgpg-error readline
# fix symlink version
ln -sf /usr/lib/libreadline.so{,.7}
pacman -S --noconfirm python2-pip
ln -sf /usr/bin/pip{2,}
pip install flask

echo -e "$bar Install MPD ..."
pacman -S --noconfirm mpd mpc libmpdclient

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
chown mpd:audio /var/lib/mpd/playlists

systemctl daemon-reload

echo -e "$bar Start MPD ..."
if ! systemctl restart mpd &> /dev/null; then
	title -l = "$warn MPD upgrade failed."
	exit
fi

clearcache
systemctl restart rune_PL_wrk
	
timestop l

version=$( mpd -V | head -n1 | cut -d'(' -f2 | cut -d')' -f1 )

title -l '=' "$bar MPD upgraded successfully to $version"

[[ $( redis-cli get local_browser ) == 1 ]] && title -nt "$info Local browser enabled: $( tcolor Chromium ) browser must be installed to replace Midori"
