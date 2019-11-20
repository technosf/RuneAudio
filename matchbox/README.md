### matchbox-window-manager

```sh
pacman -Syu
pacman -S --needed base-devel startup-notification xsettings-client
su alarm
cd

# download snapshot
curl -O https://aur.archlinux.org/cgit/aur.git/snapshot/libmatchbox.tar.gz
bsdtar xvf libmatchbox.tar.gz
rm libmatchbox.tar.gz
cd libmatchbox

sed -i "s/^arch=.*/arch=('any')/" PKGBUILD

makepkg

su
pacman -U libmatchbox-*-any.pkg.tar.xz
su alarm

curl -O https://aur.archlinux.org/cgit/aur.git/snapshot/matchbox-window-manager.tar.gz
bsdtar xvf matchbox-window-manager.tar.gz
rm matchbox-window-manager.tar.gz
cd matchbox-window-manager

sed -i "s/^arch=.*/arch=('any')/" PKGBUILD

makepkg
```
