## RuneAudio+RuneUIe.img

### Install and upgrade
- Addons
- RuneUI Enhancement
- RuneUI Metadata Tag Editor
- Login Logo for SSH Terminal
- USB DAC Plug and Play
- MPD Upgrade
- Samba Upgrade
- NGINX Upgrade

## Reset
```sh
# remove special directories
rm -r /srv/http/assets/img/{bookmarks,coverarts,playlists,tmp,webradiopl,webradios}
# clear packages cache
rm /var/cache/pacman/pkg/*
# mpd database reset
rm /var/lib/mpd/* /var/lib/mpd/playlists/*
umount /dev/sda1
mpd update
# mirrorlist reset
wget https://github.com/archlinuxarm/PKGBUILDs/raw/master/core/pacman-mirrorlist/mirrorlist -P /etc/pacman.d
```

### Startup script
- expand partition
```sh
# run once script
wget https://github.com/rern/RuneAudio/raw/master/RuneAudio%2BRuneUIe.img/systemd/runonce.sh -P /root
chmod +x /root/runonce.sh
# systemd unit file
wget https://github.com/rern/RuneAudio/raw/master/RuneAudio%2BRuneUIe.img/runonce.service -P /lib/systemd/system
systemctl enable runonce
```

### Image file
- Disk32 Image File - read SD card to `read.img`
- [PiShrink](https://github.com/Drewsif/PiShrink) - shrink image file size (`-s` skip autoresize)
```sh
wget https://github.com/Drewsif/PiShrink/raw/master/pishrink.sh
chmod +x pishrink.sh
pishrink.sh -s read.img RuneAudio+RuneUIe.img
```
- Mount `RuneAudio+RuneUIe.img`
```sh
fd=$( fdisk -u -l RuneAudio+RuneUIe.img )
unitbyte=$( echo "$fd" | grep '^Units' | cut -d' ' -f8 )
start2=$( echo "$fd" | grep '\.img2' | cut -d' ' -f7 )
mkdir -p /media/root
mount -o loop,offset=$(( unitbyte * start2 )) RuneAudio+RuneUIe.img /media/root

start1=$( echo "$fd" | grep '\.img1' | cut -d' ' -f7 )
mkdir -p /media/boot
mount -o loop,offset=$(( unitbyte * start1 )) RuneAudio+RuneUIe.img /media/boot
```

### Conversion addons
	- playlists, webradios, bookmarks
  
