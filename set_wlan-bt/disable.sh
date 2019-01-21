#!/bin/bash

. /srv/http/addonstitle.sh

title -l '=' "$bar Disable WiFi and Bluetooth ..."

systemctl disable netctl-auto@wlan0
systemctl stop netctl-auto@wlan0 shairport upmpdcli
rfkill block 0
sed -i '/blacklist/ s/^#//' /etc/modprobe.d/disable_rpi3_wifi_bt.conf

title -nt "$info WiFi and Bluetooth disabled"
