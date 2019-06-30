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
wget https://github.com/rern/RuneAudio/raw/master/RuneAudio%2BRuneUIe.img/mountimg.sh
chmod +x mountimg.sh

# root
./mountimg.sh RuneAudio+RuneUIe.img

# /boot
./mountimg.sh RuneAudio+RuneUIe.img 1
```

### Conversion addons
- playlists, webradios, bookmarks
  
