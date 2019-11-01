### Wi-Fi Setup for Headless system
- Pre-configure before boot
- No need to connect monitor/TV and keyboard
- On Linux PC:
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
