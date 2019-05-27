#!/bin/bash

. /srv/http/addonstitle.sh

if pacman -Q kid3-cli &> /dev/null; then
	title "$info kid3-cli already installed"
	redis-cli hset addons kid3 1
	exit
fi

title -l '=' "$bar Install $( tcolor kid3-cli ) ..."

file=kid3-cli-3.7.1-1-armv7h.pkg.tar.xz
wget https://github.com/rern/RuneAudio/raw/master/kid3-cli/$file
pacman -U --noconfirm $file
rm $file

redis-cli hset addons kid3 1 &> /dev/null

title -l '=' "$bar $( tcolor kid3-cli ) installed successfully."
