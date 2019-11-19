### Bluetooth Audio ALSA Backend
Source: [bluealsa](https://github.com/Arkq/bluez-alsa)
```sh
pacman -Syu
pacman -S --needed base-devel bluez bluez-utils git

su alarm
curl -O https://aur.archlinux.org/cgit/aur.git/snapshot/bluez-alsa-git.tar.gz
bluez-alsa-git.tar.gz
rm bluez-alsa-git.tar.gz
cd bluez-alsa-git

sed -i -e 's/\(enable-aac\)/\1 --enable-ofono --enable-debug/
' -e "s/^arch=.*/arch=('any')/
" PKGBUILD

makepkg -A
```
