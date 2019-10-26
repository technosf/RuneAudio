### Bluetooth Audio ALSA Backend
[bluealsa](https://github.com/Arkq/bluez-alsa)
```sh
pacman -Sy --needed base-devel bluez bluez-utils git

su alarm
wget https://aur.archlinux.org/cgit/aur.git/snapshot/bluez-alsa-git.tar.gz
bluez-alsa-git.tar.gz
rm bluez-alsa-git.tar.gz
cd bluez-alsa-git

../configure --enable-aac --enable-ofono --enable-debug

makepkg -A
```
