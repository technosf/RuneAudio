## RuneAudio+RuneUIe.img

### Upgrade
- MPD 0.21.10
- Samba 4.10.5
- NGINX 1.16.0

## Reset
```sh
# mirrorlist reset
wget https://github.com/archlinuxarm/PKGBUILDs/raw/master/core/pacman-mirrorlist/mirrorlist -P /etc/pacman.d
# remove special directories
rm -r /srv/http/assets/img/{bookmarks,coverarts,playlists,webradios,webradiopl,tmp}
# clear packages cache
rm /var/cache/pacman/pkg/*
# mpd database reset
rm /var/lib/mpd/* /var/lib/mpd/playlists/*
umount /dev/sda1
mpd update
```

### Startup script
- expand partition
```sh
# fdisk script
wget https://github.com/rern/RuneAudio/raw/master/RuneAudio%2BRuneUIe.img/systemd/expand.sh -P /root
chmod +x /root/expand.sh
# systemd unit file
wget https://github.com/rern/RuneAudio/raw/master/RuneAudio%2BRuneUIe.img/expand.service -P /lib/systemd
systemctl enable expand
# install parted
pacman -Sy parted
# makeDirLink
. /srv/http/addonstitle.sh
makeDirLink coverarts
makeDirLink bookmarks
makeDirLink playlists
makeDirLink tmp
makeDirLink webradiopl
makeDirLink webradios
# update mpd database
mpd update
/srv/http/enhancecount.sh
```

### Image file
- Disk32 Image File - read SD card to `read.img`
- [PiShrink](https://github.com/Drewsif/PiShrink) - shrink image file size (`-s` skip autoresize)
```sh
wget https://github.com/Drewsif/PiShrink/raw/master/pishrink.sh
chmod +x pishrink.sh
pishrink.sh -s read.img RuneAudio+RuneUIe.img
```
	
### Conversion addons
	- playlists, webradios, bookmarks
  
