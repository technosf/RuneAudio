#!/bin/bash

alias=kid3

. /srv/http/addonstitle.sh

 if [[ $( redis-cli hget addons kid3 ) ]]; then
	title "$info Kid3 already installed"
	exit
fi

title -l '=' "$bar Install $( tcolor Kid3 ) ..."
timestart l

getuninstall

wgetnc https://github.com/rern/RuneAudio/raw/master/Metadata_editing/kid3lib.tar.xz
mv /usr/lib/libcrypto.so.1.1{,X} &> /dev/null
mv /usr/lib/libssl.so.1.1{,X} &> /dev/null
bsdtar xvf kid3lib.tar.xz -C /usr/lib
rm kid3lib.tar.xz
ln -s /usr/lib/libreadline.so.{8.0,8}
pacman -Sy --noconfirm glibc
[[ $( redis-cli get release ) == 0.4b ]] && pacman -S --noconfirm pcre2 harfbuzz freetype2
pacman -S --noconfirm kid3

timestop l

redis-cli hset addons kid3 1 &> /dev/null

title -l '=' "$bar $( tcolor Kid3 ) installed successfully."
