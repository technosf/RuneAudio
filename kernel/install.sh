#!/bin/bash

alias=kern

. /srv/http/addonstitle.sh

pkg=$( pacman -Ss 'linux-raspberrypi$' | head -n1 )
version=$( echo $pkg | cut -d' ' -f2 )
installed=$( echo $pkg | cut -d' ' -f3 )

if [[ $installed == '[installed]' ]]; then
	title "$info Kernel already upgraged to latest version: $version"
	exit
fi

title -l '=' "$bar Upgrade Kernel ..."
timestart

pacman -Sy --force --noconfirm raspberrypi-firmware raspberrypi-bootloader linux-raspberrypi coreutils kmod

redis-cli set kernel "Linux runeaudio ${version}-ARCH" &> /dev/null

timestop
title -l '=' "$bar Kernel upgraded to $version successfully."
title -nt "$info Please reboot."
