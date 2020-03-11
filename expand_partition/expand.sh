#!/bin/bash

rm $0

[[ -e /srv/http/addons-functions.sh ]] && . /srv/http/addons-functions.sh || . /srv/http/bash/addons-functions.sh

devpart=$( mount | grep 'on / type' | awk '{print $1}' )
part=${devpart/\/dev\//}
disk=/dev/${part::-2}

freeib=$( df / | tail -n1 | awk '{print $4 * 1024}' | numfmt --to=iec-i --suffix=B --padding=10 )
unpart=$( sfdisk -F /dev/mmcblk0 | head -n1 | awk '{print $6}' )
unpartib=$( echo $unpart | numfmt --to=iec-i --suffix=B --padding=10 )

# noobs has 3MB unpartitioned space
if (( $unpart < 10000000 )); then
	title -l '=' "$info No useful space available. ("$unpartib" unpartitioned space )"
	redis-cli hset addons expa 1 &> /dev/null
	exit
fi

# expand partition #######################################
title -l '=' "$bar Expand partition ..."
echo "System partiton  : $devpart"
echo "Free space       : $freeib"
echo "Expandable space : $unpartib"
echo

if [[ -t 1 ]]; then
	yesno "Expand partiton to full expandable space:" answer
	if [[ $answer == 0 ]]; then
		title "$info Expand partition cancelled."
		exit
	fi
fi

if ! pacman -Q parted &>/dev/null; then
	echo -e "$bar Install parted ..."
	wgetnc https://github.com/rern/RuneAudio/raw/master/expand_partition/parted-3.2-9-armv7h.pkg.tar.xz
	pacman -U --noconfirm parted-3.2-9-armv7h.pkg.tar.xz
	rm parted-3.2-9-armv7h.pkg.tar.xz
fi

echo -e "$bar fdisk ..."
echo -e "d\n\nn\n\n\n\n\nw" | fdisk $disk &>/dev/null

partprobe $disk

echo -e "\n$bar resize2fs ..."
resize2fs $devpart
	
if [[ $? != 0 ]]; then
	title -l '=' "$warn Expand partition failed."
	title -nt "Try: reboot > resize2fs $devpart"
	exit
else
	freeib=$( df / | tail -n1 | awk '{print $4 * 1024}' | numfmt --to=iec-i --suffix=B )
	redis-cli hset addons expa 1 &> /dev/null # mark as expanded - disable webui button
	title -l '=' "$bar System partiton $( tcolor $devpart ) now has $( tcolor $freeib ) free space."
fi
