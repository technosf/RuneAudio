#!/bin/bash

rm $0

ROOT=$( df | grep ROOT | awk '{print $NF}' )
if [[ -z $ROOT ]]; then
    echo -e "\nROOT path not found."
	echo -e "Mount ROOT partition > ./wifisetup.sh again.\n"
	exit
fi

cols=$( tput cols )
hr() { printf "\e[36m%*s\e[m\n" $cols | tr ' ' -; }

hr
echo -e "\n\e[36mSetup Wi-Fi connection ...\e[m\n"
hr

echo -e "\n$( df -h | grep ROOT )"
echo -e "ROOT: \e[36m$ROOT\e[m\n"
read -rsn1 -p "Confirm and continue? [y/n]: " ans; echo
[[ $ans != Y && $ans != y ]] && exit
echo

selectSecurity() {
	echo Security:
	echo -e '  \e[36m1\e[m WPA'
	echo -e '  \e[36m2\e[m WEP'
	echo -e '  \e[36m3\e[m None'
	read -rn 1 -p 'Select [1-3]: ' ans
	if [[ -z $ans || $ans -gt 3 ]]; then
		echo -e "\nSelect 1, 2 or 3\n" && selectSecurity
	else
		if [[ $ans == 1 ]]; then
			wpa=wpa
		elif [[ $ans == 2 ]]; then
			wpa=wep
		else
			wpa=
		fi
	fi
}
setCredential() {
	read -p 'SSID: ' ssid
	read -p 'Password: ' password
	selectSecurity
	echo -e "\n\nSSID: \e[36m$ssid\e[m\nPassword: \e[36m$password\e[m\nSecurity: \e[36m${wpa^^}\e[m\n"
	read -rn1 -p "Confirm and continue? [y/n]: " ans; echo
	[[ $ans != Y && $ans != y ]] && setCredential
}
setCredential

# profile
profile="Interface=wlan0
Connection=wireless
IP=dhcp
ESSID=\"$ssid\""
[[ -n $wpa ]] && profile+="
Security=$wpa
Key=$password
"
echo "$profile" > "$ROOT/etc/netctl/$ssid"

# enable startup
pwd=$PWD
dir=$ROOT/etc/systemd/system/sys-subsystem-net-devices-wlan0.device.wants
mkdir -p $dir
cd $dir
ln -s ../../../../lib/systemd/system/netctl-auto@.service netctl-auto@wlan0.service
cd "$pwd"

# unmount
umount -l $ROOT && echo -e "\n$ROOT unmounted."

echo -e "\n\e[36mWi-Fi setup succesfully.\e[m\n"
hr

