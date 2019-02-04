#!/bin/bash

. /srv/http/addonstitle.sh

pkg=$( pacman -Ss '^midori$' | head -n1 )
version=$( echo $pkg | cut -d' ' -f2 )
installed=$( echo $pkg | cut -d' ' -f3 )

if [[ $installed == '[installed]' ]]; then
	title "$info Midori already upgraded to latest version: $version"
	exit
fi

title -l '=' "$bar Upgrade Midori ..."
timestart

if ! pacman -Q midori-rune &> /dev/null; then
	pacman -Sw --noconfirm enchant fontconfig freetype2 gpg-crypter glib2 gstreamer gstreamer-vaapi gtk3  gst-plugins-base-libs\
		harfbuzz harfbuzz-icu hunspell icu libepoxy libgcrypt libgpg-error libsoup libthai libwebp pango zbar

	file=$( ls -l /lib/libicuuc* | grep -v '^lrw' )
	file=$( echo $file | cut -d' ' -f9 )
	ln -sf $file /lib/libicuuc.so.56

	file=$( ls -l /lib/libicudata* | grep -v '^lrw' )
	file=$( echo $file | cut -d' ' -f9 )
	ln -sf $file /lib/libicudata.so.56
fi

yes 2>/dev/null | pacman -S midori

if grep '^chromium' /root/.xinitrc; then
	echo -e "$bar Disable Chromium ..."
	sed -i -e '/^chromium/ s/^/#/
	' -e '/midori/ s/^#//
	' /root/.xinitrc
fi

echo -e "$bar Restart Midori ..."
killall midori
sleep 3
xinit &> /dev/null &

timestop

title -l '=' "$bar Midori upgraded to $version successfully."

