#!/bin/bash

rm $0

. /srv/http/addonstitle.sh

title "$info Set AirPlay output ..."

sessioncontrol=$( cat <<'EOF'
sessioncontrol = {
	run_this_before_play_begins = "/srv/http/enhanceshairport &";
	run_this_after_play_ends = "/srv/http/enhanceshairport off &";
}
EOF
)
# get dac's output_device
ao=$( redis-cli get ao )
if [[ ${ao:0:-2} == 'bcm2835 ALSA' ]]; then
	string=$( cat <<EOF
$sessioncontrol
alsa = {
	output_device = "hw:0";
}
EOF
)
else
	output_device=$( aplay -l | grep "$ao" | sed 's/card \(.\):.*/\1/' )
	string=$( cat <<EOF
$sessioncontrol
alsa = {
	output_device = "hw:$output_device";
}
EOF
)
fi

# set config
echo "$string" > /etc/shairport-sync.conf

systemctl restart shairport-sync

title "$info AirPlay output changed to $ao"
