## RuneAudio+RuneUIe.img

### Before install
- Fix access point startup failed - `systemctl disable hostapd`
- Connect WiFi (result - none connected, fixed by reboot in next step)
- `/dev` page > `gitpull` to update RuneUI > auto reboot
- Verify connected WiFi
- Delete `test` profile: `rm /etc/netctl/test`
- `Disconnect-Delete` connected WiFi

### Install and upgrade
- Addons
- RuneUI Enhancement
	- Enable only Accesspoint for initial setup through WiFi
- RuneUI Metadata Tag Editor
- RuneUI Lyrics
- Login Logo for SSH Terminal
- USB DAC Plug and Play
- MPD Upgrade
- Samba Upgrade
- NGINX Upgrade
```sh
wget -qN --show-progress https://github.com/rern/RuneAudio/raw/master/nginx/install.sh -O - | sh 
```

### Setup SD card to common state
```sh
wget -qN --show-progress https://github.com/rern/RuneAudio/raw/master/RuneAudio%2BRuneUIe.img/setup.sh -O - | sh 
```

### Image file
**GParted**
- Unmount SD card ext4 partition
	- in **Nautilus** after open **GParted** > GParted menu > Refresh devices (avoid SD card ejected)
	- or by command line
- Resize to minimum + 50MB
- **Win32 Disk Imager** > `Read only allocated partition` from SD card to `RuneAudio+RuneUIe.img`

**or**
- **Win32 Disk Imager** - from SD card to `RuneAudio+RuneUIe.img`
- Shrink image file
```sh
wget -qN --show-progress https://github.com/rern/RuneAudio/raw/master/RuneAudio%2BRuneUIe.img/shrinkimg.sh
chmod +x shrinkimg.sh
./shrinkimg.sh RuneAudio+RuneUIe.img
```

## In-place edit image file
```sh
wget -qN --show-progress https://github.com/rern/RuneAudio/raw/master/RuneAudio%2BRuneUIe.img/mountimg.sh
chmod +x mountimg.sh

# root
./mountimg.sh RuneAudio+RuneUIe.img

# boot ( /boot )
./mountimg.sh RuneAudio+RuneUIe.img 1

# umount
umount /media/root
umount /media/boot
kpartx -dv RuneAudio+RuneUIe.img
```
  
