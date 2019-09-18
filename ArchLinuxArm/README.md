ArchLinuxArm
---

### Desktop Linux

**Download**
- list: http://os.archlinuxarm.org/os/
```sh
# RPi 3
file=ArchLinuxARM-rpi-3-latest.tar.gz
wget http://os.archlinuxarm.org/os/$file
```

**Partition SD Card**
- **Gparted**

| Type    | No. | Label | Format | Size     |
|---------|-----|-------|--------|----------|
| primary | #1  | BOOT  | fat32  | 100MB    |
| primary | #2  | ROOT  | ext4   | the rest |

**Create SD card**
```sh
# install bsdtar
sudo su
apt install libarchive-tools

# extract
mkdir alarm
bsdtar xpvf $file -C alarm
rm $file

# copy files to SD card
user=<username>
cp -rv alarm/boot/* /media/$user/BOOT
rsync -av --progress alarm/ /media/$user/ROOT/ --exclude boot

# after initial boot, set root's password to "rune" and allow SSH login
# root's password: root
su root
sed -i 's|^root:.*$|root:\\$6\\$CPmm8tpA/CUX3u4G\$bi6hsZ.71bhybjbLob.piVwAT8dyEvhVPDACMpm0mwkMwdCSnkXsji9dzeUOxVOkObm/NAK6NacQmMheSJojn/:17513::::::|' /etc/shadow
sed -i 's/#PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config
```
