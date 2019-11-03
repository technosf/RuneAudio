### Wi-Fi Setup for Headless System
- No need to connect monitor/TV and keyboard
- Pre-configure before boot:
	- SSID
	- Password
	- Security (WPA/WEP/none)
	
- On Linux PC:
	- Insert micro SD card (or USB drive with ROOT partition)
	- Filesystem 'root' partition must be labeled as ROOT
	- Open **Files** app - click `ROOT` to mount
	- Hover mouse over `ROOT` and note the path
```sh
# switch user to root
su -

# get setup script
wget -qN --show-progress https://github.com/rern/RuneAudio/raw/master/wifi_setup/wifisetup.sh
chmod +x wifisetup.sh
./wifisetup.sh

# remove when done
rm wifisetup.sh
```
