## RuneAudio+RuneUIe.img

### Before install
- `/dev` page > `gitpull` to update RuneUI > auto reboot
- Edit `IgnorePkg` in `/etc/pacman.conf`
- Silent boot
```sh
sed -i -e 's/\(disable_splash=\)0/\11/' /boot/config.txt
cat << 'EOF' > /boot/cmdline.txt
root=/dev/mmcblk0p2 rw rootwait console=ttyAMA0,115200 console=tty3 selinux=0 plymouth.enable=0 fsck.repair=yes smsc95xx.turbo_mode=N dwc_otg.lpm_enable=0 kgdboc=ttyAMA0,115200 elevator=noop quiet loglevel=0 logo.nologo vt.global_cursor_default=0
EOF
```
- Fixes
```sh
# readlind and icu - icu upgrade also upgrade Chromium but has to be purged - reinstalled
pacman -Sy
pkg=$( pacman -Qi readline | grep '^Required By' | cut -d':' -f2 )
pacman -S --needed $pkg awk readline nettle wget

# fix - php-fpm
ln -s /lib/libreadline.so.{8.0,7}

pkg=$( pacman -Qi icu | grep '^Required By' | cut -d':' -f2 )
pacman -S --needed $pkg icu

# fix - hostapd, alsa webui
systemctl disable hostapd amixer-webui
rm -r /usr/share/amixer-webui

# fix - pip
pacman -Rdd python-pip python
pacman -S python2 python-pip
ln -s /usr/bin/python{2.7,}
ln -s /usr/bin/pip{2.7,}

# upgrades
rm /etc/shairport-sync.conf \
	/usr/bin/shairport-sync \
	/usr/lib/systemd/system/shairport-sync.service
file=shairport-sync-3.3.1-1-armv7h.pkg.tar.xz
wget -qN https://github.com/rern/RuneAudio/raw/master/shairport-sync/$file
pacman -U $file
rm $file

pacman -S hostapd ifplugd dnsmasq
```

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
- Chromium Upgrade

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
  
