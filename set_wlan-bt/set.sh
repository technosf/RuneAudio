#!/bin/bash

rm $0

. /srv/http/addonstitle.sh

if [[ $1 == yes ]]; then
	title -l '=' "$bar Disable WiFi and Bluetooth ..."

	systemctl disable netctl-auto@wlan0
	systemctl stop netctl-auto@wlan0
	rfkill block 0
	sed -i '/blacklist/ s/^#//' /etc/modprobe.d/disable_rpi3_wifi_bt.conf

	title -nt "$info WiFi and Bluetooth disabled"
else
	title -l '=' "$bar Enable WiFi and Bluetooth ..."

	sed -i '/blacklist/ s/^/#/' /etc/modprobe.d/disable_rpi3_wifi_bt.conf
	systemctl enable netctl-auto@wlan0
	systemctl start netctl-auto@wlan0

	title -nt "$info WiFi and Bluetooth enabled."
fi
