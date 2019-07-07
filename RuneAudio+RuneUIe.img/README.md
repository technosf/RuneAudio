## RuneAudio+RuneUIe.img

### Before install
- `/dev` page > `gitpull` to update RuneUI > auto reboot
- Fix `readline` and `icu`
```sh
pacman -Sy
pkg=$( pacman -Qi readline | grep '^Required By' | cut -d':' -f2 )
pacman -S --needed $pkg awk readline
pkg=$( pacman -Qi icu | grep '^Required By' | cut -d':' -f2 )
pacman -S --needed $pkg icu
```
- Remove Chromium, install Midori

### Install and upgrade
- Addons
- RuneUI Enhancement
	- Enable for initial setup: accesspoint and local browser
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
- Midori Upgrade
```sh
pacman -S midori
sed -i -e '/chromium/ s/^/#/
' -e '/midori/ s/^#//
' /etc/X11/xinit/xinitrc
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
  
