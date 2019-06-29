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
wget https://github.com/rern/RuneAudio/raw/master/RuneAudio%2BRuneUIe.img/setup.sh -O - | sh 
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

# remount
losetup -a # get /dev/loopN
mount /dev/loopN /media/root
```

### Conversion addons
- playlists, webradios, bookmarks
  
