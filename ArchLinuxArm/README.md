ArchLinuxArm
---

### Desktop Linux

**Download**
```sh
# RPi 3
file=ArchLinuxARM-rpi-3-latest.tar.gz
wget http://os.archlinuxarm.org/os/$file
```

**Partition SD Card**
- **Gparted**
```sh
# primary #1   BOOT   fat32   100MB  
# primary #2   ROOT   ext4    the rest
```

**Extract files**
```sh
# install bsdtar
sudo su
apt install libarchive-tools

# extract
mkdir alarm
bsdtar xpvf $file -C alarm
rm $file

fat32=<sdcardfat32>
ext4=<sdcardext4>
rsync -v --progress alarm/boot/ /media/$fat32/
rsync -av --progress alarm/ /media/$ext4/ --exclude boot

# set root's password to "rune" and allow SSH login
sed -i 's|^root:.*$|root:\\$6\\$CPmm8tpA/CUX3u4G\$bi6hsZ.71bhybjbLob.piVwAT8dyEvhVPDACMpm0mwkMwdCSnkXsji9dzeUOxVOkObm/NAK6NacQmMheSJojn/:17513::::::|' alarm/etc/shadow
sed -i 's/#PermitRootLogin.*/PermitRootLogin yes/' alarm/etc/ssh/sshd_config
```
