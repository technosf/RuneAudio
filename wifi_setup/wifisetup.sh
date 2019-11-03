#!/bin/bash

ROOT=$( df | grep ROOT | awk '{print $NF}' )
if [[ -z $ROOT ]]; then
    echo -e "\nROOT path not found."
	echo -e "Mount ROOT partition > ./wifisetup.sh again.\n"
	exit
fi

cols=$( tput cols )
hr() { printf "\e[36m%*s\e[m\n" $cols | tr ' ' -; }

hr
echo -e "\nSetup Wi-Fi connection ...\n"
hr

echo -e "\n$( df -h | grep ROOT )"
echo -e "ROOT: $ROOT\n"
read -rsn1 -p "Confirm ROOT path? (y/N): " ans; echo
[[ $ans != Y && $ans != y ]] && exit

selectSecurity() {
	echo Security:
	tcolor 1 'WPA'
	tcolor 2 'WEP'
	tcolor 3 'None'
	read -rn 1 -p 'Select [1-3]: ' ans
	[[ -z $ans ]] || (( $ans > 3 )) && echo -e "\nSelect 1, 2 or 3\n" && selectSecurity
	if [[ $ans == 1 ]]; then
		wpa=wpa
	elif [[ $ans == 2 ]]; then
		wpa=wep
	else
		wpa=
	fi
}
setCredential() {
	echo
	read -p 'SSID: ' ssid
	read -p 'Password: ' password
	selectSecurity
	echo -e "\nSSID: $ssid\nPassword: $password\nSecurity: ${wpa^^}\n"
	read -rn1 -p "Confirm and continue? [y/N]: " ans; echo
	[[ $ans != Y && $ans != y ]] && setCredential
}
setCredential

# profile
profile="Interface=wlan0
Connection=wireless
IP=dhcp
ESSID=\"$ssid\""
[[ -n $wpa ]] && profile+="Security=$wpa
Key=$password"
echo $profile > "$ROOT/etc/netctl/$ssid"

# enable startup
dir="$ROOT/etc/systemd/system/netctl@$ssid.service.d"
mkdir $dir
echo '[Unit]
BindsTo=sys-subsystem-net-devices-wlan0.device
After=sys-subsystem-net-devices-wlan0.device' > "$dir/profile.conf"

cd $ROOT/etc/systemd/system/multi-user.target.wants
ln -s ../../../../lib/systemd/system/netctl@.service "netctl@$ssid.service"
cd

# unmount
umount -l $ROOT && echo -e "\n$ROOT unmounted."

echo -e "\n\e[36mWi-Fi setup succesfully.\e[m\n"
hr

