### matchbox-window-manager

```sh
pacman -Syu
pacman -S --needed base-devel startup-notification xsettings-client

# utilize all cpu cores
sed -i 's/.*MAKEFLAGS=.*/MAKEFLAGS="-j'$( nproc )'"/' /etc/makepkg.conf

# libmatchbox - depend
su alarm
cd
curl -O https://aur.archlinux.org/cgit/aur.git/snapshot/libmatchbox.tar.gz
bsdtar xvf libmatchbox.tar.gz
rm libmatchbox.tar.gz
cd libmatchbox

makepkg -A

su
pacman -U libmatchbox*.pkg.tar.xz

su alarm
cd
curl -O https://aur.archlinux.org/cgit/aur.git/snapshot/matchbox-window-manager.tar.gz
bsdtar xvf matchbox-window-manager.tar.gz
rm matchbox-window-manager.tar.gz
cd matchbox-window-manager

makepkg -A
```
