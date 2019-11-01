### Wi-Fi Setup for Headless System
- No need to connect monitor/TV and keyboard
- Pre-configure before boot:
	- SSID
	- Password
	- Security (WPA/WEP/none)
	
- On Linux PC: (Filesystem 'root' partition must be labeled as ROOT)
```sh
# switch user to root
su -

# get setup script
wget https://github.com/rern/RuneAudio/raw/master/wifi_setup/wifisetup.sh
chmod +x wifisetup.sh
./wifisetup.sh

# remove when done
rm wifisetup.sh
```
