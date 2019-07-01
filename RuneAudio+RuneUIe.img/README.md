## RuneAudio+RuneUIe.img

### Install and upgrade
- Addons
- RuneUI Enhancement
- RuneUI Metadata Tag Editor
- RuneUI Lyrics
- Login Logo for SSH Terminal
- USB DAC Plug and Play
- MPD Upgrade
- Samba Upgrade
- NGINX Upgrade

### Setup
```sh
wget -qN --show-progress https://github.com/rern/RuneAudio/raw/master/RuneAudio%2BRuneUIe.img/setup.sh -O - | sh 
```

### Image file
**GParted**
- Unmount SD card ext4 partition
	- in Nautilus after open GParted > GParted menu > Refresh devices (avoid SD card ejected)
	- or by command line
- Resize to minimum + 50MB
- PC - Disk32 Image File > `Read only allocated partition` from SD card to `RuneAudio+RuneUIe.img`

**or**
- PC - Disk32 Image File - from SD card to `RuneAudio+RuneUIe.img`
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

### Conversion addons
- playlists, webradios, bookmarks
  
