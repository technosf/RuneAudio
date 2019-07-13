#!/bin/bash

rm $0

. /srv/http/addonstitle.sh

title "$info Set AirPlay output ..."

# get dac's output_device
ao=$( redis-cli get ao )
if [[ ${ao:0:-2} == 'bcm2835 ALSA' ]]; then
	card=0
else
	card=$( aplay -l | grep "$ao" | sed 's/card \(.\):.*/\1/' )
fi

sed -i -e "s/\s*output_device = .*/	output_device = \"hw:$card\";/" /etc/shairport-sync.conf

systemctl restart shairport-sync

title "$info AirPlay output changed to $ao"
