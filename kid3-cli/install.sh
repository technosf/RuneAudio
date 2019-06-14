#!/bin/bash

rm $0

. /srv/http/addonstitle.sh

if [[ -e /usr/bin/kid3-cli ]]; then
	title "$info Kid3 already installed"
	redis-cli hset addons kid3 1 &> /dev/null
	exit
fi

title -l '=' "$bar Install $( tcolor Kid3 ) ..."
timestart

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

echo -e "$bar Get package files ..."

wgetnc https://github.com/rern/_assets/raw/master/kid3pkg1.tar
wgetnc https://github.com/rern/_assets/raw/master/kid3pkg2.tar
mkdir pkg pkg4 pkg5
bsdtar xvf kid3pkg1.tar -C pkg
bsdtar xvf kid3pkg2.tar -C pkg
mv pkg/{pcre*,harfbuzz*,freetype2*} pkg4
mv pkg/{gstreamer*,orc*} pkg5

if [[ $( redis-cli get release ) == 0.4b ]]; then
	pacman -U --needed --noconfirm pkg4/*
else
	pacman -U --needed --noconfirm pkg5/*
fi
pacman -U --needed --noconfirm pkg/*

rm -rf kid3* pkg*

redis-cli hset addons kid3 1 &> /dev/null

timestop
title -l '=' "$bar $( tcolor Kid3 ) installed successfully."
