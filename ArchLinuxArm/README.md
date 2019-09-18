ArchLinuxArm
---

### Desktop Linux

**Download**
```sh
# RPi 3 (not for compiling)
wget http://os.archlinuxarm.org/os/ArchLinuxARM-rpi-3-latest.tar.gz
# RPi 2
wget http://os.archlinuxarm.org/os/ArchLinuxARM-rpi-2-latest.tar.gz
```

**Partition SD Card**
- **Gparted**: unmount > partition > format
```sh
# primary #1  BOOT   fat32   100MB  
# primary #2   ROOT   ext4    the rest
```

**Extract files**
```sh
# bsdtar
apt-cache policy bsdtar
	# version 3.3+
apt install bsdtar
	# otherwise make install
file=libarchive-N.N.N.tar.gz
wget https://www.libarchive.org/downloads/$file
tar xzf $file
cd ${file/.tar.gz}
./configure
make
sudo make install

# extract
bsdtar xpvf ArchLinuxARM-rpi-3-latest.tar.gz -C /media/x/ROOT

cp -r --no-preserve=mode,ownership /media/x/ROOT/boot/* /media/x/BOOT
rm -r /media/x/ROOT/boot/*

# set root's password to "rune" and allow SSH login
sed -i 's/^root:.*$/root:$6$CPmm8tpA/CUX3u4G$bi6hsZ.71bhybjbLob.piVwAT8dyEvhVPDACMpm0mwkMwdCSnkXsji9dzeUOxVOkObm/NAK6NacQmMheSJojn/:17513::::::/' /etc/shadow
sed -i 's/#PermitRootLogin.*/PermitRootLogin yes/' /media/x/ROOT/etc/ssh/sshd_config
```
