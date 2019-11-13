### matchbox-window-manager

```sh
pacman -Sy --needed base-devel
su alarm
cd

# download snapshot
wget https://aur.archlinux.org/cgit/aur.git/snapshot/matchbox-window-manager.tar.gz
bsdtar xvf matchbox-window-manager.tar.gz
rm matchbox-window-manager.tar.gz
cd matchbox-window-manager

sed -i "s/^arch=.*/arch=('any')/" PKGBUILD

makepkg -A
```
