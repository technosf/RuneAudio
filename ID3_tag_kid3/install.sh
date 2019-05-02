#!/bin/bash

rm $0

. /srv/http/addonstitle.sh

pkg=$( pacman -Ss '^kid3-qt$' | head -n1 )
version=$( echo $pkg | cut -d' ' -f2 )
installed=$( echo $pkg | cut -d' ' -f3 )

if [[ $installed == '[installed]' ]]; then
	title "$info Kid3 already installed"
	exit
fi

title -l '=' "$bar Install Kid3 ..."

timestart l

echo -e "$bar Prefetch packages ..."
pacman -Syw --noconfirm kid3-qt icu glibc readline pcre2 harfbuzz freetype2

echo -e "$bar Install packages ..."

pacman -S --noconfirm glibc readline
# fix missing symlink
ln -sf /lib/libreadline.so.{8.0,7}
# reinstall
pacman -S --noconfirm readline

pacman -S --noconfirm kid3-qt icu pcre2 harfbuzz freetype2

if [[ ! -e /usr/lib/libssl.so.1.1 ]]; then
  wgetnc https://github.com/rern/RuneAudio/raw/master/mpd/usr/lib/libcrypto.so.1.1 -P /usr/lib
  wgetnc https://github.com/rern/RuneAudio/raw/master/mpd/usr/lib/libssl.so.1.1 -P /usr/lib
  chown root:root /usr/lib/{libcrypto.so.1.1,libssl.so.1.1}
  chmod 755 /usr/lib/{libcrypto.so.1.1,libssl.so.1.1}
fi

redis-cli hset addons kid3 1 &> /dev/null

timestop l

title -l '=' "$bar Kid3 installed successfully"
