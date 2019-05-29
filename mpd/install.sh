#!/bin/bash

rm $0

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
pkg="libnfs libwebp gcc wavpack ffmpeg pacman python2-pip mpd mpc libmpdclient libgcrypt libgpg-error"
if [[ $( redis-cli get release ) == 0.4b ]]; then
	pkg="$pkg icu readline"
	# fix python3 issue by swith to python2
	ln -sf /usr/bin/python{2.7,}
	# fix symlink version
	ln -sf /usr/lib/libreadline.so{,.7}
	pacman -S --noconfirm python2-pip
	ln -sf /usr/bin/pip{2,}
	pip install flask
fi
cp /etc/mpd.conf{,.backup}

pacman -Syw --noconfirm $pkg

echo -e "$bar Get files ..."
# NO: pacman -S openssl > libcrypto.so.1.0, libssl.so.1.0 error - some packages still need existing version
if [[ ! -e /usr/bin/kid3-cli ]]; then
	file=libcryptossl.tar.xz
	wgetnc https://github.com/rern/_assets/raw/master/$file
	cp /usr/lib/libcrypto.so.1.1{,backup} &> /dev/null
	cp /usr/lib/libssl.so.1.1{,backup} &> /dev/null
	bsdtar xvf $file -C /usr/lib
	rm $file
fi

echo -e "$bar Remove conflict packages ..."
# pre-remove to avoid conflict messages (/usr/local/bin/ashuffle is used directly, not by installed)
pacman -Q mpd-rune &> /dev/null && pacman -Rdd --noconfirm ashuffle-rune ffmpeg-rune mpd-rune libsystemd

echo -e "$bar Install MPD ..."
pacman -S --noconfirm $pkg

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
redis-cli hset addons mpdu 1 &> /dev/null

timestop l

version=$( mpd -V | head -n1 | cut -d'(' -f2 | cut -d')' -f1 )

title -l '=' "$bar MPD upgraded successfully to $version"

[[ $( redis-cli get local_browser ) == 1 ]] && title -nt "$info Local browser enabled: $( tcolor Chromium ) browser must be installed to replace Midori"
