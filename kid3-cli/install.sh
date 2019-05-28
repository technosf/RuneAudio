#!/bin/bash

. /srv/http/addonstitle.sh

if pacman -Q kid3-cli || pacman -Q kid3 &> /dev/null; then
	title "$info Kid3 already installed"
	redis-cli hset addons kid3 1
	exit
fi

title -l '=' "$bar Install $( tcolor Kid3 ) ..."
timestart l

if [[ ! -e /lib/libicudata.so.64.2 ]]; then
	echo -e "$bar Get files ..."

	wgetnc https://github.com/rern/RuneAudio/raw/master/Metadata_editing/kid3lib.tar.xz
	cp /usr/lib/libcrypto.so.1.1{,X} &> /dev/null
	cp /usr/lib/libssl.so.1.1{,X} &> /dev/null
	bsdtar xvf kid3lib.tar.xz -C /usr/lib
	ln -sf /usr/lib/libreadline.so.8{.0,}
	ln -f /usr/lib/libicudata.so.64{.2,}
	ln -f /usr/lib/libicui18n.so.64{.2,}
	ln -f /usr/lib/libicuio.so.64{.2,}
	ln -f /usr/lib/libicuuc.so.64{.2,}
	rm kid3lib.tar.xz
fi

wgetnc https://github.com/rern/RuneAudio/raw/master/kid3-cli/kid3pkg1.tar
wgetnc https://github.com/rern/RuneAudio/raw/master/kid3-cli/kid3pkg2.tar
mkdir tmp tmp1
bsdtar xvf kid3pkg1.tar -C tmp
bsdtar xvf kid3pkg2.tar -C tmp
mv tmp/kid3-cli-3.7.1-1-armv7h.pkg.tar.xz .
mv tmp/{pcre*,harfbuzz*,freetype2*} tmp1
pkgs=( tmp/* )
pacman -U --noconfirm $pkgs
if [[ $( redis-cli get release ) == 0.4b ]]; then
	pkgs=( tmp1/* )
	pacman -U --noconfirm $pkgs
fi
pacman -U --noconfirm kid3-cli-3.7.1-1-armv7h.pkg.tar.xz
rm -rf tmp tmp1 kid3-cli-3.7.1-1-armv7h.pkg.tar.xz

redis-cli hset addons kid3 1 &> /dev/null

title -l '=' "$bar $( tcolor Kid3 ) installed successfully."
