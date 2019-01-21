#!/bin/bash

. /srv/http/addonstitle.sh

title -l '=' "$bar Enable WiFi and Bluetooth ..."

sed -i '/blacklist/ s/^/#/' /etc/modprobe.d/disable_rpi3_wifi_bt.conf
systemctl enable netctl-auto@wlan0
systemctl start netctl-auto@wlan0 shairport upmpdcli

title -nt "$info WiFi and Bluetooth enabled."
