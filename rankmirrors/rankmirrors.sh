#!/bin/bash

rm $0

(( $# == 0 )) && sec=3 || sec=$1

# rankmirrors.sh
# mitigate download errors by enable(uncomment) and 
# rank servers in /etc/pacman.d/mirrorlist by download speed

[[ ! -e /srv/http/addonstitle.sh ]] && wget -q https://github.com/rern/RuneAudio_Addons/raw/master/srv/http/addonstitle.sh -P /srv/http
. /srv/http/addonstitle.sh

timestart

title -l = $bar Rank Mirror Package Servers ...

echo -e "\n$bar Get latest mirrorlist of package servers ..."
wgetnc https://github.com/archlinuxarm/PKGBUILDs/raw/master/core/pacman-mirrorlist/mirrorlist -P /tmp
tmplist=/tmp/mirrorlist
echo $( grep 'Generated' $tmplist | cut -d' ' -f2- )

# convert mirrorlist to url list
if grep -qs '# Server = ' $tmplist; then
	sed -i '/^\s*$/d
		/^# Server = /!d
		s/^# Server = //g
		s|/$arch/$repo||g' $tmplist
		# delete blank lines and lines not start with '# Server = ', remove '# Server = '
else
	sed -i 's/^Server = //g
		s|/$arch/$repo||g' $tmplist # already uncomment
fi

readarray servers < "$tmplist"

echo -e "\nTest ${#servers[@]} servers @ $sec seconds download + 3 pings:\n"

dlfile='armv7h/community/community.db' # download test file
tmpdir=/tmp/rankmirrors
rm -rf $tmpdir && mkdir $tmpdir

i=0
for server in ${servers[@]}; do # download from each mirror
	(( i++ ))
	timeout $sec wget -q -P $tmpdir $server/$dlfile &
	wait
	dl=$( du -c $tmpdir | grep total | awk '{print $1}' ) # get downloaded amount
	ping=$( ping -4 -c 3 -w 3 ${server/http*\:\/\/} | tail -1 | cut -d'/' -f5 )
	if [[ -n $ping ]]; then
		latency=$( printf %.0f $ping )
	else
		latency=
	fi
	
	server0='Server = '$server'/$arch/$repo'
	speed=$(( dl / sec ))
	dl_server="$dl_server$server0 $speed kB/s $latency ms\n"
	printf "%6d. %-23s :%7d kB/s%5s ms\n" $i ${server/archlinux*}.. $speed $latency
	
	rm -f $tmpdir/* # remove downloaded file
done

rank=$( echo -e "$dl_server" | grep . | sort -g -k4,4nr -k6,6n )
rankfile=$( echo -e "$rank" | cut -d' ' -f1-3 )

echo -e "\n$info Top 3 package servers ranked by speed and latency:\n"

lines=$( echo -e "$rank" | head -3 | sed 's/Server = \|\/\$arch.*repo//g' )
for i in 1 2 3; do
	fields=( $( echo "$lines" | sed -n "$i p" ) )
	printf "%-33s%7d kB/s%5s ms\n" ${fields[0]} ${fields[1]} ${fields[2]}
done

list=/etc/pacman.d/mirrorlist
[[ ! -e $list.backup ]] && cp $list $list.backup
echo -e "$rankfile" > $list
rm -rf $tmpdir

echo -e "\n$bar Update package database ..."

rm -f /var/lib/pacman/db.lck
pacman -Sy

timestop
title -l = "$bar Mirror list updated and ranked successfully."
