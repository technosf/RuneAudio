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
wget https://github.com/rern/RuneAudio/raw/master/RuneAudio%2BRuneUIe.img/runonce.service -P /etc/systemd/system
systemctl enable runonce
```

### Image file
- Windows: Disk32 Image File - read SD card to `RuneAudio+RuneUIe.img`
```sh
wget https://github.com/rern/RuneAudio/raw/master/RuneAudio%2BRuneUIe.img/shrinkimg.sh
chmod +x shrinkimg.sh
./shrinkimg.sh RuneAudio+RuneUIe.img
```
- Mount `RuneAudio+RuneUIe.img` for editing
```sh
# root
fd=$( fdisk -lo Start RuneAudio+RuneUIe.img )
unitbyte=$( echo "$fd" | grep '^Units' | cut -d' ' -f8 )
start2=$( echo "$fd" | tail -1 )
mkdir -p /media/root
mount -o loop,offset=$(( unitbyte * start2 )) RuneAudio+RuneUIe.img /media/root
# boot
start1=$( echo "$fd" | tail -2 | head -1 )
mkdir -p /media/boot
mount -o loop,offset=$(( unitbyte * start1 )) RuneAudio+RuneUIe.img /media/boot

# get /dev/loopN
losetup -a

# unmount
losetup -d /dev/loopN

# remount
mount /dev/loopN /media/root
```

### Conversion addons
- playlists, webradios, bookmarks
  
