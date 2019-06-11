#!/bin/bash

. /srv/http/addonstitle.sh

rankmirrors

packagestatus pacman # $version, $installed

if [[ $installed ]]; then
	title "$info Pacman already upgraded to latest version: $version"
	exit
fi

title -l '=' "$bar Upgrade Pacman ..."
timestart

echo -e "$bar Prefetch packages ..."
pacman -Syw --noconfirm glibc pacman

echo -e "$bar Install packages ..."
pacman -S --noconfirm glibc pacman

timestop

title -l '=' "$bar Pacman upgraded to $version successfully."
