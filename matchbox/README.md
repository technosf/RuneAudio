### matchbox-window-manager

```sh
pacman -Syu
pacman -S --needed base-devel startup-notification xsettings-client

# utilize 4 cores of cpu
sed -i 's/.*MAKEFLAGS=.*/MAKEFLAGS="-j4"/' /etc/makepkg.conf

su alarm
cd

# libmatchbox - depend
curl -O https://aur.archlinux.org/cgit/aur.git/snapshot/libmatchbox.tar.gz
bsdtar xvf libmatchbox.tar.gz
rm libmatchbox.tar.gz
cd libmatchbox

makepkg

su
pacman -U libmatchbox*.pkg.tar.xz
su alarm
cd

curl -O https://aur.archlinux.org/cgit/aur.git/snapshot/matchbox-window-manager.tar.gz
bsdtar xvf matchbox-window-manager.tar.gz
rm matchbox-window-manager.tar.gz
cd matchbox-window-manager

makepkg
```
