ArchLinuxArm
---

### Desktop Linux

**Partition SD Card**
- **Gparted**

| Type    | No. | Label | Format | Size     |
|---------|-----|-------|--------|----------|
| primary | #1  | BOOT  | fat32  | 100MB    |
| primary | #2  | ROOT  | ext4   | the rest |

**Download**
- list: http://os.archlinuxarm.org/os/
```sh
# get user
whoami

sudo su
user=<user> # from previous command

# download - RPi 3
file=ArchLinuxARM-rpi-3-latest.tar.gz
wget http://os.archlinuxarm.org/os/$file
```

### Flash SD card
```sh
# install bsdtar ("tar" will show lots of errors.)
apt install bsdtar

# extract
bsdtar xpvf $file -C /media/$user/ROOT
cp -r --no-preserve=mode,ownership /media/$user/ROOT/boot/* /media/$user/BOOT
rm -r /media/$user/ROOT/boot/*
```

### Boot
- SCP/SSH with user|password : alarm|alarm
```sh
# set root's password to "rune"
su root # root's password: root
passwd

# permit root SSH login
sed -i 's/#PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config
systemctl reload sshd

# if keyring error, temporarily disable keyring
sed -i '/^SigLevel/ s/^/#/; a\SigLevel    = TrustAll' /etc/pacman.conf
```
